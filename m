From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH V2 3/4] qla4xxx: Add support for additional network parameters settings
Date: Fri, 18 Oct 2013 09:01:42 -0400
Message-ID: <1382101303-3420-4-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1382101303-3420-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:22035 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210Ab3JRNdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Oct 2013 09:33:31 -0400
In-Reply-To: <1382101303-3420-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Added support to display and update additional network parameters
through iscsiadm.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |   32 ++
 drivers/scsi/qla4xxx/ql4_fw.h   |   43 ++-
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
 drivers/scsi/qla4xxx/ql4_isr.c  |   32 ++
 drivers/scsi/qla4xxx/ql4_mbx.c  |  111 ++++-
 drivers/scsi/qla4xxx/ql4_os.c   | 1126 ++++++++++++++++++++++++++++++++++-----
 6 files changed, 1212 insertions(+), 133 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 084d1fd..e2be308 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -179,6 +179,10 @@
 		n &= ~v;	\
 }
 
+#define OP_STATE(o, f, p) {			\
+	p = (o & f) ? "enable" : "disable";	\
+}
+
 /*
  * Retry & Timeout Values
  */
@@ -476,6 +480,34 @@ struct ipaddress_config {
 	uint16_t eth_mtu_size;
 	uint16_t ipv4_port;
 	uint16_t ipv6_port;
+	uint8_t control;
+	uint16_t ipv6_tcp_options;
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
+	uint16_t iscsi_first_burst_len;
+	uint16_t iscsi_max_outstnd_r2t;
+	uint16_t iscsi_max_burst_len;
+	uint8_t iscsi_name[224];
 };
 
 #define QL4_CHAP_MAX_NAME_LEN 256
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 1243e59..3060652 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -551,6 +551,7 @@ struct addr_ctrl_blk {
 #define  IFCB_VER_MIN			0x01
 #define  IFCB_VER_MAX			0x02
 	uint8_t control;	/* 01 */
+#define	 CTRLOPT_NEW_CONN_DISABLE	0x0002
 
 	uint16_t fw_options;	/* 02-03 */
 #define	 FWOPT_HEARTBEAT_ENABLE		  0x1000
@@ -582,11 +583,40 @@ struct addr_ctrl_blk {
 	uint32_t shdwreg_addr_hi;	/* 2C-2F */
 
 	uint16_t iscsi_opts;	/* 30-31 */
+#define ISCSIOPTS_HEADER_DIGEST_EN		0x2000
+#define ISCSIOPTS_DATA_DIGEST_EN		0x1000
+#define ISCSIOPTS_IMMEDIATE_DATA_EN		0x0800
+#define ISCSIOPTS_INITIAL_R2T_EN		0x0400
+#define ISCSIOPTS_DATA_SEQ_INORDER_EN		0x0200
+#define ISCSIOPTS_DATA_PDU_INORDER_EN		0x0100
+#define ISCSIOPTS_CHAP_AUTH_EN			0x0080
+#define ISCSIOPTS_SNACK_EN			0x0040
+#define ISCSIOPTS_DISCOVERY_LOGOUT_EN		0x0020
+#define ISCSIOPTS_BIDI_CHAP_EN			0x0010
+#define ISCSIOPTS_DISCOVERY_AUTH_EN		0x0008
+#define ISCSIOPTS_STRICT_LOGIN_COMP_EN		0x0004
+#define ISCSIOPTS_ERL				0x0003
 	uint16_t ipv4_tcp_opts;	/* 32-33 */
+#define TCPOPT_DELAYED_ACK_DISABLE	0x8000
 #define TCPOPT_DHCP_ENABLE		0x0200
+#define TCPOPT_DNS_SERVER_IP_EN		0x0100
+#define TCPOPT_SLP_DA_INFO_EN		0x0080
+#define TCPOPT_NAGLE_ALGO_DISABLE	0x0020
+#define TCPOPT_WINDOW_SCALE_DISABLE	0x0010
+#define TCPOPT_TIMER_SCALE		0x000E
+#define TCPOPT_TIMESTAMP_ENABLE		0x0001
 	uint16_t ipv4_ip_opts;	/* 34-35 */
 #define IPOPT_IPV4_PROTOCOL_ENABLE	0x8000
+#define IPOPT_IPV4_TOS_EN		0x4000
 #define IPOPT_VLAN_TAGGING_ENABLE	0x2000
+#define IPOPT_GRAT_ARP_EN		0x1000
+#define IPOPT_ALT_CID_EN		0x0800
+#define IPOPT_REQ_VID_EN		0x0400
+#define IPOPT_USE_VID_EN		0x0200
+#define IPOPT_LEARN_IQN_EN		0x0100
+#define IPOPT_FRAGMENTATION_DISABLE	0x0010
+#define IPOPT_IN_FORWARD_EN		0x0008
+#define IPOPT_ARP_REDIRECT_EN		0x0004
 
 	uint16_t iscsi_max_pdu_size;	/* 36-37 */
 	uint8_t ipv4_tos;	/* 38 */
@@ -637,15 +667,24 @@ struct addr_ctrl_blk {
 	uint32_t cookie;	/* 200-203 */
 	uint16_t ipv6_port;	/* 204-205 */
 	uint16_t ipv6_opts;	/* 206-207 */
-#define IPV6_OPT_IPV6_PROTOCOL_ENABLE	0x8000
-#define IPV6_OPT_VLAN_TAGGING_ENABLE	0x2000
+#define IPV6_OPT_IPV6_PROTOCOL_ENABLE		0x8000
+#define IPV6_OPT_VLAN_TAGGING_ENABLE		0x2000
+#define IPV6_OPT_GRAT_NEIGHBOR_ADV_EN		0x1000
+#define IPV6_OPT_REDIRECT_EN			0x0004
 
 	uint16_t ipv6_addtl_opts;	/* 208-209 */
+#define IPV6_ADDOPT_IGNORE_ICMP_ECHO_REQ		0x0040
+#define IPV6_ADDOPT_MLD_EN				0x0004
 #define IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE	0x0002 /* Pri ACB
 								  Only */
 #define IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR		0x0001
 
 	uint16_t ipv6_tcp_opts;	/* 20A-20B */
+#define IPV6_TCPOPT_DELAYED_ACK_DISABLE		0x8000
+#define IPV6_TCPOPT_NAGLE_ALGO_DISABLE		0x0020
+#define IPV6_TCPOPT_WINDOW_SCALE_DISABLE	0x0010
+#define IPV6_TCPOPT_TIMER_SCALE			0x000E
+#define IPV6_TCPOPT_TIMESTAMP_EN		0x0001
 	uint8_t ipv6_tcp_wsf;	/* 20C */
 	uint16_t ipv6_flow_lbl;	/* 20D-20F */
 	uint8_t ipv6_dflt_rtr_addr[16]; /* 210-21F */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 5cef252..b8e87b3 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -276,6 +276,7 @@ int qla4xxx_get_acb(struct scsi_qla_host *ha, dma_addr_t acb_dma,
 int qla4_84xx_config_acb(struct scsi_qla_host *ha, int acb_config);
 int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha,
 				uint64_t addr, uint32_t *data, uint32_t count);
+uint8_t qla4xxx_set_ipaddr_state(uint8_t fw_ipaddr_state);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 7dff09f..66cc9c1 100644
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
@@ -741,6 +771,8 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			    "mbox_sts[3]=%04x\n", ha->host_no, mbox_sts[0],
 			    mbox_sts[2], mbox_sts[3]);
 
+			qla4xxx_update_ipaddr_state(ha, mbox_sts[5],
+						    mbox_sts[3]);
 			/* mbox_sts[2] = Old ACB state
 			 * mbox_sts[3] = new ACB state */
 			if ((mbox_sts[3] == ACB_STATE_VALID) &&
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 1bb3fde..3c0ea1e 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -418,6 +418,38 @@ qla4xxx_get_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
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
@@ -425,7 +457,7 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 	ha->ip_config.tcp_options = le16_to_cpu(init_fw_cb->ipv4_tcp_opts);
 	ha->ip_config.ipv4_options = le16_to_cpu(init_fw_cb->ipv4_ip_opts);
 	ha->ip_config.ipv4_addr_state =
-				le16_to_cpu(init_fw_cb->ipv4_addr_state);
+			qla4xxx_set_ipaddr_state(init_fw_cb->ipv4_addr_state);
 	ha->ip_config.eth_mtu_size =
 				le16_to_cpu(init_fw_cb->eth_mtu_size);
 	ha->ip_config.ipv4_port = le16_to_cpu(init_fw_cb->ipv4_port);
@@ -434,6 +466,8 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 		ha->ip_config.ipv6_options = le16_to_cpu(init_fw_cb->ipv6_opts);
 		ha->ip_config.ipv6_addl_options =
 				le16_to_cpu(init_fw_cb->ipv6_addtl_opts);
+		ha->ip_config.ipv6_tcp_options =
+				le16_to_cpu(init_fw_cb->ipv6_tcp_opts);
 	}
 
 	/* Save IPv4 Address Info */
@@ -448,17 +482,65 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 		   sizeof(init_fw_cb->ipv4_gw_addr)));
 
 	ha->ip_config.ipv4_vlan_tag = be16_to_cpu(init_fw_cb->ipv4_vlan_tag);
+	ha->ip_config.control = init_fw_cb->control;
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
+	ha->ip_config.iscsi_first_burst_len =
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
 
@@ -479,6 +561,23 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 		ha->ip_config.ipv6_vlan_tag =
 				be16_to_cpu(init_fw_cb->ipv6_vlan_tag);
 		ha->ip_config.ipv6_port = le16_to_cpu(init_fw_cb->ipv6_port);
+		ha->ip_config.ipv6_cache_id = init_fw_cb->ipv6_cache_id;
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
index 6dc3e99..da9fdcc 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -440,6 +440,65 @@ static umode_t qla4_attr_is_visible(int param_type, int param)
 		case ISCSI_NET_PARAM_VLAN_ENABLED:
 		case ISCSI_NET_PARAM_MTU:
 		case ISCSI_NET_PARAM_PORT:
+		case ISCSI_NET_PARAM_IPADDR_STATE:
+		case ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE:
+		case ISCSI_NET_PARAM_IPV6_ROUTER_STATE:
+		case ISCSI_NET_PARAM_DELAYED_ACK_EN:
+		case ISCSI_NET_PARAM_TCP_NAGLE_DISABLE:
+		case ISCSI_NET_PARAM_TCP_WSF_DISABLE:
+		case ISCSI_NET_PARAM_TCP_WSF:
+		case ISCSI_NET_PARAM_TCP_TIMER_SCALE:
+		case ISCSI_NET_PARAM_TCP_TIMESTAMP_EN:
+		case ISCSI_NET_PARAM_CACHE_ID:
+		case ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN:
+		case ISCSI_NET_PARAM_IPV4_TOS_EN:
+		case ISCSI_NET_PARAM_IPV4_TOS:
+		case ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID:
+		case ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN:
+		case ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID:
+		case ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN:
+		case ISCSI_NET_PARAM_IPV4_FRAGMENT_DISABLE:
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
+		case ISCSI_NET_PARAM_IPV6_DUP_ADDR_DETECT_CNT:
+		case ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU:
+			return S_IRUGO;
+		default:
+			return 0;
+		}
+	case ISCSI_IFACE_PARAM:
+		switch (param) {
+		case ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO:
+		case ISCSI_IFACE_PARAM_HDRDGST_EN:
+		case ISCSI_IFACE_PARAM_DATADGST_EN:
+		case ISCSI_IFACE_PARAM_IMM_DATA_EN:
+		case ISCSI_IFACE_PARAM_INITIAL_R2T_EN:
+		case ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN:
+		case ISCSI_IFACE_PARAM_PDU_INORDER_EN:
+		case ISCSI_IFACE_PARAM_ERL:
+		case ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH:
+		case ISCSI_IFACE_PARAM_FIRST_BURST:
+		case ISCSI_IFACE_PARAM_MAX_R2T:
+		case ISCSI_IFACE_PARAM_MAX_BURST:
+		case ISCSI_IFACE_PARAM_CHAP_AUTH_EN:
+		case ISCSI_IFACE_PARAM_BIDI_CHAP_EN:
+		case ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL:
+		case ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN:
+		case ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN:
+		case ISCSI_IFACE_PARAM_INITIATOR_NAME:
 			return S_IRUGO;
 		default:
 			return 0;
@@ -894,107 +953,437 @@ static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 {
 	struct Scsi_Host *shost = iscsi_iface_to_shost(iface);
 	struct scsi_qla_host *ha = to_qla_host(shost);
+	int ival;
+	char *pval = NULL;
 	int len = -ENOSYS;
 
-	if (param_type != ISCSI_NET_PARAM)
-		return -ENOSYS;
+	if (param_type == ISCSI_NET_PARAM) {
+		switch (param) {
+		case ISCSI_NET_PARAM_IPV4_ADDR:
+			len = sprintf(buf, "%pI4\n", &ha->ip_config.ip_address);
+			break;
+		case ISCSI_NET_PARAM_IPV4_SUBNET:
+			len = sprintf(buf, "%pI4\n",
+				      &ha->ip_config.subnet_mask);
+			break;
+		case ISCSI_NET_PARAM_IPV4_GW:
+			len = sprintf(buf, "%pI4\n", &ha->ip_config.gateway);
+			break;
+		case ISCSI_NET_PARAM_IFACE_ENABLE:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
+				OP_STATE(ha->ip_config.ipv4_options,
+					 IPOPT_IPV4_PROTOCOL_ENABLE, pval);
+			} else {
+				OP_STATE(ha->ip_config.ipv6_options,
+					 IPV6_OPT_IPV6_PROTOCOL_ENABLE, pval);
+			}
 
-	switch (param) {
-	case ISCSI_NET_PARAM_IPV4_ADDR:
-		len = sprintf(buf, "%pI4\n", &ha->ip_config.ip_address);
-		break;
-	case ISCSI_NET_PARAM_IPV4_SUBNET:
-		len = sprintf(buf, "%pI4\n", &ha->ip_config.subnet_mask);
-		break;
-	case ISCSI_NET_PARAM_IPV4_GW:
-		len = sprintf(buf, "%pI4\n", &ha->ip_config.gateway);
-		break;
-	case ISCSI_NET_PARAM_IFACE_ENABLE:
-		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
-			len = sprintf(buf, "%s\n",
-				      (ha->ip_config.ipv4_options &
-				       IPOPT_IPV4_PROTOCOL_ENABLE) ?
-				      "enabled" : "disabled");
-		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
 			len = sprintf(buf, "%s\n",
-				      (ha->ip_config.ipv6_options &
-				       IPV6_OPT_IPV6_PROTOCOL_ENABLE) ?
-				       "enabled" : "disabled");
-		break;
-	case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
-		len = sprintf(buf, "%s\n",
-			      (ha->ip_config.tcp_options & TCPOPT_DHCP_ENABLE) ?
-			      "dhcp" : "static");
-		break;
-	case ISCSI_NET_PARAM_IPV6_ADDR:
-		if (iface->iface_num == 0)
-			len = sprintf(buf, "%pI6\n", &ha->ip_config.ipv6_addr0);
-		if (iface->iface_num == 1)
-			len = sprintf(buf, "%pI6\n", &ha->ip_config.ipv6_addr1);
-		break;
-	case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
-		len = sprintf(buf, "%pI6\n",
-			      &ha->ip_config.ipv6_link_local_addr);
-		break;
-	case ISCSI_NET_PARAM_IPV6_ROUTER:
-		len = sprintf(buf, "%pI6\n",
-			      &ha->ip_config.ipv6_default_router_addr);
-		break;
-	case ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG:
-		len = sprintf(buf, "%s\n",
-			      (ha->ip_config.ipv6_addl_options &
-			       IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE) ?
-			       "nd" : "static");
-		break;
-	case ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG:
-		len = sprintf(buf, "%s\n",
-			      (ha->ip_config.ipv6_addl_options &
-			       IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR) ?
-			       "auto" : "static");
-		break;
-	case ISCSI_NET_PARAM_VLAN_ID:
-		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+				      (ha->ip_config.tcp_options &
+				       TCPOPT_DHCP_ENABLE) ?
+				      "dhcp" : "static");
+			break;
+		case ISCSI_NET_PARAM_IPV6_ADDR:
+			if (iface->iface_num == 0)
+				len = sprintf(buf, "%pI6\n",
+					      &ha->ip_config.ipv6_addr0);
+			if (iface->iface_num == 1)
+				len = sprintf(buf, "%pI6\n",
+					      &ha->ip_config.ipv6_addr1);
+			break;
+		case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
+			len = sprintf(buf, "%pI6\n",
+				      &ha->ip_config.ipv6_link_local_addr);
+			break;
+		case ISCSI_NET_PARAM_IPV6_ROUTER:
+			len = sprintf(buf, "%pI6\n",
+				      &ha->ip_config.ipv6_default_router_addr);
+			break;
+		case ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG:
+			pval = (ha->ip_config.ipv6_addl_options &
+				IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE) ?
+				"nd" : "static";
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG:
+			pval = (ha->ip_config.ipv6_addl_options &
+				IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR) ?
+				"auto" : "static";
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_VLAN_ID:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+				ival = ha->ip_config.ipv4_vlan_tag &
+				       ISCSI_MAX_VLAN_ID;
+			else
+				ival = ha->ip_config.ipv6_vlan_tag &
+				       ISCSI_MAX_VLAN_ID;
+
+			len = sprintf(buf, "%d\n", ival);
+			break;
+		case ISCSI_NET_PARAM_VLAN_PRIORITY:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+				ival = (ha->ip_config.ipv4_vlan_tag >> 13) &
+				       ISCSI_MAX_VLAN_PRIORITY;
+			else
+				ival = (ha->ip_config.ipv6_vlan_tag >> 13) &
+				       ISCSI_MAX_VLAN_PRIORITY;
+
+			len = sprintf(buf, "%d\n", ival);
+			break;
+		case ISCSI_NET_PARAM_VLAN_ENABLED:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
+				OP_STATE(ha->ip_config.ipv4_options,
+					 IPOPT_VLAN_TAGGING_ENABLE, pval);
+			} else {
+				OP_STATE(ha->ip_config.ipv6_options,
+					 IPV6_OPT_VLAN_TAGGING_ENABLE, pval);
+			}
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_MTU:
+			len = sprintf(buf, "%d\n", ha->ip_config.eth_mtu_size);
+			break;
+		case ISCSI_NET_PARAM_PORT:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+				len = sprintf(buf, "%d\n",
+					      ha->ip_config.ipv4_port);
+			else
+				len = sprintf(buf, "%d\n",
+					      ha->ip_config.ipv6_port);
+			break;
+		case ISCSI_NET_PARAM_IPADDR_STATE:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
+				pval = iscsi_get_ipaddress_state_name(
+						ha->ip_config.ipv4_addr_state);
+			} else {
+				if (iface->iface_num == 0)
+					pval = iscsi_get_ipaddress_state_name(
+						ha->ip_config.ipv6_addr0_state);
+				else if (iface->iface_num == 1)
+					pval = iscsi_get_ipaddress_state_name(
+						ha->ip_config.ipv6_addr1_state);
+			}
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE:
+			pval = iscsi_get_ipaddress_state_name(
+					ha->ip_config.ipv6_link_local_state);
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV6_ROUTER_STATE:
+			pval = iscsi_get_router_state_name(
+				      ha->ip_config.ipv6_default_router_state);
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_DELAYED_ACK_EN:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
+				OP_STATE(~ha->ip_config.tcp_options,
+					 TCPOPT_DELAYED_ACK_DISABLE, pval);
+			} else {
+				OP_STATE(~ha->ip_config.ipv6_tcp_options,
+					 IPV6_TCPOPT_DELAYED_ACK_DISABLE, pval);
+			}
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_TCP_NAGLE_DISABLE:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
+				OP_STATE(~ha->ip_config.tcp_options,
+					 TCPOPT_NAGLE_ALGO_DISABLE, pval);
+			} else {
+				OP_STATE(~ha->ip_config.ipv6_tcp_options,
+					 IPV6_TCPOPT_NAGLE_ALGO_DISABLE, pval);
+			}
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_TCP_WSF_DISABLE:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
+				OP_STATE(~ha->ip_config.tcp_options,
+					 TCPOPT_WINDOW_SCALE_DISABLE, pval);
+			} else {
+				OP_STATE(~ha->ip_config.ipv6_tcp_options,
+					 IPV6_TCPOPT_WINDOW_SCALE_DISABLE,
+					 pval);
+			}
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_TCP_WSF:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+				len = sprintf(buf, "%d\n",
+					      ha->ip_config.tcp_wsf);
+			else
+				len = sprintf(buf, "%d\n",
+					      ha->ip_config.ipv6_tcp_wsf);
+			break;
+		case ISCSI_NET_PARAM_TCP_TIMER_SCALE:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+				ival = (ha->ip_config.tcp_options &
+					TCPOPT_TIMER_SCALE) >> 1;
+			else
+				ival = (ha->ip_config.ipv6_tcp_options &
+					IPV6_TCPOPT_TIMER_SCALE) >> 1;
+
+			len = sprintf(buf, "%d\n", ival);
+			break;
+		case ISCSI_NET_PARAM_TCP_TIMESTAMP_EN:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
+				OP_STATE(ha->ip_config.tcp_options,
+					 TCPOPT_TIMESTAMP_ENABLE, pval);
+			} else {
+				OP_STATE(ha->ip_config.ipv6_tcp_options,
+					 IPV6_TCPOPT_TIMESTAMP_EN, pval);
+			}
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_CACHE_ID:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+				len = sprintf(buf, "%d\n",
+					      ha->ip_config.ipv4_cache_id);
+			else
+				len = sprintf(buf, "%d\n",
+					      ha->ip_config.ipv6_cache_id);
+			break;
+		case ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN:
+			OP_STATE(ha->ip_config.tcp_options,
+				 TCPOPT_DNS_SERVER_IP_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN:
+			OP_STATE(ha->ip_config.tcp_options,
+				 TCPOPT_SLP_DA_INFO_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_TOS_EN:
+			OP_STATE(ha->ip_config.ipv4_options,
+				 IPOPT_IPV4_TOS_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_TOS:
+			len = sprintf(buf, "%d\n", ha->ip_config.ipv4_tos);
+			break;
+		case ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN:
+			OP_STATE(ha->ip_config.ipv4_options,
+				 IPOPT_GRAT_ARP_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN:
+			OP_STATE(ha->ip_config.ipv4_options, IPOPT_ALT_CID_EN,
+				 pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID:
+			pval = (ha->ip_config.ipv4_alt_cid_len) ?
+			       (char *)ha->ip_config.ipv4_alt_cid : "";
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN:
+			OP_STATE(ha->ip_config.ipv4_options,
+				 IPOPT_REQ_VID_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN:
+			OP_STATE(ha->ip_config.ipv4_options,
+				 IPOPT_USE_VID_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID:
+			pval = (ha->ip_config.ipv4_vid_len) ?
+			       (char *)ha->ip_config.ipv4_vid : "";
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN:
+			OP_STATE(ha->ip_config.ipv4_options,
+				 IPOPT_LEARN_IQN_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_FRAGMENT_DISABLE:
+			OP_STATE(~ha->ip_config.ipv4_options,
+				 IPOPT_FRAGMENTATION_DISABLE, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_IN_FORWARD_EN:
+			OP_STATE(ha->ip_config.ipv4_options,
+				 IPOPT_IN_FORWARD_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_REDIRECT_EN:
+			if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
+				OP_STATE(ha->ip_config.ipv4_options,
+					 IPOPT_ARP_REDIRECT_EN, pval);
+			} else {
+				OP_STATE(ha->ip_config.ipv6_options,
+					 IPV6_OPT_REDIRECT_EN, pval);
+			}
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV4_TTL:
+			len = sprintf(buf, "%d\n", ha->ip_config.ipv4_ttl);
+			break;
+		case ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN:
+			OP_STATE(ha->ip_config.ipv6_options,
+				 IPV6_OPT_GRAT_NEIGHBOR_ADV_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV6_MLD_EN:
+			OP_STATE(ha->ip_config.ipv6_addl_options,
+				 IPV6_ADDOPT_MLD_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_NET_PARAM_IPV6_FLOW_LABEL:
+			len = sprintf(buf, "%u\n", ha->ip_config.ipv6_flow_lbl);
+			break;
+		case ISCSI_NET_PARAM_IPV6_TRAFFIC_CLASS:
 			len = sprintf(buf, "%d\n",
-				      (ha->ip_config.ipv4_vlan_tag &
-				       ISCSI_MAX_VLAN_ID));
-		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+				      ha->ip_config.ipv6_traffic_class);
+			break;
+		case ISCSI_NET_PARAM_IPV6_HOP_LIMIT:
 			len = sprintf(buf, "%d\n",
-				      (ha->ip_config.ipv6_vlan_tag &
-				       ISCSI_MAX_VLAN_ID));
-		break;
-	case ISCSI_NET_PARAM_VLAN_PRIORITY:
-		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+				      ha->ip_config.ipv6_hop_limit);
+			break;
+		case ISCSI_NET_PARAM_IPV6_ND_REACHABLE_TMO:
 			len = sprintf(buf, "%d\n",
-				      ((ha->ip_config.ipv4_vlan_tag >> 13) &
-					ISCSI_MAX_VLAN_PRIORITY));
-		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+				      ha->ip_config.ipv6_nd_reach_time);
+			break;
+		case ISCSI_NET_PARAM_IPV6_ND_REXMIT_TIME:
 			len = sprintf(buf, "%d\n",
-				      ((ha->ip_config.ipv6_vlan_tag >> 13) &
-					ISCSI_MAX_VLAN_PRIORITY));
-		break;
-	case ISCSI_NET_PARAM_VLAN_ENABLED:
-		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
-			len = sprintf(buf, "%s\n",
-				      (ha->ip_config.ipv4_options &
-				       IPOPT_VLAN_TAGGING_ENABLE) ?
-				       "enabled" : "disabled");
-		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
-			len = sprintf(buf, "%s\n",
-				      (ha->ip_config.ipv6_options &
-				       IPV6_OPT_VLAN_TAGGING_ENABLE) ?
-				       "enabled" : "disabled");
-		break;
-	case ISCSI_NET_PARAM_MTU:
-		len = sprintf(buf, "%d\n", ha->ip_config.eth_mtu_size);
-		break;
-	case ISCSI_NET_PARAM_PORT:
-		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
-			len = sprintf(buf, "%d\n", ha->ip_config.ipv4_port);
-		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
-			len = sprintf(buf, "%d\n", ha->ip_config.ipv6_port);
-		break;
-	default:
-		len = -ENOSYS;
+				      ha->ip_config.ipv6_nd_rexmit_timer);
+			break;
+		case ISCSI_NET_PARAM_IPV6_ND_STALE_TMO:
+			len = sprintf(buf, "%d\n",
+				      ha->ip_config.ipv6_nd_stale_timeout);
+			break;
+		case ISCSI_NET_PARAM_IPV6_DUP_ADDR_DETECT_CNT:
+			len = sprintf(buf, "%d\n",
+				      ha->ip_config.ipv6_dup_addr_detect_count);
+			break;
+		case ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU:
+			len = sprintf(buf, "%d\n",
+				      ha->ip_config.ipv6_gw_advrt_mtu);
+			break;
+		default:
+			len = -ENOSYS;
+		}
+	} else if (param_type == ISCSI_IFACE_PARAM) {
+		switch (param) {
+		case ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO:
+			len = sprintf(buf, "%d\n", ha->ip_config.def_timeout);
+			break;
+		case ISCSI_IFACE_PARAM_HDRDGST_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_HEADER_DIGEST_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_DATADGST_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_DATA_DIGEST_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_IMM_DATA_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_IMMEDIATE_DATA_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_INITIAL_R2T_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_INITIAL_R2T_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_DATA_SEQ_INORDER_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_PDU_INORDER_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_DATA_PDU_INORDER_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_ERL:
+			len = sprintf(buf, "%d\n",
+				      (ha->ip_config.iscsi_options &
+				       ISCSIOPTS_ERL));
+			break;
+		case ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH:
+			len = sprintf(buf, "%u\n",
+				      ha->ip_config.iscsi_max_pdu_size *
+				      BYTE_UNITS);
+			break;
+		case ISCSI_IFACE_PARAM_FIRST_BURST:
+			len = sprintf(buf, "%u\n",
+				      ha->ip_config.iscsi_first_burst_len *
+				      BYTE_UNITS);
+			break;
+		case ISCSI_IFACE_PARAM_MAX_R2T:
+			len = sprintf(buf, "%d\n",
+				      ha->ip_config.iscsi_max_outstnd_r2t);
+			break;
+		case ISCSI_IFACE_PARAM_MAX_BURST:
+			len = sprintf(buf, "%u\n",
+				      ha->ip_config.iscsi_max_burst_len *
+				      BYTE_UNITS);
+			break;
+		case ISCSI_IFACE_PARAM_CHAP_AUTH_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_CHAP_AUTH_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_BIDI_CHAP_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_BIDI_CHAP_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_DISCOVERY_AUTH_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_DISCOVERY_LOGOUT_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN:
+			OP_STATE(ha->ip_config.iscsi_options,
+				 ISCSIOPTS_STRICT_LOGIN_COMP_EN, pval);
+
+			len = sprintf(buf, "%s\n", pval);
+			break;
+		case ISCSI_IFACE_PARAM_INITIATOR_NAME:
+			len = sprintf(buf, "%s\n", ha->ip_config.iscsi_name);
+			break;
+		default:
+			len = -ENOSYS;
+		}
 	}
 
 	return len;
@@ -1366,8 +1755,8 @@ static void qla4xxx_set_ipv6(struct scsi_qla_host *ha,
 				cpu_to_le16(
 				  IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE);
 		else
-			ql4_printk(KERN_ERR, ha, "Invalid autocfg setting for "
-				   "IPv6 addr\n");
+			ql4_printk(KERN_ERR, ha,
+				   "Invalid autocfg setting for IPv6 addr\n");
 		break;
 	case ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG:
 		/* Autocfg applies to even interface */
@@ -1383,8 +1772,8 @@ static void qla4xxx_set_ipv6(struct scsi_qla_host *ha,
 			init_fw_cb->ipv6_addtl_opts &= cpu_to_le16(
 				       ~IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR);
 		else
-			ql4_printk(KERN_ERR, ha, "Invalid autocfg setting for "
-				   "IPv6 linklocal addr\n");
+			ql4_printk(KERN_ERR, ha,
+				   "Invalid autocfg setting for IPv6 linklocal addr\n");
 		break;
 	case ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG:
 		/* Autocfg applies to even interface */
@@ -1433,6 +1822,135 @@ static void qla4xxx_set_ipv6(struct scsi_qla_host *ha,
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
+				cpu_to_le16(~IPV6_TCPOPT_DELAYED_ACK_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_NAGLE_DISABLE:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16(IPV6_TCPOPT_NAGLE_ALGO_DISABLE);
+		else
+			init_fw_cb->ipv6_tcp_opts &=
+				cpu_to_le16(~IPV6_TCPOPT_NAGLE_ALGO_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_WSF_DISABLE:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16(IPV6_TCPOPT_WINDOW_SCALE_DISABLE);
+		else
+			init_fw_cb->ipv6_tcp_opts &=
+				cpu_to_le16(~IPV6_TCPOPT_WINDOW_SCALE_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_WSF:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_tcp_wsf = iface_param->value[0];
+		break;
+	case ISCSI_NET_PARAM_TCP_TIMER_SCALE:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv6_tcp_opts &=
+					cpu_to_le16(~IPV6_TCPOPT_TIMER_SCALE);
+		init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16((iface_param->value[0] << 1) &
+					    IPV6_TCPOPT_TIMER_SCALE);
+		break;
+	case ISCSI_NET_PARAM_TCP_TIMESTAMP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv6_tcp_opts |=
+				cpu_to_le16(IPV6_TCPOPT_TIMESTAMP_EN);
+		else
+			init_fw_cb->ipv6_tcp_opts &=
+				cpu_to_le16(~IPV6_TCPOPT_TIMESTAMP_EN);
+		break;
+	case ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv6_opts |=
+				cpu_to_le16(IPV6_OPT_GRAT_NEIGHBOR_ADV_EN);
+		else
+			init_fw_cb->ipv6_opts &=
+				cpu_to_le16(~IPV6_OPT_GRAT_NEIGHBOR_ADV_EN);
+		break;
+	case ISCSI_NET_PARAM_REDIRECT_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv6_opts |=
+				cpu_to_le16(IPV6_OPT_REDIRECT_EN);
+		else
+			init_fw_cb->ipv6_opts &=
+				cpu_to_le16(~IPV6_OPT_REDIRECT_EN);
+		break;
+	case ISCSI_NET_PARAM_IPV6_MLD_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv6_addtl_opts |=
+				cpu_to_le16(IPV6_ADDOPT_MLD_EN);
+		else
+			init_fw_cb->ipv6_addtl_opts &=
+				cpu_to_le16(~IPV6_ADDOPT_MLD_EN);
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
+	case ISCSI_NET_PARAM_IPV6_DUP_ADDR_DETECT_CNT:
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
 	default:
 		ql4_printk(KERN_ERR, ha, "Unknown IPv6 param = %d\n",
 			   iface_param->param);
@@ -1501,6 +2019,195 @@ static void qla4xxx_set_ipv4(struct scsi_qla_host *ha,
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
+				cpu_to_le16(~TCPOPT_DELAYED_ACK_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_NAGLE_DISABLE:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_NAGLE_ALGO_DISABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_NAGLE_ALGO_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_WSF_DISABLE:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_DISABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_WINDOW_SCALE_DISABLE);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_WINDOW_SCALE_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_TCP_WSF:
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
+				cpu_to_le16(TCPOPT_DNS_SERVER_IP_EN);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_DNS_SERVER_IP_EN);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_tcp_opts |=
+				cpu_to_le16(TCPOPT_SLP_DA_INFO_EN);
+		else
+			init_fw_cb->ipv4_tcp_opts &=
+				cpu_to_le16(~TCPOPT_SLP_DA_INFO_EN);
+		break;
+	case ISCSI_NET_PARAM_IPV4_TOS_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+				cpu_to_le16(IPOPT_IPV4_TOS_EN);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_IPV4_TOS_EN);
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
+					cpu_to_le16(IPOPT_GRAT_ARP_EN);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+					cpu_to_le16(~IPOPT_GRAT_ARP_EN);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+				cpu_to_le16(IPOPT_ALT_CID_EN);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_ALT_CID_EN);
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
+					cpu_to_le16(IPOPT_REQ_VID_EN);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+					cpu_to_le16(~IPOPT_REQ_VID_EN);
+		break;
+	case ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+					cpu_to_le16(IPOPT_USE_VID_EN);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+					cpu_to_le16(~IPOPT_USE_VID_EN);
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
+					cpu_to_le16(IPOPT_LEARN_IQN_EN);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+					cpu_to_le16(~IPOPT_LEARN_IQN_EN);
+		break;
+	case ISCSI_NET_PARAM_IPV4_FRAGMENT_DISABLE:
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
+				cpu_to_le16(IPOPT_IN_FORWARD_EN);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_IN_FORWARD_EN);
+		break;
+	case ISCSI_NET_PARAM_REDIRECT_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+				cpu_to_le16(IPOPT_ARP_REDIRECT_EN);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_ARP_REDIRECT_EN);
+		break;
+	case ISCSI_NET_PARAM_IPV4_TTL:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->ipv4_ttl = iface_param->value[0];
+		break;
 	default:
 		ql4_printk(KERN_ERR, ha, "Unknown IPv4 param = %d\n",
 			   iface_param->param);
@@ -1508,6 +2215,168 @@ static void qla4xxx_set_ipv4(struct scsi_qla_host *ha,
 	}
 }
 
+static void qla4xxx_set_iscsi_param(struct scsi_qla_host *ha,
+				    struct iscsi_iface_param_info *iface_param,
+				    struct addr_ctrl_blk *init_fw_cb)
+{
+	switch (iface_param->param) {
+	case ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->def_timeout =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_IFACE_PARAM_HDRDGST_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_HEADER_DIGEST_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_HEADER_DIGEST_EN);
+		break;
+	case ISCSI_IFACE_PARAM_DATADGST_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_DATA_DIGEST_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_DATA_DIGEST_EN);
+		break;
+	case ISCSI_IFACE_PARAM_IMM_DATA_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_IMMEDIATE_DATA_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_IMMEDIATE_DATA_EN);
+		break;
+	case ISCSI_IFACE_PARAM_INITIAL_R2T_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_INITIAL_R2T_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_INITIAL_R2T_EN);
+		break;
+	case ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_DATA_SEQ_INORDER_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_DATA_SEQ_INORDER_EN);
+		break;
+	case ISCSI_IFACE_PARAM_PDU_INORDER_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_DATA_PDU_INORDER_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_DATA_PDU_INORDER_EN);
+		break;
+	case ISCSI_IFACE_PARAM_ERL:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_opts &= cpu_to_le16(~ISCSIOPTS_ERL);
+		init_fw_cb->iscsi_opts |= cpu_to_le16(iface_param->value[0] &
+						      ISCSIOPTS_ERL);
+		break;
+	case ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_max_pdu_size =
+				cpu_to_le32(*(uint32_t *)iface_param->value) /
+				BYTE_UNITS;
+		break;
+	case ISCSI_IFACE_PARAM_FIRST_BURST:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_fburst_len =
+				cpu_to_le32(*(uint32_t *)iface_param->value) /
+				BYTE_UNITS;
+		break;
+	case ISCSI_IFACE_PARAM_MAX_R2T:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_max_outstnd_r2t =
+				cpu_to_le16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_IFACE_PARAM_MAX_BURST:
+		if (iface_param->iface_num & 0x1)
+			break;
+		init_fw_cb->iscsi_max_burst_len =
+				cpu_to_le32(*(uint32_t *)iface_param->value) /
+				BYTE_UNITS;
+		break;
+	case ISCSI_IFACE_PARAM_CHAP_AUTH_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_CHAP_AUTH_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_CHAP_AUTH_EN);
+		break;
+	case ISCSI_IFACE_PARAM_BIDI_CHAP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_BIDI_CHAP_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_BIDI_CHAP_EN);
+		break;
+	case ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_DISCOVERY_AUTH_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_DISCOVERY_AUTH_EN);
+		break;
+	case ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_DISCOVERY_LOGOUT_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_DISCOVERY_LOGOUT_EN);
+		break;
+	case ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN:
+		if (iface_param->iface_num & 0x1)
+			break;
+		if (iface_param->value[0] == ISCSI_NET_PARAM_ENABLE)
+			init_fw_cb->iscsi_opts |=
+				cpu_to_le16(ISCSIOPTS_STRICT_LOGIN_COMP_EN);
+		else
+			init_fw_cb->iscsi_opts &=
+				cpu_to_le16(~ISCSIOPTS_STRICT_LOGIN_COMP_EN);
+		break;
+	default:
+		ql4_printk(KERN_ERR, ha, "Unknown iscsi param = %d\n",
+			   iface_param->param);
+		break;
+	}
+}
+
 static void
 qla4xxx_initcb_to_acb(struct addr_ctrl_blk *init_fw_cb)
 {
@@ -1565,40 +2434,47 @@ qla4xxx_iface_set_param(struct Scsi_Host *shost, void *data, uint32_t len)
 	nla_for_each_attr(attr, data, len, rem) {
 		iface_param = nla_data(attr);
 
-		if (iface_param->param_type != ISCSI_NET_PARAM)
-			continue;
-
-		switch (iface_param->iface_type) {
-		case ISCSI_IFACE_TYPE_IPV4:
-			switch (iface_param->iface_num) {
-			case 0:
-				qla4xxx_set_ipv4(ha, iface_param, init_fw_cb);
-				break;
-			default:
+		if (iface_param->param_type == ISCSI_NET_PARAM) {
+			switch (iface_param->iface_type) {
+			case ISCSI_IFACE_TYPE_IPV4:
+				switch (iface_param->iface_num) {
+				case 0:
+					qla4xxx_set_ipv4(ha, iface_param,
+							 init_fw_cb);
+					break;
+				default:
 				/* Cannot have more than one IPv4 interface */
-				ql4_printk(KERN_ERR, ha, "Invalid IPv4 iface "
-					   "number = %d\n",
-					   iface_param->iface_num);
+					ql4_printk(KERN_ERR, ha,
+						   "Invalid IPv4 iface number = %d\n",
+						   iface_param->iface_num);
+					break;
+				}
 				break;
-			}
-			break;
-		case ISCSI_IFACE_TYPE_IPV6:
-			switch (iface_param->iface_num) {
-			case 0:
-			case 1:
-				qla4xxx_set_ipv6(ha, iface_param, init_fw_cb);
+			case ISCSI_IFACE_TYPE_IPV6:
+				switch (iface_param->iface_num) {
+				case 0:
+				case 1:
+					qla4xxx_set_ipv6(ha, iface_param,
+							 init_fw_cb);
+					break;
+				default:
+				/* Cannot have more than two IPv6 interface */
+					ql4_printk(KERN_ERR, ha,
+						   "Invalid IPv6 iface number = %d\n",
+						   iface_param->iface_num);
+					break;
+				}
 				break;
 			default:
-				/* Cannot have more than two IPv6 interface */
-				ql4_printk(KERN_ERR, ha, "Invalid IPv6 iface "
-					   "number = %d\n",
-					   iface_param->iface_num);
+				ql4_printk(KERN_ERR, ha,
+					   "Invalid iface type\n");
 				break;
 			}
-			break;
-		default:
-			ql4_printk(KERN_ERR, ha, "Invalid iface type\n");
-			break;
+		} else if (iface_param->param_type == ISCSI_IFACE_PARAM) {
+				qla4xxx_set_iscsi_param(ha, iface_param,
+							init_fw_cb);
+		} else {
+			continue;
 		}
 	}
 
-- 
1.7.1

