From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: [PATCH] aha1740 update
Date: Tue, 01 Jul 2003 20:09:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <wrp7k72ktkg.fsf@hina.wild-wind.fr.eu.org>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:15627 "EHLO
	young-lust.wild-wind.fr.eu.org") by vger.kernel.org with ESMTP
	id S263187AbTGAR5J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2003 13:57:09 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

James,

The included patch fixes a few bits that were missing when you merged
my aha1740 patch (mainly errors handling, and a release method).

Tested on Alpha and x86.

Thanks,

        M.

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1262  -> 1.1263 
#	drivers/scsi/aha1740.c	1.25    -> 1.26   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/01	maz@hina.wild-wind.fr.eu.org	1.1263
# aha1740 : Merge back missing bits after merge with jebe.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
--- a/drivers/scsi/aha1740.c	Tue Jul  1 20:05:20 2003
+++ b/drivers/scsi/aha1740.c	Tue Jul  1 20:05:20 2003
@@ -565,11 +565,26 @@
 	return 0;
 }
 
+static int aha1740_release(struct Scsi_Host *shost)
+{
+	struct aha1740_hostdata *host = HOSTDATA (shost);
+
+        free_irq (shost->irq, shost);
+        dma_unmap_single (&host->edev->dev, host->ecb_dma_addr,
+                          sizeof (host->ecb), DMA_BIDIRECTIONAL);
+        release_region (shost->io_port, SLOTSIZE);
+
+        scsi_host_put (shost);
+
+	return 0;
+}
+
 static Scsi_Host_Template aha1740_template = {
 	.module           = THIS_MODULE,
 	.proc_name        = "aha1740",
 	.proc_info        = aha1740_proc_info,
 	.name             = "Adaptec 174x (EISA)",
+	.release          = aha1740_release,
 	.queuecommand     = aha1740_queuecommand,
 	.bios_param       = aha1740_biosparam,
 	.can_queue        = AHA1740_ECBS,
@@ -594,7 +609,7 @@
 	if (!request_region(slotbase, SLOTSIZE, "aha1740")) /* See if in use */
 		return -EBUSY;
 	if (!aha1740_test_port(slotbase))
-		goto err_release;
+		goto err_release_region;
 	aha1740_getconfig(slotbase,&irq_level,&translation);
 	if ((inb(G2STAT(slotbase)) &
 	     (G2STAT_MBXOUT|G2STAT_BUSY)) != G2STAT_MBXOUT) {
@@ -609,7 +624,7 @@
 	shpnt = scsi_host_alloc(&aha1740_template,
 			      sizeof(struct aha1740_hostdata));
 	if(shpnt == NULL)
-		goto err_release;
+		goto err_release_region;
 
 	shpnt->base = 0;
 	shpnt->io_port = slotbase;
@@ -625,21 +640,26 @@
 	if (!host->ecb_dma_addr) {
 		printk (KERN_ERR "aha1740_probe: Couldn't map ECB, giving up\n");
 		scsi_unregister (shpnt);
-		goto err_release;
+		goto err_host_put;
 	}
 	
 	DEB(printk("aha1740_probe: enable interrupt channel %d\n",irq_level));
 	if (request_irq(irq_level,aha1740_intr_handle,0,"aha1740",shpnt)) {
 		printk(KERN_ERR "aha1740_probe: Unable to allocate IRQ %d.\n",
 		       irq_level);
-		goto err_release;
+		goto err_unmap;
 	}
 
 	eisa_set_drvdata (edev, shpnt);
 	scsi_add_host (shpnt, dev);
 	return 0;
 
- err_release:
+ err_unmap:
+	dma_unmap_single (&edev->dev, host->ecb_dma_addr,
+			  sizeof (host->ecb), DMA_BIDIRECTIONAL);
+ err_host_put:
+	scsi_host_put (shpnt);
+ err_release_region:
 	release_region(slotbase, SLOTSIZE);
 
 	return -ENODEV;
@@ -648,17 +668,11 @@
 static __devexit int aha1740_remove (struct device *dev)
 {
 	struct Scsi_Host *shpnt = dev->driver_data;
-	struct aha1740_hostdata *host = HOSTDATA (shpnt);
 
 	if (scsi_remove_host (shpnt))
 		return -EBUSY;
 	
-	free_irq (shpnt->irq, shpnt);
-	dma_unmap_single (dev, host->ecb_dma_addr,
-			  sizeof (host->ecb), DMA_BIDIRECTIONAL);
-	release_region (shpnt->io_port, SLOTSIZE);
-
-	scsi_host_put (shpnt);
+	aha1740_release (shpnt);
 	
 	return 0;
 }

-- 
Places change, faces change. Life is so very strange.
