From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] dm: remove write same support
Date: Wed, 12 Apr 2017 10:48:06 +0200
Message-ID: <20170412084809.8245-6-hch@lst.de>
References: <20170412084809.8245-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170412084809.8245-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-core.h          |  1 -
 drivers/md/dm-io.c            | 21 +--------------------
 drivers/md/dm-linear.c        |  1 -
 drivers/md/dm-mpath.c         |  1 -
 drivers/md/dm-rq.c            |  3 ---
 drivers/md/dm-stripe.c        |  4 +---
 drivers/md/dm-table.c         | 29 -----------------------------
 drivers/md/dm.c               | 23 -----------------------
 include/linux/device-mapper.h |  6 ------
 9 files changed, 2 insertions(+), 87 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index fea5bd52ada8..d661801d72e7 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -131,7 +131,6 @@ struct mapped_device {
 void dm_init_md_queue(struct mapped_device *md);
 void dm_init_normal_md_queue(struct mapped_device *md);
 int md_in_flight(struct mapped_device *md);
-void disable_write_same(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
 
 static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 3702e502466d..105e68dabd3e 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -303,7 +303,6 @@ static void do_region(int op, int op_flags, unsigned region,
 	unsigned num_bvecs;
 	sector_t remaining = where->count;
 	struct request_queue *q = bdev_get_queue(where->bdev);
-	unsigned short logical_block_size = queue_logical_block_size(q);
 	sector_t num_sectors;
 	unsigned int uninitialized_var(special_cmd_max_sectors);
 
@@ -314,10 +313,7 @@ static void do_region(int op, int op_flags, unsigned region,
 		special_cmd_max_sectors = q->limits.max_discard_sectors;
 	else if (op == REQ_OP_WRITE_ZEROES)
 		special_cmd_max_sectors = q->limits.max_write_zeroes_sectors;
-	else if (op == REQ_OP_WRITE_SAME)
-		special_cmd_max_sectors = q->limits.max_write_same_sectors;
-	if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES ||
-	     op == REQ_OP_WRITE_SAME)  &&
+	if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES) &&
 	    special_cmd_max_sectors == 0) {
 		dec_count(io, region, -EOPNOTSUPP);
 		return;
@@ -336,9 +332,6 @@ static void do_region(int op, int op_flags, unsigned region,
 		case REQ_OP_WRITE_ZEROES:
 			num_bvecs = 0;
 			break;
-		case REQ_OP_WRITE_SAME:
-			num_bvecs = 1;
-			break;
 		default:
 			num_bvecs = min_t(int, BIO_MAX_PAGES,
 					  dm_sector_div_up(remaining, (PAGE_SIZE >> SECTOR_SHIFT)));
@@ -355,18 +348,6 @@ static void do_region(int op, int op_flags, unsigned region,
 			num_sectors = min_t(sector_t, special_cmd_max_sectors, remaining);
 			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 			remaining -= num_sectors;
-		} else if (op == REQ_OP_WRITE_SAME) {
-			/*
-			 * WRITE SAME only uses a single page.
-			 */
-			dp->get_page(dp, &page, &len, &offset);
-			bio_add_page(bio, page, logical_block_size, offset);
-			num_sectors = min_t(sector_t, special_cmd_max_sectors, remaining);
-			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
-
-			offset = 0;
-			remaining -= num_sectors;
-			dp->next_page(dp);
 		} else while (remaining) {
 			/*
 			 * Try and add as many pages as possible.
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index e17fd44ceef5..f928f7e9ee4a 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -58,7 +58,6 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
-	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
 	ti->private = lc;
 	return 0;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index ab55955ed704..ece53947b99d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1102,7 +1102,6 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
-	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
 	if (m->queue_mode == DM_TYPE_BIO_BASED)
 		ti->per_io_data_size = multipath_per_bio_data_size();
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index e60f1b6845be..6f8dc99685f2 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -299,9 +299,6 @@ static void dm_done(struct request *clone, int error, bool mapped)
 	}
 
 	if (unlikely(r == -EREMOTEIO)) {
-		if (req_op(clone) == REQ_OP_WRITE_SAME &&
-		    !clone->q->limits.max_write_same_sectors)
-			disable_write_same(tio->md);
 		if (req_op(clone) == REQ_OP_WRITE_ZEROES &&
 		    !clone->q->limits.max_write_zeroes_sectors)
 			disable_write_zeroes(tio->md);
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 5ef49c121d99..cc5a00f2e2de 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -168,7 +168,6 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_flush_bios = stripes;
 	ti->num_discard_bios = stripes;
-	ti->num_write_same_bios = stripes;
 	ti->num_write_zeroes_bios = stripes;
 
 	sc->chunk_size = chunk_size;
@@ -294,8 +293,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_REMAPPED;
 	}
 	if (unlikely(bio_op(bio) == REQ_OP_DISCARD) ||
-	    unlikely(bio_op(bio) == REQ_OP_WRITE_ZEROES) ||
-	    unlikely(bio_op(bio) == REQ_OP_WRITE_SAME)) {
+	    unlikely(bio_op(bio) == REQ_OP_WRITE_ZEROES)) {
 		target_bio_nr = dm_bio_get_target_bio_nr(bio);
 		BUG_ON(target_bio_nr >= sc->stripes);
 		return stripe_map_range(sc, bio, target_bio_nr);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 958275aca008..8bbc3d57fcc7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1490,33 +1490,6 @@ static bool dm_table_all_devices_attribute(struct dm_table *t,
 	return true;
 }
 
-static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
-					 sector_t start, sector_t len, void *data)
-{
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-
-	return q && !q->limits.max_write_same_sectors;
-}
-
-static bool dm_table_supports_write_same(struct dm_table *t)
-{
-	struct dm_target *ti;
-	unsigned i = 0;
-
-	while (i < dm_table_get_num_targets(t)) {
-		ti = dm_table_get_target(t, i++);
-
-		if (!ti->num_write_same_bios)
-			return false;
-
-		if (!ti->type->iterate_devices ||
-		    ti->type->iterate_devices(ti, device_not_write_same_capable, NULL))
-			return false;
-	}
-
-	return true;
-}
-
 static int device_not_write_zeroes_capable(struct dm_target *ti, struct dm_dev *dev,
 					   sector_t start, sector_t len, void *data)
 {
@@ -1610,8 +1583,6 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
 
-	if (!dm_table_supports_write_same(t))
-		q->limits.max_write_same_sectors = 0;
 	if (!dm_table_supports_write_zeroes(t))
 		q->limits.max_write_zeroes_sectors = 0;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8bf397729bbd..8259aa76839e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -816,14 +816,6 @@ static void dec_pending(struct dm_io *io, int error)
 	}
 }
 
-void disable_write_same(struct mapped_device *md)
-{
-	struct queue_limits *limits = dm_get_queue_limits(md);
-
-	/* device doesn't really support WRITE SAME, disable it */
-	limits->max_write_same_sectors = 0;
-}
-
 void disable_write_zeroes(struct mapped_device *md)
 {
 	struct queue_limits *limits = dm_get_queue_limits(md);
@@ -859,9 +851,6 @@ static void clone_endio(struct bio *bio)
 	}
 
 	if (unlikely(r == -EREMOTEIO)) {
-		if (bio_op(bio) == REQ_OP_WRITE_SAME &&
-		    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
-			disable_write_same(md);
 		if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
 		    !bdev_get_queue(bio->bi_bdev)->limits.max_write_zeroes_sectors)
 			disable_write_zeroes(md);
@@ -1209,11 +1198,6 @@ static unsigned get_num_discard_bios(struct dm_target *ti)
 	return ti->num_discard_bios;
 }
 
-static unsigned get_num_write_same_bios(struct dm_target *ti)
-{
-	return ti->num_write_same_bios;
-}
-
 static unsigned get_num_write_zeroes_bios(struct dm_target *ti)
 {
 	return ti->num_write_zeroes_bios;
@@ -1268,11 +1252,6 @@ static int __send_discard(struct clone_info *ci)
 					   is_split_required_for_discard);
 }
 
-static int __send_write_same(struct clone_info *ci)
-{
-	return __send_changing_extent_only(ci, get_num_write_same_bios, NULL);
-}
-
 static int __send_write_zeroes(struct clone_info *ci)
 {
 	return __send_changing_extent_only(ci, get_num_write_zeroes_bios, NULL);
@@ -1290,8 +1269,6 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 
 	if (unlikely(bio_op(bio) == REQ_OP_DISCARD))
 		return __send_discard(ci);
-	else if (unlikely(bio_op(bio) == REQ_OP_WRITE_SAME))
-		return __send_write_same(ci);
 	else if (unlikely(bio_op(bio) == REQ_OP_WRITE_ZEROES))
 		return __send_write_zeroes(ci);
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index c7ea33e38fb9..58f451ba9b75 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -249,12 +249,6 @@ struct dm_target {
 	unsigned num_discard_bios;
 
 	/*
-	 * The number of WRITE SAME bios that will be submitted to the target.
-	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
-	 */
-	unsigned num_write_same_bios;
-
-	/*
 	 * The number of WRITE ZEROES bios that will be submitted to the target.
 	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
 	 */
-- 
2.11.0
