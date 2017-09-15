From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 06/12] scsi: sd_zbc: Rearrange code
Date: Fri, 15 Sep 2017 19:06:39 +0900
Message-ID: <20170915100645.17999-7-damien.lemoal@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:33744 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbdIOKIb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 06:08:31 -0400
In-Reply-To: <20170915100645.17999-1-damien.lemoal@wdc.com>
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
---
 drivers/scsi/sd_zbc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index fd29717b6eab..081bf5a3b10b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -532,6 +532,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	}
 
 	sdkp->zone_blocks = zone_blocks;
+	sdkp->zone_shift = ilog2(zone_blocks);
 
 	return 0;
 }
@@ -539,10 +540,13 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
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
@@ -605,10 +609,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
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
