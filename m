From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] sd_zbc: Fix potential memory leak
Date: Fri,  2 Mar 2018 07:19:28 +0900
Message-ID: <20180301221928.29028-1-damien.lemoal@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Rework sd_zbc_check_zone_size() to avoid a memory leak due to an early
return if sd_zbc_report_zones() fails.

Reported-by: David.butterfield <david.butterfield@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/sd_zbc.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 14174f26af98..ec55a255d1a2 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -366,7 +366,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf)
  */
 static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 {
-	u64 zone_blocks;
+	u64 zone_blocks = 0;
 	sector_t block = 0;
 	unsigned char *buf;
 	unsigned char *rec;
@@ -384,10 +384,8 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 
 	/* Do a report zone to get the same field */
 	ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, 0);
-	if (ret) {
-		zone_blocks = 0;
-		goto out;
-	}
+	if (ret)
+		goto out_free;
 
 	same = buf[4] & 0x0f;
 	if (same > 0) {
@@ -427,7 +425,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 			ret = sd_zbc_report_zones(sdkp, buf,
 						  SD_ZBC_BUF_SIZE, block);
 			if (ret)
-				return ret;
+				goto out_free;
 		}
 
 	} while (block < sdkp->capacity);
@@ -435,35 +433,32 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	zone_blocks = sdkp->zone_blocks;
 
 out:
-	kfree(buf);
-
 	if (!zone_blocks) {
 		if (sdkp->first_scan)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Devices with non constant zone "
 				  "size are not supported\n");
-		return -ENODEV;
-	}
-
-	if (!is_power_of_2(zone_blocks)) {
+		ret = -ENODEV;
+	} else if (!is_power_of_2(zone_blocks)) {
 		if (sdkp->first_scan)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Devices with non power of 2 zone "
 				  "size are not supported\n");
-		return -ENODEV;
-	}
-
-	if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
+		ret = -ENODEV;
+	} else if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
 		if (sdkp->first_scan)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Zone size too large\n");
-		return -ENODEV;
+		ret = -ENODEV;
+	} else {
+		sdkp->zone_blocks = zone_blocks;
+		sdkp->zone_shift = ilog2(zone_blocks);
 	}
 
-	sdkp->zone_blocks = zone_blocks;
-	sdkp->zone_shift = ilog2(zone_blocks);
+out_free:
+	kfree(buf);
 
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.14.3
