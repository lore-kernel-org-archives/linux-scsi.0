From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 08/11] qla2xxx: terminate exchange when command is aborted by LIO
Date: Thu, 25 Jun 2015 12:33:48 -0400
Message-ID: <1435250031-20525-9-git-send-email-himanshu.madhani@qlogic.com>
References: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:29274 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbbFYRSJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2015 13:18:09 -0400
In-Reply-To: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Alexei Potashnik <alexei@purestorage.com>

The newly introduced aborted_task TFO callback has to terminate
exchange with QLogic driver, since command is being deleted and
no status will be queued to the driver at a later point.

This patch also moves the burden of releasing one cmd refcount to
the aborted_task handler.

Changed iSCSI aborted_task logic to satisfy the above requirement.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Acked-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c  |   34 ++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_target.h  |    9 +--------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   11 +----------
 3 files changed, 18 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ed9fdd7..2832253 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1924,21 +1924,6 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 	struct qla_hw_data *ha = vha->hw;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 
-	if (unlikely(cmd->aborted)) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
-		    "qla_target(%d): terminating exchange "
-		    "for aborted cmd=%p (se_cmd=%p, tag=%d)", vha->vp_idx, cmd,
-		    se_cmd, cmd->tag);
-
-		cmd->state = QLA_TGT_STATE_ABORTED;
-		cmd->cmd_flags |= BIT_6;
-
-		qlt_send_term_exchange(vha, cmd, &cmd->atio, 0);
-
-		/* !! At this point cmd could be already freed !! */
-		return QLA_TGT_PRE_XMIT_RESP_CMD_ABORTED;
-	}
-
 	prm->cmd = cmd;
 	prm->tgt = tgt;
 	prm->rq_result = scsi_status;
@@ -2526,9 +2511,6 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	res = qlt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status,
 	    &full_req_cnt);
 	if (unlikely(res != 0)) {
-		if (res == QLA_TGT_PRE_XMIT_RESP_CMD_ABORTED)
-			return 0;
-
 		return res;
 	}
 
@@ -3100,6 +3082,22 @@ static void qlt_chk_exch_leak_thresh_hold(struct scsi_qla_host *vha)
 
 }
 
+void qlt_abort_cmd(struct qla_tgt_cmd *cmd)
+{
+	struct qla_tgt *tgt = cmd->tgt;
+	struct scsi_qla_host *vha = tgt->vha;
+
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
+	    "qla_target(%d): terminating exchange for aborted cmd=%p "
+	    "(se_cmd=%p, tag=%d)", vha->vp_idx, cmd, &cmd->se_cmd, cmd->tag);
+
+	cmd->state = QLA_TGT_STATE_ABORTED;
+	cmd->cmd_flags |= BIT_6;
+
+	qlt_send_term_exchange(vha, cmd, &cmd->atio, 0);
+}
+EXPORT_SYMBOL(qlt_abort_cmd);
+
 void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 {
 	struct qla_tgt_sess *sess = cmd->sess;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index e521fbad..abcaefa 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -808,13 +808,6 @@ int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
 #define	FC_TM_REJECT                4
 #define FC_TM_FAILED                5
 
-/*
- * Error code of qlt_pre_xmit_response() meaning that cmd's exchange was
- * terminated, so no more actions is needed and success should be returned
- * to target.
- */
-#define QLA_TGT_PRE_XMIT_RESP_CMD_ABORTED	0x1717
-
 #if (BITS_PER_LONG > 32) || defined(CONFIG_HIGHMEM64G)
 #define pci_dma_lo32(a) (a & 0xffffffff)
 #define pci_dma_hi32(a) ((((a) >> 16)>>16) & 0xffffffff)
@@ -950,7 +943,6 @@ struct qla_tgt_cmd {
 	unsigned int conf_compl_supported:1;
 	unsigned int sg_mapped:1;
 	unsigned int free_sg:1;
-	unsigned int aborted:1; /* Needed in case of SRR */
 	unsigned int write_data_transferred:1;
 	unsigned int ctx_dsd_alloced:1;
 	unsigned int q_full:1;
@@ -1135,6 +1127,7 @@ static inline uint32_t sid_to_key(const uint8_t *s_id)
 extern void qlt_response_pkt_all_vps(struct scsi_qla_host *, response_t *);
 extern int qlt_rdy_to_xfer(struct qla_tgt_cmd *);
 extern int qlt_xmit_response(struct qla_tgt_cmd *, int, uint8_t);
+extern void qlt_abort_cmd(struct qla_tgt_cmd *);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7bf3043..b2baaa1 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -673,7 +673,6 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	cmd->cmd_flags |= BIT_4;
 	cmd->bufflen = se_cmd->data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
-	cmd->aborted = (se_cmd->transport_state & CMD_T_ABORTED);
 
 	cmd->sg_cnt = se_cmd->t_data_nents;
 	cmd->sg = se_cmd->t_data_sg;
@@ -702,7 +701,6 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 	cmd->sg_cnt = 0;
 	cmd->offset = 0;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
-	cmd->aborted = (se_cmd->transport_state & CMD_T_ABORTED);
 	if (cmd->cmd_flags &  BIT_5) {
 		pr_crit("Bit_5 already set for cmd = %p.\n", cmd);
 		dump_stack();
@@ -767,14 +765,7 @@ static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
-	struct scsi_qla_host *vha = cmd->vha;
-	struct qla_hw_data *ha = vha->hw;
-
-	if (!cmd->sg_mapped)
-		return;
-
-	pci_unmap_sg(ha->pdev, cmd->sg, cmd->sg_cnt, cmd->dma_data_direction);
-	cmd->sg_mapped = 0;
+	qlt_abort_cmd(cmd);
 }
 
 static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *,
-- 
1.7.7

