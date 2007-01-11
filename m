From: Bino.Sebastian@Emulex.Com
Subject: RE: lpfc PCIe error recoveyr
Date: Thu, 11 Jan 2007 09:25:30 -0500
Message-ID: <332A49C36DB0F64198D1A011FB1AA79132A7F2@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41545 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965359AbXAKOid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 09:38:33 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linas@austin.ibm.com
Cc: James.Smart@Emulex.Com, rlary@us.ibm.com, Laurie.Barry@Emulex.Com, strosake@us.ibm.com, vaios.papadimitriou@Emulex.Com, linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-scsi@vger.kernel.org

I looks like there is a recursion in the stack trace.
scsi_request_fn is called recursively.

-bino

-----Original Message-----
From: Linas Vepstas [mailto:linas@austin.ibm.com]
Sent: Wednesday, January 10, 2007 6:00 PM
To: Sebastian, Bino
Cc: Smart, James; rlary@us.ibm.com; Barry, Laurie; strosake@us.ibm.com;
Papadimitriou, Vaios; linuxppc-dev@ozlabs.org;
linux-pci@atrey.karlin.mff.cuni.cz; linux-scsi@vger.kernel.org
Subject: Re: lpfc PCIe error recoveyr


On Tue, Jan 09, 2007 at 10:00:09AM -0500, Bino.Sebastian@Emulex.Com wrote:
> Hi Linas,
> 	Following is the latest lpfc driver patch we are testing in the 
> Emulex lab for PCI error recovery. This patch looks good on a Power5 
> platform. 

Yes, it seemed to survive a few hours of testting fine. I did see one
interesting thing, namely a softlockup. I attribute this to the fact
that I'd queued up a lot of heavy file i/o, issued a sync, which
typically takes more than a few seconds on the test sytem, and then 
injected the artificial PCI error. After about ten seconds, I got the 
softlockup, but after another 10-20 seconds, things seemed back to
normal. So I don't consider this an actual error, but thought 
it was interesting.

The actual stack trace was

BUG: soft lockup detected on CPU#2!
Call Trace:
[C00000000253D470] [C00000000000F8C8] .show_stack+0x68/0x1b0 (unreliable)
[C00000000253D510] [C00000000008E770] .softlockup_tick+0xec/0x124
[C00000000253D5B0] [C00000000006957C] .run_local_timers+0x1c/0x30
[C00000000253D630] [C000000000023C18] .timer_interrupt+0xb8/0x4a4
[C00000000253D710] [C000000000003578] decrementer_common+0xf8/0x100
--- Exception: 901 at .local_irq_restore+0x3c/0x40
    LR = ._spin_unlock_irqrestore+0x24/0x3c
[C00000000253DA00] [C00000000046D574] ._spin_unlock_irqrestore+0x18/0x3c (unreliable)
[C00000000253DA90] [C00000000031BBA0] .scsi_dispatch_cmd+0x25c/0x2e4
[C00000000253DB30] [C0000000003227CC] .scsi_request_fn+0x2c4/0x3c0
[C00000000253DBE0] [C00000000021ADF8] .__generic_unplug_device+0x54/0x6c
[C00000000253DC60] [C000000000216D34] .elv_insert+0x240/0x268
[C00000000253DD00] [C00000000021A224] .blk_requeue_request+0x38/0x54
[C00000000253DD90] [C00000000032282C] .scsi_request_fn+0x324/0x3c0
[C00000000253DE40] [C00000000021ADF8] .__generic_unplug_device+0x54/0x6c
[C00000000253DEC0] [C000000000216D34] .elv_insert+0x240/0x268
[C00000000253DF60] [C00000000021A224] .blk_requeue_request+0x38/0x54
[C00000000253DFF0] [C00000000032282C] .scsi_request_fn+0x324/0x3c0
[C00000000253E0A0] [C00000000021ADF8] .__generic_unplug_device+0x54/0x6c
etc.

> However, on a Power4 architecture there are errors reported
> in upper layer (we discussed this in one of earlier emails) followed 
> by SCSI errors.

I'm trying to investigate now.

The patch you sent out got garbled, so I'm reposting below.

----

This patch adds PCI Error recovery support to the
Emulex Lightpulse Fibrechannel (lpfc) SCSI device driver.
Lightly tested at this point, works.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Bino.Sebastian@Emulex.Com
Cc: James Smart <james.smart@emulex.com>

----

 drivers/scsi/lpfc/lpfc_init.c |   96 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c  |   12 +++++
 2 files changed, 108 insertions(+)

Index: linux-2.6.20-rc4/drivers/scsi/lpfc/lpfc_init.c
===================================================================
--- linux-2.6.20-rc4.orig/drivers/scsi/lpfc/lpfc_init.c	2007-01-10 12:30:01.000000000 -0600
+++ linux-2.6.20-rc4/drivers/scsi/lpfc/lpfc_init.c	2007-01-10 12:34:27.000000000 -0600
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
@@ -1797,6 +1801,91 @@ lpfc_pci_remove_one(struct pci_dev *pdev
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
+
+	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
+	if (pci_enable_device(pdev)) {
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
@@ -1857,11 +1946,18 @@ static struct pci_device_id lpfc_id_tabl
 
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
Index: linux-2.6.20-rc4/drivers/scsi/lpfc/lpfc_sli.c
===================================================================
--- linux-2.6.20-rc4.orig/drivers/scsi/lpfc/lpfc_sli.c	2007-01-08 17:55:41.000000000 -0600
+++ linux-2.6.20-rc4/drivers/scsi/lpfc/lpfc_sli.c	2007-01-10 12:34:27.000000000 -0600
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
