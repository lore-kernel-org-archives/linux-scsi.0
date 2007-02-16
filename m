From: akpm@linux-foundation.org
Subject: [patch 30/30] lpfc: add PCI error recovery support
Date: Fri, 16 Feb 2007 01:46:48 -0800
Message-ID: <200702160946.l1G9knw1026716@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36894 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423515AbXBPJq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:46:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linas@austin.ibm.com, james.smart@emulex.com

From: Linas Vepstas <linas@austin.ibm.com>

Add PCI Error recovery support to the Emulex Lightpulse Fibrechannel (lpfc)
SCSI device driver.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Bino.Sebastian@Emulex.Com
Acked-by: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_init.c |   97 ++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c  |   12 +++
 2 files changed, 109 insertions(+)

diff -puN drivers/scsi/lpfc/lpfc_init.c~lpfc-add-pci-error-recovery-support drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~lpfc-add-pci-error-recovery-support
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -518,6 +518,10 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
 	uint32_t event_data;
+	/* If the pci channel is offline, ignore possible errors,
+	 * since we cannot communicate with the pci card anyway. */
+	if (pci_channel_offline(phba->pcidev))
+		return;
 
 	if (phba->work_hs & HS_FFER6 ||
 	    phba->work_hs & HS_FFER5) {
@@ -1797,6 +1801,92 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	pci_set_drvdata(pdev, NULL);
 }
 
+/**
+ * lpfc_io_error_detected - called when PCI error is detected
+ * @pdev: Pointer to PCI device
+ * @state: The current pci conneection state
+ *
+ * This function is called after a PCI bus error affecting
+ * this device has been detected.
+ */
+static pci_ers_result_t lpfc_io_error_detected(struct pci_dev *pdev,
+				pci_channel_state_t state)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring  *pring;
+
+	if (state == pci_channel_io_perm_failure) {
+		lpfc_pci_remove_one(pdev);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+	pci_disable_device(pdev);
+	/*
+	 * There may be I/Os dropped by the firmware.
+	 * Error iocb (I/O) on txcmplq and let the SCSI layer
+	 * retry it after re-establishing link.
+	 */
+	pring = &psli->ring[psli->fcp_ring];
+	lpfc_sli_abort_iocb_ring(phba, pring);
+
+	/* Request a slot reset. */
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ * lpfc_io_slot_reset - called after the pci bus has been reset.
+ * @pdev: Pointer to PCI device
+ *
+ * Restart the card from scratch, as if from a cold-boot.
+ */
+static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata;
+	struct lpfc_sli *psli = &phba->sli;
+	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
+
+	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
+	if (pci_enable_device_bars(pdev, bars)) {
+		printk(KERN_ERR "lpfc: Cannot re-enable "
+			"PCI device after reset.\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	pci_set_master(pdev);
+
+	/* Re-establishing Link */
+	spin_lock_irq(phba->host->host_lock);
+	phba->fc_flag |= FC_ESTABLISH_LINK;
+	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	spin_unlock_irq(phba->host->host_lock);
+
+
+	/* Take device offline; this will perform cleanup */
+	lpfc_offline(phba);
+	lpfc_sli_brdrestart(phba);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+/**
+ * lpfc_io_resume - called when traffic can start flowing again.
+ * @pdev: Pointer to PCI device
+ *
+ * This callback is called when the error recovery driver tells us that
+ * its OK to resume normal operation.
+ */
+static void lpfc_io_resume(struct pci_dev *pdev)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata;
+
+	if (lpfc_online(phba) == 0) {
+		mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
+	}
+}
+
 static struct pci_device_id lpfc_id_table[] = {
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
 		PCI_ANY_ID, PCI_ANY_ID, },
@@ -1857,11 +1947,18 @@ static struct pci_device_id lpfc_id_tabl
 
 MODULE_DEVICE_TABLE(pci, lpfc_id_table);
 
+static struct pci_error_handlers lpfc_err_handler = {
+	.error_detected = lpfc_io_error_detected,
+	.slot_reset = lpfc_io_slot_reset,
+	.resume = lpfc_io_resume,
+};
+
 static struct pci_driver lpfc_driver = {
 	.name		= LPFC_DRIVER_NAME,
 	.id_table	= lpfc_id_table,
 	.probe		= lpfc_pci_probe_one,
 	.remove		= __devexit_p(lpfc_pci_remove_one),
+	.err_handler = &lpfc_err_handler,
 };
 
 static int __init
diff -puN drivers/scsi/lpfc/lpfc_sli.c~lpfc-add-pci-error-recovery-support drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c~lpfc-add-pci-error-recovery-support
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -2104,6 +2104,10 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 	volatile uint32_t word0, ldata;
 	void __iomem *to_slim;
 
+	/* If the PCI channel is in offline state, do not post mbox. */
+	if (unlikely(pci_channel_offline(phba->pcidev)))
+		return MBX_NOT_FINISHED;
+
 	psli = &phba->sli;
 
 	spin_lock_irqsave(phba->host->host_lock, drvr_flag);
@@ -2407,6 +2411,10 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
 	struct lpfc_iocbq *nextiocb;
 	IOCB_t *iocb;
 
+	/* If the PCI channel is in offline state, do not post iocbs. */
+	if (unlikely(pci_channel_offline(phba->pcidev)))
+		return IOCB_ERROR;
+
 	/*
 	 * We should never get an IOCB if we are in a < LINK_DOWN state
 	 */
@@ -3154,6 +3162,10 @@ lpfc_intr_handler(int irq, void *dev_id)
 	if (unlikely(!phba))
 		return IRQ_NONE;
 
+	/* If the pci channel is offline, ignore all the interrupts. */
+	if (unlikely(pci_channel_offline(phba->pcidev)))
+		return IRQ_NONE;
+
 	phba->sli.slistat.sli_intr++;
 
 	/*
_
