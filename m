From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/8] qla4xxx: Additional parameters for net settings
Date: Thu, 9 May 2013 06:02:07 -0400
Message-ID: <1368093732-8524-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:27099
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669Ab3EIK0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 06:26:49 -0400
In-Reply-To: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |   31 ++
 drivers/scsi/qla4xxx/ql4_fw.h   |   53 +-
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
 drivers/scsi/qla4xxx/ql4_isr.c  |   32 ++
 drivers/scsi/qla4xxx/ql4_mbx.c  |  119 ++++-
 drivers/scsi/qla4xxx/ql4_os.c   | 1057 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 1283 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index ddf16a8..fcd4110 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -469,6 +469,37 @@ struct ipaddress_config {
 	uint16_t eth_mtu_size;
 	uint16_t ipv4_port;
 	uint16_t ipv6_port;
+	uint8_t control;
+	uint16_t ipv6_tcp_options;
+	uint8_t isns_addr[IP_ADDR_LEN];
+	uint16_t isns_port;
+	struct in6_addr ipv6_isns_addr;
+	uint8_t tcp_wsf;
+	uint8_t ipv6_tcp_wsf;
+	uint8_t ipv4_tos;
+	uint8_t ipv4_cache_id;
+	uint8_t ipv6_cache_id;
+	uint8_t ipv4_alt_cid_len;
+	uint8_t ipv4_alt_cid[11];
+	uint8_t ipv4_vid_len;
+	uint8_t ipv4_vid[11];
+	uint8_t ipv4_ttl;
+	uint16_t ipv6_flow_lbl;
+	uint8_t ipv6_traffic_class;
+	uint8_t ipv6_hop_limit;
+	uint32_t ipv6_nd_reach_time;
+	uint32_t ipv6_nd_rexmit_timer;
+	uint32_t ipv6_nd_stale_timeout;
+	uint8_t ipv6_dup_addr_detect_count;
+	uint32_t ipv6_gw_advrt_mtu;
+	uint16_t def_timeout;
+	uint8_t abort_timer;
+	uint16_t iscsi_options;
+	uint16_t iscsi_max_pdu_size;
+	uint16_t iscsi_fburst_len;
+	uint16_t iscsi_max_outstnd_r2t;
+	uint16_t iscsi_max_burst_len;
+	uint8_t iscsi_name[224];
 };
 
 #define QL4_CHAP_MAX_NAME_LEN 256
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index c7b8892..79c53eb 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -541,6 +541,7 @@ struct addr_ctrl_blk {
 #define  IFCB_VER_MIN			0x01
 #define  IFCB_VER_MAX			0x02
 	uint8_t control;	/* 01 */
+#define	 CTRLOPT_NEW_CONN_DISABLE	0x0002
 
 	uint16_t fw_options;	/* 02-03 */
 #define	 FWOPT_HEARTBEAT_ENABLE		  0x1000
@@ -572,11 +573,42 @@ struct addr_ctrl_blk {
 	uint32_t shdwreg_addr_hi;	/* 2C-2F */
 
 	uint16_t iscsi_opts;	/* 30-31 */
+#define ISCSIOPT_HEADER_DIGEST_ENABLE		0x2000
+#define ISCSIOPT_DATA_DIGEST_ENABLE		0x1000
+#define ISCSIOPT_IMMEDIATE_DATA_ENABLE		0x0800
+#define ISCSIOPT_INITIAL_R2T_ENABLE		0x0400
+#define ISCSIOPT_DATA_SEQ_INORDER_ENABLE	0x0200
+#define ISCSIOPT_DATA_PDU_INORDER_ENABLE	0x0100
+#define ISCSIOPT_CHAP_AUTH_ENABLE		0x0080
+#define ISCSIOPT_SNACK_ENABLE			0x0040
+#define ISCSIOPT_DISCOVERY_LOGOUT_ENABLE	0x0020
+#define ISCSIOPT_BIDI_CHAP_ENABLE		0x0010
+#define ISCSIOPT_DISCOVERY_AUTH_ENABLE		0x0008
+#define ISCSIOPT_STRICT_LOGIN_COMP_ENABLE	0x0004
+#define ISCSIOPT_ERR_RECOVERY_LEVEL_MASK	0x0003
 	uint16_t ipv4_tcp_opts;	/* 32-33 */
+#define TCPOPT_DELAYED_ACK_DISABLE	0x8000
+#define TCPOPT_ISNS_ENABLE		0x4000
 #define TCPOPT_DHCP_ENABLE		0x0200
+#define TCPOPT_DNS_SERVER_IP_ENABLE	0x0100
+#define TCPOPT_SLP_DA_INFO_ENABLE	0x0080
+#define TCPOPT_ISNS_INFO_ENABLE		0x0040
+#define TCPOPT_NAGLE_ALGO_DISABLE	0x0020
+#define TCPOPT_WINDOW_SCALE_DISABLE	0x0010
+#define TCPOPT_TIMER_SCALE		0x000E
+#define TCPOPT_TIMESTAMP_ENABLE		0x0001
 	uint16_t ipv4_ip_opts;	/* 34-35 */
 #define IPOPT_IPV4_PROTOCOL_ENABLE	0x8000
+#define IPOPT_IPV4_TOS_ENABLE		0x4000
 #define IPOPT_VLAN_TAGGING_ENABLE	0x2000
+#define IPOPT_GRAT_ARP_ENABLE		0x1000
+#define IPOPT_ALT_CID_ENABLE		0x0800
+#define IPOPT_REQ_VID_ENABLE		0x0400
+#define IPOPT_USE_VID_ENABLE		0x0200
+#define IPOPT_LEARN_IQN_ENABLE		0x0100
+#define IPOPT_FRAGMENTATION_DISABLE	0x0010
+#define IPOPT_INCOM_FORWARD_ENABLE	0x0008
+#define IPOPT_ARP_REDIRECT_ENABLE	0x0004
 
 	uint16_t iscsi_max_pdu_size;	/* 36-37 */
 	uint8_t ipv4_tos;	/* 38 */
@@ -619,7 +651,9 @@ struct addr_ctrl_blk {
 	uint8_t ipv4_sec_ip_addr[4];	/* D0-D3 */
 	uint8_t ipv4_dhcp_vid_len;	/* D4 */
 	uint8_t ipv4_dhcp_vid[11];	/* D5-DF */
-	uint8_t res11[20];	/* E0-F3 */
+	uint8_t ipv4_isns_addr[4];	/* E0-E3 */
+	uint16_t ipv4_isns_port;		/* E4-E5 */
+	uint8_t res11[14];	/* E6-F3 */
 	uint8_t ipv4_dhcp_alt_cid_len;	/* F4 */
 	uint8_t ipv4_dhcp_alt_cid[11];	/* F5-FF */
 	uint8_t iscsi_name[224];	/* 100-1DF */
@@ -627,15 +661,25 @@ struct addr_ctrl_blk {
 	uint32_t cookie;	/* 200-203 */
 	uint16_t ipv6_port;	/* 204-205 */
 	uint16_t ipv6_opts;	/* 206-207 */
-#define IPV6_OPT_IPV6_PROTOCOL_ENABLE	0x8000
-#define IPV6_OPT_VLAN_TAGGING_ENABLE	0x2000
+#define IPV6_OPT_IPV6_PROTOCOL_ENABLE		0x8000
+#define IPV6_OPT_VLAN_TAGGING_ENABLE		0x2000
+#define IPV6_OPT_GRAT_NEIGHBOR_ADV_ENABLE	0x1000
+#define IPV6_OPT_REDIRECT_ENABLE		0x0004
 
 	uint16_t ipv6_addtl_opts;	/* 208-209 */
+#define IPV6_ADDOPT_IGNORE_ICMP_ECHO_REQ		0x0040
+#define IPV6_ADDOPT_MLD_ENABLE				0x0004
 #define IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE	0x0002 /* Pri ACB
 								  Only */
 #define IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR		0x0001
 
 	uint16_t ipv6_tcp_opts;	/* 20A-20B */
+#define IPV6_TCPOPT_DELAYED_ACK_DISABLE		0x8000
+#define IPV6_TCPOPT_ISNS_ENABLE			0x4000
+#define IPV6_TCPOPT_NAGLE_ALGO_DISABLE		0x0020
+#define IPV6_TCPOPT_WINDOW_SCALE_DISABLE	0x0010
+#define IPV6_TCPOPT_TIMER_SCALE			0x000E
+#define IPV6_TCPOPT_TIMESTAMP_ENABLE		0x0001
 	uint8_t ipv6_tcp_wsf;	/* 20C */
 	uint16_t ipv6_flow_lbl;	/* 20D-20F */
 	uint8_t ipv6_dflt_rtr_addr[16]; /* 210-21F */
@@ -667,7 +711,8 @@ struct addr_ctrl_blk {
 	uint32_t ipv6_nd_stale_timeout;	/* 258-25B */
 	uint8_t ipv6_dup_addr_detect_count;	/* 25C */
 	uint8_t ipv6_cache_id;	/* 25D */
-	uint8_t res13[18];	/* 25E-26F */
+	uint8_t res13[2];	/* 25E-25F */
+	uint8_t ipv6_isns_addr[16];	/* 260-26F */
 	uint32_t ipv6_gw_advrt_mtu;	/* 270-273 */
 	uint8_t res14[140];	/* 274-2FF */
 };
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 4a42800..48d6b5d 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -266,6 +266,7 @@ int qla4xxx_get_default_ddb(struct scsi_qla_host *ha, uint32_t options,
 			    dma_addr_t dma_addr);
 int qla4xxx_get_uni_chap_at_index(struct scsi_qla_host *ha, char *username,
 				  char *password, uint16_t chap_index);
+uint8_t qla4xxx_set_ipaddr_state(uint8_t fw_ipaddr_state);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 482287f..6d94543 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -606,6 +606,36 @@ static int qla4_83xx_loopback_in_progress(struct scsi_qla_host *ha)
 	return rval;
 }
 
+static void qla4xxx_update_ipaddr_state(struct scsi_qla_host *ha,
+					uint32_t ipaddr_idx,
+					uint32_t ipaddr_fw_state)
+{
+	uint8_t ipaddr_state;
+	uint8_t ip_idx;
+
+	ip_idx = ipaddr_idx & 0xF;
+	ipaddr_state = qla4xxx_set_ipaddr_state((uint8_t)ipaddr_fw_state);
+
+	switch (ip_idx) {
+	case 0:
+		ha->ip_config.ipv4_addr_state = ipaddr_state;
+		break;
+	case 1:
+		ha->ip_config.ipv6_link_local_state = ipaddr_state;
+		break;
+	case 2:
+		ha->ip_config.ipv6_addr0_state = ipaddr_state;
+		break;
+	case 3:
+		ha->ip_config.ipv6_addr1_state = ipaddr_state;
+		break;
+	default:
+		ql4_printk(KERN_INFO, ha, "%s: Invalid IPADDR index %d\n",
+			   __func__, ip_idx);
+	}
+}
+
+
 /**
  * qla4xxx_isr_decode_mailbox - decodes mailbox status
  * @ha: Pointer to host adapter structure.
@@ -740,6 +770,8 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			    "mbox_sts[3]=%04x\n", ha->host_no, mbox_sts[0],
 			    mbox_sts[2], mbox_sts[3]);
 
+			qla4xxx_update_ipaddr_state(ha, mbox_sts[5],
+						    mbox_sts[3]);
 			/* mbox_sts[2] = Old ACB state
 			 * mbox_sts[3] = new ACB state */
 			if ((mbox_sts[3] == ACB_STATE_VALID) &&
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index a501bea..1f7909e 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -417,6 +417,38 @@ qla4xxx_get_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 	return QLA_SUCCESS;
 }
 
+uint8_t qla4xxx_set_ipaddr_state(uint8_t fw_ipaddr_state)
+{
+	uint8_t ipaddr_state;
+
+	switch (fw_ipaddr_state) {
+	case IP_ADDRSTATE_UNCONFIGURED:
+		ipaddr_state = ISCSI_IPDDRESS_STATE_UNCONFIGURED;
+		break;
+	case IP_ADDRSTATE_INVALID:
+		ipaddr_state = ISCSI_IPDDRESS_STATE_INVALID;
+		break;
+	case IP_ADDRSTATE_ACQUIRING:
+		ipaddr_state = ISCSI_IPDDRESS_STATE_ACQUIRING;
+		break;
+	case IP_ADDRSTATE_TENTATIVE:
+		ipaddr_state = ISCSI_IPDDRESS_STATE_TENTATIVE;
+		break;
+	case IP_ADDRSTATE_DEPRICATED:
+		ipaddr_state = ISCSI_IPDDRESS_STATE_DEPRECATED;
+		break;
+	case IP_ADDRSTATE_PREFERRED:
+		ipaddr_state = ISCSI_IPDDRESS_STATE_VALID;
+		break;
+	case IP_ADDRSTATE_DISABLING:
+		ipaddr_state = ISCSI_IPDDRESS_STATE_DISABLING;
+		break;
+	default:
+		ipaddr_state = ISCSI_IPDDRESS_STATE_UNCONFIGURED;
+	}
+	return ipaddr_state;
+}
+
 static void
 qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 			struct addr_ctrl_blk *init_fw_cb)
@@ -424,7 +456,7 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 	ha->ip_config.tcp_options = le16_to_cpu(init_fw_cb->ipv4_tcp_opts);
 	ha->ip_config.ipv4_options = le16_to_cpu(init_fw_cb->ipv4_ip_opts);
 	ha->ip_config.ipv4_addr_state =
-				le16_to_cpu(init_fw_cb->ipv4_addr_state);
+			qla4xxx_set_ipaddr_state(init_fw_cb->ipv4_addr_state);
 	ha->ip_config.eth_mtu_size =
 				le16_to_cpu(init_fw_cb->eth_mtu_size);
 	ha->ip_config.ipv4_port = le16_to_cpu(init_fw_cb->ipv4_port);
@@ -433,6 +465,8 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 		ha->ip_config.ipv6_options = le16_to_cpu(init_fw_cb->ipv6_opts);
 		ha->ip_config.ipv6_addl_options =
 				le16_to_cpu(init_fw_cb->ipv6_addtl_opts);
+		ha->ip_config.ipv6_tcp_options =
+				le16_to_cpu(init_fw_cb->ipv6_tcp_opts);
 	}
 
 	/* Save IPv4 Address Info */
@@ -447,17 +481,69 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 		   sizeof(init_fw_cb->ipv4_gw_addr)));
 
 	ha->ip_config.ipv4_vlan_tag = be16_to_cpu(init_fw_cb->ipv4_vlan_tag);
+	ha->ip_config.control = init_fw_cb->control;
+	memcpy(ha->ip_config.isns_addr, init_fw_cb->ipv4_isns_addr,
+	       min(sizeof(ha->ip_config.isns_addr),
+		   sizeof(init_fw_cb->ipv4_isns_addr)));
+	ha->ip_config.isns_port = le16_to_cpu(init_fw_cb->ipv4_isns_port);
+	ha->ip_config.tcp_wsf = init_fw_cb->ipv4_tcp_wsf;
+	ha->ip_config.ipv4_tos = init_fw_cb->ipv4_tos;
+	ha->ip_config.ipv4_cache_id = init_fw_cb->ipv4_cacheid;
+	ha->ip_config.ipv4_alt_cid_len = init_fw_cb->ipv4_dhcp_alt_cid_len;
+	memcpy(ha->ip_config.ipv4_alt_cid, init_fw_cb->ipv4_dhcp_alt_cid,
+	       min(sizeof(ha->ip_config.ipv4_alt_cid),
+		   sizeof(init_fw_cb->ipv4_dhcp_alt_cid)));
+	ha->ip_config.ipv4_vid_len = init_fw_cb->ipv4_dhcp_vid_len;
+	memcpy(ha->ip_config.ipv4_vid, init_fw_cb->ipv4_dhcp_vid,
+	       min(sizeof(ha->ip_config.ipv4_vid),
+		   sizeof(init_fw_cb->ipv4_dhcp_vid)));
+	ha->ip_config.ipv4_ttl = init_fw_cb->ipv4_ttl;
+	ha->ip_config.def_timeout = le16_to_cpu(init_fw_cb->def_timeout);
+	ha->ip_config.abort_timer = init_fw_cb->abort_timer;
+	ha->ip_config.iscsi_options = le16_to_cpu(init_fw_cb->iscsi_opts);
+	ha->ip_config.iscsi_max_pdu_size =
+				le16_to_cpu(init_fw_cb->iscsi_max_pdu_size);
+	ha->ip_config.iscsi_fburst_len =
+				le16_to_cpu(init_fw_cb->iscsi_fburst_len);
+	ha->ip_config.iscsi_max_outstnd_r2t =
+				le16_to_cpu(init_fw_cb->iscsi_max_outstnd_r2t);
+	ha->ip_config.iscsi_max_burst_len =
+				le16_to_cpu(init_fw_cb->iscsi_max_burst_len);
+	memcpy(ha->ip_config.iscsi_name, init_fw_cb->iscsi_name,
+	       min(sizeof(ha->ip_config.iscsi_name),
+		   sizeof(init_fw_cb->iscsi_name)));
 
 	if (is_ipv6_enabled(ha)) {
 		/* Save IPv6 Address */
 		ha->ip_config.ipv6_link_local_state =
-			le16_to_cpu(init_fw_cb->ipv6_lnk_lcl_addr_state);
+		  qla4xxx_set_ipaddr_state(init_fw_cb->ipv6_lnk_lcl_addr_state);
 		ha->ip_config.ipv6_addr0_state =
-				le16_to_cpu(init_fw_cb->ipv6_addr0_state);
+			qla4xxx_set_ipaddr_state(init_fw_cb->ipv6_addr0_state);
 		ha->ip_config.ipv6_addr1_state =
-				le16_to_cpu(init_fw_cb->ipv6_addr1_state);
-		ha->ip_config.ipv6_default_router_state =
-				le16_to_cpu(init_fw_cb->ipv6_dflt_rtr_state);
+			qla4xxx_set_ipaddr_state(init_fw_cb->ipv6_addr1_state);
+
+		switch (le16_to_cpu(init_fw_cb->ipv6_dflt_rtr_state)) {
+		case IPV6_RTRSTATE_UNKNOWN:
+			ha->ip_config.ipv6_default_router_state =
+						ISCSI_ROUTER_STATE_UNKNOWN;
+			break;
+		case IPV6_RTRSTATE_MANUAL:
+			ha->ip_config.ipv6_default_router_state =
+						ISCSI_ROUTER_STATE_MANUAL;
+			break;
+		case IPV6_RTRSTATE_ADVERTISED:
+			ha->ip_config.ipv6_default_router_state =
+						ISCSI_ROUTER_STATE_ADVERTISED;
+			break;
+		case IPV6_RTRSTATE_STALE:
+			ha->ip_config.ipv6_default_router_state =
+						ISCSI_ROUTER_STATE_STALE;
+			break;
+		default:
+			ha->ip_config.ipv6_default_router_state =
+						ISCSI_ROUTER_STATE_UNKNOWN;
+		}
+
 		ha->ip_config.ipv6_link_local_addr.in6_u.u6_addr8[0] = 0xFE;
 		ha->ip_config.ipv6_link_local_addr.in6_u.u6_addr8[1] = 0x80;
 
@@ -478,6 +564,27 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 		ha->ip_config.ipv6_vlan_tag =
 				be16_to_cpu(init_fw_cb->ipv6_vlan_tag);
 		ha->ip_config.ipv6_port = le16_to_cpu(init_fw_cb->ipv6_port);
+		ha->ip_config.ipv6_cache_id = init_fw_cb->ipv6_cache_id;
+		memcpy(&ha->ip_config.ipv6_isns_addr,
+		       init_fw_cb->ipv6_isns_addr,
+		       min(sizeof(ha->ip_config.ipv6_isns_addr),
+			   sizeof(init_fw_cb->ipv6_isns_addr)));
+		ha->ip_config.ipv6_flow_lbl =
+				le16_to_cpu(init_fw_cb->ipv6_flow_lbl);
+		ha->ip_config.ipv6_traffic_class =
+				init_fw_cb->ipv6_traffic_class;
+		ha->ip_config.ipv6_hop_limit = init_fw_cb->ipv6_hop_limit;
+		ha->ip_config.ipv6_nd_reach_time =
+				le32_to_cpu(init_fw_cb->ipv6_nd_reach_time);
+		ha->ip_config.ipv6_nd_rexmit_timer =
+				le32_to_cpu(init_fw_cb->ipv6_nd_rexmit_timer);
+		ha->ip_config.ipv6_nd_stale_timeout =
+				le32_to_cpu(init_fw_cb->ipv6_nd_stale_timeout);
+		ha->ip_config.ipv6_dup_addr_detect_count =
+					init_fw_cb->ipv6_dup_addr_detect_count;
+		ha->ip_config.ipv6_gw_advrt_mtu =
+				le32_to_cpu(init_fw_cb->ipv6_gw_advrt_mtu);
+		ha->ip_config.ipv6_tcp_wsf = init_fw_cb->ipv6_tcp_wsf;
 	}
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4d231c1..3313358 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -399,6 +399,63 @@ static umode_t qla4_attr_is_visible(int param_type, int param)
 		case ISCSI_NET_PARAM_VLAN_ENABLED:
 		case ISCSI_NET_PARAM_MTU:
 		case ISCSI_NET_PARAM_PORT:
+		case ISCSI_NET_PARAM_IPADDR_STATE:
+		case ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE:
+		case ISCSI_NET_PARAM_IPV6_ROUTER_STATE:
+		case ISCSI_NET_PARAM_DELAYED_ACK_EN:
+		case ISCSI_NET_PARAM_ISNS_EN:
+		case ISCSI_NET_PARAM_ISNS_ADDR:
+		case ISCSI_NET_PARAM_ISNS_PORT:
+		case ISCSI_NET_PARAM_NAGLE_EN:
+		case ISCSI_NET_PARAM_TCP_WIN_SCALE_EN:
+		case ISCSI_NET_PARAM_TCP_WIN_SCALE:
+		case ISCSI_NET_PARAM_TCP_TIMER_SCALE:
+		case ISCSI_NET_PARAM_TCP_TIMESTAMP_EN:
+		case ISCSI_NET_PARAM_CACHE_ID:
+		case ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_REQ_ISNS_INFO_EN:
+		case ISCSI_NET_PARAM_IPV4_TOS_EN:
+		case ISCSI_NET_PARAM_IPV4_TOS:
+		case ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID:
+		case ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID:
+		case ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN:
+		case ISCSI_NET_PARAM_IPV4_FRAGMENT_EN:
+		case ISCSI_NET_PARAM_IPV4_IN_FORWARD_EN:
+		case ISCSI_NET_PARAM_REDIRECT_EN:
+		case ISCSI_NET_PARAM_IPV4_TTL:
+		case ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN:
+		case ISCSI_NET_PARAM_IPV6_MLD_EN:
+		case ISCSI_NET_PARAM_IPV6_FLOW_LABEL:
+		case ISCSI_NET_PARAM_IPV6_TRAFFIC_CLASS:
+		case ISCSI_NET_PARAM_IPV6_HOP_LIMIT:
+		case ISCSI_NET_PARAM_IPV6_ND_REACHABLE_TMO:
+		case ISCSI_NET_PARAM_IPV6_ND_REXMIT_TIME:
+		case ISCSI_NET_PARAM_IPV6_ND_STALE_TMO:
+		case ISCSI_NET_PARAM_IPV6_DUP_ADDR_DET_CNT:
+		case ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU:
+		case ISCSI_NET_PARAM_DEF_TMF_TMO:
+		case ISCSI_NET_PARAM_DEF_HDRDGST_EN:
+		case ISCSI_NET_PARAM_DEF_DATADGST_EN:
+		case ISCSI_NET_PARAM_DEF_IMM_DATA_EN:
+		case ISCSI_NET_PARAM_DEF_INITIAL_R2T_EN:
+		case ISCSI_NET_PARAM_DEF_DATASEQ_INORDER_EN:
+		case ISCSI_NET_PARAM_DEF_PDU_INORDER_EN:
+		case ISCSI_NET_PARAM_DEF_ERL:
+		case ISCSI_NET_PARAM_DEF_MAX_RECV_DLENGTH:
+		case ISCSI_NET_PARAM_DEF_FIRST_BURST:
+		case ISCSI_NET_PARAM_DEF_MAX_R2T:
+		case ISCSI_NET_PARAM_DEF_MAX_BURST:
+		case ISCSI_NET_PARAM_DEF_CHAP_AUTH_EN:
+		case ISCSI_NET_PARAM_DEF_BIDI_CHAP_EN:
+		case ISCSI_NET_PARAM_DEF_STRICT_LOGIN_COMP_EN:
+		case ISCSI_NET_PARAM_DEF_DISCOVERY_AUTH_EN:
+		case ISCSI_NET_PARAM_DEF_DISCOVERY_LOGOUT_EN:
+		case ISCSI_NET_PARAM_DEF_ISCSI_NAME:
 			return S_IRUGO;
 		default:
 			return 0;
@@ -758,6 +815,339 @@ static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
 			len = sprintf(buf, "%d\n", ha->ip_config.ipv6_port);
 		break;
+	case ISCSI_NET_PARAM_IPADDR_STATE:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
+			len = sprintf(buf, "%s\n",
+				      iscsi_get_ipaddress_state_name(
+						ha->ip_config.ipv4_addr_state));
+		} else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6) {
+			if (iface->iface_num == 0)
+				len = sprintf(buf, "%s\n",
+					      iscsi_get_ipaddress_state_name(
+					      ha->ip_config.ipv6_addr0_state));
+			else if (iface->iface_num == 1)
+				len = sprintf(buf, "%s\n",
+					      iscsi_get_ipaddress_state_name(
+					      ha->ip_config.ipv6_addr1_state));
+		}
+		break;
+	case ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE:
+		len = sprintf(buf, "%s\n",
+			      iscsi_get_ipaddress_state_name(
+					ha->ip_config.ipv6_link_local_state));
+		break;
+	case ISCSI_NET_PARAM_IPV6_ROUTER_STATE:
+		len = sprintf(buf, "%s\n",
+			      iscsi_get_router_state_name(
+				ha->ip_config.ipv6_default_router_state));
+		break;
+	case ISCSI_NET_PARAM_DELAYED_ACK_EN:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.tcp_options &
+				       TCPOPT_DELAYED_ACK_DISABLE) ?
+				      "disabled" : "enabled");
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv6_tcp_options &
+				       IPV6_TCPOPT_DELAYED_ACK_DISABLE) ?
+				      "disabled" : "enabled");
+		break;
+	case ISCSI_NET_PARAM_ISNS_EN:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.tcp_options &
+				       TCPOPT_ISNS_ENABLE) ?
+				      "enabled" : "disabled");
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv6_tcp_options &
+				       IPV6_TCPOPT_ISNS_ENABLE) ?
+				      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_ISNS_ADDR:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%pI4\n", &ha->ip_config.isns_addr);
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%pI6\n",
+				      &ha->ip_config.ipv6_isns_addr);
+		break;
+	case ISCSI_NET_PARAM_ISNS_PORT:
+		len = sprintf(buf, "%d\n", ha->ip_config.isns_port);
+		break;
+	case ISCSI_NET_PARAM_NAGLE_EN:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.tcp_options &
+				       TCPOPT_NAGLE_ALGO_DISABLE) ?
+				      "disabled" : "enabled");
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv6_tcp_options &
+				       IPV6_TCPOPT_NAGLE_ALGO_DISABLE) ?
+				      "disabled" : "enabled");
+		break;
+	case ISCSI_NET_PARAM_TCP_WIN_SCALE_EN:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.tcp_options &
+				       TCPOPT_WINDOW_SCALE_DISABLE) ?
+				      "disabled" : "enabled");
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv6_tcp_options &
+				       IPV6_TCPOPT_WINDOW_SCALE_DISABLE) ?
+				      "disabled" : "enabled");
+		break;
+	case ISCSI_NET_PARAM_TCP_WIN_SCALE:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%d\n", ha->ip_config.tcp_wsf);
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%d\n", ha->ip_config.ipv6_tcp_wsf);
+		break;
+	case ISCSI_NET_PARAM_TCP_TIMER_SCALE:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%d\n",
+				      ((ha->ip_config.tcp_options &
+					TCPOPT_TIMER_SCALE) >> 1));
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%d\n",
+				      ((ha->ip_config.ipv6_tcp_options &
+					IPV6_TCPOPT_TIMER_SCALE) >> 1));
+		break;
+	case ISCSI_NET_PARAM_TCP_TIMESTAMP_EN:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.tcp_options &
+				       TCPOPT_TIMESTAMP_ENABLE) ?
+				      "enabled" : "disabled");
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv6_tcp_options &
+				       IPV6_TCPOPT_TIMESTAMP_ENABLE) ?
+				      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_CACHE_ID:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%d\n", ha->ip_config.ipv4_cache_id);
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%d\n", ha->ip_config.ipv6_cache_id);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.tcp_options &
+			       TCPOPT_DNS_SERVER_IP_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.tcp_options &
+			       TCPOPT_SLP_DA_INFO_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_REQ_ISNS_INFO_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.tcp_options &
+			       TCPOPT_ISNS_INFO_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_TOS_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv4_options &
+			       IPOPT_IPV4_TOS_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_TOS:
+		len = sprintf(buf, "%d\n", ha->ip_config.ipv4_tos);
+		break;
+	case ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv4_options &
+			       IPOPT_GRAT_ARP_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv4_options &
+			       IPOPT_ALT_CID_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID:
+		len = sprintf(buf, "%s\n", ha->ip_config.ipv4_alt_cid);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv4_options &
+			       IPOPT_REQ_VID_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv4_options &
+			       IPOPT_USE_VID_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID:
+		len = sprintf(buf, "%s\n", ha->ip_config.ipv4_vid);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv4_options &
+			       IPOPT_LEARN_IQN_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_FRAGMENT_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv4_options &
+			       IPOPT_FRAGMENTATION_DISABLE) ?
+			      "disabled" : "enabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_IN_FORWARD_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv4_options &
+			       IPOPT_INCOM_FORWARD_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_REDIRECT_EN:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv4_options &
+				       IPOPT_ARP_REDIRECT_ENABLE) ?
+				      "enabled" : "disabled");
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv6_options &
+				       IPV6_OPT_REDIRECT_ENABLE) ?
+				      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV4_TTL:
+		len = sprintf(buf, "%d\n", ha->ip_config.ipv4_ttl);
+		break;
+	case ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv6_options &
+			       IPV6_OPT_GRAT_NEIGHBOR_ADV_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV6_MLD_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv6_addl_options &
+			       IPV6_ADDOPT_MLD_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_IPV6_FLOW_LABEL:
+		len = sprintf(buf, "%d\n", ha->ip_config.ipv6_flow_lbl);
+		break;
+	case ISCSI_NET_PARAM_IPV6_TRAFFIC_CLASS:
+		len = sprintf(buf, "%d\n", ha->ip_config.ipv6_traffic_class);
+		break;
+	case ISCSI_NET_PARAM_IPV6_HOP_LIMIT:
+		len = sprintf(buf, "%d\n", ha->ip_config.ipv6_hop_limit);
+		break;
+	case ISCSI_NET_PARAM_IPV6_ND_REACHABLE_TMO:
+		len = sprintf(buf, "%d\n", ha->ip_config.ipv6_nd_reach_time);
+		break;
+	case ISCSI_NET_PARAM_IPV6_ND_REXMIT_TIME:
+		len = sprintf(buf, "%d\n", ha->ip_config.ipv6_nd_rexmit_timer);
+		break;
+	case ISCSI_NET_PARAM_IPV6_ND_STALE_TMO:
+		len = sprintf(buf, "%d\n", ha->ip_config.ipv6_nd_stale_timeout);
+		break;
+	case ISCSI_NET_PARAM_IPV6_DUP_ADDR_DET_CNT:
+		len = sprintf(buf, "%d\n",
+			      ha->ip_config.ipv6_dup_addr_detect_count);
+		break;
+	case ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU:
+		len = sprintf(buf, "%d\n", ha->ip_config.ipv6_gw_advrt_mtu);
+		break;
+	case ISCSI_NET_PARAM_DEF_TMF_TMO:
+		len = sprintf(buf, "%d\n", ha->ip_config.def_timeout);
+		break;
+	case ISCSI_NET_PARAM_DEF_HDRDGST_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_HEADER_DIGEST_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_DATADGST_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_DATA_DIGEST_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_IMM_DATA_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_IMMEDIATE_DATA_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_INITIAL_R2T_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_INITIAL_R2T_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_DATASEQ_INORDER_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_DATA_SEQ_INORDER_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_PDU_INORDER_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_DATA_PDU_INORDER_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_ERL:
+		len = sprintf(buf, "%d\n", (ha->ip_config.iscsi_options &
+					    ISCSIOPT_ERR_RECOVERY_LEVEL_MASK));
+		break;
+	case ISCSI_NET_PARAM_DEF_MAX_RECV_DLENGTH:
+		len = sprintf(buf, "%d\n", ha->ip_config.iscsi_max_pdu_size);
+		break;
+	case ISCSI_NET_PARAM_DEF_FIRST_BURST:
+		len = sprintf(buf, "%d\n", ha->ip_config.iscsi_fburst_len);
+		break;
+	case ISCSI_NET_PARAM_DEF_MAX_R2T:
+		len = sprintf(buf, "%d\n", ha->ip_config.iscsi_max_outstnd_r2t);
+		break;
+	case ISCSI_NET_PARAM_DEF_MAX_BURST:
+		len = sprintf(buf, "%d\n", ha->ip_config.iscsi_max_burst_len);
+		break;
+	case ISCSI_NET_PARAM_DEF_CHAP_AUTH_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_CHAP_AUTH_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_BIDI_CHAP_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_BIDI_CHAP_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_STRICT_LOGIN_COMP_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_STRICT_LOGIN_COMP_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_DISCOVERY_AUTH_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_DISCOVERY_AUTH_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_DISCOVERY_LOGOUT_EN:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.iscsi_options &
+			       ISCSIOPT_DISCOVERY_LOGOUT_ENABLE) ?
+			      "enabled" : "disabled");
+		break;
+	case ISCSI_NET_PARAM_DEF_ISCSI_NAME:
+		len = sprintf(buf, "%s\n", ha->ip_config.iscsi_name);
+		break;
 	default:
 		len = -ENOSYS;
 	}
@@ -1198,6 +1588,300 @@ static void qla4xxx_set_ipv6(struct scsi_qla_host *ha,
 		init_fw_cb->ipv6_port =
 				cpu_to_le16(*(uint16_t *)iface_param->value);
 		break;
+	case ISCSI_NET_PARAM_DELAYED_ACK_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16(IPV6_TCPOPT_DELAYED_ACK_DISABLE);
+		else
+			init_fw_cb->ipv6_tcp_opts &=
+				cpu_to_le16(~IPV6_TCPOPT_DELAYED_ACK_DISABLE &
+					    0xFFFF);
+		break;
+	case ISCSI_NET_PARAM_ISNS_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16(IPV6_TCPOPT_ISNS_ENABLE);
+		else
+			init_fw_cb->ipv6_tcp_opts &=
+				cpu_to_le16(~IPV6_TCPOPT_ISNS_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_ISNS_ADDR:
+		if (iface_param->iface_num & 0x1)
+			break;
+		memcpy(init_fw_cb->ipv6_isns_addr, iface_param->value,
+		       sizeof(init_fw_cb->ipv6_isns_addr));
+		break;
+	case ISCSI_NET_PARAM_NAGLE_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16(IPV6_TCPOPT_NAGLE_ALGO_DISABLE);
+		else
+			init_fw_cb->ipv6_tcp_opts &=
+				cpu_to_le16(~IPV6_TCPOPT_NAGLE_ALGO_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_WIN_SCALE_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16(IPV6_TCPOPT_WINDOW_SCALE_DISABLE);
+		else
+			init_fw_cb->ipv6_tcp_opts &=
+				cpu_to_le16(~IPV6_TCPOPT_WINDOW_SCALE_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_WIN_SCALE:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_tcp_wsf = iface_param->value[0];
+		break;
+	case ISCSI_NET_PARAM_TCP_TIMER_SCALE:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_tcp_opts &= cpu_to_le16(~TCPOPT_TIMER_SCALE);
+		init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16((iface_param->value[0] << 1) &
+					    TCPOPT_TIMER_SCALE);
+		break;
+	case ISCSI_NET_PARAM_TCP_TIMESTAMP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16(IPV6_TCPOPT_TIMESTAMP_ENABLE);
+		else
+			init_fw_cb->ipv6_tcp_opts &=
+				cpu_to_le16(~IPV6_TCPOPT_TIMESTAMP_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv6_opts |=
+				cpu_to_le16(IPV6_OPT_GRAT_NEIGHBOR_ADV_ENABLE);
+		else
+			init_fw_cb->ipv6_opts &=
+				cpu_to_le16(~IPV6_OPT_GRAT_NEIGHBOR_ADV_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_REDIRECT_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv6_opts |=
+				cpu_to_le16(IPV6_OPT_REDIRECT_ENABLE);
+		else
+			init_fw_cb->ipv6_opts &=
+				cpu_to_le16(~IPV6_OPT_REDIRECT_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV6_MLD_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv6_addtl_opts |=
+				cpu_to_le16(IPV6_ADDOPT_MLD_ENABLE);
+		else
+			init_fw_cb->ipv6_addtl_opts &=
+				cpu_to_le16(~IPV6_ADDOPT_MLD_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV6_FLOW_LABEL:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_flow_lbl =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_IPV6_TRAFFIC_CLASS:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_traffic_class = iface_param->value[0];
+		break;
+	case ISCSI_NET_PARAM_IPV6_HOP_LIMIT:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_hop_limit = iface_param->value[0];
+		break;
+	case ISCSI_NET_PARAM_IPV6_ND_REACHABLE_TMO:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_nd_reach_time =
+				cpu_to_le32(*(uint32_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_IPV6_ND_REXMIT_TIME:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_nd_rexmit_timer =
+				cpu_to_le32(*(uint32_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_IPV6_ND_STALE_TMO:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_nd_stale_timeout =
+				cpu_to_le32(*(uint32_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_IPV6_DUP_ADDR_DET_CNT:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_dup_addr_detect_count = iface_param->value[0];
+		break;
+	case ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_gw_advrt_mtu =
+				cpu_to_le32(*(uint32_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_TMF_TMO:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->def_timeout =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_HDRDGST_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_HEADER_DIGEST_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_HEADER_DIGEST_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_DATADGST_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DATA_DIGEST_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DATA_DIGEST_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_IMM_DATA_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_IMMEDIATE_DATA_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_IMMEDIATE_DATA_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_INITIAL_R2T_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_INITIAL_R2T_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_INITIAL_R2T_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_DATASEQ_INORDER_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DATA_SEQ_INORDER_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DATA_SEQ_INORDER_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_PDU_INORDER_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DATA_PDU_INORDER_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DATA_PDU_INORDER_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_ERL:
+		if (iface_param->iface_num & 0x1)
+			break;
+		/* Set lower 2 bits to zero */
+		init_fw_cb->iscsi_opts &= 0xFFFC;
+		init_fw_cb->iscsi_opts |=
+				cpu_to_le16(iface_param->value[0] &
+					    ISCSIOPT_ERR_RECOVERY_LEVEL_MASK);
+		break;
+	case ISCSI_NET_PARAM_DEF_MAX_RECV_DLENGTH:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_max_pdu_size =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_FIRST_BURST:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_fburst_len =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_MAX_R2T:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_max_outstnd_r2t =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_MAX_BURST:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_max_burst_len =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_CHAP_AUTH_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_CHAP_AUTH_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_CHAP_AUTH_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_BIDI_CHAP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_BIDI_CHAP_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_BIDI_CHAP_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_STRICT_LOGIN_COMP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_STRICT_LOGIN_COMP_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_STRICT_LOGIN_COMP_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_DISCOVERY_AUTH_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DISCOVERY_AUTH_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DISCOVERY_AUTH_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_DISCOVERY_LOGOUT_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DISCOVERY_LOGOUT_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DISCOVERY_LOGOUT_ENABLE);
+		break;
 	default:
 		ql4_printk(KERN_ERR, ha, "Unknown IPv6 param = %d\n",
 			   iface_param->param);
@@ -1266,6 +1950,379 @@ static void qla4xxx_set_ipv4(struct scsi_qla_host *ha,
 		init_fw_cb->ipv4_port =
 				cpu_to_le16(*(uint16_t *)iface_param->value);
 		break;
+	case ISCSI_NET_PARAM_DELAYED_ACK_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_DELAYED_ACK_DISABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_DELAYED_ACK_DISABLE &
+					    0xFFFF);
+		break;
+	case ISCSI_NET_PARAM_ISNS_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_ISNS_ENABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_ISNS_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_ISNS_ADDR:
+		if (iface_param->iface_num & 0x1)
+			break;
+		memcpy(init_fw_cb->ipv4_isns_addr, iface_param->value,
+		       sizeof(init_fw_cb->ipv4_isns_addr));
+		break;
+	case ISCSI_NET_PARAM_ISNS_PORT:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv4_isns_port =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_NAGLE_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_NAGLE_ALGO_DISABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_NAGLE_ALGO_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_WIN_SCALE_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_WINDOW_SCALE_DISABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_WINDOW_SCALE_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_WIN_SCALE:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv4_tcp_wsf = iface_param->value[0];
+		break;
+	case ISCSI_NET_PARAM_TCP_TIMER_SCALE:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv4_tcp_opts &= cpu_to_le16(~TCPOPT_TIMER_SCALE);
+		init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16((iface_param->value[0] << 1) &
+					    TCPOPT_TIMER_SCALE);
+		break;
+	case ISCSI_NET_PARAM_TCP_TIMESTAMP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_TIMESTAMP_ENABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_TIMESTAMP_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_DNS_SERVER_IP_ENABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_DNS_SERVER_IP_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_SLP_DA_INFO_ENABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_SLP_DA_INFO_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_REQ_ISNS_INFO_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_ISNS_INFO_ENABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_ISNS_INFO_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_TOS_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+				cpu_to_le16(IPOPT_IPV4_TOS_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_IPV4_TOS_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_TOS:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv4_tos = iface_param->value[0];
+		break;
+	case ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+					cpu_to_le16(IPOPT_GRAT_ARP_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+					cpu_to_le16(~IPOPT_GRAT_ARP_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+				cpu_to_le16(IPOPT_ALT_CID_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_ALT_CID_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID:
+		if (iface_param->iface_num & 0x1)
+			break;
+		memcpy(init_fw_cb->ipv4_dhcp_alt_cid, iface_param->value,
+		       (sizeof(init_fw_cb->ipv4_dhcp_alt_cid) - 1));
+		init_fw_cb->ipv4_dhcp_alt_cid_len =
+					strlen(init_fw_cb->ipv4_dhcp_alt_cid);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+					cpu_to_le16(IPOPT_REQ_VID_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+					cpu_to_le16(~IPOPT_REQ_VID_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+					cpu_to_le16(IPOPT_USE_VID_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+					cpu_to_le16(~IPOPT_USE_VID_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID:
+		if (iface_param->iface_num & 0x1)
+			break;
+		memcpy(init_fw_cb->ipv4_dhcp_vid, iface_param->value,
+		       (sizeof(init_fw_cb->ipv4_dhcp_vid) - 1));
+		init_fw_cb->ipv4_dhcp_vid_len =
+					strlen(init_fw_cb->ipv4_dhcp_vid);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+					cpu_to_le16(IPOPT_LEARN_IQN_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+					cpu_to_le16(~IPOPT_LEARN_IQN_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_FRAGMENT_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv4_ip_opts |=
+				cpu_to_le16(IPOPT_FRAGMENTATION_DISABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_FRAGMENTATION_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_IN_FORWARD_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+				cpu_to_le16(IPOPT_INCOM_FORWARD_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_INCOM_FORWARD_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_REDIRECT_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+				cpu_to_le16(IPOPT_ARP_REDIRECT_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_ARP_REDIRECT_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_IPV4_TTL:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv4_ttl = iface_param->value[0];
+		break;
+	case ISCSI_NET_PARAM_DEF_TMF_TMO:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->def_timeout =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_HDRDGST_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_HEADER_DIGEST_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_HEADER_DIGEST_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_DATADGST_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DATA_DIGEST_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DATA_DIGEST_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_IMM_DATA_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_IMMEDIATE_DATA_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_IMMEDIATE_DATA_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_INITIAL_R2T_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_INITIAL_R2T_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_INITIAL_R2T_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_DATASEQ_INORDER_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DATA_SEQ_INORDER_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DATA_SEQ_INORDER_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_PDU_INORDER_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DATA_PDU_INORDER_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DATA_PDU_INORDER_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_ERL:
+		if (iface_param->iface_num & 0x1)
+			break;
+		/* Set lower 2 bits to zero */
+		init_fw_cb->iscsi_opts >>= 2;
+		init_fw_cb->iscsi_opts <<= 2;
+
+		init_fw_cb->iscsi_opts |=
+				cpu_to_le16(iface_param->value[0] &
+					    ISCSIOPT_ERR_RECOVERY_LEVEL_MASK);
+		break;
+	case ISCSI_NET_PARAM_DEF_MAX_RECV_DLENGTH:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_max_pdu_size =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_FIRST_BURST:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_fburst_len =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_MAX_R2T:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_max_outstnd_r2t =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_MAX_BURST:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_max_burst_len =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_DEF_CHAP_AUTH_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_CHAP_AUTH_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_CHAP_AUTH_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_BIDI_CHAP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_BIDI_CHAP_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_BIDI_CHAP_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_STRICT_LOGIN_COMP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_STRICT_LOGIN_COMP_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_STRICT_LOGIN_COMP_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_DISCOVERY_AUTH_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DISCOVERY_AUTH_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DISCOVERY_AUTH_ENABLE);
+		break;
+	case ISCSI_NET_PARAM_DEF_DISCOVERY_LOGOUT_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPT_DISCOVERY_LOGOUT_ENABLE);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPT_DISCOVERY_LOGOUT_ENABLE);
+		break;
 	default:
 		ql4_printk(KERN_ERR, ha, "Unknown IPv4 param = %d\n",
 			   iface_param->param);
-- 
1.8.2.GIT


