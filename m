From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: Re: [PATCH] aha1740 update
Date: Thu, 03 Jul 2003 17:29:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <wrpadbviq6x.fsf@hina.wild-wind.fr.eu.org>
References: <wrp7k72ktkg.fsf@hina.wild-wind.fr.eu.org>
	<20030703161335.A4558@infradead.org>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:47886 "EHLO
	young-lust.wild-wind.fr.eu.org") by vger.kernel.org with ESMTP
	id S264340AbTGCPRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2003 11:17:53 -0400
In-Reply-To: <20030703161335.A4558@infradead.org> (Christoph Hellwig's
 message of "Thu, 3 Jul 2003 16:13:36 +0100")
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> aha1740 is a newstyle driver and doesn't need a release
Christoph> method so this is bogus.

Ok, I was getting confused with all the different merge that occured
in this driver for the last few week.

Anyway, here is the latest patch, including fix for the very nice
locking bug Adrian just found.

Regards,

        M.

--- ../vanilla/linux-2.5/drivers/scsi/aha1740.c	2003-07-01 18:51:30.000000000 +0200
+++ linux-2.5/drivers/scsi/aha1740.c	2003-07-03 17:21:31.000000000 +0200
@@ -375,7 +375,7 @@
 #endif
 
 	/* locate an available ecb */
-	spin_lock_irqsave(&SCpnt->device->host->host_lock, flags);
+	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
 	ecbno = host->last_ecb_used + 1; /* An optimization */
 	if (ecbno >= AHA1740_ECBS)
 		ecbno = 0;
@@ -394,7 +394,7 @@
 						    doubles as reserved flag */
 
 	host->last_ecb_used = ecbno;    
-	spin_unlock_irqrestore(&SCpnt->device->host->host_lock, flags);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
 
 #ifdef DEBUG
 	printk("Sending command (%d %x)...", ecbno, done);
@@ -491,7 +491,7 @@
 		unsigned int base = SCpnt->device->host->io_port;
 		DEB(printk("aha1740[%d] critical section\n",ecbno));
 
-		spin_lock_irqsave(&SCpnt->device->host->host_lock, flags);
+		spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
 		for (loopcnt = 0; ; loopcnt++) {
 			if (inb(G2STAT(base)) & G2STAT_MBXOUT) break;
 			if (loopcnt == LOOPCNT_WARN) {
@@ -511,7 +511,7 @@
 				panic("aha1740.c: attn wait failed!\n");
 		}
 		outb(ATTN_START | (target & 7), ATTN(base)); /* Start it up */
-		spin_unlock_irqrestore(&SCpnt->device->host->host_lock, flags);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
 		DEB(printk("aha1740[%d] request queued.\n",ecbno));
 	} else
 		printk(KERN_ALERT "aha1740_queuecommand: done can't be NULL\n");
@@ -594,7 +594,7 @@
 	if (!request_region(slotbase, SLOTSIZE, "aha1740")) /* See if in use */
 		return -EBUSY;
 	if (!aha1740_test_port(slotbase))
-		goto err_release;
+		goto err_release_region;
 	aha1740_getconfig(slotbase,&irq_level,&translation);
 	if ((inb(G2STAT(slotbase)) &
 	     (G2STAT_MBXOUT|G2STAT_BUSY)) != G2STAT_MBXOUT) {
@@ -609,7 +609,7 @@
 	shpnt = scsi_host_alloc(&aha1740_template,
 			      sizeof(struct aha1740_hostdata));
 	if(shpnt == NULL)
-		goto err_release;
+		goto err_release_region;
 
 	shpnt->base = 0;
 	shpnt->io_port = slotbase;
@@ -625,21 +625,26 @@
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

-- 
Places change, faces change. Life is so very strange.
