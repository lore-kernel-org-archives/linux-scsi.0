From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 10/19] qla2xxx: Handle chip reset in target mode.
Date: Thu, 25 Sep 2014 04:10:03 -0400
Message-ID: <1411632612-7320-11-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

A chip reset can occur after driver submits command to the stack. Abort
command processing if a chip reset has occurred or in progress when you
get a follow up for a command.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |    1 +
 drivers/scsi/qla2xxx/qla_gbl.h    |    1 +
 drivers/scsi/qla2xxx/qla_init.c   |    4 ++
 drivers/scsi/qla2xxx/qla_iocb.c   |   11 +++++++
 drivers/scsi/qla2xxx/qla_target.c |   56 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.h |    2 +
 6 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 509dbd5..c9fe4cf 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3446,6 +3446,7 @@ struct qla_hw_data {
 	struct work_struct board_disable;
 
 	struct mr_data_fx00 mr;
+	uint32_t chip_reset;
 
 	struct qlt_hw_data tgt;
 	int	allow_cna_fw_dump;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 8257a27..13591de 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -72,6 +72,7 @@ extern void qla2x00_async_logout_done(struct scsi_qla_host *, fc_port_t *,
 extern void qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern void *qla2x00_alloc_iocbs(struct scsi_qla_host *, srb_t *);
+extern void *qla2x00_alloc_iocbs_ready(struct scsi_qla_host *, srb_t *);
 extern int qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *, fc_port_t *);
 
 extern fc_port_t *
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1d66f2f..a4dde7e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4575,6 +4575,10 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 		/* Requeue all commands in outstanding command list. */
 		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
 	}
+
+	ha->chip_reset++;
+	/* memory barrier */
+	wmb();
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c787847..f0edb07 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1858,6 +1858,17 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 }
 
 /* Generic Control-SRB manipulation functions. */
+
+/* hardware_lock assumed to be held. */
+void *
+qla2x00_alloc_iocbs_ready(scsi_qla_host_t *vha, srb_t *sp)
+{
+	if (qla2x00_reset_active(vha))
+		return NULL;
+
+	return qla2x00_alloc_iocbs(vha, sp);
+}
+
 void *
 qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 {
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index edd9d1b..25af5b7 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -101,6 +101,8 @@ static void qlt_send_term_exchange(struct scsi_qla_host *ha, struct qla_tgt_cmd
 	*cmd, struct atio_from_isp *atio, int ha_locked);
 static void qlt_reject_free_srr_imm(struct scsi_qla_host *ha,
 	struct qla_tgt_srr_imm *imm, int ha_lock);
+static void qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha,
+	struct qla_tgt_cmd *cmd);
 /*
  * Global Variables
  */
@@ -1031,7 +1033,7 @@ static void qlt_24xx_send_abts_resp(struct scsi_qla_host *vha,
 	if (qlt_issue_marker(vha, 1) != QLA_SUCCESS)
 		return;
 
-	resp = (struct abts_resp_to_24xx *)qla2x00_alloc_iocbs(vha, NULL);
+	resp = (struct abts_resp_to_24xx *)qla2x00_alloc_iocbs_ready(vha, NULL);
 	if (!resp) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe04a,
 		    "qla_target(%d): %s failed: unable to allocate "
@@ -1102,7 +1104,7 @@ static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
 	if (qlt_issue_marker(vha, 1) != QLA_SUCCESS)
 		return;
 
-	ctio = (struct ctio7_to_24xx *)qla2x00_alloc_iocbs(vha, NULL);
+	ctio = (struct ctio7_to_24xx *)qla2x00_alloc_iocbs_ready(vha, NULL);
 	if (ctio == NULL) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe04b,
 		    "qla_target(%d): %s failed: unable to allocate "
@@ -1321,6 +1323,21 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 	    mcmd, mcmd->fc_tm_rsp, mcmd->flags);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	if (qla2x00_reset_active(vha) || mcmd->reset_count != ha->chip_reset) {
+		/*
+		 * Either a chip reset is active or this request was from
+		 * previous life, just abort the processing.
+		 */
+		ql_dbg(ql_dbg_async, vha, 0xe100,
+			"RESET-TMR active/old-count/new-count = %d/%d/%d.\n",
+			qla2x00_reset_active(vha), mcmd->reset_count,
+			ha->chip_reset);
+		ha->tgt.tgt_ops->free_mcmd(mcmd);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		return;
+	}
+
 	if (mcmd->flags == QLA24XX_MGMT_SEND_NACK)
 		qlt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
 		    0, 0, 0, 0, 0, 0);
@@ -2264,6 +2281,21 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
+	if (qla2x00_reset_active(vha) || cmd->reset_count != ha->chip_reset) {
+		/*
+		 * Either a chip reset is active or this request was from
+		 * previous life, just abort the processing.
+		 */
+		cmd->state = QLA_TGT_STATE_PROCESSED;
+		qlt_abort_cmd_on_host_reset(cmd->vha, cmd);
+		ql_dbg(ql_dbg_async, vha, 0xe101,
+			"RESET-RSP active/old-count/new-count = %d/%d/%d.\n",
+			qla2x00_reset_active(vha), cmd->reset_count,
+			ha->chip_reset);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		return 0;
+	}
+
 	/* Does F/W have an IOCBs for this request */
 	res = qlt_check_reserve_free_req(vha, full_req_cnt);
 	if (unlikely(res))
@@ -2387,6 +2419,21 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
+	if (qla2x00_reset_active(vha) || cmd->reset_count != ha->chip_reset) {
+		/*
+		 * Either a chip reset is active or this request was from
+		 * previous life, just abort the processing.
+		 */
+		cmd->state = QLA_TGT_STATE_NEED_DATA;
+		qlt_abort_cmd_on_host_reset(cmd->vha, cmd);
+		ql_dbg(ql_dbg_async, vha, 0xe102,
+			"RESET-XFR active/old-count/new-count = %d/%d/%d.\n",
+			qla2x00_reset_active(vha), cmd->reset_count,
+			ha->chip_reset);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		return 0;
+	}
+
 	/* Does F/W have an IOCBs for this request */
 	res = qlt_check_reserve_free_req(vha, prm.req_cnt);
 	if (res != 0)
@@ -2572,7 +2619,7 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe01c, "Sending TERM EXCH CTIO (ha=%p)\n", ha);
 
-	pkt = (request_t *)qla2x00_alloc_iocbs(vha, NULL);
+	pkt = (request_t *)qla2x00_alloc_iocbs_ready(vha, NULL);
 	if (pkt == NULL) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe050,
 		    "qla_target(%d): %s failed: unable to allocate "
@@ -3300,6 +3347,8 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 		return -ENOMEM;
 	}
 
+	cmd->reset_count = vha->hw->chip_reset;
+
 	INIT_WORK(&cmd->work, qlt_do_work);
 	queue_work(qla_tgt_wq, &cmd->work);
 	return 0;
@@ -3333,6 +3382,7 @@ static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 	}
 	mcmd->tmr_func = fn;
 	mcmd->flags = flags;
+	mcmd->reset_count = vha->hw->chip_reset;
 
 	switch (fn) {
 	case QLA_TGT_CLEAR_ACA:
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index d1d24fb..20e42bd 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -923,6 +923,7 @@ struct qla_tgt_cmd {
 	uint32_t tag;
 	uint32_t unpacked_lun;
 	enum dma_data_direction dma_data_direction;
+	uint32_t reset_count;
 
 	uint16_t loop_id;	/* to save extra sess dereferences */
 	struct qla_tgt *tgt;	/* to save extra sess dereferences */
@@ -958,6 +959,7 @@ struct qla_tgt_mgmt_cmd {
 	struct se_cmd se_cmd;
 	struct work_struct free_work;
 	unsigned int flags;
+	uint32_t reset_count;
 #define QLA24XX_MGMT_SEND_NACK	1
 	union {
 		struct atio_from_isp atio;
-- 
1.7.7
