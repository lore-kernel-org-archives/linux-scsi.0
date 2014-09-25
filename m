From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 16/17] qla2xxx: Add flags for tracing the target commands.
Date: Thu, 25 Sep 2014 06:14:58 -0400
Message-ID: <1411640099-7856-17-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:46434 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbaIYKtD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 06:49:03 -0400
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c  |   30 ++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_target.h  |   24 ++++++++++++++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   24 ++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2ba4433..f3287e1 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1723,6 +1723,7 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 		    se_cmd, cmd->tag);
 
 		cmd->state = QLA_TGT_STATE_ABORTED;
+		cmd->cmd_flags |= BIT_6;
 
 		qlt_send_term_exchange(vha, cmd, &cmd->atio, 0);
 
@@ -2789,10 +2790,13 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 	    __func__, &cmd->se_cmd,
 	    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
 
+	BUG_ON(cmd->cmd_in_wq);
+
 	if (!cmd->q_full)
 		qlt_decr_num_pend_cmds(cmd->vha);
 
 	BUG_ON(cmd->sg_mapped);
+	cmd->jiffies_at_free = get_jiffies_64();
 	if (unlikely(cmd->free_sg))
 		kfree(cmd->sg);
 
@@ -2800,6 +2804,7 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 		WARN_ON(1);
 		return;
 	}
+	cmd->jiffies_at_free = get_jiffies_64();
 	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 }
 EXPORT_SYMBOL(qlt_free_cmd);
@@ -2813,6 +2818,7 @@ static int qlt_prepare_srr_ctio(struct scsi_qla_host *vha,
 	struct qla_tgt_srr_imm *imm;
 
 	tgt->ctio_srr_id++;
+	cmd->cmd_flags |= BIT_15;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf019,
 	    "qla_target(%d): CTIO with SRR status received\n", vha->vp_idx);
@@ -2998,6 +3004,7 @@ qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 		dump_stack();
 	}
 
+	cmd->cmd_flags |= BIT_12;
 	ha->tgt.tgt_ops->free_cmd(cmd);
 }
 
@@ -3152,6 +3159,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		 */
 		if ((cmd->state != QLA_TGT_STATE_NEED_DATA) &&
 		    (cmd->state != QLA_TGT_STATE_ABORTED)) {
+			cmd->cmd_flags |= BIT_13;
 			if (qlt_term_ctio_exchange(vha, ctio, cmd, status))
 				return;
 		}
@@ -3240,6 +3248,8 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	uint32_t data_length;
 	int ret, fcp_task_attr, data_dir, bidi = 0;
 
+	cmd->cmd_in_wq = 0;
+	cmd->cmd_flags |= BIT_1;
 	if (tgt->tgt_stop)
 		goto out_term;
 
@@ -3283,6 +3293,7 @@ out_term:
 	 * cmd has not sent to target yet, so pass NULL as the second
 	 * argument to qlt_send_term_exchange() and free the memory here.
 	 */
+	cmd->cmd_flags |= BIT_2;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1);
 
@@ -3430,8 +3441,13 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 		return -ENOMEM;
 	}
 
+	cmd->cmd_flags = 0;
+	cmd->jiffies_at_alloc = get_jiffies_64();
+
 	cmd->reset_count = vha->hw->chip_reset;
 
+	cmd->cmd_in_wq = 1;
+	cmd->cmd_flags |= BIT_0;
 	INIT_WORK(&cmd->work, qlt_do_work);
 	queue_work(qla_tgt_wq, &cmd->work);
 	return 0;
@@ -3893,8 +3909,10 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 			qlt_send_notify_ack(vha, ntfy,
 			    0, 0, 0, NOTIFY_ACK_SRR_FLAGS_ACCEPT, 0, 0);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			if (xmit_type & QLA_TGT_XMIT_DATA)
+			if (xmit_type & QLA_TGT_XMIT_DATA) {
+				cmd->cmd_flags |= BIT_8;
 				qlt_rdy_to_xfer(cmd);
+			}
 		} else {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf066,
 			    "qla_target(%d): SRR for out data for cmd "
@@ -3912,8 +3930,10 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 	}
 
 	/* Transmit response in case of status and data-in cases */
-	if (resp)
+	if (resp) {
+		cmd->cmd_flags |= BIT_7;
 		qlt_xmit_response(cmd, xmit_type, se_cmd->scsi_status);
+	}
 
 	return;
 
@@ -3926,8 +3946,10 @@ out_reject:
 	if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
 		cmd->state = QLA_TGT_STATE_DATA_IN;
 		dump_stack();
-	} else
+	} else {
+		cmd->cmd_flags |= BIT_9;
 		qlt_send_term_exchange(vha, cmd, &cmd->atio, 1);
+	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
@@ -4041,7 +4063,7 @@ static void qlt_prepare_srr_imm(struct scsi_qla_host *vha,
 
 	tgt->imm_srr_id++;
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02d, "qla_target(%d): SRR received\n",
+	ql_log(ql_log_warn, vha, 0xf02d, "qla_target(%d): SRR received\n",
 	    vha->vp_idx);
 
 	imm = kzalloc(sizeof(*imm), GFP_ATOMIC);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index b07b230..8ff330f 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -918,6 +918,7 @@ struct qla_tgt_cmd {
 	unsigned int q_full:1;
 	unsigned int term_exchg:1;
 	unsigned int cmd_sent_to_fw:1;
+	unsigned int cmd_in_wq:1;
 
 	struct scatterlist *sg;	/* cmd data buffer SG vector */
 	int sg_cnt;		/* SG segments count */
@@ -940,6 +941,29 @@ struct qla_tgt_cmd {
 	uint32_t blk_sz;
 	struct crc_context *ctx;
 
+	uint64_t jiffies_at_alloc;
+	uint64_t jiffies_at_free;
+	/* BIT_0 - Atio Arrival / schedule to work
+	 * BIT_1 - qlt_do_work
+	 * BIT_2 - qlt_do work failed
+	 * BIT_3 - xfer rdy/tcm_qla2xxx_write_pending
+	 * BIT_4 - read respond/tcm_qla2xx_queue_data_in
+	 * BIT_5 - status respond / tcm_qla2xx_queue_status
+	 * BIT_6 - tcm request to abort/Term exchange.
+	 *	pre_xmit_response->qlt_send_term_exchange
+	 * BIT_7 - SRR received (qlt_handle_srr->qlt_xmit_response)
+	 * BIT_8 - SRR received (qlt_handle_srr->qlt_rdy_to_xfer)
+	 * BIT_9 - SRR received (qla_handle_srr->qlt_send_term_exchange)
+	 * BIT_10 - Data in - hanlde_data->tcm_qla2xxx_handle_data
+	 * BIT_11 - Data actually going to TCM : tcm_qla2xx_handle_data_work
+	 * BIT_12 - good completion - qlt_ctio_do_completion -->free_cmd
+	 * BIT_13 - Bad completion -
+	 *	qlt_ctio_do_completion --> qlt_term_ctio_exchange
+	 * BIT_14 - Back end data received/sent.
+	 * BIT_15 - SRR prepare ctio
+	 * BIT_16 - complete free
+	 */
+	uint32_t cmd_flags;
 };
 
 struct qla_tgt_sess_work_param {
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 9f95407..031b296 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -390,6 +390,11 @@ static void tcm_qla2xxx_complete_free(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
 
+	cmd->cmd_in_wq = 0;
+
+	WARN_ON(cmd->cmd_flags &  BIT_16);
+
+	cmd->cmd_flags |= BIT_16;
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
@@ -400,6 +405,7 @@ static void tcm_qla2xxx_complete_free(struct work_struct *work)
  */
 static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
 {
+	cmd->cmd_in_wq = 1;
 	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
 	queue_work(tcm_qla2xxx_free_wq, &cmd->work);
 }
@@ -409,6 +415,13 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
  */
 static int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
 {
+	struct qla_tgt_cmd *cmd;
+
+	if ((se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) == 0) {
+		cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+		cmd->cmd_flags |= BIT_14;
+	}
+
 	return target_put_sess_cmd(se_cmd->se_sess, se_cmd);
 }
 
@@ -571,6 +584,8 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 	 * Ensure that the complete FCP WRITE payload has been received.
 	 * Otherwise return an exception via CHECK_CONDITION status.
 	 */
+	cmd->cmd_in_wq = 0;
+	cmd->cmd_flags |= BIT_11;
 	if (!cmd->write_data_transferred) {
 		/*
 		 * Check if se_cmd has already been aborted via LUN_RESET, and
@@ -599,6 +614,8 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
  */
 static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 {
+	cmd->cmd_flags |= BIT_10;
+	cmd->cmd_in_wq = 1;
 	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
 	queue_work(tcm_qla2xxx_free_wq, &cmd->work);
 }
@@ -642,6 +659,7 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
 
+	cmd->cmd_flags |= BIT_4;
 	cmd->bufflen = se_cmd->data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 	cmd->aborted = (se_cmd->transport_state & CMD_T_ABORTED);
@@ -649,6 +667,7 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	cmd->sg_cnt = se_cmd->t_data_nents;
 	cmd->sg = se_cmd->t_data_sg;
 	cmd->offset = 0;
+	cmd->cmd_flags |= BIT_3;
 
 	cmd->prot_sg_cnt = se_cmd->t_prot_nents;
 	cmd->prot_sg = se_cmd->t_prot_sg;
@@ -674,6 +693,11 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 	cmd->offset = 0;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 	cmd->aborted = (se_cmd->transport_state & CMD_T_ABORTED);
+	if (cmd->cmd_flags &  BIT_5) {
+		pr_crit("Bit_5 already set for cmd = %p.\n", cmd);
+		dump_stack();
+	}
+	cmd->cmd_flags |= BIT_5;
 
 	if (se_cmd->data_direction == DMA_FROM_DEVICE) {
 		/*
-- 
1.7.7

