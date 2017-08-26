FROM whw3/rpi-s6

ENV OPENLDAP_VERSION 2.4.40
ENV DEBUG_LEVEL 32768

RUN apt-get update && apt-get upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        slapd=${OPENLDAP_VERSION}* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mv /etc/ldap /etc/ldap.dist

COPY modules/ /etc/ldap.dist/modules

COPY entrypoint.sh /entrypoint.sh

EXPOSE 389

VOLUME ["/etc/ldap", "/var/lib/ldap"]

ENTRYPOINT ["/init"]

CMD ["sh", "-c", "slapd -d ${DEBUG_LEVEL} -u openldap -g openldap"]

