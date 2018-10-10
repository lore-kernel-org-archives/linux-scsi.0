From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 10/11] block: add a report_zones method
Date: Wed, 10 Oct 2018 10:52:38 +0900
Message-ID: <20181010015239.24930-11-damien.lemoal@wdc.com>
References: <20181010015239.24930-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181010015239.24930-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Dispatching a report zones command through the request queue is a major
pain due to the command reply payload rewriting necessary. Given that
blkdev_report_zones() is executing everything synchronously, implement
report zones as a block device file operation instead, allowing major
simplification of the code in many places.

sd, null-blk, dm-linear and dm-flakey being the only block device
drivers supporting exposing zoned block devices, these drivers are
modified to provide the device side implementation of the
report_zones() block device file operation.

For dm-linear and dm-flakey, a new report_zones() target type operation
is defined so that the upper block layer call can be propagated down to
the underlying devices of the dm targets.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[Damien]
* Changed method block_device argument to gendisk
* Various bug fixes and improvements
* Added support for null_blk, dm-linear and dm-flakey.
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-core.c               |   1 -
 block/blk-mq-debugfs.c         |   1 -
 block/blk-zoned.c              | 164 ++++++++++-----------------------
 drivers/block/null_blk.h       |  11 ++-
 drivers/block/null_blk_main.c  |  23 +----
 drivers/block/null_blk_zoned.c |  57 +++---------
 drivers/md/dm-flakey.c         |  28 ++++--
 drivers/md/dm-linear.c         |  31 ++++---
 drivers/md/dm.c                | 150 ++++++++++++++++--------------
 drivers/scsi/sd.c              |  13 +--
 drivers/scsi/sd.h              |  11 +--
 drivers/scsi/sd_zbc.c          | 153 ++++++++++--------------------
 include/linux/blk_types.h      |   2 -
 include/linux/blkdev.h         |   8 +-
 include/linux/device-mapper.h  |  10 +-
 include/trace/events/f2fs.h    |   1 -
 16 files changed, 255 insertions(+), 409 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cff0a60ee200..18e7050eb5a4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2307,7 +2307,6 @@ generic_make_request_checks(struct bio *bio)
 		if (!q->limits.max_write_same_sectors)
 			goto not_supported;
 		break;
-	case REQ_OP_ZONE_REPORT:
 	case REQ_OP_ZONE_RESET:
 		if (!blk_queue_is_zoned(q))
 			goto not_supported;
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index cb1e6cf7ac48..a14ed04c1ff7 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -275,7 +275,6 @@ static const char *const op_name[] = {
 	REQ_OP_NAME(WRITE),
 	REQ_OP_NAME(FLUSH),
 	REQ_OP_NAME(DISCARD),
-	REQ_OP_NAME(ZONE_REPORT),
 	REQ_OP_NAME(SECURE_ERASE),
 	REQ_OP_NAME(ZONE_RESET),
 	REQ_OP_NAME(WRITE_SAME),
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index ca2faef940af..2ed03e301908 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -93,13 +93,10 @@ unsigned int blkdev_nr_zones(struct block_device *bdev)
 EXPORT_SYMBOL_GPL(blkdev_nr_zones);
 
 /*
- * Check that a zone report belongs to the partition.
- * If yes, fix its start sector and write pointer, copy it in the
- * zone information array and return true. Return false otherwise.
+ * Check that a zone report belongs to this partition, and if yes, fix its start
+ * sector and write pointer and return true. Return false otherwise.
  */
-static bool blkdev_report_zone(struct block_device *bdev,
-			       struct blk_zone *rep,
-			       struct blk_zone *zone)
+static bool blkdev_report_zone(struct block_device *bdev, struct blk_zone *rep)
 {
 	sector_t offset = get_start_sect(bdev);
 
@@ -114,11 +111,36 @@ static bool blkdev_report_zone(struct block_device *bdev,
 		rep->wp = rep->start + rep->len;
 	else
 		rep->wp -= offset;
-	memcpy(zone, rep, sizeof(struct blk_zone));
-
 	return true;
 }
 
+static int blk_report_zones(struct gendisk *disk, sector_t sector,
+			    struct blk_zone *zones, unsigned int *nr_zones,
+			    gfp_t gfp_mask)
+{
+	struct request_queue *q = disk->queue;
+	unsigned int z = 0, n, nrz = *nr_zones;
+	sector_t capacity = get_capacity(disk);
+	int ret;
+
+	while (z < nrz && sector < capacity) {
+		n = nrz - z;
+		ret = disk->fops->report_zones(disk, sector, &zones[z], &n,
+					       gfp_mask);
+		if (ret)
+			return ret;
+		if (!n)
+			break;
+		sector += blk_queue_zone_sectors(q) * n;
+		z += n;
+	}
+
+	WARN_ON(z > *nr_zones);
+	*nr_zones = z;
+
+	return 0;
+}
+
 /**
  * blkdev_report_zones - Get zones information
  * @bdev:	Target block device
@@ -133,130 +155,46 @@ static bool blkdev_report_zone(struct block_device *bdev,
  *    requested by @nr_zones. The number of zones actually reported is
  *    returned in @nr_zones.
  */
-int blkdev_report_zones(struct block_device *bdev,
-			sector_t sector,
-			struct blk_zone *zones,
-			unsigned int *nr_zones,
+int blkdev_report_zones(struct block_device *bdev, sector_t sector,
+			struct blk_zone *zones, unsigned int *nr_zones,
 			gfp_t gfp_mask)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	struct blk_zone_report_hdr *hdr;
-	unsigned int nrz = *nr_zones;
-	struct page *page;
-	unsigned int nr_rep;
-	size_t rep_bytes;
-	unsigned int nr_pages;
-	struct bio *bio;
-	struct bio_vec *bv;
-	unsigned int i, n, nz;
-	unsigned int ofst;
-	void *addr;
+	unsigned int i, nrz;
 	int ret;
 
-	if (!q)
-		return -ENXIO;
-
 	if (!blk_queue_is_zoned(q))
 		return -EOPNOTSUPP;
 
-	if (!nrz)
-		return 0;
-
-	if (sector > bdev->bd_part->nr_sects) {
-		*nr_zones = 0;
-		return 0;
-	}
-
 	/*
-	 * The zone report has a header. So make room for it in the
-	 * payload. Also make sure that the report fits in a single BIO
-	 * that will not be split down the stack.
+	 * A block device that advertized itself as zoned must have a
+	 * report_zones method. If it does not have one defined, the device
+	 * driver has a bug. So warn about that.
 	 */
-	rep_bytes = sizeof(struct blk_zone_report_hdr) +
-		sizeof(struct blk_zone) * nrz;
-	rep_bytes = (rep_bytes + PAGE_SIZE - 1) & PAGE_MASK;
-	if (rep_bytes > (queue_max_sectors(q) << 9))
-		rep_bytes = queue_max_sectors(q) << 9;
-
-	nr_pages = min_t(unsigned int, BIO_MAX_PAGES,
-			 rep_bytes >> PAGE_SHIFT);
-	nr_pages = min_t(unsigned int, nr_pages,
-			 queue_max_segments(q));
-
-	bio = bio_alloc(gfp_mask, nr_pages);
-	if (!bio)
-		return -ENOMEM;
+	if (WARN_ON_ONCE(!bdev->bd_disk->fops->report_zones))
+		return -EOPNOTSUPP;
 
-	bio_set_dev(bio, bdev);
-	bio->bi_iter.bi_sector = blk_zone_start(q, sector);
-	bio_set_op_attrs(bio, REQ_OP_ZONE_REPORT, 0);
-
-	for (i = 0; i < nr_pages; i++) {
-		page = alloc_page(gfp_mask);
-		if (!page) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		if (!bio_add_page(bio, page, PAGE_SIZE, 0)) {
-			__free_page(page);
-			break;
-		}
+	if (!*nr_zones || sector >= bdev->bd_part->nr_sects) {
+		*nr_zones = 0;
+		return 0;
 	}
 
-	if (i == 0)
-		ret = -ENOMEM;
-	else
-		ret = submit_bio_wait(bio);
+	nrz = min(*nr_zones,
+		  __blkdev_nr_zones(q, bdev->bd_part->nr_sects - sector));
+	ret = blk_report_zones(bdev->bd_disk, get_start_sect(bdev) + sector,
+			       zones, &nrz, gfp_mask);
 	if (ret)
-		goto out;
-
-	/*
-	 * Process the report result: skip the header and go through the
-	 * reported zones to fixup and fixup the zone information for
-	 * partitions. At the same time, return the zone information into
-	 * the zone array.
-	 */
-	n = 0;
-	nz = 0;
-	nr_rep = 0;
-	bio_for_each_segment_all(bv, bio, i) {
+		return ret;
 
-		if (!bv->bv_page)
+	for (i = 0; i < nrz; i++) {
+		if (!blkdev_report_zone(bdev, zones))
 			break;
-
-		addr = kmap_atomic(bv->bv_page);
-
-		/* Get header in the first page */
-		ofst = 0;
-		if (!nr_rep) {
-			hdr = addr;
-			nr_rep = hdr->nr_zones;
-			ofst = sizeof(struct blk_zone_report_hdr);
-		}
-
-		/* Fixup and report zones */
-		while (ofst < bv->bv_len &&
-		       n < nr_rep && nz < nrz) {
-			if (blkdev_report_zone(bdev, addr + ofst, &zones[nz]))
-				nz++;
-			ofst += sizeof(struct blk_zone);
-			n++;
-		}
-
-		kunmap_atomic(addr);
-
-		if (n >= nr_rep || nz >= nrz)
-			break;
-
+		zones++;
 	}
 
-	*nr_zones = nz;
-out:
-	bio_for_each_segment_all(bv, bio, i)
-		__free_page(bv->bv_page);
-	bio_put(bio);
+	*nr_zones = i;
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(blkdev_report_zones);
 
diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index 34e0030f0592..aba807013c50 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -87,7 +87,9 @@ struct nullb {
 #ifdef CONFIG_BLK_DEV_ZONED
 int null_zone_init(struct nullb_device *dev);
 void null_zone_exit(struct nullb_device *dev);
-blk_status_t null_zone_report(struct nullb *nullb, struct bio *bio);
+int null_zone_report(struct gendisk *disk, sector_t sector,
+		     struct blk_zone *zones, unsigned int *nr_zones,
+		     gfp_t gfp_mask);
 void null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 			unsigned int nr_sectors);
 void null_zone_reset(struct nullb_cmd *cmd, sector_t sector);
@@ -97,10 +99,11 @@ static inline int null_zone_init(struct nullb_device *dev)
 	return -EINVAL;
 }
 static inline void null_zone_exit(struct nullb_device *dev) {}
-static inline blk_status_t null_zone_report(struct nullb *nullb,
-					    struct bio *bio)
+static inline int null_zone_report(struct block_device *bdev, sector_t sector,
+				struct blk_zone *zones, unsigned int *nr_zones,
+				gfp_t gfp_mask)
 {
-	return BLK_STS_NOTSUPP;
+	return -EOPNOTSUPP;
 }
 static inline void null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 				   unsigned int nr_sectors)
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 093b614d6524..f5759ca768d1 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1157,34 +1157,12 @@ static void null_restart_queue_async(struct nullb *nullb)
 	}
 }
 
-static bool cmd_report_zone(struct nullb *nullb, struct nullb_cmd *cmd)
-{
-	struct nullb_device *dev = cmd->nq->dev;
-
-	if (dev->queue_mode == NULL_Q_BIO) {
-		if (bio_op(cmd->bio) == REQ_OP_ZONE_REPORT) {
-			cmd->error = null_zone_report(nullb, cmd->bio);
-			return true;
-		}
-	} else {
-		if (req_op(cmd->rq) == REQ_OP_ZONE_REPORT) {
-			cmd->error = null_zone_report(nullb, cmd->rq->bio);
-			return true;
-		}
-	}
-
-	return false;
-}
-
 static blk_status_t null_handle_cmd(struct nullb_cmd *cmd)
 {
 	struct nullb_device *dev = cmd->nq->dev;
 	struct nullb *nullb = dev->nullb;
 	int err = 0;
 
-	if (cmd_report_zone(nullb, cmd))
-		goto out;
-
 	if (test_bit(NULLB_DEV_FL_THROTTLED, &dev->flags)) {
 		struct request *rq = cmd->rq;
 
@@ -1528,6 +1506,7 @@ static const struct block_device_operations null_fops = {
 	.owner =	THIS_MODULE,
 	.open =		null_open,
 	.release =	null_release,
+	.report_zones =	null_zone_report,
 };
 
 static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 7c6b86d98700..c0b0e4a3fa8f 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -48,54 +48,27 @@ void null_zone_exit(struct nullb_device *dev)
 	kvfree(dev->zones);
 }
 
-static void null_zone_fill_bio(struct nullb_device *dev, struct bio *bio,
-			       unsigned int zno, unsigned int nr_zones)
+int null_zone_report(struct gendisk *disk, sector_t sector,
+		     struct blk_zone *zones, unsigned int *nr_zones,
+		     gfp_t gfp_mask)
 {
-	struct blk_zone_report_hdr *hdr = NULL;
-	struct bio_vec bvec;
-	struct bvec_iter iter;
-	void *addr;
-	unsigned int zones_to_cpy;
-
-	bio_for_each_segment(bvec, bio, iter) {
-		addr = kmap_atomic(bvec.bv_page);
-
-		zones_to_cpy = bvec.bv_len / sizeof(struct blk_zone);
-
-		if (!hdr) {
-			hdr = (struct blk_zone_report_hdr *)addr;
-			hdr->nr_zones = nr_zones;
-			zones_to_cpy--;
-			addr += sizeof(struct blk_zone_report_hdr);
-		}
-
-		zones_to_cpy = min_t(unsigned int, zones_to_cpy, nr_zones);
-
-		memcpy(addr, &dev->zones[zno],
-				zones_to_cpy * sizeof(struct blk_zone));
-
-		kunmap_atomic(addr);
+	struct nullb *nullb = disk->private_data;
+	struct nullb_device *dev = nullb->dev;
+	unsigned int zno, nrz = 0;
 
-		nr_zones -= zones_to_cpy;
-		zno += zones_to_cpy;
+	if (!dev->zoned)
+		/* Not a zoned null device */
+		return -EOPNOTSUPP;
 
-		if (!nr_zones)
-			break;
+	zno = null_zone_no(dev, sector);
+	if (zno < dev->nr_zones) {
+		nrz = min_t(unsigned int, *nr_zones, dev->nr_zones - zno);
+		memcpy(zones, &dev->zones[zno], nrz * sizeof(struct blk_zone));
 	}
-}
 
-blk_status_t null_zone_report(struct nullb *nullb, struct bio *bio)
-{
-	struct nullb_device *dev = nullb->dev;
-	unsigned int zno = null_zone_no(dev, bio->bi_iter.bi_sector);
-	unsigned int nr_zones = dev->nr_zones - zno;
-	unsigned int max_zones;
+	*nr_zones = nrz;
 
-	max_zones = (bio->bi_iter.bi_size / sizeof(struct blk_zone)) - 1;
-	nr_zones = min_t(unsigned int, nr_zones, max_zones);
-	null_zone_fill_bio(nullb->dev, bio, zno, nr_zones);
-
-	return BLK_STS_OK;
+	return 0;
 }
 
 void null_zone_write(struct nullb_cmd *cmd, sector_t sector,
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 21d126a5078c..e4a86daf0fd6 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -315,10 +315,6 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	if (bio_op(bio) == REQ_OP_ZONE_RESET)
 		goto map_bio;
 
-	/* We need to remap reported zones, so remember the BIO iter */
-	if (bio_op(bio) == REQ_OP_ZONE_REPORT)
-		goto map_bio;
-
 	/* Are we alive ? */
 	elapsed = (jiffies - fc->start_time) / HZ;
 	if (elapsed % (fc->up_interval + fc->down_interval) >= fc->up_interval) {
@@ -380,11 +376,6 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	if (bio_op(bio) == REQ_OP_ZONE_RESET)
 		return DM_ENDIO_DONE;
 
-	if (bio_op(bio) == REQ_OP_ZONE_REPORT) {
-		dm_remap_zone_report(ti, bio, fc->start);
-		return DM_ENDIO_DONE;
-	}
-
 	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
 		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
 		    all_corrupt_bio_flags_match(bio, fc)) {
@@ -457,6 +448,24 @@ static int flakey_prepare_ioctl(struct dm_target *ti, struct block_device **bdev
 	return 0;
 }
 
+static int flakey_report_zones(struct dm_target *ti, sector_t sector,
+			       struct blk_zone *zones, unsigned int *nr_zones,
+			       gfp_t gfp_mask)
+{
+	struct flakey_c *fc = ti->private;
+	int ret;
+
+	/* Do report and remap it */
+	ret = blkdev_report_zones(fc->dev->bdev, flakey_map_sector(ti, sector),
+				  zones, nr_zones, gfp_mask);
+	if (ret != 0)
+		return ret;
+
+	if (*nr_zones)
+		dm_remap_zone_report(ti, fc->start, zones, nr_zones);
+	return 0;
+}
+
 static int flakey_iterate_devices(struct dm_target *ti, iterate_devices_callout_fn fn, void *data)
 {
 	struct flakey_c *fc = ti->private;
@@ -475,6 +484,7 @@ static struct target_type flakey_target = {
 	.end_io = flakey_end_io,
 	.status = flakey_status,
 	.prepare_ioctl = flakey_prepare_ioctl,
+	.report_zones = flakey_report_zones,
 	.iterate_devices = flakey_iterate_devices,
 };
 
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index d10964d41fd7..69da7b5a33ad 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -102,17 +102,6 @@ static int linear_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-static int linear_end_io(struct dm_target *ti, struct bio *bio,
-			 blk_status_t *error)
-{
-	struct linear_c *lc = ti->private;
-
-	if (!*error && bio_op(bio) == REQ_OP_ZONE_REPORT)
-		dm_remap_zone_report(ti, bio, lc->start);
-
-	return DM_ENDIO_DONE;
-}
-
 static void linear_status(struct dm_target *ti, status_type_t type,
 			  unsigned status_flags, char *result, unsigned maxlen)
 {
@@ -146,6 +135,24 @@ static int linear_prepare_ioctl(struct dm_target *ti, struct block_device **bdev
 	return 0;
 }
 
+static int linear_report_zones(struct dm_target *ti, sector_t sector,
+			       struct blk_zone *zones, unsigned int *nr_zones,
+			       gfp_t gfp_mask)
+{
+	struct linear_c *lc = (struct linear_c *) ti->private;
+	int ret;
+
+	/* Do report and remap it */
+	ret = blkdev_report_zones(lc->dev->bdev, linear_map_sector(ti, sector),
+				  zones, nr_zones, gfp_mask);
+	if (ret != 0)
+		return ret;
+
+	if (*nr_zones)
+		dm_remap_zone_report(ti, lc->start, zones, nr_zones);
+	return 0;
+}
+
 static int linear_iterate_devices(struct dm_target *ti,
 				  iterate_devices_callout_fn fn, void *data)
 {
@@ -213,9 +220,9 @@ static struct target_type linear_target = {
 	.ctr    = linear_ctr,
 	.dtr    = linear_dtr,
 	.map    = linear_map,
-	.end_io = linear_end_io,
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
+	.report_zones = linear_report_zones,
 	.iterate_devices = linear_iterate_devices,
 	.direct_access = linear_dax_direct_access,
 	.dax_copy_from_iter = linear_dax_copy_from_iter,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 20f7e4ef5342..e9fb3c706ef6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -458,6 +458,53 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return dm_get_geometry(md, geo);
 }
 
+static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
+			       struct blk_zone *zones, unsigned int *nr_zones,
+			       gfp_t gfp_mask)
+{
+	struct mapped_device *md = disk->private_data;
+	struct dm_target *tgt;
+	struct dm_table *map;
+	int srcu_idx, ret;
+
+	if (dm_suspended_md(md))
+		return -EAGAIN;
+
+	map = dm_get_live_table(md, &srcu_idx);
+	if (!map)
+		return -EIO;
+
+	tgt = dm_table_find_target(map, sector);
+	if (!dm_target_is_valid(tgt)) {
+		ret = -EIO;
+		goto out;
+	}
+
+	/*
+	 * If we are executing this, we already know that the block device
+	 * is a zoned device and so each target should have support for that
+	 * type of drive. A missing report_zones method means that the target
+	 * driver has a problem.
+	 */
+	if (WARN_ON(!tgt->type->report_zones)) {
+		ret = -EIO;
+		goto out;
+	}
+
+	/*
+	 * blkdev_report_zones() will loop and call this again to cover all the
+	 * zones of the target, eventually moving on to the next target.
+	 * So there is no need to loop here trying to fill the entire array
+	 * of zones.
+	 */
+	ret = tgt->type->report_zones(tgt, sector, zones,
+				      nr_zones, gfp_mask);
+
+out:
+	dm_put_live_table(md, srcu_idx);
+	return ret;
+}
+
 static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 			    struct block_device **bdev)
 	__acquires(md->io_barrier)
@@ -1156,79 +1203,48 @@ EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
 /*
  * The zone descriptors obtained with a zone report indicate
- * zone positions within the target device. The zone descriptors
- * must be remapped to match their position within the dm device.
- * A target may call dm_remap_zone_report after completion of a
- * REQ_OP_ZONE_REPORT bio to remap the zone descriptors obtained
- * from the target device mapping to the dm device.
+ * zone positions within the underlying device of the target. The zone
+ * descriptors must be remapped to match their position within the dm device.
+ * The caller target should obtain the zones information using
+ * blkdev_report_zones() to ensure that remapping for partition offset is
+ * already handled.
  */
-void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
+void dm_remap_zone_report(struct dm_target *ti, sector_t start,
+			  struct blk_zone *zones, unsigned int *nr_zones)
 {
 #ifdef CONFIG_BLK_DEV_ZONED
-	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
-	struct bio *report_bio = tio->io->orig_bio;
-	struct blk_zone_report_hdr *hdr = NULL;
 	struct blk_zone *zone;
-	unsigned int nr_rep = 0;
-	unsigned int ofst;
-	struct bio_vec bvec;
-	struct bvec_iter iter;
-	void *addr;
-
-	if (bio->bi_status)
-		return;
+	unsigned int nrz = *nr_zones;
+	int i;
 
 	/*
-	 * Remap the start sector of the reported zones. For sequential zones,
-	 * also remap the write pointer position.
+	 * Remap the start sector and write pointer position of the zones in
+	 * the array. Since we may have obtained from the target underlying
+	 * device more zones that the target size, also adjust the number
+	 * of zones.
 	 */
-	bio_for_each_segment(bvec, report_bio, iter) {
-		addr = kmap_atomic(bvec.bv_page);
-
-		/* Remember the report header in the first page */
-		if (!hdr) {
-			hdr = addr;
-			ofst = sizeof(struct blk_zone_report_hdr);
-		} else
-			ofst = 0;
-
-		/* Set zones start sector */
-		while (hdr->nr_zones && ofst < bvec.bv_len) {
-			zone = addr + ofst;
-			if (zone->start >= start + ti->len) {
-				hdr->nr_zones = 0;
-				break;
-			}
-			zone->start = zone->start + ti->begin - start;
-			if (zone->type != BLK_ZONE_TYPE_CONVENTIONAL) {
-				if (zone->cond == BLK_ZONE_COND_FULL)
-					zone->wp = zone->start + zone->len;
-				else if (zone->cond == BLK_ZONE_COND_EMPTY)
-					zone->wp = zone->start;
-				else
-					zone->wp = zone->wp + ti->begin - start;
-			}
-			ofst += sizeof(struct blk_zone);
-			hdr->nr_zones--;
-			nr_rep++;
+	for (i = 0; i < nrz; i++) {
+		zone = zones + i;
+		if (zone->start >= start + ti->len) {
+			memset(zone, 0, sizeof(struct blk_zone) * (nrz - i));
+			break;
 		}
 
-		if (addr != hdr)
-			kunmap_atomic(addr);
-
-		if (!hdr->nr_zones)
-			break;
-	}
+		zone->start = zone->start + ti->begin - start;
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+			continue;
 
-	if (hdr) {
-		hdr->nr_zones = nr_rep;
-		kunmap_atomic(hdr);
+		if (zone->cond == BLK_ZONE_COND_FULL)
+			zone->wp = zone->start + zone->len;
+		else if (zone->cond == BLK_ZONE_COND_EMPTY)
+			zone->wp = zone->start;
+		else
+			zone->wp = zone->wp + ti->begin - start;
 	}
 
-	bio_advance(report_bio, report_bio->bi_iter.bi_size);
-
+	*nr_zones = i;
 #else /* !CONFIG_BLK_DEV_ZONED */
-	bio->bi_status = BLK_STS_NOTSUPP;
+	*nr_zones = 0;
 #endif
 }
 EXPORT_SYMBOL_GPL(dm_remap_zone_report);
@@ -1314,8 +1330,7 @@ static int clone_bio(struct dm_target_io *tio, struct bio *bio,
 			return r;
 	}
 
-	if (bio_op(bio) != REQ_OP_ZONE_REPORT)
-		bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
+	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
 	clone->bi_iter.bi_size = to_bytes(len);
 
 	if (unlikely(bio_integrity(bio) != NULL))
@@ -1528,7 +1543,6 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
  */
 static int __split_and_process_non_flush(struct clone_info *ci)
 {
-	struct bio *bio = ci->bio;
 	struct dm_target *ti;
 	unsigned len;
 	int r;
@@ -1540,11 +1554,7 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 	if (unlikely(__process_abnormal_io(ci, ti, &r)))
 		return r;
 
-	if (bio_op(bio) == REQ_OP_ZONE_REPORT)
-		len = ci->sector_count;
-	else
-		len = min_t(sector_t, max_io_len(ci->sector, ti),
-			    ci->sector_count);
+	len = min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
 
 	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
 	if (r < 0)
@@ -1603,9 +1613,6 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 				 * We take a clone of the original to store in
 				 * ci.io->orig_bio to be used by end_io_acct() and
 				 * for dec_pending to use for completion handling.
-				 * As this path is not used for REQ_OP_ZONE_REPORT,
-				 * the usage of io->orig_bio in dm_remap_zone_report()
-				 * won't be affected by this reassignment.
 				 */
 				struct bio *b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
 							  GFP_NOIO, &md->queue->bio_split);
@@ -3154,6 +3161,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
+	.report_zones = dm_blk_report_zones,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
 };
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4a57ffecc7e6..718aaf15d812 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1271,8 +1271,6 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
 		return sd_setup_read_write_cmnd(cmd);
-	case REQ_OP_ZONE_REPORT:
-		return sd_zbc_setup_report_cmnd(cmd);
 	case REQ_OP_ZONE_RESET:
 		return sd_zbc_setup_reset_cmnd(cmd);
 	default:
@@ -1801,6 +1799,7 @@ static const struct block_device_operations sd_fops = {
 	.check_events		= sd_check_events,
 	.revalidate_disk	= sd_revalidate_disk,
 	.unlock_native_capacity	= sd_unlock_native_capacity,
+	.report_zones		= sd_zbc_report_zones,
 	.pr_ops			= &sd_pr_ops,
 };
 
@@ -1952,16 +1951,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			scsi_set_resid(SCpnt, blk_rq_bytes(req));
 		}
 		break;
-	case REQ_OP_ZONE_REPORT:
-		if (!result) {
-			good_bytes = scsi_bufflen(SCpnt)
-				- scsi_get_resid(SCpnt);
-			scsi_set_resid(SCpnt, 0);
-		} else {
-			good_bytes = 0;
-			scsi_set_resid(SCpnt, blk_rq_bytes(req));
-		}
-		break;
 	default:
 		/*
 		 * In case of bogus fw or device, we could end up having
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index a7d4f50b67d4..f72f20fd0d8b 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -273,10 +273,12 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 extern void sd_zbc_remove(struct scsi_disk *sdkp);
 extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
-extern int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
 extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 			    struct scsi_sense_hdr *sshdr);
+extern int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
+			       struct blk_zone *zones, unsigned int *nr_zones,
+			       gfp_t gfp_mask);
 
 #else /* CONFIG_BLK_DEV_ZONED */
 
@@ -290,11 +292,6 @@ static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
 
 static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
 
-static inline int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
-{
-	return BLKPREP_INVALID;
-}
-
 static inline int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 {
 	return BLKPREP_INVALID;
@@ -304,6 +301,8 @@ static inline void sd_zbc_complete(struct scsi_cmnd *cmd,
 				   unsigned int good_bytes,
 				   struct scsi_sense_hdr *sshdr) {}
 
+#define sd_zbc_report_zones NULL
+
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 44b64b4a922a..1e8274f473b0 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -62,7 +62,7 @@ static void sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
 }
 
 /**
- * sd_zbc_report_zones - Issue a REPORT ZONES scsi command.
+ * sd_zbc_do_report_zones - Issue a REPORT ZONES scsi command.
  * @sdkp: The target disk
  * @buf: Buffer to use for the reply
  * @buflen: the buffer size
@@ -75,9 +75,9 @@ static void sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
  * zones and will only report the count of zones fitting in the command reply
  * buffer.
  */
-static int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
-			       unsigned int buflen, sector_t lba,
-			       bool partial)
+static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
+				  unsigned int buflen, sector_t lba,
+				  bool partial)
 {
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout;
@@ -118,108 +118,56 @@ static int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 }
 
 /**
- * sd_zbc_setup_report_cmnd - Prepare a REPORT ZONES scsi command
- * @cmd: The command to setup
+ * sd_zbc_report_zones - Disk report zones operation.
+ * @disk: The target disk
+ * @sector: Start 512B sector of the report
+ * @zones: Array of zone descriptors
+ * @nr_zones: Number of descriptors in the array
+ * @gfp_mask: Memory allocation mask
  *
- * Call in sd_init_command() for a REQ_OP_ZONE_REPORT request.
+ * Execute a report zones command on the target disk.
  */
-int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
+int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
+			struct blk_zone *zones, unsigned int *nr_zones,
+			gfp_t gfp_mask)
 {
-	struct request *rq = cmd->request;
-	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
-	sector_t lba, sector = blk_rq_pos(rq);
-	unsigned int nr_bytes = blk_rq_bytes(rq);
-	int ret;
-
-	WARN_ON(nr_bytes == 0);
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	unsigned int i, buflen, nrz = *nr_zones;
+	unsigned char *buf;
+	size_t offset = 0;
+	int ret = 0;
 
 	if (!sd_is_zoned(sdkp))
 		/* Not a zoned device */
-		return BLKPREP_KILL;
-
-	ret = scsi_init_io(cmd);
-	if (ret != BLKPREP_OK)
-		return ret;
-
-	cmd->cmd_len = 16;
-	memset(cmd->cmnd, 0, cmd->cmd_len);
-	cmd->cmnd[0] = ZBC_IN;
-	cmd->cmnd[1] = ZI_REPORT_ZONES;
-	lba = sectors_to_logical(sdkp->device, sector);
-	put_unaligned_be64(lba, &cmd->cmnd[2]);
-	put_unaligned_be32(nr_bytes, &cmd->cmnd[10]);
-	/* Do partial report for speeding things up */
-	cmd->cmnd[14] = ZBC_REPORT_ZONE_PARTIAL;
-
-	cmd->sc_data_direction = DMA_FROM_DEVICE;
-	cmd->sdb.length = nr_bytes;
-	cmd->transfersize = sdkp->device->sector_size;
-	cmd->allowed = 0;
+		return -EOPNOTSUPP;
 
-	return BLKPREP_OK;
-}
-
-/**
- * sd_zbc_report_zones_complete - Process a REPORT ZONES scsi command reply.
- * @scmd: The completed report zones command
- * @good_bytes: reply size in bytes
- *
- * Convert all reported zone descriptors to struct blk_zone. The conversion
- * is done in-place, directly in the request specified sg buffer.
- */
-static void sd_zbc_report_zones_complete(struct scsi_cmnd *scmd,
-					 unsigned int good_bytes)
-{
-	struct request *rq = scmd->request;
-	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
-	struct sg_mapping_iter miter;
-	struct blk_zone_report_hdr hdr;
-	struct blk_zone zone;
-	unsigned int offset, bytes = 0;
-	unsigned long flags;
-	u8 *buf;
-
-	if (good_bytes < 64)
-		return;
-
-	memset(&hdr, 0, sizeof(struct blk_zone_report_hdr));
-
-	sg_miter_start(&miter, scsi_sglist(scmd), scsi_sg_count(scmd),
-		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+	/*
+	 * Get a reply buffer for the number of requested zones plus a header.
+	 * For ATA, buffers must be aligned to 512B.
+	 */
+	buflen = roundup((nrz + 1) * 64, 512);
+	buf = kmalloc(buflen, gfp_mask);
+	if (!buf)
+		return -ENOMEM;
 
-	local_irq_save(flags);
-	while (sg_miter_next(&miter) && bytes < good_bytes) {
+	ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
+			sectors_to_logical(sdkp->device, sector), true);
+	if (ret)
+		goto out_free_buf;
 
-		buf = miter.addr;
-		offset = 0;
+	nrz = min(nrz, get_unaligned_be32(&buf[0]) / 64);
+	for (i = 0; i < nrz; i++) {
+		offset += 64;
+		sd_zbc_parse_report(sdkp, buf + offset, zones);
+		zones++;
+	}
 
-		if (bytes == 0) {
-			/* Set the report header */
-			hdr.nr_zones = min_t(unsigned int,
-					 (good_bytes - 64) / 64,
-					 get_unaligned_be32(&buf[0]) / 64);
-			memcpy(buf, &hdr, sizeof(struct blk_zone_report_hdr));
-			offset += 64;
-			bytes += 64;
-		}
+	*nr_zones = nrz;
 
-		/* Parse zone descriptors */
-		while (offset < miter.length && hdr.nr_zones) {
-			WARN_ON(offset > miter.length);
-			buf = miter.addr + offset;
-			sd_zbc_parse_report(sdkp, buf, &zone);
-			memcpy(buf, &zone, sizeof(struct blk_zone));
-			offset += 64;
-			bytes += 64;
-			hdr.nr_zones--;
-		}
-
-		if (!hdr.nr_zones)
-			break;
+out_free_buf:
+	kfree(buf);
 
-	}
-	sg_miter_stop(&miter);
-	local_irq_restore(flags);
+	return ret;
 }
 
 /**
@@ -302,13 +250,6 @@ void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE_SAME:
 		break;
-
-	case REQ_OP_ZONE_REPORT:
-
-		if (!result)
-			sd_zbc_report_zones_complete(cmd, good_bytes);
-		break;
-
 	}
 }
 
@@ -390,7 +331,7 @@ static s32 sd_zbc_check_zones(struct scsi_disk *sdkp)
 		return -ENOMEM;
 
 	/* Do a report zone to get max_lba and the same field */
-	ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, 0, false);
+	ret = sd_zbc_do_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, 0, false);
 	if (ret)
 		goto out_free;
 
@@ -447,8 +388,8 @@ static s32 sd_zbc_check_zones(struct scsi_disk *sdkp)
 		}
 
 		if (block < sdkp->capacity) {
-			ret = sd_zbc_report_zones(sdkp, buf,
-						  SD_ZBC_BUF_SIZE, block, true);
+			ret = sd_zbc_do_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE,
+						     block, true);
 			if (ret)
 				goto out_free;
 		}
@@ -564,8 +505,8 @@ sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp, u32 zone_shift,
 		goto out;
 
 	while (lba < sdkp->capacity) {
-		ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE,
-					  lba, true);
+		ret = sd_zbc_do_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, lba,
+					     true);
 		if (ret)
 			goto out;
 		lba = sd_zbc_get_seq_zones(sdkp, buf, SD_ZBC_BUF_SIZE,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index f6dfb30737d8..1dcf652ba0aa 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -284,8 +284,6 @@ enum req_opf {
 	REQ_OP_FLUSH		= 2,
 	/* discard sectors */
 	REQ_OP_DISCARD		= 3,
-	/* get zone information */
-	REQ_OP_ZONE_REPORT	= 4,
 	/* securely erase sectors */
 	REQ_OP_SECURE_ERASE	= 5,
 	/* seset a zone write pointer */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c24969b1741b..d183c10872b7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -396,11 +396,6 @@ struct queue_limits {
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-struct blk_zone_report_hdr {
-	unsigned int	nr_zones;
-	u8		padding[60];
-};
-
 extern unsigned int blkdev_nr_zones(struct block_device *bdev);
 extern int blkdev_report_zones(struct block_device *bdev,
 			       sector_t sector, struct blk_zone *zones,
@@ -1992,6 +1987,9 @@ struct block_device_operations {
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
 	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
+	int (*report_zones)(struct gendisk *, sector_t sector,
+			    struct blk_zone *zones, unsigned int *nr_zones,
+			    gfp_t gfp_mask);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
 };
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 6fb0808e87c8..0d40ee6f5fd5 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -92,6 +92,11 @@ typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv,
 
 typedef int (*dm_prepare_ioctl_fn) (struct dm_target *ti, struct block_device **bdev);
 
+typedef int (*dm_report_zones_fn) (struct dm_target *ti, sector_t sector,
+				   struct blk_zone *zones,
+				   unsigned int *nr_zones,
+				   gfp_t gfp_mask);
+
 /*
  * These iteration functions are typically used to check (and combine)
  * properties of underlying devices.
@@ -180,6 +185,7 @@ struct target_type {
 	dm_status_fn status;
 	dm_message_fn message;
 	dm_prepare_ioctl_fn prepare_ioctl;
+	dm_report_zones_fn report_zones;
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
@@ -420,8 +426,8 @@ struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
-void dm_remap_zone_report(struct dm_target *ti, struct bio *bio,
-			  sector_t start);
+void dm_remap_zone_report(struct dm_target *ti, sector_t start,
+			  struct blk_zone *zones, unsigned int *nr_zones);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 795698925d20..3ec73f17ee2a 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -82,7 +82,6 @@ TRACE_DEFINE_ENUM(CP_TRIMMED);
 		{ REQ_OP_WRITE,			"WRITE" },		\
 		{ REQ_OP_FLUSH,			"FLUSH" },		\
 		{ REQ_OP_DISCARD,		"DISCARD" },		\
-		{ REQ_OP_ZONE_REPORT,		"ZONE_REPORT" },	\
 		{ REQ_OP_SECURE_ERASE,		"SECURE_ERASE" },	\
 		{ REQ_OP_ZONE_RESET,		"ZONE_RESET" },		\
 		{ REQ_OP_WRITE_SAME,		"WRITE_SAME" },		\
-- 
2.17.1
