-- users
create table
  public.users (
    user_id bigint generated by default as identity,
    time timestamp with time zone not null default (now() at time zone 'utc'::text),
    name text not null,
    constraint user_pkey primary key (user_id),
    constraint users_name_key unique (name),
    constraint users_name_check check ((length(name) <= 100))
  ) tablespace pg_default;

-- animals
create table
  public.animals (
    animal_id bigint generated by default as identity,
    time timestamp with time zone not null default (now() at time zone 'utc'::text),
    name text not null,
    attack integer not null default 0,
    defense integer not null default 0,
    price integer not null default 0,
    in_use boolean not null default false,
    constraint animal_pkey primary key (animal_id),
    constraint animals_attack_check check (
      (
        (attack >= '-1'::integer)
        and (attack <= 81)
      )
    ),
    constraint animals_defense_check check (
      (
        (defense >= '-1'::integer)
        and (defense <= 81)
      )
    ),
    constraint animals_name_check check ((length(name) <= 100))
  ) tablespace pg_default;

-- animals_owned
create table
  public.animals_owned (
    inventory_id bigint generated by default as identity,
    user_id bigint null,
    animal_id bigint null,
    constraint animals_owned_pkey primary key (inventory_id),
    constraint animals_owned_animal_id_fkey foreign key (animal_id) references animals (animal_id),
    constraint animals_owned_user_id_fkey foreign key (user_id) references users (user_id)
  ) tablespace pg_default;

-- transactions
create table
  public.transactions (
    transaction_id bigint generated by default as identity,
    time timestamp with time zone not null default (now() at time zone 'utc'::text),
    gold integer not null default 0,
    description text not null,
    user_id bigint null,
    animal_id bigint null,
    health integer not null default 0,
    constraint transactions_pkey primary key (transaction_id),
    constraint transactions_animal_id_fkey foreign key (animal_id) references animals (animal_id),
    constraint transactions_user_id_fkey foreign key (user_id) references users (user_id)
  ) tablespace pg_default;

-- enemies
create table
  public.enemies (
    enemy_id bigint generated by default as identity,
    time timestamp with time zone not null default (now() at time zone 'utc'::text),
    name text not null,
    attack integer not null default 0,
    defense integer not null default 0,
    constraint enemy_pkey primary key (enemy_id)
  ) tablespace pg_default;

-- fights
create table
  public.fights (
    fight_id bigint generated by default as identity,
    time timestamp with time zone not null default (now() at time zone 'utc'::text),
    animal_id bigint not null,
    user_id bigint not null,
    enemy_id bigint not null,
    transaction_id integer not null,
    outcome boolean not null,
    constraint fight_pkey primary key (fight_id),
    constraint fight_animal_id_fkey foreign key (animal_id) references animals (animal_id),
    constraint fight_enemy_id_fkey foreign key (enemy_id) references enemies (enemy_id),
    constraint fight_user_id_fkey foreign key (user_id) references users (user_id),
    constraint fights_transaction_id_fkey foreign key (transaction_id) references transactions (transaction_id)
  ) tablespace pg_default;

-- INSERT statements

-- animals
INSERT INTO animals (animal_id, name, attack, defense, price) VALUES (1, 'FeeFee', 45, 30, 40);
INSERT INTO animals (animal_id, name, attack, defense, price) VALUES (2, 'Kiwi', 50, 40, 60);

-- enemies
INSERT INTO enemies (name, attack, defense) VALUES ('Gollum', 60, 15);
INSERT INTO enemies (name, attack, defense) VALUES ('FEELTH', 37, 56);
INSERT INTO enemies (name, attack, defense) VALUES ('GARY', 73, 20);
INSERT INTO enemies (name, attack, defense) VALUES ('MiniMooBAMBA', 20, 70);
INSERT INTO enemies (name, attack, defense) VALUES ('Mid', 50, 50);

-- transactions
INSERT INTO transactions (description, animal_id, health) VALUES ('created animal FeeFee', 1, 100);
INSERT INTO transactions (description, animal_id, health) VALUES ('created animal Kiwi', 2, 100);
