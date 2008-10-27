From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/2] cciss: fix sysfs broken symlink regression
Date: Mon, 27 Oct 2008 16:01:36 -0500
Message-ID: <20081027210136.GA9438@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11808 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYJ0VB0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 17:01:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

Patch 1 of 2

Regression introduced by commit 6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
This patch fixes a broken symlink in sysfs that was introduced by the above
commit also called "cciss: remove redundant code." We broke it in 2.6.27-rc
on or about 20080804. Some installers are broken if this symlink does not
exist and they may not detect the logical drives configured on the
controller.
It does not require being backported into 2.6.26.x or earlier kernels.

Please consider this for inclusion.

Andrew, do I need to resubmit 2 of 2? Or is that one still in your queue?

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1e1f915..0f367b1 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1365,6 +1365,7 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	disk->first_minor = drv_index << NWD_SHIFT;
 	disk->fops = &cciss_fops;
 	disk->private_data = &h->drv[drv_index];
+	disk->driverfs_dev = &h->pdev->dev;
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
