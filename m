From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/11] lpfc 10.2.8000.0: Fix SLI4 s abort loop to process all
 FCP rings and under ring_lock
Date: Fri, 4 Apr 2014 13:52:02 -0400
Message-ID: <1396633922.1924.18.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:53479 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaDDRwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 13:52:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix SLI4 s abort loop to process all FCP rings and under ring_lock


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h |    1 
 lpfc_init.c |   23 +-------
 lpfc_sli.c  |  155 ++++++++++++++++++++++++++++++++++++------------------------
 3 files changed, 99 insertions(+), 80 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2014-03-31 16:21:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2014-04-03 10:24:24.211308703 -0400
@@ -289,6 +289,7 @@ int lpfc_sli_issue_iocb(struct lpfc_hba
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_bemem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_abort_iocb_ring(struct lpfc_hba *, struct lpfc_sli_ring *);
+void lpfc_sli_abort_fcp_rings(struct lpfc_hba *phba);
 void lpfc_sli_hba_iocb_abort(struct lpfc_hba *);
 void lpfc_sli_flush_fcp_rings(struct lpfc_hba *);
 int lpfc_sli_ringpostbuf_put(struct lpfc_hba *, struct lpfc_sli_ring *,
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-04-03 10:24:22.340308608 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-04-03 10:24:24.223308703 -0400
@@ -880,8 +880,6 @@ lpfc_hba_clean_txcmplq(struct lpfc_hba *
 	LIST_HEAD(completions);
 	int i;
 
-
-
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
 		if (phba->sli_rev >= LPFC_SLI_REV4)
@@ -892,6 +890,7 @@ lpfc_hba_clean_txcmplq(struct lpfc_hba *
 		 * way, nothing should be on txcmplq as it will NEVER complete.
 		 */
 		list_splice_init(&pring->txcmplq, &completions);
+		pring->txcmplq_cnt = 0;
 
 		if (phba->sli_rev >= LPFC_SLI_REV4)
 			spin_unlock_irq(&pring->ring_lock);
@@ -1300,7 +1299,6 @@ static void
 lpfc_handle_deferred_eratt(struct lpfc_hba *phba)
 {
 	uint32_t old_host_status = phba->work_hs;
-	struct lpfc_sli_ring  *pring;
 	struct lpfc_sli *psli = &phba->sli;
 
 	/* If the pci channel is offline, ignore possible errors,
@@ -1329,8 +1327,7 @@ lpfc_handle_deferred_eratt(struct lpfc_h
 	 * dropped by the firmware. Error iocb (I/O) on txcmplq and let the
 	 * SCSI layer retry it after re-establishing link.
 	 */
-	pring = &psli->ring[psli->fcp_ring];
-	lpfc_sli_abort_iocb_ring(phba, pring);
+	lpfc_sli_abort_fcp_rings(phba);
 
 	/*
 	 * There was a firmware error. Take the hba offline and then
@@ -1398,7 +1395,6 @@ lpfc_handle_eratt_s3(struct lpfc_hba *ph
 {
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_sli   *psli = &phba->sli;
-	struct lpfc_sli_ring  *pring;
 	uint32_t event_data;
 	unsigned long temperature;
 	struct temp_event temp_event_data;
@@ -1450,8 +1446,7 @@ lpfc_handle_eratt_s3(struct lpfc_hba *ph
 		* Error iocb (I/O) on txcmplq and let the SCSI layer
 		* retry it after re-establishing link.
 		*/
-		pring = &psli->ring[psli->fcp_ring];
-		lpfc_sli_abort_iocb_ring(phba, pring);
+		lpfc_sli_abort_fcp_rings(phba);
 
 		/*
 		 * There was a firmware error.  Take the hba offline and then
@@ -9716,9 +9711,6 @@ lpfc_pci_resume_one_s3(struct pci_dev *p
 static void
 lpfc_sli_prep_dev_for_recover(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring  *pring;
-
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2723 PCI channel I/O abort preparing for recovery\n");
 
@@ -9726,8 +9718,7 @@ lpfc_sli_prep_dev_for_recover(struct lpf
 	 * There may be errored I/Os through HBA, abort all I/Os on txcmplq
 	 * and let the SCSI mid-layer to retry them to recover.
 	 */
-	pring = &psli->ring[psli->fcp_ring];
-	lpfc_sli_abort_iocb_ring(phba, pring);
+	lpfc_sli_abort_fcp_rings(phba);
 }
 
 /**
@@ -10470,17 +10461,13 @@ lpfc_pci_resume_one_s4(struct pci_dev *p
 static void
 lpfc_sli4_prep_dev_for_recover(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring  *pring;
-
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2828 PCI channel I/O abort preparing for recovery\n");
 	/*
 	 * There may be errored I/Os through HBA, abort all I/Os on txcmplq
 	 * and let the SCSI mid-layer to retry them to recover.
 	 */
-	pring = &psli->ring[psli->fcp_ring];
-	lpfc_sli_abort_iocb_ring(phba, pring);
+	lpfc_sli_abort_fcp_rings(phba);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2014-03-31 16:21:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2014-04-03 10:24:24.244308704 -0400
@@ -3511,14 +3511,27 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 	/* Error everything on txq and txcmplq
 	 * First do the txq.
 	 */
-	spin_lock_irq(&phba->hbalock);
-	list_splice_init(&pring->txq, &completions);
+	if (phba->sli_rev >= LPFC_SLI_REV4) {
+		spin_lock_irq(&pring->ring_lock);
+		list_splice_init(&pring->txq, &completions);
+		pring->txq_cnt = 0;
+		spin_unlock_irq(&pring->ring_lock);
 
-	/* Next issue ABTS for everything on the txcmplq */
-	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-		lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+		spin_lock_irq(&phba->hbalock);
+		/* Next issue ABTS for everything on the txcmplq */
+		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+		spin_unlock_irq(&phba->hbalock);
+	} else {
+		spin_lock_irq(&phba->hbalock);
+		list_splice_init(&pring->txq, &completions);
+		pring->txq_cnt = 0;
 
-	spin_unlock_irq(&phba->hbalock);
+		/* Next issue ABTS for everything on the txcmplq */
+		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+		spin_unlock_irq(&phba->hbalock);
+	}
 
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
@@ -3526,6 +3539,36 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 }
 
 /**
+ * lpfc_sli_abort_fcp_rings - Abort all iocbs in all FCP rings
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function aborts all iocbs in FCP rings and frees all the iocb
+ * objects in txq. This function issues an abort iocb for all the iocb commands
+ * in txcmplq. The iocbs in the txcmplq is not guaranteed to complete before
+ * the return of this function. The caller is not required to hold any locks.
+ **/
+void
+lpfc_sli_abort_fcp_rings(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring  *pring;
+	uint32_t i;
+
+	/* Look on all the FCP Rings for the iotag */
+	if (phba->sli_rev >= LPFC_SLI_REV4) {
+		for (i = 0; i < phba->cfg_fcp_io_channel; i++) {
+			pring = &psli->ring[i + MAX_SLI3_CONFIGURED_RINGS];
+			lpfc_sli_abort_iocb_ring(phba, pring);
+		}
+	} else {
+		pring = &psli->ring[psli->fcp_ring];
+		lpfc_sli_abort_iocb_ring(phba, pring);
+	}
+}
+
+
+/**
  * lpfc_sli_flush_fcp_rings - flush all iocbs in the fcp ring
  * @phba: Pointer to HBA context object.
  *
@@ -3542,28 +3585,55 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba
 	LIST_HEAD(txcmplq);
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
-
-	/* Currently, only one fcp ring */
-	pring = &psli->ring[psli->fcp_ring];
+	uint32_t i;
 
 	spin_lock_irq(&phba->hbalock);
-	/* Retrieve everything on txq */
-	list_splice_init(&pring->txq, &txq);
-
-	/* Retrieve everything on the txcmplq */
-	list_splice_init(&pring->txcmplq, &txcmplq);
-
 	/* Indicate the I/O queues are flushed */
 	phba->hba_flag |= HBA_FCP_IOQ_FLUSH;
 	spin_unlock_irq(&phba->hbalock);
 
-	/* Flush the txq */
-	lpfc_sli_cancel_iocbs(phba, &txq, IOSTAT_LOCAL_REJECT,
-			      IOERR_SLI_DOWN);
+	/* Look on all the FCP Rings for the iotag */
+	if (phba->sli_rev >= LPFC_SLI_REV4) {
+		for (i = 0; i < phba->cfg_fcp_io_channel; i++) {
+			pring = &psli->ring[i + MAX_SLI3_CONFIGURED_RINGS];
+
+			spin_lock_irq(&pring->ring_lock);
+			/* Retrieve everything on txq */
+			list_splice_init(&pring->txq, &txq);
+			/* Retrieve everything on the txcmplq */
+			list_splice_init(&pring->txcmplq, &txcmplq);
+			pring->txq_cnt = 0;
+			pring->txcmplq_cnt = 0;
+			spin_unlock_irq(&pring->ring_lock);
+
+			/* Flush the txq */
+			lpfc_sli_cancel_iocbs(phba, &txq,
+					      IOSTAT_LOCAL_REJECT,
+					      IOERR_SLI_DOWN);
+			/* Flush the txcmpq */
+			lpfc_sli_cancel_iocbs(phba, &txcmplq,
+					      IOSTAT_LOCAL_REJECT,
+					      IOERR_SLI_DOWN);
+		}
+	} else {
+		pring = &psli->ring[psli->fcp_ring];
 
-	/* Flush the txcmpq */
-	lpfc_sli_cancel_iocbs(phba, &txcmplq, IOSTAT_LOCAL_REJECT,
-			      IOERR_SLI_DOWN);
+		spin_lock_irq(&phba->hbalock);
+		/* Retrieve everything on txq */
+		list_splice_init(&pring->txq, &txq);
+		/* Retrieve everything on the txcmplq */
+		list_splice_init(&pring->txcmplq, &txcmplq);
+		pring->txq_cnt = 0;
+		pring->txcmplq_cnt = 0;
+		spin_unlock_irq(&phba->hbalock);
+
+		/* Flush the txq */
+		lpfc_sli_cancel_iocbs(phba, &txq, IOSTAT_LOCAL_REJECT,
+				      IOERR_SLI_DOWN);
+		/* Flush the txcmpq */
+		lpfc_sli_cancel_iocbs(phba, &txcmplq, IOSTAT_LOCAL_REJECT,
+				      IOERR_SLI_DOWN);
+	}
 }
 
 /**
@@ -6701,7 +6771,6 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	LPFC_MBOXQ_t *pmbox = phba->sli.mbox_active;
 	MAILBOX_t *mb = &pmbox->u.mb;
 	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring;
 
 	/* If the mailbox completed, process the completion and return */
 	if (lpfc_sli4_process_missed_mbox_completions(phba))
@@ -6743,8 +6812,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
-	pring = &psli->ring[psli->fcp_ring];
-	lpfc_sli_abort_iocb_ring(phba, pring);
+	lpfc_sli_abort_fcp_rings(phba);
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 			"0345 Resetting board due to mailbox timeout\n");
@@ -9784,43 +9852,6 @@ abort_iotag_exit:
 }
 
 /**
- * lpfc_sli_iocb_ring_abort - Unconditionally abort all iocbs on an iocb ring
- * @phba: Pointer to HBA context object.
- * @pring: Pointer to driver SLI ring object.
- *
- * This function aborts all iocbs in the given ring and frees all the iocb
- * objects in txq. This function issues abort iocbs unconditionally for all
- * the iocb commands in txcmplq. The iocbs in the txcmplq is not guaranteed
- * to complete before the return of this function. The caller is not required
- * to hold any locks.
- **/
-static void
-lpfc_sli_iocb_ring_abort(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
-{
-	LIST_HEAD(completions);
-	struct lpfc_iocbq *iocb, *next_iocb;
-
-	if (pring->ringno == LPFC_ELS_RING)
-		lpfc_fabric_abort_hba(phba);
-
-	spin_lock_irq(&phba->hbalock);
-
-	/* Take off all the iocbs on txq for cancelling */
-	list_splice_init(&pring->txq, &completions);
-	pring->txq_cnt = 0;
-
-	/* Next issue ABTS for everything on the txcmplq */
-	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-		lpfc_sli_abort_iotag_issue(phba, pring, iocb);
-
-	spin_unlock_irq(&phba->hbalock);
-
-	/* Cancel all the IOCBs from the completions list */
-	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
-			      IOERR_SLI_ABORTED);
-}
-
-/**
  * lpfc_sli_hba_iocb_abort - Abort all iocbs to an hba.
  * @phba: pointer to lpfc HBA data structure.
  *
@@ -9835,7 +9866,7 @@ lpfc_sli_hba_iocb_abort(struct lpfc_hba
 
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
-		lpfc_sli_iocb_ring_abort(phba, pring);
+		lpfc_sli_abort_iocb_ring(phba, pring);
 	}
 }
 



