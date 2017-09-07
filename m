From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 06/12] scsi: sd_zbc: Rearrange code
Date: Fri,  8 Sep 2017 01:16:34 +0900
Message-ID: <20170907161640.30465-7-damien.lemoal@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:6565 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932095AbdIGQSa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2017 12:18:30 -0400
In-Reply-To: <20170907161640.30465-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Move inline functions sd_zbc_zone_sectors() and sd_zbc_zone_no()
declarations to sd_zbc.h and rearrange sd_zbc_setup() to include
use_16_for_rw and use_10_for_rw assignment.
Also move calculation of sdkp->zone_shift together with the assignment
of the verified zone_blocks value in sd_zbc_check_zone_size().

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 21 +++++----------------
 drivers/scsi/sd_zbc.h | 17 +++++++++++++++++
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index e0927f8fb829..a25a940243a9 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -206,17 +206,6 @@ static void sd_zbc_report_zones_complete(struct scsi_cmnd *scmd,
 	local_irq_restore(flags);
 }
 
-static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
-{
-	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
-}
-
-static inline unsigned int sd_zbc_zone_no(struct scsi_disk *sdkp,
-					  sector_t sector)
-{
-	return sectors_to_logical(sdkp->device, sector) >> sdkp->zone_shift;
-}
-
 /*
  * Prepare a RESET WRITE POINTER scsi command for a REQ_OP_ZONE_RESET request.
  */
@@ -516,6 +505,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	}
 
 	sdkp->zone_blocks = zone_blocks;
+	sdkp->zone_shift = ilog2(zone_blocks);
 
 	return 0;
 }
@@ -523,10 +513,13 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
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
@@ -589,10 +582,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	if (ret)
 		goto err;
 
-	/* READ16/WRITE16 is mandatory for ZBC disks */
-	sdkp->device->use_16_for_rw = 1;
-	sdkp->device->use_10_for_rw = 0;
-
 	return 0;
 
 err:
diff --git a/drivers/scsi/sd_zbc.h b/drivers/scsi/sd_zbc.h
index 5e7ecc9b2966..b34002f0acbe 100644
--- a/drivers/scsi/sd_zbc.h
+++ b/drivers/scsi/sd_zbc.h
@@ -15,6 +15,23 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
 void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 		     struct scsi_sense_hdr *sshdr);
 
+/*
+ * Zone size in number of 512B sectors.
+ */
+static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
+{
+	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
+}
+
+/*
+ * Zone number of the specified sector.
+ */
+static inline unsigned int sd_zbc_zone_no(struct scsi_disk *sdkp,
+					  sector_t sector)
+{
+	return sectors_to_logical(sdkp->device, sector) >> sdkp->zone_shift;
+}
+
 #else /* CONFIG_BLK_DEV_ZONED */
 
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
-- 
2.13.5
