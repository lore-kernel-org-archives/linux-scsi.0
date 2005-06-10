From: mike.miller@hp.com
Subject: [PATCH] cciss 2.6 DMA mapping
Date: Fri, 10 Jun 2005 14:51:04 -0500
Message-ID: <20050610195104.GA15149@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel9.hp.com ([156.153.255.214]:17293 "EHLO atlrel9.hp.com")
	by vger.kernel.org with ESMTP id S261227AbVFJUub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 16:50:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@odsl.org, axboe@suse.de, jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Patch removes our homegrown DMA masks and uses the ones defined in the kernel.
This patch replaces the broken one I sent in earlier. It has been tested and works. Please discard the first submission.

Signed-off-by: Mike Miller <mike.miller@hp.com>

 cciss.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)
--------------------------------------------------------------------------------
diff -burNp lx2612-rc6.orig/drivers/block/cciss.c lx2612-rc6/drivers/block/cciss.c
--- lx2612-rc6.orig/drivers/block/cciss.c	2005-06-10 08:43:05.516957392 -0500
+++ lx2612-rc6/drivers/block/cciss.c	2005-06-10 13:10:28.527049144 -0500
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
 #include <linux/completion.h>
@@ -126,8 +127,6 @@ static struct board_type products[] = {
 #define MAX_CTLR_ORIG 	8
 
 
-#define CCISS_DMA_MASK	0xFFFFFFFF	/* 32 bit DMA */
-
 static ctlr_info_t *hba[MAX_CTLR];
 
 static void do_cciss_request(request_queue_t *q);
@@ -2393,11 +2392,6 @@ static int cciss_pci_init(ctlr_info_t *c
 		printk(KERN_ERR "cciss: Unable to Enable PCI device\n");
 		return( -1);
 	}
-	if (pci_set_dma_mask(pdev, CCISS_DMA_MASK ) != 0)
-	{
-		printk(KERN_ERR "cciss:  Unable to set DMA mask\n");
-		return(-1);
-	}
 
 	subsystem_vendor_id = pdev->subsystem_vendor;
 	subsystem_device_id = pdev->subsystem_device;
@@ -2747,9 +2741,9 @@ static int __devinit cciss_init_one(stru
 	hba[i]->pdev = pdev;
 
 	/* configure PCI DMA stuff */
-	if (!pci_set_dma_mask(pdev, 0xffffffffffffffffULL))
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK))
 		printk("cciss: using DAC cycles\n");
-	else if (!pci_set_dma_mask(pdev, 0xffffffff))
+	else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK))
 		printk("cciss: not using DAC cycles\n");
 	else {
 		printk("cciss: no suitable DMA available\n");
