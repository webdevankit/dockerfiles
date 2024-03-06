# Use a base image with Apache and PHP already installed
FROM php:7.4-apache

# Install required dependencies
RUN apt-get update && apt-get install -y \
    vim \
    net-tools \
    curl \
    libmcrypt-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libpq-dev \
    libbz2-dev \
    libldap2-dev \
    libssl-dev \
    libc-client-dev \
    libkrb5-dev \
    libxml2-dev \
    libxslt-dev \
    libgmp-dev \
    libzip-dev \
    libmemcached-dev \
    && rm -r /var/lib/apt/lists/* \
    && apt-get clean

# Install memcached PHP extension
RUN pecl install memcached-3.1.5

# Configure and install GD extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap
# Install other PHP extensions
RUN docker-php-ext-install -j$(nproc) \
    mysqli \
    pdo \
    pdo_mysql \
    pgsql \
    pdo_pgsql \
    exif \
    bcmath \
    bz2 \
    ldap \
    calendar \
    dba \
    gettext \
    pcntl \
    shmop \
    soap \
    sockets \
    sysvsem \
    sysvshm \
    xmlrpc \
    xsl \
    zip \
    intl

# Enable memcached PHP extension
RUN docker-php-ext-enable memcached

# Create a symbolic link for GMP header file
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

