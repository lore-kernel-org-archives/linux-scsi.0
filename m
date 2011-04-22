From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/5] qla4xxx: add support for set_net_config
Date: Fri, 22 Apr 2011 11:07:43 -0700
Message-ID: <1303495666-731-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46853 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751741Ab1DVSNV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 14:13:21 -0400
In-Reply-To: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Allows user space (iscsiadm) to send down network configuration parameters
for LLD to set private network configuration on the iSCSI adapters.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Reviewed-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h   |   77 ++++++++++
 drivers/scsi/qla4xxx/ql4_glbl.h |   20 +++-
 drivers/scsi/qla4xxx/ql4_mbx.c  |  119 +++++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c   |  302 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 514 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 31e2bf9..d05e8be 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -434,6 +434,14 @@ struct qla_flt_region {
 #define ACB_STATE_VALID		0x05
 #define ACB_STATE_DISABLING	0x06
 
+/* FLASH offsets */
+#define FLASH_SEGMENT_IFCB	0x04000000
+
+#define FLASH_OPT_RMW_HOLD	0
+#define FLASH_OPT_RMW_INIT	1
+#define FLASH_OPT_COMMIT	2
+#define FLASH_OPT_RMW_COMMIT	3
+
 /*************************************************************************/
 
 /* Host Adapter Initialization Control Block (from host) */
@@ -473,6 +481,7 @@ struct addr_ctrl_blk {
 
 	uint16_t iscsi_opts;	/* 30-31 */
 	uint16_t ipv4_tcp_opts;	/* 32-33 */
+#define TCPOPT_DHCP_ENABLE		0x0200
 	uint16_t ipv4_ip_opts;	/* 34-35 */
 #define  IPOPT_IPv4_PROTOCOL_ENABLE	0x8000
 
@@ -574,6 +583,74 @@ struct init_fw_ctrl_blk {
 /*	struct addr_ctrl_blk sec;*/
 };
 
+struct addr_ctrl_blk_def {
+	uint8_t reserved1[1];	/* 00 */
+	uint8_t control;	/* 01 */
+	uint8_t reserved2[11];	/* 02-0C */
+	uint8_t inst_num;	/* 0D */
+	uint8_t reserved3[34];	/* 0E-2F */
+	uint16_t iscsi_opts;	/* 30-31 */
+	uint16_t ipv4_tcp_opts;	/* 32-33 */
+	uint16_t ipv4_ip_opts;	/* 34-35 */
+	uint16_t iscsi_max_pdu_size;	/* 36-37 */
+	uint8_t ipv4_tos;	/* 38 */
+	uint8_t ipv4_ttl;	/* 39 */
+	uint8_t reserved4[2];	/* 3A-3B */
+	uint16_t def_timeout;	/* 3C-3D */
+	uint16_t iscsi_fburst_len;	/* 3E-3F */
+	uint8_t reserved5[4];	/* 40-43 */
+	uint16_t iscsi_max_outstnd_r2t;	/* 44-45 */
+	uint8_t reserved6[2];	/* 46-47 */
+	uint16_t ipv4_port;	/* 48-49 */
+	uint16_t iscsi_max_burst_len;	/* 4A-4B */
+	uint8_t reserved7[4];	/* 4C-4F */
+	uint8_t ipv4_addr[4];	/* 50-53 */
+	uint16_t ipv4_vlan_tag;	/* 54-55 */
+	uint8_t ipv4_addr_state;	/* 56 */
+	uint8_t ipv4_cacheid;	/* 57 */
+	uint8_t reserved8[8];	/* 58-5F */
+	uint8_t ipv4_subnet[4];	/* 60-63 */
+	uint8_t reserved9[12];	/* 64-6F */
+	uint8_t ipv4_gw_addr[4];	/* 70-73 */
+	uint8_t reserved10[84];	/* 74-C7 */
+	uint8_t abort_timer;	/* C8    */
+	uint8_t ipv4_tcp_wsf;	/* C9    */
+	uint8_t reserved11[10];	/* CA-D3 */
+	uint8_t ipv4_dhcp_vid_len;	/* D4 */
+	uint8_t ipv4_dhcp_vid[11];	/* D5-DF */
+	uint8_t reserved12[20];	/* E0-F3 */
+	uint8_t ipv4_dhcp_alt_cid_len;	/* F4 */
+	uint8_t ipv4_dhcp_alt_cid[11];	/* F5-FF */
+	uint8_t iscsi_name[224];	/* 100-1DF */
+	uint8_t reserved13[32];	/* 1E0-1FF */
+	uint32_t cookie;	/* 200-203 */
+	uint16_t ipv6_port;	/* 204-205 */
+	uint16_t ipv6_opts;	/* 206-207 */
+	uint16_t ipv6_addtl_opts;	/* 208-209 */
+	uint16_t ipv6_tcp_opts;		/* 20A-20B */
+	uint8_t ipv6_tcp_wsf;		/* 20C */
+	uint16_t ipv6_flow_lbl;		/* 20D-20F */
+	uint8_t ipv6_dflt_rtr_addr[16];	/* 210-21F */
+	uint16_t ipv6_vlan_tag;		/* 220-221 */
+	uint8_t ipv6_lnk_lcl_addr_state;	/* 222 */
+	uint8_t ipv6_addr0_state;	/* 223 */
+	uint8_t ipv6_addr1_state;	/* 224 */
+	uint8_t ipv6_dflt_rtr_state;	/* 225 */
+	uint8_t ipv6_traffic_class;	/* 226 */
+	uint8_t ipv6_hop_limit;		/* 227 */
+	uint8_t ipv6_if_id[8];		/* 228-22F */
+	uint8_t ipv6_addr0[16];		/* 230-23F */
+	uint8_t ipv6_addr1[16];		/* 240-24F */
+	uint32_t ipv6_nd_reach_time;	/* 250-253 */
+	uint32_t ipv6_nd_rexmit_timer;	/* 254-257 */
+	uint32_t ipv6_nd_stale_timeout;	/* 258-25B */
+	uint8_t ipv6_dup_addr_detect_count;	/* 25C */
+	uint8_t ipv6_cache_id;		/* 25D */
+	uint8_t reserved14[18];		/* 25E-26F */
+	uint32_t ipv6_gw_advrt_mtu;	/* 270-273 */
+	uint8_t reserved15[140];	/* 274-2FF */
+};
+
 /*************************************************************************/
 
 struct dev_db_entry {
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index cc53e3f..9c5c5e3 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -52,7 +52,17 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 
 int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_index,
 			  dma_addr_t fw_ddb_entry_dma);
-
+uint8_t qla4xxx_get_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
+			 uint32_t *mbox_sts, dma_addr_t init_fw_cb_dma);
+int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *ha,
+				   uint16_t fw_ddb_index,
+				   uint16_t connection_id,
+				   uint16_t option);
+int qla4xxx_disable_acb(struct scsi_qla_host *ha);
+int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
+		    uint32_t *mbox_sts, dma_addr_t acb_dma);
+int qla4xxx_get_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
+		    uint32_t *mbox_sts, dma_addr_t acb_dma);
 void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
 				 struct ddb_entry *ddb_entry);
 u16 rd_nvram_word(struct scsi_qla_host *ha, int offset);
@@ -75,7 +85,8 @@ void qla4xxx_dump_buffer(void *b, uint32_t size);
 int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
 	struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod);
 int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err);
-
+int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
+		      uint32_t offset, uint32_t length, uint32_t options);
 int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		uint8_t outCount, uint32_t *mbx_cmd, uint32_t *mbx_sts);
 
@@ -95,6 +106,11 @@ void qla4xxx_wake_dpc(struct scsi_qla_host *ha);
 void qla4xxx_get_conn_event_log(struct scsi_qla_host *ha);
 void qla4xxx_mailbox_premature_completion(struct scsi_qla_host *ha);
 void qla4xxx_dump_registers(struct scsi_qla_host *ha);
+uint8_t qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
+				  uint32_t *mbox_cmd,
+				  uint32_t *mbox_sts,
+				  struct addr_ctrl_blk *init_fw_cb,
+				  dma_addr_t init_fw_cb_dma);
 
 void qla4_8xxx_pci_config(struct scsi_qla_host *);
 int qla4_8xxx_iospace_config(struct scsi_qla_host *ha);
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index f9d81c8..743290e 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -317,7 +317,7 @@ qla4xxx_set_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 	return QLA_SUCCESS;
 }
 
-static uint8_t
+uint8_t
 qla4xxx_get_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 		 uint32_t *mbox_sts, dma_addr_t init_fw_cb_dma)
 {
@@ -377,7 +377,7 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 	}
 }
 
-static uint8_t
+uint8_t
 qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
 			  uint32_t *mbox_cmd,
 			  uint32_t *mbox_sts,
@@ -1194,3 +1194,118 @@ exit_send_tgts_no_free:
 	return ret_val;
 }
 
+int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
+		      uint32_t offset, uint32_t length, uint32_t options)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status = QLA_SUCCESS;
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_WRITE_FLASH;
+	mbox_cmd[1] = LSDW(dma_addr);
+	mbox_cmd[2] = MSDW(dma_addr);
+	mbox_cmd[3] = offset;
+	mbox_cmd[4] = length;
+	mbox_cmd[5] = options;
+
+	status = qla4xxx_mailbox_command(ha, 6, 2, &mbox_cmd[0], &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha, "%s: MBOX_CMD_WRITE_FLASH "
+				  "failed w/ status %04X, mbx1 %04X\n",
+				  __func__, mbox_sts[0], mbox_sts[1]));
+	}
+	return status;
+}
+
+int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *ha,
+				   uint16_t fw_ddb_index,
+				   uint16_t connection_id,
+				   uint16_t option)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status = QLA_SUCCESS;
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_CONN_CLOSE_SESS_LOGOUT;
+	mbox_cmd[1] = fw_ddb_index;
+	mbox_cmd[2] = connection_id;
+	mbox_cmd[3] = option;
+
+	status = qla4xxx_mailbox_command(ha, 4, 2, &mbox_cmd[0], &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha, "%s: MBOX_CMD_CONN_CLOSE "
+				  "option %04x failed w/ status %04X %04X\n",
+				  __func__, option, mbox_sts[0], mbox_sts[1]));
+	}
+	return status;
+}
+
+int qla4xxx_disable_acb(struct scsi_qla_host *ha)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status = QLA_SUCCESS;
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_DISABLE_ACB;
+
+	status = qla4xxx_mailbox_command(ha, 8, 5, &mbox_cmd[0], &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha, "%s: MBOX_CMD_DISABLE_ACB "
+				  "failed w/ status %04X %04X %04X", __func__,
+				  mbox_sts[0], mbox_sts[1], mbox_sts[2]));
+	}
+	return status;
+}
+
+int qla4xxx_get_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
+		    uint32_t *mbox_sts, dma_addr_t acb_dma)
+{
+	int status = QLA_SUCCESS;
+
+	memset(mbox_cmd, 0, sizeof(mbox_cmd[0]) * MBOX_REG_COUNT);
+	memset(mbox_sts, 0, sizeof(mbox_sts[0]) * MBOX_REG_COUNT);
+	mbox_cmd[0] = MBOX_CMD_GET_ACB;
+	mbox_cmd[1] = 0; /* Primary ACB */
+	mbox_cmd[2] = LSDW(acb_dma);
+	mbox_cmd[3] = MSDW(acb_dma);
+	mbox_cmd[4] = sizeof(struct addr_ctrl_blk);
+
+	status = qla4xxx_mailbox_command(ha, 5, 5, &mbox_cmd[0], &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha, "%s: MBOX_CMD_GET_ACB "
+				  "failed w/ status %04X\n", __func__,
+				  mbox_sts[0]));
+	}
+	return status;
+}
+
+int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
+		    uint32_t *mbox_sts, dma_addr_t acb_dma)
+{
+	int status = QLA_SUCCESS;
+
+	memset(mbox_cmd, 0, sizeof(mbox_cmd[0]) * MBOX_REG_COUNT);
+	memset(mbox_sts, 0, sizeof(mbox_sts[0]) * MBOX_REG_COUNT);
+	mbox_cmd[0] = MBOX_CMD_SET_ACB;
+	mbox_cmd[1] = 0; /* Primary ACB */
+	mbox_cmd[2] = LSDW(acb_dma);
+	mbox_cmd[3] = MSDW(acb_dma);
+	mbox_cmd[4] = sizeof(struct addr_ctrl_blk);
+
+	status = qla4xxx_mailbox_command(ha, 5, 5, &mbox_cmd[0], &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha,  "%s: MBOX_CMD_SET_ACB "
+				  "failed w/ status %04X\n", __func__,
+				  mbox_sts[0]));
+	}
+	return status;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 230ba09..e9b669d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -80,6 +80,8 @@ static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
 				  enum iscsi_param param, char *buf);
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf);
+static int qla4xxx_set_net_config(struct Scsi_Host *shost, char *data,
+				  int count);
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
 
@@ -141,6 +143,7 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.get_conn_param		= qla4xxx_conn_get_param,
 	.get_session_param	= qla4xxx_sess_get_param,
 	.get_host_param		= qla4xxx_host_get_param,
+	.set_net_config		= qla4xxx_set_net_config,
 	.session_recovery_timedout = qla4xxx_recovery_timedout,
 };
 
@@ -201,6 +204,305 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 	return len;
 }
 
+static inline void qla4xxx_set_ipv6(struct scsi_qla_host *ha,
+				    struct iscsi_net_param *net_param,
+				    struct addr_ctrl_blk *init_fw_cb)
+{
+	/*
+	 * iface_num 0 is valid for IPv6 Addr, linklocal, router, autocfg.
+	 * iface_num 1 is valid only for IPv6 Addr.
+	 */
+	switch (net_param->param_type) {
+	case ISCSI_NET_PARAM_IPV6_ADDR:
+		if (net_param->iface_num & 0x1)
+			/* IPv6 Addr 1 */
+			memcpy(init_fw_cb->ipv6_addr1, net_param->value,
+			       sizeof(init_fw_cb->ipv6_addr1));
+		else
+			/* IPv6 Addr 0 */
+			memcpy(init_fw_cb->ipv6_addr0, net_param->value,
+			       sizeof(init_fw_cb->ipv6_addr0));
+		break;
+	case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
+		if (net_param->iface_num & 0x1)
+			break;
+		memcpy(init_fw_cb->ipv6_if_id, &net_param->value[8],
+		       sizeof(init_fw_cb->ipv6_if_id));
+		break;
+	case ISCSI_NET_PARAM_IPV6_ROUTER:
+		if (net_param->iface_num & 0x1)
+			break;
+		memcpy(init_fw_cb->ipv6_dflt_rtr_addr, net_param->value,
+		       sizeof(init_fw_cb->ipv6_dflt_rtr_addr));
+		break;
+	case ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG:
+		/* Autocfg applies to even interface */
+		if (net_param->iface_num & 0x1)
+			break;
+
+		if (net_param->value[0] == ISCSI_IPV6_AUTOCFG_DISABLE)
+			init_fw_cb->ipv6_addtl_opts &=
+				cpu_to_le16(
+				  ~IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE);
+		else if (net_param->value[0] == ISCSI_IPV6_AUTOCFG_ND_ENABLE)
+			init_fw_cb->ipv6_addtl_opts |=
+				cpu_to_le16(
+				  IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE);
+		else
+			ql4_printk(KERN_ERR, ha, "Invalid autocfg setting for "
+				   "IPv6 addr\n");
+		break;
+	case ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG:
+		/* Autocfg applies to even interface */
+		if (net_param->iface_num & 0x1)
+			break;
+
+		if (net_param->value[0] == ISCSI_IPV6_LINKLOCAL_AUTOCFG_ENABLE)
+			init_fw_cb->ipv6_addtl_opts |= cpu_to_le16(
+					IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR);
+		else if (net_param->value[0] ==
+			 ISCSI_IPV6_LINKLOCAL_AUTOCFG_DISABLE)
+			init_fw_cb->ipv6_addtl_opts &= cpu_to_le16(
+				       ~IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR);
+		else
+			ql4_printk(KERN_ERR, ha, "Invalid autocfg setting for "
+				   "IPv6 linklocal addr\n");
+		break;
+	case ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG:
+		/* Autocfg applies to even interface */
+		if (net_param->iface_num & 0x1)
+			break;
+
+		if (net_param->value[0] == ISCSI_IPV6_ROUTER_AUTOCFG_ENABLE)
+			memset(init_fw_cb->ipv6_dflt_rtr_addr, 0,
+			       sizeof(init_fw_cb->ipv6_dflt_rtr_addr));
+		break;
+	case ISCSI_NET_PARAM_IFACE_ENABLED:
+		if (net_param->value[0] == ISCSI_TRUE)
+			init_fw_cb->ipv6_opts |=
+				cpu_to_le16(IPV6_OPT_IPV6_PROTOCOL_ENABLE);
+		else
+			init_fw_cb->ipv6_opts &=
+				cpu_to_le16(~IPV6_OPT_IPV6_PROTOCOL_ENABLE &
+					    0xFFFF);
+		break;
+	case ISCSI_NET_PARAM_VLAN:
+		if (net_param->length != sizeof(init_fw_cb->ipv6_vlan_tag))
+			break;
+		init_fw_cb->ipv6_vlan_tag = *(uint16_t *)net_param->value;
+		break;
+	default:
+		ql4_printk(KERN_ERR, ha, "Unknown IPv6 param = %d\n",
+			   net_param->param_type);
+		break;
+	}
+}
+
+static inline void qla4xxx_set_ipv4(struct scsi_qla_host *ha,
+				    struct iscsi_net_param *net_param,
+				    struct addr_ctrl_blk *init_fw_cb)
+{
+	switch (net_param->param_type) {
+	case ISCSI_NET_PARAM_IPV4_ADDR:
+		memcpy(init_fw_cb->ipv4_addr, net_param->value,
+		       sizeof(init_fw_cb->ipv4_addr));
+		break;
+	case ISCSI_NET_PARAM_IPV4_SUBNET:
+		memcpy(init_fw_cb->ipv4_subnet,	net_param->value,
+		       sizeof(init_fw_cb->ipv4_subnet));
+		break;
+	case ISCSI_NET_PARAM_IPV4_GW:
+		memcpy(init_fw_cb->ipv4_gw_addr, net_param->value,
+		       sizeof(init_fw_cb->ipv4_gw_addr));
+		break;
+	case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
+		if (net_param->value[0] == ISCSI_BOOTPROTO_DHCP)
+			init_fw_cb->ipv4_tcp_opts |=
+					cpu_to_le16(TCPOPT_DHCP_ENABLE);
+		else if (net_param->value[0] == ISCSI_BOOTPROTO_STATIC)
+			init_fw_cb->ipv4_tcp_opts &=
+					cpu_to_le16(~TCPOPT_DHCP_ENABLE);
+		else
+			ql4_printk(KERN_ERR, ha, "Invalid IPv4 bootproto\n");
+		break;
+	case ISCSI_NET_PARAM_IFACE_ENABLED:
+		if (net_param->value[0] == ISCSI_TRUE)
+			init_fw_cb->ipv4_ip_opts |=
+				cpu_to_le16(IPOPT_IPv4_PROTOCOL_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+				cpu_to_le16(~IPOPT_IPv4_PROTOCOL_ENABLE &
+					    0xFFFF);
+		break;
+	case ISCSI_NET_PARAM_VLAN:
+		if (net_param->length != sizeof(init_fw_cb->ipv4_vlan_tag))
+			break;
+		init_fw_cb->ipv4_vlan_tag = *(uint16_t *)net_param->value;
+		break;
+	default:
+		ql4_printk(KERN_ERR, ha, "Unknown IPv4 param = %d\n",
+			   net_param->param_type);
+		break;
+	}
+}
+
+static void
+qla4xxx_initcb_to_acb(struct addr_ctrl_blk *init_fw_cb)
+{
+	struct addr_ctrl_blk_def *acb;
+	acb = (struct addr_ctrl_blk_def *)init_fw_cb;
+	memset(acb->reserved1, 0, sizeof(acb->reserved1));
+	memset(acb->reserved2, 0, sizeof(acb->reserved2));
+	memset(acb->reserved3, 0, sizeof(acb->reserved3));
+	memset(acb->reserved4, 0, sizeof(acb->reserved4));
+	memset(acb->reserved5, 0, sizeof(acb->reserved5));
+	memset(acb->reserved6, 0, sizeof(acb->reserved6));
+	memset(acb->reserved7, 0, sizeof(acb->reserved7));
+	memset(acb->reserved8, 0, sizeof(acb->reserved8));
+	memset(acb->reserved9, 0, sizeof(acb->reserved9));
+	memset(acb->reserved10, 0, sizeof(acb->reserved10));
+	memset(acb->reserved11, 0, sizeof(acb->reserved11));
+	memset(acb->reserved12, 0, sizeof(acb->reserved12));
+	memset(acb->reserved13, 0, sizeof(acb->reserved13));
+	memset(acb->reserved14, 0, sizeof(acb->reserved14));
+	memset(acb->reserved15, 0, sizeof(acb->reserved15));
+}
+
+static int
+qla4xxx_set_net_config(struct Scsi_Host *shost, char *data, int count)
+{
+	struct scsi_qla_host *ha = to_qla_host(shost);
+	int rval = 0;
+	struct iscsi_net_param *net_param = NULL;
+	struct addr_ctrl_blk *init_fw_cb = NULL;
+	dma_addr_t init_fw_cb_dma;
+
+	struct addr_ctrl_blk *acb = NULL;
+	dma_addr_t acb_dma;
+
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	uint32_t total_param_count;
+	uint32_t length;
+
+	init_fw_cb = dma_alloc_coherent(&ha->pdev->dev,
+					sizeof(struct addr_ctrl_blk),
+					&init_fw_cb_dma, GFP_KERNEL);
+	if (!init_fw_cb) {
+		ql4_printk(KERN_ERR, ha, "%s: Unable to alloc init_cb\n",
+			   __func__);
+		return -ENOMEM;
+	}
+
+	acb = dma_alloc_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk),
+				 &acb_dma, GFP_KERNEL);
+	if (!acb) {
+		ql4_printk(KERN_ERR, ha, "%s: Unable to alloc acb\n",
+			   __func__);
+		rval = -ENOMEM;
+		goto exit_init_fw_cb;
+	}
+	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
+	memset(acb, 0, sizeof(struct addr_ctrl_blk));
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	if (qla4xxx_get_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma)) {
+		ql4_printk(KERN_ERR, ha, "%s: get ifcb failed\n", __func__);
+		rval = -EIO;
+		goto exit_init_fw_cb;
+	}
+
+	total_param_count = count;
+	net_param = (struct iscsi_net_param *)data;
+
+	for ( ; total_param_count != 0; total_param_count--) {
+		length = net_param->length;
+
+		switch (net_param->iface_type) {
+		case IFACE_TYPE_IPV4:
+			switch (net_param->iface_num) {
+			case 0:
+				qla4xxx_set_ipv4(ha, net_param, init_fw_cb);
+				break;
+			default:
+				/* Cannot have more than one IPv4 interface */
+				ql4_printk(KERN_ERR, ha, "Invalid IPv4 iface "
+					   "number = %d\n",
+					   net_param->iface_num);
+				break;
+			}
+			break;
+		case IFACE_TYPE_IPV6:
+			switch (net_param->iface_num) {
+			case 0:
+			case 1:
+				qla4xxx_set_ipv6(ha, net_param, init_fw_cb);
+				break;
+			default:
+				/* Cannot have more than two IPv6 interface */
+				ql4_printk(KERN_ERR, ha, "Invalid IPv6 iface "
+					   "number = %d\n",
+					   net_param->iface_num);
+				break;
+			}
+			break;
+		default:
+			ql4_printk(KERN_ERR, ha, "%s: Invalid iface type\n",
+				   __func__);
+			break;
+		}
+
+		net_param = (struct iscsi_net_param *)((uint8_t *)net_param +
+			    sizeof(struct iscsi_net_param) + length);
+	}
+
+	init_fw_cb->cookie = cpu_to_le32(0x11BEAD5A);
+
+	rval = qla4xxx_set_flash(ha, init_fw_cb_dma, FLASH_SEGMENT_IFCB,
+				 sizeof(struct addr_ctrl_blk),
+				 FLASH_OPT_RMW_COMMIT);
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_ERR, ha, "%s: set flash mbx failed\n",
+			   __func__);
+		rval = -EIO;
+		goto exit_init_fw_cb;
+	}
+
+	qla4xxx_disable_acb(ha);
+
+	/* Get ACB to check the state of IP address */
+	rval = qla4xxx_get_acb(ha, &mbox_cmd[0], &mbox_sts[0], acb_dma);
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_ERR, ha, "%s: get acb mbx failed\n",
+			   __func__);
+		rval = -EIO;
+		goto exit_acb;
+	}
+
+	qla4xxx_initcb_to_acb(init_fw_cb);
+	rval = qla4xxx_set_acb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma);
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_ERR, ha, "%s: set acb mbx failed\n",
+			   __func__);
+		rval = -EIO;
+		goto exit_acb;
+	}
+
+	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
+	qla4xxx_update_local_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb,
+				  init_fw_cb_dma);
+
+exit_acb:
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk),
+			  acb, acb_dma);
+exit_init_fw_cb:
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk),
+			  init_fw_cb, init_fw_cb_dma);
+
+	return rval;
+}
+
 static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
 				  enum iscsi_param param, char *buf)
 {
-- 
1.7.3.2

