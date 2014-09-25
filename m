From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 13/19] qla2xxx: Add support for QFull throttling and Term Exchange retry
Date: Thu, 25 Sep 2014 04:10:06 -0400
Message-ID: <1411632612-7320-14-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Through the qla target code, the qlt_send_term_exchange() routine
is used in various different places to cleanup an exchange. For the
case of IOCB request queue is full, the exchange is left unhandled/
dangling. Existing code does not have re-try logic to cleanup the
exchange. This patch add retry logic to cleanup the exchange before
letting new commands through.

For the case of FW running out of exchanges, driver need to reply
SAM_STAT_BUSY to the initiators. This patch add a pending queue
for the busy reply in case IOCB queue is unable to handle the cmd.

Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |    4 +-
 drivers/scsi/qla2xxx/qla_def.h    |   17 ++
 drivers/scsi/qla2xxx/qla_os.c     |    2 +
 drivers/scsi/qla2xxx/qla_target.c |  297 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.h |    4 +
 5 files changed, 316 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 09b335e..1b5c7a6 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -19,7 +19,7 @@
  * | Device Discovery             |       0x2016       | 0x2020-0x2022, |
  * |                              |                    | 0x2011-0x2012, |
  * |                              |                    | 0x2099-0x20a4  |
- * | Queue Command and IO tracing |       0x3059       | 0x3006-0x300b  |
+ * | Queue Command and IO tracing |       0x3059       | 0x300b         |
  * |                              |                    | 0x3027-0x3028  |
  * |                              |                    | 0x303d-0x3041  |
  * |                              |                    | 0x302d,0x3033  |
@@ -67,7 +67,7 @@
  * |                              |                    | 0xd031-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
- * | Target Mode		  |	  0xe078       |		|
+ * | Target Mode		  |	  0xe079       |		|
  * | Target Mode Management	  |	  0xf072       | 0xf002		|
  * |                              |                    | 0xf046-0xf049  |
  * | Target Mode Task Management  |	  0x1000b      |		|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6e3b4f5..bd4f1f3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2776,6 +2776,9 @@ struct qla_statistics {
 	uint32_t control_requests;
 
 	uint64_t jiffies_at_last_reset;
+	uint32_t stat_max_pend_cmds;
+	uint32_t stat_max_qfull_cmds_alloc;
+	uint32_t stat_max_qfull_cmds_dropped;
 };
 
 struct bidi_statistics {
@@ -2898,8 +2901,22 @@ struct qlt_hw_data {
 	uint8_t saved_add_firmware_options[2];
 
 	uint8_t tgt_node_name[WWN_SIZE];
+
+	struct list_head q_full_list;
+	uint32_t num_pend_cmds;
+	uint32_t num_qfull_cmds_alloc;
+	uint32_t num_qfull_cmds_dropped;
+	spinlock_t q_full_lock;
+	uint32_t leak_exchg_thresh_hold;
 };
 
+#define MAX_QFULL_CMDS_ALLOC	8192
+#define Q_FULL_THRESH_HOLD_PERCENT 90
+#define Q_FULL_THRESH_HOLD(ha) \
+	((ha->fw_xcb_count/100) * Q_FULL_THRESH_HOLD_PERCENT)
+
+#define LEAK_EXCHG_THRESH_HOLD_PERCENT 75	/* 75 percent */
+
 /*
  * Qlogic host adapter specific data structure.
 */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 366ccf4..2485200 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2397,6 +2397,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    "Memory allocated for ha=%p.\n", ha);
 	ha->pdev = pdev;
 	ha->tgt.enable_class_2 = ql2xenableclass2;
+	INIT_LIST_HEAD(&ha->tgt.q_full_list);
+	spin_lock_init(&ha->tgt.q_full_lock);
 
 	/* Clear our data area */
 	ha->bars = bars;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2c36b6c..fed7fef 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -54,6 +54,8 @@ MODULE_PARM_DESC(qlini_mode,
 
 int ql2x_ini_mode = QLA2XXX_INI_MODE_EXCLUSIVE;
 
+static int temp_sam_status = SAM_STAT_BUSY;
+
 /*
  * From scsi/fc/fc_fcp.h
  */
@@ -103,6 +105,8 @@ static void qlt_reject_free_srr_imm(struct scsi_qla_host *ha,
 	struct qla_tgt_srr_imm *imm, int ha_lock);
 static void qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha,
 	struct qla_tgt_cmd *cmd);
+static void qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
+	struct atio_from_isp *atio, uint16_t status, int qfull);
 /*
  * Global Variables
  */
@@ -180,6 +184,27 @@ struct scsi_qla_host *qlt_find_host_by_vp_idx(struct scsi_qla_host *vha,
 	return NULL;
 }
 
+static inline void qlt_incr_num_pend_cmds(struct scsi_qla_host *vha)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vha->hw->tgt.q_full_lock, flags);
+
+	vha->hw->tgt.num_pend_cmds++;
+	if (vha->hw->tgt.num_pend_cmds > vha->hw->qla_stats.stat_max_pend_cmds)
+		vha->hw->qla_stats.stat_max_pend_cmds =
+			vha->hw->tgt.num_pend_cmds;
+	spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
+}
+static inline void qlt_decr_num_pend_cmds(struct scsi_qla_host *vha)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vha->hw->tgt.q_full_lock, flags);
+	vha->hw->tgt.num_pend_cmds--;
+	spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
+}
+
 void qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio)
 {
@@ -2678,10 +2703,14 @@ static void qlt_send_term_exchange(struct scsi_qla_host *vha,
 
 	if (ha_locked) {
 		rc = __qlt_send_term_exchange(vha, cmd, atio);
+		if (rc == -ENOMEM)
+			qlt_alloc_qfull_cmd(vha, atio, 0, 0);
 		goto done;
 	}
 	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
 	rc = __qlt_send_term_exchange(vha, cmd, atio);
+	if (rc == -ENOMEM)
+		qlt_alloc_qfull_cmd(vha, atio, 0, 0);
 	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 done:
 	/*
@@ -2706,6 +2735,53 @@ done:
 	return;
 }
 
+static void qlt_init_term_exchange(struct scsi_qla_host *vha)
+{
+	struct list_head free_list;
+	struct qla_tgt_cmd *cmd, *tcmd;
+
+	vha->hw->tgt.leak_exchg_thresh_hold =
+	    (vha->hw->fw_xcb_count/100) * LEAK_EXCHG_THRESH_HOLD_PERCENT;
+
+	cmd = tcmd = NULL;
+	if (!list_empty(&vha->hw->tgt.q_full_list)) {
+		INIT_LIST_HEAD(&free_list);
+		list_splice_init(&vha->hw->tgt.q_full_list, &free_list);
+
+		list_for_each_entry_safe(cmd, tcmd, &free_list, cmd_list) {
+			list_del(&cmd->cmd_list);
+			/* This cmd was never sent to TCM.  There is no need
+			 * to schedule free or call free_cmd
+			 */
+			qlt_free_cmd(cmd);
+			vha->hw->tgt.num_qfull_cmds_alloc--;
+		}
+	}
+	vha->hw->tgt.num_qfull_cmds_dropped = 0;
+}
+
+static void qlt_chk_exch_leak_thresh_hold(struct scsi_qla_host *vha)
+{
+	uint32_t total_leaked;
+
+	total_leaked = vha->hw->tgt.num_qfull_cmds_dropped;
+
+	if (vha->hw->tgt.leak_exchg_thresh_hold &&
+	    (total_leaked > vha->hw->tgt.leak_exchg_thresh_hold)) {
+
+		ql_dbg(ql_dbg_tgt, vha, 0xe079,
+		    "Chip reset due to exchange starvation: %d/%d.\n",
+		    total_leaked, vha->hw->fw_xcb_count);
+
+		if (IS_P3P_TYPE(vha->hw))
+			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+		else
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+	}
+
+}
+
 void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 {
 	struct qla_tgt_sess *sess = cmd->sess;
@@ -2715,6 +2791,9 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 	    __func__, &cmd->se_cmd,
 	    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
 
+	if (!cmd->q_full)
+		qlt_decr_num_pend_cmds(cmd->vha);
+
 	BUG_ON(cmd->sg_mapped);
 	if (unlikely(cmd->free_sg))
 		kfree(cmd->sg);
@@ -3073,7 +3152,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		 * level.
 		 */
 		if ((cmd->state != QLA_TGT_STATE_NEED_DATA) &&
-			(cmd->state != QLA_TGT_STATE_ABORTED)) {
+		    (cmd->state != QLA_TGT_STATE_ABORTED)) {
 			if (qlt_term_ctio_exchange(vha, ctio, cmd, status))
 				return;
 		}
@@ -3109,6 +3188,7 @@ skip_term:
 		dump_stack();
 	}
 
+
 	ha->tgt.tgt_ops->free_cmd(cmd);
 }
 
@@ -3206,6 +3286,8 @@ out_term:
 	 */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1);
+
+	qlt_decr_num_pend_cmds(vha);
 	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -3236,6 +3318,7 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	memcpy(&cmd->atio, atio, sizeof(*atio));
 	cmd->state = QLA_TGT_STATE_NEW;
 	cmd->tgt = vha->vha_tgt.qla_tgt;
+	qlt_incr_num_pend_cmds(vha);
 	cmd->vha = vha;
 	cmd->se_cmd.map_tag = tag;
 	cmd->sess = sess;
@@ -4179,7 +4262,7 @@ static void qlt_handle_imm_notify(struct scsi_qla_host *vha,
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  * This function sends busy to ISP 2xxx or 24xx.
  */
-static void qlt_send_busy(struct scsi_qla_host *vha,
+static int __qlt_send_busy(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio, uint16_t status)
 {
 	struct ctio7_to_24xx *ctio24;
@@ -4191,7 +4274,7 @@ static void qlt_send_busy(struct scsi_qla_host *vha,
 	    atio->u.isp24.fcp_hdr.s_id);
 	if (!sess) {
 		qlt_send_term_exchange(vha, NULL, atio, 1);
-		return;
+		return 0;
 	}
 	/* Sending marker isn't necessary, since we called from ISR */
 
@@ -4200,7 +4283,7 @@ static void qlt_send_busy(struct scsi_qla_host *vha,
 		ql_dbg(ql_dbg_io, vha, 0x3063,
 		    "qla_target(%d): %s failed: unable to allocate "
 		    "request packet", vha->vp_idx, __func__);
-		return;
+		return -ENOMEM;
 	}
 
 	pkt->entry_count = 1;
@@ -4232,6 +4315,189 @@ static void qlt_send_busy(struct scsi_qla_host *vha,
 		ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
 
 	qla2x00_start_iocbs(vha, vha->req);
+	return 0;
+}
+
+/*
+ * This routine is used to allocate a command for either a QFull condition
+ * (ie reply SAM_STAT_BUSY) or to terminate an exchange that did not go
+ * out previously.
+ */
+static void
+qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
+	struct atio_from_isp *atio, uint16_t status, int qfull)
+{
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_tgt_sess *sess;
+	struct se_session *se_sess;
+	struct qla_tgt_cmd *cmd;
+	int tag;
+
+	if (unlikely(tgt->tgt_stop)) {
+		ql_dbg(ql_dbg_io, vha, 0x300a,
+			"New command while device %p is shutting down\n", tgt);
+		return;
+	}
+
+	if ((vha->hw->tgt.num_qfull_cmds_alloc + 1) > MAX_QFULL_CMDS_ALLOC) {
+		vha->hw->tgt.num_qfull_cmds_dropped++;
+		if (vha->hw->tgt.num_qfull_cmds_dropped >
+			vha->hw->qla_stats.stat_max_qfull_cmds_dropped)
+			vha->hw->qla_stats.stat_max_qfull_cmds_dropped =
+				vha->hw->tgt.num_qfull_cmds_dropped;
+
+		ql_dbg(ql_dbg_io, vha, 0x3068,
+			"qla_target(%d): %s: QFull CMD dropped[%d]\n",
+			vha->vp_idx, __func__,
+			vha->hw->tgt.num_qfull_cmds_dropped);
+
+		qlt_chk_exch_leak_thresh_hold(vha);
+		return;
+	}
+
+	sess = ha->tgt.tgt_ops->find_sess_by_s_id
+		(vha, atio->u.isp24.fcp_hdr.s_id);
+	if (!sess)
+		return;
+
+	se_sess = sess->se_sess;
+
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	if (tag < 0)
+		return;
+
+	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
+	if (!cmd) {
+		ql_dbg(ql_dbg_io, vha, 0x3009,
+			"qla_target(%d): %s: Allocation of cmd failed\n",
+			vha->vp_idx, __func__);
+
+		vha->hw->tgt.num_qfull_cmds_dropped++;
+		if (vha->hw->tgt.num_qfull_cmds_dropped >
+			vha->hw->qla_stats.stat_max_qfull_cmds_dropped)
+			vha->hw->qla_stats.stat_max_qfull_cmds_dropped =
+				vha->hw->tgt.num_qfull_cmds_dropped;
+
+		qlt_chk_exch_leak_thresh_hold(vha);
+		return;
+	}
+
+	memset(cmd, 0, sizeof(struct qla_tgt_cmd));
+
+	qlt_incr_num_pend_cmds(vha);
+	INIT_LIST_HEAD(&cmd->cmd_list);
+	memcpy(&cmd->atio, atio, sizeof(*atio));
+
+	cmd->tgt = vha->vha_tgt.qla_tgt;
+	cmd->vha = vha;
+	cmd->reset_count = vha->hw->chip_reset;
+	cmd->q_full = 1;
+
+	if (qfull) {
+		cmd->q_full = 1;
+		/* NOTE: borrowing the state field to carry the status */
+		cmd->state = status;
+	} else
+		cmd->term_exchg = 1;
+
+	list_add_tail(&cmd->cmd_list, &vha->hw->tgt.q_full_list);
+
+	vha->hw->tgt.num_qfull_cmds_alloc++;
+	if (vha->hw->tgt.num_qfull_cmds_alloc >
+		vha->hw->qla_stats.stat_max_qfull_cmds_alloc)
+		vha->hw->qla_stats.stat_max_qfull_cmds_alloc =
+			vha->hw->tgt.num_qfull_cmds_alloc;
+}
+
+int
+qlt_free_qfull_cmds(struct scsi_qla_host *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
+	struct qla_tgt_cmd *cmd, *tcmd;
+	struct list_head free_list;
+	int rc = 0;
+
+	if (list_empty(&ha->tgt.q_full_list))
+		return 0;
+
+	INIT_LIST_HEAD(&free_list);
+
+	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+
+	if (list_empty(&ha->tgt.q_full_list)) {
+		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+		return 0;
+	}
+
+	list_for_each_entry_safe(cmd, tcmd, &ha->tgt.q_full_list, cmd_list) {
+		if (cmd->q_full)
+			/* cmd->state is a borrowed field to hold status */
+			rc = __qlt_send_busy(vha, &cmd->atio, cmd->state);
+		else if (cmd->term_exchg)
+			rc = __qlt_send_term_exchange(vha, NULL, &cmd->atio);
+
+		if (rc == -ENOMEM)
+			break;
+
+		if (cmd->q_full)
+			ql_dbg(ql_dbg_io, vha, 0x3006,
+			    "%s: busy sent for ox_id[%04x]\n", __func__,
+			    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
+		else if (cmd->term_exchg)
+			ql_dbg(ql_dbg_io, vha, 0x3007,
+			    "%s: Term exchg sent for ox_id[%04x]\n", __func__,
+			    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
+		else
+			ql_dbg(ql_dbg_io, vha, 0x3008,
+			    "%s: Unexpected cmd in QFull list %p\n", __func__,
+			    cmd);
+
+		list_del(&cmd->cmd_list);
+		list_add_tail(&cmd->cmd_list, &free_list);
+
+		/* piggy back on hardware_lock for protection */
+		vha->hw->tgt.num_qfull_cmds_alloc--;
+	}
+	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+
+	cmd = NULL;
+
+	list_for_each_entry_safe(cmd, tcmd, &free_list, cmd_list) {
+		list_del(&cmd->cmd_list);
+		/* This cmd was never sent to TCM.  There is no need
+		 * to schedule free or call free_cmd
+		 */
+		qlt_free_cmd(cmd);
+	}
+	return rc;
+}
+
+static void
+qlt_send_busy(struct scsi_qla_host *vha,
+	struct atio_from_isp *atio, uint16_t status)
+{
+	int rc = 0;
+
+	rc = __qlt_send_busy(vha, atio, status);
+	if (rc == -ENOMEM)
+		qlt_alloc_qfull_cmd(vha, atio, status, 1);
+}
+
+static int
+qlt_chk_qfull_thresh_hold(struct scsi_qla_host *vha,
+	struct atio_from_isp *atio)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t status;
+
+	if (ha->tgt.num_pend_cmds < Q_FULL_THRESH_HOLD(ha))
+		return 0;
+
+	status = temp_sam_status;
+	qlt_send_busy(vha, atio, status);
+	return 1;
 }
 
 /* ha->hardware_lock supposed to be held on entry */
@@ -4266,10 +4532,19 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 			qlt_send_busy(vha, atio, SAM_STAT_TASK_SET_FULL);
 			break;
 		}
-		if (likely(atio->u.isp24.fcp_cmnd.task_mgmt_flags == 0))
+
+
+
+		if (likely(atio->u.isp24.fcp_cmnd.task_mgmt_flags == 0)) {
+			rc = qlt_chk_qfull_thresh_hold(vha, atio);
+			if (rc != 0) {
+				tgt->irq_cmd_count--;
+				return;
+			}
 			rc = qlt_handle_cmd_for_atio(vha, atio);
-		else
+		} else {
 			rc = qlt_handle_task_mgmt(vha, atio);
+		}
 		if (unlikely(rc != 0)) {
 			if (rc == -ESRCH) {
 #if 1 /* With TERM EXCHANGE some FC cards refuse to boot */
@@ -4364,6 +4639,12 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 			break;
 		}
 
+		rc = qlt_chk_qfull_thresh_hold(vha, atio);
+		if (rc != 0) {
+			tgt->irq_cmd_count--;
+			return;
+		}
+
 		rc = qlt_handle_cmd_for_atio(vha, atio);
 		if (unlikely(rc != 0)) {
 			if (rc == -ESRCH) {
@@ -4901,6 +5182,10 @@ int qlt_remove_target(struct qla_hw_data *ha, struct scsi_qla_host *vha)
 		qlt_release(vha->vha_tgt.qla_tgt);
 		return 0;
 	}
+
+	/* free left over qfull cmds */
+	qlt_init_term_exchange(vha);
+
 	mutex_lock(&qla_tgt_mutex);
 	list_del(&vha->vha_tgt.qla_tgt->tgt_list_entry);
 	mutex_unlock(&qla_tgt_mutex);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 20e42bd..0c768f5 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -915,6 +915,8 @@ struct qla_tgt_cmd {
 	unsigned int aborted:1; /* Needed in case of SRR */
 	unsigned int write_data_transferred:1;
 	unsigned int ctx_dsd_alloced:1;
+	unsigned int q_full:1;
+	unsigned int term_exchg:1;
 
 	struct scatterlist *sg;	/* cmd data buffer SG vector */
 	int sg_cnt;		/* SG segments count */
@@ -928,6 +930,7 @@ struct qla_tgt_cmd {
 	uint16_t loop_id;	/* to save extra sess dereferences */
 	struct qla_tgt *tgt;	/* to save extra sess dereferences */
 	struct scsi_qla_host *vha;
+	struct list_head cmd_list;
 
 	struct atio_from_isp atio;
 	/* t10dif */
@@ -1091,5 +1094,6 @@ extern int qlt_stop_phase1(struct qla_tgt *);
 extern void qlt_stop_phase2(struct qla_tgt *);
 extern irqreturn_t qla83xx_msix_atio_q(int, void *);
 extern void qlt_83xx_iospace_config(struct qla_hw_data *);
+extern int qlt_free_qfull_cmds(struct scsi_qla_host *);
 
 #endif /* __QLA_TARGET_H */
-- 
1.7.7
