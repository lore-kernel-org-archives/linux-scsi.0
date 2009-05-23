From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/3] sd: Physical block size and alignment support
Date: Sat, 23 May 2009 11:43:37 -0400
Message-ID: <1243093419-14371-2-git-send-email-martin.petersen@oracle.com>
References: <1243093419-14371-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:55119 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbZEWPnq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 May 2009 11:43:46 -0400
In-Reply-To: <1243093419-14371-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Extract physical block size and lowest aligned LBA from READ
CAPACITY(16) response and adjust queue parameters.

Report physical block size and alignment when applicable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   23 +++++++++++++++++++++--
 drivers/scsi/sd.h |    1 +
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bcf3bd4..fd5c580 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1307,6 +1307,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3;
+	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
 
@@ -1358,6 +1359,16 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -EOVERFLOW;
 	}
 
+	/* Logical blocks per physical block exponent */
+	sdkp->hw_sector_size = (1 << (buffer[13] & 0xf)) * sector_size;
+
+	/* Lowest aligned logical block */
+	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
+	blk_queue_alignment_offset(sdp->request_queue, alignment);
+	if (alignment && sdkp->first_scan)
+		sd_printk(KERN_NOTICE, sdkp, 
+			  "physical block alignment offset: %u\n", alignment);
+
 	sdkp->capacity = lba + 1;
 	return sector_size;
 }
@@ -1409,6 +1420,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	}
 
 	sdkp->capacity = lba + 1;
+	sdkp->hw_sector_size = sector_size;
 	return sector_size;
 }
 
@@ -1521,11 +1533,17 @@ got_data:
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
@@ -1538,6 +1556,7 @@ got_data:
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

