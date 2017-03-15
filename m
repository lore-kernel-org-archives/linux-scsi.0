From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 10/14] qla2xxx: Use IOCB interface to submit non-critical MBX.
Date: Wed, 15 Mar 2017 09:48:52 -0700
Message-ID: <20170315164856.17255-11-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0067.outbound.protection.outlook.com ([104.47.37.67]:56651
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752504AbdCOQtY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 12:49:24 -0400
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
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
 drivers/scsi/qla2xxx/qla_def.h    |  12 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |  10 +-
 drivers/scsi/qla2xxx/qla_init.c   |  46 +------
 drivers/scsi/qla2xxx/qla_isr.c    |   2 +-
 drivers/scsi/qla2xxx/qla_mbx.c    | 270 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c |   4 +-
 6 files changed, 279 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 8228dfac6a31..ae38b7a789b1 100644
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
@@ -437,7 +441,7 @@ typedef struct srb {
 	uint32_t handle;
 	uint16_t flags;
 	uint16_t type;
-	char *name;
+	const char *name;
 	int iocbs;
 	struct qla_qpair *qpair;
 	u32 gen1;	/* scratch */
@@ -3364,6 +3368,8 @@ struct qla_hw_data {
 		uint32_t	exlogins_enabled:1;
 		uint32_t	exchoffld_enabled:1;
 		/* 35 bits */
+
+		uint32_t	fw_started:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ca6f122e5865..323b912b47f7 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -193,6 +193,7 @@ extern int qla24xx_post_upd_fcport_work(struct scsi_qla_host *, fc_port_t *);
 void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
 	uint16_t *);
 int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
+int qla24xx_async_abort_cmd(srb_t *);
 
 /*
  * Global Functions in qla_mid.c source file.
@@ -368,7 +369,7 @@ qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, struct link_statistics *,
 
 extern int
 qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
-    dma_addr_t, uint);
+    dma_addr_t, uint16_t);
 
 extern int qla24xx_abort_command(srb_t *);
 extern int qla24xx_async_abort_command(srb_t *);
@@ -472,6 +473,13 @@ qla2x00_dump_mctp_data(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
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
index a7865a5d556d..b1bfa63f7d4e 100644
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
@@ -1266,7 +1224,7 @@ qla24xx_abort_sp_done(void *ptr, int res)
 	complete(&abt->u.abt.comp);
 }
 
-static int
+int
 qla24xx_async_abort_cmd(srb_t *cmd_sp)
 {
 	scsi_qla_host_t *vha = cmd_sp->vha;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b2c6da752edd..3953c8d6af69 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2692,7 +2692,7 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		return;
 
 	abt = &sp->u.iocb_cmd;
-	abt->u.abt.comp_status = le32_to_cpu(pkt->nport_handle);
+	abt->u.abt.comp_status = le16_to_cpu(pkt->nport_handle);
 	sp->done(sp, 0);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 35079f417417..e40ed570d3c1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -10,6 +10,28 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 
+static struct mb_cmd_name {
+	uint16_t cmd;
+	const char *str;
+} mb_str[] = {
+	{MBC_GET_PORT_DATABASE,		"GPDB"},
+	{MBC_GET_ID_LIST,		"GIDList"},
+	{MBC_GET_LINK_PRIV_STATS,	"Stats"},
+};
+
+static const char *mb_to_str(uint16_t cmd)
+{
+	int i;
+	struct mb_cmd_name *e;
+
+	for (i = 0; i < ARRAY_SIZE(mb_str); i++) {
+		e = mb_str + i;
+		if (cmd == e->cmd)
+			return e->str;
+	}
+	return "unknown";
+}
+
 static struct rom_cmd {
 	uint16_t cmd;
 } rom_cmds[] = {
@@ -2818,7 +2840,7 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
 
 int
 qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
-    dma_addr_t stats_dma, uint options)
+    dma_addr_t stats_dma, uint16_t options)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -2828,19 +2850,17 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
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
@@ -5827,3 +5847,225 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
 
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
+		    __func__, sp->name, rval);
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
index 563116188c43..38bdcd325fa4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1238,7 +1238,7 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 	}
 
 	/* Get list of logged in devices */
-	rc = qla2x00_get_id_list(vha, gid_list, gid_list_dma, &entries);
+	rc = qla24xx_gidlist_wait(vha, gid_list, gid_list_dma, &entries);
 	if (rc != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf045,
 		    "qla_target(%d): get_id_list() failed: %x\n",
@@ -5648,7 +5648,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 
 	fcport->loop_id = loop_id;
 
-	rc = qla2x00_get_port_database(vha, fcport, 0);
+	rc = qla24xx_gpdb_wait(vha, fcport, 0);
 	if (rc != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf070,
 		    "qla_target(%d): Failed to retrieve fcport "
-- 
2.12.0
