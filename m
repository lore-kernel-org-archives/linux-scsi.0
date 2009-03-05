From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/2] cciss: change to discover first memory BAR
Date: Thu, 5 Mar 2009 17:34:20 -0600
Message-ID: <20090305233420.GB24830@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11369 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572AbZCEXeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 18:34:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, coldwell@redhat.com
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

PATCH 2 of 2

This patch adds a method for discovering the first memory BAR. All Smart
Array controllers to date have always had the the memory BAR as the first
BAR. A new controller to be released later this year breaks that model.

Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>


diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index e189abd..311b81e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3245,12 +3245,21 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
  */
 	cciss_interrupt_mode(c, pdev, board_id);
 
-	/*
-	 * Memory base addr is first addr , the second points to the config
-	 *   table
-	 */
+	/* find the memory BAR */
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM)
+			break;
+	}
+	if (i == DEVICE_COUNT_RESOURCE) {
+		printk(KERN_WARNING "cciss: No memory BAR found\n");
+		err = -ENODEV;
+		goto err_out_free_res;
+	}
+
+	c->paddr = pci_resource_start(pdev, i); /* addressing mode bits
+						 * already removed
+						 */
 
-	c->paddr = pci_resource_start(pdev, 0);	/* addressing mode bits already removed */
 #ifdef CCISS_DEBUG
 	printk("address 0 = %lx\n", c->paddr);
 #endif				/* CCISS_DEBUG */
