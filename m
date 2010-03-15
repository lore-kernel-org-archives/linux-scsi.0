From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/6] lpfc 8.3.11: Fix AER uncorrectable non-fatal error
 handling
Date: Mon, 15 Mar 2010 11:25:32 -0400
Message-ID: <1268666732.31367.16.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:57397 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965209Ab0COPZz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 11:25:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix AER uncorrectable non-fatal error handling:

Only abort outstanding I/O to force the OS to retry failed I/Os for AER
uncorrectable non-fatal errors instead of reseting the adapter.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   50 +++++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 23 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-03-15 10:32:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-03-15 10:32:25.000000000 -0400
@@ -7763,21 +7763,23 @@ lpfc_pci_resume_one_s3(struct pci_dev *p
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is called to prepare the SLI3 device for PCI slot recover. It
- * aborts and stops all the on-going I/Os on the pci device.
+ * aborts all the outstanding SCSI I/Os to the pci device.
  **/
 static void
 lpfc_sli_prep_dev_for_recover(struct lpfc_hba *phba)
 {
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring  *pring;
+
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2723 PCI channel I/O abort preparing for recovery\n");
-	/* Prepare for bringing HBA offline */
-	lpfc_offline_prep(phba);
-	/* Clear sli active flag to prevent sysfs access to HBA */
-	spin_lock_irq(&phba->hbalock);
-	phba->sli.sli_flag &= ~LPFC_SLI_ACTIVE;
-	spin_unlock_irq(&phba->hbalock);
-	/* Stop and flush all I/Os and bring HBA offline */
-	lpfc_offline(phba);
+
+	/*
+	 * There may be errored I/Os through HBA, abort all I/Os on txcmplq
+	 * and let the SCSI mid-layer to retry them to recover.
+	 */
+	pring = &psli->ring[psli->fcp_ring];
+	lpfc_sli_abort_iocb_ring(phba, pring);
 }
 
 /**
@@ -7791,21 +7793,20 @@ lpfc_sli_prep_dev_for_recover(struct lpf
 static void
 lpfc_sli_prep_dev_for_reset(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring  *pring;
-
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2710 PCI channel disable preparing for reset\n");
+
+	/* Block all SCSI devices' I/Os on the host */
+	lpfc_scsi_dev_block(phba);
+
+	/* stop all timers */
+	lpfc_stop_hba_timers(phba);
+
 	/* Disable interrupt and pci device */
 	lpfc_sli_disable_intr(phba);
 	pci_disable_device(phba->pcidev);
-	/*
-	 * There may be I/Os dropped by the firmware.
-	 * Error iocb (I/O) on txcmplq and let the SCSI layer
-	 * retry it after re-establishing link.
-	 */
-	pring = &psli->ring[psli->fcp_ring];
-	lpfc_sli_abort_iocb_ring(phba, pring);
+	/* Flush all driver's outstanding SCSI I/Os as we are to reset */
+	lpfc_sli_flush_fcp_rings(phba);
 }
 
 /**
@@ -7821,6 +7822,12 @@ lpfc_prep_dev_for_perm_failure(struct lp
 {
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2711 PCI channel permanent disable for failure\n");
+	/* Block all SCSI devices' I/Os on the host */
+	lpfc_scsi_dev_block(phba);
+
+	/* stop all timers */
+	lpfc_stop_hba_timers(phba);
+
 	/* Clean up all driver's outstanding SCSI I/Os */
 	lpfc_sli_flush_fcp_rings(phba);
 }
@@ -7849,9 +7856,6 @@ lpfc_io_error_detected_s3(struct pci_dev
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
-	/* Block all SCSI devices' I/Os on the host */
-	lpfc_scsi_dev_block(phba);
-
 	switch (state) {
 	case pci_channel_io_normal:
 		/* Non-fatal error, prepare for recovery */
@@ -7958,7 +7962,7 @@ lpfc_io_resume_s3(struct pci_dev *pdev)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
-	/* Bring the device online */
+	/* Bring device online, it will be no-op for non-fatal error resume */
 	lpfc_online(phba);
 
 	/* Clean up Advanced Error Reporting (AER) if needed */


