From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 04/14] scsi: sd_zbc: Use well defined macros
Date: Mon, 25 Sep 2017 15:14:44 +0900
Message-ID: <20170925061454.5533-5-damien.lemoal@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:20333 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932329AbdIYGPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 02:15:00 -0400
In-Reply-To: <20170925061454.5533-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

instead of open coding, use the min() macro to calculate a report zones
reply buffer length in sd_zbc_check_zone_size() and the round_up()
macro for calculating the number of zones in sd_zbc_setup().

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd_zbc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7dbaf920679e..bbad851c1789 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -475,7 +475,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf)
 	return 0;
 }
 
-#define SD_ZBC_BUF_SIZE 131072
+#define SD_ZBC_BUF_SIZE 131072U
 
 /**
  * sd_zbc_check_zone_size - Check the device zone sizes
@@ -526,10 +526,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 		/* Parse REPORT ZONES header */
 		list_length = get_unaligned_be32(&buf[0]) + 64;
 		rec = buf + 64;
-		if (list_length < SD_ZBC_BUF_SIZE)
-			buf_len = list_length;
-		else
-			buf_len = SD_ZBC_BUF_SIZE;
+		buf_len = min(list_length, SD_ZBC_BUF_SIZE);
 
 		/* Parse zone descriptors */
 		while (rec < buf + buf_len) {
@@ -599,9 +596,8 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	/* chunk_sectors indicates the zone size */
 	blk_queue_chunk_sectors(sdkp->disk->queue,
 			logical_to_sectors(sdkp->device, sdkp->zone_blocks));
-	sdkp->nr_zones = sdkp->capacity >> sdkp->zone_shift;
-	if (sdkp->capacity & (sdkp->zone_blocks - 1))
-		sdkp->nr_zones++;
+	sdkp->nr_zones =
+		round_up(sdkp->capacity, sdkp->zone_blocks) >> sdkp->zone_shift;
 
 	if (!sdkp->zones_wlock) {
 		sdkp->zones_wlock = kcalloc(BITS_TO_LONGS(sdkp->nr_zones),
-- 
2.13.5
