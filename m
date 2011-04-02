From: vikas.chaudhary@qlogic.com
Subject: [RFC-V2 PATCH 2/5] qla4xxx: add support for set_net_config
Date: Sat,  2 Apr 2011 11:34:18 -0700
Message-ID: <1301769261-29896-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39509 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756402Ab1DBSjK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2011 14:39:10 -0400
In-Reply-To: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Allows user space (iscsiadm) to send down network configuration parameters
for LLD to set private network configuration on the iSCSI adapters.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Reviewed-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h   |  102 ++++++++++++
 drivers/scsi/qla4xxx/ql4_glbl.h |   18 ++-
 drivers/scsi/qla4xxx/ql4_mbx.c  |  126 ++++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c   |  336 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 578 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 31e2bf9..812254d 100644
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
 
@@ -574,6 +583,99 @@ struct init_fw_ctrl_blk {
 /*	struct addr_ctrl_blk sec;*/
 };
 
+struct addr_ctrl_blk_def {
+	uint8_t reserved1[1];	/* 00 */
+#define IFCB_VER_MIN			0x01
+#define IFCB_VER_MAX			0x02
+	uint8_t control;	/* 01 */
+
+	uint8_t reserved2[11];	/* 02-0C */
+	uint8_t inst_num;	/* 0D */
+	uint8_t reserved3[34];	/* 0E-2F */
+	uint16_t iscsi_opts;	/* 30-31 */
+	uint16_t ipv4_tcp_opts;	/* 32-33 */
+#define TCPOPT_DHCP_ENABLE		0x0200
+	uint16_t ipv4_ip_opts;	/* 34-35 */
+#define IPOPT_IPv4_PROTOCOL_ENABLE	0x8000
+
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
+#define IPV6_OPT_IPV6_PROTOCOL_ENABLE  0x8000
+
+	uint16_t ipv6_addtl_opts;	/* 208-209 */
+#define IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE	0x0002	/* Pri ACB
+								   Only */
+#define IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR		0x0001
+
+	uint16_t ipv6_tcp_opts;		/* 20A-20B */
+	uint8_t ipv6_tcp_wsf;		/* 20C */
+	uint16_t ipv6_flow_lbl;		/* 20D-20F */
+	uint8_t ipv6_dflt_rtr_addr[16];	/* 210-21F */
+	uint16_t ipv6_vlan_tag;		/* 220-221 */
+	uint8_t ipv6_lnk_lcl_addr_state;	/* 222 */
+	uint8_t ipv6_addr0_state;	/* 223 */
+	uint8_t ipv6_addr1_state;	/* 224 */
+#define IP_ADDRSTATE_UNCONFIGURED	0
+#define IP_ADDRSTATE_INVALID		1
+#define IP_ADDRSTATE_ACQUIRING		2
+#define IP_ADDRSTATE_TENTATIVE		3
+#define IP_ADDRSTATE_DEPRICATED		4
+#define IP_ADDRSTATE_PREFERRED		5
+#define IP_ADDRSTATE_DISABLING		6
+
+	uint8_t ipv6_dflt_rtr_state;	/* 225 */
+#define IPV6_RTRSTATE_UNKNOWN		0
+#define IPV6_RTRSTATE_MANUAL		1
+#define IPV6_RTRSTATE_ADVERTISED	3
+#define IPV6_RTRSTATE_STALE		4
+
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
index cc53e3f..1cadb74 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -52,7 +52,15 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 
 int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_index,
 			  dma_addr_t fw_ddb_entry_dma);
-
+uint8_t qla4xxx_get_ifcb(struct scsi_qla_host *, uint32_t *, uint32_t *,
+		dma_addr_t);
+int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *,
+		uint16_t, uint16_t, uint16_t);
+int qla4xxx_disable_acb(struct scsi_qla_host *);
+int qla4xxx_set_acb(struct scsi_qla_host *, uint32_t *,
+		uint32_t *, dma_addr_t);
+int qla4xxx_get_acb(struct scsi_qla_host *, uint32_t *,
+		uint32_t *, dma_addr_t);
 void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
 				 struct ddb_entry *ddb_entry);
 u16 rd_nvram_word(struct scsi_qla_host *ha, int offset);
@@ -75,7 +83,8 @@ void qla4xxx_dump_buffer(void *b, uint32_t size);
 int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
 	struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod);
 int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err);
-
+int qla4xxx_set_flash(struct scsi_qla_host *, dma_addr_t, uint32_t, uint32_t,
+		uint32_t);
 int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		uint8_t outCount, uint32_t *mbx_cmd, uint32_t *mbx_sts);
 
@@ -95,6 +104,11 @@ void qla4xxx_wake_dpc(struct scsi_qla_host *ha);
 void qla4xxx_get_conn_event_log(struct scsi_qla_host *ha);
 void qla4xxx_mailbox_premature_completion(struct scsi_qla_host *ha);
 void qla4xxx_dump_registers(struct scsi_qla_host *ha);
+uint8_t qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
+		uint32_t *mbox_cmd,
+		uint32_t *mbox_sts,
+		struct addr_ctrl_blk *init_fw_cb,
+		dma_addr_t init_fw_cb_dma);
 
 void qla4_8xxx_pci_config(struct scsi_qla_host *);
 int qla4_8xxx_iospace_config(struct scsi_qla_host *ha);
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index f9d81c8..ddcbd86 100644
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
@@ -1194,3 +1194,125 @@ exit_send_tgts_no_free:
 	return ret_val;
 }
 
+int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
+		      uint32_t offset, uint32_t length, uint32_t options)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
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
+	if (qla4xxx_mailbox_command(ha, 6, 2, &mbox_cmd[0], &mbox_sts[0])) {
+		printk(KERN_WARNING "scsi(%ld): %s: MBOX_CMD_WRITE_FLASH"
+		    " failed w/ status %04X, mbx1 %04X\n", ha->host_no,
+		    __func__, mbox_sts[0], mbox_sts[1]);
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *ha,
+				   uint16_t fw_ddb_index,
+				   uint16_t connection_id,
+				   uint16_t option)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	printk(KERN_INFO
+	    "%s: fw_ddb_index: %d\n", __func__, fw_ddb_index);
+
+	mbox_cmd[0] = MBOX_CMD_CONN_CLOSE_SESS_LOGOUT;
+	mbox_cmd[1] = fw_ddb_index;
+	mbox_cmd[2] = connection_id;
+	mbox_cmd[3] = option;
+
+	if (qla4xxx_mailbox_command(ha, 4, 2, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha, "%s: MBOX_CMD_CONN_CLOSE "
+		    "option %04x failed sts %04X %04X", __func__, option,
+		    mbox_sts[0], mbox_sts[1]));
+		if (mbox_sts[0] == 0x4005) {
+			DEBUG2(printk(KERN_WARNING "%s reason %04X\n",
+			    __func__, mbox_sts[1]));
+		} else {
+			DEBUG2(printk(KERN_WARNING "\n"));
+		}
+		return QLA_ERROR;
+	}
+	printk(KERN_INFO "%s: Exit\n", __func__);
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_disable_acb(struct scsi_qla_host *ha)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_DISABLE_ACB;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha, "%s: MBOX_CMD_DISABLE_ACB "
+		    "failed sts %04X %04X %04X", __func__,
+		    mbox_sts[0], mbox_sts[1], mbox_sts[2]));
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_get_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
+		    uint32_t *mbox_sts, dma_addr_t acb_dma)
+{
+	memset(mbox_cmd, 0, sizeof(mbox_cmd[0]) * MBOX_REG_COUNT);
+	memset(mbox_sts, 0, sizeof(mbox_sts[0]) * MBOX_REG_COUNT);
+	mbox_cmd[0] = MBOX_CMD_GET_ACB;
+	mbox_cmd[1] = 0; /* Primary ACB */
+	mbox_cmd[2] = LSDW(acb_dma);
+	mbox_cmd[3] = MSDW(acb_dma);
+	mbox_cmd[4] = sizeof(struct addr_ctrl_blk);
+
+	if (qla4xxx_mailbox_command(ha, 5, 5, mbox_cmd, mbox_sts) !=
+	    QLA_SUCCESS) {
+		DEBUG2(printk(KERN_WARNING "scsi%ld: %s: "
+		    "MBOX_CMD_GET_ACB failed w/ status %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
+		    uint32_t *mbox_sts, dma_addr_t acb_dma)
+{
+	memset(mbox_cmd, 0, sizeof(mbox_cmd[0]) * MBOX_REG_COUNT);
+	memset(mbox_sts, 0, sizeof(mbox_sts[0]) * MBOX_REG_COUNT);
+	mbox_cmd[0] = MBOX_CMD_SET_ACB;
+	mbox_cmd[1] = 0; /* Primary ACB */
+	mbox_cmd[2] = LSDW(acb_dma);
+	mbox_cmd[3] = MSDW(acb_dma);
+	mbox_cmd[4] = sizeof(struct addr_ctrl_blk);
+
+	if (qla4xxx_mailbox_command(ha, 5, 5, mbox_cmd, mbox_sts) !=
+	    QLA_SUCCESS) {
+		DEBUG2(printk(KERN_WARNING "scsi%ld: %s: "
+		    "MBOX_CMD_SET_ACB failed w/ status %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a4acb0d..7b2e237 100644
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
 
@@ -201,6 +204,339 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 	return len;
 }
 
+/* Only for primary ACB, secondary ACB not supported
+ * iface_num = 0: valid -> linklocal, routable, router, autocfg options
+ * iface_num = 1: valid -> routable
+ */
+static inline void qla4xxx_set_ipv6(struct iscsi_net_param *net_param,
+		struct addr_ctrl_blk *init_fw_cb)
+{
+	switch (net_param->param_type) {
+	case ISCSI_NET_PARAM_IPV6_ADDR:
+		if (net_param->iface_num & 0x1) {
+			/* Routable 1 */
+			memcpy(init_fw_cb->ipv6_addr1, net_param->value,
+			    sizeof(init_fw_cb->ipv6_addr1));
+		} else {
+			/* Routable 0 */
+			memcpy(init_fw_cb->ipv6_addr0, net_param->value,
+			    sizeof(init_fw_cb->ipv6_addr0));
+		}
+		break;
+	case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
+		if (net_param->iface_num & 0x1)
+			break;
+		memcpy(init_fw_cb->ipv6_if_id, &net_param->value[8],
+		    sizeof(init_fw_cb->ipv6_if_id));
+
+		break;
+	case ISCSI_NET_PARAM_IPV6_ROUTER:
+		if (net_param->iface_num & 0x1)
+			break;
+		memcpy(init_fw_cb->ipv6_dflt_rtr_addr, net_param->value,
+		    sizeof(init_fw_cb->ipv6_dflt_rtr_addr));
+		break;
+	case ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG:
+		/* Autocfg applies to even interface */
+		if (net_param->iface_num & 0x1)
+			break;
+
+		if (net_param->value[0] & ISCSI_IPV6_AUTOCFG_DISABLE) {
+			DEBUG2(printk(KERN_INFO
+			    "%s: User Config IPv6 addr\n", __func__));
+			init_fw_cb->ipv6_addtl_opts &=
+			    ~IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE;
+		} else if (net_param->value[0] & ISCSI_IPV6_AUTOCFG_ND_ENABLE) {
+			DEBUG2(printk(KERN_INFO
+			    "%s: AUTO Config IPv6 addr\n", __func__));
+			init_fw_cb->ipv6_addtl_opts |=
+			    IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE;
+		} else {
+			DEBUG2(printk(KERN_INFO
+			    "%s: Invalid setting for  IPv6 addr\n", __func__));
+		}
+		break;
+	case ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG:
+		/* Autocfg applies to even interface */
+		if (net_param->iface_num & 0x1)
+			break;
+
+		if (net_param->value[0] & ISCSI_IPV6_LINKLOCAL_AUTOCFG_ENABLE) {
+			DEBUG2(printk(KERN_INFO
+			    "%s: AUTO Config link local addr\n", __func__));
+			init_fw_cb->ipv6_addtl_opts |=
+			    IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR;
+		} else if (net_param->value[0] &
+		    ISCSI_IPV6_LINKLOCAL_AUTOCFG_DISABLE) {
+			DEBUG2(printk(KERN_INFO
+			    "%s: User Config link local addr\n", __func__));
+			init_fw_cb->ipv6_addtl_opts &=
+			    ~IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR;
+		} else {
+			DEBUG2(printk(KERN_INFO
+			    "%s: Invalid setting for  IPv6 addr\n", __func__));
+		}
+		break;
+	case ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG:
+		/* Autocfg applies to even interface */
+		if (net_param->iface_num & 0x1)
+			break;
+
+		if (net_param->value[0] & ISCSI_IPV6_ROUTER_AUTOCFG_ENABLE) {
+			DEBUG2(printk(KERN_INFO
+			    "%s: AUTO Config router addr\n", __func__));
+			memset(init_fw_cb->ipv6_dflt_rtr_addr, 0,
+			    sizeof(init_fw_cb->ipv6_dflt_rtr_addr));
+		}
+		break;
+	case ISCSI_NET_PARAM_VLAN:
+		if (net_param->length != sizeof(init_fw_cb->ipv6_vlan_tag))
+			break;
+		init_fw_cb->ipv6_vlan_tag = *(uint16_t *)net_param->value;
+		break;
+	case ISCSI_NET_PARAM_IFACE_STATE:
+		if (net_param->value[0])
+			init_fw_cb->ipv6_opts |= IPV6_OPT_IPV6_PROTOCOL_ENABLE;
+		else
+			init_fw_cb->ipv6_opts &= ~IPV6_OPT_IPV6_PROTOCOL_ENABLE;
+		break;
+	default:
+		printk(KERN_INFO
+		    "Unknown param = %d\n", net_param->param_type);
+		break;
+	}
+}
+
+static inline void qla4xxx_set_ipv4(struct iscsi_net_param *net_param,
+		struct addr_ctrl_blk *init_fw_cb)
+{
+	switch (net_param->param_type) {
+	case ISCSI_NET_PARAM_IPV4_ADDR:
+		memcpy(init_fw_cb->ipv4_addr, net_param->value,
+		    sizeof(init_fw_cb->ipv4_addr));
+		break;
+	case ISCSI_NET_PARAM_IPV4_SUBNET:
+		memcpy(init_fw_cb->ipv4_subnet,	net_param->value,
+		    sizeof(init_fw_cb->ipv4_subnet));
+		break;
+	case ISCSI_NET_PARAM_IPV4_GW:
+		memcpy(init_fw_cb->ipv4_gw_addr, net_param->value,
+		    sizeof(init_fw_cb->ipv4_gw_addr));
+		break;
+	case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
+		if (net_param->value[0])
+			init_fw_cb->ipv4_tcp_opts |= TCPOPT_DHCP_ENABLE;
+		else
+			init_fw_cb->ipv4_tcp_opts &= ~TCPOPT_DHCP_ENABLE;
+		break;
+	case ISCSI_NET_PARAM_VLAN:
+		if (net_param->length != sizeof(init_fw_cb->ipv4_vlan_tag))
+			break;
+		init_fw_cb->ipv4_vlan_tag = *(uint16_t *)net_param->value;
+		/* TODO: Set the bit indicating VLAN enabled */
+		break;
+	case ISCSI_NET_PARAM_IFACE_STATE:
+		if (net_param->value[0])
+			init_fw_cb->ipv4_ip_opts |= IPOPT_IPv4_PROTOCOL_ENABLE;
+		else
+			init_fw_cb->ipv4_ip_opts &= ~IPOPT_IPv4_PROTOCOL_ENABLE;
+		break;
+	default:
+		printk(KERN_ERR
+		    "Unknown param = %d\n", net_param->param_type);
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
+	uint32_t ddb_state;
+	struct ddb_entry *ddb_entry, *ddbtemp;
+	unsigned long wait_time;
+
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	uint32_t total_param_count;
+	uint32_t length;
+
+	init_fw_cb = dma_alloc_coherent(&ha->pdev->dev,
+	    sizeof(struct addr_ctrl_blk), &init_fw_cb_dma, GFP_KERNEL);
+	if (!init_fw_cb) {
+		printk(KERN_ERR
+		    "scsi(%ld): %s: Unable to alloc init_cb\n",
+		    ha->host_no, __func__);
+		return  -ENOMEM;
+	}
+
+	acb = dma_alloc_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk),
+	    &acb_dma, GFP_KERNEL);
+	if (!acb) {
+		printk(KERN_ERR
+		    "scsi(%ld): %s: Unable to alloc acb\n",
+		    ha->host_no, __func__);
+		rval = -ENOMEM;
+		goto exit_init_fw_cb;
+	}
+	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
+	memset(acb, 0, sizeof(struct addr_ctrl_blk));
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	if (qla4xxx_get_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma)) {
+		printk(KERN_ERR
+		    "scsi(%ld): %s: get ifcb failed\n",
+		    ha->host_no, __func__);
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
+				qla4xxx_set_ipv4(net_param, init_fw_cb);
+				break;
+			default:
+				/* Cannot have more than one IPv4 interface */
+				printk(KERN_ERR
+				    "IFACE num-%d incorrect for IPv4 setting\n",
+				    net_param->iface_num);
+				break;
+			}
+			break;
+		case IFACE_TYPE_IPV6:
+			switch (net_param->iface_num) {
+			case 0:
+			case 1:
+				qla4xxx_set_ipv6(net_param, init_fw_cb);
+				break;
+			default:
+				/* Cannot have more than two IPv6 interface */
+				printk(KERN_ERR
+				    "IFACE num-%d incorrect for IPv6 setting\n",
+				    net_param->iface_num);
+				break;
+			}
+			break;
+		default:
+			printk(KERN_ERR "Only IPv4 & IPv6 Supported\n");
+			break;
+		}
+
+		net_param = (struct iscsi_net_param *)((uint8_t *)net_param +
+		    sizeof(struct iscsi_net_param) + length);
+	}
+
+	init_fw_cb->cookie = 0x11BEAD5A;
+
+	if (qla4xxx_set_flash(ha, init_fw_cb_dma, FLASH_SEGMENT_IFCB,
+	    sizeof(struct addr_ctrl_blk), FLASH_OPT_RMW_COMMIT)) {
+		printk(KERN_ERR "scsi(%ld): %s: set flash failed\n",
+		    ha->host_no, __func__);
+		rval = -EIO;
+		goto exit_init_fw_cb;
+	}
+
+	/* TODO: See if an option can be added to allow user to do session */
+	/* logout Close all TCP connection */
+	list_for_each_entry_safe(ddb_entry, ddbtemp, &ha->ddb_list, list) {
+		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE)
+			rval  = qla4xxx_conn_close_sess_logout(ha,
+			    ddb_entry->fw_ddb_index, ddb_entry->connection_id,
+			    LOGOUT_OPTION_CLOSE_SESSION);
+		if (rval != QLA_SUCCESS)
+			printk(KERN_ERR
+			    "qla4xxx_conn_close_sess_logout failed "
+			    "for ddb index = 0x%x\n", ddb_entry->fw_ddb_index);
+	}
+
+	/* Wait for AEN 8014 to come ??? */
+	list_for_each_entry_safe(ddb_entry, ddbtemp, &ha->ddb_list, list) {
+		wait_time = jiffies + (LOGOUT_TOV * HZ);
+		while (!time_after_eq(jiffies, wait_time)) {
+			rval = qla4xxx_get_fwddb_entry(ha,
+			    ddb_entry->fw_ddb_index, NULL, 0, NULL, NULL,
+			    &ddb_state, NULL, NULL, NULL);
+			if (rval != QLA_SUCCESS)
+				break;
+
+			if ((ddb_state == DDB_DS_UNASSIGNED) ||
+			    (ddb_state == DDB_DS_NO_CONNECTION_ACTIVE)) {
+				printk(KERN_INFO
+				    "%s: ddb[%d]: conn close\n", __func__,
+				    ddb_entry->fw_ddb_index);
+				break;
+			}
+			ssleep(1);
+		}
+	}
+
+	qla4xxx_disable_acb(ha);
+
+	/* Get ACB to check the state of IP address */
+	if (qla4xxx_get_acb(ha, &mbox_cmd[0], &mbox_sts[0], acb_dma)) {
+		printk(KERN_ERR
+		    "scsi(%ld): %s: get acb failed\n", ha->host_no, __func__);
+		rval = -EIO;
+		goto exit_acb;
+	}
+
+	qla4xxx_initcb_to_acb(init_fw_cb);
+	qla4xxx_set_acb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma);
+
+	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
+	qla4xxx_update_local_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb,
+	    init_fw_cb_dma);
+
+	printk(KERN_ERR "%s: cmd=%d, Returning success\n", __func__,
+	    rval);
+exit_acb:
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk),
+	    acb, acb_dma);
+exit_init_fw_cb:
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk),
+	    init_fw_cb, init_fw_cb_dma);
+
+	return rval;
+}
+
 static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
 				  enum iscsi_param param, char *buf)
 {
-- 
1.7.3.2

