From: linas@austin.ibm.com (Linas Vepstas)
Subject: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Fri, 20 Apr 2007 15:47:20 -0500
Message-ID: <20070420204720.GM31947@austin.ibm.com>
References: <20070420204114.GL31947@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47757 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbXDTUr1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2007 16:47:27 -0400
Content-Disposition: inline
In-Reply-To: <20070420204114.GL31947@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz


Implement the so-called "first failure data capture" (FFDC) for the
symbios PCI error recovery.  After a PCI error event is reported,
the driver requests that MMIO be enabled. Once enabled, it 
then reads and dumps assorted status registers, and concludes
by requesting the usual reset sequence.

(includes a whitespace fix for bad indentation).

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>

----
 drivers/scsi/sym53c8xx_2/sym_glue.c |   15 +++++++++++++++
 drivers/scsi/sym53c8xx_2/sym_glue.h |    1 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   18 ++++++++++++++----
 3 files changed, 30 insertions(+), 4 deletions(-)

Index: linux-2.6.21-rc4-git4/drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
--- linux-2.6.21-rc4-git4.orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-04-20 12:52:01.000000000 -0500
+++ linux-2.6.21-rc4-git4/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-04-20 15:25:35.000000000 -0500
@@ -1987,6 +1987,20 @@ static pci_ers_result_t sym2_io_error_de
 	disable_irq(pdev->irq);
 	pci_disable_device(pdev);
 
+	/* Request that MMIO be enabled, so register dump can be taken. */
+	return PCI_ERS_RESULT_CAN_RECOVER;
+}
+
+/**
+ * sym2_io_slot_dump -- Enable MMIO and dump debug registers
+ * @pdev: pointer to PCI device
+ */
+static pci_ers_result_t sym2_io_slot_dump (struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	sym_dump_registers(np);
+
 	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
@@ -2241,6 +2255,7 @@ MODULE_DEVICE_TABLE(pci, sym2_id_table);
 
 static struct pci_error_handlers sym2_err_handler = {
 	.error_detected = sym2_io_error_detected,
+	.mmio_enabled = sym2_io_slot_dump,
 	.slot_reset = sym2_io_slot_reset,
 	.resume = sym2_io_resume,
 };
Index: linux-2.6.21-rc4-git4/drivers/scsi/sym53c8xx_2/sym_glue.h
===================================================================
--- linux-2.6.21-rc4-git4.orig/drivers/scsi/sym53c8xx_2/sym_glue.h	2007-04-20 12:15:07.000000000 -0500
+++ linux-2.6.21-rc4-git4/drivers/scsi/sym53c8xx_2/sym_glue.h	2007-04-20 15:21:31.000000000 -0500
@@ -270,5 +270,6 @@ void sym_xpt_async_bus_reset(struct sym_
 void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target);
 int  sym_setup_data_and_start (struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
 void sym_log_bus_error(struct sym_hcb *np);
+void sym_dump_registers(struct sym_hcb *np);
 
 #endif /* SYM_GLUE_H */
Index: linux-2.6.21-rc4-git4/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- linux-2.6.21-rc4-git4.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-04-20 12:18:59.000000000 -0500
+++ linux-2.6.21-rc4-git4/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-04-20 15:18:01.000000000 -0500
@@ -1180,10 +1180,10 @@ static void sym_log_hard_error(struct sy
 			scr_to_cpu((int) *(u32 *)(script_base + script_ofs)));
 	}
 
-        printf ("%s: regdump:", sym_name(np));
-        for (i=0; i<24;i++)
-            printf (" %02x", (unsigned)INB_OFF(np, i));
-        printf (".\n");
+	printf ("%s: regdump:", sym_name(np));
+	for (i=0; i<24;i++)
+	    printf (" %02x", (unsigned)INB_OFF(np, i));
+	printf (".\n");
 
 	/*
 	 *  PCI BUS error.
@@ -1192,6 +1192,16 @@ static void sym_log_hard_error(struct sy
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
