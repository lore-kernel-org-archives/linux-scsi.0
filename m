From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 7/17] sym53c8xx: PCI Error Recovery support
Date: Fri,  5 Oct 2007 15:55:04 -0400
Message-ID: <11916141142800-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:52953 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761332AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Linas Vepstas <linas@austin.ibm.com>, Matthew Wilcox <willy@linux.intel.com>

From: Linas Vepstas <linas@austin.ibm.com>

This patch adds the PCI error recovery callbacks to the Symbios SCSI device
driver.  It includes support for First Failure Data Capture.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>

Assorted changes to initial patches, including returning IRQ_NONE from the
interrupt handler if the device is offline and re-using the eh_done completion
in the scsi error handler.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |  179 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/sym53c8xx_2/sym_glue.h |    3 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   25 ++++-
 3 files changed, 200 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 6bc8789..fec9c9c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -134,7 +134,7 @@ static struct scsi_transport_template *sym2_transport_template = NULL;
  *  Driver private area in the SCSI command structure.
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
-	struct completion *eh_done;		/* For error handling */
+	struct completion *eh_done;		/* SCSI error handling */
 };
 
 #define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
@@ -556,6 +556,10 @@ static irqreturn_t sym53c8xx_intr(int irq, void *dev_id)
 {
 	struct sym_hcb *np = dev_id;
 
+	/* Avoid spinloop trying to handle interrupts on frozen device */
+	if (pci_channel_offline(np->s.device))
+		return IRQ_NONE;
+
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
 	spin_lock(np->s.host->host_lock);
@@ -598,6 +602,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
 	struct Scsi_Host *host = cmd->device->host;
+	struct pci_dev *pdev = np->s.device;
 	SYM_QUEHEAD *qp;
 	int cmd_queued = 0;
 	int sts = -1;
@@ -605,6 +610,38 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 
 	dev_warn(&cmd->device->sdev_gendev, "%s operation started.\n", opname);
 
+	/* We may be in an error condition because the PCI bus
+	 * went down. In this case, we need to wait until the
+	 * PCI bus is reset, the card is reset, and only then
+	 * proceed with the scsi error recovery.  There's no
+	 * point in hurrying; take a leisurely wait.
+	 */
+#define WAIT_FOR_PCI_RECOVERY	35
+	if (pci_channel_offline(pdev)) {
+		struct host_data *hostdata = shost_priv(host);
+		struct completion *io_reset;
+		int finished_reset = 0;
+		init_completion(&eh_done);
+		spin_lock_irq(host->host_lock);
+		/* Make sure we didn't race */
+		if (pci_channel_offline(pdev)) {
+			if (!hostdata->io_reset)
+				hostdata->io_reset = &eh_done;
+			io_reset = hostdata->io_reset;
+		} else {
+			io_reset = NULL;
+		}
+
+		if (!pci_channel_offline(pdev))
+			finished_reset = 1;
+		spin_unlock_irq(host->host_lock);
+		if (!finished_reset)
+			finished_reset = wait_for_completion_timeout(io_reset,
+						WAIT_FOR_PCI_RECOVERY*HZ);
+		if (!finished_reset)
+			return SCSI_FAILED;
+	}
+
 	spin_lock_irq(host->host_lock);
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
@@ -630,7 +667,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 		break;
 	case SYM_EH_HOST_RESET:
 		sym_reset_scsi_bus(np, 0);
-		sym_start_up (np, 1);
+		sym_start_up(np, 1);
 		sts = 0;
 		break;
 	default:
@@ -1435,7 +1472,7 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	/*
 	 *  Start the SCRIPTS.
 	 */
-	sym_start_up (np, 1);
+	sym_start_up(np, 1);
 
 	/*
 	 *  Start the timer daemon
@@ -1822,6 +1859,134 @@ static void __devexit sym2_remove(struct pci_dev *pdev)
 	attach_count--;
 }
 
+/**
+ * sym2_io_error_detected() - called when PCI error is detected
+ * @pdev: pointer to PCI device
+ * @state: current state of the PCI slot
+ */
+static pci_ers_result_t sym2_io_error_detected(struct pci_dev *pdev,
+                                         enum pci_channel_state state)
+{
+	/* If slot is permanently frozen, turn everything off */
+	if (state == pci_channel_io_perm_failure) {
+		sym2_remove(pdev);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	disable_irq(pdev->irq);
+	pci_disable_device(pdev);
+
+	/* Request that MMIO be enabled, so register dump can be taken. */
+	return PCI_ERS_RESULT_CAN_RECOVER;
+}
+
+/**
+ * sym2_io_slot_dump - Enable MMIO and dump debug registers
+ * @pdev: pointer to PCI device
+ */
+static pci_ers_result_t sym2_io_slot_dump(struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	sym_dump_registers(np);
+
+	/* Request a slot reset. */
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ * sym2_reset_workarounds - hardware-specific work-arounds
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
+		status_reg = PCI_STATUS_66MHZ;
+		pci_write_config_word(pdev, PCI_STATUS, status_reg);
+		pci_read_config_word(pdev, PCI_STATUS, &status_reg);
+	}
+}
+
+/**
+ * sym2_io_slot_reset() - called when the pci bus has been reset.
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
+		printk(KERN_ERR "%s: Unable to enable after PCI reset\n",
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
+			return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	/* Perform work-arounds, analogous to sym_set_workarounds() */
+	sym2_reset_workarounds(pdev);
+
+	/* Perform host reset only on one instance of the card */
+	if (PCI_FUNC(pdev->devfn) == 0) {
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
+ * sym2_io_resume() - resume normal ops after PCI reset
+ * @pdev: pointer to PCI device
+ *
+ * Called when the error recovery driver tells us that its
+ * OK to resume normal operation. Use completion to allow
+ * halted scsi ops to resume.
+ */
+static void sym2_io_resume(struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = np->s.host;
+	struct host_data *hostdata = shost_priv(shost);
+
+	spin_lock_irq(shost->host_lock);
+	if (hostdata->io_reset)
+		complete_all(hostdata->io_reset);
+	hostdata->io_reset = NULL;
+	spin_unlock_irq(shost->host_lock);
+}
+
 static void sym2_get_signalling(struct Scsi_Host *shost)
 {
 	struct sym_hcb *np = sym_get_hcb(shost);
@@ -1984,11 +2149,19 @@ static struct pci_device_id sym2_id_table[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(pci, sym2_id_table);
 
+static struct pci_error_handlers sym2_err_handler = {
+	.error_detected	= sym2_io_error_detected,
+	.mmio_enabled	= sym2_io_slot_dump,
+	.slot_reset	= sym2_io_slot_reset,
+	.resume		= sym2_io_resume,
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
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index bea7bcc..d5ba5aa 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -40,6 +40,7 @@
 #ifndef SYM_GLUE_H
 #define SYM_GLUE_H
 
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
@@ -220,6 +221,7 @@ struct sym_device {
  */
 struct host_data {
 	struct sym_hcb *ncb;
+	struct completion *io_reset;		/* PCI error handling */
 };
 
 static inline struct sym_hcb * sym_get_hcb(struct Scsi_Host *host)
@@ -265,5 +267,6 @@ void sym_xpt_async_bus_reset(struct sym_hcb *np);
 void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target);
 int  sym_setup_data_and_start (struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
 void sym_log_bus_error(struct sym_hcb *np);
+void sym_dump_registers(struct sym_hcb *np);
 
 #endif /* SYM_GLUE_H */
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 21cd4c7..af24c44 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1180,10 +1180,10 @@ static void sym_log_hard_error(struct sym_hcb *np, u_short sist, u_char dstat)
 			scr_to_cpu((int) *(u32 *)(script_base + script_ofs)));
 	}
 
-        printf ("%s: regdump:", sym_name(np));
-        for (i=0; i<24;i++)
-            printf (" %02x", (unsigned)INB_OFF(np, i));
-        printf (".\n");
+	printf("%s: regdump:", sym_name(np));
+	for (i = 0; i < 24; i++)
+		printf(" %02x", (unsigned)INB_OFF(np, i));
+	printf(".\n");
 
 	/*
 	 *  PCI BUS error.
@@ -1192,6 +1192,16 @@ static void sym_log_hard_error(struct sym_hcb *np, u_short sist, u_char dstat)
 		sym_log_bus_error(np);
 }
 
+void sym_dump_registers(struct sym_hcb *np)
+{
+	u_short sist;
+	u_char dstat;
+
+	sist = INW(np, nc_sist);
+	dstat = INB(np, nc_dstat);
+	sym_log_hard_error(np, sist, dstat);
+}
+
 static struct sym_chip sym_dev_table[] = {
  {PCI_DEVICE_ID_NCR_53C810, 0x0f, "810", 4, 8, 4, 64,
  FE_ERL}
@@ -2809,6 +2819,13 @@ void sym_interrupt (struct sym_hcb *np)
 			dstat |= INB(np, nc_dstat);
 		istatc = INB(np, nc_istat);
 		istat |= istatc;
+
+		/* Prevent deadlock waiting on a condition that may
+		 * never clear. */
+		if (unlikely(sist == 0xffff && dstat == 0xff)) {
+			if (pci_channel_offline(np->s.device))
+				return;
+		}
 	} while (istatc & (SIP|DIP));
 
 	if (DEBUG_FLAGS & DEBUG_TINY)
-- 
1.4.4.2

