From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 1/2] Move ZBC core setup to sd_zbc
Date: Sun, 21 Aug 2016 23:34:01 -0500
Message-ID: <20160822043402.8855-2-shaun@tancheff.com>
References: <20160822043402.8855-1-shaun@tancheff.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160822043402.8855-1-shaun@tancheff.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Ming Lei <ming.lei@canonical.com>, Josh Bingaman <josh.bingaman@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Move the remaining ZBC specific code to sd_zbc.c

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 drivers/scsi/sd.c     |  65 +------------------
 drivers/scsi/sd.h     |  20 ++----
 drivers/scsi/sd_zbc.c | 170 +++++++++++++++++++++++++++++++++++---------------
 3 files changed, 126 insertions(+), 129 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9a649fa..f144df4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2244,68 +2244,6 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
 	return ret;
 }
 
-static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
-{
-	int retval;
-	unsigned char *desc;
-	u32 rep_len;
-	u8 same;
-	u64 zone_len, lba;
-
-	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC)
-		/*
-		 * Device managed or normal SCSI disk,
-		 * no special handling required
-		 */
-		return;
-
-	retval = sd_zbc_report_zones(sdkp, buffer, SD_BUF_SIZE,
-				     0, ZBC_ZONE_REPORTING_OPTION_ALL, false);
-	if (retval < 0)
-		return;
-
-	rep_len = get_unaligned_be32(&buffer[0]);
-	if (rep_len < 64) {
-		sd_printk(KERN_WARNING, sdkp,
-			  "REPORT ZONES report invalid length %u\n",
-			  rep_len);
-		return;
-	}
-
-	if (sdkp->rc_basis == 0) {
-		/* The max_lba field is the capacity of a zoned device */
-		lba = get_unaligned_be64(&buffer[8]);
-		if (lba + 1 > sdkp->capacity) {
-			if (sdkp->first_scan)
-				sd_printk(KERN_WARNING, sdkp,
-					  "Changing capacity from %zu to Max LBA+1 %zu\n",
-					  sdkp->capacity, (sector_t) lba + 1);
-			sdkp->capacity = lba + 1;
-		}
-	}
-
-	/*
-	 * Adjust 'chunk_sectors' to the zone length if the device
-	 * supports equal zone sizes.
-	 */
-	same = buffer[4] & 0xf;
-	if (same > 3) {
-		sd_printk(KERN_WARNING, sdkp,
-			  "REPORT ZONES SAME type %d not supported\n", same);
-		return;
-	}
-	/* Read the zone length from the first zone descriptor */
-	desc = &buffer[64];
-	zone_len = get_unaligned_be64(&desc[8]);
-	sdkp->unmap_alignment = zone_len;
-	sdkp->unmap_granularity = zone_len;
-	blk_queue_chunk_sectors(sdkp->disk->queue,
-				logical_to_sectors(sdkp->device, zone_len));
-
-	sd_zbc_setup(sdkp, zone_len, buffer, SD_BUF_SIZE);
-	sd_config_discard(sdkp, SD_ZBC_RESET_WP);
-}
-
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			struct scsi_sense_hdr *sshdr, int sense_valid,
 			int the_result)
@@ -2611,7 +2549,8 @@ got_data:
 				      sdkp->physical_block_size);
 	sdkp->device->sector_size = sector_size;
 
-	sd_read_zones(sdkp, buffer);
+	if (sd_zbc_config(sdkp, buffer, SD_BUF_SIZE))
+		sd_config_discard(sdkp, SD_ZBC_RESET_WP);
 
 	{
 		char cap_str_2[10], cap_str_10[10];
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index adbf3e0..fc766db 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -289,10 +289,6 @@ static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
 #define SD_ZBC_WRITE_ERR	2
 
 #ifdef CONFIG_SCSI_ZBC
-
-extern int sd_zbc_report_zones(struct scsi_disk *, unsigned char *, int,
-			       sector_t, enum zbc_zone_reporting_options, bool);
-extern int sd_zbc_setup(struct scsi_disk *, u64 zlen, char *buf, int buf_len);
 extern int sd_zbc_setup_zone_report_cmnd(struct scsi_cmnd *cmd, u8 rpt_opt);
 extern int sd_zbc_setup_zone_action(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_discard(struct scsi_cmnd *cmd);
@@ -303,23 +299,15 @@ extern void sd_zbc_uninit_command(struct scsi_cmnd *cmd);
 extern void sd_zbc_remove(struct scsi_disk *);
 extern void sd_zbc_reset_zones(struct scsi_disk *);
 extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, int reason);
+extern bool sd_zbc_config(struct scsi_disk *, void *, size_t);
+
 extern unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp);
 
 #else /* CONFIG_SCSI_ZBC */
 
-static inline int sd_zbc_report_zones(struct scsi_disk *sdkp,
-				      unsigned char *buf, int buf_len,
-				      sector_t start_sector,
-				      enum zbc_zone_reporting_options option,
-				      bool partial)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen,
-			       unsigned char *buf, int buf_len)
+static inline bool sd_zbc_config(struct scsi_disk *sdkp, void *b, size_t sz)
 {
-	return 0;
+	return false;
 }
 
 static inline void sd_zbc_done(struct scsi_cmnd *cmd, int good_bytes) {}
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 0259bda..960af93 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -193,6 +193,55 @@ sector_t zbc_parse_zones(struct scsi_disk *sdkp, u64 zlen, unsigned char *buf,
 	return next_sector;
 }
 
+/**
+ * sd_zbc_report_zones - Issue a REPORT ZONES scsi command
+ * @sdkp: SCSI disk to which the command should be send
+ * @buffer: response buffer
+ * @bufflen: length of @buffer
+ * @start_sector: logical sector for the zone information should be reported
+ * @option: reporting option to be used
+ * @partial: flag to set the 'partial' bit for report zones command
+ */
+static int sd_zbc_report_zones(struct scsi_disk *sdkp, void *buffer,
+			       int bufflen, sector_t start_sector,
+			       enum zbc_zone_reporting_options option,
+			       bool partial)
+{
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout
+			* SD_FLUSH_TIMEOUT_MULTIPLIER;
+	struct scsi_sense_hdr sshdr;
+	sector_t start_lba = sectors_to_logical(sdkp->device, start_sector);
+	unsigned char cmd[16];
+	int result;
+
+	if (!scsi_device_online(sdp))
+		return -ENODEV;
+
+	sd_zbc_debug(sdkp, "REPORT ZONES lba %zu len %d\n", start_lba, bufflen);
+
+	memset(cmd, 0, 16);
+	cmd[0] = ZBC_IN;
+	cmd[1] = ZI_REPORT_ZONES;
+	put_unaligned_be64(start_lba, &cmd[2]);
+	put_unaligned_be32(bufflen, &cmd[10]);
+	cmd[14] = (partial ? ZBC_REPORT_ZONE_PARTIAL : 0) | option;
+	memset(buffer, 0, bufflen);
+
+	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+				buffer, bufflen, &sshdr,
+				timeout, SD_MAX_RETRIES, NULL);
+
+	if (result) {
+		sd_zbc_debug(sdkp,
+			     "REPORT ZONES lba %zu failed with %d/%d\n",
+			     start_lba, host_byte(result), driver_byte(result));
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static void sd_zbc_refresh_zone_work(struct work_struct *work)
 {
 	struct zbc_update_work *zbc_work =
@@ -372,54 +421,6 @@ retry:
 }
 
 /**
- * sd_zbc_report_zones - Issue a REPORT ZONES scsi command
- * @sdkp: SCSI disk to which the command should be send
- * @buffer: response buffer
- * @bufflen: length of @buffer
- * @start_sector: logical sector for the zone information should be reported
- * @option: reporting option to be used
- * @partial: flag to set the 'partial' bit for report zones command
- */
-int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buffer,
-			int bufflen, sector_t start_sector,
-			enum zbc_zone_reporting_options option, bool partial)
-{
-	struct scsi_device *sdp = sdkp->device;
-	const int timeout = sdp->request_queue->rq_timeout
-			* SD_FLUSH_TIMEOUT_MULTIPLIER;
-	struct scsi_sense_hdr sshdr;
-	sector_t start_lba = sectors_to_logical(sdkp->device, start_sector);
-	unsigned char cmd[16];
-	int result;
-
-	if (!scsi_device_online(sdp))
-		return -ENODEV;
-
-	sd_zbc_debug(sdkp, "REPORT ZONES lba %zu len %d\n", start_lba, bufflen);
-
-	memset(cmd, 0, 16);
-	cmd[0] = ZBC_IN;
-	cmd[1] = ZI_REPORT_ZONES;
-	put_unaligned_be64(start_lba, &cmd[2]);
-	put_unaligned_be32(bufflen, &cmd[10]);
-	cmd[14] = (partial ? ZBC_REPORT_ZONE_PARTIAL : 0) | option;
-	memset(buffer, 0, bufflen);
-
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-				buffer, bufflen, &sshdr,
-				timeout, SD_MAX_RETRIES, NULL);
-
-	if (result) {
-		sd_zbc_debug(sdkp,
-			     "REPORT ZONES lba %zu failed with %d/%d\n",
-			     start_lba, host_byte(result), driver_byte(result));
-		return -EIO;
-	}
-
-	return 0;
-}
-
-/**
  * discard_or_write_same - Wrapper to setup Write Same or Reset WP for ZBC dev
  * @cmd: SCSI command / request to setup
  * @sector: Block layer sector (512 byte sector) to map to device.
@@ -1232,10 +1233,10 @@ void sd_zbc_uninit_command(struct scsi_cmnd *cmd)
 }
 
 /**
- * sd_zbc_setup - Load zones of matching zlen size into rb tree.
+ * sd_zbc_init - Load zones of matching zlen size into rb tree.
  *
  */
-int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen, char *buf, int buf_len)
+static int sd_zbc_init(struct scsi_disk *sdkp, u64 zlen, char *buf, int buf_len)
 {
 	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	sector_t last_sector;
@@ -1273,6 +1274,75 @@ int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen, char *buf, int buf_len)
 }
 
 /**
+ * sd_zbc_config() - Configure a ZBC device (on attach)
+ * @sdkp: SCSI disk being attached.
+ * @buffer: Buffer to working data.
+ * @buf_sz: Size of buffer to use for working data
+ *
+ * Return: true of SD_ZBC_RESET_WP provisioning is supported
+ */
+bool sd_zbc_config(struct scsi_disk *sdkp, void *buffer, size_t buf_sz)
+{
+	struct bdev_zone_report *bzrpt = buffer;
+	u64 zone_len, lba;
+	int retval;
+	u32 rep_len;
+	u8 same;
+
+	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC)
+		/*
+		 * Device managed or normal SCSI disk,
+		 * no special handling required
+		 */
+		return false;
+
+	retval = sd_zbc_report_zones(sdkp, bzrpt, buf_sz,
+				     0, ZBC_ZONE_REPORTING_OPTION_ALL, false);
+	if (retval < 0)
+		return false;
+
+	rep_len = be32_to_cpu(bzrpt->descriptor_count);
+	if (rep_len < 7) {
+		sd_printk(KERN_WARNING, sdkp,
+			  "REPORT ZONES report invalid length %u\n",
+			  rep_len);
+		return false;
+	}
+
+	if (sdkp->rc_basis == 0) {
+		/* The max_lba field is the capacity of a zoned device */
+		lba = be64_to_cpu(bzrpt->maximum_lba);
+		if (lba + 1 > sdkp->capacity) {
+			if (sdkp->first_scan)
+				sd_printk(KERN_WARNING, sdkp,
+					  "Changing capacity from %zu to Max LBA+1 %zu\n",
+					  sdkp->capacity, (sector_t) lba + 1);
+			sdkp->capacity = lba + 1;
+		}
+	}
+
+	/*
+	 * Adjust 'chunk_sectors' to the zone length if the device
+	 * supports equal zone sizes.
+	 */
+	same = bzrpt->same_field & 0x0f;
+	if (same > 3) {
+		sd_printk(KERN_WARNING, sdkp,
+			  "REPORT ZONES SAME type %d not supported\n", same);
+		return false;
+	}
+	/* Read the zone length from the first zone descriptor */
+	zone_len = be64_to_cpu(bzrpt->descriptors[0].length);
+	sdkp->unmap_alignment = zone_len;
+	sdkp->unmap_granularity = zone_len;
+	blk_queue_chunk_sectors(sdkp->disk->queue,
+				logical_to_sectors(sdkp->device, zone_len));
+
+	sd_zbc_init(sdkp, zone_len, buffer, buf_sz);
+	return true;
+}
+
+/**
  * sd_zbc_remove - Prepare for device removal.
  * @sdkp: SCSI Disk being removed.
  */
-- 
2.9.3

