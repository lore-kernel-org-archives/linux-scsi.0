From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/6] lpfc 8.3.17: Replace function reset methodology
Date: Wed, 29 Sep 2010 11:19:14 -0400
Message-ID: <1285773554.25110.13.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16094 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386Ab0I2PTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2010 11:19:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Replace graceful teardown steps with the singular function reset command.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |  132 ++++--------------------------------------------------------
 lpfc_sli.c  |   76 ----------------------------------
 lpfc_sli4.h |    2 
 3 files changed, 9 insertions(+), 201 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-09-29 10:19:33.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-09-29 10:20:38.000000000 -0400
@@ -2886,65 +2886,6 @@ lpfc_stop_port(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_remove_dflt_fcf - Remove the driver default fcf record from the port.
- * @phba: pointer to lpfc hba data structure.
- *
- * This routine is invoked to remove the driver default fcf record from
- * the port.  This routine currently acts on FCF Index 0.
- *
- **/
-void
-lpfc_sli_remove_dflt_fcf(struct lpfc_hba *phba)
-{
-	int rc = 0;
-	LPFC_MBOXQ_t *mboxq;
-	struct lpfc_mbx_del_fcf_tbl_entry *del_fcf_record;
-	uint32_t mbox_tmo, req_len;
-	uint32_t shdr_status, shdr_add_status;
-
-	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mboxq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"2020 Failed to allocate mbox for ADD_FCF cmd\n");
-		return;
-	}
-
-	req_len = sizeof(struct lpfc_mbx_del_fcf_tbl_entry) -
-		  sizeof(struct lpfc_sli4_cfg_mhdr);
-	rc = lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
-			      LPFC_MBOX_OPCODE_FCOE_DELETE_FCF,
-			      req_len, LPFC_SLI4_MBX_EMBED);
-	/*
-	 * In phase 1, there is a single FCF index, 0.  In phase2, the driver
-	 * supports multiple FCF indices.
-	 */
-	del_fcf_record = &mboxq->u.mqe.un.del_fcf_entry;
-	bf_set(lpfc_mbx_del_fcf_tbl_count, del_fcf_record, 1);
-	bf_set(lpfc_mbx_del_fcf_tbl_index, del_fcf_record,
-	       phba->fcf.current_rec.fcf_indx);
-
-	if (!phba->sli4_hba.intr_enable)
-		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
-		rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
-	}
-	/* The IOCTL status is embedded in the mailbox subheader. */
-	shdr_status = bf_get(lpfc_mbox_hdr_status,
-			     &del_fcf_record->header.cfg_shdr.response);
-	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
-				 &del_fcf_record->header.cfg_shdr.response);
-	if (shdr_status || shdr_add_status || rc != MBX_SUCCESS) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"2516 DEL FCF of default FCF Index failed "
-				"mbx status x%x, status x%x add_status x%x\n",
-				rc, shdr_status, shdr_add_status);
-	}
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mboxq, phba->mbox_mem_pool);
-}
-
-/**
  * lpfc_fcf_redisc_wait_start_timer - Start fcf rediscover wait timer
  * @phba: Pointer to hba for which this call is being executed.
  *
@@ -4286,12 +4227,6 @@ lpfc_sli4_driver_resource_unset(struct l
 {
 	struct lpfc_fcf_conn_entry *conn_entry, *next_conn_entry;
 
-	/* unregister default FCFI from the HBA */
-	lpfc_sli4_fcfi_unreg(phba, phba->fcf.fcfi);
-
-	/* Free the default FCR table */
-	lpfc_sli_remove_dflt_fcf(phba);
-
 	/* Free memory allocated for msi-x interrupt vector entries */
 	kfree(phba->sli4_hba.msix_entries);
 
@@ -4319,9 +4254,6 @@ lpfc_sli4_driver_resource_unset(struct l
 	lpfc_sli4_cq_event_release_all(phba);
 	lpfc_sli4_cq_event_pool_destroy(phba);
 
-	/* Reset SLI4 HBA FCoE function */
-	lpfc_pci_function_reset(phba);
-
 	/* Free the bsmbx region. */
 	lpfc_destroy_bootstrap_mbox(phba);
 
@@ -4548,7 +4480,6 @@ lpfc_free_sgl_list(struct lpfc_hba *phba
 {
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
 	LIST_HEAD(sglq_list);
-	int rc = 0;
 
 	spin_lock_irq(&phba->hbalock);
 	list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &sglq_list);
@@ -4561,11 +4492,6 @@ lpfc_free_sgl_list(struct lpfc_hba *phba
 		kfree(sglq_entry);
 		phba->sli4_hba.total_sglq_bufs--;
 	}
-	rc = lpfc_sli4_remove_all_sgl_pages(phba);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"2005 Unable to deregister pages from HBA: %x\n", rc);
-	}
 	kfree(phba->sli4_hba.lpfc_els_sgl_array);
 }
 
@@ -6595,50 +6521,6 @@ lpfc_sli4_send_nop_mbox_cmds(struct lpfc
 }
 
 /**
- * lpfc_sli4_fcfi_unreg - Unregister fcfi to device
- * @phba: pointer to lpfc hba data structure.
- * @fcfi: fcf index.
- *
- * This routine is invoked to unregister a FCFI from device.
- **/
-void
-lpfc_sli4_fcfi_unreg(struct lpfc_hba *phba, uint16_t fcfi)
-{
-	LPFC_MBOXQ_t *mbox;
-	uint32_t mbox_tmo;
-	int rc;
-	unsigned long flags;
-
-	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-
-	if (!mbox)
-		return;
-
-	lpfc_unreg_fcfi(mbox, fcfi);
-
-	if (!phba->sli4_hba.intr_enable)
-		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
-	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
-		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
-	}
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
-	if (rc != MBX_SUCCESS)
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"2517 Unregister FCFI command failed "
-				"status %d, mbxStatus x%x\n", rc,
-				bf_get(lpfc_mqe_status, &mbox->u.mqe));
-	else {
-		spin_lock_irqsave(&phba->hbalock, flags);
-		/* Mark the FCFI is no longer registered */
-		phba->fcf.fcf_flag &=
-			~(FCF_AVAILABLE | FCF_REGISTERED | FCF_SCAN_DONE);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-	}
-}
-
-/**
  * lpfc_sli4_pci_mem_setup - Setup SLI4 HBA PCI memory space.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -7375,10 +7257,14 @@ lpfc_sli4_unset_hba(struct lpfc_hba *phb
 
 	phba->pport->work_port_events = 0;
 
-	lpfc_sli4_hba_down(phba);
+	/* Stop the SLI4 device port */
+	lpfc_stop_port(phba);
 
 	lpfc_sli4_disable_intr(phba);
 
+	/* Reset SLI4 HBA FCoE function */
+	lpfc_pci_function_reset(phba);
+
 	return;
 }
 
@@ -7427,15 +7313,15 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phb
 		spin_unlock_irq(&phba->hbalock);
 	}
 
-	/* Tear down the queues in the HBA */
-	lpfc_sli4_queue_unset(phba);
-
 	/* Disable PCI subsystem interrupt */
 	lpfc_sli4_disable_intr(phba);
 
 	/* Stop kthread signal shall trigger work_done one more time */
 	kthread_stop(phba->worker_thread);
 
+	/* Reset SLI4 HBA FCoE function */
+	lpfc_pci_function_reset(phba);
+
 	/* Stop the SLI4 device port */
 	phba->pport->work_port_events = 0;
 }
@@ -8371,7 +8257,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *p
 	list_del_init(&vport->listentry);
 	spin_unlock_irq(&phba->hbalock);
 
-	/* Call scsi_free before lpfc_sli4_driver_resource_unset since scsi
+	/* Perform scsi free before driver resource_unset since scsi
 	 * buffers are released to their corresponding pools here.
 	 */
 	lpfc_scsi_free(phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-09-29 10:20:39.000000000 -0400
@@ -481,7 +481,6 @@ struct lpfc_rpi_hdr {
  */
 int lpfc_pci_function_reset(struct lpfc_hba *);
 int lpfc_sli4_hba_setup(struct lpfc_hba *);
-int lpfc_sli4_hba_down(struct lpfc_hba *);
 int lpfc_sli4_config(struct lpfc_hba *, struct lpfcMboxq *, uint8_t,
 		     uint8_t, uint32_t, bool);
 void lpfc_sli4_mbox_cmd_free(struct lpfc_hba *, struct lpfcMboxq *);
@@ -514,7 +513,6 @@ int lpfc_sli4_queue_setup(struct lpfc_hb
 void lpfc_sli4_queue_unset(struct lpfc_hba *);
 int lpfc_sli4_post_sgl(struct lpfc_hba *, dma_addr_t, dma_addr_t, uint16_t);
 int lpfc_sli4_repost_scsi_sgl_list(struct lpfc_hba *);
-int lpfc_sli4_remove_all_sgl_pages(struct lpfc_hba *);
 uint16_t lpfc_sli4_next_xritag(struct lpfc_hba *);
 int lpfc_sli4_post_async_mbox(struct lpfc_hba *);
 int lpfc_sli4_post_sgl_list(struct lpfc_hba *phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-09-29 10:19:33.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-09-29 10:20:39.000000000 -0400
@@ -6930,37 +6930,6 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_hba_down - PCI function resource cleanup for the SLI4 HBA
- * @phba: Pointer to HBA context object.
- *
- * This function cleans up all queues, iocb, buffers, mailbox commands while
- * shutting down the SLI4 HBA FCoE function. This function is called with no
- * lock held and always returns 1.
- *
- * This function does the following to cleanup driver FCoE function resources:
- * - Free discovery resources for each virtual port
- * - Cleanup any pending fabric iocbs
- * - Iterate through the iocb txq and free each entry in the list.
- * - Free up any buffer posted to the HBA.
- * - Clean up all the queue entries: WQ, RQ, MQ, EQ, CQ, etc.
- * - Free mailbox commands in the mailbox queue.
- **/
-int
-lpfc_sli4_hba_down(struct lpfc_hba *phba)
-{
-	/* Stop the SLI4 device port */
-	lpfc_stop_port(phba);
-
-	/* Tear down the queues in the HBA */
-	lpfc_sli4_queue_unset(phba);
-
-	/* unregister default FCFI from the HBA */
-	lpfc_sli4_fcfi_unreg(phba, phba->fcf.fcfi);
-
-	return 1;
-}
-
-/**
  * lpfc_sli_pcimem_bcopy - SLI memory copy function
  * @srcp: Source memory pointer.
  * @destp: Destination memory pointer.
@@ -10788,51 +10757,6 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba
 	}
 	return 0;
 }
-/**
- * lpfc_sli4_remove_all_sgl_pages - Post scatter gather list for an XRI to HBA
- * @phba: The virtual port for which this call being executed.
- *
- * This routine will remove all of the sgl pages registered with the hba.
- *
- * Return codes:
- * 	0 - Success
- * 	-ENXIO, -ENOMEM - Failure
- **/
-int
-lpfc_sli4_remove_all_sgl_pages(struct lpfc_hba *phba)
-{
-	LPFC_MBOXQ_t *mbox;
-	int rc;
-	uint32_t shdr_status, shdr_add_status;
-	union lpfc_sli4_cfg_shdr *shdr;
-
-	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mbox)
-		return -ENOMEM;
-
-	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
-			LPFC_MBOX_OPCODE_FCOE_REMOVE_SGL_PAGES, 0,
-			LPFC_SLI4_MBX_EMBED);
-	if (!phba->sli4_hba.intr_enable)
-		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
-	/* The IOCTL status is embedded in the mailbox subheader. */
-	shdr = (union lpfc_sli4_cfg_shdr *)
-		&mbox->u.mqe.un.sli4_config.header.cfg_shdr;
-	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
-	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
-	if (shdr_status || shdr_add_status || rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2512 REMOVE_ALL_SGL_PAGES mailbox failed with "
-				"status x%x add_status x%x, mbx status x%x\n",
-				shdr_status, shdr_add_status, rc);
-		rc = -ENXIO;
-	}
-	return rc;
-}
 
 /**
  * lpfc_sli4_next_xritag - Get an xritag for the io


