From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/8] lpfc 8.3.43: Fix crash after xri limit is reached.
Date: Thu, 10 Oct 2013 12:19:53 -0400
Message-ID: <1381421993.20248.11.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5409 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab3JJQTz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 12:19:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix crash after xri limit is reached.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   19 ++++++++++++-------
 lpfc_sli4.h |    1 +
 2 files changed, 13 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-10-09 10:39:20.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-10-09 17:25:23.297650407 -0400
@@ -1012,20 +1012,25 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 			break;
 		}
 
-		/* Allocate iotag for psb->cur_iocbq. */
-		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
-		if (iotag == 0) {
+
+		lxri = lpfc_sli4_next_xritag(phba);
+		if (lxri == NO_XRI) {
 			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
-				psb->data, psb->dma_handle);
+			      psb->data, psb->dma_handle);
 			kfree(psb);
 			break;
 		}
 
-		lxri = lpfc_sli4_next_xritag(phba);
-		if (lxri == NO_XRI) {
+		/* Allocate iotag for psb->cur_iocbq. */
+		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
+		if (iotag == 0) {
 			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
-			      psb->data, psb->dma_handle);
+				psb->data, psb->dma_handle);
 			kfree(psb);
+			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
+					"3368 Failed to allocated IOTAG for"
+					" XRI:0x%x\n", lxri);
+			lpfc_sli4_free_xri(phba, lxri);
 			break;
 		}
 		psb->cur_iocbq.sli4_lxritag = lxri;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2013-10-09 10:39:20.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2013-10-09 17:25:23.298650407 -0400
@@ -673,6 +673,7 @@ void lpfc_sli4_queue_unset(struct lpfc_h
 int lpfc_sli4_post_sgl(struct lpfc_hba *, dma_addr_t, dma_addr_t, uint16_t);
 int lpfc_sli4_repost_scsi_sgl_list(struct lpfc_hba *);
 uint16_t lpfc_sli4_next_xritag(struct lpfc_hba *);
+void lpfc_sli4_free_xri(struct lpfc_hba *, int);
 int lpfc_sli4_post_async_mbox(struct lpfc_hba *);
 int lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *, struct list_head *, int);
 struct lpfc_cq_event *__lpfc_sli4_cq_event_alloc(struct lpfc_hba *);



