From: James Smart <james.smart@emulex.com>
Subject: [PATCH 18/19] lpfc 10.4.8000.0: Fix for handling unmapped ndlp in
 target reset handler
Date: Wed, 3 Sep 2014 12:58:16 -0400
Message-ID: <1409763496.12357.18.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:43876 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbaICQ6S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:58:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix for handling unmapped ndlp in target reset handler

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 8 +++++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0f6be85..b99399f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5339,7 +5339,13 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			"0722 Target Reset rport failure: rdata x%p\n", rdata);
-		return FAILED;
+		spin_lock_irq(shost->host_lock);
+		pnode->nlp_flag &= ~NLP_NPR_ADISC;
+		pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+		spin_unlock_irq(shost->host_lock);
+		lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+					  LPFC_CTX_TGT);
+		return FAST_IO_FAIL;
 	}
 
 	scsi_event.event_type = FC_REG_SCSI_EVENT;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cea89c6..207a43d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10132,7 +10132,9 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 			uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd cmd)
 {
 	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_scsi_buf *lpfc_cmd;
 	struct lpfc_iocbq *abtsiocbq;
+	struct lpfc_nodelist *ndlp;
 	struct lpfc_iocbq *iocbq;
 	IOCB_t *icmd;
 	int sum, i, ret_val;
@@ -10187,7 +10189,11 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		if (iocbq->iocb_flag & LPFC_IO_FOF)
 			abtsiocbq->iocb_flag |= LPFC_IO_FOF;
 
-		if (lpfc_is_link_up(phba))
+		lpfc_cmd = container_of(iocbq, struct lpfc_scsi_buf, cur_iocbq);
+		ndlp = lpfc_cmd->rdata->pnode;
+
+		if (lpfc_is_link_up(phba) &&
+		    (ndlp && ndlp->nlp_state == NLP_STE_MAPPED_NODE))
 			abtsiocbq->iocb.ulpCommand = CMD_ABORT_XRI_CN;
 		else
 			abtsiocbq->iocb.ulpCommand = CMD_CLOSE_XRI_CN;
-- 
1.7.11.7




