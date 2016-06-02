From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/14] lpfc: remove unused 'pring' argument
Date: Thu,  2 Jun 2016 16:39:04 +0200
Message-ID: <1464878356-42407-3-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161067AbcFBOj0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:26 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

---
 drivers/scsi/lpfc/lpfc_sli.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 70edf21..5e38a35 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2657,7 +2657,6 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 /**
  * lpfc_sli_iocbq_lookup - Find command iocb for the given response iocb
  * @phba: Pointer to HBA context object.
- * @pring: Pointer to driver SLI ring object.
  * @prspiocb: Pointer to response iocb object.
  *
  * This function looks up the iocb_lookup table to get the command iocb
@@ -2668,7 +2667,6 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
  **/
 static struct lpfc_iocbq *
 lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
-		      struct lpfc_sli_ring *pring,
 		      struct lpfc_iocbq *prspiocb)
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
@@ -2697,7 +2695,6 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 /**
  * lpfc_sli_iocbq_lookup_by_tag - Find command iocb for the iotag
  * @phba: Pointer to HBA context object.
- * @pring: Pointer to driver SLI ring object.
  * @iotag: IOCB tag.
  *
  * This function looks up the iocb_lookup table to get the command iocb
@@ -2708,7 +2705,7 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
  **/
 static struct lpfc_iocbq *
 lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
-			     struct lpfc_sli_ring *pring, uint16_t iotag)
+			     uint16_t iotag)
 {
 	struct lpfc_iocbq *cmd_iocb;
 
@@ -2755,7 +2752,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	/* Based on the iotag field, get the cmd IOCB from the txcmplq */
 	spin_lock_irqsave(&phba->hbalock, iflag);
-	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
+	cmdiocbp = lpfc_sli_iocbq_lookup(phba, saveq);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 
 	if (cmdiocbp) {
@@ -3088,8 +3085,7 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				break;
 			}
 
-			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
-							 &rspiocbq);
+			cmdiocbq = lpfc_sli_iocbq_lookup(phba, &rspiocbq);
 			if (unlikely(!cmdiocbq))
 				break;
 			if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED)
@@ -3284,8 +3280,7 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		case LPFC_ABORT_IOCB:
 			cmdiocbp = NULL;
 			if (irsp->ulpCommand != CMD_XRI_ABORTED_CX)
-				cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring,
-								 saveq);
+				cmdiocbp = lpfc_sli_iocbq_lookup(phba, saveq);
 			if (cmdiocbp) {
 				/* Call the specified completion routine */
 				if (cmdiocbp->iocb_cmpl) {
@@ -11711,7 +11706,7 @@ lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
 	/* Look up the ELS command IOCB and create pseudo response IOCB */
-	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
+	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
 	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
@@ -12302,7 +12297,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	/* Look up the FCP command IOCB and create pseudo response IOCB */
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
-	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
+	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
 	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	if (unlikely(!cmdiocbq)) {
-- 
1.8.5.6

