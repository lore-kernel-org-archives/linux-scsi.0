From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 11:53:36 -0500
Message-ID: <yq1zl2xl0j3.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1002251132170.1686-100000@iolanthe.rowland.org>
	<yq14ol5mfa1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:51025 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab0BYQzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 11:55:47 -0500
In-Reply-To: <yq14ol5mfa1.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Thu, 25 Feb 2010 11:49:42 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ramya Desai <ramya.desai@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

>>>>> "mkp" == Martin K Petersen <martin.petersen@oracle.com> writes:

mkp> This one is a runt that came in as part of the DM topology
mkp> enablement.  DM ended up doing things differently and it is no
mkp> longer used.  I already have a patch in my queue that removes it.

Here it is, btw...


block: Remove blk_queue_max_hw_sectors

This function is no longer called by any subsystem and can be removed.

Also clarify test in blk_queue_max_sectors.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/block/blk-settings.c b/block/blk-settings.c
index aaa379b..69b7c67 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -226,7 +226,7 @@ void blk_queue_max_sectors(struct request_queue *q, unsigned int max_sectors)
 		       __func__, max_sectors);
 	}
 
-	if (BLK_DEF_MAX_SECTORS > max_sectors)
+	if (max_sectors < BLK_DEF_MAX_SECTORS)
 		q->limits.max_hw_sectors = q->limits.max_sectors = max_sectors;
 	else {
 		q->limits.max_sectors = BLK_DEF_MAX_SECTORS;
@@ -235,15 +235,6 @@ void blk_queue_max_sectors(struct request_queue *q, unsigned int max_sectors)
 }
 EXPORT_SYMBOL(blk_queue_max_sectors);
 
-void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_sectors)
-{
-	if (BLK_DEF_MAX_SECTORS > max_sectors)
-		q->limits.max_hw_sectors = BLK_DEF_MAX_SECTORS;
-	else
-		q->limits.max_hw_sectors = max_sectors;
-}
-EXPORT_SYMBOL(blk_queue_max_hw_sectors);
-
 /**
  * blk_queue_max_discard_sectors - set max sectors for a single discard
  * @q:  the request queue for the device
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ffb13ad..0b05791 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -921,7 +921,6 @@ extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_queue_max_sectors(struct request_queue *, unsigned int);
-extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_phys_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
