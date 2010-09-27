From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] sd: Fix overflow with big physical blocks
Date: Mon, 27 Sep 2010 12:41:04 -0400
Message-ID: <1285605664-27027-3-git-send-email-martin.petersen@oracle.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:61863 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759805Ab0I0Qlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2010 12:41:42 -0400
In-Reply-To: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

The hw_sector_size variable could overflow if a device reported huge
physical blocks.  Switch to the more accurate physical_block_size
terminology and make sure we use an unsigned int to match the range
permitted by READ CAPACITY(16).

Also print a warning of the physical block size exceeds the page size.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   19 +++++++++++++------
 drivers/scsi/sd.h |    2 +-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ffa0689..1c14436 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1554,7 +1554,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	}
 
 	/* Logical blocks per physical block exponent */
-	sdkp->hw_sector_size = (1 << (buffer[13] & 0xf)) * sector_size;
+	sdkp->physical_block_size = (1 << (buffer[13] & 0xf)) * sector_size;
 
 	/* Lowest aligned logical block */
 	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
@@ -1567,7 +1567,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		struct request_queue *q = sdp->request_queue;
 
 		sdkp->thin_provisioning = 1;
-		q->limits.discard_granularity = sdkp->hw_sector_size;
+		q->limits.discard_granularity = sdkp->physical_block_size;
 		q->limits.max_discard_sectors = 0xffffffff;
 
 		if (buffer[14] & 0x40) /* TPRZ */
@@ -1635,7 +1635,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	}
 
 	sdkp->capacity = lba + 1;
-	sdkp->hw_sector_size = sector_size;
+	sdkp->physical_block_size = sector_size;
 	return sector_size;
 }
 
@@ -1756,10 +1756,16 @@ got_data:
 				  (unsigned long long)sdkp->capacity,
 				  sector_size, cap_str_10, cap_str_2);
 
-			if (sdkp->hw_sector_size != sector_size)
+			if (sdkp->physical_block_size != sector_size)
 				sd_printk(KERN_NOTICE, sdkp,
 					  "%u-byte physical blocks\n",
-					  sdkp->hw_sector_size);
+					  sdkp->physical_block_size);
+
+			if (sdkp->physical_block_size > PAGE_CACHE_SIZE)
+				sd_printk(KERN_WARNING, sdkp,
+					  "physical block size %u is bigger "
+					  "than system page size\n",
+					  sdkp->physical_block_size);
 		}
 	}
 
@@ -1773,7 +1779,8 @@ got_data:
 	else if (sector_size == 256)
 		sdkp->capacity >>= 1;
 
-	blk_queue_physical_block_size(sdp->request_queue, sdkp->hw_sector_size);
+	blk_queue_physical_block_size(sdp->request_queue,
+				      sdkp->physical_block_size);
 	sdkp->device->sector_size = sector_size;
 }
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f81a930..f947140 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -50,7 +50,7 @@ struct scsi_disk {
 	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u32		index;
-	unsigned short	hw_sector_size;
+	unsigned int	physical_block_size;
 	u8		media_present;
 	u8		write_prot;
 	u8		protection_type;/* Data Integrity Field */
-- 
1.7.2.2

