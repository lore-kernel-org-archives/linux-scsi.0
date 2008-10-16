From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/2] cciss: fix sysfs regression, obsoletes previous patch
Date: Thu, 16 Oct 2008 16:29:56 -0500
Message-ID: <20081016212956.GA25704@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:20670 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbYJPV35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 17:29:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, JensAxboejens.axboe@oracle.com
Cc: alan.brunelle@hp.com, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>


Patch 1 of 2

This patch obsoletes the one I sent yesterday. It fixes a broken symlink in
sysfs. The previous patch appeared to work but was wrong as reported by Alan
Brunelle.
Please consider this for inclusion.

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
