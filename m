From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/11] lpfc 10.2.8000.0: Fix locking for lpfc_hba_down_post
Date: Fri, 4 Apr 2014 13:51:34 -0400
Message-ID: <1396633894.1924.15.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:53470 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaDDRvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 13:51:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix locking for lpfc_hba_down_post


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   79 +++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 60 insertions(+), 19 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-03-31 16:21:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-04-03 10:24:20.116308496 -0400
@@ -820,29 +820,28 @@ lpfc_hba_down_prep(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_hba_down_post_s3 - Perform lpfc uninitialization after HBA reset
+ * lpfc_hba_free_post_buf - Perform lpfc uninitialization after HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
- * This routine will do uninitialization after the HBA is reset when bring
- * down the SLI Layer.
+ * This routine will cleanup posted ELS buffers after the HBA is reset
+ * when bringing down the SLI Layer.
+ *
  *
  * Return codes
- *   0 - success.
- *   Any other value - error.
+ *   void.
  **/
-static int
-lpfc_hba_down_post_s3(struct lpfc_hba *phba)
+static void
+lpfc_hba_free_post_buf(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *mp, *next_mp;
-	LIST_HEAD(completions);
-	int i;
 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
 		lpfc_sli_hbqbuf_free_all(phba);
 	else {
 		/* Cleanup preposted buffers on the ELS ring */
+		spin_lock_irq(&phba->hbalock);
 		pring = &psli->ring[LPFC_ELS_RING];
 		list_for_each_entry_safe(mp, next_mp, &pring->postbufq, list) {
 			list_del(&mp->list);
@@ -850,27 +849,70 @@ lpfc_hba_down_post_s3(struct lpfc_hba *p
 			lpfc_mbuf_free(phba, mp->virt, mp->phys);
 			kfree(mp);
 		}
+		spin_unlock_irq(&phba->hbalock);
 	}
+}
+
+/**
+ * lpfc_hba_clean_txcmplq - Perform lpfc uninitialization after HBA reset
+ * @phba: pointer to lpfc HBA data structure.
+ *
+ * This routine will cleanup the txcmplq after the HBA is reset when bringing
+ * down the SLI Layer.
+ *
+ * Return codes
+ *   void
+ **/
+static void
+lpfc_hba_clean_txcmplq(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring;
+	LIST_HEAD(completions);
+	int i;
+
+
 
-	spin_lock_irq(&phba->hbalock);
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
-
+		if (phba->sli_rev >= LPFC_SLI_REV4)
+			spin_lock_irq(&pring->ring_lock);
+		else
+			spin_lock_irq(&phba->hbalock);
 		/* At this point in time the HBA is either reset or DOA. Either
 		 * way, nothing should be on txcmplq as it will NEVER complete.
 		 */
 		list_splice_init(&pring->txcmplq, &completions);
-		spin_unlock_irq(&phba->hbalock);
+
+		if (phba->sli_rev >= LPFC_SLI_REV4)
+			spin_unlock_irq(&pring->ring_lock);
+		else
+			spin_unlock_irq(&phba->hbalock);
 
 		/* Cancel all the IOCBs from the completions list */
 		lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
 				      IOERR_SLI_ABORTED);
-
 		lpfc_sli_abort_iocb_ring(phba, pring);
-		spin_lock_irq(&phba->hbalock);
 	}
-	spin_unlock_irq(&phba->hbalock);
+}
 
+/**
+ * lpfc_hba_down_post_s3 - Perform lpfc uninitialization after HBA reset
+	int i;
+ * @phba: pointer to lpfc HBA data structure.
+ *
+ * This routine will do uninitialization after the HBA is reset when bring
+ * down the SLI Layer.
+ *
+ * Return codes
+ *   0 - success.
+ *   Any other value - error.
+ **/
+static int
+lpfc_hba_down_post_s3(struct lpfc_hba *phba)
+{
+	lpfc_hba_free_post_buf(phba);
+	lpfc_hba_clean_txcmplq(phba);
 	return 0;
 }
 
@@ -890,13 +932,12 @@ lpfc_hba_down_post_s4(struct lpfc_hba *p
 {
 	struct lpfc_scsi_buf *psb, *psb_next;
 	LIST_HEAD(aborts);
-	int ret;
 	unsigned long iflag = 0;
 	struct lpfc_sglq *sglq_entry = NULL;
 
-	ret = lpfc_hba_down_post_s3(phba);
-	if (ret)
-		return ret;
+	lpfc_hba_free_post_buf(phba);
+	lpfc_hba_clean_txcmplq(phba);
+
 	/* At this point in time the HBA is either reset or DOA. Either
 	 * way, nothing should be on lpfc_abts_els_sgl_list, it needs to be
 	 * on the lpfc_sgl_list so that it can either be freed if the



