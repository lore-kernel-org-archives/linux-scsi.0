From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/14] lpfc: use bitflag for exch_busy
Date: Thu,  2 Jun 2016 16:39:12 +0200
Message-ID: <1464878356-42407-11-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990AbcFBOjW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:22 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 19 +++++++++++--------
 drivers/scsi/lpfc/lpfc_scsi.h |  4 +++-
 drivers/scsi/lpfc/lpfc_sli.c  |  5 ++++-
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index fab387c..4354713 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -556,7 +556,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
 		&phba->sli4_hba.lpfc_abts_scsi_buf_list, list) {
 		if (psb->cur_iocbq.sli4_xritag == xri) {
 			list_del(&psb->list);
-			psb->exch_busy = 0;
+			clear_bit(LPFC_CMD_EXCH_BUSY, &psb->flags);
 			psb->status = IOSTAT_SUCCESS;
 			spin_unlock(
 				&phba->sli4_hba.abts_scsi_buf_list_lock);
@@ -588,7 +588,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
 		if (iocbq->sli4_xritag != xri)
 			continue;
 		psb = container_of(iocbq, struct lpfc_scsi_buf, cur_iocbq);
-		psb->exch_busy = 0;
+		clear_bit(LPFC_CMD_EXCH_BUSY, &psb->flags);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		if (!list_empty(&pring->txq))
 			lpfc_worker_wake_up(phba);
@@ -675,10 +675,12 @@ lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
 						psb->cur_iocbq.sli4_xritag);
 				if (status) {
 					/* failure, put on abort scsi list */
-					psb->exch_busy = 1;
+					set_bit(LPFC_CMD_EXCH_BUSY,
+						&psb->flags);
 				} else {
 					/* success, put on SCSI buffer list */
-					psb->exch_busy = 0;
+					clear_bit(LPFC_CMD_EXCH_BUSY,
+						  &psb->flags);
 					psb->status = IOSTAT_SUCCESS;
 					num_posted++;
 				}
@@ -708,10 +710,10 @@ lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
 					 struct lpfc_scsi_buf, list);
 			if (status) {
 				/* failure, put on abort scsi list */
-				psb->exch_busy = 1;
+				set_bit(LPFC_CMD_EXCH_BUSY, &psb->flags);
 			} else {
 				/* success, put on SCSI buffer list */
-				psb->exch_busy = 0;
+				clear_bit(LPFC_CMD_EXCH_BUSY, &psb->flags);
 				psb->status = IOSTAT_SUCCESS;
 				num_posted++;
 			}
@@ -1089,7 +1091,7 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 	psb->nonsg_phys = 0;
 	psb->prot_seg_cnt = 0;
 
-	if (psb->exch_busy) {
+	if (test_bit(LPFC_CMD_EXCH_BUSY, &psb->flags)) {
 		spin_lock_irqsave(&phba->sli4_hba.abts_scsi_buf_list_lock,
 					iflag);
 		psb->pCmd = NULL;
@@ -3923,7 +3925,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
 	/* pick up SLI4 exhange busy status from HBA */
-	lpfc_cmd->exch_busy = pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY;
+	if (pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY)
+		set_bit(LPFC_CMD_EXCH_BUSY, &lpfc_cmd->flags);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (lpfc_cmd->prot_data_type) {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 18b9260..a3658ce 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -134,7 +134,7 @@ struct lpfc_scsi_buf {
 
 	uint32_t timeout;
 
-	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
+	uint16_t xx_exch_busy;     /* SLI4 hba reported XB on complete WCQE */
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint32_t result;	/* From IOCB Word 4. */
 
@@ -143,6 +143,8 @@ struct lpfc_scsi_buf {
 				 * to dma_unmap_sg. */
 	uint32_t prot_seg_cnt;  /* seg_cnt's counterpart for protection data */
 
+	unsigned long flags;
+#define LPFC_CMD_EXCH_BUSY 1
 	dma_addr_t nonsg_phys;	/* Non scatter-gather physical address. */
 
 	/*
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5e38a35..52b1fa1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10442,7 +10442,10 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 		!(cmdiocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		lpfc_cmd = container_of(cmdiocbq, struct lpfc_scsi_buf,
 			cur_iocbq);
-		lpfc_cmd->exch_busy = rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY;
+		if (rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY)
+			set_bit(LPFC_CMD_EXCH_BUSY, &lpfc_cmd->flags);
+		else
+			clear_bit(LPFC_CMD_EXCH_BUSY, &lpfc_cmd->flags);
 	}
 
 	pdone_q = cmdiocbq->context_un.wait_queue;
-- 
1.8.5.6

