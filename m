From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 03/16] scsi: sd_zbc: Rearrange code
Date: Sun, 24 Sep 2017 16:02:34 +0900
Message-ID: <20170924070247.25560-4-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Rearrange sd_zbc_setup() to include use_16_for_rw and use_10_for_rw
assignments and move the calculation of sdkp->zone_shift together
with the assignment of the verified zone_blocks value in
sd_zbc_check_zone_size().

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
2.13.5
