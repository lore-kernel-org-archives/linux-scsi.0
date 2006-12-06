From: linas@austin.ibm.com (Linas Vepstas)
Subject: [PATCH] lpfc: add PCI error recovery support
Date: Wed, 6 Dec 2006 14:16:31 -0600
Message-ID: <20061206201631.GF17931@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:58251 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937604AbWLFUQg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 15:16:36 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kB6KGXLg021945
	for <linux-scsi@vger.kernel.org>; Wed, 6 Dec 2006 15:16:33 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kB6KGWZp454264
	for <linux-scsi@vger.kernel.org>; Wed, 6 Dec 2006 13:16:32 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kB6KGVZt021779
	for <linux-scsi@vger.kernel.org>; Wed, 6 Dec 2006 13:16:32 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, rlary@us.ibm.com


James,

Please review the patch below. Presuming that you lke it,
please forward upstream.

--linas

This patch adds PCI Error recovery support to the 
Emulex Lightpulse Fibrechannel (lpfc) SCSI device driver.
Lightly tested at this point, works.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James Smart <james.smart@emulex.com>

----

 drivers/scsi/lpfc/lpfc_init.c |   91 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

Index: linux-2.6.19-git7/drivers/scsi/lpfc/lpfc_init.c
===================================================================
--- linux-2.6.19-git7.orig/drivers/scsi/lpfc/lpfc_init.c	2006-12-06 13:31:39.000000000 -0600
+++ linux-2.6.19-git7/drivers/scsi/lpfc/lpfc_init.c	2006-12-06 13:33:49.000000000 -0600
@@ -517,6 +517,11 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 	struct lpfc_sli_ring  *pring;
 	uint32_t event_data;
 
+	/* If the pci channel is offline, ignore possible errors,
+	 * since we cannot communicate with the pci card anyway. */
+	if (pci_channel_offline(phba->pcidev))
+		return;
+
 	if (phba->work_hs & HS_FFER6) {
 		/* Re-establishing Link */
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
@@ -1825,6 +1830,85 @@ lpfc_pci_remove_one(struct pci_dev *pdev
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
+                        pci_channel_state_t state)
+{
+	if (state == pci_channel_io_perm_failure) {
+		lpfc_pci_remove_one(pdev);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+	pci_disable_device(pdev);
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
+	struct lpfc_sli_ring  *pring;
+
+	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
+	if (pci_enable_device(pdev)) {
+		printk(KERN_ERR "lpfc: Cannot re-enable PCI device after reset.\n");
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
+	/*
+	 * There may be I/Os dropped by the firmware.
+	 * Error iocb (I/O) on txcmplq and let the SCSI layer
+	 * retry it after re-establishing link.
+	 */
+	pring = &psli->ring[psli->fcp_ring];
+	lpfc_sli_abort_iocb_ring(phba, pring);
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
+	lpfc_online(phba);
+	mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
+}
+
 static struct pci_device_id lpfc_id_table[] = {
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
 		PCI_ANY_ID, PCI_ANY_ID, },
@@ -1885,11 +1969,18 @@ static struct pci_device_id lpfc_id_tabl
 
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
