From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 17/37] dmx3191d: Use NO_IRQ
Date: Wed, 12 Nov 2014 16:12:03 +1100
Message-ID: <20141112051150.515437012@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40985 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaKLFnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:21 -0500
Content-Disposition: inline; filename=dmx3191d-dont-request-irq
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Testing shows that the Domex 3191D card never asserts its IRQ. Hence it is
non-functional with Linux (worse, the EH bugs in the core driver are fatal
but that's a problem for another patch). Perhaps the DT-536 chip needs
special setup? I can't find documentation for it. The NetBSD driver uses
polling apparently because of this issue.

Set host->irq = NO_IRQ so the core driver will prevent targets from
disconnecting. Don't request host->irq.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---

Changes since v1:
- Use NO_IRQ instead of IRQ_NONE.

---
 drivers/scsi/dmx3191d.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2014-11-12 16:11:16.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2014-11-12 16:11:19.000000000 +1100
@@ -34,6 +34,8 @@
  * Definitions for the generic 5380 driver.
  */
 
+#define DONT_USE_INTR
+
 #define NCR5380_read(reg)		inb(port + reg)
 #define NCR5380_write(reg, value)	outb(value, port + reg)
 
@@ -89,32 +91,23 @@ static int dmx3191d_probe_one(struct pci
 	if (!shost)
 		goto out_release_region;       
 	shost->io_port = io;
-	shost->irq = pdev->irq;
 
-	NCR5380_init(shost, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
+	/* This card does not seem to raise an interrupt on pdev->irq.
+	 * Steam-powered SCSI controllers run without an IRQ anyway.
+	 */
+	shost->irq = NO_IRQ;
 
-	if (request_irq(pdev->irq, NCR5380_intr, IRQF_SHARED,
-				DMX3191D_DRIVER_NAME, shost)) {
-		/*
-		 * Steam powered scsi controllers run without an IRQ anyway
-		 */
-		printk(KERN_WARNING "dmx3191: IRQ %d not available - "
-				    "switching to polled mode.\n", pdev->irq);
-		shost->irq = NO_IRQ;
-	}
+	NCR5380_init(shost, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
 
 	pci_set_drvdata(pdev, shost);
 
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
-		goto out_free_irq;
+		goto out_release_region;
 
 	scsi_scan_host(shost);
 	return 0;
 
- out_free_irq:
-	if (shost->irq != NO_IRQ)
-		free_irq(shost->irq, shost);
  out_release_region:
 	release_region(io, DMX3191D_REGION_LEN);
  out_disable_device:
@@ -131,8 +124,6 @@ static void dmx3191d_remove_one(struct p
 
 	NCR5380_exit(shost);
 
-	if (shost->irq != NO_IRQ)
-		free_irq(shost->irq, shost);
 	release_region(shost->io_port, DMX3191D_REGION_LEN);
 	pci_disable_device(pdev);
 


