From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 03/11] qla2xxx: Make trace flags more readable.
Date: Fri, 23 Dec 2016 20:23:31 -0800
Message-ID: <1482553419-4117-4-git-send-email-himanshu.madhani@cavium.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

This patch does not change any functionality.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 27 +++++++++----------
 drivers/scsi/qla2xxx/qla_target.h  | 54 +++++++++++++++++---------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 35 ++++++++++++------------
 3 files changed, 54 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6e58848..c9e6a8b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3294,7 +3294,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 		return EIO;
 	}
 	cmd->aborted = 1;
-	cmd->cmd_flags |= BIT_6;
 	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
 	qlt_send_term_exchange(vha, cmd, &cmd->atio, 0, 1);
@@ -3342,7 +3341,7 @@ static int qlt_prepare_srr_ctio(struct scsi_qla_host *vha,
 	struct qla_tgt_srr_imm *imm;
 
 	tgt->ctio_srr_id++;
-	cmd->cmd_flags |= BIT_15;
+	cmd->trc_flags |= TRC_SRR_CTIO;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf019,
 	    "qla_target(%d): CTIO with SRR status received\n", vha->vp_idx);
@@ -3525,7 +3524,7 @@ static struct qla_tgt_cmd *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 		dump_stack();
 	}
 
-	cmd->cmd_flags |= BIT_17;
+	cmd->trc_flags |= TRC_FLUSH;
 	ha->tgt.tgt_ops->free_cmd(cmd);
 }
 
@@ -3691,7 +3690,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		 */
 		if ((cmd->state != QLA_TGT_STATE_NEED_DATA) &&
 		    (!cmd->aborted)) {
-			cmd->cmd_flags |= BIT_13;
+			cmd->trc_flags |= TRC_CTIO_ERR;
 			if (qlt_term_ctio_exchange(vha, ctio, cmd, status))
 				return;
 		}
@@ -3699,7 +3698,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 skip_term:
 
 	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
-		cmd->cmd_flags |= BIT_12;
+		cmd->trc_flags |= TRC_CTIO_DONE;
 	} else if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
 		cmd->state = QLA_TGT_STATE_DATA_IN;
 
@@ -3709,11 +3708,11 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		ha->tgt.tgt_ops->handle_data(cmd);
 		return;
 	} else if (cmd->aborted) {
-		cmd->cmd_flags |= BIT_18;
+		cmd->trc_flags |= TRC_CTIO_ABORTED;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01e,
 		  "Aborted command %p (tag %lld) finished\n", cmd, se_cmd->tag);
 	} else {
-		cmd->cmd_flags |= BIT_19;
+		cmd->trc_flags |= TRC_CTIO_STRANGE;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05c,
 		    "qla_target(%d): A command in state (%d) should "
 		    "not return a CTIO complete\n", vha->vp_idx, cmd->state);
@@ -3778,7 +3777,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	int ret, fcp_task_attr, data_dir, bidi = 0;
 
 	cmd->cmd_in_wq = 0;
-	cmd->cmd_flags |= BIT_1;
+	cmd->trc_flags |= TRC_DO_WORK;
 	if (tgt->tgt_stop)
 		goto out_term;
 
@@ -3830,7 +3829,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	 * cmd has not sent to target yet, so pass NULL as the second
 	 * argument to qlt_send_term_exchange() and free the memory here.
 	 */
-	cmd->cmd_flags |= BIT_2;
+	cmd->trc_flags |= TRC_DO_WORK_ERR;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1, 0);
 
@@ -3881,7 +3880,7 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	cmd->loop_id = sess->loop_id;
 	cmd->conf_compl_supported = sess->conf_compl_supported;
 
-	cmd->cmd_flags = 0;
+	cmd->trc_flags = 0;
 	cmd->jiffies_at_alloc = get_jiffies_64();
 
 	cmd->reset_count = vha->hw->chip_reset;
@@ -4017,7 +4016,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	}
 
 	cmd->cmd_in_wq = 1;
-	cmd->cmd_flags |= BIT_0;
+	cmd->trc_flags |= TRC_NEW_CMD;
 	cmd->se_cmd.cpuid = ha->msix_count ?
 		ha->tgt.rspq_vector_cpuid : WORK_CPU_UNBOUND;
 
@@ -4709,7 +4708,7 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 			    0, 0, 0, NOTIFY_ACK_SRR_FLAGS_ACCEPT, 0, 0);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			if (xmit_type & QLA_TGT_XMIT_DATA) {
-				cmd->cmd_flags |= BIT_8;
+				cmd->trc_flags |= TRC_SRR_XRDY;
 				qlt_rdy_to_xfer(cmd);
 			}
 		} else {
@@ -4728,7 +4727,7 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 
 	/* Transmit response in case of status and data-in cases */
 	if (resp) {
-		cmd->cmd_flags |= BIT_7;
+		cmd->trc_flags |= TRC_SRR_RSP;
 		qlt_xmit_response(cmd, xmit_type, se_cmd->scsi_status);
 	}
 
@@ -4744,7 +4743,7 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 		cmd->state = QLA_TGT_STATE_DATA_IN;
 		dump_stack();
 	} else {
-		cmd->cmd_flags |= BIT_9;
+		cmd->trc_flags |= TRC_SRR_TERM;
 		qlt_send_term_exchange(vha, cmd, &cmd->atio, 1, 0);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 14f2e24..f5fec62 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -965,35 +965,27 @@ struct qla_tgt_sess {
 	qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
 };
 
-typedef enum {
-	/*
-	 * BIT_0 - Atio Arrival / schedule to work
-	 * BIT_1 - qlt_do_work
-	 * BIT_2 - qlt_do work failed
-	 * BIT_3 - xfer rdy/tcm_qla2xxx_write_pending
-	 * BIT_4 - read respond/tcm_qla2xx_queue_data_in
-	 * BIT_5 - status respond / tcm_qla2xx_queue_status
-	 * BIT_6 - tcm request to abort/Term exchange.
-	 *	pre_xmit_response->qlt_send_term_exchange
-	 * BIT_7 - SRR received (qlt_handle_srr->qlt_xmit_response)
-	 * BIT_8 - SRR received (qlt_handle_srr->qlt_rdy_to_xfer)
-	 * BIT_9 - SRR received (qla_handle_srr->qlt_send_term_exchange)
-	 * BIT_10 - Data in - hanlde_data->tcm_qla2xxx_handle_data
-
-	 * BIT_12 - good completion - qlt_ctio_do_completion -->free_cmd
-	 * BIT_13 - Bad completion -
-	 *	qlt_ctio_do_completion --> qlt_term_ctio_exchange
-	 * BIT_14 - Back end data received/sent.
-	 * BIT_15 - SRR prepare ctio
-	 * BIT_16 - complete free
-	 * BIT_17 - flush - qlt_abort_cmd_on_host_reset
-	 * BIT_18 - completion w/abort status
-	 * BIT_19 - completion w/unknown status
-	 * BIT_20 - tcm_qla2xxx_free_cmd
-	 */
-	CMD_FLAG_DATA_WORK = BIT_11,
-	CMD_FLAG_DATA_WORK_FREE = BIT_21,
-} cmd_flags_t;
+enum trace_flags {
+	TRC_NEW_CMD = BIT_0,
+	TRC_DO_WORK = BIT_1,
+	TRC_DO_WORK_ERR = BIT_2,
+	TRC_XFR_RDY = BIT_3,
+	TRC_XMIT_DATA = BIT_4,
+	TRC_XMIT_STATUS = BIT_5,
+	TRC_SRR_RSP =  BIT_6,
+	TRC_SRR_XRDY = BIT_7,
+	TRC_SRR_TERM = BIT_8,
+	TRC_SRR_CTIO = BIT_9,
+	TRC_FLUSH = BIT_10,
+	TRC_CTIO_ERR = BIT_11,
+	TRC_CTIO_DONE = BIT_12,
+	TRC_CTIO_ABORTED =  BIT_13,
+	TRC_CTIO_STRANGE= BIT_14,
+	TRC_CMD_DONE = BIT_15,
+	TRC_CMD_CHK_STOP = BIT_16,
+	TRC_CMD_FREE = BIT_17,
+	TRC_DATA_IN = BIT_18,
+};
 
 struct qla_tgt_cmd {
 	struct se_cmd se_cmd;
@@ -1016,6 +1008,8 @@ struct qla_tgt_cmd {
 	unsigned int cmd_sent_to_fw:1;
 	unsigned int cmd_in_wq:1;
 	unsigned int aborted:1;
+	unsigned int data_work:1;
+	unsigned int data_work_free:1;
 
 	struct scatterlist *sg;	/* cmd data buffer SG vector */
 	int sg_cnt;		/* SG segments count */
@@ -1040,7 +1034,7 @@ struct qla_tgt_cmd {
 	uint64_t jiffies_at_alloc;
 	uint64_t jiffies_at_free;
 
-	cmd_flags_t cmd_flags;
+	enum trace_flags trc_flags;
 };
 
 struct qla_tgt_sess_work_param {
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 183a459..5f6223b3 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -282,10 +282,10 @@ static void tcm_qla2xxx_complete_free(struct work_struct *work)
 
 	cmd->cmd_in_wq = 0;
 
-	WARN_ON(cmd->cmd_flags &  BIT_16);
+	WARN_ON(cmd->trc_flags & TRC_CMD_FREE);
 
 	cmd->vha->tgt_counters.qla_core_ret_sta_ctio++;
-	cmd->cmd_flags |= BIT_16;
+	cmd->trc_flags |= TRC_CMD_FREE;
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
@@ -299,8 +299,8 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
 	cmd->vha->tgt_counters.core_qla_free_cmd++;
 	cmd->cmd_in_wq = 1;
 
-	BUG_ON(cmd->cmd_flags & BIT_20);
-	cmd->cmd_flags |= BIT_20;
+	BUG_ON(cmd->trc_flags & TRC_CMD_DONE);
+	cmd->trc_flags |= TRC_CMD_DONE;
 
 	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
 	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
@@ -315,7 +315,7 @@ static int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
 
 	if ((se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) == 0) {
 		cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
-		cmd->cmd_flags |= BIT_14;
+		cmd->trc_flags |= TRC_CMD_CHK_STOP;
 	}
 
 	return target_put_sess_cmd(se_cmd);
@@ -377,7 +377,7 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 			cmd->se_cmd.se_cmd_flags);
 		return 0;
 	}
-	cmd->cmd_flags |= BIT_3;
+	cmd->trc_flags |= TRC_XFR_RDY;
 	cmd->bufflen = se_cmd->data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
@@ -493,9 +493,9 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 	cmd->cmd_in_wq = 0;
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
-	cmd->cmd_flags |= CMD_FLAG_DATA_WORK;
+	cmd->data_work = 1;
 	if (cmd->aborted) {
-		cmd->cmd_flags |= CMD_FLAG_DATA_WORK_FREE;
+		cmd->data_work_free = 1;
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
 		tcm_qla2xxx_free_cmd(cmd);
@@ -532,7 +532,7 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
  */
 static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 {
-	cmd->cmd_flags |= BIT_10;
+	cmd->trc_flags |= TRC_DATA_IN;
 	cmd->cmd_in_wq = 1;
 	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
 	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
@@ -628,7 +628,7 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 		return 0;
 	}
 
-	cmd->cmd_flags |= BIT_4;
+	cmd->trc_flags |= TRC_XMIT_DATA;
 	cmd->bufflen = se_cmd->data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
@@ -659,11 +659,11 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 	cmd->sg_cnt = 0;
 	cmd->offset = 0;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
-	if (cmd->cmd_flags &  BIT_5) {
-		pr_crit("Bit_5 already set for cmd = %p.\n", cmd);
+	if (cmd->trc_flags & TRC_XMIT_STATUS) {
+		pr_crit("Multiple calls for status = %p.\n", cmd);
 		dump_stack();
 	}
-	cmd->cmd_flags |= BIT_5;
+	cmd->trc_flags |= TRC_XMIT_STATUS;
 
 	if (se_cmd->data_direction == DMA_FROM_DEVICE) {
 		/*
@@ -720,9 +720,8 @@ static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 }
 
 
-#define DATA_WORK_NOT_FREE(_flags) \
-	(( _flags & (CMD_FLAG_DATA_WORK|CMD_FLAG_DATA_WORK_FREE)) == \
-	 CMD_FLAG_DATA_WORK)
+#define DATA_WORK_NOT_FREE(_cmd) (_cmd->data_work && !_cmd->data_work_free)
+
 static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
@@ -735,9 +734,9 @@ static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if ((cmd->state == QLA_TGT_STATE_NEW)||
 		((cmd->state == QLA_TGT_STATE_DATA_IN) &&
-		 DATA_WORK_NOT_FREE(cmd->cmd_flags)) ) {
+		 DATA_WORK_NOT_FREE(cmd)) ) {
 
-		cmd->cmd_flags |= CMD_FLAG_DATA_WORK_FREE;
+		cmd->data_work_free = 1;
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/* Cmd have not reached firmware.
 		 * Use this trigger to free it. */
-- 
1.8.3.1
