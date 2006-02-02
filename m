From: linas@austin.ibm.com (Linas Vepstas)
Subject: [PATCH] PCI Error Recovery: Symbios SCSI device driver
Date: Thu, 2 Feb 2006 14:15:25 -0600
Message-ID: <20060202201525.GK24916@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:13997 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932206AbWBBUPt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2006 15:15:49 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k12KFj7G026993
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 15:15:45 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k12KFhxP219864
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 15:15:45 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k12KFhVb010985
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 15:15:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org


Hi Matthew,

Please review the patch below; if it looks good, please forward
upstream.  I beleive its been in the AKPM kernels for a while now.
A variant as also been shipping with SuSE SLES9 kernels for quite
a while. This version of the patch should have fixed up all of 
your previous comments/complaints. 

--linas

Formal description:

Various PCI bus errors can be signaled by newer PCI controllers.  This
patch adds the PCI error recovery callbacks to the Symbios SCSI device 
driver.  The patch has been tested, and appears to work well.

Signed-off-by: Linas Vepstas <linas@linas.org>

--

 sym_glue.c |  136 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 sym_glue.h |    4 +
 sym_hipd.c |   15 ++++++
 3 files changed, 155 insertions(+)

Index: linux-2.6.16-rc1-git5/drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
--- linux-2.6.16-rc1-git5.orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-01 17:09:16.000000000 -0600
+++ linux-2.6.16-rc1-git5/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-02 14:07:41.088534411 -0600
@@ -716,6 +716,10 @@
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
+	/* Avoid spinloop trying to handle interrupts on frozen device */
+	if (np->s.io_state != pci_channel_io_normal)
+		return IRQ_HANDLED;
+
 	spin_lock_irqsave(np->s.host->host_lock, flags);
 	sym_interrupt(np);
 	spin_unlock_irqrestore(np->s.host->host_lock, flags);
@@ -789,6 +793,25 @@
  */
 static void sym_eh_timeout(u_long p) { __sym_eh_done((struct scsi_cmnd *)p, 1); }
 
+static void sym_eeh_timeout(unsigned long p)
+{
+	struct sym_eh_wait *ep = (struct sym_eh_wait *) p;
+	if (!ep)
+		return;
+	complete(&ep->done);
+}
+
+static void sym_eeh_done(struct sym_eh_wait *ep)
+{
+	if (!ep)
+		return;
+	ep->timed_out = 0;
+	if (!del_timer(&ep->timer))
+		return;
+
+	complete(&ep->done);
+}
+
 /*
  *  Generic method for our eh processing.
  *  The 'op' argument tells what we have to do.
@@ -829,6 +852,36 @@
 
 	/* Try to proceed the operation we have been asked for */
 	sts = -1;
+
+	/* We may be in an error condition because the PCI bus
+	 * went down. In this case, we need to wait until the
+	 * PCI bus is reset, the card is reset, and only then
+	 * proceed with the scsi error recovery.  We'll wait
+	 * for 15 seconds for this to happen.
+	 */
+#define WAIT_FOR_PCI_RECOVERY	15
+	if (np->s.io_state != pci_channel_io_normal) {
+		struct sym_eh_wait eeh, *eep = &eeh;
+		np->s.io_reset_wait = eep;
+		init_completion(&eep->done);
+		init_timer(&eep->timer);
+		eep->to_do = SYM_EH_DO_WAIT;
+		eep->timer.expires = jiffies + (WAIT_FOR_PCI_RECOVERY*HZ);
+		eep->timer.function = sym_eeh_timeout;
+		eep->timer.data = (u_long)eep;
+		eep->timed_out = 1;	/* Be pessimistic for once :) */
+		add_timer(&eep->timer);
+		spin_unlock_irq(np->s.host->host_lock);
+		wait_for_completion(&eep->done);
+		spin_lock_irq(np->s.host->host_lock);
+		if (eep->timed_out) {
+			printk (KERN_ERR 
+				"%s: Timed out waiting for PCI reset\n", 
+				sym_name(np));
+		}
+		np->s.io_reset_wait = NULL;
+	}
+
 	switch(op) {
 	case SYM_EH_ABORT:
 		sts = sym_abort_scsiio(np, cmd, 1);
@@ -1630,6 +1683,8 @@
 	np->maxoffs	= dev->chip.offset_max;
 	np->maxburst	= dev->chip.burst_max;
 	np->myaddr	= dev->host_id;
+	np->s.io_state = pci_channel_io_normal;
+	np->s.io_reset_wait = NULL;
 
 	/*
 	 *  Edit its name.
@@ -1962,6 +2017,80 @@
 	return 1;
 }
 
+/**
+ * sym2_io_error_detected() - PCI error is detected
+ *
+ * Description: This routine is called shrtly after the PCI error
+ * recovery subsystem has detected a PCI bus error. At this point,
+ * all further i/o to te adapter will be fruitless, so hold off i/o.
+ * Basically, just queue up i/o and wait for the bus reset to happen.
+ */
+static pci_ers_result_t sym2_io_error_detected(struct pci_dev *pdev, 
+					                       enum pci_channel_state state)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	np->s.io_state = state;
+	/* If the reported state is "permanent failure", then
+	 * we should shut down the driver for good, and -EIO
+	 * all pending i/o requests. XXX Not implemented yet.
+	 * (Not sure how - should we scsi_remove_host() maybe ??)
+	 */
+
+	/* Request a slot slot reset. */
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ *  sym2_io_slot_reset - the pci bus has been reset.
+ *
+ *  Description: This routine is called after the PCI error
+ *  recovery system has completely reset the PCI slot. At
+ *  this point, I/O is possible, although the card has just
+ *  been reset, and is not yet initialized. A complete
+ *  restart is performed.
+ */
+static pci_ers_result_t sym2_io_slot_reset(struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	printk(KERN_INFO "%s: recovering from a PCI slot reset\n",
+	    sym_name(np));
+
+	if (pci_enable_device(pdev))
+		printk(KERN_ERR "%s: device setup failed most egregiously\n",
+			    sym_name(np));
+
+	pci_set_master(pdev);
+	enable_irq(pdev->irq);
+
+	/* Perform host reset only on one instance of the card */
+	if (PCI_FUNC(pdev->devfn) == 0)
+		sym_reset_scsi_bus(np, 0);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+/**
+ *  sym2_io_resume - pci error recovery completed.
+ *
+ *  Description: This routine is called when the PCI error
+ *  recovery has finished recovering this and all other
+ *  affects PCI cards. Normal I/O operations may resume.
+ *  Start handling any queued requests.
+ */
+static void sym2_io_resume(struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	/* Perform device startup only once for this card. */
+	if (PCI_FUNC(pdev->devfn) == 0)
+		sym_start_up(np, 1);
+
+	np->s.io_state = pci_channel_io_normal;
+	sym_eeh_done(np->s.io_reset_wait);
+}
+
 /*
  * Driver host template.
  */
@@ -2219,11 +2348,18 @@
 
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
+	.err_handler = &sym2_err_handler,
 };
 
 static int __init sym2_init(void)
Index: linux-2.6.16-rc1-git5/drivers/scsi/sym53c8xx_2/sym_glue.h
===================================================================
--- linux-2.6.16-rc1-git5.orig/drivers/scsi/sym53c8xx_2/sym_glue.h	2006-02-01 17:09:16.000000000 -0600
+++ linux-2.6.16-rc1-git5/drivers/scsi/sym53c8xx_2/sym_glue.h	2006-02-02 13:33:47.459016635 -0600
@@ -180,6 +180,10 @@
 	char		chip_name[8];
 	struct pci_dev	*device;
 
+	/* pci bus i/o state; waiter for clearing of i/o state */
+	enum pci_channel_state io_state;
+	struct sym_eh_wait *io_reset_wait;
+
 	struct Scsi_Host *host;
 
 	void __iomem *	ioaddr;		/* MMIO kernel io address	*/
Index: linux-2.6.16-rc1-git5/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- linux-2.6.16-rc1-git5.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2006-02-01 17:09:16.000000000 -0600
+++ linux-2.6.16-rc1-git5/drivers/scsi/sym53c8xx_2/sym_hipd.c	2006-02-02 14:05:38.973739591 -0600
@@ -2761,6 +2761,7 @@
 	u_char	istat, istatc;
 	u_char	dstat;
 	u_short	sist;
+	unsigned int    icnt;
 
 	/*
 	 *  interrupt on the fly ?
@@ -2802,6 +2803,7 @@
 	sist	= 0;
 	dstat	= 0;
 	istatc	= istat;
+	icnt = 0;
 	do {
 		if (istatc & SIP)
 			sist  |= INW(np, nc_sist);
@@ -2809,6 +2811,19 @@
 			dstat |= INB(np, nc_dstat);
 		istatc = INB(np, nc_istat);
 		istat |= istatc;
+		
+		/* 
+		 * Prevent deadlock waiting on a condition that may 
+		 * never clear. If the PCI bus has disconnected us,
+		 * we shouldn't poll, as all reads will return 0xffffffff.
+		 * If the flags aren't clearing, then check to see if
+		 * the bus is disconnected. If it is, punt.
+		 */
+		icnt ++;
+		if (100 < icnt) {
+			if (np->s.device->error_state != pci_channel_io_normal)
+				return;
+		}
 	} while (istatc & (SIP|DIP));
 
 	if (DEBUG_FLAGS & DEBUG_TINY)
