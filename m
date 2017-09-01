From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 1/2] scsi: sd: Fix sd_config_write_same()
Date: Fri,  1 Sep 2017 10:07:28 +0900
Message-ID: <20170901010729.16524-2-damien.lemoal@wdc.com>
References: <20170901010729.16524-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47814 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdIABJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 21:09:33 -0400
In-Reply-To: <20170901010729.16524-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>

Reporting a maximum number of blocks that is not aligned on the device
physical size would cause a large write same request to be split into
physically unaligned chunks by __blkdev_issue_write_zeroes() and
__blkdev_issue_write_same(), even if the caller of these functions took
care to align its request to physical sectors.

So make sure the maximum reported is aligned to the device physical
block size. This is only an optional optimization for regular disks,
but this is mandatory to avoid failure of large write same requests
directed at sequential write required zones of host-managed ZBC disks.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6549e5ce09ca..e7d1eed4afa7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -898,6 +898,27 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 	else
 		sdkp->zeroing_mode = SD_ZERO_WRITE;
 
+	if (sdkp->max_ws_blocks &&
+	    sdkp->physical_block_size > logical_block_size) {
+		/*
+		 * Reporting a maximum number of blocks that is not aligned
+		 * on the device physical size would cause a large write same
+		 * request to be split into physically unaligned chunks by
+		 * __blkdev_issue_write_zeroes() and __blkdev_issue_write_same()
+		 * even if the caller of these functions took care to align the
+		 * large request. So make sure the maximum reported is aligned
+		 * to the device physical block size. This is only an optional
+		 * optimization for regular disks, but this is mandatory to
+		 * avoid failure of large write same requests directed at
+		 * sequential write required zones of host-managed ZBC disks.
+		 */
+		sector_t phys_mask =
+			bytes_to_logical(sdkp->device,
+					 sdkp->physical_block_size) - 1;
+
+		sdkp->max_ws_blocks &= ~phys_mask;
+	}
+
 out:
 	blk_queue_max_write_same_sectors(q, sdkp->max_ws_blocks *
 					 (logical_block_size >> 9));
-- 
2.13.5
