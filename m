From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 2/2] Migrate zone cache from RB-Tree to arrays of descriptors
Date: Sun, 21 Aug 2016 23:34:02 -0500
Message-ID: <20160822043402.8855-3-shaun@tancheff.com>
References: <20160822043402.8855-1-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34265 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752446AbcHVEgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 00:36:00 -0400
In-Reply-To: <20160822043402.8855-1-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Ming Lei <ming.lei@canonical.com>, Josh Bingaman <josh.bingaman@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

Currently the RB-Tree zone cache is fast and flexible. It does
use a rather largish amount of ram. This model reduces the ram
required from 120 bytes per zone to 16 bytes per zone with a
moderate transformation of the blk_zone_lookup() api.

This model is predicated on the belief that most variations
on zoned media will follow a pattern of using collections of same
sized zones on a single device. Similar to the pattern of erase
blocks on flash devices being progressivly larger 16K, 64K, ...

The goal is to be able to build a descriptor which is both memory
efficient, performant, and flexible.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 block/blk-core.c       |    2 +-
 block/blk-sysfs.c      |   31 +-
 block/blk-zoned.c      |  103 +++--
 drivers/scsi/sd.c      |    5 +-
 drivers/scsi/sd.h      |    4 +-
 drivers/scsi/sd_zbc.c  | 1025 +++++++++++++++++++++++++++---------------------
 include/linux/blkdev.h |   82 +++-
 7 files changed, 716 insertions(+), 536 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a9caf7..3b084a8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -727,7 +727,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	INIT_LIST_HEAD(&q->blkg_list);
 #endif
 #ifdef CONFIG_BLK_DEV_ZONED
-	q->zones = RB_ROOT;
+	q->zones = NULL;
 #endif
 	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 43f441f..ecbd434 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -232,36 +232,7 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 #ifdef CONFIG_BLK_DEV_ZONED
 static ssize_t queue_zoned_show(struct request_queue *q, char *page)
 {
-	struct rb_node *node;
-	struct blk_zone *zone;
-	ssize_t offset = 0, end = 0;
-	size_t size = 0, num = 0;
-	enum blk_zone_type type = BLK_ZONE_TYPE_UNKNOWN;
-
-	for (node = rb_first(&q->zones); node; node = rb_next(node)) {
-		zone = rb_entry(node, struct blk_zone, node);
-		if (zone->type != type ||
-		    zone->len != size ||
-		    end != zone->start) {
-			if (size != 0)
-				offset += sprintf(page + offset, "%zu\n", num);
-			/* We can only store one page ... */
-			if (offset + 42 > PAGE_SIZE) {
-				offset += sprintf(page + offset, "...\n");
-				return offset;
-			}
-			size = zone->len;
-			type = zone->type;
-			offset += sprintf(page + offset, "%zu %zu %d ",
-					  zone->start, size, type);
-			num = 0;
-			end = zone->start + size;
-		} else
-			end += zone->len;
-		num++;
-	}
-	offset += sprintf(page + offset, "%zu\n", num);
-	return offset;
+	return sprintf(page, "%u\n", q->zones ? 1 : 0);
 }
 #endif
 
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 975e863..338a1af 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -8,63 +8,84 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
-#include <linux/rbtree.h>
+#include <linux/vmalloc.h>
 
-struct blk_zone *blk_lookup_zone(struct request_queue *q, sector_t lba)
+/**
+ * blk_lookup_zone() - Lookup zones
+ * @q: Request Queue
+ * @sector: Location to lookup
+ * @start: Pointer to starting location zone (OUT)
+ * @len: Pointer to length of zone (OUT)
+ * @lock: Pointer to spinlock of zones in owning descriptor (OUT)
+ */
+struct blk_zone *blk_lookup_zone(struct request_queue *q, sector_t sector,
+				 sector_t *start, sector_t *len,
+				 spinlock_t **lock)
 {
-	struct rb_root *root = &q->zones;
-	struct rb_node *node = root->rb_node;
+	int iter;
+	struct blk_zone *bzone = NULL;
+	struct zone_wps *zi = q->zones;
+
+	*start = 0;
+	*len = 0;
+	*lock = NULL;
+
+	if (!q->zones)
+		goto out;
 
-	while (node) {
-		struct blk_zone *zone = container_of(node, struct blk_zone,
-						     node);
+	for (iter = 0; iter < zi->wps_count; iter++) {
+		if (sector >= zi->wps[iter]->start_lba &&
+		    sector <  zi->wps[iter]->last_lba) {
+			struct contiguous_wps *wp = zi->wps[iter];
+			u64 index = (sector - wp->start_lba) / wp->zone_size;
 
-		if (lba < zone->start)
-			node = node->rb_left;
-		else if (lba >= zone->start + zone->len)
-			node = node->rb_right;
-		else
-			return zone;
+			if (index >= wp->zone_count) {
+				WARN(1, "Impossible index for zone\n");
+				goto out;
+			}
+
+			bzone = &wp->zones[index];
+			*len = wp->zone_size;
+			*start = wp->start_lba + (index * wp->zone_size);
+			*lock = &wp->lock;
+		}
 	}
-	return NULL;
+
+out:
+	return bzone;
 }
 EXPORT_SYMBOL_GPL(blk_lookup_zone);
 
-struct blk_zone *blk_insert_zone(struct request_queue *q, struct blk_zone *data)
+/**
+ * free_zone_wps() - Free up memory in use by wps
+ * @zi: zone wps array(s).
+ */
+static void free_zone_wps(struct zone_wps *zi)
 {
-	struct rb_root *root = &q->zones;
-	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	/* on error free the arrays */
+	if (zi && zi->wps) {
+		int ca;
 
-	/* Figure out where to put new node */
-	while (*new) {
-		struct blk_zone *this = container_of(*new, struct blk_zone,
-						     node);
-		parent = *new;
-		if (data->start + data->len <= this->start)
-			new = &((*new)->rb_left);
-		else if (data->start >= this->start + this->len)
-			new = &((*new)->rb_right);
-		else {
-			/* Return existing zone */
-			return this;
+		for (ca = 0; ca < zi->wps_count; ca++) {
+			if (zi->wps[ca]) {
+				vfree(zi->wps[ca]);
+				zi->wps[ca] = NULL;
+			}
 		}
+		kfree(zi->wps);
 	}
-	/* Add new node and rebalance tree. */
-	rb_link_node(&data->node, parent, new);
-	rb_insert_color(&data->node, root);
-
-	return NULL;
 }
-EXPORT_SYMBOL_GPL(blk_insert_zone);
 
+/**
+ * blk_drop_zones() - Free zones
+ * @q: Request Queue
+ */
 void blk_drop_zones(struct request_queue *q)
 {
-	struct rb_root *root = &q->zones;
-	struct blk_zone *zone, *next;
-
-	rbtree_postorder_for_each_entry_safe(zone, next, root, node) {
-		kfree(zone);
+	if (q->zones) {
+		free_zone_wps(q->zones);
+		kfree(q->zones);
+		q->zones = NULL;
 	}
-	q->zones = RB_ROOT;
 }
 EXPORT_SYMBOL_GPL(blk_drop_zones);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f144df4..0f749f5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2549,8 +2549,9 @@ got_data:
 				      sdkp->physical_block_size);
 	sdkp->device->sector_size = sector_size;
 
-	if (sd_zbc_config(sdkp, buffer, SD_BUF_SIZE))
-		sd_config_discard(sdkp, SD_ZBC_RESET_WP);
+	if (sdkp->first_scan)
+		if (sd_zbc_config(sdkp, GFP_KERNEL))
+			sd_config_discard(sdkp, SD_ZBC_RESET_WP);
 
 	{
 		char cap_str_2[10], cap_str_10[10];
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index fc766db..c9c79e9 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -299,13 +299,13 @@ extern void sd_zbc_uninit_command(struct scsi_cmnd *cmd);
 extern void sd_zbc_remove(struct scsi_disk *);
 extern void sd_zbc_reset_zones(struct scsi_disk *);
 extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, int reason);
-extern bool sd_zbc_config(struct scsi_disk *, void *, size_t);
+extern bool sd_zbc_config(struct scsi_disk *, gfp_t);
 
 extern unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp);
 
 #else /* CONFIG_SCSI_ZBC */
 
-static inline bool sd_zbc_config(struct scsi_disk *sdkp, void *b, size_t sz)
+static inline bool sd_zbc_config(struct scsi_disk *sdkp, gfp_t gfp)
 {
 	return false;
 }
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 960af93..c087035 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -22,6 +22,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/rbtree.h>
+#include <linux/vmalloc.h>
 
 #include <asm/unaligned.h>
 
@@ -51,11 +52,11 @@
 	} while( 0 )
 
 struct zbc_update_work {
-	struct work_struct zone_work;
-	struct scsi_disk *sdkp;
-	sector_t	zone_sector;
-	int		zone_buflen;
-	char		zone_buf[0];
+	struct work_struct	zone_work;
+	struct scsi_disk	*sdkp;
+	sector_t		zone_sector;
+	int			zone_buflen;
+	struct bdev_zone_report zone_buf[0];
 };
 
 /**
@@ -95,102 +96,19 @@ static inline sector_t get_start_from_desc(struct scsi_disk *sdkp,
 	return logical_to_sectors(sdkp->device, be64_to_cpu(bzde->lba_start));
 }
 
-static
-struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
+static void _fill_zone(struct blk_zone *zone, struct scsi_disk *sdkp,
+		       struct bdev_zone_descriptor *bzde)
 {
-	struct blk_zone *zone;
-	sector_t wp = (sector_t)-1;
-
-	zone = kzalloc(sizeof(struct blk_zone), GFP_KERNEL);
-	if (!zone)
-		return NULL;
-
-	spin_lock_init(&zone->lock);
-	zone->type = rec[0] & 0xf;
-	zone->state = (rec[1] >> 4) & 0xf;
-	zone->len = logical_to_sectors(sdkp->device,
-				       get_unaligned_be64(&rec[8]));
-	zone->start = logical_to_sectors(sdkp->device,
-					 get_unaligned_be64(&rec[16]));
-
-	if (blk_zone_is_smr(zone))
-		wp = logical_to_sectors(sdkp->device,
-					get_unaligned_be64(&rec[24]));
-	zone->wp = wp;
-	/*
-	 * Fixup block zone state
-	 */
-	if (zone->state == BLK_ZONE_EMPTY &&
-	    zone->wp != zone->start) {
-		sd_zbc_debug(sdkp,
-			     "zone %zu state EMPTY wp %zu: adjust wp\n",
-			     zone->start, zone->wp);
-		zone->wp = zone->start;
-	}
-	if (zone->state == BLK_ZONE_FULL &&
-	    zone->wp != zone->start + zone->len) {
-		sd_zbc_debug(sdkp,
-			     "zone %zu state FULL wp %zu: adjust wp\n",
-			     zone->start, zone->wp);
-		zone->wp = zone->start + zone->len;
-	}
-
-	return zone;
+	zone->type = bzde->type & 0x0f;
+	zone->state = (bzde->flags >> 4) & 0x0f;
+	zone->wp = get_wp_from_desc(sdkp, bzde);
 }
 
-static
-sector_t zbc_parse_zones(struct scsi_disk *sdkp, u64 zlen, unsigned char *buf,
-			 unsigned int buf_len)
-{
-	struct request_queue *q = sdkp->disk->queue;
-	unsigned char *rec = buf;
-	int rec_no = 0;
-	unsigned int list_length;
-	sector_t next_sector = -1;
-	u8 same;
-
-	/* Parse REPORT ZONES header */
-	list_length = get_unaligned_be32(&buf[0]);
-	same = buf[4] & 0xf;
-	rec = buf + 64;
-	list_length += 64;
-
-	if (list_length < buf_len)
-		buf_len = list_length;
-
-	while (rec < buf + buf_len) {
-		struct blk_zone *this, *old;
-		unsigned long flags;
 
-		this = zbc_desc_to_zone(sdkp, rec);
-		if (!this)
-			break;
-
-		if (same == 0 && this->len != zlen) {
-			next_sector = this->start + this->len;
-			break;
-		}
-
-		next_sector = this->start + this->len;
-		old = blk_insert_zone(q, this);
-		if (old) {
-			spin_lock_irqsave(&old->lock, flags);
-			if (blk_zone_is_smr(old)) {
-				old->wp = this->wp;
-				old->state = this->state;
-			}
-			spin_unlock_irqrestore(&old->lock, flags);
-			kfree(this);
-		}
-		rec += 64;
-		rec_no++;
-	}
-
-	sd_zbc_debug(sdkp,
-		     "Inserted %d zones, next sector %zu len %d\n",
-		     rec_no, next_sector, list_length);
-
-	return next_sector;
+static void fill_zone(struct contiguous_wps *cwps, int z_count,
+		      struct scsi_disk *sdkp, struct bdev_zone_descriptor *bzde)
+{
+	_fill_zone(&cwps->zones[z_count], sdkp, bzde);
 }
 
 /**
@@ -200,12 +118,10 @@ sector_t zbc_parse_zones(struct scsi_disk *sdkp, u64 zlen, unsigned char *buf,
  * @bufflen: length of @buffer
  * @start_sector: logical sector for the zone information should be reported
  * @option: reporting option to be used
- * @partial: flag to set the 'partial' bit for report zones command
  */
-static int sd_zbc_report_zones(struct scsi_disk *sdkp, void *buffer,
-			       int bufflen, sector_t start_sector,
-			       enum zbc_zone_reporting_options option,
-			       bool partial)
+static int sd_zbc_report_zones(struct scsi_disk *sdkp,
+			       struct bdev_zone_report *buffer,
+			       int bufflen, sector_t start_sector, u8 option)
 {
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
@@ -225,7 +141,7 @@ static int sd_zbc_report_zones(struct scsi_disk *sdkp, void *buffer,
 	cmd[1] = ZI_REPORT_ZONES;
 	put_unaligned_be64(start_lba, &cmd[2]);
 	put_unaligned_be32(bufflen, &cmd[10]);
-	cmd[14] = (partial ? ZBC_REPORT_ZONE_PARTIAL : 0) | option;
+	cmd[14] = option;
 	memset(buffer, 0, bufflen);
 
 	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
@@ -248,49 +164,38 @@ static void sd_zbc_refresh_zone_work(struct work_struct *work)
 		container_of(work, struct zbc_update_work, zone_work);
 	struct scsi_disk *sdkp = zbc_work->sdkp;
 	struct request_queue *q = sdkp->disk->queue;
-	unsigned char *zone_buf = zbc_work->zone_buf;
+	struct bdev_zone_report *rpt = zbc_work->zone_buf;
 	unsigned int zone_buflen = zbc_work->zone_buflen;
+	struct bdev_zone_descriptor *bzde;
+	int iter;
+	int offmax;
+	sector_t z_at, z_start, z_len;
+	spinlock_t *lock;
+	struct blk_zone *zone;
 	int ret;
-	u8 same;
-	u64 zlen = 0;
 	sector_t last_sector;
 	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 
-	ret = sd_zbc_report_zones(sdkp, zone_buf, zone_buflen,
+	ret = sd_zbc_report_zones(sdkp, rpt, zone_buflen,
 				  zbc_work->zone_sector,
-				  ZBC_ZONE_REPORTING_OPTION_ALL, true);
+				  ZBC_ZONE_REPORTING_OPTION_ALL);
 	if (ret)
 		goto done_free;
 
-	/* this whole path is unlikely so extra reports shouldn't be a
-	 * large impact */
-	same = zone_buf[4] & 0xf;
-	if (same == 0) {
-		unsigned char *desc = &zone_buf[64];
-		unsigned int blen = zone_buflen;
-
-		/* just pull the first zone */
-		if (blen > 512)
-			blen = 512;
-		ret = sd_zbc_report_zones(sdkp, zone_buf, blen, 0,
-					  ZBC_ZONE_REPORTING_OPTION_ALL, true);
-		if (ret)
-			goto done_free;
-
-		/* Read the zone length from the first zone descriptor */
-		zlen = logical_to_sectors(sdkp->device,
-					  get_unaligned_be64(&desc[8]));
-
-		ret = sd_zbc_report_zones(sdkp, zone_buf, zone_buflen,
-					  zbc_work->zone_sector,
-					  ZBC_ZONE_REPORTING_OPTION_ALL, true);
-		if (ret)
-			goto done_free;
+	offmax = max_report_entries(zone_buflen);
+	for (iter = 0; iter < offmax; iter++) {
+		bzde = &rpt->descriptors[iter];
+		z_at = get_start_from_desc(sdkp, bzde);
+		if (!z_at)
+			break;
+		zone = blk_lookup_zone(q, z_at, &z_start, &z_len, &lock);
+		if (zone) {
+			_fill_zone(zone, sdkp, bzde);
+			last_sector = z_start + z_len;
+		}
 	}
 
-	last_sector = zbc_parse_zones(sdkp, zlen, zone_buf, zone_buflen);
-	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
-	if (last_sector != -1 && last_sector < capacity) {
+	if (sdkp->zone_work_q && last_sector != -1 && last_sector < capacity) {
 		if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
 			sd_zbc_debug(sdkp,
 				     "zones in reset, canceling refresh\n");
@@ -333,10 +238,7 @@ void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t sector, int bufsize,
 {
 	struct request_queue *q = sdkp->disk->queue;
 	struct zbc_update_work *zbc_work;
-	struct blk_zone *zone;
-	struct rb_node *node;
-	int zone_num = 0, zone_busy = 0, num_rec;
-	sector_t next_sector = sector;
+	int num_rec;
 
 	if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
 		sd_zbc_debug(sdkp,
@@ -346,18 +248,23 @@ void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t sector, int bufsize,
 
 	if (reason != SD_ZBC_INIT) {
 		/* lookup sector, is zone pref? then ignore */
-		struct blk_zone *zone = blk_lookup_zone(q, sector);
-
+		sector_t z_start, z_len;
+		spinlock_t *lck;
+		struct blk_zone *zone = blk_lookup_zone(q, sector, &z_start,
+							&z_len, &lck);
+		/* zone actions on conventional zones are invalid */
+		if (zone && reason == SD_ZBC_RESET_WP && blk_zone_is_cmr(zone))
+			return;
 		if (reason == SD_ZBC_RESET_WP)
 			sd_zbc_debug(sdkp, "RESET WP failed %lx\n", sector);
-
-		if (zone && blk_zone_is_seq_pref(zone))
-			return;
 	}
 
+	if (!sdkp->zone_work_q)
+		return;
+
 retry:
 	zbc_work = kzalloc(sizeof(struct zbc_update_work) + bufsize,
-			   reason != SD_ZBC_INIT ? GFP_NOWAIT : GFP_KERNEL);
+			   reason != SD_ZBC_INIT ? GFP_ATOMIC : GFP_KERNEL);
 	if (!zbc_work) {
 		if (bufsize > 512) {
 			sd_zbc_debug(sdkp,
@@ -381,30 +288,40 @@ retry:
 	 * Mark zones under update as BUSY
 	 */
 	if (reason != SD_ZBC_INIT) {
-		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
-			unsigned long flags;
-
-			zone = rb_entry(node, struct blk_zone, node);
-			if (num_rec == 0)
+		unsigned long flags;
+		int iter;
+		struct zone_wps *zi = q->zones;
+		struct contiguous_wps *wp = NULL;
+		u64 index = -1;
+		int zone_busy = 0;
+		int z_flgd = 0;
+
+		for (iter = 0; iter < zi->wps_count; iter++) {
+			if (sector >= zi->wps[iter]->start_lba &&
+			    sector <  zi->wps[iter]->last_lba) {
+				wp = zi->wps[iter];
 				break;
-			if (zone->start != next_sector)
-				continue;
-			next_sector += zone->len;
-			num_rec--;
-
-			spin_lock_irqsave(&zone->lock, flags);
-			if (blk_zone_is_smr(zone)) {
-				if (zone->state == BLK_ZONE_BUSY) {
+			}
+		}
+		if (wp) {
+			spin_lock_irqsave(&wp->lock, flags);
+			index = (sector - wp->start_lba) / wp->zone_size;
+			while (index < wp->zone_count && z_flgd < num_rec) {
+				struct blk_zone *bzone = &wp->zones[index];
+
+				index++;
+				z_flgd++;
+				if (!blk_zone_is_smr(bzone))
+					continue;
+
+				if (bzone->state == BLK_ZONE_BUSY)
 					zone_busy++;
-				} else {
-					zone->state = BLK_ZONE_BUSY;
-					zone->wp = zone->start;
-				}
-				zone_num++;
+				else
+					bzone->state = BLK_ZONE_BUSY;
 			}
-			spin_unlock_irqrestore(&zone->lock, flags);
+			spin_unlock_irqrestore(&wp->lock, flags);
 		}
-		if (zone_num && (zone_num == zone_busy)) {
+		if (z_flgd && (z_flgd == zone_busy)) {
 			sd_zbc_debug(sdkp,
 				     "zone update for %zu in progress\n",
 				     sector);
@@ -476,43 +393,26 @@ static void discard_or_write_same(struct scsi_cmnd *cmd, sector_t sector,
 int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
-	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	unsigned int nr_sectors = blk_rq_sectors(rq);
 	int ret = BLKPREP_OK;
 	struct blk_zone *zone;
 	unsigned long flags;
-	u32 wp_offset;
 	bool use_write_same = false;
+	sector_t z_start, z_len;
+	spinlock_t *lck;
 
-	zone = blk_lookup_zone(rq->q, sector);
-	if (!zone) {
-		/* Test for a runt zone before giving up */
-		if (sdp->type != TYPE_ZBC) {
-			struct request_queue *q = rq->q;
-			struct rb_node *node;
-
-			node = rb_last(&q->zones);
-			if (node)
-				zone = rb_entry(node, struct blk_zone, node);
-			if (zone) {
-				spin_lock_irqsave(&zone->lock, flags);
-				if ((zone->start + zone->len) <= sector)
-					goto out;
-				spin_unlock_irqrestore(&zone->lock, flags);
-				zone = NULL;
-			}
-		}
+	zone = blk_lookup_zone(rq->q, sector, &z_start, &z_len, &lck);
+	if (!zone)
 		return BLKPREP_KILL;
-	}
 
-	spin_lock_irqsave(&zone->lock, flags);
+	spin_lock_irqsave(lck, flags);
 	if (zone->state == BLK_ZONE_UNKNOWN ||
 	    zone->state == BLK_ZONE_BUSY) {
 		sd_zbc_debug_ratelimit(sdkp,
 				       "Discarding zone %zx state %x, deferring\n",
-				       zone->start, zone->state);
+				       z_start, zone->state);
 		ret = BLKPREP_DEFER;
 		goto out;
 	}
@@ -520,39 +420,37 @@ int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
 		/* let the drive fail the command */
 		sd_zbc_debug_ratelimit(sdkp,
 				       "Discarding offline zone %zx\n",
-				       zone->start);
+				       z_start);
 		goto out;
 	}
 	if (blk_zone_is_cmr(zone)) {
 		use_write_same = true;
 		sd_zbc_debug_ratelimit(sdkp,
-				       "Discarding CMR zone %zx\n",
-				       zone->start);
+				       "Discarding CMR zone %zx\n", z_start);
 		goto out;
 	}
-	if (zone->start != sector || zone->len < nr_sectors) {
+	if (z_start != sector || z_len < nr_sectors) {
 		sd_printk(KERN_ERR, sdkp,
 			  "Misaligned RESET WP %zx/%x on zone %zx/%zx\n",
-			  sector, nr_sectors, zone->start, zone->len);
+			  sector, nr_sectors, z_start, z_len);
 		ret = BLKPREP_KILL;
 		goto out;
 	}
 	/* Protect against Reset WP when more data had been written to the
 	 * zone than is being discarded.
 	 */
-	wp_offset = zone->wp - zone->start;
-	if (wp_offset > nr_sectors) {
+	if (zone->wp > nr_sectors) {
 		sd_printk(KERN_ERR, sdkp,
-			  "Will Corrupt RESET WP %zx/%x/%x on zone %zx/%zx/%zx\n",
-			  sector, wp_offset, nr_sectors,
-			  zone->start, zone->wp, zone->len);
+			  "Will Corrupt RESET WP %zx/%zx/%x on zone %zx/%zx/%zx\n",
+			  sector, (sector_t)zone->wp, nr_sectors,
+			  z_start, z_start + zone->wp, z_len);
 		ret = BLKPREP_KILL;
 		goto out;
 	}
 	if (blk_zone_is_empty(zone)) {
 		sd_zbc_debug_ratelimit(sdkp,
 				       "Discarding empty zone %zx [WP: %zx]\n",
-				       zone->start, zone->wp);
+				       z_start, (sector_t)zone->wp);
 		ret = BLKPREP_DONE;
 		goto out;
 	}
@@ -563,8 +461,8 @@ out:
 	 * zone update if RESET WRITE POINTER fails.
 	 */
 	if (ret == BLKPREP_OK && !use_write_same)
-		zone->wp = zone->start;
-	spin_unlock_irqrestore(&zone->lock, flags);
+		zone->wp = 0;
+	spin_unlock_irqrestore(lck, flags);
 
 	if (ret == BLKPREP_OK)
 		discard_or_write_same(cmd, sector, nr_sectors, use_write_same);
@@ -573,13 +471,14 @@ out:
 }
 
 
-static void __set_zone_state(struct blk_zone *zone, int op)
+static void __set_zone_state(struct blk_zone *zone, sector_t z_len,
+			     spinlock_t *lck, int op)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&zone->lock, flags);
-	if (blk_zone_is_cmr(zone))
-		goto out_unlock;
+	spin_lock_irqsave(lck, flags);
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		goto out;
 
 	switch (op) {
 	case REQ_OP_ZONE_OPEN:
@@ -587,38 +486,45 @@ static void __set_zone_state(struct blk_zone *zone, int op)
 		break;
 	case REQ_OP_ZONE_FINISH:
 		zone->state = BLK_ZONE_FULL;
-		zone->wp = zone->start + zone->len;
+		zone->wp = z_len;
 		break;
 	case REQ_OP_ZONE_CLOSE:
 		zone->state = BLK_ZONE_CLOSED;
 		break;
 	case REQ_OP_ZONE_RESET:
-		zone->wp = zone->start;
+		zone->wp = 0;
 		break;
 	default:
 		WARN_ONCE(1, "%s: invalid op code: %u\n", __func__, op);
 	}
-out_unlock:
-	spin_unlock_irqrestore(&zone->lock, flags);
+out:
+	spin_unlock_irqrestore(lck, flags);
 }
 
 static void update_zone_state(struct request *rq, sector_t lba, unsigned int op)
 {
-	struct request_queue *q = rq->q;
-	struct blk_zone *zone = NULL;
+	struct blk_zone *zone;
 
 	if (lba == ~0ul) {
-		struct rb_node *node;
-
-		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
-			zone = rb_entry(node, struct blk_zone, node);
-			__set_zone_state(zone, op);
+		struct zone_wps *zi = rq->q->zones;
+		struct contiguous_wps *wp;
+		u32 iter, entry;
+
+		for (iter = 0; iter < zi->wps_count; iter++) {
+			wp = zi->wps[iter];
+			for (entry = 0; entry < wp->zone_count; entry++) {
+				zone = &wp->zones[entry];
+				__set_zone_state(zone, wp->zone_size, &wp->lock,
+						 op);
+			}
 		}
-		return;
 	} else {
-		zone = blk_lookup_zone(q, lba);
+		sector_t z_start, z_len;
+		spinlock_t *lck;
+
+		zone = blk_lookup_zone(rq->q, lba, &z_start, &z_len, &lck);
 		if (zone)
-			__set_zone_state(zone, op);
+			__set_zone_state(zone, z_len, lck, op);
 	}
 }
 
@@ -641,6 +547,8 @@ int sd_zbc_setup_zone_action(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	struct blk_zone *zone;
+	spinlock_t *lck;
+	sector_t z_start, z_len;
 	unsigned long flags;
 	unsigned int nr_sectors;
 	int ret = BLKPREP_DONE;
@@ -651,17 +559,17 @@ int sd_zbc_setup_zone_action(struct scsi_cmnd *cmd)
 	if (is_fua || op != REQ_OP_ZONE_RESET)
 		goto out;
 
-	zone = blk_lookup_zone(rq->q, sector);
+	zone = blk_lookup_zone(rq->q, sector, &z_start, &z_len, &lck);
 	if (!zone || sdkp->provisioning_mode != SD_ZBC_RESET_WP)
 		goto out;
 
 	/* Map a Reset WP w/o FUA to a discard request */
-	spin_lock_irqsave(&zone->lock, flags);
-	sector = zone->start;
-	nr_sectors = zone->len;
+	spin_lock_irqsave(lck, flags);
+	sector = z_start;
+	nr_sectors = z_len;
 	if (blk_zone_is_cmr(zone))
 		use_write_same = true;
-	spin_unlock_irqrestore(&zone->lock, flags);
+	spin_unlock_irqrestore(lck, flags);
 
 	rq->completion_data = NULL;
 	if (use_write_same) {
@@ -712,137 +620,157 @@ static sector_t bzrpt_fill(struct request *rq,
 			   struct bdev_zone_descriptor *bzd,
 			   size_t sz, sector_t lba, u8 opt)
 {
-	struct request_queue *q = rq->q;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	struct scsi_device *sdp = sdkp->device;
+	struct zone_wps *zi = rq->q->zones;
+	struct contiguous_wps *wpdscr;
 	struct blk_zone *zone = NULL;
-	struct rb_node *node = NULL;
 	sector_t progress = lba;
 	sector_t clen = ~0ul;
+	sector_t z_start, z_len, z_wp_abs;
 	unsigned long flags;
 	u32 max_entries = bzrpt ? max_report_entries(sz) : sz / sizeof(*bzd);
 	u32 entry = 0;
+	u32 iter, idscr;
 	int len_diffs = 0;
 	int type_diffs = 0;
 	u8 ctype;
 	u8 same = 0;
 
-	zone = blk_lookup_zone(q, lba);
-	if (zone)
-		node = &zone->node;
-
-	for (entry = 0; entry < max_entries && node; node = rb_next(node)) {
-		u64 z_len, z_start, z_wp_abs;
-		u8 cond = 0;
-		u8 flgs = 0;
-
-		spin_lock_irqsave(&zone->lock, flags);
-		z_len = zone->len;
-		z_start = zone->start;
-		z_wp_abs = zone->wp;
-		progress = z_start + z_len;
-		cond = zone->state;
-		if (blk_zone_is_cmr(zone))
-			flgs |= 0x02;
-		else if (zone->wp != zone->start)
-			flgs |= 0x01; /* flag as RWP recommended? */
-		spin_unlock_irqrestore(&zone->lock, flags);
-
-		switch (opt & ZBC_REPORT_OPTION_MASK) {
-		case ZBC_ZONE_REPORTING_OPTION_EMPTY:
-			if (z_wp_abs != z_start)
-				continue;
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN:
-			if (cond != BLK_ZONE_OPEN)
-				continue;
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN:
-			if (cond != BLK_ZONE_OPEN_EXPLICIT)
-				continue;
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_CLOSED:
-			if (cond != BLK_ZONE_CLOSED)
-				continue;
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_FULL:
-			if (cond != BLK_ZONE_FULL)
-				continue;
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_READONLY:
-			if (cond == BLK_ZONE_READONLY)
-				continue;
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_OFFLINE:
-			if (cond == BLK_ZONE_OFFLINE)
-				continue;
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP:
-			if (z_wp_abs == z_start)
-				continue;
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_NON_WP:
-			if (cond == BLK_ZONE_NO_WP)
+	for (iter = 0; entry < max_entries && iter < zi->wps_count; iter++) {
+		wpdscr = zi->wps[iter];
+		if (lba > wpdscr->last_lba)
+			continue;
+
+		spin_lock_irqsave(&wpdscr->lock, flags);
+		for (idscr = 0;
+		     entry < max_entries && idscr < wpdscr->zone_count;
+		     idscr++) {
+			struct bdev_zone_descriptor *dscr;
+			u64 zoff = idscr * wpdscr->zone_size;
+			u8 cond, flgs = 0;
+
+			z_len = wpdscr->zone_size;
+			zoff = idscr * z_len;
+			z_start = wpdscr->start_lba + zoff;
+			if (lba >= z_start + z_len)
 				continue;
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE:
-			/* this can only be reported by the HW */
-			break;
-		case ZBC_ZONE_REPORTING_OPTION_ALL:
-		default:
-			break;
-		}
 
-		/* if same code only applies to returned zones */
-		if (opt & ZBC_REPORT_ZONE_PARTIAL) {
-			if (clen != ~0ul) {
-				clen = z_len;
+			zone = &wpdscr->zones[idscr];
+			if (blk_zone_is_cmr(zone))
+				z_wp_abs = z_start + wpdscr->zone_size;
+			else
+				z_wp_abs = z_start + zone->wp;
+
+			switch (opt & ZBC_REPORT_OPTION_MASK) {
+			case ZBC_ZONE_REPORTING_OPTION_EMPTY:
+				if (z_wp_abs != z_start)
+					continue;
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN:
+				if (zone->state != BLK_ZONE_OPEN)
+					continue;
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN:
+				if (zone->state != BLK_ZONE_OPEN_EXPLICIT)
+					continue;
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_CLOSED:
+				if (zone->state != BLK_ZONE_CLOSED)
+					continue;
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_FULL:
+				if (zone->state != BLK_ZONE_FULL)
+					continue;
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_READONLY:
+				if (zone->state == BLK_ZONE_READONLY)
+					continue;
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_OFFLINE:
+				if (zone->state == BLK_ZONE_OFFLINE)
+					continue;
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP:
+				if (z_wp_abs == z_start)
+					continue;
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_NON_WP:
+				if (zone->state == BLK_ZONE_NO_WP)
+					continue;
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE:
+				/* this can only be reported by the HW */
+				break;
+			case ZBC_ZONE_REPORTING_OPTION_ALL:
+			default:
+				break;
+			}
+
+			/* if same code only applies to returned zones */
+			if (opt & ZBC_REPORT_ZONE_PARTIAL) {
+				if (clen != ~0ul) {
+					clen = z_len;
+					ctype = zone->type;
+				}
+				if (z_len != clen)
+					len_diffs++;
+				if (zone->type != ctype)
+					type_diffs++;
 				ctype = zone->type;
 			}
-			if (z_len != clen)
-				len_diffs++;
-			if (zone->type != ctype)
-				type_diffs++;
-			ctype = zone->type;
-		}
+			progress = z_start + z_len;
 
-		/* shift to device units */
-		z_start >>= ilog2(sdkp->device->sector_size) - 9;
-		z_len >>= ilog2(sdkp->device->sector_size) - 9;
-		z_wp_abs >>= ilog2(sdkp->device->sector_size) - 9;
+			if (!bzd) {
+				if (bzrpt)
+					bzrpt->descriptor_count =
+						cpu_to_be32(++entry);
+				continue;
+			}
 
-		if (!bzd) {
+			/* shift to device units */
+			z_start >>= ilog2(sdp->sector_size) - 9;
+			z_len >>= ilog2(sdp->sector_size) - 9;
+			z_wp_abs >>= ilog2(sdp->sector_size) - 9;
+
+			cond = zone->state;
+			if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+				flgs |= 0x02;
+			else if (zone->wp)
+				flgs |= 0x01; /* flag as RWP recommended? */
+
+			dscr = &bzd[entry];
+			dscr->lba_start = cpu_to_be64(z_start);
+			dscr->length = cpu_to_be64(z_len);
+			dscr->lba_wptr = cpu_to_be64(z_wp_abs);
+			dscr->type = zone->type;
+			dscr->flags = cond << 4 | flgs;
+			entry++;
 			if (bzrpt)
-				bzrpt->descriptor_count =
-					cpu_to_be32(++entry);
-			continue;
+				bzrpt->descriptor_count = cpu_to_be32(entry);
 		}
-
-		bzd[entry].lba_start = cpu_to_be64(z_start);
-		bzd[entry].length = cpu_to_be64(z_len);
-		bzd[entry].lba_wptr = cpu_to_be64(z_wp_abs);
-		bzd[entry].type = zone->type;
-		bzd[entry].flags = cond << 4 | flgs;
-		entry++;
-		if (bzrpt)
-			bzrpt->descriptor_count = cpu_to_be32(entry);
+		spin_unlock_irqrestore(&wpdscr->lock, flags);
 	}
 
 	/* if same code applies to all zones */
 	if (bzrpt && !(opt & ZBC_REPORT_ZONE_PARTIAL)) {
-		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
-			zone = rb_entry(node, struct blk_zone, node);
-
-			spin_lock_irqsave(&zone->lock, flags);
-			if (clen != ~0ul) {
-				clen = zone->len;
+		for (iter = 0; iter < zi->wps_count; iter++) {
+			wpdscr = zi->wps[iter];
+			spin_lock_irqsave(&wpdscr->lock, flags);
+			for (idscr = 0; idscr < wpdscr->zone_count; idscr++) {
+				z_len = wpdscr->zone_size;
+				zone = &wpdscr->zones[idscr];
+				if (clen != ~0ul) {
+					clen = z_len;
+					ctype = zone->type;
+				}
+				if (z_len != clen)
+					len_diffs++;
+				if (zone->type != ctype)
+					type_diffs++;
 				ctype = zone->type;
 			}
-			if (zone->len != clen)
-				len_diffs++;
-			if (zone->type != ctype)
-				type_diffs++;
-			ctype = zone->type;
-			spin_unlock_irqrestore(&zone->lock, flags);
+			spin_unlock_irqrestore(&wpdscr->lock, flags);
 		}
 	}
 
@@ -985,12 +913,15 @@ out:
 int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 			    sector_t sector, unsigned int *num_sectors)
 {
+	struct request_queue *q = sdkp->disk->queue;
 	struct blk_zone *zone;
+	sector_t z_start, z_len;
+	spinlock_t *lck;
 	unsigned int sectors = *num_sectors;
 	int ret = BLKPREP_OK;
 	unsigned long flags;
 
-	zone = blk_lookup_zone(sdkp->disk->queue, sector);
+	zone = blk_lookup_zone(q, sector, &z_start, &z_len, &lck);
 	if (!zone) {
 		/* Might happen during zone initialization */
 		sd_zbc_debug_ratelimit(sdkp,
@@ -999,7 +930,7 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 		return BLKPREP_OK;
 	}
 
-	spin_lock_irqsave(&zone->lock, flags);
+	spin_lock_irqsave(lck, flags);
 
 	if (blk_zone_is_cmr(zone))
 		goto out;
@@ -1008,7 +939,7 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 	    zone->state == BLK_ZONE_BUSY) {
 		sd_zbc_debug_ratelimit(sdkp,
 				       "zone %zu state %x, deferring\n",
-				       zone->start, zone->state);
+				       z_start, zone->state);
 		ret = BLKPREP_DEFER;
 		goto out;
 	}
@@ -1017,25 +948,22 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 		if (op_is_write(req_op(rq))) {
 			u64 nwp = sector + sectors;
 
-			while (nwp > (zone->start + zone->len)) {
-				struct rb_node *node = rb_next(&zone->node);
+			while (nwp > (z_start + z_len)) {
+				zone->wp = z_len;
+				sector = z_start + z_len;
+				sectors = nwp - sector;
+				spin_unlock_irqrestore(lck, flags);
 
-				zone->wp = zone->start + zone->len;
-				sector = zone->wp;
-				sectors = nwp - zone->wp;
-				spin_unlock_irqrestore(&zone->lock, flags);
-
-				if (!node)
-					return BLKPREP_OK;
-				zone = rb_entry(node, struct blk_zone, node);
+				zone = blk_lookup_zone(q, sector,
+						       &z_start, &z_len, &lck);
 				if (!zone)
 					return BLKPREP_OK;
 
-				spin_lock_irqsave(&zone->lock, flags);
+				spin_lock_irqsave(lck, flags);
 				nwp = sector + sectors;
 			}
-			if (nwp > zone->wp)
-				zone->wp = nwp;
+			if (nwp > z_start + zone->wp)
+				zone->wp = nwp - z_start;
 		}
 		goto out;
 	}
@@ -1044,37 +972,37 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 		/* let the drive fail the command */
 		sd_zbc_debug_ratelimit(sdkp,
 				       "zone %zu offline\n",
-				       zone->start);
+				       z_start);
 		goto out;
 	}
 
 	if (op_is_write(req_op(rq))) {
 		if (zone->state == BLK_ZONE_READONLY)
 			goto out;
-		if (blk_zone_is_full(zone)) {
+		if (zone->wp == z_len) {
 			sd_zbc_debug(sdkp,
-				     "Write to full zone %zu/%zu\n",
-				     sector, zone->wp);
+				     "Write to full zone %zu/%zu/%zu\n",
+				     sector, (sector_t)zone->wp, z_len);
 			ret = BLKPREP_KILL;
 			goto out;
 		}
-		if (zone->wp != sector) {
+		if (sector != (z_start + zone->wp)) {
 			sd_zbc_debug(sdkp,
 				     "Misaligned write %zu/%zu\n",
-				     sector, zone->wp);
+				     sector, z_start + zone->wp);
 			ret = BLKPREP_KILL;
 			goto out;
 		}
 		zone->wp += sectors;
-	} else if (zone->wp <= sector + sectors) {
-		if (zone->wp <= sector) {
+	} else if (z_start + zone->wp <= sector + sectors) {
+		if (z_start + zone->wp <= sector) {
 			/* Read beyond WP: clear request buffer */
 			struct req_iterator iter;
 			struct bio_vec bvec;
 			void *buf;
 			sd_zbc_debug(sdkp,
 				     "Read beyond wp %zu+%u/%zu\n",
-				     sector, sectors, zone->wp);
+				     sector, sectors, z_start + zone->wp);
 			rq_for_each_segment(bvec, rq, iter) {
 				buf = bvec_kmap_irq(&bvec, &flags);
 				memset(buf, 0, bvec.bv_len);
@@ -1085,15 +1013,15 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 			goto out;
 		}
 		/* Read straddle WP position: limit request size */
-		*num_sectors = zone->wp - sector;
+		*num_sectors = z_start + zone->wp - sector;
 		sd_zbc_debug(sdkp,
 			     "Read straddle wp %zu+%u/%zu => %zu+%u\n",
-			     sector, sectors, zone->wp,
+			     sector, sectors, z_start + zone->wp,
 			     sector, *num_sectors);
 	}
 
 out:
-	spin_unlock_irqrestore(&zone->lock, flags);
+	spin_unlock_irqrestore(lck, flags);
 
 	return ret;
 }
@@ -1145,21 +1073,22 @@ static void update_zones_from_report(struct scsi_cmnd *cmd, u32 nr_bytes)
 			struct bdev_zone_descriptor *entry = &bzde[iter];
 			sector_t s = get_start_from_desc(sdkp, entry);
 			sector_t z_len = get_len_from_desc(sdkp, entry);
+			sector_t z_strt;
+			spinlock_t *lck;
 			unsigned long flags;
 
 			if (!z_len)
 				goto done;
 
-			zone = blk_lookup_zone(rq->q, s);
+			zone = blk_lookup_zone(rq->q, s, &z_strt, &z_len, &lck);
 			if (!zone)
 				goto done;
 
-			spin_lock_irqsave(&zone->lock, flags);
+			spin_lock_irqsave(lck, flags);
 			zone->type = entry->type & 0xF;
 			zone->state = (entry->flags >> 4) & 0xF;
 			zone->wp = get_wp_from_desc(sdkp, entry);
-			zone->len = z_len;
-			spin_unlock_irqrestore(&zone->lock, flags);
+			spin_unlock_irqrestore(lck, flags);
 		}
 		nread += len;
 		if (!dmax)
@@ -1233,113 +1162,314 @@ void sd_zbc_uninit_command(struct scsi_cmnd *cmd)
 }
 
 /**
- * sd_zbc_init - Load zones of matching zlen size into rb tree.
+ * alloc_cpws() - Allocate space for a contiguous set of write pointers
+ * @items: Number of wps needed.
+ * @lba: lba of the start of the next zone.
+ * @z_start: Starting lba of this contiguous set.
+ * @z_size: Size of each zone this contiguous set.
  *
+ * Return: Allocated wps or NULL on error.
  */
-static int sd_zbc_init(struct scsi_disk *sdkp, u64 zlen, char *buf, int buf_len)
+static struct contiguous_wps *alloc_cpws(int items, u64 lba, u64 z_start,
+					 u64 z_size)
 {
-	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
-	sector_t last_sector;
+	struct contiguous_wps *cwps = NULL;
+	size_t sz;
 
-	if (test_and_set_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags)) {
-		sdev_printk(KERN_WARNING, sdkp->device,
-			    "zone initialization already running\n");
-		return 0;
+	sz = sizeof(struct contiguous_wps) + (items * sizeof(struct blk_zone));
+	if (items) {
+		cwps = vzalloc(sz);
+		if (!cwps)
+			goto out;
+		spin_lock_init(&cwps->lock);
+		cwps->start_lba = z_start;
+		cwps->last_lba = lba - 1;
+		cwps->zone_size = z_size;
+		cwps->is_zoned = items > 1 ? 1 : 0;
+		cwps->zone_count = items;
 	}
 
-	if (!sdkp->zone_work_q) {
-		char wq_name[32];
+out:
+	return cwps;
+}
 
-		sprintf(wq_name, "zbc_wq_%s", sdkp->disk->disk_name);
-		sdkp->zone_work_q = create_singlethread_workqueue(wq_name);
-		if (!sdkp->zone_work_q) {
-			sdev_printk(KERN_WARNING, sdkp->device,
-				    "create zoned disk workqueue failed\n");
-			return -ENOMEM;
+/**
+ * free_zone_wps() - Free up memory in use by wps
+ * @zi: zone wps array(s).
+ */
+static void free_zone_wps(struct zone_wps *zi)
+{
+	/* on error free the arrays */
+	if (zi && zi->wps) {
+		int ca;
+
+		for (ca = 0; ca < zi->wps_count; ca++) {
+			if (zi->wps[ca]) {
+				vfree(zi->wps[ca]);
+				zi->wps[ca] = NULL;
+			}
 		}
-	} else if (!test_and_set_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
-		drain_workqueue(sdkp->zone_work_q);
-		clear_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags);
+		kfree(zi->wps);
 	}
+}
 
-	last_sector = zbc_parse_zones(sdkp, zlen, buf, buf_len);
-	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
-	if (last_sector != -1 && last_sector < capacity) {
-		sd_zbc_update_zones(sdkp, last_sector,
-				    SD_ZBC_BUF_SIZE, SD_ZBC_INIT);
-	} else
-		clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags);
+static int wps_realloc(struct zone_wps *zi, gfp_t gfp_mask)
+{
+	int rcode = 0;
+	struct contiguous_wps **old;
+	struct contiguous_wps **tmp;
+	int n = zi->wps_count * 2;
+
+	old = zi->wps;
+	tmp = kzalloc(n, sizeof(*zi->wps), gfp_mask);
+	if (!tmp) {
+		rcode = -ENOMEM;
+		goto out;
+	}
+	memcpy(tmp, zi->wps, zi->wps_count * sizeof(*zi->wps));
+	zi->wps = tmp;
+	kfree(old);
 
-	return 0;
+out:
+	return rcode;
 }
 
+#define FMT_CHANGING_CAPACITY "Changing capacity from %zu to Max LBA+1 %zu"
+
 /**
- * sd_zbc_config() - Configure a ZBC device (on attach)
- * @sdkp: SCSI disk being attached.
- * @buffer: Buffer to working data.
- * @buf_sz: Size of buffer to use for working data
+ * zbc_init_zones() - Re-Sync expected WP location with drive
+ * @sdkp: scsi_disk
+ * @gfp_mask: Allocation mask.
  *
- * Return: true of SD_ZBC_RESET_WP provisioning is supported
+ * Return: 0 on success, otherwise error.
  */
-bool sd_zbc_config(struct scsi_disk *sdkp, void *buffer, size_t buf_sz)
+int zbc_init_zones(struct scsi_disk *sdkp, gfp_t gfp_mask)
 {
-	struct bdev_zone_report *bzrpt = buffer;
-	u64 zone_len, lba;
-	int retval;
-	u32 rep_len;
-	u8 same;
+	struct request_queue *q = sdkp->disk->queue;
+	int rcode = 0;
+	int entry = 0;
+	int offset;
+	int offmax;
+	u64 iter;
+	u64 z_start = 0ul;
+	u64 z_size = 0; /* size of zone */
+	int z_count = 0; /* number of zones of z_size */
+	int do_fill = 0;
+	int array_count = 0;
+	int one_time_setup = 0;
+	u8 opt = ZBC_ZONE_REPORTING_OPTION_ALL;
+	size_t bufsz = SD_ZBC_BUF_SIZE;
+	struct bdev_zone_report *rpt = NULL;
+	struct zone_wps *zi = NULL;
+	struct contiguous_wps *cwps = NULL;
+
+	if (q->zones)
+		goto out;
 
-	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC)
-		/*
-		 * Device managed or normal SCSI disk,
-		 * no special handling required
-		 */
-		return false;
-
-	retval = sd_zbc_report_zones(sdkp, bzrpt, buf_sz,
-				     0, ZBC_ZONE_REPORTING_OPTION_ALL, false);
-	if (retval < 0)
-		return false;
-
-	rep_len = be32_to_cpu(bzrpt->descriptor_count);
-	if (rep_len < 7) {
-		sd_printk(KERN_WARNING, sdkp,
-			  "REPORT ZONES report invalid length %u\n",
-			  rep_len);
-		return false;
+	zi = kzalloc(sizeof(*zi), gfp_mask);
+	if (!zi) {
+		rcode = -ENOMEM;
+		goto out;
 	}
 
-	if (sdkp->rc_basis == 0) {
-		/* The max_lba field is the capacity of a zoned device */
-		lba = be64_to_cpu(bzrpt->maximum_lba);
-		if (lba + 1 > sdkp->capacity) {
-			if (sdkp->first_scan)
-				sd_printk(KERN_WARNING, sdkp,
-					  "Changing capacity from %zu to Max LBA+1 %zu\n",
-					  sdkp->capacity, (sector_t) lba + 1);
-			sdkp->capacity = lba + 1;
+	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC) {
+		struct gendisk *disk = sdkp->disk;
+
+		zi->wps = kzalloc(sizeof(*zi->wps), gfp_mask);
+		zi->wps[0] = alloc_cpws(1, disk->part0.nr_sects, z_start, 1);
+		if (!zi->wps[0]) {
+			rcode = -ENOMEM;
+			goto out;
 		}
+		zi->wps_count = 1;
+		goto out;
+	}
+
+	rpt = kmalloc(bufsz, gfp_mask);
+	if (!rpt) {
+		rcode = -ENOMEM;
+		goto out;
 	}
 
 	/*
-	 * Adjust 'chunk_sectors' to the zone length if the device
-	 * supports equal zone sizes.
+	 * Start by handling upto 32 different zone sizes. 2 will work
+	 * for all the current drives, but maybe something exotic will
+	 * surface.
 	 */
-	same = bzrpt->same_field & 0x0f;
-	if (same > 3) {
-		sd_printk(KERN_WARNING, sdkp,
-			  "REPORT ZONES SAME type %d not supported\n", same);
-		return false;
+	zi->wps = kcalloc(32, sizeof(*zi->wps), gfp_mask);
+	zi->wps_count = 32;
+	if (!zi->wps) {
+		rcode = -ENOMEM;
+		goto out;
 	}
-	/* Read the zone length from the first zone descriptor */
-	zone_len = be64_to_cpu(bzrpt->descriptors[0].length);
-	sdkp->unmap_alignment = zone_len;
-	sdkp->unmap_granularity = zone_len;
-	blk_queue_chunk_sectors(sdkp->disk->queue,
-				logical_to_sectors(sdkp->device, zone_len));
-
-	sd_zbc_init(sdkp, zone_len, buffer, buf_sz);
-	return true;
+
+fill:
+	offset = 0;
+	offmax = 0;
+	for (entry = 0, iter = 0; iter < sdkp->capacity; entry++) {
+		struct bdev_zone_descriptor *bzde;
+		int stop_end = 0;
+		int stop_size = 0;
+
+		if (offset == 0) {
+			int err;
+
+			err = sd_zbc_report_zones(sdkp, rpt, bufsz, iter, opt);
+			if (err) {
+				pr_err("report zones-> %d\n", err);
+				if (err != -ENOTSUPP)
+					rcode = err;
+				goto out;
+			}
+			if (sdkp->rc_basis == 0) {
+				sector_t lba = be64_to_cpu(rpt->maximum_lba);
+
+				if (lba + 1 > sdkp->capacity) {
+					sd_printk(KERN_WARNING, sdkp,
+						  FMT_CHANGING_CAPACITY "\n",
+						  sdkp->capacity, lba + 1);
+					sdkp->capacity = lba + 1;
+				}
+			}
+			offmax = max_report_entries(bufsz);
+		}
+		bzde = &rpt->descriptors[offset];
+		if (z_size == 0)
+			z_size = get_len_from_desc(sdkp, bzde);
+		if (z_size != get_len_from_desc(sdkp, bzde))
+			stop_size = 1;
+		if ((iter + z_size) >= sdkp->capacity)
+			stop_end = 1;
+
+		if (!one_time_setup) {
+			u8 type = bzde->type & 0x0F;
+
+			if (type != BLK_ZONE_TYPE_CONVENTIONAL) {
+				one_time_setup = 1;
+				blk_queue_chunk_sectors(sdkp->disk->queue,
+							z_size);
+			}
+		}
+
+		if (do_fill == 0) {
+			if (stop_end || stop_size) {
+				/* include the next/last zone? */
+				if (!stop_size) {
+					z_count++;
+					iter += z_size;
+				}
+				cwps = alloc_cpws(z_count, iter,
+						  z_start, z_size);
+				if (!cwps) {
+					rcode = -ENOMEM;
+					goto out;
+				}
+				if (array_count > 0)
+					cwps->is_zoned = 1;
+
+				zi->wps[array_count] = cwps;
+				z_start = iter;
+				z_size = 0;
+				z_count = 0;
+				array_count++;
+				if (array_count >= zi->wps_count) {
+					rcode = wps_realloc(zi, gfp_mask);
+					if (rcode)
+						goto out;
+				}
+				/* add the runt zone */
+				if (stop_end && stop_size) {
+					z_count++;
+					z_size = get_len_from_desc(sdkp, bzde);
+					cwps = alloc_cpws(z_count,
+							  iter + z_size,
+							  z_start, z_size);
+					if (!cwps) {
+						rcode = -ENOMEM;
+						goto out;
+					}
+					if (array_count > 0)
+						cwps->is_zoned = 1;
+					zi->wps[array_count] = cwps;
+					array_count++;
+				}
+				if (stop_end) {
+					do_fill = 1;
+					array_count = 0;
+					z_count = 0;
+					z_size = 0;
+					goto fill;
+				}
+			}
+			z_size = get_len_from_desc(sdkp, bzde);
+			iter += z_size;
+			z_count++;
+		} else {
+			fill_zone(zi->wps[array_count], z_count, sdkp, bzde);
+			z_count++;
+			iter += z_size;
+			if (zi->wps[array_count]->zone_count == z_count) {
+				z_count = 0;
+				array_count++;
+				zi->wps_count = array_count;
+			}
+		}
+		offset++;
+		if (offset >= offmax)
+			offset = 0;
+	}
+out:
+	kfree(rpt);
+
+	if (rcode) {
+		if (zi) {
+			free_zone_wps(zi);
+			kfree(zi);
+		}
+	} else {
+		q->zones = zi;
+	}
+
+	return rcode;
+}
+
+/**
+ * sd_zbc_config() - Configure a ZBC device (on attach)
+ * @sdkp: SCSI disk being attached.
+ * @gfp_mask: Memory allocation strategy
+ *
+ * Return: true of SD_ZBC_RESET_WP provisioning is supported
+ */
+bool sd_zbc_config(struct scsi_disk *sdkp, gfp_t gfp_mask)
+{
+	bool can_reset_wp = false;
+
+	if (zbc_init_zones(sdkp, gfp_mask)) {
+		sdev_printk(KERN_WARNING, sdkp->device,
+			    "Initialize zone cache failed\n");
+		goto out;
+	}
+
+	if (sdkp->zoned == 1 || sdkp->device->type == TYPE_ZBC)
+		can_reset_wp = true;
+
+	if (!sdkp->zone_work_q) {
+		char wq_name[32];
+
+		sprintf(wq_name, "zbc_wq_%s", sdkp->disk->disk_name);
+		sdkp->zone_work_q = create_singlethread_workqueue(wq_name);
+		if (!sdkp->zone_work_q) {
+			sdev_printk(KERN_WARNING, sdkp->device,
+				    "create zoned disk workqueue failed\n");
+			goto out;
+		}
+	} else if (!test_and_set_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
+		drain_workqueue(sdkp->zone_work_q);
+		clear_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags);
+	}
+
+out:
+	return can_reset_wp;
 }
 
 /**
@@ -1365,15 +1495,16 @@ void sd_zbc_remove(struct scsi_disk *sdkp)
  */
 unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp)
 {
-	unsigned int bytes = 1;
 	struct request_queue *q = sdkp->disk->queue;
-	struct rb_node *node = rb_first(&q->zones);
+	struct zone_wps *zi = q->zones;
+	unsigned int bytes = 1;
 
-	if (node) {
-		struct blk_zone *zone = rb_entry(node, struct blk_zone, node);
+	if (zi && zi->wps_count > 0) {
+		struct contiguous_wps *wp = zi->wps[0];
 
-		bytes = zone->len;
+		bytes = wp->zone_size;
 	}
+
 	bytes <<= ilog2(sdkp->device->sector_size);
 	return bytes;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d5cdb5d..113c5a8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -264,27 +264,83 @@ struct blk_queue_tag {
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
+/**
+ * struct blk_zone - A single zone type/stats and WP offset.
+ *
+ * @wp:    Holds the wp offset from the start of the zone.
+ * @type:  Holds the zone type nibble.
+ * @state: Holds the zone state nibble + kernel (zone busy)
+ * @private_data: Used to hold whatever the implicit domain owner
+ *                of the zone needs to track.
+ *
+ * Type is left at 4 bits (only 2 are needed currently) to match
+ * the current ZBC/ZAC standards.
+ *
+ * State is using 5 bits to accommodate the ZONE_BUSY. The first 4 bits
+ * match the current ZBC/ZAC spec.
+ * ZONE_BUSY could be mapped to one of the reserved bits. Using it as
+ * mask bit or independent flag my be useful for decoding the zone
+ * state before it transitioned to BUSY.
+ *
+ * A zone sized at order (39+9) is very unlikely (current zones are 16+9)
+ * Even at lba48 equivalent number of sectors we have a large amount
+ * of padding to fill out 8 bytes.
+ *
+ * Getting this to fit in 4 bytes would limit the maximum size of a zone
+ * to 4G [order 23 of 512 byte sectors + 9 bits for flags] which is probably
+ * okay for embedded or 32-bit systems where the private_data pointer
+ * would also shrink to 32 bits. There are also WP tracking schemes
+ * that don't make use of the private_data helper so perhaps that
+ * could be factored out as well.
+ */
 struct blk_zone {
-	struct rb_node node;
-	spinlock_t lock;
-	sector_t start;
-	size_t len;
-	sector_t wp;
-	enum blk_zone_type type;
-	enum blk_zone_state state;
+	unsigned long long wp:39;
+	unsigned long long type:4;
+	unsigned long long state:5;
+	unsigned long long padding:15;
 	void *private_data;
 };
 
+/**
+ * struct contiguous_wps - A descriptor of zones of the same size
+ *
+ * @start_lba:  LBA of first zone covered by the descriptor.
+ * @last_lba:   LBA of last zone.
+ * @zone_size:  Size of zones as a number of 512 byte sectors.
+ * @zone_count: Number of zones (last-start/size) for convenience.
+ * @lock:       A spinlock protecting these zones.
+ * @is_zoned:   0 when all zones are conventional no WP zones.
+ * zones:       Array of blk_zone entries.
+ */
+struct contiguous_wps {
+	u64 start_lba;
+	u64 last_lba;
+	u64 zone_size;
+	u32 zone_count;
+	spinlock_t lock;
+	unsigned is_zoned:1;
+	struct blk_zone zones[0];
+};
+
+/**
+ * struct zone_wps - A collection of zone descriptors to describe zoned media.
+ *
+ * @wps_count:  Number of descriptors.
+ * @wps:        Array of zone descriptors.
+ */
+struct zone_wps {
+	u32 wps_count;
+	struct contiguous_wps **wps;
+};
+
 #define blk_zone_is_seq_req(z) ((z)->type == BLK_ZONE_TYPE_SEQWRITE_REQ)
 #define blk_zone_is_seq_pref(z) ((z)->type == BLK_ZONE_TYPE_SEQWRITE_PREF)
 #define blk_zone_is_smr(z) (blk_zone_is_seq_req(z) || blk_zone_is_seq_pref(z))
 #define blk_zone_is_cmr(z) ((z)->type == BLK_ZONE_TYPE_CONVENTIONAL)
-#define blk_zone_is_full(z) ((z)->wp == (z)->start + (z)->len)
-#define blk_zone_is_empty(z) ((z)->wp == (z)->start)
+#define blk_zone_is_empty(z) ((z)->wp == 0)
 
-extern struct blk_zone *blk_lookup_zone(struct request_queue *, sector_t);
-extern struct blk_zone *blk_insert_zone(struct request_queue *,
-					struct blk_zone *);
+extern struct blk_zone *blk_lookup_zone(struct request_queue *, sector_t,
+					sector_t *, sector_t *, spinlock_t **);
 extern void blk_drop_zones(struct request_queue *);
 #else
 static inline void blk_drop_zones(struct request_queue *q) { };
@@ -463,7 +519,7 @@ struct request_queue {
 	struct queue_limits	limits;
 
 #ifdef CONFIG_BLK_DEV_ZONED
-	struct rb_root		zones;
+	struct zone_wps		*zones;
 #endif
 	/*
 	 * sg stuff
-- 
2.9.3

