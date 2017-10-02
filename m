From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V6 03/14] scsi: sd_zbc: Rearrange code
Date: Mon,  2 Oct 2017 16:15:24 +0900
Message-ID: <20171002071535.8007-4-damien.lemoal@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:3420 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdJBHPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 03:15:41 -0400
In-Reply-To: <20171002071535.8007-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Rearrange sd_zbc_setup() to include use_16_for_rw and use_10_for_rw
assignments and move the calculation of sdkp->zone_shift together
with the assignment of the verified zone_blocks value in
sd_zbc_check_zone_size().

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <Bart.VanAssche@wdc.com>
---
 drivers/scsi/sd_zbc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 023f705ae235..7dbaf920679e 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -584,6 +584,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	}
 
 	sdkp->zone_blocks = zone_blocks;
+	sdkp->zone_shift = ilog2(zone_blocks);
 
 	return 0;
 }
@@ -591,10 +592,13 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 static int sd_zbc_setup(struct scsi_disk *sdkp)
 {
 
+	/* READ16/WRITE16 is mandatory for ZBC disks */
+	sdkp->device->use_16_for_rw = 1;
+	sdkp->device->use_10_for_rw = 0;
+
 	/* chunk_sectors indicates the zone size */
 	blk_queue_chunk_sectors(sdkp->disk->queue,
 			logical_to_sectors(sdkp->device, sdkp->zone_blocks));
-	sdkp->zone_shift = ilog2(sdkp->zone_blocks);
 	sdkp->nr_zones = sdkp->capacity >> sdkp->zone_shift;
 	if (sdkp->capacity & (sdkp->zone_blocks - 1))
 		sdkp->nr_zones++;
@@ -657,10 +661,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	if (ret)
 		goto err;
 
-	/* READ16/WRITE16 is mandatory for ZBC disks */
-	sdkp->device->use_16_for_rw = 1;
-	sdkp->device->use_10_for_rw = 0;
-
 	return 0;
 
 err:
-- 
2.13.6
