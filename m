From: akpm@linux-foundation.org
Subject: [patch 4/7] PCI Error Recovery: Symbios SCSI base support
Date: Tue, 16 Oct 2007 14:28:21 -0700
Message-ID: <200710162128.l9GLSLVE018173@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754470AbXJPV3y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 17:29:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linas@austin.ibm.com, willy@debian.org

From: Linas Vepstas <linas@austin.ibm.com>

Various PCI bus errors can be signaled by newer PCI controllers.  This
patch adds the PCI error recovery callbacks to the Symbios SCSI device
driver.  The patch has been tested, and appears to work well.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sym53c8xx_2/sym_glue.c |  136 ++++++++++++++++++++++++++
 drivers/scsi/sym53c8xx_2/sym_glue.h |    4 
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    6 +
 3 files changed, 146 insertions(+)

diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~pci-error-recovery-symbios-scsi-base-support drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c~pci-error-recovery-symbios-scsi-base-support
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -596,6 +596,10 @@ static irqreturn_t sym53c8xx_intr(int ir
 	unsigned long flags;
 	struct sym_hcb *np = (struct sym_hcb *)dev_id;
 
+	/* Avoid spinloop trying to handle interrupts on frozen device */
+	if (pci_channel_offline(np->s.device))
+		return IRQ_HANDLED;
+
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
 	spin_lock_irqsave(np->s.host->host_lock, flags);
@@ -665,6 +669,20 @@ static int sym_eh_handler(int op, char *
 
 	dev_warn(&cmd->device->sdev_gendev, "%s operation started.\n", opname);
 
+	/* We may be in an error condition because the PCI bus
+	 * went down. In this case, we need to wait until the
+	 * PCI bus is reset, the card is reset, and only then
+	 * proceed with the scsi error recovery.  There's no
+	 * point in hurrying; take a leisurely wait.
+	 */
+#define WAIT_FOR_PCI_RECOVERY	35
+	if (pci_channel_offline(np->s.device)) {
+		int finished_reset = wait_for_completion_timeout(
+			&np->s.io_reset_wait, WAIT_FOR_PCI_RECOVERY*HZ);
+		if (!finished_reset)
+			return SCSI_FAILED;
+	}
+
 	spin_lock_irq(host->host_lock);
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
@@ -1449,6 +1467,7 @@ static struct Scsi_Host * __devinit sym_
 	np->maxoffs	= dev->chip.offset_max;
 	np->maxburst	= dev->chip.burst_max;
 	np->myaddr	= dev->host_id;
+	init_completion(&np->s.io_reset_wait);
 
 	/*
 	 *  Edit its name.
@@ -1888,6 +1907,116 @@ static void __devexit sym2_remove(struct
 	attach_count--;
 }
 
+/**
+ * sym2_io_error_detected() -- called when PCI error is detected
+ * @pdev: pointer to PCI device
+ * @state: current state of the PCI slot
+ */
+static pci_ers_result_t sym2_io_error_detected(struct pci_dev *pdev,
+                                         enum pci_channel_state state)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	/* If slot is permanently frozen, turn everything off */
+	if (state == pci_channel_io_perm_failure) {
+		sym2_remove(pdev);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	init_completion(&np->s.io_reset_wait);
+	disable_irq(pdev->irq);
+	pci_disable_device(pdev);
+
+	/* Request a slot reset. */
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ * sym2_reset_workarounds -- hardware-specific work-arounds
+ *
+ * This routine is similar to sym_set_workarounds(), except
+ * that, at this point, we already know that the device was
+ * succesfully intialized at least once before, and so most
+ * of the steps taken there are un-needed here.
+ */
+static void sym2_reset_workarounds(struct pci_dev *pdev)
+{
+	u_char revision;
+	u_short status_reg;
+	struct sym_chip *chip;
+
+	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
+	chip = sym_lookup_chip_table(pdev->device, revision);
+
+	/* Work around for errant bit in 895A, in a fashion
+	 * similar to what is done in sym_set_workarounds().
+	 */
+	pci_read_config_word(pdev, PCI_STATUS, &status_reg);
+	if (!(chip->features & FE_66MHZ) && (status_reg & PCI_STATUS_66MHZ)) {
+	 	status_reg = PCI_STATUS_66MHZ;
+		pci_write_config_word(pdev, PCI_STATUS, status_reg);
+		pci_read_config_word(pdev, PCI_STATUS, &status_reg);
+	}
+}
+
+/**
+ * sym2_io_slot_reset() -- called when the pci bus has been reset.
+ * @pdev: pointer to PCI device
+ *
+ * Restart the card from scratch.
+ */
+static pci_ers_result_t sym2_io_slot_reset(struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	printk(KERN_INFO "%s: recovering from a PCI slot reset\n",
+	          sym_name(np));
+
+	if (pci_enable_device(pdev)) {
+		printk(KERN_ERR "%s: Unable to enable afer PCI reset\n",
+		        sym_name(np));
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	pci_set_master(pdev);
+	enable_irq(pdev->irq);
+
+	/* If the chip can do Memory Write Invalidate, enable it */
+	if (np->features & FE_WRIE) {
+		if (pci_set_mwi(pdev))
+				return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	/* Perform work-arounds, analogous to sym_set_workarounds() */
+	sym2_reset_workarounds(pdev);
+
+	/* Perform host reset only on one instance of the card */
+	if (PCI_FUNC (pdev->devfn) == 0) {
+		if (sym_reset_scsi_bus(np, 0)) {
+			printk(KERN_ERR "%s: Unable to reset scsi host\n",
+			        sym_name(np));
+			return PCI_ERS_RESULT_DISCONNECT;
+		}
+		sym_start_up(np, 1);
+	}
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+/**
+ * sym2_io_resume() -- resume normal ops after PCI reset
+ * @pdev: pointer to PCI device
+ *
+ * Called when the error recovery driver tells us that its
+ * OK to resume normal operation. Use completion to allow
+ * halted scsi ops to resume.
+ */
+static void sym2_io_resume(struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+	complete_all(&np->s.io_reset_wait);
+}
+
 static void sym2_get_signalling(struct Scsi_Host *shost)
 {
 	struct sym_hcb *np = sym_get_hcb(shost);
@@ -2050,11 +2179,18 @@ static struct pci_device_id sym2_id_tabl
 
 MODULE_DEVICE_TABLE(pci, sym2_id_table);
 
+static struct pci_error_handlers sym2_err_handler = {
+	.error_detected = sym2_io_error_detected,
+	.slot_reset = sym2_io_slot_reset,
+	.resume = sym2_io_resume,
+};
+
 static struct pci_driver sym2_driver = {
 	.name		= NAME53C8XX,
 	.id_table	= sym2_id_table,
 	.probe		= sym2_probe,
 	.remove		= __devexit_p(sym2_remove),
+	.err_handler 	= &sym2_err_handler,
 };
 
 static int __init sym2_init(void)
diff -puN drivers/scsi/sym53c8xx_2/sym_glue.h~pci-error-recovery-symbios-scsi-base-support drivers/scsi/sym53c8xx_2/sym_glue.h
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h~pci-error-recovery-symbios-scsi-base-support
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -40,6 +40,7 @@
 #ifndef SYM_GLUE_H
 #define SYM_GLUE_H
 
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
@@ -179,6 +180,9 @@ struct sym_shcb {
 	char		chip_name[8];
 	struct pci_dev	*device;
 
+	/* Waiter for clearing of frozen PCI bus */
+	struct completion io_reset_wait;
+
 	struct Scsi_Host *host;
 
 	void __iomem *	ioaddr;		/* MMIO kernel io address	*/
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~pci-error-recovery-symbios-scsi-base-support drivers/scsi/sym53c8xx_2/sym_hipd.c
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c~pci-error-recovery-symbios-scsi-base-support
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -2809,6 +2809,12 @@ void sym_interrupt (struct sym_hcb *np)
 			dstat |= INB(np, nc_dstat);
 		istatc = INB(np, nc_istat);
 		istat |= istatc;
+
+		/* Prevent deadlock waiting on a condition that may never clear. */
+		if (unlikely(sist == 0xffff && dstat == 0xff)) {
+			if (pci_channel_offline(np->s.device))
+				return;
+		}
 	} while (istatc & (SIP|DIP));
 
 	if (DEBUG_FLAGS & DEBUG_TINY)
_
