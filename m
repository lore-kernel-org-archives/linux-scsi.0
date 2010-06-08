From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/4] lpfc 8.3.14: PCI fixes and enhancements
Date: Tue, 8 Jun 2010 18:31:21 -0400
Message-ID: <1276036312.3169.1.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:14393 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752140Ab0FHWcz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2010 18:32:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Allow enabling MSI-X intterupts with fewer vectors than requested
  by looking at the return value from pci_enable_msix.
- Implemented driver PCI AER error handling routines for supporting
  AER error recovering on SLI4 devices.
- Remove redundant SLI_ACTIVE checks

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |   22 ------
 lpfc_init.c |  195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 lpfc_scsi.c |   10 ++-
 lpfc_sli.c  |   41 ++++++++++--
 lpfc_sli4.h |    1 
 5 files changed, 228 insertions(+), 41 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-06-08 12:01:16.000000000 -0400
@@ -864,7 +864,6 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 		  uint32_t *mrpi, uint32_t *arpi,
 		  uint32_t *mvpi, uint32_t *avpi)
 {
-	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_mbx_read_config *rd_config;
 	LPFC_MBOXQ_t *pmboxq;
 	MAILBOX_t *pmb;
@@ -893,8 +892,7 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 	pmb->mbxOwner = OWN_HOST;
 	pmboxq->context1 = NULL;
 
-	if ((phba->pport->fc_flag & FC_OFFLINE_MODE) ||
-		(!(psli->sli_flag & LPFC_SLI_ACTIVE)))
+	if (phba->pport->fc_flag & FC_OFFLINE_MODE)
 		rc = MBX_NOT_FINISHED;
 	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
@@ -2943,9 +2941,6 @@ lpfc_aer_support_store(struct device *de
 	struct lpfc_hba *phba = vport->phba;
 	int val = 0, rc = -EINVAL;
 
-	/* AER not supported on OC devices yet */
-	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
-		return -EPERM;
 	if (!isdigit(buf[0]))
 		return -EINVAL;
 	if (sscanf(buf, "%i", &val) != 1)
@@ -3018,12 +3013,6 @@ lpfc_param_show(aer_support)
 static int
 lpfc_aer_support_init(struct lpfc_hba *phba, int val)
 {
-	/* AER not supported on OC devices yet */
-	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC) {
-		phba->cfg_aer_support = 0;
-		return -EPERM;
-	}
-
 	if (val == 0 || val == 1) {
 		phba->cfg_aer_support = val;
 		return 0;
@@ -3068,9 +3057,6 @@ lpfc_aer_cleanup_state(struct device *de
 	struct lpfc_hba   *phba = vport->phba;
 	int val, rc = -1;
 
-	/* AER not supported on OC devices yet */
-	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
-		return -EPERM;
 	if (!isdigit(buf[0]))
 		return -EINVAL;
 	if (sscanf(buf, "%i", &val) != 1)
@@ -4099,8 +4085,7 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	pmboxq->context1 = NULL;
 	pmboxq->vport = vport;
 
-	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-		(!(psli->sli_flag & LPFC_SLI_ACTIVE)))
+	if (vport->fc_flag & FC_OFFLINE_MODE)
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
 	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
@@ -4124,8 +4109,7 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	pmboxq->context1 = NULL;
 	pmboxq->vport = vport;
 
-	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-	    (!(psli->sli_flag & LPFC_SLI_ACTIVE)))
+	if (vport->fc_flag & FC_OFFLINE_MODE)
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
 	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-06-08 12:01:16.000000000 -0400
@@ -7030,22 +7030,28 @@ lpfc_sli_disable_intr(struct lpfc_hba *p
 static int
 lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 {
-	int rc, index;
+	int vectors, rc, index;
 
 	/* Set up MSI-X multi-message vectors */
 	for (index = 0; index < phba->sli4_hba.cfg_eqn; index++)
 		phba->sli4_hba.msix_entries[index].entry = index;
 
 	/* Configure MSI-X capability structure */
+	vectors = phba->sli4_hba.cfg_eqn;
+enable_msix_vectors:
 	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
-			     phba->sli4_hba.cfg_eqn);
-	if (rc) {
+			     vectors);
+	if (rc > 1) {
+		vectors = rc;
+		goto enable_msix_vectors;
+	} else if (rc) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
 		goto msi_fail_out;
 	}
+
 	/* Log MSI-X vector assignment */
-	for (index = 0; index < phba->sli4_hba.cfg_eqn; index++)
+	for (index = 0; index < vectors; index++)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0489 MSI-X entry[%d]: vector=x%x "
 				"message=%d\n", index,
@@ -7067,7 +7073,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *p
 	}
 
 	/* The rest of the vector(s) are associated to fast-path handler(s) */
-	for (index = 1; index < phba->sli4_hba.cfg_eqn; index++) {
+	for (index = 1; index < vectors; index++) {
 		phba->sli4_hba.fcp_eq_hdl[index - 1].idx = index - 1;
 		phba->sli4_hba.fcp_eq_hdl[index - 1].phba = phba;
 		rc = request_irq(phba->sli4_hba.msix_entries[index].vector,
@@ -7081,6 +7087,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *p
 			goto cfg_fail_out;
 		}
 	}
+	phba->sli4_hba.msix_vec_nr = vectors;
 
 	return rc;
 
@@ -7114,9 +7121,10 @@ lpfc_sli4_disable_msix(struct lpfc_hba *
 	/* Free up MSI-X multi-message vectors */
 	free_irq(phba->sli4_hba.msix_entries[0].vector, phba);
 
-	for (index = 1; index < phba->sli4_hba.cfg_eqn; index++)
+	for (index = 1; index < phba->sli4_hba.msix_vec_nr; index++)
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
 			 &phba->sli4_hba.fcp_eq_hdl[index - 1]);
+
 	/* Disable MSI-X */
 	pci_disable_msix(phba->pcidev);
 
@@ -7158,6 +7166,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *ph
 		pci_disable_msi(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0490 MSI request_irq failed (%d)\n", rc);
+		return rc;
 	}
 
 	for (index = 0; index < phba->cfg_fcp_eq_count; index++) {
@@ -7165,7 +7174,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *ph
 		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
 	}
 
-	return rc;
+	return 0;
 }
 
 /**
@@ -7876,6 +7885,9 @@ lpfc_sli_prep_dev_for_reset(struct lpfc_
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2710 PCI channel disable preparing for reset\n");
 
+	/* Block any management I/Os to the device */
+	lpfc_block_mgmt_io(phba);
+
 	/* Block all SCSI devices' I/Os on the host */
 	lpfc_scsi_dev_block(phba);
 
@@ -7885,6 +7897,7 @@ lpfc_sli_prep_dev_for_reset(struct lpfc_
 	/* Disable interrupt and pci device */
 	lpfc_sli_disable_intr(phba);
 	pci_disable_device(phba->pcidev);
+
 	/* Flush all driver's outstanding SCSI I/Os as we are to reset */
 	lpfc_sli_flush_fcp_rings(phba);
 }
@@ -7898,7 +7911,7 @@ lpfc_sli_prep_dev_for_reset(struct lpfc_
  * pending I/Os.
  **/
 static void
-lpfc_prep_dev_for_perm_failure(struct lpfc_hba *phba)
+lpfc_sli_prep_dev_for_perm_failure(struct lpfc_hba *phba)
 {
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2711 PCI channel permanent disable for failure\n");
@@ -7947,7 +7960,7 @@ lpfc_io_error_detected_s3(struct pci_dev
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		/* Permanent failure, prepare for device down */
-		lpfc_prep_dev_for_perm_failure(phba);
+		lpfc_sli_prep_dev_for_perm_failure(phba);
 		return PCI_ERS_RESULT_DISCONNECT;
 	default:
 		/* Unknown state, prepare and request slot reset */
@@ -8016,7 +8029,8 @@ lpfc_io_slot_reset_s3(struct pci_dev *pd
 	} else
 		phba->intr_mode = intr_mode;
 
-	/* Take device offline; this will perform cleanup */
+	/* Take device offline, it will perform cleanup */
+	lpfc_offline_prep(phba);
 	lpfc_offline(phba);
 	lpfc_sli_brdrestart(phba);
 
@@ -8201,6 +8215,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 		/* Default to single FCP EQ for non-MSI-X */
 		if (phba->intr_type != MSIX)
 			phba->cfg_fcp_eq_count = 1;
+		else if (phba->sli4_hba.msix_vec_nr < phba->cfg_fcp_eq_count)
+			phba->cfg_fcp_eq_count = phba->sli4_hba.msix_vec_nr - 1;
 		/* Set up SLI-4 HBA */
 		if (lpfc_sli4_hba_setup(phba)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -8362,7 +8378,7 @@ lpfc_pci_suspend_one_s4(struct pci_dev *
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"0298 PCI device Power Management suspend.\n");
+			"2843 PCI device Power Management suspend.\n");
 
 	/* Bring down the device */
 	lpfc_offline_prep(phba);
@@ -8453,6 +8469,84 @@ lpfc_pci_resume_one_s4(struct pci_dev *p
 }
 
 /**
+ * lpfc_sli4_prep_dev_for_recover - Prepare SLI4 device for pci slot recover
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is called to prepare the SLI4 device for PCI slot recover. It
+ * aborts all the outstanding SCSI I/Os to the pci device.
+ **/
+static void
+lpfc_sli4_prep_dev_for_recover(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring  *pring;
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2828 PCI channel I/O abort preparing for recovery\n");
+	/*
+	 * There may be errored I/Os through HBA, abort all I/Os on txcmplq
+	 * and let the SCSI mid-layer to retry them to recover.
+	 */
+	pring = &psli->ring[psli->fcp_ring];
+	lpfc_sli_abort_iocb_ring(phba, pring);
+}
+
+/**
+ * lpfc_sli4_prep_dev_for_reset - Prepare SLI4 device for pci slot reset
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is called to prepare the SLI4 device for PCI slot reset. It
+ * disables the device interrupt and pci device, and aborts the internal FCP
+ * pending I/Os.
+ **/
+static void
+lpfc_sli4_prep_dev_for_reset(struct lpfc_hba *phba)
+{
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2826 PCI channel disable preparing for reset\n");
+
+	/* Block any management I/Os to the device */
+	lpfc_block_mgmt_io(phba);
+
+	/* Block all SCSI devices' I/Os on the host */
+	lpfc_scsi_dev_block(phba);
+
+	/* stop all timers */
+	lpfc_stop_hba_timers(phba);
+
+	/* Disable interrupt and pci device */
+	lpfc_sli4_disable_intr(phba);
+	pci_disable_device(phba->pcidev);
+
+	/* Flush all driver's outstanding SCSI I/Os as we are to reset */
+	lpfc_sli_flush_fcp_rings(phba);
+}
+
+/**
+ * lpfc_sli4_prep_dev_for_perm_failure - Prepare SLI4 dev for pci slot disable
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is called to prepare the SLI4 device for PCI slot permanently
+ * disabling. It blocks the SCSI transport layer traffic and flushes the FCP
+ * pending I/Os.
+ **/
+static void
+lpfc_sli4_prep_dev_for_perm_failure(struct lpfc_hba *phba)
+{
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2827 PCI channel permanent disable for failure\n");
+
+	/* Block all SCSI devices' I/Os on the host */
+	lpfc_scsi_dev_block(phba);
+
+	/* stop all timers */
+	lpfc_stop_hba_timers(phba);
+
+	/* Clean up all driver's outstanding SCSI I/Os */
+	lpfc_sli_flush_fcp_rings(phba);
+}
+
+/**
  * lpfc_io_error_detected_s4 - Method for handling PCI I/O error to SLI-4 device
  * @pdev: pointer to PCI device.
  * @state: the current PCI connection state.
@@ -8471,7 +8565,29 @@ lpfc_pci_resume_one_s4(struct pci_dev *p
 static pci_ers_result_t
 lpfc_io_error_detected_s4(struct pci_dev *pdev, pci_channel_state_t state)
 {
-	return PCI_ERS_RESULT_NEED_RESET;
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	switch (state) {
+	case pci_channel_io_normal:
+		/* Non-fatal error, prepare for recovery */
+		lpfc_sli4_prep_dev_for_recover(phba);
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_frozen:
+		/* Fatal error, prepare for slot reset */
+		lpfc_sli4_prep_dev_for_reset(phba);
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		/* Permanent failure, prepare for device down */
+		lpfc_sli4_prep_dev_for_perm_failure(phba);
+		return PCI_ERS_RESULT_DISCONNECT;
+	default:
+		/* Unknown state, prepare and request slot reset */
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2825 Unknown PCI error state: x%x\n", state);
+		lpfc_sli4_prep_dev_for_reset(phba);
+		return PCI_ERS_RESULT_NEED_RESET;
+	}
 }
 
 /**
@@ -8495,6 +8611,39 @@ lpfc_io_error_detected_s4(struct pci_dev
 static pci_ers_result_t
 lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 {
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	struct lpfc_sli *psli = &phba->sli;
+	uint32_t intr_mode;
+
+	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
+	if (pci_enable_device_mem(pdev)) {
+		printk(KERN_ERR "lpfc: Cannot re-enable "
+			"PCI device after reset.\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	pci_restore_state(pdev);
+	if (pdev->is_busmaster)
+		pci_set_master(pdev);
+
+	spin_lock_irq(&phba->hbalock);
+	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Configure and enable interrupt */
+	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
+	if (intr_mode == LPFC_INTR_ERROR) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2824 Cannot re-enable interrupt after "
+				"slot reset.\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	} else
+		phba->intr_mode = intr_mode;
+
+	/* Log the current active interrupt mode */
+	lpfc_log_intr_mode(phba, phba->intr_mode);
+
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
@@ -8511,7 +8660,27 @@ lpfc_io_slot_reset_s4(struct pci_dev *pd
 static void
 lpfc_io_resume_s4(struct pci_dev *pdev)
 {
-	return;
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	/*
+	 * In case of slot reset, as function reset is performed through
+	 * mailbox command which needs DMA to be enabled, this operation
+	 * has to be moved to the io resume phase. Taking device offline
+	 * will perform the necessary cleanup.
+	 */
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE)) {
+		/* Perform device reset */
+		lpfc_offline_prep(phba);
+		lpfc_offline(phba);
+		lpfc_sli_brdrestart(phba);
+		/* Bring the device back online */
+		lpfc_online(phba);
+	}
+
+	/* Clean up Advanced Error Reporting (AER) if needed */
+	if (phba->hba_flag & HBA_AER_ENABLED)
+		pci_cleanup_aer_uncorrect_error_status(pdev);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-06-08 12:01:16.000000000 -0400
@@ -2295,15 +2295,21 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	struct lpfc_vport      *vport = pIocbIn->vport;
 	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
-	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	struct scsi_cmnd *cmd;
 	int result;
 	struct scsi_device *tmp_sdev;
 	int depth;
 	unsigned long flags;
 	struct lpfc_fast_path_event *fast_path_evt;
-	struct Scsi_Host *shost = cmd->device->host;
+	struct Scsi_Host *shost;
 	uint32_t queue_depth, scsi_id;
 
+	/* Sanity check on return of outstanding command */
+	if (!(lpfc_cmd->pCmd))
+		return;
+	cmd = lpfc_cmd->pCmd;
+	shost = cmd->device->host;
+
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
 	/* pick up SLI4 exhange busy status from HBA */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-06-08 12:01:16.000000000 -0400
@@ -382,6 +382,7 @@ struct lpfc_sli4_hba {
 	struct lpfc_pc_sli4_params pc_sli4_params;
 	struct msix_entry *msix_entries;
 	uint32_t cfg_eqn;
+	uint32_t msix_vec_nr;
 	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
 	/* Pointers to the constructed SLI4 queues */
 	struct lpfc_queue **fp_eq; /* Fast-path event queue */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-06-07 19:15:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-06-08 12:01:16.000000000 -0400
@@ -3593,13 +3593,16 @@ static int
 lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
-
+	uint32_t hba_aer_enabled;
 
 	/* Restart HBA */
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"0296 Restart HBA Data: x%x x%x\n",
 			phba->pport->port_state, psli->sli_flag);
 
+	/* Take PCIe device Advanced Error Reporting (AER) state */
+	hba_aer_enabled = phba->hba_flag & HBA_AER_ENABLED;
+
 	lpfc_sli4_brdreset(phba);
 
 	spin_lock_irq(&phba->hbalock);
@@ -3611,6 +3614,10 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *
 	memset(&psli->lnk_stat_offsets, 0, sizeof(psli->lnk_stat_offsets));
 	psli->stats_start = get_seconds();
 
+	/* Reset HBA AER if it was enabled, note hba_flag was reset above */
+	if (hba_aer_enabled)
+		pci_disable_pcie_error_reporting(phba->pcidev);
+
 	lpfc_hba_down_post(phba);
 
 	return 0;
@@ -4554,6 +4561,24 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	/* Start error attention (ERATT) polling timer */
 	mod_timer(&phba->eratt_poll, jiffies + HZ * LPFC_ERATT_POLL_INTERVAL);
 
+	/* Enable PCIe device Advanced Error Reporting (AER) if configured */
+	if (phba->cfg_aer_support == 1 && !(phba->hba_flag & HBA_AER_ENABLED)) {
+		rc = pci_enable_pcie_error_reporting(phba->pcidev);
+		if (!rc) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2829 This device supports "
+					"Advanced Error Reporting (AER)\n");
+			spin_lock_irq(&phba->hbalock);
+			phba->hba_flag |= HBA_AER_ENABLED;
+			spin_unlock_irq(&phba->hbalock);
+		} else {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2830 This device does not support "
+					"Advanced Error Reporting (AER)\n");
+			phba->cfg_aer_support = 0;
+		}
+	}
+
 	/*
 	 * The port is ready, set the host's link state to LINK_DOWN
 	 * in preparation for link interrupts.
@@ -9089,9 +9114,10 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba 
 		}
 	}
 	if (unlikely(!cq)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0365 Slow-path CQ identifier (%d) does "
-				"not exist\n", cqid);
+		if (phba->sli.sli_flag & LPFC_SLI_ACTIVE)
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"0365 Slow-path CQ identifier "
+					"(%d) does not exist\n", cqid);
 		return;
 	}
 
@@ -9321,9 +9347,10 @@ lpfc_sli4_fp_handle_eqe(struct lpfc_hba 
 
 	cq = phba->sli4_hba.fcp_cq[fcp_cqidx];
 	if (unlikely(!cq)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0367 Fast-path completion queue does not "
-				"exist\n");
+		if (phba->sli.sli_flag & LPFC_SLI_ACTIVE)
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"0367 Fast-path completion queue "
+					"does not exist\n");
 		return;
 	}
 


