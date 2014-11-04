From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/11] mptfusion: don't change queue type in ->change_queue_depth
Date: Tue,  4 Nov 2014 08:54:11 +0100
Message-ID: <1415087656-9491-7-git-send-email-hch@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34667 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaKDHyP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:54:15 -0500
In-Reply-To: <1415087656-9491-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

This function shouldn't change the queue type, just the depth.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/message/fusion/mptscsih.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 00bd13d..c0d84a0 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2322,7 +2322,6 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 	VirtTarget 		*vtarget;
 	struct scsi_target 	*starget;
 	int			max_depth;
-	int			tagged;
 	MPT_ADAPTER		*ioc = hd->ioc;
 
 	starget = scsi_target(sdev);
@@ -2347,12 +2346,8 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 
 	if (qdepth > max_depth)
 		qdepth = max_depth;
-	if (qdepth == 1)
-		tagged = 0;
-	else
-		tagged = MSG_SIMPLE_TAG;
 
-	scsi_adjust_queue_depth(sdev, tagged, qdepth);
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
 	return sdev->queue_depth;
 }
 
-- 
1.9.1

