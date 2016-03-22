From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: fixup capacity calculation for 4k drives
Date: Mon, 21 Mar 2016 21:16:21 -0400
Message-ID: <yq1a8lr5n2y.fsf@sermon.lab.mkp.net>
References: <1458563249-91200-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49294 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbcCVBQc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2016 21:16:32 -0400
In-Reply-To: <1458563249-91200-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Mon, 21 Mar 2016 13:27:29 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> in sd_read_capacity() the sdkp->capacity field changes its
Hannes> meaning: after the call to read_capacity_XX() it carries the
Hannes> _unscaled_ values, making the comparison between the original
Hannes> value and the new value always false for drives with a sector
Hannes> size != 512.  So introduce a 'new_capacity' carrying the new,
Hannes> scaled, capacity.

I agree with Christoph.

How about something like this instead?

-- 
Martin K. Petersen	Oracle Linux Engineering

commit 2049b38f7de6dd073acee98230e7d735ceced8c9
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Mon Mar 21 20:49:53 2016 -0400

    sd: Fix excessive capacity printing on devices with blocks bigger than 512 bytes
    
    During revalidate we check whether device capacity has changed before we
    decide whether to output disk information or not.
    
    The check for old capacity failed to take into account that we scaled
    sdkp->capacity based on the reported logical block size. And therefore
    the capacity test would always fail for devices with sectors bigger than
    512 bytes and we would print several copies of the same discovery
    information.
    
    Avoid scaling sdkp->capacity and instead adjust the value on the fly
    when setting the block device capacity.
    
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
    Reported-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5a5457ac9cdb..d8c672d4ae1d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2337,14 +2337,6 @@ got_data:
 	if (sdkp->capacity > 0xffffffff)
 		sdp->use_16_for_rw = 1;
 
-	/* Rescale capacity to 512-byte units */
-	if (sector_size == 4096)
-		sdkp->capacity <<= 3;
-	else if (sector_size == 2048)
-		sdkp->capacity <<= 2;
-	else if (sector_size == 1024)
-		sdkp->capacity <<= 1;
-
 	blk_queue_physical_block_size(sdp->request_queue,
 				      sdkp->physical_block_size);
 	sdkp->device->sector_size = sector_size;
@@ -2812,7 +2804,7 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
 	return 0;
 }
 
-static inline u32 logical_to_sectors(struct scsi_device *sdev, u32 blocks)
+static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blocks)
 {
 	return blocks << (ilog2(sdev->sector_size) - 9);
 }
@@ -2900,7 +2892,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
 
-	set_capacity(disk, sdkp->capacity);
+	set_capacity(disk, logical_to_sectors(sdp, sdkp->capacity));
 	sd_config_write_same(sdkp);
 	kfree(buffer);
 
