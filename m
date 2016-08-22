From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2 1/4] Enable support for Seagate HostAware drives
Date: Sun, 21 Aug 2016 23:31:13 -0500
Message-ID: <20160822043116.21168-2-shaun@tancheff.com>
References: <20160822043116.21168-1-shaun@tancheff.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160822043116.21168-1-shaun@tancheff.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Seagate drives report a SAME code of 0 due to having:
  - Zones of different types (CMR zones at the low LBA space).
  - Zones of different size (A terminating 'runt' zone in the high
    lba space).

Support loading the zone topology into the zone cache.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 drivers/scsi/sd.c      |  22 +++---
 drivers/scsi/sd.h      |  20 ++++--
 drivers/scsi/sd_zbc.c  | 183 +++++++++++++++++++++++++++++++++++--------------
 include/linux/blkdev.h |  16 +++--
 4 files changed, 170 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 059a57f..7903e21 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -693,8 +693,13 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 
 	case SD_ZBC_RESET_WP:
-		max_blocks = sdkp->unmap_granularity;
 		q->limits.discard_zeroes_data = 1;
+		q->limits.discard_granularity =
+			sd_zbc_discard_granularity(sdkp);
+
+		max_blocks = min_not_zero(sdkp->unmap_granularity,
+					  q->limits.discard_granularity >>
+						ilog2(logical_block_size));
 		break;
 
 	case SD_LBP_ZERO:
@@ -1955,13 +1960,12 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
 		} else {
-#ifdef CONFIG_SCSI_ZBC
 			if (op == ZBC_OUT)
 				/* RESET WRITE POINTER failed */
 				sd_zbc_update_zones(sdkp,
 						    blk_rq_pos(req),
-						    512, true);
-#endif
+						    512, SD_ZBC_RESET_WP_ERR);
+
 			good_bytes = 0;
 			scsi_set_resid(SCpnt, blk_rq_bytes(req));
 		}
@@ -2034,7 +2038,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 				good_bytes = blk_rq_bytes(req);
 				scsi_set_resid(SCpnt, 0);
 			}
-#ifdef CONFIG_SCSI_ZBC
 			/*
 			 * ZBC: Unaligned write command.
 			 * Write did not start a write pointer position.
@@ -2042,8 +2045,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			if (sshdr.ascq == 0x04)
 				sd_zbc_update_zones(sdkp,
 						    blk_rq_pos(req),
-						    512, true);
-#endif
+						    512, SD_ZBC_WRITE_ERR);
 		}
 		break;
 	default:
@@ -2270,7 +2272,7 @@ static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
 	 * supports equal zone sizes.
 	 */
 	same = buffer[4] & 0xf;
-	if (same == 0 || same > 3) {
+	if (same > 3) {
 		sd_printk(KERN_WARNING, sdkp,
 			  "REPORT ZONES SAME type %d not supported\n", same);
 		return;
@@ -2282,9 +2284,9 @@ static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
 	sdkp->unmap_granularity = zone_len;
 	blk_queue_chunk_sectors(sdkp->disk->queue,
 				logical_to_sectors(sdkp->device, zone_len));
-	sd_config_discard(sdkp, SD_ZBC_RESET_WP);
 
-	sd_zbc_setup(sdkp, buffer, SD_BUF_SIZE);
+	sd_zbc_setup(sdkp, zone_len, buffer, SD_BUF_SIZE);
+	sd_config_discard(sdkp, SD_ZBC_RESET_WP);
 }
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6ae4505..ef6c132 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -283,19 +283,24 @@ static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+
+#define SD_ZBC_INIT		0
+#define SD_ZBC_RESET_WP_ERR	1
+#define SD_ZBC_WRITE_ERR	2
+
 #ifdef CONFIG_SCSI_ZBC
 
 extern int sd_zbc_report_zones(struct scsi_disk *, unsigned char *, int,
 			       sector_t, enum zbc_zone_reporting_options, bool);
-extern int sd_zbc_setup(struct scsi_disk *, char *, int);
+extern int sd_zbc_setup(struct scsi_disk *, u64 zlen, char *buf, int buf_len);
 extern void sd_zbc_remove(struct scsi_disk *);
 extern void sd_zbc_reset_zones(struct scsi_disk *);
 extern int sd_zbc_setup_discard(struct scsi_disk *, struct request *,
 				sector_t, unsigned int);
 extern int sd_zbc_setup_read_write(struct scsi_disk *, struct request *,
 				   sector_t, unsigned int *);
-extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, bool);
-extern void sd_zbc_refresh_zone_work(struct work_struct *);
+extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, int reason);
+extern unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp);
 
 #else /* CONFIG_SCSI_ZBC */
 
@@ -308,7 +313,7 @@ static inline int sd_zbc_report_zones(struct scsi_disk *sdkp,
 	return -EOPNOTSUPP;
 }
 
-static inline int sd_zbc_setup(struct scsi_disk *sdkp,
+static inline int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen,
 			       unsigned char *buf, int buf_len)
 {
 	return 0;
@@ -328,6 +333,13 @@ static inline int sd_zbc_setup_read_write(struct scsi_disk *sdkp,
 	return BLKPREP_OK;
 }
 
+static inline unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp)
+{
+	return sdkp->device->sector_size;
+}
+
+static inline void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t s,
+				       int buf_sz, int reason) {}
 static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
 #endif /* CONFIG_SCSI_ZBC */
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index f953d16..17414fb 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -36,17 +36,6 @@
 #include "sd.h"
 #include "scsi_priv.h"
 
-enum zbc_zone_cond {
-	ZBC_ZONE_COND_NO_WP,
-	ZBC_ZONE_COND_EMPTY,
-	ZBC_ZONE_COND_IMPLICIT_OPEN,
-	ZBC_ZONE_COND_EXPLICIT_OPEN,
-	ZBC_ZONE_COND_CLOSED,
-	ZBC_ZONE_COND_READONLY = 0xd,
-	ZBC_ZONE_COND_FULL,
-	ZBC_ZONE_COND_OFFLINE,
-};
-
 #define SD_ZBC_BUF_SIZE 524288
 
 #define sd_zbc_debug(sdkp, fmt, args...)				\
@@ -69,10 +58,10 @@ struct zbc_update_work {
 	char		zone_buf[0];
 };
 
+static
 struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
 {
 	struct blk_zone *zone;
-	enum zbc_zone_cond zone_cond;
 	sector_t wp = (sector_t)-1;
 
 	zone = kzalloc(sizeof(struct blk_zone), GFP_KERNEL);
@@ -81,37 +70,27 @@ struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
 
 	spin_lock_init(&zone->lock);
 	zone->type = rec[0] & 0xf;
-	zone_cond = (rec[1] >> 4) & 0xf;
+	zone->state = (rec[1] >> 4) & 0xf;
 	zone->len = logical_to_sectors(sdkp->device,
 				       get_unaligned_be64(&rec[8]));
 	zone->start = logical_to_sectors(sdkp->device,
 					 get_unaligned_be64(&rec[16]));
 
-	if (blk_zone_is_smr(zone)) {
+	if (blk_zone_is_smr(zone))
 		wp = logical_to_sectors(sdkp->device,
 					get_unaligned_be64(&rec[24]));
-		if (zone_cond == ZBC_ZONE_COND_READONLY) {
-			zone->state = BLK_ZONE_READONLY;
-		} else if (zone_cond == ZBC_ZONE_COND_OFFLINE) {
-			zone->state = BLK_ZONE_OFFLINE;
-		} else {
-			zone->state = BLK_ZONE_OPEN;
-		}
-	} else
-		zone->state = BLK_ZONE_NO_WP;
-
 	zone->wp = wp;
 	/*
 	 * Fixup block zone state
 	 */
-	if (zone_cond == ZBC_ZONE_COND_EMPTY &&
+	if (zone->state == BLK_ZONE_EMPTY &&
 	    zone->wp != zone->start) {
 		sd_zbc_debug(sdkp,
 			     "zone %zu state EMPTY wp %zu: adjust wp\n",
 			     zone->start, zone->wp);
 		zone->wp = zone->start;
 	}
-	if (zone_cond == ZBC_ZONE_COND_FULL &&
+	if (zone->state == BLK_ZONE_FULL &&
 	    zone->wp != zone->start + zone->len) {
 		sd_zbc_debug(sdkp,
 			     "zone %zu state FULL wp %zu: adjust wp\n",
@@ -122,7 +101,8 @@ struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
 	return zone;
 }
 
-sector_t zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
+static
+sector_t zbc_parse_zones(struct scsi_disk *sdkp, u64 zlen, unsigned char *buf,
 			 unsigned int buf_len)
 {
 	struct request_queue *q = sdkp->disk->queue;
@@ -149,6 +129,11 @@ sector_t zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
 		if (!this)
 			break;
 
+		if (same == 0 && this->len != zlen) {
+			next_sector = this->start + this->len;
+			break;
+		}
+
 		next_sector = this->start + this->len;
 		old = blk_insert_zone(q, this);
 		if (old) {
@@ -171,29 +156,58 @@ sector_t zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return next_sector;
 }
 
-void sd_zbc_refresh_zone_work(struct work_struct *work)
+static void sd_zbc_refresh_zone_work(struct work_struct *work)
 {
 	struct zbc_update_work *zbc_work =
 		container_of(work, struct zbc_update_work, zone_work);
 	struct scsi_disk *sdkp = zbc_work->sdkp;
 	struct request_queue *q = sdkp->disk->queue;
-	unsigned int zone_buflen;
+	unsigned char *zone_buf = zbc_work->zone_buf;
+	unsigned int zone_buflen = zbc_work->zone_buflen;
 	int ret;
+	u8 same;
+	u64 zlen = 0;
 	sector_t last_sector;
 	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 
-	zone_buflen = zbc_work->zone_buflen;
-	ret = sd_zbc_report_zones(sdkp, zbc_work->zone_buf, zone_buflen,
+	ret = sd_zbc_report_zones(sdkp, zone_buf, zone_buflen,
 				  zbc_work->zone_sector,
 				  ZBC_ZONE_REPORTING_OPTION_ALL, true);
 	if (ret)
 		goto done_free;
 
-	last_sector = zbc_parse_zones(sdkp, zbc_work->zone_buf, zone_buflen);
+	/* this whole path is unlikely so extra reports shouldn't be a
+	 * large impact */
+	same = zone_buf[4] & 0xf;
+	if (same == 0) {
+		unsigned char *desc = &zone_buf[64];
+		unsigned int blen = zone_buflen;
+
+		/* just pull the first zone */
+		if (blen > 512)
+			blen = 512;
+		ret = sd_zbc_report_zones(sdkp, zone_buf, blen, 0,
+					  ZBC_ZONE_REPORTING_OPTION_ALL, true);
+		if (ret)
+			goto done_free;
+
+		/* Read the zone length from the first zone descriptor */
+		zlen = logical_to_sectors(sdkp->device,
+					  get_unaligned_be64(&desc[8]));
+
+		ret = sd_zbc_report_zones(sdkp, zone_buf, zone_buflen,
+					  zbc_work->zone_sector,
+					  ZBC_ZONE_REPORTING_OPTION_ALL, true);
+		if (ret)
+			goto done_free;
+	}
+
+	last_sector = zbc_parse_zones(sdkp, zlen, zone_buf, zone_buflen);
+	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	if (last_sector != -1 && last_sector < capacity) {
 		if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
 			sd_zbc_debug(sdkp,
-				     "zones in reset, cancelling refresh\n");
+				     "zones in reset, canceling refresh\n");
 			ret = -EAGAIN;
 			goto done_free;
 		}
@@ -207,7 +221,7 @@ done_free:
 	kfree(zbc_work);
 	if (test_and_clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags) && ret) {
 		sd_zbc_debug(sdkp,
-			     "Cancelling zone initialisation\n");
+			     "Canceling zone initialization\n");
 	}
 done_start_queue:
 	if (q->mq_ops)
@@ -226,10 +240,10 @@ done_start_queue:
  * @sdkp: SCSI disk for which the zone information needs to be updated
  * @sector: sector to be updated
  * @bufsize: buffersize to be allocated
- * @update: true if existing zones should be updated
+ * @reason: non-zero if existing zones should be updated
  */
 void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t sector, int bufsize,
-			 bool update)
+			 int reason)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	struct zbc_update_work *zbc_work;
@@ -240,13 +254,24 @@ void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t sector, int bufsize,
 
 	if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
 		sd_zbc_debug(sdkp,
-			     "zones in reset, not starting update\n");
+			     "zones in reset, not starting reason\n");
 		return;
 	}
 
+	if (reason != SD_ZBC_INIT) {
+		/* lookup sector, is zone pref? then ignore */
+		struct blk_zone *zone = blk_lookup_zone(q, sector);
+
+		if (reason == SD_ZBC_RESET_WP)
+			sd_zbc_debug(sdkp, "RESET WP failed %lx\n", sector);
+
+		if (zone && blk_zone_is_seq_pref(zone))
+			return;
+	}
+
 retry:
 	zbc_work = kzalloc(sizeof(struct zbc_update_work) + bufsize,
-			   update ? GFP_NOWAIT : GFP_KERNEL);
+			   reason != SD_ZBC_INIT ? GFP_NOWAIT : GFP_KERNEL);
 	if (!zbc_work) {
 		if (bufsize > 512) {
 			sd_zbc_debug(sdkp,
@@ -256,7 +281,7 @@ retry:
 		}
 		sd_zbc_debug(sdkp,
 			     "failed to allocate %d bytes\n", bufsize);
-		if (!update)
+		if (reason == SD_ZBC_INIT)
 			clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags);
 		return;
 	}
@@ -269,7 +294,7 @@ retry:
 	/*
 	 * Mark zones under update as BUSY
 	 */
-	if (update) {
+	if (reason != SD_ZBC_INIT) {
 		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
 			unsigned long flags;
 
@@ -333,8 +358,7 @@ int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buffer,
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	sd_zbc_debug(sdkp, "REPORT ZONES lba %zu len %d\n",
-		     start_lba, bufflen);
+	sd_zbc_debug(sdkp, "REPORT ZONES lba %zu len %d\n", start_lba, bufflen);
 
 	memset(cmd, 0, 16);
 	cmd[0] = ZBC_IN;
@@ -460,9 +484,37 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 		goto out;
 	}
 
-	if (req_op(rq) == REQ_OP_WRITE || req_op(rq) == REQ_OP_WRITE_SAME) {
-		if (zone->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
-			goto out;
+	if (blk_zone_is_cmr(zone))
+		goto out;
+
+	if (blk_zone_is_seq_pref(zone)) {
+		if (op_is_write(req_op(rq))) {
+			u64 nwp = sector + sectors;
+
+			while (nwp > (zone->start + zone->len)) {
+				struct rb_node *node = rb_next(&zone->node);
+
+				zone->wp = zone->start + zone->len;
+				sector = zone->wp;
+				sectors = nwp - zone->wp;
+				spin_unlock_irqrestore(&zone->lock, flags);
+
+				if (!node)
+					return BLKPREP_OK;
+				zone = rb_entry(node, struct blk_zone, node);
+				if (!zone)
+					return BLKPREP_OK;
+
+				spin_lock_irqsave(&zone->lock, flags);
+				nwp = sector + sectors;
+			}
+			if (nwp > zone->wp)
+				zone->wp = nwp;
+		}
+		goto out;
+	}
+
+	if (op_is_write(req_op(rq))) {
 		if (zone->state == BLK_ZONE_READONLY)
 			goto out;
 		if (blk_zone_is_full(zone)) {
@@ -480,8 +532,7 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 			goto out;
 		}
 		zone->wp += sectors;
-	} else if (zone->type == BLK_ZONE_TYPE_SEQWRITE_REQ &&
-		   zone->wp <= sector + sectors) {
+	} else if (zone->wp <= sector + sectors) {
 		if (zone->wp <= sector) {
 			/* Read beyond WP: clear request buffer */
 			struct req_iterator iter;
@@ -513,14 +564,18 @@ out:
 	return ret;
 }
 
-int sd_zbc_setup(struct scsi_disk *sdkp, char *buf, int buf_len)
+/**
+ * sd_zbc_setup - Load zones of matching zlen size into rb tree.
+ *
+ */
+int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen, char *buf, int buf_len)
 {
 	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	sector_t last_sector;
 
 	if (test_and_set_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags)) {
 		sdev_printk(KERN_WARNING, sdkp->device,
-			    "zone initialisation already running\n");
+			    "zone initialization already running\n");
 		return 0;
 	}
 
@@ -539,15 +594,20 @@ int sd_zbc_setup(struct scsi_disk *sdkp, char *buf, int buf_len)
 		clear_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags);
 	}
 
-	last_sector = zbc_parse_zones(sdkp, buf, buf_len);
+	last_sector = zbc_parse_zones(sdkp, zlen, buf, buf_len);
+	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	if (last_sector != -1 && last_sector < capacity) {
-		sd_zbc_update_zones(sdkp, last_sector, SD_ZBC_BUF_SIZE, false);
+		sd_zbc_update_zones(sdkp, last_sector,
+				    SD_ZBC_BUF_SIZE, SD_ZBC_INIT);
 	} else
 		clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags);
 
 	return 0;
 }
 
+/**
+ * sd_zbc_remove -
+ */
 void sd_zbc_remove(struct scsi_disk *sdkp)
 {
 	if (sdkp->zone_work_q) {
@@ -557,3 +617,24 @@ void sd_zbc_remove(struct scsi_disk *sdkp)
 		destroy_workqueue(sdkp->zone_work_q);
 	}
 }
+/**
+ * sd_zbc_discard_granularity - Determine discard granularity.
+ * @sdkp: SCSI disk used to calculate discard granularity.
+ *
+ * Discard granularity should match the (maximum non-CMR) zone
+ * size reported on the drive.
+ */
+unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp)
+{
+	unsigned int bytes = 1;
+	struct request_queue *q = sdkp->disk->queue;
+	struct rb_node *node = rb_first(&q->zones);
+
+	if (node) {
+		struct blk_zone *zone = rb_entry(node, struct blk_zone, node);
+
+		bytes = zone->len;
+	}
+	bytes <<= ilog2(sdkp->device->sector_size);
+	return bytes;
+}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9084a9e..68198eb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -272,12 +272,16 @@ enum blk_zone_type {
 };
 
 enum blk_zone_state {
-	BLK_ZONE_UNKNOWN,
 	BLK_ZONE_NO_WP,
+	BLK_ZONE_EMPTY,
 	BLK_ZONE_OPEN,
-	BLK_ZONE_READONLY,
+	BLK_ZONE_OPEN_EXPLICIT,
+	BLK_ZONE_CLOSED,
+	BLK_ZONE_UNKNOWN = 5,
+	BLK_ZONE_READONLY = 0xd,
+	BLK_ZONE_FULL,
 	BLK_ZONE_OFFLINE,
-	BLK_ZONE_BUSY,
+	BLK_ZONE_BUSY = 0x20,
 };
 
 struct blk_zone {
@@ -291,9 +295,9 @@ struct blk_zone {
 	void *private_data;
 };
 
-#define blk_zone_is_smr(z) ((z)->type == BLK_ZONE_TYPE_SEQWRITE_REQ ||	\
-			    (z)->type == BLK_ZONE_TYPE_SEQWRITE_PREF)
-
+#define blk_zone_is_seq_req(z) ((z)->type == BLK_ZONE_TYPE_SEQWRITE_REQ)
+#define blk_zone_is_seq_pref(z) ((z)->type == BLK_ZONE_TYPE_SEQWRITE_PREF)
+#define blk_zone_is_smr(z) (blk_zone_is_seq_req(z) || blk_zone_is_seq_pref(z))
 #define blk_zone_is_cmr(z) ((z)->type == BLK_ZONE_TYPE_CONVENTIONAL)
 #define blk_zone_is_full(z) ((z)->wp == (z)->start + (z)->len)
 #define blk_zone_is_empty(z) ((z)->wp == (z)->start)
-- 
2.9.3

