From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/5] qla4xxx: Added new "struct ipaddress_config"
Date: Fri, 22 Apr 2011 11:07:44 -0700
Message-ID: <1303495666-731-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46858 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755120Ab1DVSNV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 14:13:21 -0400
In-Reply-To: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

- Move all ipaddress related param to "struct ipaddress_config"
  from "struct scsi_qla_host"
- update function - qla4xxx_update_local_ip()
- Rename IPOPT_IPv4_PROTOCOL_ENABLE to IPOPT_IPV4_PROTOCOL_ENABLE

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |   47 ++++++++++++----------
 drivers/scsi/qla4xxx/ql4_fw.h   |    2 +-
 drivers/scsi/qla4xxx/ql4_init.c |   53 +++++++++++++++----------
 drivers/scsi/qla4xxx/ql4_mbx.c  |   81 ++++++++++++++++++++++-----------------
 drivers/scsi/qla4xxx/ql4_os.c   |    8 +--
 5 files changed, 107 insertions(+), 84 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 4757878..bce5c89 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -357,6 +357,28 @@ struct isp_operations {
 	int (*get_sys_info) (struct scsi_qla_host *);
 };
 
+/*qla4xxx ipaddress configuration details */
+struct ipaddress_config {
+	uint16_t ipv4_options;
+	uint16_t tcp_options;
+	uint16_t ipv4_vlan_tag;
+	uint8_t ipv4_addr_state;
+	uint8_t ip_address[IP_ADDR_LEN];
+	uint8_t subnet_mask[IP_ADDR_LEN];
+	uint8_t gateway[IP_ADDR_LEN];
+	uint32_t ipv6_options;
+	uint32_t ipv6_addl_options;
+	uint8_t ipv6_link_local_state;
+	uint8_t ipv6_addr0_state;
+	uint8_t ipv6_addr1_state;
+	uint8_t ipv6_default_router_state;
+	uint16_t ipv6_vlan_tag;
+	struct in6_addr ipv6_link_local_addr;
+	struct in6_addr ipv6_addr0;
+	struct in6_addr ipv6_addr1;
+	struct in6_addr ipv6_default_router_addr;
+};
+
 /*
  * Linux Host Adapter structure
  */
@@ -452,10 +474,6 @@ struct scsi_qla_host {
 	/* --- From Init_FW --- */
 	/* init_cb_t *init_cb; */
 	uint16_t firmware_options;
-	uint16_t tcp_options;
-	uint8_t ip_address[IP_ADDR_LEN];
-	uint8_t subnet_mask[IP_ADDR_LEN];
-	uint8_t gateway[IP_ADDR_LEN];
 	uint8_t alias[32];
 	uint8_t name_string[256];
 	uint8_t heartbeat_interval;
@@ -534,22 +552,7 @@ struct scsi_qla_host {
 	/* Saved srb for status continuation entry processing */
 	struct srb *status_srb;
 
-	/* IPv6 support info from InitFW */
 	uint8_t acb_version;
-	uint8_t ipv4_addr_state;
-	uint16_t ipv4_options;
-
-	uint32_t resvd2;
-	uint32_t ipv6_options;
-	uint32_t ipv6_addl_options;
-	uint8_t ipv6_link_local_state;
-	uint8_t ipv6_addr0_state;
-	uint8_t ipv6_addr1_state;
-	uint8_t ipv6_default_router_state;
-	struct in6_addr ipv6_link_local_addr;
-	struct in6_addr ipv6_addr0;
-	struct in6_addr ipv6_addr1;
-	struct in6_addr ipv6_default_router_addr;
 
 	/* qla82xx specific fields */
 	struct device_reg_82xx  __iomem *qla4_8xxx_reg; /* Base I/O address */
@@ -584,16 +587,18 @@ struct scsi_qla_host {
 	uint32_t nx_reset_timeout;
 
 	struct completion mbx_intr_comp;
+	struct ipaddress_config ip_config;
 };
 
 static inline int is_ipv4_enabled(struct scsi_qla_host *ha)
 {
-	return ((ha->ipv4_options & IPOPT_IPv4_PROTOCOL_ENABLE) != 0);
+	return ((ha->ip_config.ipv4_options & IPOPT_IPV4_PROTOCOL_ENABLE) != 0);
 }
 
 static inline int is_ipv6_enabled(struct scsi_qla_host *ha)
 {
-	return ((ha->ipv6_options & IPV6_OPT_IPV6_PROTOCOL_ENABLE) != 0);
+	return ((ha->ip_config.ipv6_options &
+		IPV6_OPT_IPV6_PROTOCOL_ENABLE) != 0);
 }
 
 static inline int is_qla4010(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index d05e8be..9a07b8d 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -483,7 +483,7 @@ struct addr_ctrl_blk {
 	uint16_t ipv4_tcp_opts;	/* 32-33 */
 #define TCPOPT_DHCP_ENABLE		0x0200
 	uint16_t ipv4_ip_opts;	/* 34-35 */
-#define  IPOPT_IPv4_PROTOCOL_ENABLE	0x8000
+#define IPOPT_IPV4_PROTOCOL_ENABLE	0x8000
 
 	uint16_t iscsi_max_pdu_size;	/* 36-37 */
 	uint8_t ipv4_tos;	/* 38 */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 48e2241..1f267d8 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -236,38 +236,44 @@ qla4xxx_wait_for_ip_config(struct scsi_qla_host *ha)
 				    FW_ADDSTATE_DHCPv4_LEASE_ACQUIRED) == 0)) {
 			ipv4_wait = 1;
 		}
-		if (((ha->ipv6_addl_options &
-			    IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE) != 0) &&
-		    ((ha->ipv6_link_local_state == IP_ADDRSTATE_ACQUIRING) ||
-		     (ha->ipv6_addr0_state == IP_ADDRSTATE_ACQUIRING) ||
-		     (ha->ipv6_addr1_state == IP_ADDRSTATE_ACQUIRING))) {
+		if (((ha->ip_config.ipv6_addl_options &
+		      IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE) != 0) &&
+		    ((ha->ip_config.ipv6_link_local_state ==
+		      IP_ADDRSTATE_ACQUIRING) ||
+		     (ha->ip_config.ipv6_addr0_state ==
+		      IP_ADDRSTATE_ACQUIRING) ||
+		     (ha->ip_config.ipv6_addr1_state ==
+		      IP_ADDRSTATE_ACQUIRING))) {
 
 			ipv6_wait = 1;
 
-			if ((ha->ipv6_link_local_state ==
-						     IP_ADDRSTATE_PREFERRED) ||
-			    (ha->ipv6_addr0_state == IP_ADDRSTATE_PREFERRED) ||
-			    (ha->ipv6_addr1_state == IP_ADDRSTATE_PREFERRED)) {
+			if ((ha->ip_config.ipv6_link_local_state ==
+			     IP_ADDRSTATE_PREFERRED) ||
+			    (ha->ip_config.ipv6_addr0_state ==
+			     IP_ADDRSTATE_PREFERRED) ||
+			    (ha->ip_config.ipv6_addr1_state ==
+			     IP_ADDRSTATE_PREFERRED)) {
 				DEBUG2(printk(KERN_INFO "scsi%ld: %s: "
 					      "Preferred IP configured."
 					      " Don't wait!\n", ha->host_no,
 					      __func__));
 				ipv6_wait = 0;
 			}
-			if (memcmp(&ha->ipv6_default_router_addr, ip_address,
-				IPv6_ADDR_LEN) == 0) {
+			if (memcmp(&ha->ip_config.ipv6_default_router_addr,
+				   ip_address, IPv6_ADDR_LEN) == 0) {
 				DEBUG2(printk(KERN_INFO "scsi%ld: %s: "
 					      "No Router configured. "
 					      "Don't wait!\n", ha->host_no,
 					      __func__));
 				ipv6_wait = 0;
 			}
-			if ((ha->ipv6_default_router_state ==
-						IPV6_RTRSTATE_MANUAL) &&
-			    (ha->ipv6_link_local_state ==
-						IP_ADDRSTATE_TENTATIVE) &&
-			    (memcmp(&ha->ipv6_link_local_addr,
-				    &ha->ipv6_default_router_addr, 4) == 0)) {
+			if ((ha->ip_config.ipv6_default_router_state ==
+			     IPV6_RTRSTATE_MANUAL) &&
+			    (ha->ip_config.ipv6_link_local_state ==
+			     IP_ADDRSTATE_TENTATIVE) &&
+			    (memcmp(&ha->ip_config.ipv6_link_local_addr,
+			     &ha->ip_config.ipv6_default_router_addr, 4) ==
+			     0)) {
 				DEBUG2(printk("scsi%ld: %s: LinkLocal Router & "
 					"IP configured. Don't wait!\n",
 					ha->host_no, __func__));
@@ -279,11 +285,14 @@ qla4xxx_wait_for_ip_config(struct scsi_qla_host *ha)
 				      "IP(s) \"", ha->host_no, __func__));
 			if (ipv4_wait)
 				DEBUG2(printk("IPv4 "));
-			if (ha->ipv6_link_local_state == IP_ADDRSTATE_ACQUIRING)
+			if (ha->ip_config.ipv6_link_local_state ==
+			    IP_ADDRSTATE_ACQUIRING)
 				DEBUG2(printk("IPv6LinkLocal "));
-			if (ha->ipv6_addr0_state == IP_ADDRSTATE_ACQUIRING)
+			if (ha->ip_config.ipv6_addr0_state ==
+			    IP_ADDRSTATE_ACQUIRING)
 				DEBUG2(printk("IPv6Addr0 "));
-			if (ha->ipv6_addr1_state == IP_ADDRSTATE_ACQUIRING)
+			if (ha->ip_config.ipv6_addr1_state ==
+			    IP_ADDRSTATE_ACQUIRING)
 				DEBUG2(printk("IPv6Addr1 "));
 			DEBUG2(printk("\"\n"));
 		}
@@ -1297,8 +1306,8 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
 		goto exit_init_online;
 
 	/* Skip device discovery if ip and subnet is zero */
-	if (memcmp(ha->ip_address, ip_address, IP_ADDR_LEN) == 0 ||
-	    memcmp(ha->subnet_mask, ip_address, IP_ADDR_LEN) == 0)
+	if (memcmp(ha->ip_config.ip_address, ip_address, IP_ADDR_LEN) == 0 ||
+	    memcmp(ha->ip_config.subnet_mask, ip_address, IP_ADDR_LEN) == 0)
 		goto exit_init_online;
 
 	if (renew_ddb_list == PRESERVE_DDB_LIST) {
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 743290e..d213fa7 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -341,39 +341,57 @@ qla4xxx_get_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 
 static void
 qla4xxx_update_local_ip(struct scsi_qla_host *ha,
-			 struct addr_ctrl_blk  *init_fw_cb)
+			struct addr_ctrl_blk *init_fw_cb)
 {
+	ha->ip_config.tcp_options = le16_to_cpu(init_fw_cb->ipv4_tcp_opts);
+	ha->ip_config.ipv4_options = le16_to_cpu(init_fw_cb->ipv4_ip_opts);
+	ha->ip_config.ipv4_addr_state =
+				le16_to_cpu(init_fw_cb->ipv4_addr_state);
+
+	if (ha->acb_version == ACB_SUPPORTED) {
+		ha->ip_config.ipv6_options = le16_to_cpu(init_fw_cb->ipv6_opts);
+		ha->ip_config.ipv6_addl_options =
+				le16_to_cpu(init_fw_cb->ipv6_addtl_opts);
+	}
+
 	/* Save IPv4 Address Info */
-	memcpy(ha->ip_address, init_fw_cb->ipv4_addr,
-		min(sizeof(ha->ip_address), sizeof(init_fw_cb->ipv4_addr)));
-	memcpy(ha->subnet_mask, init_fw_cb->ipv4_subnet,
-		min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->ipv4_subnet)));
-	memcpy(ha->gateway, init_fw_cb->ipv4_gw_addr,
-		min(sizeof(ha->gateway), sizeof(init_fw_cb->ipv4_gw_addr)));
+	memcpy(ha->ip_config.ip_address, init_fw_cb->ipv4_addr,
+	       min(sizeof(ha->ip_config.ip_address),
+		   sizeof(init_fw_cb->ipv4_addr)));
+	memcpy(ha->ip_config.subnet_mask, init_fw_cb->ipv4_subnet,
+	       min(sizeof(ha->ip_config.subnet_mask),
+		   sizeof(init_fw_cb->ipv4_subnet)));
+	memcpy(ha->ip_config.gateway, init_fw_cb->ipv4_gw_addr,
+	       min(sizeof(ha->ip_config.gateway),
+		   sizeof(init_fw_cb->ipv4_gw_addr)));
 
 	if (is_ipv6_enabled(ha)) {
 		/* Save IPv6 Address */
-		ha->ipv6_link_local_state = init_fw_cb->ipv6_lnk_lcl_addr_state;
-		ha->ipv6_addr0_state = init_fw_cb->ipv6_addr0_state;
-		ha->ipv6_addr1_state = init_fw_cb->ipv6_addr1_state;
-		ha->ipv6_default_router_state = init_fw_cb->ipv6_dflt_rtr_state;
-		ha->ipv6_link_local_addr.in6_u.u6_addr8[0] = 0xFE;
-		ha->ipv6_link_local_addr.in6_u.u6_addr8[1] = 0x80;
-
-		memcpy(&ha->ipv6_link_local_addr.in6_u.u6_addr8[8],
-			init_fw_cb->ipv6_if_id,
-			min(sizeof(ha->ipv6_link_local_addr)/2,
-			sizeof(init_fw_cb->ipv6_if_id)));
-		memcpy(&ha->ipv6_addr0, init_fw_cb->ipv6_addr0,
-			min(sizeof(ha->ipv6_addr0),
-			sizeof(init_fw_cb->ipv6_addr0)));
-		memcpy(&ha->ipv6_addr1, init_fw_cb->ipv6_addr1,
-			min(sizeof(ha->ipv6_addr1),
-			sizeof(init_fw_cb->ipv6_addr1)));
-		memcpy(&ha->ipv6_default_router_addr,
-			init_fw_cb->ipv6_dflt_rtr_addr,
-			min(sizeof(ha->ipv6_default_router_addr),
-			sizeof(init_fw_cb->ipv6_dflt_rtr_addr)));
+		ha->ip_config.ipv6_link_local_state =
+			le16_to_cpu(init_fw_cb->ipv6_lnk_lcl_addr_state);
+		ha->ip_config.ipv6_addr0_state =
+				le16_to_cpu(init_fw_cb->ipv6_addr0_state);
+		ha->ip_config.ipv6_addr1_state =
+				le16_to_cpu(init_fw_cb->ipv6_addr1_state);
+		ha->ip_config.ipv6_default_router_state =
+				le16_to_cpu(init_fw_cb->ipv6_dflt_rtr_state);
+		ha->ip_config.ipv6_link_local_addr.in6_u.u6_addr8[0] = 0xFE;
+		ha->ip_config.ipv6_link_local_addr.in6_u.u6_addr8[1] = 0x80;
+
+		memcpy(&ha->ip_config.ipv6_link_local_addr.in6_u.u6_addr8[8],
+		       init_fw_cb->ipv6_if_id,
+		       min(sizeof(ha->ip_config.ipv6_link_local_addr)/2,
+			   sizeof(init_fw_cb->ipv6_if_id)));
+		memcpy(&ha->ip_config.ipv6_addr0, init_fw_cb->ipv6_addr0,
+		       min(sizeof(ha->ip_config.ipv6_addr0),
+			   sizeof(init_fw_cb->ipv6_addr0)));
+		memcpy(&ha->ip_config.ipv6_addr1, init_fw_cb->ipv6_addr1,
+		       min(sizeof(ha->ip_config.ipv6_addr1),
+			   sizeof(init_fw_cb->ipv6_addr1)));
+		memcpy(&ha->ip_config.ipv6_default_router_addr,
+		       init_fw_cb->ipv6_dflt_rtr_addr,
+		       min(sizeof(ha->ip_config.ipv6_default_router_addr),
+			   sizeof(init_fw_cb->ipv6_dflt_rtr_addr)));
 	}
 }
 
@@ -397,9 +415,6 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
 	/* Save some info in adapter structure. */
 	ha->acb_version = init_fw_cb->acb_version;
 	ha->firmware_options = le16_to_cpu(init_fw_cb->fw_options);
-	ha->tcp_options = le16_to_cpu(init_fw_cb->ipv4_tcp_opts);
-	ha->ipv4_options = le16_to_cpu(init_fw_cb->ipv4_ip_opts);
-	ha->ipv4_addr_state = le16_to_cpu(init_fw_cb->ipv4_addr_state);
 	ha->heartbeat_interval = init_fw_cb->hb_interval;
 	memcpy(ha->name_string, init_fw_cb->iscsi_name,
 		min(sizeof(ha->name_string),
@@ -407,10 +422,6 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
 	/*memcpy(ha->alias, init_fw_cb->Alias,
 	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));*/
 
-	if (ha->acb_version == ACB_SUPPORTED) {
-		ha->ipv6_options = init_fw_cb->ipv6_opts;
-		ha->ipv6_addl_options = init_fw_cb->ipv6_addtl_opts;
-	}
 	qla4xxx_update_local_ip(ha, init_fw_cb);
 
 	return QLA_SUCCESS;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index e9b669d..09e371f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -190,9 +190,7 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 		len = sysfs_format_mac(buf, ha->my_mac, MAC_ADDR_LEN);
 		break;
 	case ISCSI_HOST_PARAM_IPADDRESS:
-		len = sprintf(buf, "%d.%d.%d.%d\n", ha->ip_address[0],
-			      ha->ip_address[1], ha->ip_address[2],
-			      ha->ip_address[3]);
+		len = sprintf(buf, "%pI4\n", &ha->ip_config.ip_address);
 		break;
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
 		len = sprintf(buf, "%s\n", ha->name_string);
@@ -328,10 +326,10 @@ static inline void qla4xxx_set_ipv4(struct scsi_qla_host *ha,
 	case ISCSI_NET_PARAM_IFACE_ENABLED:
 		if (net_param->value[0] == ISCSI_TRUE)
 			init_fw_cb->ipv4_ip_opts |=
-				cpu_to_le16(IPOPT_IPv4_PROTOCOL_ENABLE);
+				cpu_to_le16(IPOPT_IPV4_PROTOCOL_ENABLE);
 		else
 			init_fw_cb->ipv4_ip_opts &=
-				cpu_to_le16(~IPOPT_IPv4_PROTOCOL_ENABLE &
+				cpu_to_le16(~IPOPT_IPV4_PROTOCOL_ENABLE &
 					    0xFFFF);
 		break;
 	case ISCSI_NET_PARAM_VLAN:
-- 
1.7.3.2

