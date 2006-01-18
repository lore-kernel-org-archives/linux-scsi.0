From: linas@austin.ibm.com (linas)
Subject: [PATCH] PCI Error Recovery: Symbios SCSI device driver
Date: Wed, 18 Jan 2006 10:53:45 -0600
Message-ID: <20060118165345.GA31920@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52612 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S932520AbWARQxy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2006 11:53:54 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k0IGrlS9019500
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 11:53:47 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0IGqAOO272634
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 09:52:10 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k0IGrkfg003273
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 09:53:47 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: brking@us.ibm.com, gregkh@suse.de, linux-scsi@vger.kernel.org


Hi James,

Please review the patch below, and forward upstream.  I've been
bouncing it to various mailing lists for the last half-year,
it has been living in an -mm tree for a while, and was a part of
GregKH's patchset for a while. I'd like to get it propely upstream.

The general description of the principles at work here are given in
Documentation/pci-error-recovery.txt

Thanks,

--linas


----- Forwarded message from Greg KH <gregkh@suse.de> -----

Cc: linas@austin.ibm.com
Subject: [PATCH] PCI Error Recovery: Symbios SCSI device driver
Reply-To: Greg K-H <greg@kroah.com>
To: linux-pci@atrey.karlin.mff.cuni.cz
From: Greg KH <gregkh@suse.de>

[PATCH] PCI Error Recovery: Symbios SCSI device driver

Various PCI bus errors can be signaled by newer PCI controllers.  This
patch adds the PCI error recovery callbacks to the Symbios SCSI device driver.
The patch has been tested, and appears to work well.

Signed-off-by: Linas Vepstas <linas@linas.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
commit d78cde68ab78766c3a175466aa8adcbdc5520963
tree 836445f183f96049046d2da633c45e04df53b775
parent 3c06ba2cdbd37f80ae6dc044d9e305f0dd0ad6dd
author linas <linas@austin.ibm.com> Fri, 18 Nov 2005 16:23:04 -0600
committer Greg Kroah-Hartman <gregkh@suse.de> Thu, 05 Jan 2006 21:54:54 -0800

 drivers/scsi/sym53c8xx_2/sym_glue.c |  113 +++++++++++++++++++++++++++++++++++
 drivers/scsi/sym53c8xx_2/sym_glue.h |    4 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   15 +++++
 3 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 1fffd2b..19ca4ed 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -716,6 +716,10 @@ static irqreturn_t sym53c8xx_intr(int ir
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
+	/* Avoid spinloop trying to handle interrupts on frozen device */
+	if (np->s.io_state != pci_channel_io_normal)
+		return IRQ_HANDLED;
+
 	spin_lock_irqsave(np->s.host->host_lock, flags);
 	sym_interrupt(np);
 	spin_unlock_irqrestore(np->s.host->host_lock, flags);
@@ -789,6 +793,25 @@ static void sym_eh_done(struct scsi_cmnd
  */
 static void sym_eh_timeout(u_long p) { __sym_eh_done((struct scsi_cmnd *)p, 1); }
 
+static void sym_eeh_timeout(u_long p)
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
@@ -829,6 +852,35 @@ prepare:
 
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
+			printk (KERN_ERR "%s: Timed out waiting for PCI reset\n",
+			       sym_name(np));
+		}
+		np->s.io_reset_wait = NULL;
+	}
+
 	switch(op) {
 	case SYM_EH_ABORT:
 		sts = sym_abort_scsiio(np, cmd, 1);
@@ -1630,6 +1682,8 @@ static struct Scsi_Host * __devinit sym_
 	np->maxoffs	= dev->chip.offset_max;
 	np->maxburst	= dev->chip.burst_max;
 	np->myaddr	= dev->host_id;
+	np->s.io_state = pci_channel_io_normal;
+	np->s.io_reset_wait = NULL;
 
 	/*
 	 *  Edit its name.
@@ -1962,6 +2016,58 @@ static int sym_detach(struct sym_hcb *np
 	return 1;
 }
 
+/* ------------- PCI Error Recovery infrastructure -------------- */
+/** sym2_io_error_detected() is called when PCI error is detected */
+static pci_ers_result_t sym2_io_error_detected (struct pci_dev *pdev, pci_channel_state_t state)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	np->s.io_state = state;
+	// XXX If slot is permanently frozen, then what?
+	// Should we scsi_remove_host() maybe ??
+
+	/* Request a slot slot reset. */
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/** sym2_io_slot_reset is called when the pci bus has been reset.
+ *  Restart the card from scratch. */
+static pci_ers_result_t sym2_io_slot_reset (struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	printk (KERN_INFO "%s: recovering from a PCI slot reset\n",
+	    sym_name(np));
+
+	if (pci_enable_device(pdev))
+		printk (KERN_ERR "%s: device setup failed most egregiously\n",
+			    sym_name(np));
+
+	pci_set_master(pdev);
+	enable_irq (pdev->irq);
+
+	/* Perform host reset only on one instance of the card */
+	if (0 == PCI_FUNC (pdev->devfn))
+		sym_reset_scsi_bus(np, 0);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+/** sym2_io_resume is called when the error recovery driver
+ *  tells us that its OK to resume normal operation.
+ */
+static void sym2_io_resume (struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	/* Perform device startup only once for this card. */
+	if (0 == PCI_FUNC (pdev->devfn))
+		sym_start_up (np, 1);
+
+	np->s.io_state = pci_channel_io_normal;
+	sym_eeh_done (np->s.io_reset_wait);
+}
+
 /*
  * Driver host template.
  */
@@ -2219,11 +2325,18 @@ static struct pci_device_id sym2_id_tabl
 
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
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index cc92d0c..1ccf0c5 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -180,6 +180,10 @@ struct sym_shcb {
 	char		chip_name[8];
 	struct pci_dev	*device;
 
+	/* pci bus i/o state; waiter for clearing of i/o state */
+	pci_channel_state_t io_state;
+	struct sym_eh_wait *io_reset_wait;
+
 	struct Scsi_Host *host;
 
 	void __iomem *	ioaddr;		/* MMIO kernel io address	*/
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 8260f04..eec2feb 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -2761,6 +2761,7 @@ void sym_interrupt (struct sym_hcb *np)
 	u_char	istat, istatc;
 	u_char	dstat;
 	u_short	sist;
+	u_int    icnt;
 
 	/*
 	 *  interrupt on the fly ?
@@ -2802,6 +2803,7 @@ void sym_interrupt (struct sym_hcb *np)
 	sist	= 0;
 	dstat	= 0;
 	istatc	= istat;
+	icnt = 0;
 	do {
 		if (istatc & SIP)
 			sist  |= INW(np, nc_sist);
@@ -2809,6 +2811,19 @@ void sym_interrupt (struct sym_hcb *np)
 			dstat |= INB(np, nc_dstat);
 		istatc = INB(np, nc_istat);
 		istat |= istatc;
+
+		/* Prevent deadlock waiting on a condition that may never clear. */
+		/* XXX this is a temporary kludge; the correct to detect
+		 * a PCI bus error would be to use the io_check interfaces
+		 * proposed by Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
+		 * Problem with polling like that is the state flag might not
+		 * be set.
+		 */
+		icnt ++;
+		if (100 < icnt) {
+			if (np->s.device->error_state != pci_channel_io_normal)
+				return;
+		}
 	} while (istatc & (SIP|DIP));
 
 	if (DEBUG_FLAGS & DEBUG_TINY)



----- End forwarded message -----
