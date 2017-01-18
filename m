From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 09/12] qla2xxx: Add Dual mode support in the driver
Date: Wed, 18 Jan 2017 15:19:42 -0800
Message-ID: <1484781585-27252-10-git-send-email-himanshu.madhani@cavium.com>
References: <1484781585-27252-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1484781585-27252-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add switch to allow both Initiator Mode & Target
mode to operate at the same time.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |   1 +
 drivers/scsi/qla2xxx/qla_init.c    |   6 +-
 drivers/scsi/qla2xxx/qla_isr.c     |  19 ++++++-
 drivers/scsi/qla2xxx/qla_target.c  | 110 +++++++++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_target.h  |   3 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   2 +-
 6 files changed, 119 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 253f991..fd179df 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3390,6 +3390,7 @@ struct qla_hw_data {
 #define FLOGI_SP_SUPPORT        BIT_13
 
 	uint8_t		port_no;		/* Physical port of adapter */
+	uint8_t		exch_starvation;
 
 	/* Timeout timers. */
 	uint8_t 	loop_down_abort_time;    /* port down timer */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e628107..2e9142d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1568,8 +1568,7 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha,
 		}
 	}
 
-	if (qla_ini_mode_enabled(vha) ||
-		qla_dual_mode_enabled(vha))
+	if (qla_ini_mode_enabled(vha) || qla_dual_mode_enabled(vha))
 		rval = qla2x00_init_rings(vha);
 
 	ha->flags.chip_reset_done = 1;
@@ -3994,7 +3993,8 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			 * Process any ATIO queue entries that came in
 			 * while we weren't online.
 			 */
-			if (qla_tgt_mode_enabled(vha)) {
+			if (qla_tgt_mode_enabled(vha) ||
+			    qla_dual_mode_enabled(vha)) {
 				if (IS_QLA27XX(ha) || IS_QLA83XX(ha)) {
 					spin_lock_irqsave(&ha->tgt.atio_lock,
 					    flags);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 99088ff..62066af 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1029,7 +1029,8 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 
 		qla2x00_mark_all_devices_lost(vha, 1);
 
-		if (vha->vp_idx == 0 && !qla_ini_mode_enabled(vha))
+		if (vha->vp_idx == 0 &&
+		    (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)))
 			set_bit(SCR_PENDING, &vha->dpc_flags);
 
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
@@ -1642,6 +1643,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 		    le32_to_cpu(logio->io_parameter[0]));
 
+		vha->hw->exch_starvation = 0;
 		data[0] = MBS_COMMAND_COMPLETE;
 		if (sp->type != SRB_LOGIN_CMD)
 			goto logio_done;
@@ -1677,6 +1679,21 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	case LSC_SCODE_NPORT_USED:
 		data[0] = MBS_LOOP_ID_USED;
 		break;
+	case LSC_SCODE_NOXCB:
+		vha->hw->exch_starvation++;
+		if (vha->hw->exch_starvation > 5) {
+			ql_log(ql_log_warn, vha, 0xffff,
+			    "Exchange starvation. Resetting RISC\n");
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
index b5cfab0..225d2bf 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -55,8 +55,17 @@
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
@@ -1295,7 +1304,8 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	wait_event(tgt->waitQ, test_tgt_sess_count(tgt));
 
 	/* Big hammer */
-	if (!ha->flags.host_shutting_down && qla_tgt_mode_enabled(vha))
+	if (!ha->flags.host_shutting_down &&
+	    (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)))
 		qlt_disable_vha(vha);
 
 	/* Wait for sessions to clear out (just in case) */
@@ -5263,6 +5273,32 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
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
+				    "Exchange starvation-. Resetting RISC\n");
+
+				vha->hw->exch_starvation = 0;
+				if (IS_P3P_TYPE(vha->hw))
+					set_bit(FCOE_CTX_RESET_NEEDED,
+					    &vha->dpc_flags);
+				else
+					set_bit(ISP_ABORT_NEEDED,
+					    &vha->dpc_flags);
+				qla2xxx_wake_dpc(vha);
+			}
+		}
+		break;
+
 	case MBA_PORT_UPDATE:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03d,
 		    "qla_target(%d): Port update async event %#x "
@@ -5272,10 +5308,11 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
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
@@ -5826,7 +5863,10 @@ static void qlt_set_mode(struct scsi_qla_host *vha)
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
@@ -5849,8 +5889,8 @@ static void qlt_clear_mode(struct scsi_qla_host *vha)
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
@@ -5945,9 +5985,6 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 void
 qlt_vport_create(struct scsi_qla_host *vha, struct qla_hw_data *ha)
 {
-	if (!qla_tgt_mode_enabled(vha))
-		return;
-
 	vha->vha_tgt.qla_tgt = NULL;
 
 	mutex_init(&vha->vha_tgt.tgt_mutex);
@@ -5978,7 +6015,6 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		ct_req->req.rff_id.fc4_feature = BIT_1;
 	} else if (qla_dual_mode_enabled(vha))
 		ct_req->req.rff_id.fc4_feature = BIT_0 | BIT_1;
-
 }
 
 /*
@@ -5997,7 +6033,7 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	uint16_t cnt;
 	struct atio_from_isp *pkt = (struct atio_from_isp *)ha->tgt.atio_ring;
 
-	if (!qla_tgt_mode_enabled(vha))
+	if (qla_ini_mode_enabled(vha))
 		return;
 
 	for (cnt = 0; cnt < ha->tgt.atio_q_length; cnt++) {
@@ -6090,8 +6126,10 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 qlt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 {
 	struct qla_hw_data *ha = vha->hw;
+	u32 tmp;
+	u16 t;
 
-	if (qla_tgt_mode_enabled(vha)) {
+	if (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)) {
 		if (!ha->tgt.saved_set) {
 			/* We save only once */
 			ha->tgt.saved_exchange_count = nv->exchange_count;
@@ -6104,7 +6142,24 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
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
@@ -6189,11 +6244,13 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
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
@@ -6206,7 +6263,23 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
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
@@ -6316,10 +6389,11 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 qlt_modify_vp_config(struct scsi_qla_host *vha,
 	struct vp_config_entry_24xx *vpmod)
 {
-	if (qla_tgt_mode_enabled(vha))
+	/* enable target mode.  Bit5 = 1 => disable */
+	if (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha))
 		vpmod->options_idx1 &= ~BIT_5;
 
-	/* Disable ini mode, if requested. */
+	/* Disable ini mode, if requested.  bit4 = 1 => disable */
 	if (qla_tgt_mode_enabled(vha))
 		vpmod->options_idx1 &= ~BIT_4;
 }
@@ -6474,6 +6548,8 @@ static int __init qlt_parse_ini_mode(void)
 		ql2x_ini_mode = QLA2XXX_INI_MODE_DISABLED;
 	else if (strcasecmp(qlini_mode, QLA2XXX_INI_MODE_STR_ENABLED) == 0)
 		ql2x_ini_mode = QLA2XXX_INI_MODE_ENABLED;
+	else if (strcasecmp(qlini_mode, QLA2XXX_INI_MODE_STR_DUAL) == 0)
+		ql2x_ini_mode = QLA2XXX_INI_MODE_DUAL;
 	else
 		return false;
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 5e56192..ac86b37 100644
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
@@ -975,6 +977,7 @@ extern int qlt_lport_register(void *, u64, u64, u64,
  * is not set. Right now, ha value is ignored.
  */
 #define QLA_TGT_MODE_ENABLED() (ql2x_ini_mode != QLA2XXX_INI_MODE_ENABLED)
+
 extern int ql2x_ini_mode;
 
 static inline bool qla_tgt_mode_enabled(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index e37d7ee..8b878a2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1744,7 +1744,7 @@ static int tcm_qla2xxx_lport_register_npiv_cb(struct scsi_qla_host *base_vha,
 			(struct tcm_qla2xxx_lport *)base_vha->vha_tgt.target_lport_ptr;
 	struct fc_vport_identifiers vport_id;
 
-	if (!qla_tgt_mode_enabled(base_vha)) {
+	if (qla_ini_mode_enabled(base_vha)) {
 		pr_err("qla2xxx base_vha not enabled for target mode\n");
 		return -EPERM;
 	}
-- 
1.8.3.1
