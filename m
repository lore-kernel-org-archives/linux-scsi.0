From: mike.miller@hp.com
Subject: [PATCH] cciss 2.6; replaces DMA masks with kernel defines
Date: Fri, 10 Jun 2005 09:34:53 -0500
Message-ID: <20050610143453.GA26476@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:55697 "EHLO palrel13.hp.com")
	by vger.kernel.org with ESMTP id S262575AbVFJPeU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 11:34:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch removes our homegrown DMA masks and uses the ones defined in
the kernel instead.
Thanks to Jens Axboe for the code. Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

 cciss.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

--------------------------------------------------------------------------------
diff -burNp lx2612-rc6.orig/drivers/block/cciss.c lx2612-rc6/drivers/block/cciss.c
--- lx2612-rc6.orig/drivers/block/cciss.c	2005-06-10 08:43:05.516957392 -0500
+++ lx2612-rc6/drivers/block/cciss.c	2005-06-10 08:56:44.302483072 -0500
@@ -126,8 +126,6 @@ static struct board_type products[] = {
 #define MAX_CTLR_ORIG 	8
 
 
-#define CCISS_DMA_MASK	0xFFFFFFFF	/* 32 bit DMA */
-
 static ctlr_info_t *hba[MAX_CTLR];
 
 static void do_cciss_request(request_queue_t *q);
@@ -2747,9 +2745,9 @@ static int __devinit cciss_init_one(stru
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
