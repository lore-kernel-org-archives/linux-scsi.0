From: Christoph Hellwig <hch@infradead.org>
Subject: Re: eata - issue appeared in Linus git master in last 24-48 hours
Date: Fri, 11 Jul 2014 02:20:06 -0700
Message-ID: <20140711092006.GB26912@infradead.org>
References: <dd468b-sj5.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaGKJUG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2014 05:20:06 -0400
Content-Disposition: inline
In-Reply-To: <dd468b-sj5.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 30, 2014 at 04:31:33AM +0930, Arthur Marsh wrote:
> Hi, I haven't had time to do a git bisect yet, but just saw this after
> rebuilding the kernel in the last day or so:

It seems like some of the routines called during the driver
initialization may sleep while the driver_lock is held and irqs are
disabled.

As eata2x_detect is only called during module load the lock seems
entirely pointless and should be removed, like in the patch below:


diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 03372cf..980898e 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -837,7 +837,6 @@ struct hostdata {
 static struct Scsi_Host *sh[MAX_BOARDS];
 static const char *driver_name = "EATA";
 static char sha[MAX_BOARDS];
-static DEFINE_SPINLOCK(driver_lock);
 
 /* Initialize num_boards so that ihdlr can work while detect is in progress */
 static unsigned int num_boards = MAX_BOARDS;
@@ -1097,8 +1096,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
 		goto fail;
 	}
 
-	spin_lock_irq(&driver_lock);
-
 	if (do_dma(port_base, 0, READ_CONFIG_PIO)) {
 #if defined(DEBUG_DETECT)
 		printk("%s: detect, do_dma failed at 0x%03lx.\n", name,
@@ -1265,10 +1262,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 	}
 #endif
 
-	spin_unlock_irq(&driver_lock);
 	sh[j] = shost = scsi_register(tpnt, sizeof(struct hostdata));
-	spin_lock_irq(&driver_lock);
-
 	if (shost == NULL) {
 		printk("%s: unable to register host, detaching.\n", name);
 		goto freedma;
@@ -1345,8 +1339,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
 	else
 		sprintf(dma_name, "DMA %u", dma_channel);
 
-	spin_unlock_irq(&driver_lock);
-
 	for (i = 0; i < shost->can_queue; i++)
 		ha->cp[i].cp_dma_addr = pci_map_single(ha->pdev,
 							  &ha->cp[i],
@@ -1439,7 +1431,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
       freeirq:
 	free_irq(irq, &sha[j]);
       freelock:
-	spin_unlock_irq(&driver_lock);
 	release_region(port_base, REGION_SIZE);
       fail:
 	return 0;
