From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [RFC-V2 PATCH] iscsiadm: Add netconfig support in iscsiadm
 and iscsid
Date: Sun, 1 May 2011 16:48:36 -0700
Message-ID: <1304293717.3737.80.camel@ltirv-waie-lx1>
References: <1301769339-30008-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1384 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab1EAXs4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 May 2011 19:48:56 -0400
In-Reply-To: <1301769339-30008-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "vikas.chaudhary@qlogic.com" <vikas.chaudhary@qlogic.com>, "lalit.chandivade@qlogic.com" <lalit.chandivade@qlogic.com>, "ravi.anand@qlogic.com" <ravi.anand@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Hello Vikas,

The patch looks good but I have a few questions/comments in relation to
the general scheme of setting these iface net parameters:

1.  As far as I understand, each iface file of the same hw must now
incorporate an unique iface_num which will be used to key off the
corresponding iface settings in the transport.  Iscsiadm will send a
UEVENT along with the net contents to the transport only when it is
explicitly asked to apply the update via the command line.  Perhaps it
would be beneficial to have the initiator apply the changes implicitly
like how it is currently making the call to the
iscsi_host_set_net_params just prior to all the ep_connect calls.  This
will allow the current iface parameters to be set for the corresponding
ep_connect call.

2. In the qla4xxx code changes, it looks like each Scsi_Host is only
allowing 1 IPv4 and 2 IPv6 addresses to the applied to the HBA.  This is
conceivable as each interface can only assume that number of addresses.
But in the case of VLANs, how do you handle the case when the VLANs
assume different IP addresses and subnets when they are based off of the
same HBA?

This can be resolved easily if we have a direct reference to the iface
parameters upon the ep_connect call.  Perhaps embed this info (or
iface_num) to the Scsi_Host struct?  Or just do as proposed in (1).

3. Its probably a good idea to bump the ISCSI_UEVENT_MAX #define since
the netlink.c in the initiator uses it to error out undefined events.
>         ISCSI_UEVENT_PATH_UPDATE        = UEVENT_BASE + 20,
> +       ISCSI_UEVENT_SET_NET_CONFIG     = UEVENT_BASE + 21,
> 
>         ISCSI_UEVENT_MAX                = ISCSI_UEVENT_PATH_UPDATE,
+       ISCSI_UEVENT_MAX                = ISCSI_UEVENT_SET_NET_CONFIG,
> 

4. Although the newly defined "set_net_config" to the iscsi_transport
structure in the driver is a new augmentation, its interesting that the
iscsi_transport_template in the initiator already has a "set_net_config"
entry which is currently used for uip_broadcast_params.  We probably
should change the name of one of them.

Thanks,
Eddie wai

On Sat, 2011-04-02 at 11:35 -0700, vikas.chaudhary@qlogic.com wrote:
> From: Lalit Chandivade <lalit.chandivade@qlogic.com>
> 
> 1. Current status:
> Using iscsiadm one cannot do any network configuration for qla4xxx adapters.
> However an iface is created for the qla4xxx ports using the hwaddress.
> 
> \# ls /etc/iscsi/ifaces/
> iface.example  iface0  qla4xxx.00:0e:1e:04:8b:2a  qla4xxx.00:0e:1e:04:8b:2e
> This allows user to issue sendtargets via the qla4xxx iscsi offload.
> 
> 2. Current Proposal:
> Current proposal is to allow iscsiadm to configure the network settings for qla4xxx ports.
> 
> This implementation is based on discussions at
> http://marc.info/?l=linux-scsi&m=127066184916180&w=2
> http://groups.google.com/group/open-iscsi/browse_thread/thread/d8e8c2df71c95d69/8f731d95d46141a0?lnk=gst&q=iscsi+hba#
> 
> 2.1 Changes in iscsiadm/iscsid
> 
> 2.1.1 Add a new event: ISCSI_UEVENT_SET_NET_CONFIG
> 
> 2.1.2 New structure to represent a single network parameter
> /* iSCSI network params */
> enum iscsi_net_param_type {
>         ISCSI_NET_PARAM_IPV4_ADDR       = 1,
>         ISCSI_NET_PARAM_IPV4_SUBNET     = 2,
>         ISCSI_NET_PARAM_IPV4_GW         = 3,
>         ISCSI_NET_PARAM_IPV4_BOOTPROTO  = 4,
>         ISCSI_NET_PARAM_VLAN            = 5,
>         ISCSI_NET_PARAM_MAC             = 6,
>         ISCSI_NET_PARAM_IPV6_LINKLOCAL  = 7,
>         ISCSI_NET_PARAM_IPV6_ADDR       = 8,
>         ISCSI_NET_PARAM_IPV6_ROUTER     = 9,
>         ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG       = 10,
>         ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG  = 11,
>         ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG     = 12,
>         ISCSI_NET_PARAM_IFACE_STATE     = 13,
> };
> 
> struct iscsi_net_param {
>         uint32_t param_type;    /* enum iscsi_net_param */
>         uint32_t iface_type;    /* IPv4 or IPv6 */
>         uint32_t iface_num;     /* iface number, 0 - n */
>         uint32_t length;        /* Actual length of the param */
>         uint8_t value[0];       /* legnth sized value follows */
> } __attribute__((packed));
> 
> 2.1.3 New parameters in iface
> Added following params:-
> 
>  typedef struct iface_rec {
>         struct list_head        list;
>         /* iscsi iface record name */
>         char                    name[ISCSI_MAX_IFACE_LEN];
> +       char                    iface_num[ISCSI_MAX_STR_LEN];
>         /* network layer iface name (eth0) */
>         char                    netdev[IFNAMSIZ];
>         char                    ipaddress[NI_MAXHOST];
> +       char                    subnet_mask[NI_MAXHOST];
> +       char                    gateway[NI_MAXHOST];
> +       char                    bootproto[ISCSI_MAX_STR_LEN];
> +       char                    ipv6_linklocal[NI_MAXHOST];
> +       char                    ipv6_router[NI_MAXHOST];
> +       char                    ipv6_autocfg[NI_MAXHOST];
> +       char                    linklocal_autocfg[NI_MAXHOST];
> +       char                    router_autocfg[NI_MAXHOST];
> +       char                    vlan[ISCSI_MAX_STR_LEN];
> +       char                    state[ISCSI_MAX_STR_LEN]; /* 0 = disable,
> +                                                          * 1 = enable */
> 
> 2.1.4 Change in operations
> Add two new operations to iscsiadm
> apply: Apply the single iface settings
> applyall: Apply the iface settings of all iface having the same MAC address
> 
> 2.2 Changes in sysfs network representation The new sysfs directory would look like this:-
> /sys/class/iscsi_iface/
> |
> |- ipv4-iface-<host_no>-<iface_no>/                             <-- for ipv4
>                                 |- ipaddress
>                                 |- subnet
>                                 |- gateway
>                                 |- bootproto
>                                 |- state
> |- ipv6-iface-<host_no>-<iface_no>/                             <-- for ipv6
>                                 |- ipaddress
>                                 |- link_local_addr
>                                 |- router_addr
>                                 |- ipaddr_autocfg
>                                 |- linklocal_autocfg
>                                 |- state
> 
> 3. Flow:
> 3.1 User space code:
>             - If user specify --op=update, then just update the iface config file
>             - If use specify --op=applyall then read ifaces having the same hwaddress
>               and build up the net config buffer.
>             - Note: If --op is "apply" then only settings for single iface is read,
>               the iface provided with -I option is only read.
>             - The net config buffer will look like this.
>         ----------------------------------------------------------------|
>         | iscsi_net_param {                                             |
>         |  param = ISCSI_NET_PARAM_IPV4_ADDR;                           |
>         |  iface_num = 0;                                               |
>         |  length = 4                                                   |
>         |  offset = 0;                                                  |
>         |  value[0] = ipaddress[0];                                     |
>         |  value[1] = ipaddress[1];                                     |
>         |  value[2] = ipaddress[2];                                     |
>         |  value[3] = ipaddress[3];                                     |
>         | }                                                             |
>         ----------------------------------------------------------------|
>         |  iscsi_net_param {                                            |
>         |  param = ISCSI_NET_PARAM_IPV4_GW;                             |
>         |  iface_num = 0;                                               |
>         |  length = 4                                                   |
>         |  offset = 0;                                                  |
>         |  value[0] = ipgateway[0];                                     |
>         |  value[1] = ipgateway[1];                                     |
>         |  value[2] = ipgateway[2];                                     |
>         |  value[3] = ipgateway[3];                                     |
>         | }                                                             |
>         -----------------------------------------------------------------
>         |                                                               |
>         | iscsi_net_param {                                             |
>         |  param = ISCSI_NET_PARAM_IPV4_ADDR;                           |
>         |  iface_num = 1;                                               |
>         |  length = 4                                                   |
>         |  offset = 0;                                                  |
>         |  value[0] = ipaddress[0];                                     |
>         |  value[1] = ipaddress[1];                                     |
>         |  value[2] = ipaddress[2];                                     |
>         |  value[3] = ipaddress[3];                                     |
>         | }                                                             |
>         -----------------------------------------------------------------
>         | iscsi_net_param {                                             |
>         |  param = ISCSI_NET_PARAM_IPV4_GW;                             |
>         |  iface_num = 1;                                               |
>         |  length = 4                                                   |
>         |  offset = 0;                                                  |
>         |  value[0] = ipgateway[0];                                     |
>         |  value[1] = ipgateway[1];                                     |
>         |  value[2] = ipgateway[2];                                     |
>         |  value[3] = ipgateway[3];                                     |
>         | }                                                             |
>         -----------------------------------------------------------------
>         | iscsi_net_param {                                             |
>         |  param = ISCSI_NET_PARAM_NET_STATE;                           |
>         |  iface_num = 1;                                               |
>         |  length = 1                                                   |
>         |  offset = 0;                                                  |
>         |  value[0] = 0; /* 0 = disable, default = 1 = enable           |
>         | }                                                             |
>         -----------------------------------------------------------------
> 
> Each netconfig parameter has different size requirement for value field.
> 
> e.g.: IPv4 address requires 4 bytes, IPv6 address requires 16 bytes etc.
> 
>         The memory allocated for each netconfig parameter is sizeof
>         iscsi_net_param + length required for that parameter.
> 
>         The multiple IO Vector mechanism is used to send netconfig
>         parameter from user space to kernel using Netlink interface.
> 
>         IO Vector 0 is used for Netlink message header.
> 
>         IO Vector 1 is used for iSCSI User Event (ev).
>         - The ev will be sent down with event type = ISCSI_UEVENT_SET_NET_CONFIG
> 
>         IO Vector 2 onwards, each vector consists of the struct iscsi_net_param
>         with parameter name followed by its value.
> 
>         The total size will be addition of all the IO vector sizes.
> 
> 3.2 Kernel space code:
>         - Once event is received, the buffer will look like struct iscsi_net_param
>           with parameter name followed by its value, then next parameter and
>           its value and so on.
>         - the scsi_transpor_iscsi would call the adapter's transport->set_net_config
>         - In set_net_config each individual param can be decoded and set into the
>           hardware.
> 
> 4. qla4xxx configuration:
>         iscsid, creates the iface for qla4xxx, based on the hwaddress. To display
>         the iface related to qla4xxx execute following
>            # iscsiadm -m iface
>                qla4xxx.00:0e:1e:04:8b:2e qla4xxx,00:0e:1e:04:8b:2e,<empty>,<empty>,<empty>
>                qla4xxx.00:0e:1e:04:8b:2e.ipv6 qla4xxx,00:0e:1e:04:8b:2e,<empty>,<empty>,<empty>
>                qla4xxx.00:0e:1e:04:8b:2a qla4xxx,00:0e:1e:04:8b:2a,20.15.0.66,<empty>,<empty>
>                qla4xxx.00:0e:1e:04:8b:2a.ipv6
>                qla4xxx,00:0e:1e:04:8b:2a,2001:DB8:1111:2222::8888,<empty>,<empty>
>                qla4xxx.00:0e:1e:04:8b:2a.ipv6.1
>                qla4xxx,00:0e:1e:04:8b:2a,2001:DB8:4444:5555::9999,<empty>,<empty>
> 
> To setup network configuration there can be two methods 4. 1. User can manually
> modify the iface file, and issue an "apply" command.
> ---------------------------------------------------------------------------
> iface.example  iface0  qla4xxx.00:0e:1e:04:8b:2a  qla4xxx.00:0e:1e:04:8b:2e
> 
>             Example:
>             iface.ipaddress = 192.168.2.2 (decimal)
>             iface.iface_num = 0 (default)
>             iface.subnetmask = 255.255.255.0 (decimal)
>             iface.vlan = 0x1022 (hex)
> 
>             # vi qla4xxx.00:0e:1e:04:8b:2a.ipv6
>             If file does not exisit the one can create it.
>             iface.ipaddress =  1111:2222::7777:8888 (hex)
>             iface.iface_num = 0
>             iface.vlan = 0x1022 (hex)
> 
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a --op=applyall
>             This will read the iface config file and apply the settings to the
>             hardware.
>             Note, this will read all the iface belonging to the same MAC address.
> 
> 4.2. User can use iscsiadm to specify the values and then apply
> --------------------------------------------------------------
>             # ls /etc/iscsi/ifaces/
> iface.example  iface0  qla4xxx.00:0e:1e:04:8b:2a  qla4xxx.00:0e:1e:04:8b:2e
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
>                -n iface.ipaddress -v 192.168.1.2
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
>                            -n iface.gateway -v 192.168.1.1
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
>                            -n iface.subnet_mask -v 255.255.255.0
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o applyall
> 
>             Setting up multiple IP:
>             First interface (default, no need to set iface_num, it is 0 by default)
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
>                            -n iface.ipaddress -v 192.168.1.2
>             Create the second one if it does not exist
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a.1 -op=new
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
>                            -n iface.iface_num -v 1 (Mandatory)
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a -o update \
>                            -n iface.ipaddress -v 192.168.1.3
>             # iscsiadm -m iface -I qla4xxx.00:0e:1e:04:8b:2a --op=applyall
> 
>             Note: If there are common settings for multiple interfaces then the
>             settings from 0th iface would be considered valid.
> 
>             Note: To apply settings for a single iface, just say --op=apply
> 
> Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
> ---
>  include/iscsi_if.h |   54 +++++
>  usr/config.h       |   13 ++
>  usr/idbm.c         |   16 ++
>  usr/idbm_fields.h  |    7 +
>  usr/iface.c        |  559 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  usr/iface.h        |    4 +
>  usr/iscsi_ipc.h    |    3 +
>  usr/iscsiadm.c     |  108 ++++++++++-
>  usr/netlink.c      |  168 +++++++++++-----
>  9 files changed, 882 insertions(+), 50 deletions(-)
> 
> diff --git a/include/iscsi_if.h b/include/iscsi_if.h
> index 50a09cb..99443a9 100644
> --- a/include/iscsi_if.h
> +++ b/include/iscsi_if.h
> @@ -64,6 +64,7 @@ enum iscsi_uevent_e {
>         ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST  = UEVENT_BASE + 19,
> 
>         ISCSI_UEVENT_PATH_UPDATE        = UEVENT_BASE + 20,
> +       ISCSI_UEVENT_SET_NET_CONFIG     = UEVENT_BASE + 21,
> 
>         ISCSI_UEVENT_MAX                = ISCSI_UEVENT_PATH_UPDATE,
> 
> @@ -181,6 +182,10 @@ struct iscsi_uevent {
>                 struct msg_set_path {
>                         uint32_t        host_no;
>                 } set_path;
> +               struct msg_set_net_config {
> +                       uint32_t        host_no;
> +                       uint32_t        count;
> +               } set_net_config;
>         } u;
>         union {
>                 /* messages k -> u */
> @@ -246,6 +251,55 @@ struct iscsi_path {
>         uint16_t        pmtu;
>  } __attribute__ ((aligned (sizeof(uint64_t))));
> 
> +#define        ISCSI_BOOTPROTO_STATIC          0x0
> +#define        ISCSI_BOOTPROTO_DHCP            0x1
> +
> +/* ipv6 addr autoconfig type */
> +#define ISCSI_IPV6_AUTOCFG_DISABLE             0x01
> +#define ISCSI_IPV6_AUTOCFG_ND_ENABLE           0x02
> +#define ISCSI_IPV6_AUTOCFG_DHCPV6_ENABLE       0x03
> +
> +/* ipv6 link local addr type */
> +#define ISCSI_IPV6_LINKLOCAL_AUTOCFG_ENABLE    0x01
> +#define ISCSI_IPV6_LINKLOCAL_AUTOCFG_DISABLE   0x02
> +
> +/* ipv6 router addr type */
> +#define ISCSI_IPV6_ROUTER_AUTOCFG_ENABLE       0x01
> +#define ISCSI_IPV6_ROUTER_AUTOCFG_DISABLE      0x02
> +
> +/* iSCSI network params */
> +enum iscsi_net_param_type {
> +       ISCSI_NET_PARAM_IPV4_ADDR       = 1,
> +       ISCSI_NET_PARAM_IPV4_SUBNET     = 2,
> +       ISCSI_NET_PARAM_IPV4_GW         = 3,
> +       ISCSI_NET_PARAM_IPV4_BOOTPROTO  = 4,
> +       ISCSI_NET_PARAM_VLAN            = 5,
> +       ISCSI_NET_PARAM_MAC             = 6,
> +       ISCSI_NET_PARAM_IPV6_LINKLOCAL  = 7,
> +       ISCSI_NET_PARAM_IPV6_ADDR       = 8,
> +       ISCSI_NET_PARAM_IPV6_ROUTER     = 9,
> +       ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG       = 10,
> +       ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG  = 11,
> +       ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG     = 12,
> +       ISCSI_NET_PARAM_IFACE_STATE     = 13,
> +};
> +
> +/* 20 param per iface * 10 iface per port = 200 params */
> +#define        ISCSI_MAX_IFACE_PER_HW          10
> +#define        ISCSI_MAX_PARAM_PER_IFACE       20
> +#define        ISCSI_MAX_NET_PARAMS            (ISCSI_MAX_IFACE_PER_HW * \
> +                                       ISCSI_MAX_PARAM_PER_IFACE)
> +
> +#define        IFACE_TYPE_IPV4                 0x01
> +#define        IFACE_TYPE_IPV6                 0x02
> +struct iscsi_net_param {
> +       uint32_t param_type;    /* enum iscsi_net_param */
> +       uint32_t iface_type;    /* IPv4 or IPv6 */
> +       uint32_t iface_num;     /* iface number, 0 - n */
> +       uint32_t length;        /* Actual length of the param */
> +       uint8_t value[0];       /* legnth sized value follows */
> +} __attribute__((packed));
> +
>  /*
>   * Common error codes
>   */
> diff --git a/usr/config.h b/usr/config.h
> index 5cb4d56..be5914a 100644
> --- a/usr/config.h
> +++ b/usr/config.h
> @@ -196,14 +196,27 @@ typedef struct session_rec {
>  } session_rec_t;
> 
>  #define ISCSI_TRANSPORT_NAME_MAXLEN 16
> +#define        ISCSI_MAX_STR_LEN       80
> 
>  typedef struct iface_rec {
>         struct list_head        list;
>         /* iscsi iface record name */
>         char                    name[ISCSI_MAX_IFACE_LEN];
> +       unsigned int            iface_num;
>         /* network layer iface name (eth0) */
>         char                    netdev[IFNAMSIZ];
>         char                    ipaddress[NI_MAXHOST];
> +       char                    subnet_mask[NI_MAXHOST];
> +       char                    gateway[NI_MAXHOST];
> +       char                    bootproto[ISCSI_MAX_STR_LEN];
> +       char                    ipv6_linklocal[NI_MAXHOST];
> +       char                    ipv6_router[NI_MAXHOST];
> +       char                    ipv6_autocfg[NI_MAXHOST];
> +       char                    linklocal_autocfg[NI_MAXHOST];
> +       char                    router_autocfg[NI_MAXHOST];
> +       char                    vlan[ISCSI_MAX_STR_LEN];
> +       char                    state[ISCSI_MAX_STR_LEN]; /* 0 = disable,
> +                                                          * 1 = enable */
>         /*
>          * TODO: we may have to make this bigger and interconnect
>          * specific for infinniband
> diff --git a/usr/idbm.c b/usr/idbm.c
> index a73b410..a7fb793 100644
> --- a/usr/idbm.c
> +++ b/usr/idbm.c
> @@ -370,6 +370,22 @@ void idbm_recinfo_iface(iface_rec_t *r, recinfo_t *ri)
>         __recinfo_str(IFACE_TRANSPORTNAME, ri, r, transport_name,
>                       IDBM_SHOW, num, 1);
>         __recinfo_str(IFACE_INAME, ri, r, iname, IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_BOOT_PROTO, ri, r, bootproto, IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_SUBNET_MASK, ri, r, subnet_mask,
> +                     IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_GATEWAY, ri, r, gateway, IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_IPV6_AUTOCFG, ri, r, ipv6_autocfg,
> +                     IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_LINKLOCAL_AUTOCFG, ri, r, linklocal_autocfg,
> +                     IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_ROUTER_AUTOCFG, ri, r, router_autocfg,
> +                     IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_LINKLOCAL, ri, r, ipv6_linklocal,
> +                     IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_ROUTER, ri, r, ipv6_router, IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_STATE, ri, r, state, IDBM_SHOW, num, 1);
> +       __recinfo_str(IFACE_VLAN, ri, r, vlan, IDBM_SHOW, num, 1);
> +       __recinfo_int(IFACE_NUM, ri, r, iface_num, IDBM_SHOW, num, 1);
>  }
> 
>  recinfo_t *idbm_recinfo_alloc(int max_keys)
> diff --git a/usr/idbm_fields.h b/usr/idbm_fields.h
> index eaa55d1..33019bb 100644
> --- a/usr/idbm_fields.h
> +++ b/usr/idbm_fields.h
> @@ -76,6 +76,13 @@
>  #define IFACE_PRIMARY_DNS      "iface.primary_dns"
>  #define IFACE_SEC_DNS          "iface.secondary_dns"
>  #define IFACE_VLAN             "iface.vlan"
> +#define        IFACE_LINKLOCAL         "iface.ipv6_linklocal"
> +#define        IFACE_ROUTER            "iface.ipv6_router"
> +#define        IFACE_IPV6_AUTOCFG      "iface.ipv6_autocfg"
> +#define        IFACE_LINKLOCAL_AUTOCFG "iface.linklocal_autocfg"
> +#define        IFACE_ROUTER_AUTOCFG    "iface.router_autocfg"
> +#define        IFACE_STATE             "iface.state"
> +#define        IFACE_NUM               "iface.iface_num"
> 
>  /* discovery fields */
>  #define DISC_STARTUP           "discovery.startup"
> diff --git a/usr/iface.c b/usr/iface.c
> index 8a1683b..2e1a0af 100644
> --- a/usr/iface.c
> +++ b/usr/iface.c
> @@ -26,6 +26,7 @@
>  #include <unistd.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> +#include <arpa/inet.h>
> 
>  #include "log.h"
>  #include "list.h"
> @@ -885,3 +886,561 @@ fail:
>         }
>         return rc;
>  }
> +
> +struct iface_param_count {
> +       struct iface_rec *primary;
> +       int count;
> +};
> +
> +/**
> + * __iface_get_param_count - Gets netconfig parameter count from iface
> + * @data: iface_param_count structure
> + * @iface: iface t setup
> + *
> + */
> +static int __iface_get_param_count(void *data, struct iface_rec *iface)
> +{
> +       struct iface_param_count *iface_params = data;
> +       int iptype = IFACE_TYPE_IPV4;
> +       int count = 0;
> +
> +       if (strcmp(iface_params->primary->hwaddress, iface->hwaddress))
> +               return 0;
> +
> +       if (iface_params->count > ISCSI_MAX_NET_PARAMS)
> +               return 1;
> +
> +       if (strcmp(iface->bootproto, "dhcp") && !strstr(iface->ipaddress, "."))
> +               iptype = IFACE_TYPE_IPV6;
> +
> +       if (iptype == IFACE_TYPE_IPV4) {
> +
> +               if (strcmp(iface->state, "disable")) {
> +                       if (strstr(iface->bootproto, "dhcp"))
> +                               count++;        /* count for dhcp enable */
> +                       else {
> +                               count++;        /* count for dhcp disable */
> +                               if (strstr(iface->ipaddress, ".")) {
> +                                       count++;        /* count for ipaddr */
> +                                       if (strstr(iface->subnet_mask, "."))
> +                                               count++; /* count for subnet */
> +                                       if (strstr(iface->gateway, "."))
> +                                               count++; /* count for gateway */
> +                               } else  /* IP addr not valid, decrement count */
> +                                       count--;
> +                       }
> +
> +                       /* if any valid IPV4 configuration in iface file
> +                        * enable state */
> +                       if (count)
> +                               count++;        /* count for iface state */
> +               } else  /* IPV4 is disable */
> +                       count++;        /* count for iface state */
> +
> +       } else if (iptype == IFACE_TYPE_IPV6) {
> +
> +               if (strcmp(iface->state, "disable")) {
> +
> +                       /* IPV6 Address */
> +                       if (strstr(iface->ipv6_autocfg, "nd") ||
> +                           strstr(iface->ipv6_autocfg, "dhcpv6"))
> +                               count++;        /* count for autocfg */
> +                       else {
> +                               count++;        /* count for autocfg */
> +                               if (strstr(iface->ipaddress, ":"))
> +                                       count++;    /* count for IPV6 Addr */
> +                               else
> +                                       count--;    /* as IPV6 not valid
> +                                                    * decrement count for
> +                                                    * autocfg */
> +                       }
> +
> +                       /* IPV6 linklocal address */
> +                       if (strstr(iface->linklocal_autocfg, "auto"))
> +                               count++;
> +                       else {
> +                               count++;
> +                               if (strstr(iface->ipv6_linklocal, ":"))
> +                                       count++;
> +                               else
> +                                       count--;
> +                       }
> +
> +                       /* IPV6 router address */
> +                       if (strstr(iface->router_autocfg, "auto"))
> +                               count++;
> +                       else {
> +                               count++;
> +                               if (strstr(iface->ipv6_router, ":"))
> +                                       count++;
> +                               else
> +                                       count--;
> +                       }
> +
> +                       if (count)
> +                               count++;
> +               } else
> +                       count++;
> +       }
> +
> +       iface_params->count += count;
> +       return 0;
> +}
> +
> +int iface_get_param_count(struct iface_rec *iface, int iface_all)
> +{
> +       int num_found = 0, rc;
> +       struct iface_param_count iface_params;
> +
> +       log_debug(8, "In iface_get_param_count\n");
> +
> +       iface_params.primary = iface;
> +       iface_params.count = 0;
> +
> +       if (iface_all)
> +               rc = iface_for_each_iface(&iface_params, 0, &num_found,
> +                   __iface_get_param_count);
> +       else
> +               rc = __iface_get_param_count(&iface_params, iface);
> +
> +       log_debug(8, "iface_get_param_count: rc = %d, count = %d\n",
> +            rc, iface_params.count);
> +       return iface_params.count;
> +}
> +
> +/* Network state: disable/enable */
> +static inline int __iface_fill_net_state(struct iovec *iov,
> +                                        struct iface_rec *iface,
> +                                        uint32_t iface_type)
> +{
> +       int len;
> +       struct iscsi_net_param *net_param;
> +
> +       len = sizeof(struct iscsi_net_param) + 1;
> +       iov->iov_base = calloc(len, sizeof(char));
> +       if (!(iov->iov_base))
> +               return 1;
> +
> +       iov->iov_len = len;
> +       net_param = (struct iscsi_net_param *)(iov->iov_base);
> +       net_param->param_type = ISCSI_NET_PARAM_IFACE_STATE;
> +       net_param->iface_type = iface_type;
> +       net_param->iface_num = iface->iface_num;
> +       net_param->length = 1;
> +       if (!strcmp(iface->state, "disable"))
> +               net_param->value[0] = 0;
> +       else /* Assume enabled */
> +               net_param->value[0] = 1;
> +       return 0;
> +}
> +
> +/* Bootproto , need to send down the values as set or not set*/
> +static inline int __iface_fill_net_bootproto(struct iovec *iov,
> +                                            struct iface_rec *iface)
> +{
> +       int len;
> +       struct iscsi_net_param *net_param;
> +
> +       len = sizeof(struct iscsi_net_param) + 1;
> +       iov->iov_base = calloc(len, sizeof(char));
> +       if (!(iov->iov_base))
> +               return 1;
> +
> +       iov->iov_len = len;
> +       net_param = (struct iscsi_net_param *)(iov->iov_base);
> +       net_param->param_type = ISCSI_NET_PARAM_IPV4_BOOTPROTO;
> +       net_param->iface_type = IFACE_TYPE_IPV4;
> +       net_param->iface_num = iface->iface_num;
> +       net_param->length = 1;
> +       if (!strcmp(iface->bootproto, "dhcp"))
> +               net_param->value[0] = ISCSI_BOOTPROTO_DHCP;
> +
> +       return 0;
> +}
> +
> +/* Autocfg */
> +static inline int __iface_fill_net_autocfg(struct iovec *iov,
> +                                          struct iface_rec *iface)
> +{
> +       int len;
> +       struct iscsi_net_param *net_param;
> +
> +       len = sizeof(struct iscsi_net_param) + 1;
> +       iov->iov_base = calloc(len, sizeof(char));
> +       if (!(iov->iov_base))
> +               return 1;
> +
> +       iov->iov_len = len;
> +       net_param = (struct iscsi_net_param *)(iov->iov_base);
> +       net_param->param_type = ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG;
> +       net_param->iface_type = IFACE_TYPE_IPV6;
> +       net_param->length = 1;
> +
> +       if (!strcmp(iface->ipv6_autocfg, "nd"))
> +               net_param->value[0] = ISCSI_IPV6_AUTOCFG_ND_ENABLE;
> +       else if (!strcmp(iface->ipv6_autocfg, "dhcpv6"))
> +               net_param->value[0] = ISCSI_IPV6_AUTOCFG_DHCPV6_ENABLE;
> +       else
> +               net_param->value[0] = ISCSI_IPV6_AUTOCFG_DISABLE;
> +
> +       return 0;
> +}
> +
> +static inline int __iface_fill_linklocal_autocfg(struct iovec *iov,
> +                                          struct iface_rec *iface)
> +{
> +       int len;
> +       struct iscsi_net_param *net_param;
> +
> +       len = sizeof(struct iscsi_net_param) + 1;
> +       iov->iov_base = calloc(len, sizeof(char));
> +       if (!(iov->iov_base))
> +               return 1;
> +
> +       iov->iov_len = len;
> +       net_param = (struct iscsi_net_param *)(iov->iov_base);
> +       net_param->param_type = ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG;
> +       net_param->iface_type = IFACE_TYPE_IPV6;
> +       net_param->length = 1;
> +
> +       if (strstr(iface->linklocal_autocfg, "auto"))
> +               net_param->value[0] = ISCSI_IPV6_LINKLOCAL_AUTOCFG_ENABLE;
> +       else
> +               net_param->value[0] = ISCSI_IPV6_LINKLOCAL_AUTOCFG_DISABLE;
> +
> +       return 0;
> +}
> +
> +static inline int __iface_fill_router_autocfg(struct iovec *iov,
> +                                          struct iface_rec *iface)
> +{
> +       int len;
> +       struct iscsi_net_param *net_param;
> +
> +       len = sizeof(struct iscsi_net_param) + 1;
> +       iov->iov_base = calloc(len, sizeof(char));
> +       if (!(iov->iov_base))
> +               return 1;
> +
> +       iov->iov_len = len;
> +       net_param = (struct iscsi_net_param *)(iov->iov_base);
> +       net_param->param_type = ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG;
> +       net_param->iface_type = IFACE_TYPE_IPV6;
> +       net_param->length = 1;
> +
> +       if (strstr(iface->router_autocfg, "auto"))
> +               net_param->value[0] = ISCSI_IPV6_ROUTER_AUTOCFG_ENABLE;
> +       else
> +               net_param->value[0] = ISCSI_IPV6_ROUTER_AUTOCFG_DISABLE;
> +
> +       return 0;
> +}
> +
> +/* Network IPv4 address: 4 bytes */
> +static inline int __iface_fill_net_ipv4_addr(struct iovec *iov,
> +                                            struct iface_rec *iface,
> +                                            uint32_t param_type)
> +{
> +       int rc = 1;
> +       int len;
> +       struct iscsi_net_param *net_param;
> +
> +       len = sizeof(struct iscsi_net_param) + 4;
> +       iov->iov_base = calloc(len, sizeof(char));
> +       if (!(iov->iov_base))
> +               return 1;
> +
> +       iov->iov_len = len;
> +       net_param = (struct iscsi_net_param *)(iov->iov_base);
> +       net_param->param_type = param_type;
> +       net_param->iface_type = IFACE_TYPE_IPV4;
> +       net_param->iface_num = iface->iface_num;
> +       net_param->length = 4;
> +
> +       switch (param_type) {
> +       case ISCSI_NET_PARAM_IPV4_ADDR:
> +               rc = inet_pton(AF_INET, iface->ipaddress, net_param->value);
> +               if (rc <= 0)
> +                       goto free;
> +               break;
> +       case ISCSI_NET_PARAM_IPV4_SUBNET:
> +               rc = inet_pton(AF_INET, iface->subnet_mask, net_param->value);
> +               if (rc <= 0)
> +                       goto free;
> +               break;
> +       case ISCSI_NET_PARAM_IPV4_GW:
> +               rc = inet_pton(AF_INET, iface->gateway, net_param->value);
> +               if (rc <= 0)
> +                       goto free;
> +               break;
> +       default:
> +               goto free;
> +       }
> +
> +       /* validate */
> +       if (!net_param->value[0] && !net_param->value[1] &&
> +           !net_param->value[2] && !net_param->value[3])
> +               goto free;
> +
> +       return 0;
> +free:
> +       free(iov->iov_base);
> +       iov->iov_base = NULL;
> +       iov->iov_len = 0;
> +       return 1;
> +}
> +
> +/* Network IPv6 address: 16 bytes */
> +static inline int __iface_fill_net_ipv6_addr(struct iovec *iov,
> +                                            struct iface_rec *iface,
> +                                            uint32_t param_type)
> +{
> +       int rc;
> +       int len;
> +       struct iscsi_net_param *net_param;
> +
> +       len = sizeof(struct iscsi_net_param) + 16;
> +       iov->iov_base = calloc(len, sizeof(char));
> +       if (!(iov->iov_base))
> +               return 1;
> +
> +       iov->iov_len = len;
> +       net_param = (struct iscsi_net_param *)(iov->iov_base);
> +       net_param->param_type = param_type;
> +       net_param->iface_type = IFACE_TYPE_IPV6;
> +       net_param->iface_num = iface->iface_num;
> +       net_param->length = 16;
> +
> +       switch (param_type) {
> +       case ISCSI_NET_PARAM_IPV6_ADDR:
> +               rc = inet_pton(AF_INET6, iface->ipaddress, net_param->value);
> +               if (rc <= 0)
> +                       goto free;
> +               break;
> +       case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
> +               rc = inet_pton(AF_INET6, iface->ipv6_linklocal,
> +                   net_param->value);
> +               if (rc <= 0)
> +                       goto free;
> +               break;
> +       case ISCSI_NET_PARAM_IPV6_ROUTER:
> +               rc = inet_pton(AF_INET6, iface->ipv6_router, net_param->value);
> +               if (rc <= 0)
> +                       goto free;
> +               break;
> +       default:
> +               goto free;
> +       }
> +
> +       return 0;
> +free:
> +       free(iov->iov_base);
> +       iov->iov_base = NULL;
> +       iov->iov_len = 0;
> +       return 1;
> +}
> +
> +struct iface_net_config {
> +       struct iface_rec *primary;
> +       struct iovec *iovs;
> +       int count;
> +};
> +
> +static int __iface_build_net_config(void *data, struct iface_rec *iface)
> +{
> +       struct iface_net_config *net_config = data;
> +       struct iovec *iov;
> +       int iptype = IFACE_TYPE_IPV4;
> +       int count = 0;
> +
> +       if (strcmp(net_config->primary->hwaddress, iface->hwaddress))
> +               return 0;
> +
> +       if (net_config->count > ISCSI_MAX_NET_PARAMS)
> +               return 1;
> +
> +       if (strcmp(iface->bootproto, "dhcp") && !strstr(iface->ipaddress, "."))
> +               iptype = IFACE_TYPE_IPV6;
> +
> +       /* start at 2, because 0 is for nlmsghdr and 1 for event */
> +       iov = net_config->iovs + 2;
> +
> +       if (iptype == IFACE_TYPE_IPV4) {
> +
> +               if (strcmp(iface->state, "disable")) {
> +                       if (strstr(iface->bootproto, "dhcp")) {
> +                               if (__iface_fill_net_bootproto(
> +                                   &iov[net_config->count], iface) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                       } else if (strstr(iface->ipaddress, ".")) {
> +                               if (__iface_fill_net_bootproto(
> +                                   &iov[net_config->count], iface) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                               if (__iface_fill_net_ipv4_addr(
> +                                   &iov[net_config->count], iface,
> +                                   ISCSI_NET_PARAM_IPV4_ADDR) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                               if (strstr(iface->subnet_mask, ".")) {
> +                                       if (__iface_fill_net_ipv4_addr(
> +                                           &iov[net_config->count], iface,
> +                                           ISCSI_NET_PARAM_IPV4_SUBNET) == 0) {
> +                                               net_config->count++;
> +                                               count++;
> +                                       }
> +                               }
> +                               if (strstr(iface->gateway, ".")) {
> +                                       if (__iface_fill_net_ipv4_addr(
> +                                           &iov[net_config->count], iface,
> +                                           ISCSI_NET_PARAM_IPV4_GW) == 0) {
> +                                               net_config->count++;
> +                                               count++;
> +                                       }
> +                               }
> +                       }
> +
> +                       /* if ipv4 is enable or ipv4 configuration present
> +                        * in iface file */
> +                       if (count) {
> +                               if (__iface_fill_net_state(
> +                                   &iov[net_config->count], iface,
> +                                   IFACE_TYPE_IPV4) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                       }
> +               } else {
> +                       if (__iface_fill_net_state(&iov[net_config->count],
> +                           iface, IFACE_TYPE_IPV4) == 0) {
> +                               net_config->count++;
> +                               count++;
> +                       }
> +               }
> +
> +       } else if (iptype == IFACE_TYPE_IPV6) {
> +
> +               if (strcmp(iface->state, "disable")) {
> +                       /* for ipv6 addr */
> +                       if (strstr(iface->ipv6_autocfg, "nd") ||
> +                           strstr(iface->ipv6_autocfg, "dhcpv6")) {
> +                               if (__iface_fill_net_autocfg(
> +                                   &iov[net_config->count], iface) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                       } else if (strstr(iface->ipaddress, ":")) {
> +                               if (__iface_fill_net_autocfg(
> +                                   &iov[net_config->count], iface) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                               /* User provided IPv6 Address */
> +                               if (__iface_fill_net_ipv6_addr(
> +                                   &iov[net_config->count],
> +                                   iface, ISCSI_NET_PARAM_IPV6_ADDR) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                       }
> +
> +                       /* for LinkLocal Addr */
> +                       if (strstr(iface->linklocal_autocfg, "auto")) {
> +                               if (__iface_fill_linklocal_autocfg(
> +                                   &iov[net_config->count], iface) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                       } else if (strstr(iface->ipv6_linklocal, ":")) {
> +                               if (__iface_fill_linklocal_autocfg(
> +                                   &iov[net_config->count], iface) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                               /* User provided Link Local Address */
> +                               if (__iface_fill_net_ipv6_addr(
> +                                   &iov[net_config->count], iface,
> +                                   ISCSI_NET_PARAM_IPV6_LINKLOCAL) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                       }
> +
> +                       /* for router address */
> +                       if (strstr(iface->router_autocfg, "auto")) {
> +                               if (__iface_fill_router_autocfg(
> +                                   &iov[net_config->count], iface) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                       } else if (strstr(iface->ipv6_router, ":")) {
> +                               if (__iface_fill_router_autocfg(
> +                                   &iov[net_config->count], iface) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                               /* User provided Router Address */
> +                               if (__iface_fill_net_ipv6_addr(
> +                                   &iov[net_config->count], iface,
> +                                   ISCSI_NET_PARAM_IPV6_ROUTER) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                       }
> +
> +                       /* if ipv6 configuration is present is iface file
> +                        * enable ipv6 state */
> +                       if (count) {
> +                               /* default is enable */
> +                               if (__iface_fill_net_state(
> +                                   &iov[net_config->count], iface,
> +                                   IFACE_TYPE_IPV6) == 0) {
> +                                       net_config->count++;
> +                                       count++;
> +                               }
> +                       }
> +               } else {
> +                       if (__iface_fill_net_state(&iov[net_config->count],
> +                           iface, IFACE_TYPE_IPV6) == 0) {
> +                               net_config->count++;
> +                               count++;
> +                       }
> +               }
> +       }
> +       return 0;
> +}
> +
> +/**
> + * iface_build_net_config - Setup neconfig parameter buffers
> + * @iface: iface to setup
> + * @iface_all: Flag for number of ifaces to traverse (1 for all)
> + * @iovs: iovec buffer for netconfig parameters
> + *
> + * This increaments existing count, caller should initialize count to zero.
> + */
> +int iface_build_net_config(struct iface_rec *iface, int iface_all,
> +                          struct iovec *iovs)
> +{
> +       int num_found = 0, rc;
> +       struct iface_net_config net_config;
> +
> +       log_debug(8, "In iface_build_net_config\n");
> +
> +       net_config.primary = iface;
> +       net_config.iovs = iovs;
> +       net_config.count = 0;
> +
> +       if (iface_all)
> +               rc = iface_for_each_iface(&net_config, 0, &num_found,
> +                   __iface_build_net_config);
> +       else
> +               rc = __iface_build_net_config(&net_config, iface);
> +
> +       log_debug(8, "iface_build_net_config: rc = %d, count = %d\n",
> +            rc, net_config.count);
> +       return net_config.count;
> +}
> diff --git a/usr/iface.h b/usr/iface.h
> index 9f6d47e..3ba2a4e 100644
> --- a/usr/iface.h
> +++ b/usr/iface.h
> @@ -54,6 +54,10 @@ extern int iface_setup_from_boot_context(struct iface_rec *iface,
>                                     struct boot_context *context);
>  extern int iface_create_ifaces_from_boot_contexts(struct list_head *ifaces,
>                                                   struct list_head *targets);
> +extern int iface_get_param_count(struct iface_rec *iface_primary,
> +                                int iface_all);
> +extern int iface_build_net_config(struct iface_rec *iface_primary,
> +                                 int iface_all, struct iovec *iovs);
> 
>  #define iface_fmt "[hw=%s,ip=%s,net_if=%s,iscsi_if=%s]"
>  #define iface_str(_iface) \
> diff --git a/usr/iscsi_ipc.h b/usr/iscsi_ipc.h
> index 93b4917..8df3cdc 100644
> --- a/usr/iscsi_ipc.h
> +++ b/usr/iscsi_ipc.h
> @@ -129,6 +129,9 @@ struct iscsi_ipc {
>         int (*recv_pdu_begin) (struct iscsi_conn *conn);
> 
>         int (*recv_pdu_end) (struct iscsi_conn *conn);
> +
> +       int (*set_net_config) (uint64_t transport_handle, uint32_t host_no,
> +                              struct iovec *iovs, uint32_t param_count);
>  };
> 
>  #endif /* ISCSI_IPC_H */
> diff --git a/usr/iscsiadm.c b/usr/iscsiadm.c
> index 3c8abd2..51f4eea 100644
> --- a/usr/iscsiadm.c
> +++ b/usr/iscsiadm.c
> @@ -49,6 +49,7 @@
>  #include "iscsid_req.h"
>  #include "isns-proto.h"
>  #include "iscsi_err.h"
> +#include "iscsi_ipc.h"
> 
>  static char program_name[] = "iscsiadm";
>  static char config_file[TARGET_NAME_MAXLEN];
> @@ -70,7 +71,9 @@ enum iscsiadm_op {
>         OP_DELETE               = 0x2,
>         OP_UPDATE               = 0x4,
>         OP_SHOW                 = 0x8,
> -       OP_NONPERSISTENT        = 0x10
> +       OP_NONPERSISTENT        = 0x10,
> +       OP_APPLY                = 0x20,
> +       OP_APPLY_ALL            = 0x40
>  };
> 
>  static struct option const long_options[] =
> @@ -138,6 +141,10 @@ str_to_op(char *str)
>                 op = OP_SHOW;
>         else if (!strcmp("nonpersistent", str))
>                 op = OP_NONPERSISTENT;
> +       else if (!strcmp("apply", str))
> +               op = OP_APPLY;
> +       else if (!strcmp("applyall", str))
> +               op = OP_APPLY_ALL;
>         else
>                 op = OP_NOOP;
> 
> @@ -1091,6 +1098,84 @@ static void catch_sigint( int signo ) {
>         exit(1);
>  }
> 
> +static int
> +iface_apply_net_config(struct iface_rec *iface, int op)
> +{
> +       int rc = 1;
> +       uint32_t host_no;
> +       int param_count;
> +       int param_used;
> +       int iface_all = 0;
> +       int i;
> +       struct iovec *iovs = NULL;
> +       struct iovec *iov = NULL;
> +       struct iscsi_transport *t = NULL;
> +       int fd;
> +
> +       log_debug(8, "Calling iscsid, to apply net config for"
> +           "iface.name = %s\n", iface->name);
> +
> +       if (op == OP_APPLY_ALL)
> +               iface_all = 1;
> +
> +       param_count = iface_get_param_count(iface, iface_all);
> +       if (!param_count) {
> +               log_error("%s: Nothing to configure\n", __func__);
> +               return 0;
> +       }
> +
> +       /* +2 for event and nlmsghdr */
> +       iovs = calloc(((param_count + 2) * sizeof(struct iovec)),
> +                       sizeof(char));
> +       if (!iovs) {
> +               log_error("%s: Out of Memory\n", __func__);
> +               return ENOMEM;
> +       }
> +
> +       /* param_used gives actual number of iovecs used for netconfig */
> +       param_used = iface_build_net_config(iface, iface_all, iovs);
> +       if (!param_used) {
> +               log_error("%s: build netconfig failed\n", __func__);
> +               goto free_buf;
> +       }
> +
> +       t = iscsi_sysfs_get_transport_by_name(iface->transport_name);
> +       if (!t) {
> +               log_error("%s: Can't find transport\n", __func__);
> +               goto free_buf;
> +       }
> +
> +       host_no = iscsi_sysfs_get_host_no_from_hwinfo(iface, &rc);
> +       if (host_no == -1) {
> +               log_error("%s: Can't find host_no\n", __func__);
> +               goto free_buf;
> +       }
> +       rc = 1;
> +
> +       fd = ipc->ctldev_open();
> +       if (fd < 0) {
> +               log_error("%s: Netlink open failed\n", __func__);
> +               goto free_buf;
> +       }
> +
> +       rc = ipc->set_net_config(t->handle, host_no, iovs, param_count);
> +       log_debug(8, "iface_apply_net_config rc=%d\n", rc);
> +       ipc->ctldev_close();
> +
> +free_buf:
> +       /* start at 2, because 0 is for nlmsghdr and 1 for event */
> +       iov = iovs + 2;
> +       for (i = 0; i < param_used; i++, iov++) {
> +               if (iov->iov_base)
> +                       free(iov->iov_base);
> +       }
> +
> +       free(iovs);
> +       if (rc)
> +               return EIO;
> +       return 0;
> +}
> +
>  /* TODO: merge iter helpers and clean them up, so we can use them here */
>  static int exec_iface_op(int op, int do_show, int info_level,
>                          struct iface_rec *iface, char *name, char *value)
> @@ -1217,6 +1302,27 @@ update_fail:
>                 log_error("Could not update iface %s: %s",
>                           iface->name, iscsi_err_to_str(rc));
>                 break;
> +       case OP_APPLY:
> +       case OP_APPLY_ALL:
> +               if (!iface) {
> +                       log_error("Apply requires iface.");
> +                       rc = EINVAL;
> +                       break;
> +               }
> +
> +               rc = iface_conf_read(iface);
> +               if (rc) {
> +                       log_error("Could not read iface %s (%d).",
> +                                 iface->name, rc);
> +                       break;
> +               }
> +
> +               /* For each iface where hwaddress match, start filling the
> +                * buffer with iscsi_net_param
> +                */
> +               rc = iface_apply_net_config(iface, op);
> +               printf("%s applied.\n", iface->name);
> +               break;
>         default:
>                 if (!iface || (iface && info_level > 0)) {
>                         if (op == OP_NOOP || op == OP_SHOW)
> diff --git a/usr/netlink.c b/usr/netlink.c
> index c5d8650..3b0f2cf 100644
> --- a/usr/netlink.c
> +++ b/usr/netlink.c
> @@ -155,7 +155,6 @@ kwritev(enum iscsi_uevent_e type, struct iovec *iovp, int count)
>         int i, rc;
>         struct nlmsghdr *nlh;
>         struct msghdr msg;
> -       struct iovec iov;
>         int datalen = 0;
> 
>         log_debug(7, "in %s", __FUNCTION__);
> @@ -164,6 +163,7 @@ kwritev(enum iscsi_uevent_e type, struct iovec *iovp, int count)
>                 datalen += iovp[i].iov_len;
>         }
> 
> +
>         if (xmitbuf && type != ISCSI_UEVENT_SEND_PDU) {
>                 for (i = 0; i < count; i++) {
>                         memcpy(xmitbuf + xmitlen,
> @@ -174,27 +174,25 @@ kwritev(enum iscsi_uevent_e type, struct iovec *iovp, int count)
>         }
> 
>         nlh = nlm_sendbuf;
> -       memset(nlh, 0, NLMSG_SPACE(datalen));
> +       memset(nlh, 0, NLMSG_SPACE(0));
> +
> +       datalen = 0;
> +       for (i = 1; i < count; i++)
> +               datalen += iovp[i].iov_len;
> 
> -       nlh->nlmsg_len = NLMSG_SPACE(datalen);
> +       nlh->nlmsg_len = NLMSG_ALIGN(datalen);
>         nlh->nlmsg_pid = getpid();
>         nlh->nlmsg_flags = 0;
>         nlh->nlmsg_type = type;
> 
> -       datalen = 0;
> -       for (i = 0; i < count; i++) {
> -               memcpy(NLMSG_DATA(nlh) + datalen, iovp[i].iov_base,
> -                      iovp[i].iov_len);
> -               datalen += iovp[i].iov_len;
> -       }
> -       iov.iov_base = (void*)nlh;
> -       iov.iov_len = nlh->nlmsg_len;
> +       iovp[0].iov_base = (void *)nlh;
> +       iovp[0].iov_len = sizeof(*nlh);
> 
>         memset(&msg, 0, sizeof(msg));
>         msg.msg_name= (void*)&dest_addr;
>         msg.msg_namelen = sizeof(dest_addr);
> -       msg.msg_iov = &iov;
> -       msg.msg_iovlen = 1;
> +       msg.msg_iov = iovp;
> +       msg.msg_iovlen = count;
> 
>         do {
>                 /*
> @@ -255,19 +253,15 @@ kwritev(enum iscsi_uevent_e type, struct iovec *iovp, int count)
>   *        cleanup. (Dima)
>   */
>  static int
> -__kipc_call(void *iov_base, int iov_len)
> +__kipc_call(struct iovec *iovp, int count)
>  {
>         int rc, iferr;
> -       struct iovec iov;
> -       struct iscsi_uevent *ev = iov_base;
> +       struct iscsi_uevent *ev = iovp[1].iov_base;
>         enum iscsi_uevent_e type = ev->type;
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> -       iov.iov_base = iov_base;
> -       iov.iov_len = iov_len;
> -
> -       rc = kwritev(type, &iov, 1);
> +       rc = kwritev(type, iovp, count);
> 
>         do {
>                 if ((rc = nlpayload_read(ctrl_fd, (void*)ev,
> @@ -327,6 +321,7 @@ ksendtargets(uint64_t transport_handle, uint32_t host_no, struct sockaddr *addr)
>  {
>         int rc, addrlen;
>         struct iscsi_uevent *ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -348,7 +343,9 @@ ksendtargets(uint64_t transport_handle, uint32_t host_no, struct sockaddr *addr)
>         }
>         memcpy(setparam_buf + sizeof(*ev), addr, addrlen);
> 
> -       rc = __kipc_call(ev, sizeof(*ev) + addrlen);
> +       iov[1].iov_base = ev;
> +       iov[1].iov_len = sizeof(*ev) + addrlen;
> +       rc = __kipc_call(iov, 2);
>         if (rc < 0) {
>                 log_error("sendtargets failed rc%d\n", rc);
>                 return rc;
> @@ -363,6 +360,7 @@ kcreate_session(uint64_t transport_handle, uint64_t ep_handle,
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -383,9 +381,11 @@ kcreate_session(uint64_t transport_handle, uint64_t ep_handle,
>                 ev.u.c_bound_session.ep_handle = ep_handle;
>         }
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         *hostno = ev.r.c_session_ret.host_no;
>         *out_sid = ev.r.c_session_ret.sid;
> @@ -398,6 +398,7 @@ kdestroy_session(uint64_t transport_handle, uint32_t sid)
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -407,9 +408,11 @@ kdestroy_session(uint64_t transport_handle, uint32_t sid)
>         ev.transport_handle = transport_handle;
>         ev.u.d_session.sid = sid;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         return 0;
>  }
> @@ -419,6 +422,7 @@ kunbind_session(uint64_t transport_handle, uint32_t sid)
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -428,9 +432,11 @@ kunbind_session(uint64_t transport_handle, uint32_t sid)
>         ev.transport_handle = transport_handle;
>         ev.u.d_session.sid = sid;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         return 0;
>  }
> @@ -441,6 +447,7 @@ kcreate_conn(uint64_t transport_handle, uint32_t sid,
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -451,7 +458,10 @@ kcreate_conn(uint64_t transport_handle, uint32_t sid,
>         ev.u.c_conn.cid = cid;
>         ev.u.c_conn.sid = sid;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0) {
>                 log_debug(7, "returned %d", rc);
>                 return rc;
>         }
> @@ -468,6 +478,7 @@ kdestroy_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid)
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -478,9 +489,11 @@ kdestroy_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid)
>         ev.u.d_conn.sid = sid;
>         ev.u.d_conn.cid = cid;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         return 0;
>  }
> @@ -491,6 +504,7 @@ kbind_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -503,9 +517,11 @@ kbind_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>         ev.u.b_conn.transport_eph = transport_eph;
>         ev.u.b_conn.is_leading = is_leading;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         *retcode = ev.r.retcode;
> 
> @@ -547,7 +563,7 @@ ksend_pdu_end(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>  {
>         int rc;
>         struct iscsi_uevent *ev;
> -       struct iovec iov;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -561,10 +577,11 @@ ksend_pdu_end(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>                 exit(-EIO);
>         }
> 
> -       iov.iov_base = xmitbuf;
> -       iov.iov_len = xmitlen;
> +       iov[1].iov_base = xmitbuf;
> +       iov[1].iov_len = xmitlen;
> 
> -       if ((rc = __kipc_call(xmitbuf, xmitlen)) < 0)
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 goto err;
>         if (ev->r.retcode) {
>                 *retcode = ev->r.retcode;
> @@ -594,6 +611,7 @@ kset_host_param(uint64_t transport_handle, uint32_t host_no,
>         struct iscsi_uevent *ev;
>         char *param_str;
>         int rc, len;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -620,9 +638,11 @@ kset_host_param(uint64_t transport_handle, uint32_t host_no,
>         }
>         ev->u.set_host_param.len = len = strlen(param_str) + 1;
> 
> -       if ((rc = __kipc_call(ev, sizeof(*ev) + len)) < 0) {
> +       iov[1].iov_base = ev;
> +       iov[1].iov_len = sizeof(*ev) + len;
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         return 0;
>  }
> @@ -634,6 +654,7 @@ kset_param(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>         struct iscsi_uevent *ev;
>         char *param_str;
>         int rc, len;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -661,9 +682,11 @@ kset_param(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>         }
>         ev->u.set_param.len = len = strlen(param_str) + 1;
> 
> -       if ((rc = __kipc_call(ev, sizeof(*ev) + len)) < 0) {
> +       iov[1].iov_base = ev;
> +       iov[1].iov_len = sizeof(*ev) + len;
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         return 0;
>  }
> @@ -673,6 +696,7 @@ kstop_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid, int flag)
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -684,9 +708,11 @@ kstop_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid, int flag)
>         ev.u.stop_conn.cid = cid;
>         ev.u.stop_conn.flag = flag;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         return 0;
>  }
> @@ -697,6 +723,7 @@ kstart_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -707,9 +734,11 @@ kstart_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>         ev.u.start_conn.sid = sid;
>         ev.u.start_conn.cid = cid;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         *retcode = ev.r.retcode;
>         return 0;
> @@ -774,6 +803,7 @@ ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
>         int rc, addrlen;
>         struct iscsi_uevent *ev;
>         struct sockaddr *dst_addr = (struct sockaddr *)&conn->saddr;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -801,7 +831,10 @@ ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
>         }
>         memcpy(setparam_buf + sizeof(*ev), dst_addr, addrlen);
> 
> -       if ((rc = __kipc_call(ev, sizeof(*ev) + addrlen)) < 0)
> +       iov[1].iov_base = ev;
> +       iov[1].iov_len = sizeof(*ev) + addrlen;
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> 
>         if (!ev->r.ep_connect_ret.handle)
> @@ -819,6 +852,7 @@ ktransport_ep_poll(iscsi_conn_t *conn, int timeout_ms)
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -829,7 +863,10 @@ ktransport_ep_poll(iscsi_conn_t *conn, int timeout_ms)
>         ev.u.ep_poll.ep_handle  = conn->transport_ep_handle;
>         ev.u.ep_poll.timeout_ms = timeout_ms;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0)
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> 
>         return ev.r.retcode;
> @@ -840,6 +877,7 @@ ktransport_ep_disconnect(iscsi_conn_t *conn)
>  {
>         int rc;
>         struct iscsi_uevent ev;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -852,7 +890,10 @@ ktransport_ep_disconnect(iscsi_conn_t *conn)
>         ev.transport_handle = conn->session->t->handle;
>         ev.u.ep_disconnect.ep_handle = conn->transport_ep_handle;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0) {
>                 log_error("connnection %d:%d transport disconnect failed for "
>                           "ep %" PRIu64 " with error %d.", conn->session->id,
>                           conn->id, conn->transport_ep_handle, rc);
> @@ -869,6 +910,7 @@ kget_stats(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>         struct iscsi_uevent ev;
>         char nlm_ev[NLMSG_SPACE(sizeof(struct iscsi_uevent))];
>         struct nlmsghdr *nlh;
> +       struct iovec iov[2];
> 
>         log_debug(7, "in %s", __FUNCTION__);
> 
> @@ -879,9 +921,11 @@ kget_stats(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>         ev.u.get_stats.sid = sid;
>         ev.u.get_stats.cid = cid;
> 
> -       if ((rc = __kipc_call(&ev, sizeof(ev))) < 0) {
> +       iov[1].iov_base = &ev;
> +       iov[1].iov_len = sizeof(ev);
> +       rc = __kipc_call(iov, 2);
> +       if (rc < 0)
>                 return rc;
> -       }
> 
>         if ((rc = nl_read(ctrl_fd, nlm_ev,
>                 NLMSG_SPACE(sizeof(struct iscsi_uevent)), MSG_PEEK)) < 0) {
> @@ -907,6 +951,31 @@ kget_stats(uint64_t transport_handle, uint32_t sid, uint32_t cid,
>         return 0;
>  }
> 
> +static int
> +kset_net_config(uint64_t transport_handle, uint32_t host_no,
> +               struct iovec *iovs, uint32_t param_count)
> +{
> +       struct iscsi_uevent ev;
> +       int rc, ev_len;
> +       struct iovec *iov = iovs + 1;
> +
> +       log_debug(8, "in %s", __FUNCTION__);
> +
> +       ev_len = sizeof(ev);
> +       ev.type = ISCSI_UEVENT_SET_NET_CONFIG;
> +       ev.transport_handle = transport_handle;
> +       ev.u.set_net_config.host_no = host_no;
> +       ev.u.set_net_config.count = param_count;
> +
> +       iov->iov_base = &ev;
> +       iov->iov_len = ev_len;
> +       rc = __kipc_call(iovs, (param_count + 2));
> +       if (rc < 0)
> +               return rc;
> +
> +       return 0;
> +}
> +
>  static void drop_data(struct nlmsghdr *nlh)
>  {
>         int ev_size;
> @@ -1151,6 +1220,7 @@ struct iscsi_ipc nl_ipc = {
>         .read                   = kread,
>         .recv_pdu_begin         = krecv_pdu_begin,
>         .recv_pdu_end           = krecv_pdu_end,
> +       .set_net_config         = kset_net_config,
>  };
>  struct iscsi_ipc *ipc = &nl_ipc;
> 
> --
> 1.7.3.2
> 
> --
> You received this message because you are subscribed to the Google Groups "open-iscsi" group.
> To post to this group, send email to open-iscsi@googlegroups.com.
> To unsubscribe from this group, send email to open-iscsi+unsubscribe@googlegroups.com.
> For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
> 
> 


