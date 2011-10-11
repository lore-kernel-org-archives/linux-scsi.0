From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/6] lpfc 8.3.27: Fix queue allocation failure recovery
Date: Mon, 10 Oct 2011 21:33:49 -0400
Message-ID: <1318296831.5189.13.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:33726 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753183Ab1JKBiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2011 21:38:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix queue allocation failure recovery

- Move the allocation of the Queues closer to the creation of the queues.
- If there is a problem with creation, or if the HBA is reset, the queues
  will be completely freed and re allocated.
- Only allocate fcp_eq_hdl if cfg_fcp_eq_count is non-zero.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h |    2 
 lpfc_init.c |  153 ++++++++++++++++++++++++++++++++++++------------------------
 lpfc_sli.c  |   30 +++++++++--
 3 files changed, 118 insertions(+), 67 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-10-10 16:46:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-10-10 16:46:38.000000000 -0400
@@ -451,3 +451,5 @@ int lpfc_wr_object(struct lpfc_hba *, st
 /* functions to support SR-IOV */
 int lpfc_sli_probe_sriov_nr_virtfn(struct lpfc_hba *, int);
 uint16_t lpfc_sli_sriov_nr_virtfn_get(struct lpfc_hba *);
+int lpfc_sli4_queue_create(struct lpfc_hba *);
+void lpfc_sli4_queue_destroy(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-10-10 16:46:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-10-10 16:46:38.000000000 -0400
@@ -58,8 +58,7 @@ spinlock_t _dump_buf_lock;
 
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 static int lpfc_post_rcv_buf(struct lpfc_hba *);
-static int lpfc_sli4_queue_create(struct lpfc_hba *);
-static void lpfc_sli4_queue_destroy(struct lpfc_hba *);
+static int lpfc_sli4_queue_verify(struct lpfc_hba *);
 static int lpfc_create_bootstrap_mbox(struct lpfc_hba *);
 static int lpfc_setup_endian_order(struct lpfc_hba *);
 static int lpfc_sli4_read_config(struct lpfc_hba *);
@@ -4493,15 +4492,15 @@ lpfc_sli4_driver_resource_setup(struct l
 		}
 	}
 	mempool_free(mboxq, phba->mbox_mem_pool);
-	/* Create all the SLI4 queues */
-	rc = lpfc_sli4_queue_create(phba);
+	/* Verify all the SLI4 queues */
+	rc = lpfc_sli4_queue_verify(phba);
 	if (rc)
 		goto out_free_bsmbx;
 
 	/* Create driver internal CQE event pool */
 	rc = lpfc_sli4_cq_event_pool_create(phba);
 	if (rc)
-		goto out_destroy_queue;
+		goto out_free_bsmbx;
 
 	/* Initialize and populate the iocb list per host */
 	rc = lpfc_init_sgl_list(phba);
@@ -4535,14 +4534,21 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_remove_rpi_hdrs;
 	}
 
-	phba->sli4_hba.fcp_eq_hdl = kzalloc((sizeof(struct lpfc_fcp_eq_hdl) *
+	/* 
+	 * The cfg_fcp_eq_count can be zero whenever there is exactly one
+	 * interrupt vector.  This is not an error
+	 */
+	if (phba->cfg_fcp_eq_count) {
+		phba->sli4_hba.fcp_eq_hdl =
+				kzalloc((sizeof(struct lpfc_fcp_eq_hdl) *
 				    phba->cfg_fcp_eq_count), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_eq_hdl) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2572 Failed allocate memory for fast-path "
-				"per-EQ handle array\n");
-		rc = -ENOMEM;
-		goto out_free_fcf_rr_bmask;
+		if (!phba->sli4_hba.fcp_eq_hdl) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2572 Failed allocate memory for "
+					"fast-path per-EQ handle array\n");
+			rc = -ENOMEM;
+			goto out_free_fcf_rr_bmask;
+		}
 	}
 
 	phba->sli4_hba.msix_entries = kzalloc((sizeof(struct msix_entry) *
@@ -4586,8 +4592,6 @@ out_free_sgl_list:
 	lpfc_free_sgl_list(phba);
 out_destroy_cq_event_pool:
 	lpfc_sli4_cq_event_pool_destroy(phba);
-out_destroy_queue:
-	lpfc_sli4_queue_destroy(phba);
 out_free_bsmbx:
 	lpfc_destroy_bootstrap_mbox(phba);
 out_free_mem:
@@ -4627,9 +4631,6 @@ lpfc_sli4_driver_resource_unset(struct l
 	/* Free the SCSI sgl management array */
 	kfree(phba->sli4_hba.lpfc_scsi_psb_array);
 
-	/* Free the SLI4 queues */
-	lpfc_sli4_queue_destroy(phba);
-
 	/* Free the completion queue EQ event pool */
 	lpfc_sli4_cq_event_release_all(phba);
 	lpfc_sli4_cq_event_pool_destroy(phba);
@@ -6158,24 +6159,21 @@ lpfc_setup_endian_order(struct lpfc_hba 
 }
 
 /**
- * lpfc_sli4_queue_create - Create all the SLI4 queues
+ * lpfc_sli4_queue_verify - Verify and update EQ and CQ counts
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to allocate all the SLI4 queues for the FCoE HBA
- * operation. For each SLI4 queue type, the parameters such as queue entry
- * count (queue depth) shall be taken from the module parameter. For now,
- * we just use some constant number as place holder.
+ * This routine is invoked to check the user settable queue counts for EQs and
+ * CQs. after this routine is called the counts will be set to valid values that
+ * adhere to the constraints of the system's interrupt vectors and the port's
+ * queue resources.
  *
  * Return codes
  *      0 - successful
  *      -ENOMEM - No available memory
- *      -EIO - The mailbox failed to complete successfully.
  **/
 static int
-lpfc_sli4_queue_create(struct lpfc_hba *phba)
+lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 {
-	struct lpfc_queue *qdesc;
-	int fcp_eqidx, fcp_cqidx, fcp_wqidx;
 	int cfg_fcp_wq_count;
 	int cfg_fcp_eq_count;
 
@@ -6248,14 +6246,43 @@ lpfc_sli4_queue_create(struct lpfc_hba *
 	/* The overall number of event queues used */
 	phba->sli4_hba.cfg_eqn = phba->cfg_fcp_eq_count + LPFC_SP_EQN_DEF;
 
-	/*
-	 * Create Event Queues (EQs)
-	 */
-
 	/* Get EQ depth from module parameter, fake the default for now */
 	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
 	phba->sli4_hba.eq_ecount = LPFC_EQE_DEF_COUNT;
 
+	/* Get CQ depth from module parameter, fake the default for now */
+	phba->sli4_hba.cq_esize = LPFC_CQE_SIZE;
+	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
+
+	return 0;
+out_error:
+	return -ENOMEM;
+}
+
+/**
+ * lpfc_sli4_queue_create - Create all the SLI4 queues
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to allocate all the SLI4 queues for the FCoE HBA
+ * operation. For each SLI4 queue type, the parameters such as queue entry
+ * count (queue depth) shall be taken from the module parameter. For now,
+ * we just use some constant number as place holder.
+ *
+ * Return codes
+ *      0 - sucessful
+ *      -ENOMEM - No availble memory
+ *      -EIO - The mailbox failed to complete successfully.
+ **/
+int
+lpfc_sli4_queue_create(struct lpfc_hba *phba)
+{
+	struct lpfc_queue *qdesc;
+	int fcp_eqidx, fcp_cqidx, fcp_wqidx;
+
+	/*
+	 * Create Event Queues (EQs)
+	 */
+
 	/* Create slow path event queue */
 	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.eq_esize,
 				      phba->sli4_hba.eq_ecount);
@@ -6266,14 +6293,20 @@ lpfc_sli4_queue_create(struct lpfc_hba *
 	}
 	phba->sli4_hba.sp_eq = qdesc;
 
-	/* Create fast-path FCP Event Queue(s) */
-	phba->sli4_hba.fp_eq = kzalloc((sizeof(struct lpfc_queue *) *
-			       phba->cfg_fcp_eq_count), GFP_KERNEL);
-	if (!phba->sli4_hba.fp_eq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2576 Failed allocate memory for fast-path "
-				"EQ record array\n");
-		goto out_free_sp_eq;
+	/*
+	 * Create fast-path FCP Event Queue(s).  The cfg_fcp_eq_count can be
+	 * zero whenever there is exactly one interrupt vector.  This is not
+	 * an error.
+	 */
+	if (phba->cfg_fcp_eq_count) {
+		phba->sli4_hba.fp_eq = kzalloc((sizeof(struct lpfc_queue *) *
+				       phba->cfg_fcp_eq_count), GFP_KERNEL);
+		if (!phba->sli4_hba.fp_eq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2576 Failed allocate memory for "
+					"fast-path EQ record array\n");
+			goto out_free_sp_eq;
+		}
 	}
 	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_eq_count; fcp_eqidx++) {
 		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.eq_esize,
@@ -6290,10 +6323,6 @@ lpfc_sli4_queue_create(struct lpfc_hba *
 	 * Create Complete Queues (CQs)
 	 */
 
-	/* Get CQ depth from module parameter, fake the default for now */
-	phba->sli4_hba.cq_esize = LPFC_CQE_SIZE;
-	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
-
 	/* Create slow-path Mailbox Command Complete Queue */
 	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
 				      phba->sli4_hba.cq_ecount);
@@ -6315,16 +6344,25 @@ lpfc_sli4_queue_create(struct lpfc_hba *
 	phba->sli4_hba.els_cq = qdesc;
 

-	/* Create fast-path FCP Completion Queue(s), one-to-one with EQs */
-	phba->sli4_hba.fcp_cq = kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_eq_count), GFP_KERNEL);
+	/*
+	 * Create fast-path FCP Completion Queue(s), one-to-one with FCP EQs.
+	 * If there are no FCP EQs then create exactly one FCP CQ.
+	 */
+	if (phba->cfg_fcp_eq_count)
+		phba->sli4_hba.fcp_cq = kzalloc((sizeof(struct lpfc_queue *) *
+						 phba->cfg_fcp_eq_count),
+						GFP_KERNEL);
+	else
+		phba->sli4_hba.fcp_cq = kzalloc(sizeof(struct lpfc_queue *),
+						GFP_KERNEL);
 	if (!phba->sli4_hba.fcp_cq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2577 Failed allocate memory for fast-path "
 				"CQ record array\n");
 		goto out_free_els_cq;
 	}
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_eq_count; fcp_cqidx++) {
+	fcp_cqidx = 0;
+	do {
 		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
 					      phba->sli4_hba.cq_ecount);
 		if (!qdesc) {
@@ -6334,7 +6372,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *
 			goto out_free_fcp_cq;
 		}
 		phba->sli4_hba.fcp_cq[fcp_cqidx] = qdesc;
-	}
+	} while (++fcp_cqidx < phba->cfg_fcp_eq_count);
 
 	/* Create Mailbox Command Queue */
 	phba->sli4_hba.mq_esize = LPFC_MQE_SIZE;
@@ -6466,7 +6504,7 @@ out_error:
  *      -ENOMEM - No available memory
  *      -EIO - The mailbox failed to complete successfully.
  **/
-static void
+void
 lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 {
 	int fcp_qidx;
@@ -6814,8 +6852,10 @@ lpfc_sli4_queue_unset(struct lpfc_hba *p
 	/* Unset ELS complete queue */
 	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
 	/* Unset FCP response complete queue */
-	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++)
+	fcp_qidx = 0;
+	do {
 		lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_qidx]);
+	} while (++fcp_qidx < phba->cfg_fcp_eq_count);
 	/* Unset fast-path event queue */
 	for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_eq_count; fcp_qidx++)
 		lpfc_eq_destroy(phba, phba->sli4_hba.fp_eq[fcp_qidx]);
@@ -7995,6 +8035,7 @@ lpfc_sli4_unset_hba(struct lpfc_hba *phb
 
 	/* Reset SLI4 HBA FCoE function */
 	lpfc_pci_function_reset(phba);
+	lpfc_sli4_queue_destroy(phba);
 
 	return;
 }
@@ -8108,6 +8149,7 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phb
 
 	/* Reset SLI4 HBA FCoE function */
 	lpfc_pci_function_reset(phba);
+	lpfc_sli4_queue_destroy(phba);
 
 	/* Stop the SLI4 device port */
 	phba->pport->work_port_events = 0;
@@ -9008,7 +9050,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	uint32_t cfg_mode, intr_mode;
 	int mcnt;
 	int adjusted_fcp_eq_count;
-	int fcp_qidx;
 	const struct firmware *fw;
 	uint8_t file_name[16];
 
@@ -9117,16 +9158,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 			adjusted_fcp_eq_count = phba->sli4_hba.msix_vec_nr - 1;
 		else
 			adjusted_fcp_eq_count = phba->cfg_fcp_eq_count;
-		/* Free unused EQs */
-		for (fcp_qidx = adjusted_fcp_eq_count;
-		     fcp_qidx < phba->cfg_fcp_eq_count;
-		     fcp_qidx++) {
-			lpfc_sli4_queue_free(phba->sli4_hba.fp_eq[fcp_qidx]);
-			/* do not delete the first fcp_cq */
-			if (fcp_qidx)
-				lpfc_sli4_queue_free(
-					phba->sli4_hba.fcp_cq[fcp_qidx]);
-		}
 		phba->cfg_fcp_eq_count = adjusted_fcp_eq_count;
 		/* Set up SLI-4 HBA */
 		if (lpfc_sli4_hba_setup(phba)) {
@@ -9309,6 +9340,7 @@ lpfc_pci_suspend_one_s4(struct pci_dev *
 
 	/* Disable interrupt from device */
 	lpfc_sli4_disable_intr(phba);
+	lpfc_sli4_queue_destroy(phba);
 
 	/* Save device state to PCI config space */
 	pci_save_state(pdev);
@@ -9438,6 +9470,7 @@ lpfc_sli4_prep_dev_for_reset(struct lpfc
 
 	/* Disable interrupt and pci device */
 	lpfc_sli4_disable_intr(phba);
+	lpfc_sli4_queue_destroy(phba);
 	pci_disable_device(phba->pcidev);
 
 	/* Flush all driver's outstanding SCSI I/Os as we are to reset */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-10-10 16:46:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-10-10 16:46:38.000000000 -0400
@@ -6127,12 +6127,20 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		goto out_free_mbox;
 	}
 
+	/* Create all the SLI4 queues */
+	rc = lpfc_sli4_queue_create(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3089 Failed to allocate queues\n");
+		rc = -ENODEV;
+		goto out_stop_timers;
+	}
 	/* Set up all the queues to the device */
 	rc = lpfc_sli4_queue_setup(phba);
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 				"0381 Error %d during queue setup.\n ", rc);
-		goto out_stop_timers;
+		goto out_destroy_queue;
 	}
 
 	/* Arm the CQs and then EQs on device */
@@ -6205,15 +6213,20 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	spin_lock_irq(&phba->hbalock);
 	phba->link_state = LPFC_LINK_DOWN;
 	spin_unlock_irq(&phba->hbalock);
-	if (phba->cfg_suppress_link_up == LPFC_INITIALIZE_LINK)
+	if (phba->cfg_suppress_link_up == LPFC_INITIALIZE_LINK) {
 		rc = phba->lpfc_hba_init_link(phba, MBX_NOWAIT);
+		if (rc)
+			goto out_unset_queue;
+	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return rc;
 out_unset_queue:
 	/* Unset all the queues set up in this routine when error out */
-	if (rc)
-		lpfc_sli4_queue_unset(phba);
+	lpfc_sli4_queue_unset(phba);
+out_destroy_queue:
+	lpfc_sli4_queue_destroy(phba);
 out_stop_timers:
-	if (rc)
-		lpfc_stop_hba_timers(phba);
+	lpfc_stop_hba_timers(phba);
 out_free_mbox:
 	mempool_free(mboxq, phba->mbox_mem_pool);
 	return rc;
@@ -9562,7 +9575,6 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 
 	/* now issue the command */
 	retval = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
-
 	if (retval == MBX_BUSY || retval == MBX_SUCCESS) {
 		wait_event_interruptible_timeout(done_q,
 				pmboxq->mbox_flag & LPFC_MBX_WAKE,
@@ -11319,6 +11331,8 @@ lpfc_sli4_sp_intr_handler(int irq, void 
 
 	/* Get to the EQ struct associated with this vector */
 	speq = phba->sli4_hba.sp_eq;
+	if (unlikely(!speq))
+		return IRQ_NONE;
 
 	/* Check device state for handling interrupt */
 	if (unlikely(lpfc_intr_state_check(phba))) {
@@ -11396,6 +11410,8 @@ lpfc_sli4_fp_intr_handler(int irq, void 
 
 	if (unlikely(!phba))
 		return IRQ_NONE;
+	if (unlikely(!phba->sli4_hba.fp_eq))
+		return IRQ_NONE;
 
 	/* Get to the EQ struct associated with this vector */
 	fpeq = phba->sli4_hba.fp_eq[fcp_eqidx];



