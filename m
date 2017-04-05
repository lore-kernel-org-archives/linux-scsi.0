From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/27] dm: support REQ_OP_WRITE_ZEROES
Date: Wed,  5 Apr 2017 19:21:05 +0200
Message-ID: <20170405172125.22600-8-hch@lst.de>
References: <20170405172125.22600-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170405172125.22600-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Copy & paste from the REQ_OP_WRITE_SAME code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-core.h          |  1 +
 drivers/md/dm-io.c            |  8 ++++++--
 drivers/md/dm-linear.c        |  1 +
 drivers/md/dm-mpath.c         |  1 +
 drivers/md/dm-rq.c            | 11 ++++++++---
 drivers/md/dm-stripe.c        |  2 ++
 drivers/md/dm-table.c         | 30 ++++++++++++++++++++++++++++++
 drivers/md/dm.c               | 31 ++++++++++++++++++++++++++++---
 include/linux/device-mapper.h |  6 ++++++
 9 files changed, 83 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 136fda3ff9e5..fea5bd52ada8 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -132,6 +132,7 @@ void dm_init_md_queue(struct mapped_device *md);
 void dm_init_normal_md_queue(struct mapped_device *md);
 int md_in_flight(struct mapped_device *md);
 void disable_write_same(struct mapped_device *md);
+void disable_write_zeroes(struct mapped_device *md);
 
 static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
 {
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index b808cbe22678..3702e502466d 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -312,9 +312,12 @@ static void do_region(int op, int op_flags, unsigned region,
 	 */
 	if (op == REQ_OP_DISCARD)
 		special_cmd_max_sectors = q->limits.max_discard_sectors;
+	else if (op == REQ_OP_WRITE_ZEROES)
+		special_cmd_max_sectors = q->limits.max_write_zeroes_sectors;
 	else if (op == REQ_OP_WRITE_SAME)
 		special_cmd_max_sectors = q->limits.max_write_same_sectors;
-	if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_SAME) &&
+	if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES ||
+	     op == REQ_OP_WRITE_SAME)  &&
 	    special_cmd_max_sectors == 0) {
 		dec_count(io, region, -EOPNOTSUPP);
 		return;
@@ -330,6 +333,7 @@ static void do_region(int op, int op_flags, unsigned region,
 		 */
 		switch (op) {
 		case REQ_OP_DISCARD:
+		case REQ_OP_WRITE_ZEROES:
 			num_bvecs = 0;
 			break;
 		case REQ_OP_WRITE_SAME:
@@ -347,7 +351,7 @@ static void do_region(int op, int op_flags, unsigned region,
 		bio_set_op_attrs(bio, op, op_flags);
 		store_io_and_region_in_bio(bio, io, region);
 
-		if (op == REQ_OP_DISCARD) {
+		if (op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES) {
 			num_sectors = min_t(sector_t, special_cmd_max_sectors, remaining);
 			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 			remaining -= num_sectors;
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 4788b0b989a9..e17fd44ceef5 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -59,6 +59,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
+	ti->num_write_zeroes_bios = 1;
 	ti->private = lc;
 	return 0;
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7f223dbed49f..ab55955ed704 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1103,6 +1103,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
+	ti->num_write_zeroes_bios = 1;
 	if (m->queue_mode == DM_TYPE_BIO_BASED)
 		ti->per_io_data_size = multipath_per_bio_data_size();
 	else
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 6886bf160fb2..a789bf035621 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -298,9 +298,14 @@ static void dm_done(struct request *clone, int error, bool mapped)
 			r = rq_end_io(tio->ti, clone, error, &tio->info);
 	}
 
-	if (unlikely(r == -EREMOTEIO && (req_op(clone) == REQ_OP_WRITE_SAME) &&
-		     !clone->q->limits.max_write_same_sectors))
-		disable_write_same(tio->md);
+	if (unlikely(r == -EREMOTEIO)) {
+		if (req_op(clone) == REQ_OP_WRITE_SAME &&
+		    !clone->q->limits.max_write_same_sectors)
+			disable_write_same(tio->md);
+		if (req_op(clone) == REQ_OP_WRITE_ZEROES &&
+		    !clone->q->limits.max_write_zeroes_sectors)
+			disable_write_zeroes(tio->md);
+	}
 
 	if (r <= 0)
 		/* The target wants to complete the I/O */
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 28193a57bf47..5ef49c121d99 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -169,6 +169,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_flush_bios = stripes;
 	ti->num_discard_bios = stripes;
 	ti->num_write_same_bios = stripes;
+	ti->num_write_zeroes_bios = stripes;
 
 	sc->chunk_size = chunk_size;
 	if (chunk_size & (chunk_size - 1))
@@ -293,6 +294,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_REMAPPED;
 	}
 	if (unlikely(bio_op(bio) == REQ_OP_DISCARD) ||
+	    unlikely(bio_op(bio) == REQ_OP_WRITE_ZEROES) ||
 	    unlikely(bio_op(bio) == REQ_OP_WRITE_SAME)) {
 		target_bio_nr = dm_bio_get_target_bio_nr(bio);
 		BUG_ON(target_bio_nr >= sc->stripes);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3ad16d9c9d5a..5cd665c91ead 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1533,6 +1533,34 @@ static bool dm_table_supports_write_same(struct dm_table *t)
 	return true;
 }
 
+static int device_not_write_zeroes_capable(struct dm_target *ti, struct dm_dev *dev,
+					   sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && !q->limits.max_write_zeroes_sectors;
+}
+
+static bool dm_table_supports_write_zeroes(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i = 0;
+
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+
+		if (!ti->num_write_zeroes_bios)
+			return false;
+
+		if (!ti->type->iterate_devices ||
+		    ti->type->iterate_devices(ti, device_not_write_zeroes_capable, NULL))
+			return false;
+	}
+
+	return true;
+}
+
+
 static int device_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
@@ -1603,6 +1631,8 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 
 	if (!dm_table_supports_write_same(t))
 		q->limits.max_write_same_sectors = 0;
+	if (!dm_table_supports_write_zeroes(t))
+		q->limits.max_write_zeroes_sectors = 0;
 
 	if (dm_table_all_devices_attribute(t, queue_supports_sg_merge))
 		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index dfb75979e455..e8226359c8f7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -825,6 +825,14 @@ void disable_write_same(struct mapped_device *md)
 	limits->max_write_same_sectors = 0;
 }
 
+void disable_write_zeroes(struct mapped_device *md)
+{
+	struct queue_limits *limits = dm_get_queue_limits(md);
+
+	/* device doesn't really support WRITE ZEROES, disable it */
+	limits->max_write_zeroes_sectors = 0;
+}
+
 static void clone_endio(struct bio *bio)
 {
 	int error = bio->bi_error;
@@ -851,9 +859,14 @@ static void clone_endio(struct bio *bio)
 		}
 	}
 
-	if (unlikely(r == -EREMOTEIO && (bio_op(bio) == REQ_OP_WRITE_SAME) &&
-		     !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors))
-		disable_write_same(md);
+	if (unlikely(r == -EREMOTEIO)) {
+		if (bio_op(bio) == REQ_OP_WRITE_SAME &&
+		    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
+			disable_write_same(md);
+		if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
+		    !bdev_get_queue(bio->bi_bdev)->limits.max_write_zeroes_sectors)
+			disable_write_zeroes(md);
+	}
 
 	free_tio(tio);
 	dec_pending(io, error);
@@ -1202,6 +1215,11 @@ static unsigned get_num_write_same_bios(struct dm_target *ti)
 	return ti->num_write_same_bios;
 }
 
+static unsigned get_num_write_zeroes_bios(struct dm_target *ti)
+{
+	return ti->num_write_zeroes_bios;
+}
+
 typedef bool (*is_split_required_fn)(struct dm_target *ti);
 
 static bool is_split_required_for_discard(struct dm_target *ti)
@@ -1256,6 +1274,11 @@ static int __send_write_same(struct clone_info *ci)
 	return __send_changing_extent_only(ci, get_num_write_same_bios, NULL);
 }
 
+static int __send_write_zeroes(struct clone_info *ci)
+{
+	return __send_changing_extent_only(ci, get_num_write_zeroes_bios, NULL);
+}
+
 /*
  * Select the correct strategy for processing a non-flush bio.
  */
@@ -1270,6 +1293,8 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 		return __send_discard(ci);
 	else if (unlikely(bio_op(bio) == REQ_OP_WRITE_SAME))
 		return __send_write_same(ci);
+	else if (unlikely(bio_op(bio) == REQ_OP_WRITE_ZEROES))
+		return __send_write_zeroes(ci);
 
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a7e6903866fd..3829bee2302a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -255,6 +255,12 @@ struct dm_target {
 	unsigned num_write_same_bios;
 
 	/*
+	 * The number of WRITE ZEROES bios that will be submitted to the target.
+	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
+	 */
+	unsigned num_write_zeroes_bios;
+
+	/*
 	 * The minimum number of extra bytes allocated in each io for the
 	 * target to use.
 	 */
-- 
2.11.0
