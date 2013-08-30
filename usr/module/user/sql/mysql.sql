# Pi Engine schema
# http://pialog.org
# Author: Taiwen Jiang <taiwenjiang@tsinghua.org.cn>
# --------------------------------------------------------

# ------------------------------------------------------
# User
# >>>>

# Entity meta for custom user profile fields
CREATE TABLE `{profile}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  -- Custom profile field
  `field`           varchar(64)     NOT NULL,
  `value`           text,

  PRIMARY KEY  (`id`),
  UNIQUE KEY  `field` (`uid`, `field`)
);

# Entity for user profile compound fields
CREATE TABLE `{compound}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  -- Compound name, stored in table `field`
  `compound`        varchar(64)     NOT NULL,
  -- Field set key, integer
  `set`             smallint(5)     unsigned    NOT NULL default '0',
  -- Compound field name, stored in table `compound_field`
  `field`           varchar(64)     NOT NULL,
  `value`           text,

  PRIMARY KEY  (`id`),
  UNIQUE KEY  `field` (`uid`, `compound`, `set`, `field`)
);

# Entity meta for all profile fields: account, basic profile and custom fields
CREATE TABLE `{field}` (
  `id`              smallint(5)     unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL,
  `module`          varchar(64)     NOT NULL default '',
  `title`           varchar(255)    NOT NULL default '',
  -- Specs for edit form element, filters and validators, encoded with json
  `edit`            text,
  -- Filter for display value
  `filter`          text,

  -- Field type, default as 'custom'
  `type`            enum('custom', 'account', 'profile', 'compound'),

  -- Is editable by user
  `is_edit`         tinyint(1)      unsigned NOT NULL default '0',
  -- Is capable for searching user
  `is_search`       tinyint(1)      unsigned NOT NULL default '0',
  -- Available for display
  `is_display`      tinyint(1)      unsigned NOT NULL default '0',

  -- Available, usually set by module activation/deactivation
  `active`          tinyint(1)      unsigned NOT NULL default '0',

  PRIMARY KEY  (`id`),
  UNIQUE KEY  `name` (`name`)
);

# Entity meta for compound fields
CREATE TABLE `{compound_field}` (
  `id`              smallint(5)     unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL,
  `compound`        varchar(64)     NOT NULL,
  `module`          varchar(64)     NOT NULL default '',
  `title`           varchar(255)    NOT NULL default '',

  `edit`            text,
  `filter`          text,

  PRIMARY KEY  (`id`),
  UNIQUE KEY  `name` (`compound`, `name`)
);

# Display group for profile fields
CREATE TABLE `{display_group}` (
  `id`            int(10) unsigned        NOT NULL auto_increment,
  `name`          varchar(64)             NOT NULL default '',
  `title`         varchar(255)            NOT NULL default '',
  `order`         smallint(5) unsigned    NOT NULL default '0',
  -- Compound name;
  `compound`      varchar(64)     default NULL,

  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
);

# Display grouping and order of field
CREATE TABLE `{field_display}` (
  `id`         int(10) unsigned         NOT NULL auto_increment,
  -- Profile field name;
  -- Or compound field name if `compound` is specified in table 'display_group'
  `field`      varchar(64)              NOT NULL default '',
  `group`      varchar(64)              NOT NULL default '',
  `order`      smallint(5) unsigned     NOT NULL default '0',

  PRIMARY KEY (`id`)
);

# Timeline meta
CREATE TABLE `{timeline}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL    default '',
  `title`           varchar(255)    NOT NULL    default '',
  `module`          varchar(64)     NOT NULL    default '',
  `icon`            varchar(255)    NOT NULL    default '',
  `active`          tinyint(1)      NOT NULL    default '0',

  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
);

# Activity meta
CREATE TABLE `{activity}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL    default '',
  `title`           varchar(255)    NOT NULL    default '',
  `description`     text,
  `module`          varchar(64)     NOT NULL    default '',
  -- Link to 'Get more'
  `link`            varchar(255)    NOT NULL    default '',
  `icon`            varchar(255)    NOT NULL    default '',
  `active`          tinyint(1)      unsigned    NOT NULL    default '0',
  -- Display order, '0' for hidden
  `display`         smallint(5)     unsigned    NOT NULL    default '0',

  -- Callback to get user activity messages
  `callback`        varchar(64)     NOT NULL,

  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
);

# Quicklinks
CREATE TABLE `{quicklink}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `name`            varchar(64)     NOT NULL    default '',
  `title`           varchar(255)    NOT NULL    default '',
  `module`          varchar(64)     NOT NULL    default '',
  `link`            varchar(255)    NOT NULL    default '',
  `icon`            varchar(255)    NOT NULL    default '',
  `active`          tinyint(1)      unsigned NOT NULL    default '0',
  -- Display order, '0' for hidden
  `display`         smallint(5)     unsigned    NOT NULL    default '0',

  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
);

# Timeline for user activities
CREATE TABLE `{timeline_log}` (
  `id`              int(10)         unsigned    NOT NULL    auto_increment,
  `uid`             int(10)         unsigned    NOT NULL,
  -- Timeline name, defined in table `timeline`
  `timeline`        varchar(64)     NOT NULL    default '',
  `module`          varchar(64)     NOT NULL    default '',
  `message`         text,
  `link`            varchar(255)    NOT NULL    default '',
  `time`            int(11)         unsigned    NOT NULL,

  PRIMARY KEY  (`id`),
  KEY (`uid`)
);

#Privacy control
CREATE TABLE `{privacy}` (
  `id`        int(10)              unsigned NOT NULL auto_increment,
  `uid`       int(10)              unsigned NOT NULL,
  `name`      varchar(64)          NOT NULL default '',
  `value`     varchar(64)          NOT NULL default '',
  `visitor`   varchar(64)          NOT NULL default '',

  PRIMARY KEY (`id`)
);

#Privacy field controller
CREATE TABLE `{privacy_field}` (
  `id`        int(10)              unsigned NOT NULL auto_increment,
  `name`      varchar(64)          NOT NULL default '',
  `value`     varchar(64)          NOT NULL default '',
  `force`     tinyint(1)           NOT NULL default '0',
  `visible`   tinyint(1)           NOT NULL default '0',

  PRIMARY KEY (`id`)
);

# User action log generated for user module
CREATE TABLE `{log}` (
  `id`              int(10)             unsigned NOT NULL auto_increment,
  `uid`             int(10)             unsigned NOT NULL,
  `time`            int(10)             unsigned NOT NULL default '0',
  `data`            varchar(255)        NOT NULL default '',
  `action`          varchar(64)         NOT NULL default '',

  PRIMARY KEY (`id`),
  KEY (`uid`)
);