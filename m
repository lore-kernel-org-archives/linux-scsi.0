From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/2] scsi: sd_zbc: Fix potential memory leak
Date: Thu, 31 May 2018 19:31:23 +0900
Message-ID: <20180531103124.21532-2-damien.lemoal@wdc.com>
References: <20180531103124.21532-1-damien.lemoal@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180531103124.21532-1-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

[Backport of upstream commit 0aa3fdb8b3a6df3c2e3b61dbfe079db9d30e03cd]

Rework sd_zbc_check_zone_size() to avoid a memory leak due to an early
return if sd_zbc_report_zones() fails.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org # 4.14
---
 drivers/scsi/sd_zbc.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 2eb61d54bbb4..bc3cb81a9c7d 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -425,7 +425,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp,
 
 static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 {
-	u64 zone_blocks;
+	u64 zone_blocks = 0;
 	sector_t block = 0;
 	unsigned char *buf;
 	unsigned char *rec;
@@ -443,10 +443,8 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 
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
@@ -489,7 +487,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 			ret = sd_zbc_report_zones(sdkp, buf,
 						  SD_ZBC_BUF_SIZE, block);
 			if (ret)
-				return ret;
+				goto out_free;
 		}
 
 	} while (block < sdkp->capacity);
@@ -497,34 +495,32 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
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
+out_free:
+	kfree(buf);
 
-	return 0;
+	return ret;
 }
 
 static int sd_zbc_setup(struct scsi_disk *sdkp)
-- 
2.17.0
