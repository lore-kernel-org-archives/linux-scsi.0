From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 04/14] qla2xxx: Use IOCB interface to submit non-critical MBX.
Date: Fri, 3 Feb 2017 14:40:45 -0800
Message-ID: <1486161655-2307-5-git-send-email-himanshu.madhani@cavium.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0063.outbound.protection.outlook.com ([104.47.37.63]:39605
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752983AbdBCWlj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 17:41:39 -0500
In-Reply-To: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

The Mailbox interface is currently over subscribed. We like
to reserve the Mailbox interface for the chip managment and
link initialization. Any non essential Mailbox command will
be routed through the IOCB interface. The IOCB interface is
able to absorb more commands.

Following commands are being routed through IOCB interface

- Get ID List (007Ch)
- Get Port DB (0064h)
- Get Link Priv Stats (006Dh)

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |   8 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |  10 +-
 drivers/scsi/qla2xxx/qla_init.c   |  46 +------
 drivers/scsi/qla2xxx/qla_isr.c    |   2 +-
 drivers/scsi/qla2xxx/qla_mbx.c    | 273 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c |   4 +-
 6 files changed, 279 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bf2ae8d3..f92977b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -395,11 +395,15 @@ struct srb_iocb {
 			struct completion comp;
 		} abt;
 		struct ct_arg ctarg;
+#define MAX_IOCB_MB_REG 28
+#define SIZEOF_IOCB_MB_REG (MAX_IOCB_MB_REG * sizeof(uint16_t))
 		struct {
-			__le16 in_mb[28]; 	/* fr fw */
-			__le16 out_mb[28];	/* to fw */
+			__le16 in_mb[MAX_IOCB_MB_REG];	/* from FW */
+			__le16 out_mb[MAX_IOCB_MB_REG];	/* to FW */
 			void *out, *in;
 			dma_addr_t out_dma, in_dma;
+			struct completion comp;
+			int rc;
 		} mbx;
 		struct {
 			struct imm_ntfy_from_isp *ntfy;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 862d5f5..48a1190 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -194,6 +194,7 @@ void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
 	uint16_t *);
 int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
 void qla2x00_schedule_work(struct scsi_qla_host *);
+int qla24xx_async_abort_cmd(srb_t *);
 
 /*
  * Global Functions in qla_mid.c source file.
@@ -369,7 +370,7 @@ extern int qla24xx_build_scsi_crc_2_iocbs(srb_t *,
 
 extern int
 qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
-    dma_addr_t, uint);
+    dma_addr_t, uint16_t);
 
 extern int qla24xx_abort_command(srb_t *);
 extern int qla24xx_async_abort_command(srb_t *);
@@ -473,6 +474,13 @@ extern int qla24xx_set_fcp_prio(scsi_qla_host_t *, uint16_t, uint16_t,
 extern int
 qla26xx_dport_diagnostics(scsi_qla_host_t *, void *, uint, uint);
 
+int qla24xx_send_mb_cmd(struct scsi_qla_host *, mbx_cmd_t *);
+int qla24xx_gpdb_wait(struct scsi_qla_host *, fc_port_t *, u8);
+int qla24xx_gidlist_wait(struct scsi_qla_host *, void *, dma_addr_t,
+    uint16_t *);
+int __qla24xx_parse_gpdb(struct scsi_qla_host *, fc_port_t *,
+	struct port_database_24xx *);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e84ab37..5aca3df 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -629,7 +629,6 @@ void qla24xx_async_gpdb_sp_done(void *s, int res)
 	struct srb *sp = s;
 	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
-	uint64_t zero = 0;
 	struct port_database_24xx *pd;
 	fc_port_t *fcport = sp->fcport;
 	u16 *mb = sp->u.iocb_cmd.u.mbx.in_mb;
@@ -649,48 +648,7 @@ void qla24xx_async_gpdb_sp_done(void *s, int res)
 
 	pd = (struct port_database_24xx *)sp->u.iocb_cmd.u.mbx.in;
 
-	/* Check for logged in state. */
-	if (pd->current_login_state != PDS_PRLI_COMPLETE &&
-	    pd->last_login_state != PDS_PRLI_COMPLETE) {
-		ql_dbg(ql_dbg_mbx, vha, 0xffff,
-		    "Unable to verify login-state (%x/%x) for "
-		    "loop_id %x.\n", pd->current_login_state,
-		    pd->last_login_state, fcport->loop_id);
-		rval = QLA_FUNCTION_FAILED;
-		goto gpd_error_out;
-	}
-
-	if (fcport->loop_id == FC_NO_LOOP_ID ||
-	    (memcmp(fcport->port_name, (uint8_t *)&zero, 8) &&
-		memcmp(fcport->port_name, pd->port_name, 8))) {
-		/* We lost the device mid way. */
-		rval = QLA_NOT_LOGGED_IN;
-		goto gpd_error_out;
-	}
-
-	/* Names are little-endian. */
-	memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
-
-	/* Get port_id of device. */
-	fcport->d_id.b.domain = pd->port_id[0];
-	fcport->d_id.b.area = pd->port_id[1];
-	fcport->d_id.b.al_pa = pd->port_id[2];
-	fcport->d_id.b.rsvd_1 = 0;
-
-	/* If not target must be initiator or unknown type. */
-	if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
-		fcport->port_type = FCT_INITIATOR;
-	else
-		fcport->port_type = FCT_TARGET;
-
-	/* Passback COS information. */
-	fcport->supported_classes = (pd->flags & PDF_CLASS_2) ?
-		FC_COS_CLASS2 : FC_COS_CLASS3;
-
-	if (pd->prli_svc_param_word_3[0] & BIT_7) {
-		fcport->flags |= FCF_CONF_COMP_SUPPORTED;
-		fcport->conf_compl_supported = 1;
-	}
+	rval = __qla24xx_parse_gpdb(vha, fcport, pd);
 
 gpd_error_out:
 	memset(&ea, 0, sizeof(ea));
@@ -1270,7 +1228,7 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 	complete(&abt->u.abt.comp);
 }
 
-static int
+int
 qla24xx_async_abort_cmd(srb_t *cmd_sp)
 {
 	scsi_qla_host_t *vha = cmd_sp->vha;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f1da53d..3c2599a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2702,7 +2702,7 @@ struct scsi_dif_tuple {
 		return;
 
 	abt = &sp->u.iocb_cmd;
-	abt->u.abt.comp_status = le32_to_cpu(pkt->nport_handle);
+	abt->u.abt.comp_status = le16_to_cpu(pkt->nport_handle);
 	sp->done(sp, 0);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index db6bd92..4225256 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -10,6 +10,29 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 
+static struct mb_cmd_name {
+	uint16_t cmd;
+	char *str;
+} mb_str[] = {
+	{0xffff,		"unknown"},
+	{MBC_GET_PORT_DATABASE,	"GPDB"},
+	{MBC_GET_ID_LIST,	"GIDList"},
+	{MBC_GET_LINK_PRIV_STATS, "Stats"},
+};
+
+static char *mb_to_str(uint16_t cmd)
+{
+	int i;
+	struct mb_cmd_name *e;
+
+	for (i = 0; i < ARRAY_SIZE(mb_str); i++) {
+		e = mb_str + i;
+		if (cmd == e->cmd)
+			return e->str;
+	}
+	return mb_str[0].str; /* unknown */
+}
+
 static struct rom_cmd {
 	uint16_t cmd;
 } rom_cmds[] = {
@@ -2818,7 +2841,7 @@ static int is_rom_cmd(uint16_t cmd)
 
 int
 qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
-    dma_addr_t stats_dma, uint options)
+    dma_addr_t stats_dma, uint16_t options)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -2828,19 +2851,17 @@ static int is_rom_cmd(uint16_t cmd)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1088,
 	    "Entered %s.\n", __func__);
 
-	mcp->mb[0] = MBC_GET_LINK_PRIV_STATS;
-	mcp->mb[2] = MSW(stats_dma);
-	mcp->mb[3] = LSW(stats_dma);
-	mcp->mb[6] = MSW(MSD(stats_dma));
-	mcp->mb[7] = LSW(MSD(stats_dma));
-	mcp->mb[8] = sizeof(struct link_statistics) / 4;
-	mcp->mb[9] = vha->vp_idx;
-	mcp->mb[10] = options;
-	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
-	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	mcp->tov = MBX_TOV_SECONDS;
-	mcp->flags = IOCTL_CMD;
-	rval = qla2x00_mailbox_command(vha, mcp);
+	memset(&mc, 0, sizeof(mc));
+	mc.mb[0] = MBC_GET_LINK_PRIV_STATS;
+	mc.mb[2] = MSW(stats_dma);
+	mc.mb[3] = LSW(stats_dma);
+	mc.mb[6] = MSW(MSD(stats_dma));
+	mc.mb[7] = LSW(MSD(stats_dma));
+	mc.mb[8] = sizeof(struct link_statistics) / 4;
+	mc.mb[9] = cpu_to_le16(vha->vp_idx);
+	mc.mb[10] = cpu_to_le16(options);
+
+	rval = qla24xx_send_mb_cmd(vha, &mc);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
@@ -5827,3 +5848,227 @@ struct cs84xx_mgmt_cmd {
 
 	return rval;
 }
+
+static void qla2x00_async_mb_sp_done(void *s, int res)
+{
+	struct srb *sp = s;
+
+	sp->u.iocb_cmd.u.mbx.rc = res;
+
+	complete(&sp->u.iocb_cmd.u.mbx.comp);
+	/* don't free sp here. Let the caller do the free */
+}
+
+/*
+ * This mailbox uses the iocb interface to send MB command.
+ * This allows non-critial (non chip setup) command to go
+ * out in parrallel.
+ */
+int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	srb_t *sp;
+	struct srb_iocb *c;
+	char *name;
+
+	if (!vha->hw->flags.fw_started)
+		goto done;
+
+	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
+	if (!sp)
+		goto done;
+
+	sp->type = SRB_MB_IOCB;
+	sp->name = mb_to_str(mcp->mb[0]);
+	name = sp->name;
+
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
+	memcpy(sp->u.iocb_cmd.u.mbx.out_mb, mcp->mb, SIZEOF_IOCB_MB_REG);
+
+	c = &sp->u.iocb_cmd;
+	c->timeout = qla2x00_async_iocb_timeout;
+	init_completion(&c->u.mbx.comp);
+
+	sp->done = qla2x00_async_mb_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+		    "%s: %s Failed submission. %x.\n",
+		    __func__, sp->name, rval);
+		goto done_free_sp;
+	}
+
+	ql_dbg(ql_dbg_mbx, vha, 0xffff, "MB:%s hndl %x submitted\n",
+	    sp->name, sp->handle);
+
+	wait_for_completion(&c->u.mbx.comp);
+	memcpy(mcp->mb, sp->u.iocb_cmd.u.mbx.in_mb, SIZEOF_IOCB_MB_REG);
+
+	rval = c->u.mbx.rc;
+	switch (rval) {
+	case QLA_FUNCTION_TIMEOUT:
+		ql_dbg(ql_dbg_mbx, vha, 0xffff, "%s: %s Timeout. %x.\n",
+		    __func__, name, rval);
+		break;
+	case  QLA_SUCCESS:
+		ql_dbg(ql_dbg_mbx, vha, 0xffff, "%s: %s done.\n",
+		    __func__, sp->name);
+		sp->free(sp);
+		break;
+	default:
+		ql_dbg(ql_dbg_mbx, vha, 0xffff, "%s: %s Failed. %x.\n",
+		    __func__, sp->name, rval);
+		sp->free(sp);
+		break;
+	}
+
+	return rval;
+
+done_free_sp:
+	sp->free(sp);
+done:
+	return rval;
+}
+
+/*
+ * qla24xx_gpdb_wait
+ * NOTE: Do not call this routine from DPC thread
+ */
+int qla24xx_gpdb_wait(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	dma_addr_t pd_dma;
+	struct port_database_24xx *pd;
+	struct qla_hw_data *ha = vha->hw;
+	mbx_cmd_t mc;
+
+	if (!vha->hw->flags.fw_started)
+		goto done;
+
+	pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
+	if (pd  == NULL) {
+		ql_log(ql_log_warn, vha, 0xffff,
+			"Failed to allocate port database structure.\n");
+		goto done_free_sp;
+	}
+	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
+
+	memset(&mc, 0, sizeof(mc));
+	mc.mb[0] = MBC_GET_PORT_DATABASE;
+	mc.mb[1] = cpu_to_le16(fcport->loop_id);
+	mc.mb[2] = MSW(pd_dma);
+	mc.mb[3] = LSW(pd_dma);
+	mc.mb[6] = MSW(MSD(pd_dma));
+	mc.mb[7] = LSW(MSD(pd_dma));
+	mc.mb[9] = cpu_to_le16(vha->vp_idx);
+	mc.mb[10] = cpu_to_le16((uint16_t)opt);
+
+	rval = qla24xx_send_mb_cmd(vha, &mc);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+		    "%s: %8phC fail\n", __func__, fcport->port_name);
+		goto done_free_sp;
+	}
+
+	rval = __qla24xx_parse_gpdb(vha, fcport, pd);
+
+	ql_dbg(ql_dbg_mbx, vha, 0xffff, "%s: %8phC done\n",
+	    __func__, fcport->port_name);
+
+done_free_sp:
+	if (pd)
+		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
+done:
+	return rval;
+}
+
+int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
+    struct port_database_24xx *pd)
+{
+	int rval = QLA_SUCCESS;
+	uint64_t zero = 0;
+
+	/* Check for logged in state. */
+	if (pd->current_login_state != PDS_PRLI_COMPLETE &&
+		pd->last_login_state != PDS_PRLI_COMPLETE) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			   "Unable to verify login-state (%x/%x) for "
+			   "loop_id %x.\n", pd->current_login_state,
+			   pd->last_login_state, fcport->loop_id);
+		rval = QLA_FUNCTION_FAILED;
+		goto gpd_error_out;
+	}
+
+	if (fcport->loop_id == FC_NO_LOOP_ID ||
+	    (memcmp(fcport->port_name, (uint8_t *)&zero, 8) &&
+	     memcmp(fcport->port_name, pd->port_name, 8))) {
+		/* We lost the device mid way. */
+		rval = QLA_NOT_LOGGED_IN;
+		goto gpd_error_out;
+	}
+
+	/* Names are little-endian. */
+	memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
+	memcpy(fcport->port_name, pd->port_name, WWN_SIZE);
+
+	/* Get port_id of device. */
+	fcport->d_id.b.domain = pd->port_id[0];
+	fcport->d_id.b.area = pd->port_id[1];
+	fcport->d_id.b.al_pa = pd->port_id[2];
+	fcport->d_id.b.rsvd_1 = 0;
+
+	/* If not target must be initiator or unknown type. */
+	if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
+		fcport->port_type = FCT_INITIATOR;
+	else
+		fcport->port_type = FCT_TARGET;
+
+	/* Passback COS information. */
+	fcport->supported_classes = (pd->flags & PDF_CLASS_2) ?
+		FC_COS_CLASS2 : FC_COS_CLASS3;
+
+	if (pd->prli_svc_param_word_3[0] & BIT_7) {
+		fcport->flags |= FCF_CONF_COMP_SUPPORTED;
+		fcport->conf_compl_supported = 1;
+	}
+
+gpd_error_out:
+	return rval;
+}
+
+/*
+ * qla24xx_gidlist__wait
+ * NOTE: don't call this routine from DPC thread.
+ */
+int qla24xx_gidlist_wait(struct scsi_qla_host *vha,
+	void *id_list, dma_addr_t id_list_dma, uint16_t *entries)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	mbx_cmd_t mc;
+
+	if (!vha->hw->flags.fw_started)
+		goto done;
+
+	memset(&mc, 0, sizeof(mc));
+	mc.mb[0] = MBC_GET_ID_LIST;
+	mc.mb[2] = MSW(id_list_dma);
+	mc.mb[3] = LSW(id_list_dma);
+	mc.mb[6] = MSW(MSD(id_list_dma));
+	mc.mb[7] = LSW(MSD(id_list_dma));
+	mc.mb[8] = 0;
+	mc.mb[9] = cpu_to_le16(vha->vp_idx);
+
+	rval = qla24xx_send_mb_cmd(vha, &mc);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			"%s:  fail\n", __func__);
+	} else {
+		*entries = mc.mb[1];
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			"%s:  done\n", __func__);
+	}
+done:
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8d21c04..a4cc14b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1217,7 +1217,7 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 	}
 
 	/* Get list of logged in devices */
-	rc = qla2x00_get_id_list(vha, gid_list, gid_list_dma, &entries);
+	rc = qla24xx_gidlist_wait(vha, gid_list, gid_list_dma, &entries);
 	if (rc != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf045,
 		    "qla_target(%d): get_id_list() failed: %x\n",
@@ -5524,7 +5524,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 
 	fcport->loop_id = loop_id;
 
-	rc = qla2x00_get_port_database(vha, fcport, 0);
+	rc = qla24xx_gpdb_wait(vha, fcport, 0);
 	if (rc != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf070,
 		    "qla_target(%d): Failed to retrieve fcport "
-- 
1.8.3.1
