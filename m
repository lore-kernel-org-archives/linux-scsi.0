From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] eata: remove driver_lock
Date: Mon, 14 Jul 2014 10:26:33 +0200
Message-ID: <1405326393-18559-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50747 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaGNIYT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2014 04:24:19 -0400
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1X6bYY-0005kT-Jo
	for linux-scsi@vger.kernel.org; Mon, 14 Jul 2014 08:24:18 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

port_detect is only called from the module_init routine and thus implicitly
serialized, so remove the driver lock which was held over potentially
sleeping function calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
---
 drivers/scsi/eata.c | 9 ---------
 1 file changed, 9 deletions(-)

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
-- 
1.9.1

