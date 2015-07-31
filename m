From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/8] sd: Set chunk_sectors to zone size
Date: Fri, 31 Jul 2015 15:36:15 +0200
Message-ID: <1438349780-116429-4-git-send-email-hare@suse.de>
References: <1438349780-116429-1-git-send-email-hare@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438349780-116429-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

For ZBC devices I/O must not cross zone boundaries, so setup
the 'chunk_sectors' block queue setting to the zone size.
This is only valid for REPORT ZONES SAME type 2 or 3;
for other types the zone sizes might be different
for individual zones. So issue a warning if the type is
found to be different.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sd.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 77 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b2fcb4..b5d412a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1861,6 +1861,45 @@ sd_spinup_disk(struct scsi_disk *sdkp)
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
@@ -2631,6 +2670,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, sdkp->disk->queue);
 	}
 
+	sdkp->zoned = (buffer[8] >> 4) & 3;
  out:
 	kfree(buffer);
 }
@@ -2692,6 +2732,41 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->ws10 = 1;
 }
 
+static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	int retval;
+	unsigned char *desc;
+	u32 rep_len;
+	u8 same;
+	u64 zone_len;
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
+	same = buffer[4] & 0xf;
+	if (same != 2 && same != 3) {
+		sd_printk(KERN_WARNING, sdkp,
+			  "REPORT ZONES SAME type %d not supported\n", same);
+		return;
+	}
+	if (rep_len < 64) {
+		sd_printk(KERN_WARNING, sdkp,
+			  "REPORT ZONES report invalid length %u\n",
+			  rep_len);
+		return;
+	}
+	/* Read the zone length from the first zone descriptor */
+	desc = &buffer[64];
+	zone_len = get_unaligned_be64(&desc[8]);
+	blk_queue_chunk_sectors(sdkp->disk->queue, zone_len);
+}
+
 static int sd_try_extended_inquiry(struct scsi_device *sdp)
 {
 	/* Attempt VPD inquiry if the device blacklist explicitly calls
@@ -2757,6 +2832,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
 		sd_read_write_same(sdkp, buffer);
+		sd_read_zones(sdkp, buffer);
 	}
 
 	sdkp->first_scan = 0;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 63ba5ca..6500d51 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -93,6 +93,7 @@ struct scsi_disk {
 	unsigned	lbpvpd : 1;
 	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
+	unsigned	zoned: 2;	/* ZONED field */
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
-- 
1.8.5.2
