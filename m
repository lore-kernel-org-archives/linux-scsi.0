From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] cciss: remove READ_AHEAD define and use block layer defaults
Date: Mon, 25 Feb 2008 18:32:38 -0600
Message-ID: <20080226003238.GA31623@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:28490 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbYBZAcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 19:32:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, coughlan@redhat.com

PATCH 1/1

This patch removes the #define READ_AHEAD 1024 from the driver and uses the
block layer defaults, instead. We have found that under certain workloads
the setting can cause a disk connected to the e200 controller to go offline.
If the disk hiccups the link may try to downshift but the controller is
never notified that the link successfully completed the renegotiation.
We've also found that performance using the block layer default of 32 pages
was on par with the 1024 setting. We tried setting it to zero at one time
based on info from our firmware guys but that killed performance. Turns out
we were talking about 2 different read ahead settings.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

  
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9715be3..2f6cc3b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -131,7 +131,6 @@ static struct board_type products[] = {
 /*define how many times we will try a command because of bus resets */
 #define MAX_CMD_RETRIES 3
 
-#define READ_AHEAD 	 1024
 #define MAX_CTLR	32
 
 /* Originally cciss driver only supports 8 major numbers */
@@ -1341,7 +1340,6 @@ geo_inq:
 		disk->private_data = &h->drv[drv_index];
 
 		/* Set up queue information */
-		disk->queue->backing_dev_info.ra_pages = READ_AHEAD;
 		blk_queue_bounce_limit(disk->queue, hba[ctlr]->pdev->dma_mask);
 
 		/* This is a hardware imposed limit. */
@@ -3434,7 +3432,6 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		}
 		drv->queue = q;
 
-		q->backing_dev_info.ra_pages = READ_AHEAD;
 		blk_queue_bounce_limit(q, hba[i]->pdev->dma_mask);
 
 		/* This is a hardware imposed limit. */
