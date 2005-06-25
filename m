From: James.Smart@Emulex.Com
Subject: [PATCH 8 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:30 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F414D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45758 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261254AbVFYOec convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:32 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEYV9P008201
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:31 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add completion handler to the abort iocbs

Add completion handler to the abort iocbs to close a hole where we
could reuse an iotag.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_crtn.h |    3 ++
 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_scsi.c |    1 
 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_sli.c  |   14 ++++++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_scsi.c~abtfix drivers/scsi/lpfc/lpfc_scsi.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_scsi.c~abtfix	2005-06-25 09:42:26.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_scsi.c	2005-06-25 09:42:26.000000000 -0400
@@ -874,6 +874,7 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 		else
 			icmd->ulpCommand = CMD_CLOSE_XRI_CN;
 
+		abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 		if (lpfc_sli_issue_iocb(phba, pring, abtsiocb, 0) ==
 								IOCB_ERROR) {
 			list_add_tail(&abtsiocb->list, lpfc_iocb_list);
diff -puN drivers/scsi/lpfc/lpfc_crtn.h~abtfix drivers/scsi/lpfc/lpfc_crtn.h
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_crtn.h~abtfix	2005-06-25 09:42:26.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_crtn.h	2005-06-25 09:42:26.000000000 -0400
@@ -195,6 +195,9 @@ int lpfc_sli_issue_iocb_wait_high_priori
 void lpfc_sli_wake_iocb_high_priority(struct lpfc_hba * phba,
 				      struct lpfc_iocbq * queue1,
 				      struct lpfc_iocbq * queue2);
+void lpfc_sli_abort_fcp_cmpl(struct lpfc_hba * phba,
+			     struct lpfc_iocbq * cmdiocb,
+			     struct lpfc_iocbq * rspiocb);
 
 void *lpfc_mbuf_alloc(struct lpfc_hba *, int, dma_addr_t *);
 void lpfc_mbuf_free(struct lpfc_hba *, void *, dma_addr_t);
diff -puN drivers/scsi/lpfc/lpfc_sli.c~abtfix drivers/scsi/lpfc/lpfc_sli.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_sli.c~abtfix	2005-06-25 09:42:26.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_sli.c	2005-06-25 09:42:26.000000000 -0400
@@ -2077,8 +2077,6 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
 		switch (piocb->iocb.ulpCommand) {
 		case CMD_QUE_RING_BUF_CN:
 		case CMD_QUE_RING_BUF64_CN:
-		case CMD_CLOSE_XRI_CN:
-		case CMD_ABORT_XRI_CN:
 			/*
 			 * For IOCBs, like QUE_RING_BUF, that have no rsp ring
 			 * completion, iocb_cmpl MUST be 0.
@@ -2561,6 +2559,16 @@ lpfc_sli_sum_iocb(struct lpfc_hba *phba,
 	return sum;
 }
 
+void
+lpfc_sli_abort_fcp_cmpl(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
+			   struct lpfc_iocbq * rspiocb)
+{
+	spin_lock_irq(phba->host->host_lock);
+	list_add_tail(&cmdiocb->list, &phba->lpfc_iocb_list);
+	spin_unlock_irq(phba->host->host_lock);
+	return;
+}
+
 int
 lpfc_sli_abort_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    uint16_t tgt_id, uint64_t lun_id, uint32_t ctx,
@@ -2610,6 +2618,8 @@ lpfc_sli_abort_iocb(struct lpfc_hba *phb
 		else
 			abtsiocb->iocb.ulpCommand = CMD_CLOSE_XRI_CN;
 
+		/* Setup callback routine and issue the command. */
+		abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 		ret_val = lpfc_sli_issue_iocb(phba, pring, abtsiocb, 0);
 		if (ret_val == IOCB_ERROR) {
 			list_add_tail(&abtsiocb->list, lpfc_iocb_list);
_
