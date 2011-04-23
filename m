From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: FW: [PATCH] iscsiadm: Add netconfig support in iscsiadm and iscsid
Date: Fri, 22 Apr 2011 21:24:15 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728AB02FEF@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:18151
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930Ab1DWEYj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Apr 2011 00:24:39 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>

Added open-iscsi group is CC list.

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

1. Current status:
Using iscsiadm one cannot do any network configuration for qla4xxx adapters.
However an iface is created for the qla4xxx ports using the hwaddress.

\# ls /etc/iscsi/ifaces/
iface.example  iface0  qla4xxx.00:0e:1e:04:8b:2a  qla4xxx.00:0e:1e:04:8b:2e

This allows user to issue sendtargets via the qla4xxx iscsi offload.

2. Current Proposal:
Current proposal is to allow iscsiadm to configure the network settings for qla4xxx ports.

This implementation is based on discussions at
http://marc.info/?l=linux-scsi&m=127066184916180&w=2
http://groups.google.com/group/open-iscsi/browse_thread/thread/d8e8c2df71c95d69/8f731d95d46141a0?lnk=gst&q=iscsi+hba#

2.1 Changes in iscsiadm/iscsid

2.1.1 Add a new event: ISCSI_UEVENT_SET_NET_CONFIG

2.1.2 New structure to represent a single network parameter
/* iSCSI network params */
enum iscsi_net_param_type {
        ISCSI_NET_PARAM_IPV4_ADDR               = 1,
        ISCSI_NET_PARAM_IPV4_SUBNET             = 2,
        ISCSI_NET_PARAM_IPV4_GW                 = 3,
        ISCSI_NET_PARAM_IPV4_BOOTPROTO          = 4,
        ISCSI_NET_PARAM_MAC                     = 5,
        ISCSI_NET_PARAM_IPV6_LINKLOCAL          = 6,
        ISCSI_NET_PARAM_IPV6_ADDR               = 7,
        ISCSI_NET_PARAM_IPV6_ROUTER             = 8,
        ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG       = 9,
        ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG  = 10,
        ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG     = 11,
        ISCSI_NET_PARAM_IFACE_ENABLED           = 12,
        ISCSI_NET_PARAM_VLAN                    = 13,
};

struct iscsi_net_param {
        uint32_t param_type;    /* enum iscsi_net_param */
        uint32_t iface_type;    /* IPv4 or IPv6 */
        uint32_t iface_num;     /* iface number, 0 - n */
        uint32_t length;        /* Actual length of the param */
        uint8_t value[0];       /* length sized value follows */
} __attribute__((packed));

2.1.3 New parameters in iface
Added following params:-

typedef struct iface_rec {
        struct list_head        list;
        /* iscsi iface record name */
        char                    name[ISCSI_MAX_IFACE_LEN];
+       uint32_t                iface_num;
        /* network layer iface name (eth0) */
        char                    netdev[IFNAMSIZ];
        char                    ipaddress[NI_MAXHOST];
+       char                    subnet_mask[NI_MAXHOST];
+       char                    gateway[NI_MAXHOST];
+       char                    bootproto[ISCSI_MAX_STR_LEN];
+       char                    ipv6_linklocal[NI_MAXHOST];
+       char                    ipv6_router[NI_MAXHOST];
+       char                    ipv6_autocfg[NI_MAXHOST];
+       char                    linklocal_autocfg[NI_MAXHOST];
+       char                    router_autocfg[NI_MAXHOST];
+       char                    vlan[ISCSI_MAX_STR_LEN];
+       char                    state[ISCSI_MAX_STR_LEN]; /* 0 = disable,
+                                                          * 1 = enable */

2.1.4 Change in operations
Add two new operations to iscsiadm
apply: Apply the single iface settings
applyall: Apply the iface settings of all iface having the same MAC address

2.2 Changes in sysfs network representation
The new sysfs directory would look like this:-
/sys/class/iscsi_iface/
|
|- ipv4-iface-<host_no>-<iface_no>/                             <-- for ipv4
                                |- ipaddress
                                |- subnet
                                |- gateway
                                |- bootproto
                                |- enabled
|- ipv6-iface-<host_no>-<iface_no>/                             <-- for ipv6
                                |- ipaddress
                                |- link_local_addr
                                |- router_addr
                                |- ipaddr_autocfg
                                |- linklocal_autocfg
                                |- enabled

3. Flow:
3.1 User space code:
            - If user specify --op=update, then just update the iface config file
            - If use specify --op=applyall then read ifaces having the same hwaddress
              and build up the net config buffer.
            - Note: If --op is "apply" then only settings for single iface is read,
              the iface provided with -I option is only read.
            - The net config buffer will look like this.
        ----------------------------------------------------------------|
        | iscsi_net_param {                                             |
        |  param = ISCSI_NET_PARAM_IPV4_ADDR;                           |
        |  iface_num = 0;                                               |
        |  length = 4                                                   |
        |  offset = 0;                                                  |
        |  value[0] = ipaddress[0];                                     |
        |  value[1] = ipaddress[1];                                     |
        |  value[2] = ipaddress[2];                                     |
        |  value[3] = ipaddress[3];                                     |
        | }                                                             |
        ----------------------------------------------------------------|
        |  iscsi_net_param {                                            |
        |  param = ISCSI_NET_PARAM_IPV4_GW;                             |
        |  iface_num = 0;                                               |
        |  length = 4                                                   |
        |  offset = 0;                                                  |
        |  value[0] = ipgateway[0];                                     |
        |  value[1] = ipgateway[1];                                     |
        |  value[2] = ipgateway[2];                                     |
        |  value[3] = ipgateway[3];                                     |
        | }                                                             |
        -----------------------------------------------------------------
        |                                                               |
        | iscsi_net_param {                                             |
        |  param = ISCSI_NET_PARAM_IPV4_ADDR;                           |
        |  iface_num = 1;                                               |
        |  length = 4                                                   |
        |  offset = 0;                                                  |
        |  value[0] = ipaddress[0];                                     |
        |  value[1] = ipaddress[1];                                     |
        |  value[2] = ipaddress[2];                                     |
        |  value[3] = ipaddress[3];                                     |
        | }                                                             |
        -----------------------------------------------------------------
        | iscsi_net_param {                                             |
        |  param = ISCSI_NET_PARAM_IPV4_GW;                             |
        |  iface_num = 1;                                               |
        |  length = 4                                                   |
        |  offset = 0;                                                  |
        |  value[0] = ipgateway[0];                                     |
        |  value[1] = ipgateway[1];                                     |
        |  value[2] = ipgateway[2];                                     |
        |  value[3] = ipgateway[3];                                     |
        | }                                                             |
        -----------------------------------------------------------------
        | iscsi_net_param {                                             |
        |  param = ISCSI_NET_PARAM_IFACE_ENABLED;                       |
        |  iface_num = 1;                                               |
        |  length = 1                                                   |
        |  offset = 0;                                                  |
        |  value[0] = 0; /* 0 = disable, default = 1 = enable           |
        | }                                                             |
        -----------------------------------------------------------------

Each netconfig parameter has different size requirement for value field.

e.g.: IPv4 address requires 4 bytes, IPv6 address requires 16 bytes etc.

        The memory allocated for each netconfig parameter is size of
        iscsi_net_param + length required for that parameter.

        The multiple IO Vector mechanism is used to send netconfig
        parameter from user space to kernel using Netlink interface.

        IO Vector 0 is used for Netlink message header.

        IO Vector 1 is used for iSCSI User Event (ev).
        - The ev will be sent down with event type = ISCSI_UEVENT_SET_NET_CONFIG

        IO Vector 2 onwards, each vector consists of the struct iscsi_net_param
        with parameter name followed by its value.

        The total size will be addition of all the IO vector sizes.

3.2 Kernel space code:
        - Once event is received, the buffer will look like struct iscsi_net_param
          with parameter name followed by its value, then next parameter and
          its value and so on.
        - the scsi_transport_iscsi would call the adapter's transport->set_net_config
        - In set_net_config each individual param can be decoded and set into the
          hardware.

4. qla4xxx configuration:
        iscsid, creates the iface for qla4xxx, based on the hwaddress. To display
        the iface related to qla4xxx execute following
           # iscsiadm -m iface
               qla4xxx.00:0e:1e:04:8b:2e qla4xxx,00:0e:1e:04:8b:2e,<empty>,<empty>,<empty>
               qla4xxx.00:0e:1e:04:8b:2e.ipv6 qla4xxx,00:0e:1e:04:8b:2e,<empty>,<empty>,<empty>
               qla4xxx.00:0e:1e:04:8b:2a qla4xxx,00:0e:1e:04:8b:2a,20.15.0.66,<empty>,<empty>
               qla4xxx.00:0e:1e:04:8b:2a.ipv6
               qla4xxx,00:0e:1e:04:8b:2a,2001:DB8:1111:2222::8888,<empty>,<empty>
               qla4xxx.00:0e:1e:04:8b:2a.ipv6.1
               qla4xxx,00:0e:1e:04:8b:2a,2001:DB8:4444:5555::9999,<empty>,<empty>

To setup network configuration there can be two methods
4. 1. User can manually modify the iface file, and issue an "apply" command.
---------------------------------------------------------------------------
iface.example  iface0  qla4xxx.00:0e:1e:04:8b:2a  qla4xxx.00:0e:1e:04:8b:2e

            Example:
            iface.ipaddress = 192.168.2.2 (decimal)
            iface.iface_num = 0 (default)
            iface.subnetmask = 255.255.255.0 (decimal)
            iface.vlan = 0x1022 (hex)

            # vi qla4xxx.00:0e:1e:04:8b:2a.ipv6
            If file does not exist, the one can create it.
            iface.ipaddress =  1111:2222::7777:8888 (hex)
            iface.iface_num = 0
            iface.vlan = 0x1022 (hex)

            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a --op=applyall
            This will read the iface config file and apply the settings to the
            hardware.
            Note, this will read all the iface belonging to the same MAC address.

4.2. User can use iscsiadm to specify the values and then apply
--------------------------------------------------------------
            # ls /etc/iscsi/ifaces/
iface.example  iface0  qla4xxx.00:0e:1e:04:8b:2a  qla4xxx.00:0e:1e:04:8b:2e
            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
               -n iface.ipaddress -v 192.168.1.2
            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
                           -n iface.gateway -v 192.168.1.1
            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
                           -n iface.subnet_mask -v 255.255.255.0
            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o applyall

            Setting up multiple IP:
            First interface (default, no need to set iface_num, it is 0 by default)
            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
                           -n iface.ipaddress -v 192.168.1.2
            Create the second one if it does not exist
            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a.1 -op=new
            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
                           -n iface.iface_num -v 1 (Mandatory)
            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
                           -n iface.ipaddress -v 192.168.1.3
            # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a --op=applyall

            Note: If there are common settings for multiple interfaces then the
            settings from 0th iface would be considered valid.

            Note: To apply settings for a single iface, just say --op=apply

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 include/iscsi_if.h |   76 +++++++
 usr/config.h       |   13 +
 usr/idbm.c         |   16 ++
 usr/idbm_fields.h  |    7 +
 usr/iface.c        |  616 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 usr/iface.h        |    4 +
 usr/iscsi_ipc.h    |    3 +
 usr/iscsiadm.c     |  127 +++++++++++-
 usr/netlink.c      |  168 ++++++++++----
 9 files changed, 980 insertions(+), 50 deletions(-)

diff --git a/include/iscsi_if.h b/include/iscsi_if.h
index 50a09cb..ef60563 100644
--- a/include/iscsi_if.h
+++ b/include/iscsi_if.h
@@ -64,6 +64,7 @@ enum iscsi_uevent_e {
        ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST  = UEVENT_BASE + 19,

        ISCSI_UEVENT_PATH_UPDATE        = UEVENT_BASE + 20,
+       ISCSI_UEVENT_SET_NET_CONFIG     = UEVENT_BASE + 21,

        ISCSI_UEVENT_MAX                = ISCSI_UEVENT_PATH_UPDATE,

@@ -181,6 +182,10 @@ struct iscsi_uevent {
                struct msg_set_path {
                        uint32_t        host_no;
                } set_path;
+               struct msg_set_net_config {
+                       uint32_t        host_no;
+                       uint32_t        count;
+               } set_net_config;
        } u;
        union {
                /* messages k -> u */
@@ -246,6 +251,77 @@ struct iscsi_path {
        uint16_t        pmtu;
 } __attribute__ ((aligned (sizeof(uint64_t))));

+#define ISCSI_FALSE    0
+#define ISCSI_TRUE     1
+
+/* ipv4 bootproto */
+#define        ISCSI_BOOTPROTO_STATIC          0x01
+#define        ISCSI_BOOTPROTO_DHCP            0x02
+
+/* ipv6 addr autoconfig type */
+#define ISCSI_IPV6_AUTOCFG_DISABLE             0x01
+#define ISCSI_IPV6_AUTOCFG_ND_ENABLE           0x02
+#define ISCSI_IPV6_AUTOCFG_DHCPV6_ENABLE       0x03
+
+/* ipv6 link local addr type */
+#define ISCSI_IPV6_LINKLOCAL_AUTOCFG_ENABLE    0x01
+#define ISCSI_IPV6_LINKLOCAL_AUTOCFG_DISABLE   0x02
+
+/* ipv6 router addr type */
+#define ISCSI_IPV6_ROUTER_AUTOCFG_ENABLE       0x01
+#define ISCSI_IPV6_ROUTER_AUTOCFG_DISABLE      0x02
+
+/* iSCSI network params */
+enum iscsi_net_param_type {
+       ISCSI_NET_PARAM_IPV4_ADDR               = 1,
+       ISCSI_NET_PARAM_IPV4_SUBNET             = 2,
+       ISCSI_NET_PARAM_IPV4_GW                 = 3,
+       ISCSI_NET_PARAM_IPV4_BOOTPROTO          = 4,
+       ISCSI_NET_PARAM_MAC                     = 5,
+       ISCSI_NET_PARAM_IPV6_LINKLOCAL          = 6,
+       ISCSI_NET_PARAM_IPV6_ADDR               = 7,
+       ISCSI_NET_PARAM_IPV6_ROUTER             = 8,
+       ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG       = 9,
+       ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG  = 10,
+       ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG     = 11,
+       ISCSI_NET_PARAM_IFACE_ENABLED           = 12,
+       ISCSI_NET_PARAM_VLAN                    = 13,
+};
+
+#define ISCSI_NET_IPV4_ADDR            (1ULL << ISCSI_NET_PARAM_IPV4_ADDR)
+#define ISCSI_NET_IPV4_SUBNET          (1ULL << ISCSI_NET_PARAM_IPV4_SUBNET)
+#define ISCSI_NET_IPV4_GW              (1ULL << ISCSI_NET_PARAM_IPV4_GW)
+#define ISCSI_NET_IPV4_BOOTPROTO       (1ULL << ISCSI_NET_PARAM_IPV4_BOOTPROTO)
+#define ISCSI_NET_MAC                  (1ULL << ISCSI_NET_PARAM_MAC)
+#define ISCSI_NET_IPV6_LINKLOCAL       (1ULL << ISCSI_NET_PARAM_IPV6_LINKLOCAL)
+#define ISCSI_NET_IPV6_ADDR            (1ULL << ISCSI_NET_PARAM_IPV6_ADDR)
+#define ISCSI_NET_IPV6_ROUTER          (1ULL << ISCSI_NET_PARAM_IPV6_ROUTER)
+#define ISCSI_NET_IPV6_AUTOCFG         (1ULL << ISCSI_NET_PARAM_IPV6_AUTOCFG)
+#define ISCSI_NET_IPV6_ADDR_AUTOCFG                    \
+                               (1ULL << ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG)
+#define ISCSI_NET_IPV6_LINKLOCAL_AUTOCFG               \
+                               (1ULL << ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG)
+#define ISCSI_NET_IPV6_ROUTER_AUTOCFG                  \
+                               (1ULL << ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG)
+#define ISCSI_NET_IFACE_ENABLED                (1ULL << ISCSI_NET_PARAM_IFACE_ENABLED)
+#define ISCSI_NET_VLAN                 (1ULL << ISCSI_NET_PARAM_VLAN)
+
+/* 20 param per iface * 10 iface per port = 200 params */
+#define        ISCSI_MAX_IFACE_PER_HW          10
+#define        ISCSI_MAX_PARAM_PER_IFACE       20
+#define        ISCSI_MAX_NET_PARAMS            (ISCSI_MAX_IFACE_PER_HW * \
+                                       ISCSI_MAX_PARAM_PER_IFACE)
+
+#define        IFACE_TYPE_IPV4                 0x01
+#define        IFACE_TYPE_IPV6                 0x02
+struct iscsi_net_param {
+       uint32_t param_type;    /* enum iscsi_net_param */
+       uint32_t iface_type;    /* IPv4 or IPv6 */
+       uint32_t iface_num;     /* iface number, 0 - n */
+       uint32_t length;        /* Actual length of the param */
+       uint8_t value[0];       /* length sized value follows */
+} __attribute__((packed));
+
 /*
  * Common error codes
  */
diff --git a/usr/config.h b/usr/config.h
index 5cb4d56..987f208 100644
--- a/usr/config.h
+++ b/usr/config.h
@@ -196,14 +196,27 @@ typedef struct session_rec {
 } session_rec_t;

 #define ISCSI_TRANSPORT_NAME_MAXLEN 16
+#define        ISCSI_MAX_STR_LEN       80

 typedef struct iface_rec {
        struct list_head        list;
        /* iscsi iface record name */
        char                    name[ISCSI_MAX_IFACE_LEN];
+       uint32_t                iface_num;
        /* network layer iface name (eth0) */
        char                    netdev[IFNAMSIZ];
        char                    ipaddress[NI_MAXHOST];
+       char                    subnet_mask[NI_MAXHOST];
+       char                    gateway[NI_MAXHOST];
+       char                    bootproto[ISCSI_MAX_STR_LEN];
+       char                    ipv6_linklocal[NI_MAXHOST];
+       char                    ipv6_router[NI_MAXHOST];
+       char                    ipv6_autocfg[NI_MAXHOST];
+       char                    linklocal_autocfg[NI_MAXHOST];
+       char                    router_autocfg[NI_MAXHOST];
+       char                    vlan[ISCSI_MAX_STR_LEN];
+       char                    state[ISCSI_MAX_STR_LEN]; /* 0 = disable,
+                                                          * 1 = enable */
        /*
         * TODO: we may have to make this bigger and interconnect
         * specific for infinniband
diff --git a/usr/idbm.c b/usr/idbm.c
index a73b410..a7fb793 100644
--- a/usr/idbm.c
+++ b/usr/idbm.c
@@ -370,6 +370,22 @@ void idbm_recinfo_iface(iface_rec_t *r, recinfo_t *ri)
        __recinfo_str(IFACE_TRANSPORTNAME, ri, r, transport_name,
                      IDBM_SHOW, num, 1);
        __recinfo_str(IFACE_INAME, ri, r, iname, IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_BOOT_PROTO, ri, r, bootproto, IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_SUBNET_MASK, ri, r, subnet_mask,
+                     IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_GATEWAY, ri, r, gateway, IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_IPV6_AUTOCFG, ri, r, ipv6_autocfg,
+                     IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_LINKLOCAL_AUTOCFG, ri, r, linklocal_autocfg,
+                     IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_ROUTER_AUTOCFG, ri, r, router_autocfg,
+                     IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_LINKLOCAL, ri, r, ipv6_linklocal,
+                     IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_ROUTER, ri, r, ipv6_router, IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_STATE, ri, r, state, IDBM_SHOW, num, 1);
+       __recinfo_str(IFACE_VLAN, ri, r, vlan, IDBM_SHOW, num, 1);
+       __recinfo_int(IFACE_NUM, ri, r, iface_num, IDBM_SHOW, num, 1);
 }

 recinfo_t *idbm_recinfo_alloc(int max_keys)
diff --git a/usr/idbm_fields.h b/usr/idbm_fields.h
index eaa55d1..33019bb 100644
--- a/usr/idbm_fields.h
+++ b/usr/idbm_fields.h
@@ -76,6 +76,13 @@
 #define IFACE_PRIMARY_DNS      "iface.primary_dns"
 #define IFACE_SEC_DNS          "iface.secondary_dns"
 #define IFACE_VLAN             "iface.vlan"
+#define        IFACE_LINKLOCAL         "iface.ipv6_linklocal"
+#define        IFACE_ROUTER            "iface.ipv6_router"
+#define        IFACE_IPV6_AUTOCFG      "iface.ipv6_autocfg"
+#define        IFACE_LINKLOCAL_AUTOCFG "iface.linklocal_autocfg"
+#define        IFACE_ROUTER_AUTOCFG    "iface.router_autocfg"
+#define        IFACE_STATE             "iface.state"
+#define        IFACE_NUM               "iface.iface_num"

 /* discovery fields */
 #define DISC_STARTUP           "discovery.startup"
diff --git a/usr/iface.c b/usr/iface.c
index b10a1d4..558267a 100644
--- a/usr/iface.c
+++ b/usr/iface.c
@@ -26,6 +26,7 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <arpa/inet.h>

 #include "log.h"
 #include "list.h"
@@ -898,3 +899,618 @@ fail:
        }
        return rc;
 }
+
+struct iface_param_count {
+       struct iface_rec *primary;
+       int count;
+};
+
+/**
+ * __iface_get_param_count - Gets netconfig parameter count for given iface
+ * @data: iface_param_count structure
+ * @iface: iface to setup
+ */
+static int __iface_get_param_count(void *data, struct iface_rec *iface)
+{
+       struct iface_param_count *iface_params = data;
+       int iptype = IFACE_TYPE_IPV4;
+       int count = 0;
+
+       if (strcmp(iface_params->primary->hwaddress, iface->hwaddress))
+               return 0;
+
+       if (iface_params->count > ISCSI_MAX_NET_PARAMS)
+               return iface_params->count;
+
+       if (strcmp(iface->bootproto, "dhcp") && !strstr(iface->ipaddress, "."))
+               iptype = IFACE_TYPE_IPV6;
+
+       if (iptype == IFACE_TYPE_IPV4) {
+
+               if (strcmp(iface->state, "disable")) {
+                       if (strstr(iface->bootproto, "dhcp"))
+                               /* DHCP enabled */
+                               count++;
+                       else {
+                               /* DHCP disabled */
+                               count++;
+
+                               if (strstr(iface->ipaddress, ".")) {
+                                       /* User configured IPv4 Address */
+                                       count++;
+
+                                       if (strstr(iface->subnet_mask, "."))
+                                               /* User configured Subnet */
+                                               count++;
+
+                                       if (strstr(iface->gateway, "."))
+                                               /* User configured Gateway */
+                                               count++;
+                               } else
+                                       /*
+                                        * IPv4 Address not valid, decrement
+                                        * count of DHCP
+                                        */
+                                       count--;
+                       }
+
+                       /*
+                        * If IPv4 configuration in iface file is valid,
+                        * enable state and other parameters (if any)
+                        */
+                       if (count)
+                               /* iface state */
+                               count++;
+
+               } else
+                       /* IPv4 is disabled, iface state */
+                       count++;
+
+       } else if (iptype == IFACE_TYPE_IPV6) {
+
+               if (strcmp(iface->state, "disable")) {
+
+                       /* IPv6 Address */
+                       if (strstr(iface->ipv6_autocfg, "nd") ||
+                           strstr(iface->ipv6_autocfg, "dhcpv6"))
+                               /* Autocfg enabled */
+                               count++;
+                       else {
+                               /* Autocfg disabled */
+                               count++;
+
+                               if (strstr(iface->ipaddress, ":"))
+                                       /* User configured IPv6 Address */
+                                       count++;
+                               else
+                                       /*
+                                        * IPv6 Address not valid, decrement
+                                        * count of IPv6 Autocfg
+                                        */
+                                       count--;
+                       }
+
+                       /* IPv6 LinkLocal Address */
+                       if (strstr(iface->linklocal_autocfg, "auto"))
+                               /* Autocfg enabled */
+                               count++;
+                       else {
+                               /* Autocfg disabled */
+                               count++;
+
+                               if (strstr(iface->ipv6_linklocal, ":"))
+                                       /* User configured LinkLocal Address */
+                                       count++;
+                               else
+                                       /*
+                                        * LinkLocal Address not valid,
+                                        * decrement count of LinkLocal Autocfg
+                                        */
+                                       count--;
+                       }
+
+                       /* IPv6 Router Address */
+                       if (strstr(iface->router_autocfg, "auto"))
+                               /* Autocfg enabled */
+                               count++;
+                       else {
+                               /* Autocfg disabled */
+                               count++;
+
+                               if (strstr(iface->ipv6_router, ":"))
+                                       /* User configured Router Address */
+                                       count++;
+                               else
+                                       /*
+                                        * Router Address not valid,
+                                        * decrement count of Router Autocfg
+                                        */
+                                       count--;
+                       }
+
+                       /*
+                        * If IPv6 configuration in iface file is valid,
+                        * enable state and other parameters (if any)
+                        */
+                       if (count)
+                               /* iface state */
+                               count++;
+               } else
+                       /* IPv6 is disabled, iface state */
+                       count++;
+       }
+
+       iface_params->count += count;
+       return 0;
+}
+
+/**
+ * iface_get_param_count - Gets netconfig parameter count from iface
+ * @iface: iface to setup
+ * @iface_all: Flag for number of ifaces to traverse (1 for all)
+ *
+ * Returns netconfig parameter count.
+ */
+int iface_get_param_count(struct iface_rec *iface, int iface_all)
+{
+       int num_found = 0, rc;
+       struct iface_param_count iface_params;
+
+       log_debug(8, "In iface_get_param_count\n");
+
+       iface_params.primary = iface;
+       iface_params.count = 0;
+
+       if (iface_all)
+               rc = iface_for_each_iface(&iface_params, 0, &num_found,
+                                         __iface_get_param_count);
+       else
+               rc = __iface_get_param_count(&iface_params, iface);
+
+       log_debug(8, "iface_get_param_count: rc = %d, count = %d\n",
+                 rc, iface_params.count);
+       return iface_params.count;
+}
+
+/* IPv4/IPv6 Network state: disable/enable */
+static inline int __iface_fill_net_state(struct iovec *iov,
+                                        struct iface_rec *iface,
+                                        uint32_t iface_type)
+{
+       int len;
+       struct iscsi_net_param *net_param;
+
+       len = sizeof(struct iscsi_net_param) + 1;
+       iov->iov_base = calloc(len, sizeof(char));
+       if (!(iov->iov_base))
+               return 1;
+
+       iov->iov_len = len;
+       net_param = (struct iscsi_net_param *)(iov->iov_base);
+       net_param->param_type = ISCSI_NET_PARAM_IFACE_ENABLED;
+       net_param->iface_type = iface_type;
+       net_param->iface_num = iface->iface_num;
+       net_param->length = 1;
+       if (!strcmp(iface->state, "disable"))
+               net_param->value[0] = ISCSI_FALSE;
+       else /* Assume enabled */
+               net_param->value[0] = ISCSI_TRUE;
+       return 0;
+}
+
+/* IPv4 Bootproto: DHCP/static */
+static inline int __iface_fill_net_bootproto(struct iovec *iov,
+                                            struct iface_rec *iface)
+{
+       int len;
+       struct iscsi_net_param *net_param;
+
+       len = sizeof(struct iscsi_net_param) + 1;
+       iov->iov_base = calloc(len, sizeof(char));
+       if (!(iov->iov_base))
+               return 1;
+
+       iov->iov_len = len;
+       net_param = (struct iscsi_net_param *)(iov->iov_base);
+       net_param->param_type = ISCSI_NET_PARAM_IPV4_BOOTPROTO;
+       net_param->iface_type = IFACE_TYPE_IPV4;
+       net_param->iface_num = iface->iface_num;
+       net_param->length = 1;
+       if (!strcmp(iface->bootproto, "dhcp"))
+               net_param->value[0] = ISCSI_BOOTPROTO_DHCP;
+       else
+               net_param->value[0] = ISCSI_BOOTPROTO_STATIC;
+       return 0;
+}
+
+/* IPv6 IPAddress Autocfg: nd/dhcpv6/disable */
+static inline int __iface_fill_net_autocfg(struct iovec *iov,
+                                          struct iface_rec *iface)
+{
+       int len;
+       struct iscsi_net_param *net_param;
+
+       len = sizeof(struct iscsi_net_param) + 1;
+       iov->iov_base = calloc(len, sizeof(char));
+       if (!(iov->iov_base))
+               return 1;
+
+       iov->iov_len = len;
+       net_param = (struct iscsi_net_param *)(iov->iov_base);
+       net_param->param_type = ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG;
+       net_param->iface_type = IFACE_TYPE_IPV6;
+       net_param->length = 1;
+
+       if (!strcmp(iface->ipv6_autocfg, "nd"))
+               net_param->value[0] = ISCSI_IPV6_AUTOCFG_ND_ENABLE;
+       else if (!strcmp(iface->ipv6_autocfg, "dhcpv6"))
+               net_param->value[0] = ISCSI_IPV6_AUTOCFG_DHCPV6_ENABLE;
+       else
+               net_param->value[0] = ISCSI_IPV6_AUTOCFG_DISABLE;
+
+       return 0;
+}
+
+/* IPv6 LinkLocal Autocfg: enable/disable */
+static inline int __iface_fill_linklocal_autocfg(struct iovec *iov,
+                                                struct iface_rec *iface)
+{
+       int len;
+       struct iscsi_net_param *net_param;
+
+       len = sizeof(struct iscsi_net_param) + 1;
+       iov->iov_base = calloc(len, sizeof(char));
+       if (!(iov->iov_base))
+               return 1;
+
+       iov->iov_len = len;
+       net_param = (struct iscsi_net_param *)(iov->iov_base);
+       net_param->param_type = ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG;
+       net_param->iface_type = IFACE_TYPE_IPV6;
+       net_param->length = 1;
+
+       if (strstr(iface->linklocal_autocfg, "auto"))
+               net_param->value[0] = ISCSI_IPV6_LINKLOCAL_AUTOCFG_ENABLE;
+       else
+               net_param->value[0] = ISCSI_IPV6_LINKLOCAL_AUTOCFG_DISABLE;
+
+       return 0;
+}
+
+/* IPv6 Router Autocfg: enable/disable */
+static inline int __iface_fill_router_autocfg(struct iovec *iov,
+                                             struct iface_rec *iface)
+{
+       int len;
+       struct iscsi_net_param *net_param;
+
+       len = sizeof(struct iscsi_net_param) + 1;
+       iov->iov_base = calloc(len, sizeof(char));
+       if (!(iov->iov_base))
+               return 1;
+
+       iov->iov_len = len;
+       net_param = (struct iscsi_net_param *)(iov->iov_base);
+       net_param->param_type = ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG;
+       net_param->iface_type = IFACE_TYPE_IPV6;
+       net_param->length = 1;
+
+       if (strstr(iface->router_autocfg, "auto"))
+               net_param->value[0] = ISCSI_IPV6_ROUTER_AUTOCFG_ENABLE;
+       else
+               net_param->value[0] = ISCSI_IPV6_ROUTER_AUTOCFG_DISABLE;
+
+       return 0;
+}
+
+/* IPv4 IPAddress/Subnet Mask/Gateway: 4 bytes */
+static inline int __iface_fill_net_ipv4_addr(struct iovec *iov,
+                                            struct iface_rec *iface,
+                                            uint32_t param_type)
+{
+       int rc = 1;
+       int len;
+       struct iscsi_net_param *net_param;
+
+       len = sizeof(struct iscsi_net_param) + 4;
+       iov->iov_base = calloc(len, sizeof(char));
+       if (!(iov->iov_base))
+               return 1;
+
+       iov->iov_len = len;
+       net_param = (struct iscsi_net_param *)(iov->iov_base);
+       net_param->param_type = param_type;
+       net_param->iface_type = IFACE_TYPE_IPV4;
+       net_param->iface_num = iface->iface_num;
+       net_param->length = 4;
+
+       switch (param_type) {
+       case ISCSI_NET_PARAM_IPV4_ADDR:
+               rc = inet_pton(AF_INET, iface->ipaddress, net_param->value);
+               if (rc <= 0)
+                       goto free;
+               break;
+       case ISCSI_NET_PARAM_IPV4_SUBNET:
+               rc = inet_pton(AF_INET, iface->subnet_mask, net_param->value);
+               if (rc <= 0)
+                       goto free;
+               break;
+       case ISCSI_NET_PARAM_IPV4_GW:
+               rc = inet_pton(AF_INET, iface->gateway, net_param->value);
+               if (rc <= 0)
+                       goto free;
+               break;
+       default:
+               goto free;
+       }
+
+       /* validate */
+       if (!net_param->value[0] && !net_param->value[1] &&
+           !net_param->value[2] && !net_param->value[3])
+               goto free;
+
+       return 0;
+free:
+       free(iov->iov_base);
+       iov->iov_base = NULL;
+       iov->iov_len = 0;
+       return 1;
+}
+
+/* IPv6 IPAddress/LinkLocal/Router: 16 bytes */
+static inline int __iface_fill_net_ipv6_addr(struct iovec *iov,
+                                            struct iface_rec *iface,
+                                            uint32_t param_type)
+{
+       int rc;
+       int len;
+       struct iscsi_net_param *net_param;
+
+       len = sizeof(struct iscsi_net_param) + 16;
+       iov->iov_base = calloc(len, sizeof(char));
+       if (!(iov->iov_base))
+               return 1;
+
+       iov->iov_len = len;
+       net_param = (struct iscsi_net_param *)(iov->iov_base);
+       net_param->param_type = param_type;
+       net_param->iface_type = IFACE_TYPE_IPV6;
+       net_param->iface_num = iface->iface_num;
+       net_param->length = 16;
+
+       switch (param_type) {
+       case ISCSI_NET_PARAM_IPV6_ADDR:
+               rc = inet_pton(AF_INET6, iface->ipaddress, net_param->value);
+               if (rc <= 0)
+                       goto free;
+               break;
+       case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
+               rc = inet_pton(AF_INET6, iface->ipv6_linklocal,
+                   net_param->value);
+               if (rc <= 0)
+                       goto free;
+               break;
+       case ISCSI_NET_PARAM_IPV6_ROUTER:
+               rc = inet_pton(AF_INET6, iface->ipv6_router, net_param->value);
+               if (rc <= 0)
+                       goto free;
+               break;
+       default:
+               goto free;
+       }
+
+       return 0;
+free:
+       free(iov->iov_base);
+       iov->iov_base = NULL;
+       iov->iov_len = 0;
+       return 1;
+}
+
+struct iface_net_config {
+       struct iface_rec *primary;
+       struct iovec *iovs;
+       int count;
+};
+
+static int __iface_build_net_config(void *data, struct iface_rec *iface)
+{
+       struct iface_net_config *net_config = data;
+       struct iovec *iov;
+       int iptype = IFACE_TYPE_IPV4;
+       int count = 0;
+
+       if (strcmp(net_config->primary->hwaddress, iface->hwaddress))
+               return 0;
+
+       if (net_config->count > ISCSI_MAX_NET_PARAMS)
+               return net_config->count;
+
+       if (strcmp(iface->bootproto, "dhcp") && !strstr(iface->ipaddress, "."))
+               iptype = IFACE_TYPE_IPV6;
+
+       /* start at 2, because 0 is for nlmsghdr and 1 for event */
+       iov = net_config->iovs + 2;
+
+       if (iptype == IFACE_TYPE_IPV4) {
+
+               if (strcmp(iface->state, "disable")) {
+                       if (strstr(iface->bootproto, "dhcp")) {
+                               if (__iface_fill_net_bootproto(
+                                   &iov[net_config->count], iface) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                       } else if (strstr(iface->ipaddress, ".")) {
+                               if (__iface_fill_net_bootproto(
+                                   &iov[net_config->count], iface) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                               if (__iface_fill_net_ipv4_addr(
+                                   &iov[net_config->count], iface,
+                                   ISCSI_NET_PARAM_IPV4_ADDR) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                               if (strstr(iface->subnet_mask, ".")) {
+                                       if (__iface_fill_net_ipv4_addr(
+                                           &iov[net_config->count], iface,
+                                           ISCSI_NET_PARAM_IPV4_SUBNET) == 0) {
+                                               net_config->count++;
+                                               count++;
+                                       }
+                               }
+                               if (strstr(iface->gateway, ".")) {
+                                       if (__iface_fill_net_ipv4_addr(
+                                           &iov[net_config->count], iface,
+                                           ISCSI_NET_PARAM_IPV4_GW) == 0) {
+                                               net_config->count++;
+                                               count++;
+                                       }
+                               }
+                       }
+
+                       /*
+                        * If IPv4 configuration in iface file is valid,
+                        * fill state and other parameters (if any)
+                        */
+                       if (count) {
+                               if (__iface_fill_net_state(
+                                   &iov[net_config->count], iface,
+                                   IFACE_TYPE_IPV4) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                       }
+               } else {
+                       if (__iface_fill_net_state(&iov[net_config->count],
+                           iface, IFACE_TYPE_IPV4) == 0) {
+                               net_config->count++;
+                               count++;
+                       }
+               }
+
+       } else if (iptype == IFACE_TYPE_IPV6) {
+
+               if (strcmp(iface->state, "disable")) {
+                       /* For IPv6 Address */
+                       if (strstr(iface->ipv6_autocfg, "nd") ||
+                           strstr(iface->ipv6_autocfg, "dhcpv6")) {
+                               if (__iface_fill_net_autocfg(
+                                   &iov[net_config->count], iface) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                       } else if (strstr(iface->ipaddress, ":")) {
+                               if (__iface_fill_net_autocfg(
+                                   &iov[net_config->count], iface) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                               /* User provided IPv6 Address */
+                               if (__iface_fill_net_ipv6_addr(
+                                   &iov[net_config->count],
+                                   iface, ISCSI_NET_PARAM_IPV6_ADDR) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                       }
+
+                       /* For LinkLocal Address */
+                       if (strstr(iface->linklocal_autocfg, "auto")) {
+                               if (__iface_fill_linklocal_autocfg(
+                                   &iov[net_config->count], iface) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                       } else if (strstr(iface->ipv6_linklocal, ":")) {
+                               if (__iface_fill_linklocal_autocfg(
+                                   &iov[net_config->count], iface) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                               /* User provided Link Local Address */
+                               if (__iface_fill_net_ipv6_addr(
+                                   &iov[net_config->count], iface,
+                                   ISCSI_NET_PARAM_IPV6_LINKLOCAL) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                       }
+
+                       /* For Router Address */
+                       if (strstr(iface->router_autocfg, "auto")) {
+                               if (__iface_fill_router_autocfg(
+                                   &iov[net_config->count], iface) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                       } else if (strstr(iface->ipv6_router, ":")) {
+                               if (__iface_fill_router_autocfg(
+                                   &iov[net_config->count], iface) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                               /* User provided Router Address */
+                               if (__iface_fill_net_ipv6_addr(
+                                   &iov[net_config->count], iface,
+                                   ISCSI_NET_PARAM_IPV6_ROUTER) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                       }
+
+                       /*
+                        * If IPv6 configuration in iface file is valid,
+                        * fill state and other parameters
+                        */
+                       if (count) {
+                               if (__iface_fill_net_state(
+                                   &iov[net_config->count], iface,
+                                   IFACE_TYPE_IPV6) == 0) {
+                                       net_config->count++;
+                                       count++;
+                               }
+                       }
+               } else {
+                       if (__iface_fill_net_state(&iov[net_config->count],
+                           iface, IFACE_TYPE_IPV6) == 0) {
+                               net_config->count++;
+                               count++;
+                       }
+               }
+       }
+       return 0;
+}
+
+/**
+ * iface_build_net_config - Setup neconfig parameter buffers
+ * @iface: iface to setup
+ * @iface_all: Flag for number of ifaces to traverse (1 for all)
+ * @iovs: iovec buffer for netconfig parameters
+ *
+ * Returns total number of netconfig parameter buffers used.
+ */
+int iface_build_net_config(struct iface_rec *iface, int iface_all,
+                          struct iovec *iovs)
+{
+       int num_found = 0, rc;
+       struct iface_net_config net_config;
+
+       log_debug(8, "In iface_build_net_config\n");
+
+       net_config.primary = iface;
+       net_config.iovs = iovs;
+       net_config.count = 0;
+
+       if (iface_all)
+               rc = iface_for_each_iface(&net_config, 0, &num_found,
+                                         __iface_build_net_config);
+       else
+               rc = __iface_build_net_config(&net_config, iface);
+
+       log_debug(8, "iface_build_net_config: rc = %d, count = %d\n",
+                 rc, net_config.count);
+       return net_config.count;
+}
diff --git a/usr/iface.h b/usr/iface.h
index 9f6d47e..3ba2a4e 100644
--- a/usr/iface.h
+++ b/usr/iface.h
@@ -54,6 +54,10 @@ extern int iface_setup_from_boot_context(struct iface_rec *iface,
                                    struct boot_context *context);
 extern int iface_create_ifaces_from_boot_contexts(struct list_head *ifaces,
                                                  struct list_head *targets);
+extern int iface_get_param_count(struct iface_rec *iface_primary,
+                                int iface_all);
+extern int iface_build_net_config(struct iface_rec *iface_primary,
+                                 int iface_all, struct iovec *iovs);

 #define iface_fmt "[hw=%s,ip=%s,net_if=%s,iscsi_if=%s]"
 #define iface_str(_iface) \
diff --git a/usr/iscsi_ipc.h b/usr/iscsi_ipc.h
index 93b4917..8df3cdc 100644
--- a/usr/iscsi_ipc.h
+++ b/usr/iscsi_ipc.h
@@ -129,6 +129,9 @@ struct iscsi_ipc {
        int (*recv_pdu_begin) (struct iscsi_conn *conn);

        int (*recv_pdu_end) (struct iscsi_conn *conn);
+
+       int (*set_net_config) (uint64_t transport_handle, uint32_t host_no,
+                              struct iovec *iovs, uint32_t param_count);
 };

 #endif /* ISCSI_IPC_H */
diff --git a/usr/iscsiadm.c b/usr/iscsiadm.c
index 3c8abd2..55b4a5a 100644
--- a/usr/iscsiadm.c
+++ b/usr/iscsiadm.c
@@ -49,6 +49,7 @@
 #include "iscsid_req.h"
 #include "isns-proto.h"
 #include "iscsi_err.h"
+#include "iscsi_ipc.h"

 static char program_name[] = "iscsiadm";
 static char config_file[TARGET_NAME_MAXLEN];
@@ -70,7 +71,9 @@ enum iscsiadm_op {
        OP_DELETE               = 0x2,
        OP_UPDATE               = 0x4,
        OP_SHOW                 = 0x8,
-       OP_NONPERSISTENT        = 0x10
+       OP_NONPERSISTENT        = 0x10,
+       OP_APPLY                = 0x20,
+       OP_APPLY_ALL            = 0x40
 };

 static struct option const long_options[] =
@@ -138,6 +141,10 @@ str_to_op(char *str)
                op = OP_SHOW;
        else if (!strcmp("nonpersistent", str))
                op = OP_NONPERSISTENT;
+       else if (!strcmp("apply", str))
+               op = OP_APPLY;
+       else if (!strcmp("applyall", str))
+               op = OP_APPLY_ALL;
        else
                op = OP_NOOP;

@@ -1091,6 +1098,97 @@ static void catch_sigint( int signo ) {
        exit(1);
 }

+static int
+iface_apply_net_config(struct iface_rec *iface, int op)
+{
+       int rc = ISCSI_ERR;
+       uint32_t host_no;
+       int param_count;
+       int param_used;
+       int iface_all = 0;
+       int i;
+       struct iovec *iovs = NULL;
+       struct iovec *iov = NULL;
+       struct iscsi_transport *t = NULL;
+       int fd;
+
+       log_debug(8, "Calling iscsid, to apply net config for"
+           "iface.name = %s\n", iface->name);
+
+       if (op == OP_APPLY_ALL)
+               iface_all = 1;
+
+       param_count = iface_get_param_count(iface, iface_all);
+       if (!param_count) {
+               log_error("Nothing to configure.");
+               return ISCSI_SUCCESS;
+       }
+
+       if (param_count > ISCSI_MAX_NET_PARAMS) {
+               log_error("Too many parameters.");
+               return ISCSI_ERR;
+       }
+
+       /* +2 for event and nlmsghdr */
+       param_count += 2;
+       iovs = calloc((param_count * sizeof(struct iovec)),
+                      sizeof(char));
+       if (!iovs) {
+               log_error("Out of Memory.");
+               return ISCSI_ERR_NOMEM;
+       }
+
+       /* param_used gives actual number of iovecs used for netconfig */
+       param_used = iface_build_net_config(iface, iface_all, iovs);
+       if (!param_used) {
+               log_error("Build netconfig failed.");
+               goto free_buf;
+       }
+
+       if (param_used > ISCSI_MAX_NET_PARAMS) {
+               log_error("Too many parameters for build netconfig.");
+               goto free_buf;
+       }
+
+       t = iscsi_sysfs_get_transport_by_name(iface->transport_name);
+       if (!t) {
+               log_error("Can't find transport.");
+               goto free_buf;
+       }
+
+       host_no = iscsi_sysfs_get_host_no_from_hwinfo(iface, &rc);
+       if (host_no == -1) {
+               log_error("Can't find host_no.");
+               goto free_buf;
+       }
+       rc = ISCSI_ERR;
+
+       fd = ipc->ctldev_open();
+       if (fd < 0) {
+               log_error("Netlink open failed.");
+               goto free_buf;
+       }
+
+       rc = ipc->set_net_config(t->handle, host_no, iovs, param_count);
+       if (rc < 0)
+               log_error("Set net_config failed. errno=%d", errno);
+
+       ipc->ctldev_close();
+
+free_buf:
+       /* start at 2, because 0 is for nlmsghdr and 1 for event */
+       iov = iovs + 2;
+       for (i = 0; i < param_used; i++, iov++) {
+               if (iov->iov_base)
+                       free(iov->iov_base);
+       }
+
+       free(iovs);
+       if (rc)
+               return ISCSI_ERR;
+       return ISCSI_SUCCESS;
+}
+
 /* TODO: merge iter helpers and clean them up, so we can use them here */
 static int exec_iface_op(int op, int do_show, int info_level,
                         struct iface_rec *iface, char *name, char *value)
@@ -1217,6 +1315,33 @@ update_fail:
                log_error("Could not update iface %s: %s",
                          iface->name, iscsi_err_to_str(rc));
                break;
+       case OP_APPLY:
+       case OP_APPLY_ALL:
+               if (!iface) {
+                       log_error("Apply requires iface.");
+                       rc = ISCSI_ERR_INVAL;
+                       break;
+               }
+
+               rc = iface_conf_read(iface);
+               if (rc) {
+                       log_error("Could not read iface %s (%d).",
+                                 iface->name, rc);
+                       break;
+               }
+
+               /*
+                * For each iface where hwaddress match, start filling
+                * buffer with iscsi_net_param
+                */
+               rc = iface_apply_net_config(iface, op);
+               if (rc) {
+                       log_error("Could not apply net_config: %s",
+                                 iscsi_err_to_str(rc));
+                       break;
+               }
+               printf("%s applied.\n", iface->name);
+               break;
        default:
                if (!iface || (iface && info_level > 0)) {
                        if (op == OP_NOOP || op == OP_SHOW)
diff --git a/usr/netlink.c b/usr/netlink.c
index 957fdb6..46b72a4 100644
--- a/usr/netlink.c
+++ b/usr/netlink.c
@@ -161,7 +161,6 @@ kwritev(enum iscsi_uevent_e type, struct iovec *iovp, int count)
        int i, rc;
        struct nlmsghdr *nlh;
        struct msghdr msg;
-       struct iovec iov;
        int datalen = 0;

        log_debug(7, "in %s", __FUNCTION__);
@@ -180,27 +179,25 @@ kwritev(enum iscsi_uevent_e type, struct iovec *iovp, int count)
        }

        nlh = nlm_sendbuf;
-       memset(nlh, 0, NLMSG_SPACE(datalen));
+       memset(nlh, 0, NLMSG_SPACE(0));

-       nlh->nlmsg_len = NLMSG_SPACE(datalen);
+       datalen = 0;
+       for (i = 1; i < count; i++)
+               datalen += iovp[i].iov_len;
+
+       nlh->nlmsg_len = NLMSG_ALIGN(datalen);
        nlh->nlmsg_pid = getpid();
        nlh->nlmsg_flags = 0;
        nlh->nlmsg_type = type;

-       datalen = 0;
-       for (i = 0; i < count; i++) {
-               memcpy(NLMSG_DATA(nlh) + datalen, iovp[i].iov_base,
-                      iovp[i].iov_len);
-               datalen += iovp[i].iov_len;
-       }
-       iov.iov_base = (void*)nlh;
-       iov.iov_len = nlh->nlmsg_len;
+       iovp[0].iov_base = (void *)nlh;
+       iovp[0].iov_len = sizeof(*nlh);

        memset(&msg, 0, sizeof(msg));
        msg.msg_name= (void*)&dest_addr;
        msg.msg_namelen = sizeof(dest_addr);
-       msg.msg_iov = &iov;
-       msg.msg_iovlen = 1;
+       msg.msg_iov = iovp;
+       msg.msg_iovlen = count;

        do {
                /*
@@ -261,19 +258,15 @@ kwritev(enum iscsi_uevent_e type, struct iovec *iovp, int count)
  *        cleanup. (Dima)
  */
 static int
-__kipc_call(void *iov_base, int iov_len)
+__kipc_call(struct iovec *iovp, int count)
 {
        int rc, iferr;
-       struct iovec iov;
-       struct iscsi_uevent *ev = iov_base;
+       struct iscsi_uevent *ev = iovp[1].iov_base;
        enum iscsi_uevent_e type = ev->type;

        log_debug(7, "in %s", __FUNCTION__);

-       iov.iov_base = iov_base;
-       iov.iov_len = iov_len;
-
-       rc = kwritev(type, &iov, 1);
+       rc = kwritev(type, iovp, count);

        do {
                if ((rc = nlpayload_read(ctrl_fd, (void*)ev,
@@ -333,6 +326,7 @@ ksendtargets(uint64_t transport_handle, uint32_t host_no, struct sockaddr *addr)
 {
        int rc, addrlen;
        struct iscsi_uevent *ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -354,7 +348,9 @@ ksendtargets(uint64_t transport_handle, uint32_t host_no, struct sockaddr *addr)
        }
        memcpy(setparam_buf + sizeof(*ev), addr, addrlen);

-       rc = __kipc_call(ev, sizeof(*ev) + addrlen);
+       iov[1].iov_base = ev;
+       iov[1].iov_len = sizeof(*ev) + addrlen;
+       rc = __kipc_call(iov, 2);
        if (rc < 0) {
                log_error("sendtargets failed rc%d\n", rc);
                return rc;
@@ -369,6 +365,7 @@ kcreate_session(uint64_t transport_handle, uint64_t ep_handle,
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -389,9 +386,11 @@ kcreate_session(uint64_t transport_handle, uint64_t ep_handle,
                ev.u.c_bound_session.ep_handle = ep_handle;
        }

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        *hostno = ev.r.c_session_ret.host_no;
        *out_sid = ev.r.c_session_ret.sid;
@@ -404,6 +403,7 @@ kdestroy_session(uint64_t transport_handle, uint32_t sid)
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -413,9 +413,11 @@ kdestroy_session(uint64_t transport_handle, uint32_t sid)
        ev.transport_handle = transport_handle;
        ev.u.d_session.sid = sid;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        return 0;
 }
@@ -425,6 +427,7 @@ kunbind_session(uint64_t transport_handle, uint32_t sid)
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -434,9 +437,11 @@ kunbind_session(uint64_t transport_handle, uint32_t sid)
        ev.transport_handle = transport_handle;
        ev.u.d_session.sid = sid;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        return 0;
 }
@@ -447,6 +452,7 @@ kcreate_conn(uint64_t transport_handle, uint32_t sid,
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -457,7 +463,10 @@ kcreate_conn(uint64_t transport_handle, uint32_t sid,
        ev.u.c_conn.cid = cid;
        ev.u.c_conn.sid = sid;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0) {
                log_debug(7, "returned %d", rc);
                return rc;
        }
@@ -474,6 +483,7 @@ kdestroy_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid)
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -484,9 +494,11 @@ kdestroy_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid)
        ev.u.d_conn.sid = sid;
        ev.u.d_conn.cid = cid;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        return 0;
 }
@@ -497,6 +509,7 @@ kbind_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid,
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -509,9 +522,11 @@ kbind_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid,
        ev.u.b_conn.transport_eph = transport_eph;
        ev.u.b_conn.is_leading = is_leading;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        *retcode = ev.r.retcode;

@@ -559,7 +574,7 @@ ksend_pdu_end(uint64_t transport_handle, uint32_t sid, uint32_t cid,
 {
        int rc;
        struct iscsi_uevent *ev;
-       struct iovec iov;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -573,10 +588,11 @@ ksend_pdu_end(uint64_t transport_handle, uint32_t sid, uint32_t cid,
                exit(-EIO);
        }

-       iov.iov_base = xmitbuf;
-       iov.iov_len = xmitlen;
+       iov[1].iov_base = xmitbuf;
+       iov[1].iov_len = xmitlen;

-       if ((rc = __kipc_call(xmitbuf, xmitlen)) < 0)
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                goto err;
        if (ev->r.retcode) {
                *retcode = ev->r.retcode;
@@ -606,6 +622,7 @@ kset_host_param(uint64_t transport_handle, uint32_t host_no,
        struct iscsi_uevent *ev;
        char *param_str;
        int rc, len;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -632,9 +649,11 @@ kset_host_param(uint64_t transport_handle, uint32_t host_no,
        }
        ev->u.set_host_param.len = len = strlen(param_str) + 1;

-       if ((rc = __kipc_call(ev, sizeof(*ev) + len)) < 0) {
+       iov[1].iov_base = ev;
+       iov[1].iov_len = sizeof(*ev) + len;
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        return 0;
 }
@@ -646,6 +665,7 @@ kset_param(uint64_t transport_handle, uint32_t sid, uint32_t cid,
        struct iscsi_uevent *ev;
        char *param_str;
        int rc, len;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -673,9 +693,11 @@ kset_param(uint64_t transport_handle, uint32_t sid, uint32_t cid,
        }
        ev->u.set_param.len = len = strlen(param_str) + 1;

-       if ((rc = __kipc_call(ev, sizeof(*ev) + len)) < 0) {
+       iov[1].iov_base = ev;
+       iov[1].iov_len = sizeof(*ev) + len;
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        return 0;
 }
@@ -685,6 +707,7 @@ kstop_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid, int flag)
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -696,9 +719,11 @@ kstop_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid, int flag)
        ev.u.stop_conn.cid = cid;
        ev.u.stop_conn.flag = flag;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        return 0;
 }
@@ -709,6 +734,7 @@ kstart_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid,
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -719,9 +745,11 @@ kstart_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid,
        ev.u.start_conn.sid = sid;
        ev.u.start_conn.cid = cid;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        *retcode = ev.r.retcode;
        return 0;
@@ -786,6 +814,7 @@ ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
        int rc, addrlen;
        struct iscsi_uevent *ev;
        struct sockaddr *dst_addr = (struct sockaddr *)&conn->saddr;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -813,7 +842,10 @@ ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
        }
        memcpy(setparam_buf + sizeof(*ev), dst_addr, addrlen);

-       if ((rc = __kipc_call(ev, sizeof(*ev) + addrlen)) < 0)
+       iov[1].iov_base = ev;
+       iov[1].iov_len = sizeof(*ev) + addrlen;
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;

        if (!ev->r.ep_connect_ret.handle)
@@ -831,6 +863,7 @@ ktransport_ep_poll(iscsi_conn_t *conn, int timeout_ms)
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -841,7 +874,10 @@ ktransport_ep_poll(iscsi_conn_t *conn, int timeout_ms)
        ev.u.ep_poll.ep_handle  = conn->transport_ep_handle;
        ev.u.ep_poll.timeout_ms = timeout_ms;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0)
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;

        return ev.r.retcode;
@@ -852,6 +888,7 @@ ktransport_ep_disconnect(iscsi_conn_t *conn)
 {
        int rc;
        struct iscsi_uevent ev;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -864,7 +901,10 @@ ktransport_ep_disconnect(iscsi_conn_t *conn)
        ev.transport_handle = conn->session->t->handle;
        ev.u.ep_disconnect.ep_handle = conn->transport_ep_handle;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0) {
                log_error("connnection %d:%d transport disconnect failed for "
                          "ep %" PRIu64 " with error %d.", conn->session->id,
                          conn->id, conn->transport_ep_handle, rc);
@@ -881,6 +921,7 @@ kget_stats(uint64_t transport_handle, uint32_t sid, uint32_t cid,
        struct iscsi_uevent ev;
        char nlm_ev[NLMSG_SPACE(sizeof(struct iscsi_uevent))];
        struct nlmsghdr *nlh;
+       struct iovec iov[2];

        log_debug(7, "in %s", __FUNCTION__);

@@ -891,9 +932,11 @@ kget_stats(uint64_t transport_handle, uint32_t sid, uint32_t cid,
        ev.u.get_stats.sid = sid;
        ev.u.get_stats.cid = cid;

-       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
+       iov[1].iov_base = &ev;
+       iov[1].iov_len = sizeof(ev);
+       rc = __kipc_call(iov, 2);
+       if (rc < 0)
                return rc;
-       }

        if ((rc = nl_read(ctrl_fd, nlm_ev,
                NLMSG_SPACE(sizeof(struct iscsi_uevent)), MSG_PEEK)) < 0) {
@@ -919,6 +962,32 @@ kget_stats(uint64_t transport_handle, uint32_t sid, uint32_t cid,
        return 0;
 }

+static int
+kset_net_config(uint64_t transport_handle, uint32_t host_no,
+               struct iovec *iovs, uint32_t param_count)
+{
+       struct iscsi_uevent ev;
+       int rc, ev_len;
+       struct iovec *iov = iovs + 1;
+
+       log_debug(8, "in %s", __FUNCTION__);
+
+       ev_len = sizeof(ev);
+       ev.type = ISCSI_UEVENT_SET_NET_CONFIG;
+       ev.transport_handle = transport_handle;
+       ev.u.set_net_config.host_no = host_no;
+       /* first two iovs for nlmsg hdr and ev */
+       ev.u.set_net_config.count = param_count - 2;
+
+       iov->iov_base = &ev;
+       iov->iov_len = ev_len;
+       rc = __kipc_call(iovs, param_count);
+       if (rc < 0)
+               return rc;
+
+       return 0;
+}
+
 static void drop_data(struct nlmsghdr *nlh)
 {
        int ev_size;
@@ -1163,6 +1232,7 @@ struct iscsi_ipc nl_ipc = {
        .read                   = kread,
        .recv_pdu_begin         = krecv_pdu_begin,
        .recv_pdu_end           = krecv_pdu_end,
+       .set_net_config         = kset_net_config,
 };
 struct iscsi_ipc *ipc = &nl_ipc;

--
1.7.1


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

