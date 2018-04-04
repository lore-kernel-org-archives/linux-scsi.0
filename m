From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/2] sd_zbc: Avoid errors due to sd_zbc_check_zone_size() execution
Date: Wed,  4 Apr 2018 17:54:17 +0900
Message-ID: <20180404085418.29205-2-damien.lemoal@wdc.com>
References: <20180404085418.29205-1-damien.lemoal@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180404085418.29205-1-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When sd_revalidate() is executed for a ZBC disk (zoned block device),
sd_zbc_read_zones() is called to revalidate the disk zone configuration.
This executes sd_zbc_check_zone_size() to check that the disk zone sizes
are in line with the defined constraints (all zones must be the same
size and a power of 2 number of LBAs). As part of its execution,
sd_zbc_check_zone_size() was temporarily setting sdkp->zone_blocks to 0.
If during the execution of sd_zbc_check_zone_size() within
sd_revalidate() context, another context issues a command which
references sdkp->zone_blocks to check zone alignment of the command
(e.g. a zone reset is issued and sd_zbc_setup_reset_cmnd() is called),
an invalid value for the disk zone size is used and the alignment check
fails.

Simply fix this by using an on-stack variable inside
sd_zbc_check_zone_size() instead of directly using sdkp->zone_blocks.
This change is valid for both revalidate as well as for the first scan
of the device.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/sd_zbc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 89cf4498f535..b59454ed5087 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -403,6 +403,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf)
  */
 static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 {
+	u64 sdkp_zone_blocks = sdkp->zone_blocks;
 	u64 zone_blocks = 0;
 	sector_t block = 0;
 	unsigned char *buf;
@@ -412,8 +413,6 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	int ret;
 	u8 same;
 
-	sdkp->zone_blocks = 0;
-
 	/* Get a buffer */
 	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
 	if (!buf)
@@ -446,11 +445,11 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 		/* Parse zone descriptors */
 		while (rec < buf + buf_len) {
 			zone_blocks = get_unaligned_be64(&rec[8]);
-			if (sdkp->zone_blocks == 0) {
-				sdkp->zone_blocks = zone_blocks;
-			} else if (zone_blocks != sdkp->zone_blocks &&
+			if (sdkp_zone_blocks == 0) {
+				sdkp_zone_blocks = zone_blocks;
+			} else if (zone_blocks != sdkp_zone_blocks &&
 				   (block + zone_blocks < sdkp->capacity
-				    || zone_blocks > sdkp->zone_blocks)) {
+				    || zone_blocks > sdkp_zone_blocks)) {
 				zone_blocks = 0;
 				goto out;
 			}
@@ -467,7 +466,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 
 	} while (block < sdkp->capacity);
 
-	zone_blocks = sdkp->zone_blocks;
+	zone_blocks = sdkp_zone_blocks;
 
 out:
 	if (!zone_blocks) {
-- 
2.14.3
