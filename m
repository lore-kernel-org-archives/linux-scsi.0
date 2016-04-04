From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/9] sd: configure ZBC devices
Date: Mon,  4 Apr 2016 12:00:14 +0200
Message-ID: <1459764020-126038-4-git-send-email-hare@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbcDDKAq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 06:00:46 -0400
In-Reply-To: <1459764020-126038-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

For ZBC devices I/O must not cross zone boundaries, so setup
the 'chunk_sectors' block queue setting to the zone size.
This is only valid for REPORT ZONES SAME type 2 or 3;
for other types the zone sizes might be different
for individual zones. So issue a warning if the type is
found to be different.
Also the capacity might be different from the announced
capacity, so adjust it as needed.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sd.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/sd.h |   2 +
 2 files changed, 104 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8401697..74637fd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1972,6 +1972,45 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	}
 }
 
+static int
+sd_zbc_report_zones(struct scsi_disk *sdkp, sector_t start_lba,
+		    unsigned char *buffer, int bufflen )
+{
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout
+		* SD_FLUSH_TIMEOUT_MULTIPLIER;
+	struct scsi_sense_hdr sshdr;
+	unsigned char cmd[16];
+	int result;
+
+	if (!scsi_device_online(sdp)) {
+		sd_printk(KERN_INFO, sdkp, "device not online\n");
+		return -ENODEV;
+	}
+
+	sd_printk(KERN_INFO, sdkp, "REPORT ZONES lba %zu len %d\n",
+		  start_lba, bufflen);
+
+	memset(cmd, 0, 16);
+	cmd[0] = ZBC_IN;
+	cmd[1] = ZI_REPORT_ZONES;
+	put_unaligned_be64(start_lba, &cmd[2]);
+	put_unaligned_be32(bufflen, &cmd[10]);
+	memset(buffer, 0, bufflen);
+
+	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+				  buffer, bufflen, &sshdr,
+				  timeout, SD_MAX_RETRIES, NULL);
+
+	if (result) {
+		sd_printk(KERN_NOTICE, sdkp,
+			  "REPORT ZONES lba %zu failed with %d/%d\n",
+			  start_lba, host_byte(result), driver_byte(result));
+
+		return -EIO;
+	}
+	return 0;
+}
 
 /*
  * Determine whether disk supports Data Integrity Field.
@@ -2014,6 +2053,58 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
 	return ret;
 }
 
+static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	int retval;
+	unsigned char *desc;
+	u32 rep_len;
+	u8 same;
+	u64 zone_len, lba;
+
+	if (sdkp->zoned != 1)
+		/* Device managed, no special handling required */
+		return;
+
+	retval = sd_zbc_report_zones(sdkp, 0, buffer, SD_BUF_SIZE);
+	if (retval < 0)
+		return;
+
+	rep_len = get_unaligned_be32(&buffer[0]);
+	if (rep_len < 64) {
+		sd_printk(KERN_WARNING, sdkp,
+			  "REPORT ZONES report invalid length %u\n",
+			  rep_len);
+		return;
+	}
+
+	if (sdkp->rc_basis == 0) {
+		/* The max_lba field is the capacity of a zoned device */
+		lba = get_unaligned_be64(&buffer[8]);
+		if (lba + 1 > sdkp->capacity) {
+			sd_printk(KERN_WARNING, sdkp,
+				  "Max LBA %zu (capacity %zu)\n",
+				  (sector_t) lba + 1, sdkp->capacity);
+			sdkp->capacity = lba + 1;
+		}
+	}
+
+	/*
+	 * Adjust 'chunk_sectors' to the zone length if the device
+	 * supports equal zone sizes.
+	 */
+	same = buffer[4] & 0xf;
+	if (same == 0 || same > 3) {
+		sd_printk(KERN_WARNING, sdkp,
+			  "REPORT ZONES SAME type %d not supported\n", same);
+		return;
+	}
+	/* Read the zone length from the first zone descriptor */
+	desc = &buffer[64];
+	zone_len = logical_to_sectors(sdkp->device,
+				      get_unaligned_be64(&desc[8]));
+	blk_queue_chunk_sectors(sdkp->disk->queue, zone_len);
+}
+
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			struct scsi_sense_hdr *sshdr, int sense_valid,
 			int the_result)
@@ -2122,6 +2213,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	/* Logical blocks per physical block exponent */
 	sdkp->physical_block_size = (1 << (buffer[13] & 0xf)) * sector_size;
 
+	/* RC basis */
+	sdkp->rc_basis = (buffer[12] >> 4) & 0x3;
+
 	/* Lowest aligned logical block */
 	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
 	blk_queue_alignment_offset(sdp->request_queue, alignment);
@@ -2312,6 +2406,11 @@ got_data:
 		sector_size = 512;
 	}
 	blk_queue_logical_block_size(sdp->request_queue, sector_size);
+	blk_queue_physical_block_size(sdp->request_queue,
+				      sdkp->physical_block_size);
+	sdkp->device->sector_size = sector_size;
+
+	sd_read_zones(sdkp, buffer);
 
 	{
 		char cap_str_2[10], cap_str_10[10];
@@ -2338,9 +2437,6 @@ got_data:
 	if (sdkp->capacity > 0xffffffff)
 		sdp->use_16_for_rw = 1;
 
-	blk_queue_physical_block_size(sdp->request_queue,
-				      sdkp->physical_block_size);
-	sdkp->device->sector_size = sector_size;
 }
 
 /* called with buffer of length 512 */
@@ -2727,6 +2823,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, sdkp->disk->queue);
 	}
 
+	sdkp->zoned = (buffer[8] >> 4) & 3;
  out:
 	kfree(buffer);
 }
@@ -2842,14 +2939,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * react badly if we do.
 	 */
 	if (sdkp->media_present) {
-		sd_read_capacity(sdkp, buffer);
-
 		if (sd_try_extended_inquiry(sdp)) {
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
 		}
 
+		sd_read_capacity(sdkp, buffer);
+
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 654630b..ab1696d 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -94,6 +94,8 @@ struct scsi_disk {
 	unsigned	lbpvpd : 1;
 	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
+	unsigned	rc_basis: 2;
+	unsigned	zoned: 2;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
-- 
1.8.5.6

