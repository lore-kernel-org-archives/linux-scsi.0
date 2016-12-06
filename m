From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 12/22] qla2xxx: Add Dual mode support in the driver
Date: Tue, 6 Dec 2016 12:30:41 -0800
Message-ID: <1481056251-2310-13-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0054.outbound.protection.outlook.com ([104.47.41.54]:49890
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752316AbcLFUbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:31:20 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Add switch to allow both Initiator Mode & Target
mode to operate at the same time.

Also remove unwanted/unused ini_mode_force option

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |   2 +-
 drivers/scsi/qla2xxx/qla_init.c    |   8 +--
 drivers/scsi/qla2xxx/qla_isr.c     |  19 +++++-
 drivers/scsi/qla2xxx/qla_target.c  | 129 +++++++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_target.h  |  15 ++---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   2 +-
 6 files changed, 131 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6370aca..6bf7ff9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3175,7 +3175,6 @@ struct qlt_hw_data {
 	/* Protected by hw lock */
 	uint32_t enable_class_2:1;
 	uint32_t enable_explicit_conf:1;
-	uint32_t ini_mode_force_reverse:1;
 	uint32_t node_name_set:1;
 
 	dma_addr_t atio_dma;	/* Physical address. */
@@ -3328,6 +3327,7 @@ struct qla_hw_data {
 #define FLOGI_SP_SUPPORT        BIT_13
 
 	uint8_t		port_no;		/* Physical port of adapter */
+	uint8_t		exch_starvation;
 
 	/* Timeout timers. */
 	uint8_t 	loop_down_abort_time;    /* port down timer */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cfdfb02..df6a51f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -813,9 +813,9 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	fcport->flags &= ~FCF_ASYNC_SENT;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
-		"%s %8phC DS %d LS %d \n",
+		"%s %8phC DS %d LS %d rval %d \n",
 		__func__, fcport->port_name, fcport->disc_state,
-		   fcport->fw_login_state);
+		fcport->fw_login_state, rval);
 
 	if (ea->sp->gen2 != fcport->login_gen) {
 		/* target side must have changed it. */
@@ -4020,7 +4020,8 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			 * Process any ATIO queue entries that came in
 			 * while we weren't online.
 			 */
-			if (qla_tgt_mode_enabled(vha)) {
+			if (qla_tgt_mode_enabled(vha) ||
+				qla_dual_mode_enabled(vha)) {
 				if (IS_QLA27XX(ha) || IS_QLA83XX(ha)) {
 					spin_lock_irqsave(&ha->tgt.atio_lock,
 					    flags);
@@ -5739,7 +5740,6 @@ int qla2x00_perform_loop_resync(scsi_qla_host_t *ha)
 		if (!status) {
 			/* Issue a marker after FW becomes ready. */
 			qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
-
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7a7a8c6..04899f4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1029,7 +1029,8 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 
 		qla2x00_mark_all_devices_lost(vha, 1);
 
-		if (vha->vp_idx == 0 && !qla_ini_mode_enabled(vha))
+		if (vha->vp_idx == 0 &&
+			(qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)))
 			set_bit(SCR_PENDING, &vha->dpc_flags);
 
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
@@ -1648,6 +1649,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 		    le32_to_cpu(logio->io_parameter[0]));
 
+		vha->hw->exch_starvation = 0;
 		data[0] = MBS_COMMAND_COMPLETE;
 		if (sp->type != SRB_LOGIN_CMD)
 			goto logio_done;
@@ -1683,6 +1685,21 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	case LSC_SCODE_NPORT_USED:
 		data[0] = MBS_LOOP_ID_USED;
 		break;
+	case LSC_SCODE_NOXCB:
+		vha->hw->exch_starvation++;
+		if (vha->hw->exch_starvation > 5) {
+			ql_log(ql_log_warn, vha, 0xffff,
+			    "Exchange starvation. Reseting RISC\n");
+
+			vha->hw->exch_starvation = 0;
+
+			if (IS_P3P_TYPE(vha->hw))
+				set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+			else
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+		}
+		/* drop through */
 	default:
 		data[0] = MBS_COMMAND_ERROR;
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cd7494f..8ccbd74 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -53,8 +53,17 @@
 	"disabled on enabling target mode and then on disabling target mode "
 	"enabled back; "
 	"\"disabled\" - initiator mode will never be enabled; "
+	"\"dual\" - Initiator Modes will be enabled. Target Mode can be activated "
+	"when ready "
 	"\"enabled\" (default) - initiator mode will always stay enabled.");
 
+static int ql_dm_tgt_ex_pct = 50;
+module_param(ql_dm_tgt_ex_pct, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql_dm_tgt_ex_pct,
+	"For Dual Mode (qlini_mode=dual), this parameter determines "
+	"the percentage of exchanges/cmds FW will allocate resources "
+	"for Target mode.");
+
 int ql2x_ini_mode = QLA2XXX_INI_MODE_EXCLUSIVE;
 
 static int temp_sam_status = SAM_STAT_BUSY;
@@ -1285,7 +1294,8 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	wait_event(tgt->waitQ, test_tgt_sess_count(tgt));
 
 	/* Big hammer */
-	if (!ha->flags.host_shutting_down && qla_tgt_mode_enabled(vha))
+	if (!ha->flags.host_shutting_down &&
+		(qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)))
 		qlt_disable_vha(vha);
 
 	/* Wait for sessions to clear out (just in case) */
@@ -5981,7 +5991,6 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	case MBA_LOOP_DOWN:
 	case MBA_LIP_RESET:
 	case MBA_RSCN_UPDATE:
-	case MBA_REJECTED_FCP_CMD:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03c,
 		    "qla_target(%d): Async event %#x occurred "
 		    "(m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx, code,
@@ -5989,6 +5998,35 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
 		break;
 
+	case MBA_REJECTED_FCP_CMD:
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
+			"qla_target(%d): Async event LS_REJECT occurred "
+			"(m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx,
+			le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
+			le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
+
+		if (le16_to_cpu(mailbox[3]) == 1) {
+			/* exchange starvation. */
+			vha->hw->exch_starvation++;
+			if (vha->hw->exch_starvation > 5) {
+				ql_log(ql_log_warn, vha, 0xffff,
+				    "Exchange starvation-. Reseting RISC\n");
+
+				vha->hw->exch_starvation = 0;
+
+				if (IS_P3P_TYPE(vha->hw))
+					set_bit(FCOE_CTX_RESET_NEEDED,
+					    &vha->dpc_flags);
+				else
+					set_bit(ISP_ABORT_NEEDED,
+					    &vha->dpc_flags);
+
+				qla2xxx_wake_dpc(vha);
+			}
+		}
+
+		break;
+
 	case MBA_PORT_UPDATE:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03d,
 		    "qla_target(%d): Port update async event %#x "
@@ -5998,10 +6036,11 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
 
 		login_code = le16_to_cpu(mailbox[2]);
-		if (login_code == 0x4)
+		if (login_code == 0x4) {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03e,
 			    "Async MB 2: Got PLOGI Complete\n");
-		else if (login_code == 0x7)
+			vha->hw->exch_starvation = 0;
+		} else if (login_code == 0x7)
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03f,
 			    "Async MB 2: Port Logged Out\n");
 		break;
@@ -6542,30 +6581,26 @@ void qlt_lport_deregister(struct scsi_qla_host *vha)
 /* Must be called under HW lock */
 static void qlt_set_mode(struct scsi_qla_host *vha)
 {
-	struct qla_hw_data *ha = vha->hw;
-
 	switch (ql2x_ini_mode) {
 	case QLA2XXX_INI_MODE_DISABLED:
 	case QLA2XXX_INI_MODE_EXCLUSIVE:
 		vha->host->active_mode = MODE_TARGET;
 		break;
 	case QLA2XXX_INI_MODE_ENABLED:
-		vha->host->active_mode |= MODE_TARGET;
+		vha->host->active_mode = MODE_UNKNOWN;
+		break;
+	case QLA2XXX_INI_MODE_DUAL:
+		vha->host->active_mode = MODE_DUAL;
 		break;
 
 	default:
 		break;
 	}
-
-	if (ha->tgt.ini_mode_force_reverse)
-		qla_reverse_ini_mode(vha);
 }
 
 /* Must be called under HW lock */
 static void qlt_clear_mode(struct scsi_qla_host *vha)
 {
-	struct qla_hw_data *ha = vha->hw;
-
 	switch (ql2x_ini_mode) {
 	case QLA2XXX_INI_MODE_DISABLED:
 		vha->host->active_mode = MODE_UNKNOWN;
@@ -6574,15 +6609,12 @@ static void qlt_clear_mode(struct scsi_qla_host *vha)
 		vha->host->active_mode = MODE_INITIATOR;
 		break;
 	case QLA2XXX_INI_MODE_ENABLED:
-		vha->host->active_mode &= ~MODE_TARGET;
-		vha->host->active_mode |= MODE_INITIATOR;
+	case QLA2XXX_INI_MODE_DUAL:
+		vha->host->active_mode = MODE_INITIATOR;
 		break;
 	default:
 		break;
 	}
-
-	if (ha->tgt.ini_mode_force_reverse)
-		qla_reverse_ini_mode(vha);
 }
 
 /*
@@ -6670,9 +6702,6 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 void
 qlt_vport_create(struct scsi_qla_host *vha, struct qla_hw_data *ha)
 {
-	if (!qla_tgt_mode_enabled(vha))
-		return;
-
 	vha->vha_tgt.qla_tgt = NULL;
 
 	mutex_init(&vha->vha_tgt.tgt_mutex);
@@ -6722,7 +6751,7 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	uint16_t cnt;
 	struct atio_from_isp *pkt = (struct atio_from_isp *)ha->tgt.atio_ring;
 
-	if (!qla_tgt_mode_enabled(vha))
+	if (qla_ini_mode_enabled(vha))
 		return;
 
 	for (cnt = 0; cnt < ha->tgt.atio_q_length; cnt++) {
@@ -6798,8 +6827,11 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 qlt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 {
 	struct qla_hw_data *ha = vha->hw;
+	u32 tmp;
+	u16 t;
 
-	if (qla_tgt_mode_enabled(vha)) {
+	if (qla_tgt_mode_enabled(vha) ||
+		qla_dual_mode_enabled(vha)) {
 		if (!ha->tgt.saved_set) {
 			/* We save only once */
 			ha->tgt.saved_exchange_count = nv->exchange_count;
@@ -6812,7 +6844,23 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 			ha->tgt.saved_set = 1;
 		}
 
-		nv->exchange_count = cpu_to_le16(0xFFFF);
+		if (qla_tgt_mode_enabled(vha)) {
+			nv->exchange_count = cpu_to_le16(0xFFFF);
+		} else {			/* dual */
+			if (ql_dm_tgt_ex_pct > 100) {
+				ql_dm_tgt_ex_pct = 50;
+			} else if (ql_dm_tgt_ex_pct == 100) {
+				/* leave some for FW */
+				ql_dm_tgt_ex_pct = 95;
+			}
+
+			tmp = ha->orig_fw_xcb_count * ql_dm_tgt_ex_pct;
+			tmp = tmp/100;
+			if (tmp > 0xffff)
+				tmp = 0xffff;
+			t = tmp & 0xffff;
+			nv->exchange_count = cpu_to_le16(t);
+		}
 
 		/* Enable target mode */
 		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
@@ -6899,11 +6947,13 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 qlt_81xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_81xx *nv)
 {
 	struct qla_hw_data *ha = vha->hw;
+	u32 tmp;
+	u16 t;
 
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
-	if (qla_tgt_mode_enabled(vha)) {
+	if (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)) {
 		if (!ha->tgt.saved_set) {
 			/* We save only once */
 			ha->tgt.saved_exchange_count = nv->exchange_count;
@@ -6916,7 +6966,24 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 			ha->tgt.saved_set = 1;
 		}
 
-		nv->exchange_count = cpu_to_le16(0xFFFF);
+		if (qla_tgt_mode_enabled(vha)) {
+			nv->exchange_count = cpu_to_le16(0xFFFF);
+		} else {			/* dual */
+			if (ql_dm_tgt_ex_pct > 100) {
+				ql_dm_tgt_ex_pct = 50;
+			} else if (ql_dm_tgt_ex_pct == 100) {
+				/* leave some for FW */
+				ql_dm_tgt_ex_pct = 95;
+			}
+
+			tmp = ha->orig_fw_xcb_count * ql_dm_tgt_ex_pct;
+			tmp = tmp/100;
+			if (tmp > 0xffff)
+				tmp = 0xffff;
+
+			t = tmp & 0xffff;
+			nv->exchange_count = cpu_to_le16(t);
+		}
 
 		/* Enable target mode */
 		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
@@ -7030,9 +7097,15 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 qlt_modify_vp_config(struct scsi_qla_host *vha,
 	struct vp_config_entry_24xx *vpmod)
 {
-	if (qla_tgt_mode_enabled(vha))
+
+	/* enable target mode.
+	   Bit5=1 => disable */
+	if (qla_tgt_mode_enabled(vha) ||
+		qla_dual_mode_enabled(vha))
 		vpmod->options_idx1 &= ~BIT_5;
-	/* Disable ini mode, if requested */
+
+	/* Disable ini mode, if requested.
+	   bit4=1 => disable */
 	if (qla_tgt_mode_enabled(vha))
 		vpmod->options_idx1 &= ~BIT_4;
 }
@@ -7187,6 +7260,8 @@ static int __init qlt_parse_ini_mode(void)
 		ql2x_ini_mode = QLA2XXX_INI_MODE_DISABLED;
 	else if (strcasecmp(qlini_mode, QLA2XXX_INI_MODE_STR_ENABLED) == 0)
 		ql2x_ini_mode = QLA2XXX_INI_MODE_ENABLED;
+	else if (strcasecmp(qlini_mode, QLA2XXX_INI_MODE_STR_DUAL) == 0)
+		ql2x_ini_mode = QLA2XXX_INI_MODE_DUAL;
 	else
 		return false;
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 6d0d738..90b056e 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -45,10 +45,12 @@
 #define QLA2XXX_INI_MODE_STR_EXCLUSIVE	"exclusive"
 #define QLA2XXX_INI_MODE_STR_DISABLED	"disabled"
 #define QLA2XXX_INI_MODE_STR_ENABLED	"enabled"
+#define QLA2XXX_INI_MODE_STR_DUAL		"dual"
 
 #define QLA2XXX_INI_MODE_EXCLUSIVE	0
 #define QLA2XXX_INI_MODE_DISABLED	1
 #define QLA2XXX_INI_MODE_ENABLED	2
+#define QLA2XXX_INI_MODE_DUAL	3
 
 #define QLA2XXX_COMMAND_COUNT_INIT	250
 #define QLA2XXX_IMMED_NOTIFY_COUNT_INIT 250
@@ -1108,7 +1110,9 @@ extern int qlt_lport_register(void *, u64, u64, u64,
  * This macro is used during early initializations when host->active_mode
  * is not set. Right now, ha value is ignored.
  */
-#define QLA_TGT_MODE_ENABLED() (ql2x_ini_mode != QLA2XXX_INI_MODE_ENABLED)
+#define QLA_TGT_MODE_ENABLED() \
+	((ql2x_ini_mode != QLA2XXX_INI_MODE_ENABLED) || \
+	 (ql2x_ini_mode == QLA2XXX_INI_MODE_DUAL))
 extern int ql2x_ini_mode;
 
 static inline bool qla_tgt_mode_enabled(struct scsi_qla_host *ha)
@@ -1127,15 +1131,6 @@ static inline bool qla_dual_mode_enabled(struct scsi_qla_host *ha)
 }
 
 
-
-static inline void qla_reverse_ini_mode(struct scsi_qla_host *ha)
-{
-	if (ha->host->active_mode & MODE_INITIATOR)
-		ha->host->active_mode &= ~MODE_INITIATOR;
-	else
-		ha->host->active_mode |= MODE_INITIATOR;
-}
-
 static inline uint32_t sid_to_key(const uint8_t *s_id)
 {
 	uint32_t key;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c13314a..08033d8 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -2102,7 +2102,7 @@ static int tcm_qla2xxx_lport_register_npiv_cb(struct scsi_qla_host *base_vha,
 			(struct tcm_qla2xxx_lport *)base_vha->vha_tgt.target_lport_ptr;
 	struct fc_vport_identifiers vport_id;
 
-	if (!qla_tgt_mode_enabled(base_vha)) {
+	if (qla_ini_mode_enabled(base_vha)) {
 		pr_err("qla2xxx base_vha not enabled for target mode\n");
 		return -EPERM;
 	}
-- 
1.8.3.1

