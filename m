From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/7] vmw_pscsi: simplify ->change_queue_depth
Date: Thu, 13 Nov 2014 18:59:06 +0100
Message-ID: <1415901546-8006-8-git-send-email-hch@lst.de>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54688 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663AbaKMR7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 12:59:13 -0500
In-Reply-To: <1415901546-8006-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

Remove overly verbose debugging output that pokes into mid-layer internal
structures that looks like copy & paste from the mpt2/3 drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/vmw_pvscsi.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index ade1f1d..0f133c1 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -508,15 +508,7 @@ static int pvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	if (!sdev->tagged_supported)
 		qdepth = 1;
-	scsi_change_queue_depth(sdev, qdepth);
-
-	if (sdev->inquiry_len > 7)
-		sdev_printk(KERN_INFO, sdev,
-			    "qdepth(%d), tagged(%d), simple(%d), scsi_level(%d), cmd_que(%d)\n",
-			    sdev->queue_depth, sdev->tagged_supported,
-			    sdev->simple_tags,
-			    sdev->scsi_level, (sdev->inquiry[7] & 2) >> 1);
-	return sdev->queue_depth;
+	return scsi_change_queue_depth(sdev, qdepth);
 }
 
 /*
-- 
1.9.1

