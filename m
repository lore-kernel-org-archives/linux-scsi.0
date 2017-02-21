From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] lpfc: use bitflag for 'exch_busy'
Date: Tue, 21 Feb 2017 13:55:17 +0100
Message-ID: <1487681717-61116-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35355 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752100AbdBUMzW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 07:55:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Use a bitflag for 'exch_busy' and clear the TBD marker
in the driver.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 16 +++++++++-------
 drivers/scsi/lpfc/lpfc_nvme.h |  3 +--
 drivers/scsi/lpfc/lpfc_scsi.c | 19 +++++++++++--------
 drivers/scsi/lpfc/lpfc_scsi.h |  3 +--
 drivers/scsi/lpfc/lpfc_sli.c  |  5 ++++-
 5 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 625b658..da85850 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -872,9 +872,9 @@
 
 	/* pick up SLI4 exhange busy condition */
 	if (bf_get(lpfc_wcqe_c_xb, wcqe))
-		lpfc_ncmd->flags |= LPFC_SBUF_XBUSY;
+		set_bit(LPFC_SBUF_XBUSY, &lpfc_ncmd->flags);
 	else
-		lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
+		clear_bit(LPFC_SBUF_XBUSY, &lpfc_ncmd->flags);
 
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp))
 		atomic_dec(&ndlp->cmd_pending);
@@ -1821,10 +1821,12 @@
 						pdma_phys_sgl1, cur_xritag);
 				if (status) {
 					/* failure, put on abort nvme list */
-					lpfc_ncmd->exch_busy = 1;
+					set_bit(LPFC_SBUF_XBUSY,
+						&lpfc_ncmd->flags);
 				} else {
 					/* success, put on NVME buffer list */
-					lpfc_ncmd->exch_busy = 0;
+					clear_bit(LPFC_SBUF_XBUSY,
+						  &lpfc_ncmd->flags);
 					lpfc_ncmd->status = IOSTAT_SUCCESS;
 					num_posted++;
 				}
@@ -1854,10 +1856,10 @@
 					 struct lpfc_nvme_buf, list);
 			if (status) {
 				/* failure, put on abort nvme list */
-				lpfc_ncmd->exch_busy = 1;
+				set_bit(LPFC_SBUF_XBUSY, &lpfc_ncmd->flags);
 			} else {
 				/* success, put on NVME buffer list */
-				lpfc_ncmd->exch_busy = 0;
+				clear_bit(LPFC_SBUF_XBUSY, &lpfc_ncmd->flags);
 				lpfc_ncmd->status = IOSTAT_SUCCESS;
 				num_posted++;
 			}
@@ -2099,7 +2101,7 @@
 	unsigned long iflag = 0;
 
 	lpfc_ncmd->nonsg_phys = 0;
-	if (lpfc_ncmd->exch_busy) {
+	if (test_bit(LPFC_SBUF_XBUSY, &lpfc_ncmd->flags)) {
 		spin_lock_irqsave(&phba->sli4_hba.abts_nvme_buf_list_lock,
 					iflag);
 		lpfc_ncmd->nvmeCmd = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index b2fae5e..c230aaa 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -60,9 +60,8 @@ struct lpfc_nvme_buf {
 
 	uint32_t timeout;
 
-	uint16_t flags;  /* TBD convert exch_busy to flags */
+	unsigned long flags;
 #define LPFC_SBUF_XBUSY         0x1     /* SLI4 hba reported XB on WCQE cmpl */
-	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint16_t cpu;
 	uint16_t qidx;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 9d6384a..83462be 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -568,7 +568,7 @@ struct scsi_dif_tuple {
 		&phba->sli4_hba.lpfc_abts_scsi_buf_list, list) {
 		if (psb->cur_iocbq.sli4_xritag == xri) {
 			list_del(&psb->list);
-			psb->exch_busy = 0;
+			clear_bit(LPFC_SBUF_XBUSY, &psb->flags);
 			psb->status = IOSTAT_SUCCESS;
 			spin_unlock(
 				&phba->sli4_hba.abts_scsi_buf_list_lock);
@@ -600,7 +600,7 @@ struct scsi_dif_tuple {
 		if (iocbq->sli4_xritag != xri)
 			continue;
 		psb = container_of(iocbq, struct lpfc_scsi_buf, cur_iocbq);
-		psb->exch_busy = 0;
+		clear_bit(LPFC_SBUF_XBUSY, &psb->flags);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		if (!list_empty(&pring->txq))
 			lpfc_worker_wake_up(phba);
@@ -687,10 +687,10 @@ struct scsi_dif_tuple {
 						psb->cur_iocbq.sli4_xritag);
 				if (status) {
 					/* failure, put on abort scsi list */
-					psb->exch_busy = 1;
+					set_bit(LPFC_SBUF_XBUSY, &psb->flags);
 				} else {
 					/* success, put on SCSI buffer list */
-					psb->exch_busy = 0;
+					clear_bit(LPFC_SBUF_XBUSY, &psb->flags);
 					psb->status = IOSTAT_SUCCESS;
 					num_posted++;
 				}
@@ -720,10 +720,10 @@ struct scsi_dif_tuple {
 					 struct lpfc_scsi_buf, list);
 			if (status) {
 				/* failure, put on abort scsi list */
-				psb->exch_busy = 1;
+				set_bit(LPFC_SBUF_XBUSY, &psb->flags);
 			} else {
 				/* success, put on SCSI buffer list */
-				psb->exch_busy = 0;
+				clear_bit(LPFC_SBUF_XBUSY, &psb->flags);
 				psb->status = IOSTAT_SUCCESS;
 				num_posted++;
 			}
@@ -1100,7 +1100,7 @@ struct scsi_dif_tuple {
 	psb->nonsg_phys = 0;
 	psb->prot_seg_cnt = 0;
 
-	if (psb->exch_busy) {
+	if (test_bit(LPFC_SBUF_XBUSY, &psb->flags)) {
 		spin_lock_irqsave(&phba->sli4_hba.abts_scsi_buf_list_lock,
 					iflag);
 		psb->pCmd = NULL;
@@ -3942,7 +3942,10 @@ int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
 	/* pick up SLI4 exhange busy status from HBA */
-	lpfc_cmd->exch_busy = pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY;
+	if (pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY)
+		set_bit(LPFC_SBUF_XBUSY, &lpfc_cmd->flags);
+	else
+		clear_bit(LPFC_SBUF_XBUSY, &lpfc_cmd->flags);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (lpfc_cmd->prot_data_type) {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 5da7e15..6f56d16 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -137,9 +137,8 @@ struct lpfc_scsi_buf {
 
 	uint32_t timeout;
 
-	uint16_t flags;  /* TBD convert exch_busy to flags */
+	unsigned long flags;
 #define LPFC_SBUF_XBUSY         0x1     /* SLI4 hba reported XB on WCQE cmpl */
-	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint32_t result;	/* From IOCB Word 4. */
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3dbd027..29ad09f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11106,7 +11106,10 @@ struct lpfc_dmabuf *
 		!(cmdiocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		lpfc_cmd = container_of(cmdiocbq, struct lpfc_scsi_buf,
 			cur_iocbq);
-		lpfc_cmd->exch_busy = rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY;
+		if (rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY)
+			set_bit(LPFC_SBUF_XBUSY, &lpfc_cmd->flags);
+		else
+			clear_bit(LPFC_SBUF_XBUSY, &lpfc_cmd->flags);
 	}
 
 	pdone_q = cmdiocbq->context_un.wait_queue;
-- 
1.8.5.6
