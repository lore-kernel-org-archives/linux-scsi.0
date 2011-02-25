From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/5] qla4xxx: Added new "struct ipaddress_config"
Date: Fri, 25 Feb 2011 03:07:05 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8722624A355@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:13143
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932517Ab1BYLHT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 06:07:19 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

- Move all ipaddress related param to "struct ipaddress_config"
  from "struct scsi_qla_host"
- update function - qla4xxx_update_local_ip()

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |   47 ++++++++++++++++-------------
 drivers/scsi/qla4xxx/ql4_init.c |   51 ++++++++++++++++++-------------
 drivers/scsi/qla4xxx/ql4_mbx.c  |   64 ++++++++++++++++++++++-----------------
 drivers/scsi/qla4xxx/ql4_os.c   |    4 +--
 4 files changed, 93 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 2fc0045..67280b5 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -359,6 +359,28 @@ struct isp_operations {
        int (*get_sys_info) (struct scsi_qla_host *);
 };

+/*qla4xxx ipaddress configuration details */
+struct ipaddress_config {
+       uint16_t ipv4_options;
+       uint16_t tcp_options;
+       uint16_t ipv4_vlan_tag;
+       uint8_t ipv4_addr_state;
+       uint8_t ip_address[IP_ADDR_LEN];
+       uint8_t subnet_mask[IP_ADDR_LEN];
+       uint8_t gateway[IP_ADDR_LEN];
+       uint32_t ipv6_options;
+       uint32_t ipv6_addl_options;
+       uint8_t ipv6_link_local_state;
+       uint8_t ipv6_addr0_state;
+       uint8_t ipv6_addr1_state;
+       uint8_t ipv6_default_router_state;
+       uint16_t ipv6_vlan_tag;
+       struct in6_addr ipv6_link_local_addr;
+       struct in6_addr ipv6_addr0;
+       struct in6_addr ipv6_addr1;
+       struct in6_addr ipv6_default_router_addr;
+};
+
 /*
  * Linux Host Adapter structure
  */
@@ -454,10 +476,6 @@ struct scsi_qla_host {
        /* --- From Init_FW --- */
        /* init_cb_t *init_cb; */
        uint16_t firmware_options;
-       uint16_t tcp_options;
-       uint8_t ip_address[IP_ADDR_LEN];
-       uint8_t subnet_mask[IP_ADDR_LEN];
-       uint8_t gateway[IP_ADDR_LEN];
        uint8_t alias[32];
        uint8_t name_string[256];
        uint8_t heartbeat_interval;
@@ -537,22 +555,7 @@ struct scsi_qla_host {
        /* Saved srb for status continuation entry processing */
        struct srb *status_srb;

-       /* IPv6 support info from InitFW */
        uint8_t acb_version;
-       uint8_t ipv4_addr_state;
-       uint16_t ipv4_options;
-
-       uint32_t resvd2;
-       uint32_t ipv6_options;
-       uint32_t ipv6_addl_options;
-       uint8_t ipv6_link_local_state;
-       uint8_t ipv6_addr0_state;
-       uint8_t ipv6_addr1_state;
-       uint8_t ipv6_default_router_state;
-       struct in6_addr ipv6_link_local_addr;
-       struct in6_addr ipv6_addr0;
-       struct in6_addr ipv6_addr1;
-       struct in6_addr ipv6_default_router_addr;

        /* qla82xx specific fields */
        struct device_reg_82xx  __iomem *qla4_8xxx_reg; /* Base I/O address */
@@ -587,16 +590,18 @@ struct scsi_qla_host {
        uint32_t nx_reset_timeout;

        struct completion mbx_intr_comp;
+       struct ipaddress_config ip_config;
 };

 static inline int is_ipv4_enabled(struct scsi_qla_host *ha)
 {
-       return ((ha->ipv4_options & IPOPT_IPv4_PROTOCOL_ENABLE) != 0);
+       return ((ha->ip_config.ipv4_options & IPOPT_IPv4_PROTOCOL_ENABLE) != 0);
 }

 static inline int is_ipv6_enabled(struct scsi_qla_host *ha)
 {
-       return ((ha->ipv6_options & IPV6_OPT_IPV6_PROTOCOL_ENABLE) != 0);
+       return ((ha->ip_config.ipv6_options &
+               IPV6_OPT_IPV6_PROTOCOL_ENABLE) != 0);
 }

 static inline int is_qla4010(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 1629c48..49aca39 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -236,38 +236,44 @@ qla4xxx_wait_for_ip_config(struct scsi_qla_host *ha)
                                    FW_ADDSTATE_DHCPv4_LEASE_ACQUIRED) == 0)) {
                        ipv4_wait = 1;
                }
-               if (((ha->ipv6_addl_options &
+               if (((ha->ip_config.ipv6_addl_options &
                            IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE) != 0) &&
-                   ((ha->ipv6_link_local_state == IP_ADDRSTATE_ACQUIRING) ||
-                    (ha->ipv6_addr0_state == IP_ADDRSTATE_ACQUIRING) ||
-                    (ha->ipv6_addr1_state == IP_ADDRSTATE_ACQUIRING))) {
+                   ((ha->ip_config.ipv6_link_local_state ==
+                     IP_ADDRSTATE_ACQUIRING) ||
+                    (ha->ip_config.ipv6_addr0_state ==
+                     IP_ADDRSTATE_ACQUIRING) ||
+                    (ha->ip_config.ipv6_addr1_state ==
+                     IP_ADDRSTATE_ACQUIRING))) {

                        ipv6_wait = 1;

-                       if ((ha->ipv6_link_local_state ==
-                                                    IP_ADDRSTATE_PREFERRED) ||
-                           (ha->ipv6_addr0_state == IP_ADDRSTATE_PREFERRED) ||
-                           (ha->ipv6_addr1_state == IP_ADDRSTATE_PREFERRED)) {
+                       if ((ha->ip_config.ipv6_link_local_state ==
+                            IP_ADDRSTATE_PREFERRED) ||
+                           (ha->ip_config.ipv6_addr0_state ==
+                            IP_ADDRSTATE_PREFERRED) ||
+                           (ha->ip_config.ipv6_addr1_state ==
+                            IP_ADDRSTATE_PREFERRED)) {
                                DEBUG2(printk(KERN_INFO "scsi%ld: %s: "
                                              "Preferred IP configured."
                                              " Don't wait!\n", ha->host_no,
                                              __func__));
                                ipv6_wait = 0;
                        }
-                       if (memcmp(&ha->ipv6_default_router_addr, ip_address,
-                               IPv6_ADDR_LEN) == 0) {
+                       if (memcmp(&ha->ip_config.ipv6_default_router_addr,
+                           ip_address, IPv6_ADDR_LEN) == 0) {
                                DEBUG2(printk(KERN_INFO "scsi%ld: %s: "
                                              "No Router configured. "
                                              "Don't wait!\n", ha->host_no,
                                              __func__));
                                ipv6_wait = 0;
                        }
-                       if ((ha->ipv6_default_router_state ==
-                                               IPV6_RTRSTATE_MANUAL) &&
-                           (ha->ipv6_link_local_state ==
-                                               IP_ADDRSTATE_TENTATIVE) &&
-                           (memcmp(&ha->ipv6_link_local_addr,
-                                   &ha->ipv6_default_router_addr, 4) == 0)) {
+                       if ((ha->ip_config.ipv6_default_router_state ==
+                            IPV6_RTRSTATE_MANUAL) &&
+                           (ha->ip_config.ipv6_link_local_state ==
+                            IP_ADDRSTATE_TENTATIVE) &&
+                           (memcmp(&ha->ip_config.ipv6_link_local_addr,
+                            &ha->ip_config.ipv6_default_router_addr, 4) ==
+                            0)) {
                                DEBUG2(printk("scsi%ld: %s: LinkLocal Router & "
                                        "IP configured. Don't wait!\n",
                                        ha->host_no, __func__));
@@ -279,11 +285,14 @@ qla4xxx_wait_for_ip_config(struct scsi_qla_host *ha)
                                      "IP(s) \"", ha->host_no, __func__));
                        if (ipv4_wait)
                                DEBUG2(printk("IPv4 "));
-                       if (ha->ipv6_link_local_state == IP_ADDRSTATE_ACQUIRING)
+                       if (ha->ip_config.ipv6_link_local_state ==
+                           IP_ADDRSTATE_ACQUIRING)
                                DEBUG2(printk("IPv6LinkLocal "));
-                       if (ha->ipv6_addr0_state == IP_ADDRSTATE_ACQUIRING)
+                       if (ha->ip_config.ipv6_addr0_state ==
+                           IP_ADDRSTATE_ACQUIRING)
                                DEBUG2(printk("IPv6Addr0 "));
-                       if (ha->ipv6_addr1_state == IP_ADDRSTATE_ACQUIRING)
+                       if (ha->ip_config.ipv6_addr1_state ==
+                           IP_ADDRSTATE_ACQUIRING)
                                DEBUG2(printk("IPv6Addr1 "));
                        DEBUG2(printk("\"\n"));
                }
@@ -1425,8 +1434,8 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
                goto exit_init_online;

        /* Skip device discovery if ip and subnet is zero */
-       if (memcmp(ha->ip_address, ip_address, IP_ADDR_LEN) == 0 ||
-           memcmp(ha->subnet_mask, ip_address, IP_ADDR_LEN) == 0)
+       if (memcmp(ha->ip_config.ip_address, ip_address, IP_ADDR_LEN) == 0 ||
+           memcmp(ha->ip_config.subnet_mask, ip_address, IP_ADDR_LEN) == 0)
                goto exit_init_online;

        if (renew_ddb_list == PRESERVE_DDB_LIST) {
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index dbbfa0b..e15cf9e 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -331,36 +331,51 @@ static void
 qla4xxx_update_local_ip(struct scsi_qla_host *ha,
                         struct addr_ctrl_blk  *init_fw_cb)
 {
+       ha->ip_config.tcp_options = le16_to_cpu(init_fw_cb->ipv4_tcp_opts);
+       ha->ip_config.ipv4_options = le16_to_cpu(init_fw_cb->ipv4_ip_opts);
+       ha->ip_config.ipv4_addr_state =
+           le16_to_cpu(init_fw_cb->ipv4_addr_state);
+
+       if (ha->acb_version == ACB_SUPPORTED) {
+               ha->ip_config.ipv6_options = init_fw_cb->ipv6_opts;
+               ha->ip_config.ipv6_addl_options = init_fw_cb->ipv6_addtl_opts;
+       }
+
        /* Save IPv4 Address Info */
-       memcpy(ha->ip_address, init_fw_cb->ipv4_addr,
-               min(sizeof(ha->ip_address), sizeof(init_fw_cb->ipv4_addr)));
-       memcpy(ha->subnet_mask, init_fw_cb->ipv4_subnet,
-               min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->ipv4_subnet)));
-       memcpy(ha->gateway, init_fw_cb->ipv4_gw_addr,
-               min(sizeof(ha->gateway), sizeof(init_fw_cb->ipv4_gw_addr)));
+       memcpy(ha->ip_config.ip_address, init_fw_cb->ipv4_addr,
+               min(sizeof(ha->ip_config.ip_address),
+               sizeof(init_fw_cb->ipv4_addr)));
+       memcpy(ha->ip_config.subnet_mask, init_fw_cb->ipv4_subnet,
+               min(sizeof(ha->ip_config.subnet_mask),
+               sizeof(init_fw_cb->ipv4_subnet)));
+       memcpy(ha->ip_config.gateway, init_fw_cb->ipv4_gw_addr,
+               min(sizeof(ha->ip_config.gateway),
+               sizeof(init_fw_cb->ipv4_gw_addr)));

        if (is_ipv6_enabled(ha)) {
                /* Save IPv6 Address */
-               ha->ipv6_link_local_state = init_fw_cb->ipv6_lnk_lcl_addr_state;
-               ha->ipv6_addr0_state = init_fw_cb->ipv6_addr0_state;
-               ha->ipv6_addr1_state = init_fw_cb->ipv6_addr1_state;
-               ha->ipv6_default_router_state = init_fw_cb->ipv6_dflt_rtr_state;
-               ha->ipv6_link_local_addr.in6_u.u6_addr8[0] = 0xFE;
-               ha->ipv6_link_local_addr.in6_u.u6_addr8[1] = 0x80;
-
-               memcpy(&ha->ipv6_link_local_addr.in6_u.u6_addr8[8],
+               ha->ip_config.ipv6_link_local_state =
+                   init_fw_cb->ipv6_lnk_lcl_addr_state;
+               ha->ip_config.ipv6_addr0_state = init_fw_cb->ipv6_addr0_state;
+               ha->ip_config.ipv6_addr1_state = init_fw_cb->ipv6_addr1_state;
+               ha->ip_config.ipv6_default_router_state =
+                   init_fw_cb->ipv6_dflt_rtr_state;
+               ha->ip_config.ipv6_link_local_addr.in6_u.u6_addr8[0] = 0xFE;
+               ha->ip_config.ipv6_link_local_addr.in6_u.u6_addr8[1] = 0x80;
+
+               memcpy(&ha->ip_config.ipv6_link_local_addr.in6_u.u6_addr8[8],
                        init_fw_cb->ipv6_if_id,
-                       min(sizeof(ha->ipv6_link_local_addr)/2,
+                       min(sizeof(ha->ip_config.ipv6_link_local_addr)/2,
                        sizeof(init_fw_cb->ipv6_if_id)));
-               memcpy(&ha->ipv6_addr0, init_fw_cb->ipv6_addr0,
-                       min(sizeof(ha->ipv6_addr0),
+               memcpy(&ha->ip_config.ipv6_addr0, init_fw_cb->ipv6_addr0,
+                       min(sizeof(ha->ip_config.ipv6_addr0),
                        sizeof(init_fw_cb->ipv6_addr0)));
-               memcpy(&ha->ipv6_addr1, init_fw_cb->ipv6_addr1,
-                       min(sizeof(ha->ipv6_addr1),
+               memcpy(&ha->ip_config.ipv6_addr1, init_fw_cb->ipv6_addr1,
+                       min(sizeof(ha->ip_config.ipv6_addr1),
                        sizeof(init_fw_cb->ipv6_addr1)));
-               memcpy(&ha->ipv6_default_router_addr,
+               memcpy(&ha->ip_config.ipv6_default_router_addr,
                        init_fw_cb->ipv6_dflt_rtr_addr,
-                       min(sizeof(ha->ipv6_default_router_addr),
+                       min(sizeof(ha->ip_config.ipv6_default_router_addr),
                        sizeof(init_fw_cb->ipv6_dflt_rtr_addr)));
        }
 }
@@ -385,9 +400,6 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
        /* Save some info in adapter structure. */
        ha->acb_version = init_fw_cb->acb_version;
        ha->firmware_options = le16_to_cpu(init_fw_cb->fw_options);
-       ha->tcp_options = le16_to_cpu(init_fw_cb->ipv4_tcp_opts);
-       ha->ipv4_options = le16_to_cpu(init_fw_cb->ipv4_ip_opts);
-       ha->ipv4_addr_state = le16_to_cpu(init_fw_cb->ipv4_addr_state);
        ha->heartbeat_interval = init_fw_cb->hb_interval;
        memcpy(ha->name_string, init_fw_cb->iscsi_name,
                min(sizeof(ha->name_string),
@@ -398,10 +410,6 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
        /* Save Command Line Paramater info */
        ha->discovery_wait = ql4xdiscoverywait;

-       if (ha->acb_version == ACB_SUPPORTED) {
-               ha->ipv6_options = init_fw_cb->ipv6_opts;
-               ha->ipv6_addl_options = init_fw_cb->ipv6_addtl_opts;
-       }
        qla4xxx_update_local_ip(ha, init_fw_cb);

        return QLA_SUCCESS;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b42d687..dfc52f3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -183,9 +183,7 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
                len = sysfs_format_mac(buf, ha->my_mac, MAC_ADDR_LEN);
                break;
        case ISCSI_HOST_PARAM_IPADDRESS:
-               len = sprintf(buf, "%d.%d.%d.%d\n", ha->ip_address[0],
-                             ha->ip_address[1], ha->ip_address[2],
-                             ha->ip_address[3]);
+               len = sprintf(buf, "%pI4\n", &ha->ip_config.ip_address);
                break;
        case ISCSI_HOST_PARAM_INITIATOR_NAME:
                len = sprintf(buf, "%s\n", ha->name_string);
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

