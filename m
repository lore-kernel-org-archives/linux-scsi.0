From: Rask Ingemann Lambertsen <rask@sygehus.dk>
Subject: [PATCH] aha1740.c: Allow level triggered interrupts to be shared
Date: Wed, 29 Oct 2003 22:36:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029223609.A7362@sygehus.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0x50a41c44.albnxx15.adsl-dhcp.tele.dk ([80.164.28.68]:27908
	"EHLO 0x50a41c3d.albnxx15.adsl-dhcp.tele.dk") by vger.kernel.org
	with ESMTP id S261605AbTJ2Vhl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2003 16:37:41 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi.

The patch below (against 2.6.0-test8) makes it possible to share the
interrupt when the aha1740 is configured for a level triggered interrupt.
It appears to work fine on my i486 EISA box with an AHA-1742A and an NE3200
Ethernet board sharing an irq. Comments, please.

--- linux-2.6.0-test8/drivers/scsi/aha1740.c-orig	Fri Oct 17 23:42:57 2003
+++ linux-2.6.0-test8/drivers/scsi/aha1740.c	Mon Oct 27 13:23:22 2003
@@ -27,6 +27,9 @@
  * Converted to EISA and generic DMA APIs by Marc Zyngier
  * <maz@wild-wind.fr.eu.org>, 4/2003.
  *
+ * Shared interrupt support added by Rask Ingemann Lambertsen
+ * <rask@sygehus.dk>, 10/2003
+ *
  * For the avoidance of doubt the "preferred form" of this code is one which
  * is in an open non patent encumbered format. Where cryptographic key signing
  * forms part of the process of creating an executable the information
@@ -518,15 +521,17 @@
 	return 0;
 }
 
-/* Query the board for its irq_level.  Nothing else matters
+/* Query the board for its irq_level and irq_type.  Nothing else matters
    in enhanced mode on an EISA bus. */
 
 static void aha1740_getconfig(unsigned int base, unsigned int *irq_level,
+			      unsigned int *irq_type,
 			      unsigned int *translation)
 {
 	static int intab[] = { 9, 10, 11, 12, 0, 14, 15, 0 };
 
 	*irq_level = intab[inb(INTDEF(base)) & 0x7];
+	*irq_type  = (inb(INTDEF(base)) & 0x8) >> 3;
 	*translation = inb(RESV1(base)) & 0x1;
 	outb(inb(INTDEF(base)) | 0x10, INTDEF(base));
 }
@@ -583,7 +588,7 @@
 static int aha1740_probe (struct device *dev)
 {
 	int slotbase;
-	unsigned int irq_level, translation;
+	unsigned int irq_level, irq_type, translation;
 	struct Scsi_Host *shpnt;
 	struct aha1740_hostdata *host;
 	struct eisa_device *edev = to_eisa_device (dev);
@@ -595,15 +600,15 @@
 		return -EBUSY;
 	if (!aha1740_test_port(slotbase))
 		goto err_release_region;
-	aha1740_getconfig(slotbase,&irq_level,&translation);
+	aha1740_getconfig(slotbase,&irq_level,&irq_type,&translation);
 	if ((inb(G2STAT(slotbase)) &
 	     (G2STAT_MBXOUT|G2STAT_BUSY)) != G2STAT_MBXOUT) {
 		/* If the card isn't ready, hard reset it */
 		outb(G2CNTRL_HRST, G2CNTRL(slotbase));
 		outb(0, G2CNTRL(slotbase));
 	}
-	printk(KERN_INFO "Configuring slot %d at IO:%x, IRQ %d\n",
-	       edev->slot, slotbase, irq_level);
+	printk(KERN_INFO "Configuring slot %d at IO:%x, IRQ %u (%s)\n",
+	       edev->slot, slotbase, irq_level, irq_type ? "edge" : "level");
 	printk(KERN_INFO "aha174x: Extended translation %sabled.\n",
 	       translation ? "en" : "dis");
 	shpnt = scsi_host_alloc(&aha1740_template,
@@ -629,7 +634,8 @@
 	}
 	
 	DEB(printk("aha1740_probe: enable interrupt channel %d\n",irq_level));
-	if (request_irq(irq_level,aha1740_intr_handle,0,"aha1740",shpnt)) {
+	if (request_irq(irq_level,aha1740_intr_handle,irq_type ? 0 : SA_SHIRQ,
+			"aha1740",shpnt)) {
 		printk(KERN_ERR "aha1740_probe: Unable to allocate IRQ %d.\n",
 		       irq_level);
 		goto err_unmap;

-- 
Regards,
Rask Ingemann Lambertsen
