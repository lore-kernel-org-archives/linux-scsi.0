From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 08/13] sd: Physical block size and alignment support
Date: Fri, 15 May 2009 00:40:30 -0400
Message-ID: <1242362435-11953-9-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

Extract physical block size and lowest aligned LBA from READ
CAPACITY(16) response and adjust queue parameters.

Report physical block size and alignment when applicable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   23 +++++++++++++++++++++--
 drivers/scsi/sd.h |    1 +
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c3afcae..86a8b12 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1306,6 +1306,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3;
+	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
 
@@ -1346,6 +1347,16 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 	sector_size =	(buffer[8] << 24) | (buffer[9] << 16) |
 			(buffer[10] << 8) | buffer[11];
+
+	/* Logical blocks per physical block exponent */
+	sdkp->hw_sector_size = (1 << (buffer[13] & 0xf)) * sector_size;
+
+	/* Lowest aligned logical block */
+	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
+	blk_queue_io_alignment(sdp->request_queue, alignment);
+	if (alignment && sdkp->first_scan)
+		sd_printk(KERN_NOTICE, sdkp, "%u-byte alignment\n", alignment);
+
 	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
 		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
 		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
@@ -1402,6 +1413,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
 			(buffer[6] << 8) | buffer[7];
+	sdkp->hw_sector_size = sector_size;
 	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
 		(buffer[2] << 8) | buffer[3];
 
@@ -1526,11 +1538,17 @@ got_data:
 		string_get_size(sz, STRING_UNITS_10, cap_str_10,
 				sizeof(cap_str_10));
 
-		if (sdkp->first_scan || old_capacity != sdkp->capacity)
+		if (sdkp->first_scan || old_capacity != sdkp->capacity) {
 			sd_printk(KERN_NOTICE, sdkp,
-				  "%llu %d-byte hardware sectors: (%s/%s)\n",
+				  "%llu %d-byte logical blocks: (%s/%s)\n",
 				  (unsigned long long)sdkp->capacity,
 				  sector_size, cap_str_10, cap_str_2);
+
+			if (sdkp->hw_sector_size != sector_size)
+				sd_printk(KERN_NOTICE, sdkp,
+					  "%u-byte physical blocks\n",
+					  sdkp->hw_sector_size);
+		}
 	}
 
 	/* Rescale capacity to 512-byte units */
@@ -1543,6 +1561,7 @@ got_data:
 	else if (sector_size == 256)
 		sdkp->capacity >>= 1;
 
+	blk_queue_physical_block_size(sdp->request_queue, sdkp->hw_sector_size);
 	sdkp->device->sector_size = sector_size;
 }
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 708778c..8474b5b 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -45,6 +45,7 @@ struct scsi_disk {
 	unsigned int	openers;	/* protected by BKL for now, yuck */
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u32		index;
+	unsigned short	hw_sector_size;
 	u8		media_present;
 	u8		write_prot;
 	u8		protection_type;/* Data Integrity Field */
-- 
1.6.0.6

