From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 5/9] qla2xxx: adjust debug flags
Date: Wed, 10 Jun 2015 11:05:21 -0400
Message-ID: <1433948725-4073-6-git-send-email-himanshu.madhani@qlogic.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:54598 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965987AbbFJPtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 11:49:11 -0400
In-Reply-To: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Adjust debug flag to match debug comment.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c  |    7 ++++---
 drivers/scsi/qla2xxx/qla_target.h  |    3 +++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    3 +--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 75eb042..2477602 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3015,7 +3015,7 @@ qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 		dump_stack();
 	}
 
-	cmd->cmd_flags |= BIT_12;
+	cmd->cmd_flags |= BIT_17;
 	ha->tgt.tgt_ops->free_cmd(cmd);
 }
 
@@ -3177,7 +3177,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 skip_term:
 
 	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
-		;
+		cmd->cmd_flags |= BIT_12;
 	} else if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
 		int rx_status = 0;
 
@@ -3191,9 +3191,11 @@ skip_term:
 		ha->tgt.tgt_ops->handle_data(cmd);
 		return;
 	} else if (cmd->state == QLA_TGT_STATE_ABORTED) {
+		cmd->cmd_flags |= BIT_18;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01e,
 		    "Aborted command %p (tag %d) finished\n", cmd, cmd->tag);
 	} else {
+		cmd->cmd_flags |= BIT_19;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05c,
 		    "qla_target(%d): A command in state (%d) should "
 		    "not return a CTIO complete\n", vha->vp_idx, cmd->state);
@@ -3205,7 +3207,6 @@ skip_term:
 		dump_stack();
 	}
 
-
 	ha->tgt.tgt_ops->free_cmd(cmd);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 3320867..462edbc 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -962,6 +962,9 @@ struct qla_tgt_cmd {
 	 * BIT_14 - Back end data received/sent.
 	 * BIT_15 - SRR prepare ctio
 	 * BIT_16 - complete free
+	 * BIT_17 - flush - qlt_abort_cmd_on_host_reset
+	 * BIT_18 - completion w/abort status
+	 * BIT_19 - completion w/unknown status
 	 */
 	uint32_t cmd_flags;
 };
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 5c9e680..e9893e7 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -489,7 +489,7 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
-
+	cmd->cmd_flags |= BIT_3;
 	cmd->bufflen = se_cmd->data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
@@ -674,7 +674,6 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	cmd->sg_cnt = se_cmd->t_data_nents;
 	cmd->sg = se_cmd->t_data_sg;
 	cmd->offset = 0;
-	cmd->cmd_flags |= BIT_3;
 
 	cmd->prot_sg_cnt = se_cmd->t_prot_nents;
 	cmd->prot_sg = se_cmd->t_prot_sg;
-- 
1.7.7

