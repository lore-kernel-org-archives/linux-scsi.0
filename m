From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: [PATCH] aha1740 compile fix
Date: Mon, 18 Aug 2003 18:18:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <wrpekzjlz1w.fsf@hina.wild-wind.fr.eu.org>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:40969 "EHLO
	young-lust.wild-wind.fr.eu.org") by vger.kernel.org with ESMTP
	id S272277AbTHRQSZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2003 12:18:25 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James,

The included patch fixes aha1740 compilation in Linus' latest 2.6 tree
(dev->name removal, scsi_remove_host now returns void).

Regards,

        M.

===== drivers/scsi/aha1740.c 1.29 vs edited =====
--- 1.29/drivers/scsi/aha1740.c	Sun Jul 20 19:53:13 2003
+++ edited/drivers/scsi/aha1740.c	Mon Aug 18 05:57:50 2003
@@ -603,7 +603,7 @@
 		outb(0, G2CNTRL(slotbase));
 	}
 	printk(KERN_INFO "Configuring %s at IO:%x, IRQ %d\n",
-	       dev->name, slotbase, irq_level);
+	       edev->id.sig, slotbase, irq_level);
 	printk(KERN_INFO "aha174x: Extended translation %sabled.\n",
 	       translation ? "en" : "dis");
 	shpnt = scsi_host_alloc(&aha1740_template,
@@ -656,8 +656,7 @@
 	struct Scsi_Host *shpnt = dev->driver_data;
 	struct aha1740_hostdata *host = HOSTDATA (shpnt);
 
-	if (scsi_remove_host (shpnt))
-		return -EBUSY;
+	scsi_remove_host (shpnt);
 	
 	free_irq (shpnt->irq, shpnt);
 	dma_unmap_single (dev, host->ecb_dma_addr,

-- 
Places change, faces change. Life is so very strange.
