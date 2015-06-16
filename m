From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] [PATCH] block: Add blk_max_rw_sectors limit
Date: Tue, 16 Jun 2015 18:46:14 -0400
Message-ID: <yq1616nff0p.fsf@sermon.lab.mkp.net>
References: <201506151902.t5FJ2giY001071@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50471 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbbFPWqu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2015 18:46:50 -0400
In-Reply-To: <201506151902.t5FJ2giY001071@d01av01.pok.ibm.com> (Brian King's
	message of "Mon, 15 Jun 2015 14:02:42 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, axboe@kernel.dk


Brian,

I only have minor nits wrt. your patch since you did what I asked.
However, now that I'm less jet lagged and blurry eyed I wonder if
the tweak below wouldn't suffice?


sd: Fix maximum I/O size for BLOCK_PC requests
    
Commit bcdb247c6b6a ("sd: Limit transfer length") clamped the maximum
size of an I/O request to the MAXIMUM TRANSFER LENGTH field in the BLOCK
LIMITS VPD. This had the unfortunate effect of also limiting the maximum
size of non-filesystem requests sent to the device through sg/bsg.

Avoid using blk_queue_max_hw_sectors() and set the max_sectors queue
limit directly.

Also update the comment in blk_limits_max_hw_sectors() to clarify that
max_hw_sectors defines the limit for the I/O controller only.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Brian King <brking@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # 3.17+

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 12600bfffca9..e0057d035200 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -241,8 +241,8 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
  * Description:
  *    Enables a low level driver to set a hard upper limit,
  *    max_hw_sectors, on the size of requests.  max_hw_sectors is set by
- *    the device driver based upon the combined capabilities of I/O
- *    controller and storage device.
+ *    the device driver based upon the capabilities of the I/O
+ *    controller.
  *
  *    max_sectors is a soft limit imposed by the block layer for
  *    filesystem type requests.  This value can be overridden on a
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 79beebf53302..cfc0de75d763 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2779,9 +2779,9 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	max_xfer = sdkp->max_xfer_blocks;
 	max_xfer <<= ilog2(sdp->sector_size) - 9;
 
-	max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
-				max_xfer);
-	blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
+	sdkp->disk->queue->limits.max_sectors =
+		min_not_zero(queue_max_hw_sectors(sdkp->disk->queue), max_xfer);
+
 	set_capacity(disk, sdkp->capacity);
 	sd_config_write_same(sdkp);
 	kfree(buffer);
