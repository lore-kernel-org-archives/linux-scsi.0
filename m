From: mchristi@redhat.com
Subject: [PATCH 31/32] block/fs/driver: rm bio bi_rw REQ_OP use
Date: Wed,  4 Nov 2015 16:08:28 -0600
Message-ID: <1446674909-5371-32-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

With this patch we no longer use the bio->bi_rw field
for REQ_WRITE, REQ_DISCARD, REQ_WRITE_SAME, (REQ_OPs). bi_rw should
only set REQ_XYZ values and bi_op is for REQ_OPs.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/bio.c                                 | 15 +++------
 block/blk-core.c                            | 10 +++---
 block/blk-lib.c                             |  9 ++---
 block/blk-map.c                             |  4 +--
 block/blk-merge.c                           | 12 +++----
 drivers/block/brd.c                         |  2 +-
 drivers/block/pktcdvd.c                     |  2 --
 drivers/block/rsxx/dma.c                    |  2 +-
 drivers/block/xen-blkfront.c                |  5 +--
 drivers/block/zram/zram_drv.c               |  2 +-
 drivers/md/bcache/journal.c                 |  6 ++--
 drivers/md/bcache/movinggc.c                |  2 +-
 drivers/md/bcache/request.c                 | 11 +++---
 drivers/md/bcache/writeback.c               |  4 +--
 drivers/md/dm-cache-target.c                | 10 +++---
 drivers/md/dm-crypt.c                       |  2 +-
 drivers/md/dm-io.c                          | 12 +++----
 drivers/md/dm-kcopyd.c                      |  2 +-
 drivers/md/dm-log-writes.c                  |  2 +-
 drivers/md/dm-raid1.c                       | 10 +++---
 drivers/md/dm-region-hash.c                 |  4 +--
 drivers/md/dm-stripe.c                      |  4 +--
 drivers/md/dm-thin.c                        | 15 +++++----
 drivers/md/dm.c                             |  6 ++--
 drivers/md/linear.c                         |  2 +-
 drivers/md/raid0.c                          |  2 +-
 drivers/md/raid1.c                          | 25 ++++++--------
 drivers/md/raid10.c                         | 34 +++++++++----------
 drivers/md/raid5.c                          | 20 ++++-------
 drivers/scsi/osd/osd_initiator.c            |  4 ---
 drivers/staging/lustre/lustre/llite/lloop.c |  8 ++---
 drivers/target/target_core_pscsi.c          |  4 +--
 fs/btrfs/volumes.c                          |  6 ++--
 fs/exofs/ore.c                              |  1 -
 include/linux/bio.h                         | 15 ++++++---
 include/linux/blk_types.h                   | 13 +++-----
 include/linux/blktrace_api.h                |  2 +-
 include/linux/fs.h                          | 29 ++++++++++------
 include/trace/events/bcache.h               | 12 ++++---
 include/trace/events/block.h                | 31 +++++++++++------
 kernel/trace/blktrace.c                     | 52 ++++++++++++++++-------------
 41 files changed, 204 insertions(+), 209 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 1cf8428..064a858 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -669,10 +669,10 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio->bi_op == REQ_OP_DISCARD)
 		goto integrity_clone;
 
-	if (bio->bi_rw & REQ_WRITE_SAME) {
+	if (bio->bi_op == REQ_OP_WRITE_SAME) {
 		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
 		goto integrity_clone;
 	}
@@ -1170,10 +1170,8 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	if (!bio)
 		goto out_bmd;
 
-	if (iter->type & WRITE) {
-		bio->bi_rw |= REQ_WRITE;
+	if (iter->type & WRITE)
 		bio->bi_op = REQ_OP_WRITE;
-	}
 
 	ret = 0;
 
@@ -1342,10 +1340,8 @@ struct bio *bio_map_user_iov(struct request_queue *q,
 	/*
 	 * set data direction, and check if mapped pages need bouncing
 	 */
-	if (iter->type & WRITE) {
-		bio->bi_rw |= REQ_WRITE;
+	if (iter->type & WRITE)
 		bio->bi_op = REQ_OP_WRITE;
-	}
 
 	bio_set_flag(bio, BIO_USER_MAPPED);
 
@@ -1538,7 +1534,6 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		bio->bi_private = data;
 	} else {
 		bio->bi_end_io = bio_copy_kern_endio;
-		bio->bi_rw |= REQ_WRITE;
 		bio->bi_op = REQ_OP_WRITE;
 	}
 
@@ -1798,7 +1793,7 @@ struct bio *bio_split(struct bio *bio, int sectors,
 	 * Discards need a mutable bio_vec to accommodate the payload
 	 * required by the DSM TRIM and UNMAP commands.
 	 */
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio->bi_op == REQ_OP_DISCARD)
 		split = bio_clone_bioset(bio, gfp, bs);
 	else
 		split = bio_clone_fast(bio, gfp, bs);
diff --git a/block/blk-core.c b/block/blk-core.c
index deb8bfd..c270a4a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1873,14 +1873,14 @@ generic_make_request_checks(struct bio *bio)
 		}
 	}
 
-	if ((bio->bi_rw & REQ_DISCARD) &&
+	if ((bio->bi_op == REQ_OP_DISCARD) &&
 	    (!blk_queue_discard(q) ||
 	     ((bio->bi_rw & REQ_SECURE) && !blk_queue_secdiscard(q)))) {
 		err = -EOPNOTSUPP;
 		goto end_io;
 	}
 
-	if (bio->bi_rw & REQ_WRITE_SAME && !bdev_write_same(bio->bi_bdev)) {
+	if (bio->bi_op == REQ_OP_WRITE_SAME && !bdev_write_same(bio->bi_bdev)) {
 		err = -EOPNOTSUPP;
 		goto end_io;
 	}
@@ -1992,7 +1992,7 @@ EXPORT_SYMBOL(generic_make_request);
  */
 void submit_bio(int op, int flags, struct bio *bio)
 {
-	bio->bi_rw |= op | flags;
+	bio->bi_rw |= flags;
 	bio->bi_op = op;
 
 	/*
@@ -2002,7 +2002,7 @@ void submit_bio(int op, int flags, struct bio *bio)
 	if (bio_has_data(bio)) {
 		unsigned int count;
 
-		if (unlikely(op == REQ_WRITE_SAME))
+		if (unlikely(op == REQ_OP_WRITE_SAME))
 			count = bdev_logical_block_size(bio->bi_bdev) >> 9;
 		else
 			count = bio_sectors(bio);
@@ -2873,8 +2873,6 @@ EXPORT_SYMBOL_GPL(__blk_end_request_err);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
 {
-	/* Bit 0 (R/W) is identical in rq->cmd_flags and bio->bi_rw */
-	rq->cmd_flags |= bio->bi_rw & REQ_WRITE;
 	rq->op = bio->bi_op;
 
 	if (bio_has_data(bio))
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 49786b0..77bba0a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -43,7 +43,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
 	int op = REQ_OP_DISCARD;
-	int op_flags = REQ_WRITE;
+	int op_flags = 0;
 	unsigned int granularity;
 	int alignment;
 	struct bio_batch bb;
@@ -189,12 +189,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		}
 
 		atomic_inc(&bb.done);
-		/*
-		 * REQ_WRITE being passed as a flag is temp until
-		 * code that assumes REQ_WRITE is set for WRITE_SAME
-		 * is converted.
-		 */
-		submit_bio(REQ_OP_WRITE_SAME, REQ_WRITE, bio);
+		submit_bio(REQ_OP_WRITE_SAME, 0, bio);
 	}
 
 	/* Wait for bios in-flight */
diff --git a/block/blk-map.c b/block/blk-map.c
index 4a91dc4..9021a8f 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -223,10 +223,8 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (!reading) {
-		bio->bi_rw |= REQ_WRITE;
+	if (!reading)
 		bio->bi_op = REQ_OP_WRITE;
-	}
 
 	if (do_copy)
 		rq->cmd_flags |= REQ_COPY_USER;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index ec42c7e..7550411 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -116,9 +116,9 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
 {
 	struct bio *split;
 
-	if ((*bio)->bi_rw & REQ_DISCARD)
+	if ((*bio)->bi_op == REQ_OP_DISCARD)
 		split = blk_bio_discard_split(q, *bio, bs);
-	else if ((*bio)->bi_rw & REQ_WRITE_SAME)
+	else if ((*bio)->bi_op == REQ_OP_WRITE_SAME)
 		split = blk_bio_write_same_split(q, *bio, bs);
 	else
 		split = blk_bio_segment_split(q, *bio, q->bio_split);
@@ -148,10 +148,10 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	 * This should probably be returning 0, but blk_add_request_payload()
 	 * (Christoph!!!!)
 	 */
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio->bi_op == REQ_OP_DISCARD)
 		return 1;
 
-	if (bio->bi_rw & REQ_WRITE_SAME)
+	if (bio->bi_op == REQ_OP_WRITE_SAME)
 		return 1;
 
 	fbio = bio;
@@ -324,7 +324,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 	nsegs = 0;
 	cluster = blk_queue_cluster(q);
 
-	if (bio->bi_rw & REQ_DISCARD) {
+	if (bio->bi_op == REQ_OP_DISCARD) {
 		/*
 		 * This is a hack - drivers should be neither modifying the
 		 * biovec, nor relying on bi_vcnt - but because of
@@ -339,7 +339,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 		return 0;
 	}
 
-	if (bio->bi_rw & REQ_WRITE_SAME) {
+	if (bio->bi_op == REQ_OP_WRITE_SAME) {
 single_segment:
 		*sg = sglist;
 		bvec = bio_iovec(bio);
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index b9794ae..657e4c5 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -336,7 +336,7 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
 	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk))
 		goto io_error;
 
-	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+	if (unlikely(bio->bi_op == REQ_OP_DISCARD)) {
 		discard_from_brd(brd, sector, bio->bi_iter.bi_size);
 		goto out;
 	}
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index bbb7a45..aeb296f 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1074,7 +1074,6 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 			BUG();
 
 		atomic_inc(&pkt->io_wait);
-		bio->bi_rw = READ;
 		bio->bi_op = REQ_OP_READ;
 		pkt_queue_bio(pd, bio);
 		frames_read++;
@@ -1337,7 +1336,6 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 	/* Start the write request */
 	atomic_set(&pkt->io_wait, 1);
-	pkt->w_bio->bi_rw = WRITE;
 	pkt->w_bio->bi_op = REQ_OP_WRITE;
 	pkt_queue_bio(pd, pkt->w_bio);
 }
diff --git a/drivers/block/rsxx/dma.c b/drivers/block/rsxx/dma.c
index cf8cd29..dfc189e 100644
--- a/drivers/block/rsxx/dma.c
+++ b/drivers/block/rsxx/dma.c
@@ -705,7 +705,7 @@ int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
 		dma_cnt[i] = 0;
 	}
 
-	if (bio->bi_rw & REQ_DISCARD) {
+	if (bio->bi_op == REQ_OP_DISCARD) {
 		bv_len = bio->bi_iter.bi_size;
 
 		while (bv_len > 0) {
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 91eccd1..09ea7cd 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1593,7 +1593,8 @@ static int blkif_recover(struct blkfront_info *info)
 				bio_trim(cloned_bio, offset, size);
 				cloned_bio->bi_private = split_bio;
 				cloned_bio->bi_end_io = split_bio_end;
-				submit_bio(cloned_bio->bi_rw, 0, cloned_bio);
+				submit_bio(cloned_bio->bi_op,
+					   cloned_bio->bi_rw, cloned_bio);
 			}
 			/*
 			 * Now we have to wait for all those smaller bios to
@@ -1602,7 +1603,7 @@ static int blkif_recover(struct blkfront_info *info)
 			continue;
 		}
 		/* We don't need to split this bio */
-		submit_bio(bio->bi_rw, 0, bio);
+		submit_bio(bio->bi_op, bio->bi_rw, bio);
 	}
 
 	return 0;
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9fa15bb..3b6b9e6 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -849,7 +849,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 	offset = (bio->bi_iter.bi_sector &
 		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
-	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+	if (unlikely(bio->bi_op == REQ_OP_DISCARD)) {
 		zram_bio_discard(zram, index, offset, bio);
 		bio_endio(bio);
 		return;
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index d152e78..5dc383b8 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -55,7 +55,7 @@ reread:		left = ca->sb.bucket_size - offset;
 		bio->bi_iter.bi_sector	= bucket + offset;
 		bio->bi_bdev	= ca->bdev;
 		bio->bi_op	= REQ_OP_READ;
-		bio->bi_rw	= READ;
+		bio->bi_rw	= 0;
 		bio->bi_iter.bi_size	= len << 9;
 
 		bio->bi_end_io	= journal_read_endio;
@@ -454,7 +454,7 @@ static void do_journal_discard(struct cache *ca)
 						ca->sb.d[ja->discard_idx]);
 		bio->bi_bdev		= ca->bdev;
 		bio->bi_op		= REQ_OP_DISCARD;
-		bio->bi_rw		= REQ_WRITE|REQ_DISCARD;
+		bio->bi_rw		= 0;
 		bio->bi_max_vecs	= 1;
 		bio->bi_io_vec		= bio->bi_inline_vecs;
 		bio->bi_iter.bi_size	= bucket_bytes(ca);
@@ -629,7 +629,7 @@ static void journal_write_unlocked(struct closure *cl)
 		bio->bi_iter.bi_sector	= PTR_OFFSET(k, i);
 		bio->bi_bdev	= ca->bdev;
 		bio->bi_op	= REQ_OP_WRITE;
-		bio->bi_rw	= REQ_WRITE|REQ_SYNC|REQ_META|REQ_FLUSH|REQ_FUA;
+		bio->bi_rw	= REQ_SYNC|REQ_META|REQ_FLUSH|REQ_FUA;
 		bio->bi_iter.bi_size = sectors << 9;
 
 		bio->bi_end_io	= journal_write_endio;
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 1318f32..78745ff 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -164,7 +164,7 @@ static void read_moving(struct cache_set *c)
 		bio = &io->bio.bio;
 
 		bio->bi_op	= REQ_OP_READ;
-		bio->bi_rw	= READ;
+		bio->bi_rw	= 0;
 		bio->bi_end_io	= read_moving_endio;
 
 		if (bio_alloc_pages(bio, GFP_KERNEL))
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 11f6b5c..0a35d7e 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -254,7 +254,6 @@ static void bch_data_insert_start(struct closure *cl)
 		bch_keylist_push(&op->insert_keys);
 
 		n->bi_op = REQ_OP_WRITE;
-		n->bi_rw |= REQ_WRITE;
 		bch_submit_bbio(n, op->c, k, 0);
 	} while (n != bio);
 
@@ -379,7 +378,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 
 	if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
 	    c->gc_stats.in_use > CUTOFF_CACHE_ADD ||
-	    (bio->bi_rw & REQ_DISCARD))
+	    (bio->bi_op == REQ_OP_DISCARD))
 		goto skip;
 
 	if (mode == CACHE_MODE_NONE ||
@@ -900,7 +899,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 	 * But check_overlapping drops dirty keys for which io hasn't started,
 	 * so we still want to call it.
 	 */
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio->bi_op == REQ_OP_DISCARD)
 		s->iop.bypass = true;
 
 	if (should_writeback(dc, s->orig_bio,
@@ -914,7 +913,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 		s->iop.bio = s->orig_bio;
 		bio_get(s->iop.bio);
 
-		if (!(bio->bi_rw & REQ_DISCARD) ||
+		if (!(bio->bi_op == REQ_OP_DISCARD) ||
 		    blk_queue_discard(bdev_get_queue(dc->bdev)))
 			closure_bio_submit(bio, cl);
 	} else if (s->iop.writeback) {
@@ -993,7 +992,7 @@ static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
 				cached_dev_read(dc, s);
 		}
 	} else {
-		if ((bio->bi_rw & REQ_DISCARD) &&
+		if ((bio->bi_op == REQ_OP_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(dc->bdev)))
 			bio_endio(bio);
 		else
@@ -1101,7 +1100,7 @@ static void flash_dev_make_request(struct request_queue *q, struct bio *bio)
 					&KEY(d->id, bio->bi_iter.bi_sector, 0),
 					&KEY(d->id, bio_end_sector(bio), 0));
 
-		s->iop.bypass		= (bio->bi_rw & REQ_DISCARD) != 0;
+		s->iop.bypass		= (bio->bi_op == REQ_OP_DISCARD) != 0;
 		s->iop.writeback	= true;
 		s->iop.bio		= bio;
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 28b1bae..f23d609 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -184,7 +184,7 @@ static void write_dirty(struct closure *cl)
 
 	dirty_init(w);
 	io->bio.bi_op		= REQ_OP_WRITE;
-	io->bio.bi_rw		= WRITE;
+	io->bio.bi_rw		= 0;
 	io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 	io->bio.bi_bdev		= io->dc->bdev;
 	io->bio.bi_end_io	= dirty_endio;
@@ -258,7 +258,7 @@ static void read_dirty(struct cached_dev *dc)
 		io->bio.bi_bdev		= PTR_CACHE(dc->disk.c,
 						    &w->key, 0)->bdev;
 		io->bio.bi_op		= REQ_OP_READ;
-		io->bio.bi_rw		= READ;
+		io->bio.bi_rw		= 0;
 		io->bio.bi_end_io	= read_dirty_endio;
 
 		if (bio_alloc_pages(&io->bio, GFP_KERNEL))
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index dd90d12..1a13434 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -791,7 +791,8 @@ static void check_if_tick_bio_needed(struct cache *cache, struct bio *bio)
 
 	spin_lock_irqsave(&cache->lock, flags);
 	if (cache->need_tick_bio &&
-	    !(bio->bi_rw & (REQ_FUA | REQ_FLUSH | REQ_DISCARD))) {
+	    !(bio->bi_rw & (REQ_FUA | REQ_FLUSH) &&
+	    bio->bi_op != REQ_OP_DISCARD)) {
 		pb->tick = true;
 		cache->need_tick_bio = false;
 	}
@@ -854,7 +855,7 @@ static void inc_ds(struct cache *cache, struct bio *bio,
 static bool accountable_bio(struct cache *cache, struct bio *bio)
 {
 	return ((bio->bi_bdev == cache->origin_dev->bdev) &&
-		!(bio->bi_rw & REQ_DISCARD));
+		(bio->bi_op != REQ_OP_DISCARD));
 }
 
 static void accounted_begin(struct cache *cache, struct bio *bio)
@@ -1065,7 +1066,8 @@ static void dec_io_migrations(struct cache *cache)
 
 static bool discard_or_flush(struct bio *bio)
 {
-	return bio->bi_rw & (REQ_FLUSH | REQ_FUA | REQ_DISCARD);
+	return bio->bi_rw & (REQ_FLUSH | REQ_FUA) ||
+	       bio->bi_op == REQ_OP_DISCARD;
 }
 
 static void __cell_defer(struct cache *cache, struct dm_bio_prison_cell *cell)
@@ -1978,7 +1980,7 @@ static void process_deferred_bios(struct cache *cache)
 
 		if (bio->bi_rw & REQ_FLUSH)
 			process_flush_bio(cache, bio);
-		else if (bio->bi_rw & REQ_DISCARD)
+		else if (bio->bi_op == REQ_OP_DISCARD)
 			process_discard_bio(cache, &structs, bio);
 		else
 			process_bio(cache, &structs, bio);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 92689e5..404c7005 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1911,7 +1911,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	 * - for REQ_FLUSH device-mapper core ensures that no IO is in-flight
 	 * - for REQ_DISCARD caller must use flush if IO ordering matters
 	 */
-	if (unlikely(bio->bi_rw & (REQ_FLUSH | REQ_DISCARD))) {
+	if (unlikely(bio->bi_rw & REQ_FLUSH || bio->bi_op == REQ_OP_DISCARD)) {
 		bio->bi_bdev = cc->dev->bdev;
 		if (bio_sectors(bio))
 			bio->bi_iter.bi_sector = cc->start +
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index f389380..6b514cd 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -297,11 +297,11 @@ static void do_region(int op, int op_flags, unsigned region,
 	/*
 	 * Reject unsupported discard and write same requests.
 	 */
-	if (op == REQ_DISCARD)
+	if (op == REQ_OP_DISCARD)
 		special_cmd_max_sectors = q->limits.max_discard_sectors;
-	else if (op == REQ_WRITE_SAME)
+	else if (op == REQ_OP_WRITE_SAME)
 		special_cmd_max_sectors = q->limits.max_write_same_sectors;
-	if ((op == REQ_DISCARD || op == REQ_WRITE_SAME) &&
+	if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_SAME) &&
 	    special_cmd_max_sectors == 0) {
 		dec_count(io, region, -EOPNOTSUPP);
 		return;
@@ -315,7 +315,7 @@ static void do_region(int op, int op_flags, unsigned region,
 		/*
 		 * Allocate a suitably sized-bio.
 		 */
-		if ((op == REQ_DISCARD) || (op == REQ_WRITE_SAME))
+		if ((op == REQ_OP_DISCARD) || (op == REQ_OP_WRITE_SAME))
 			num_bvecs = 1;
 		else
 			num_bvecs = min_t(int, BIO_MAX_PAGES,
@@ -327,11 +327,11 @@ static void do_region(int op, int op_flags, unsigned region,
 		bio->bi_end_io = endio;
 		store_io_and_region_in_bio(bio, io, region);
 
-		if (op == REQ_DISCARD) {
+		if (op == REQ_OP_DISCARD) {
 			num_sectors = min_t(sector_t, special_cmd_max_sectors, remaining);
 			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 			remaining -= num_sectors;
-		} else if (op == REQ_WRITE_SAME) {
+		} else if (op == REQ_OP_WRITE_SAME) {
 			/*
 			 * WRITE SAME only uses a single page.
 			 */
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 02dccbe..9612bff 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -735,7 +735,7 @@ int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		/*
 		 * Use WRITE SAME to optimize zeroing if all dests support it.
 		 */
-		job->rw = WRITE | REQ_WRITE_SAME;
+		job->rw = REQ_OP_WRITE_SAME;
 		for (i = 0; i < job->num_dests; i++)
 			if (!bdev_write_same(job->dests[i].bdev)) {
 				job->rw = WRITE;
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 7bfaa91..6820654 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -554,7 +554,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	int i = 0;
 	bool flush_bio = (bio->bi_rw & REQ_FLUSH);
 	bool fua_bio = (bio->bi_rw & REQ_FUA);
-	bool discard_bio = (bio->bi_rw & REQ_DISCARD);
+	bool discard_bio = (bio->bi_op == REQ_OP_DISCARD);
 
 	pb->block = NULL;
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ec48487..48da798 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -626,7 +626,7 @@ static void write_callback(unsigned long error, void *context)
 	 * If the bio is discard, return an error, but do not
 	 * degrade the array.
 	 */
-	if (bio->bi_rw & REQ_DISCARD) {
+	if (bio->bi_op == REQ_OP_DISCARD) {
 		bio->bi_error = -EOPNOTSUPP;
 		bio_endio(bio);
 		return;
@@ -665,8 +665,8 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 		.client = ms->io_client,
 	};
 
-	if (bio->bi_rw & REQ_DISCARD) {
-		io_req.bi_op_flags |= REQ_DISCARD;
+	if (bio->bi_op == REQ_OP_DISCARD) {
+		io_req.bi_op = REQ_OP_DISCARD;
 		io_req.mem.type = DM_IO_KMEM;
 		io_req.mem.ptr.addr = NULL;
 	}
@@ -705,7 +705,7 @@ static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 
 	while ((bio = bio_list_pop(writes))) {
 		if ((bio->bi_rw & REQ_FLUSH) ||
-		    (bio->bi_rw & REQ_DISCARD)) {
+		    (bio->bi_op == REQ_OP_DISCARD)) {
 			bio_list_add(&sync, bio);
 			continue;
 		}
@@ -1253,7 +1253,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
 	 * We need to dec pending if this was a write.
 	 */
 	if (rw == WRITE) {
-		if (!(bio->bi_rw & (REQ_FLUSH | REQ_DISCARD)))
+		if (!(bio->bi_rw & REQ_FLUSH || bio->bi_op == REQ_OP_DISCARD))
 			dm_rh_dec(ms->rh, bio_record->write_region);
 		return error;
 	}
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index b929fd5..adde887 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -405,7 +405,7 @@ void dm_rh_mark_nosync(struct dm_region_hash *rh, struct bio *bio)
 		return;
 	}
 
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio->bi_op == REQ_OP_DISCARD)
 		return;
 
 	/* We must inform the log that the sync count has changed. */
@@ -528,7 +528,7 @@ void dm_rh_inc_pending(struct dm_region_hash *rh, struct bio_list *bios)
 	struct bio *bio;
 
 	for (bio = bios->head; bio; bio = bio->bi_next) {
-		if (bio->bi_rw & (REQ_FLUSH | REQ_DISCARD))
+		if (bio->bi_rw & REQ_FLUSH || bio->bi_op == REQ_OP_DISCARD)
 			continue;
 		rh_inc(rh, dm_rh_bio_to_region(rh, bio));
 	}
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 797ddb9..12b1630 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -292,8 +292,8 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 		bio->bi_bdev = sc->stripe[target_bio_nr].dev->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
-	if (unlikely(bio->bi_rw & REQ_DISCARD) ||
-	    unlikely(bio->bi_rw & REQ_WRITE_SAME)) {
+	if (unlikely(bio->bi_op == REQ_OP_DISCARD) ||
+	    unlikely(bio->bi_op == REQ_OP_WRITE_SAME)) {
 		target_bio_nr = dm_bio_get_target_bio_nr(bio);
 		BUG_ON(target_bio_nr >= sc->stripes);
 		return stripe_map_range(sc, bio, target_bio_nr);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 63a713d..caab74c 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -703,7 +703,7 @@ static void inc_all_io_entry(struct pool *pool, struct bio *bio)
 {
 	struct dm_thin_endio_hook *h;
 
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio->bi_op == REQ_OP_DISCARD)
 		return;
 
 	h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
@@ -866,7 +866,8 @@ static void __inc_remap_and_issue_cell(void *context,
 	struct bio *bio;
 
 	while ((bio = bio_list_pop(&cell->bios))) {
-		if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA))
+		if (bio->bi_rw & (REQ_FLUSH | REQ_FUA) ||
+		    bio->bi_op == REQ_OP_DISCARD)
 			bio_list_add(&info->defer_bios, bio);
 		else {
 			inc_all_io_entry(info->tc->pool, bio);
@@ -1644,7 +1645,8 @@ static void __remap_and_issue_shared_cell(void *context,
 
 	while ((bio = bio_list_pop(&cell->bios))) {
 		if ((bio_data_dir(bio) == WRITE) ||
-		    (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA)))
+		    (bio->bi_rw & (REQ_FLUSH | REQ_FUA) ||
+		     bio->bi_op == REQ_OP_DISCARD))
 			bio_list_add(&info->defer_bios, bio);
 		else {
 			struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));;
@@ -2033,7 +2035,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			break;
 		}
 
-		if (bio->bi_rw & REQ_DISCARD)
+		if (bio->bi_op == REQ_OP_DISCARD)
 			pool->process_discard(tc, bio);
 		else
 			pool->process_bio(tc, bio);
@@ -2120,7 +2122,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 				return;
 			}
 
-			if (cell->holder->bi_rw & REQ_DISCARD)
+			if (cell->holder->bi_op == REQ_OP_DISCARD)
 				pool->process_discard_cell(tc, cell);
 			else
 				pool->process_cell(tc, cell);
@@ -2555,7 +2557,8 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
-	if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA)) {
+	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA) ||
+	    bio->bi_op == REQ_OP_DISCARD) {
 		thin_defer_bio_with_throttle(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e03ca09..6b36aad 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -983,7 +983,7 @@ static void clone_endio(struct bio *bio)
 		}
 	}
 
-	if (unlikely(r == -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &&
+	if (unlikely(r == -EREMOTEIO && (bio->bi_op == REQ_OP_WRITE_SAME) &&
 		     !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors))
 		disable_write_same(md);
 
@@ -1657,9 +1657,9 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 	struct dm_target *ti;
 	unsigned len;
 
-	if (unlikely(bio->bi_rw & REQ_DISCARD))
+	if (unlikely(bio->bi_op == REQ_OP_DISCARD))
 		return __send_discard(ci);
-	else if (unlikely(bio->bi_rw & REQ_WRITE_SAME))
+	else if (unlikely(bio->bi_op == REQ_OP_WRITE_SAME))
 		return __send_write_same(ci);
 
 	ti = dm_table_find_target(ci->map, ci->sector);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index b7fe7e9..aad82c7 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -252,7 +252,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 		split->bi_iter.bi_sector = split->bi_iter.bi_sector -
 			start_sector + data_offset;
 
-		if (unlikely((split->bi_rw & REQ_DISCARD) &&
+		if (unlikely((split->bi_op == REQ_OP_DISCARD) &&
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
 			bio_endio(split);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f8e5db0..f38be1f 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -488,7 +488,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 		split->bi_iter.bi_sector = sector + zone->dev_start +
 			tmp_dev->data_offset;
 
-		if (unlikely((split->bi_rw & REQ_DISCARD) &&
+		if (unlikely((split->bi_op == REQ_OP_DISCARD) &&
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
 			bio_endio(split);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 94e5a63..32e6bf5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -757,7 +757,7 @@ static void flush_pending_writes(struct r1conf *conf)
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
 			bio->bi_next = NULL;
-			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+			if (unlikely((bio->bi_op == REQ_OP_DISCARD) &&
 			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
 				bio_endio(bio);
@@ -1031,7 +1031,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
-		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		if (unlikely((bio->bi_op == REQ_OP_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
 			bio_endio(bio);
@@ -1055,9 +1055,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
-	const unsigned long do_discard = (bio->bi_rw
-					  & (REQ_DISCARD | REQ_SECURE));
-	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
+	const unsigned long do_secure = (bio->bi_rw & REQ_SECURE);
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
@@ -1166,7 +1164,7 @@ read_again:
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
 		read_bio->bi_op = REQ_OP_READ;
-		read_bio->bi_rw = READ | do_sync;
+		read_bio->bi_rw = do_sync;
 		read_bio->bi_private = r1_bio;
 
 		if (max_sectors < r1_bio->sectors) {
@@ -1377,8 +1375,7 @@ read_again:
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
 		mbio->bi_op = op;
-		mbio->bi_rw =
-			WRITE | do_flush_fua | do_sync | do_discard | do_same;
+		mbio->bi_rw = do_flush_fua | do_sync | do_secure;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
@@ -2021,7 +2018,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 			continue;
 
 		wbio->bi_op = REQ_OP_WRITE;
-		wbio->bi_rw = WRITE;
+		wbio->bi_rw = 0;
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
 		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));
@@ -2193,7 +2190,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		}
 
 		wbio->bi_op = REQ_OP_WRITE;
-		wbio->bi_rw = WRITE;
+		wbio->bi_rw = 0;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
@@ -2335,7 +2332,7 @@ read_more:
 		bio->bi_bdev = rdev->bdev;
 		bio->bi_end_io = raid1_end_read_request;
 		bio->bi_op  = REQ_OP_READ;
-		bio->bi_rw = READ | do_sync;
+		bio->bi_rw = do_sync;
 		bio->bi_private = r1_bio;
 		if (max_sectors < r1_bio->sectors) {
 			/* Drat - have to split this up more */
@@ -2551,7 +2548,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 				still_degraded = 1;
 		} else if (!test_bit(In_sync, &rdev->flags)) {
 			bio->bi_op = REQ_OP_WRITE;
-			bio->bi_rw = WRITE;
+			bio->bi_rw = 0;
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
 		} else {
@@ -2579,7 +2576,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 						disk = i;
 				}
 				bio->bi_op = REQ_OP_READ;
-				bio->bi_rw = READ;
+				bio->bi_rw = 0;
 				bio->bi_end_io = end_sync_read;
 				read_targets++;
 			} else if (!test_bit(WriteErrorSeen, &rdev->flags) &&
@@ -2592,7 +2589,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 				 * this device alone for this sync request.
 				 */
 				bio->bi_op = REQ_OP_WRITE;
-				bio->bi_rw = WRITE;
+				bio->bi_rw = 0;
 				bio->bi_end_io = end_sync_write;
 				write_targets++;
 			}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c7430f9..5d5b9b6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -865,7 +865,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
 			bio->bi_next = NULL;
-			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+			if (unlikely((bio->bi_op == REQ_OP_DISCARD) &&
 			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
 				bio_endio(bio);
@@ -1041,7 +1041,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
-		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		if (unlikely((bio->bi_op == REQ_OP_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
 			bio_endio(bio);
@@ -1062,9 +1062,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
-	const unsigned long do_discard = (bio->bi_rw
-					  & (REQ_DISCARD | REQ_SECURE));
-	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
+	const unsigned long do_secure = (bio->bi_rw & REQ_SECURE);
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
@@ -1158,7 +1156,7 @@ read_again:
 		read_bio->bi_bdev = rdev->bdev;
 		read_bio->bi_end_io = raid10_end_read_request;
 		read_bio->bi_op = REQ_OP_READ;
-		read_bio->bi_rw = READ | do_sync;
+		read_bio->bi_rw = do_sync;
 		read_bio->bi_private = r10_bio;
 
 		if (max_sectors < r10_bio->sectors) {
@@ -1366,8 +1364,7 @@ retry_write:
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			mbio->bi_op = op;
-			mbio->bi_rw =
-				WRITE | do_sync | do_fua | do_discard | do_same;
+			mbio->bi_rw = do_sync | do_fua | do_secure;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1410,8 +1407,7 @@ retry_write:
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			mbio->bi_op = op;
-			mbio->bi_rw =
-				WRITE | do_sync | do_fua | do_discard | do_same;
+			mbio->bi_rw = do_sync | do_fua | do_secure;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1993,7 +1989,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_iter.bi_size = r10_bio->sectors << 9;
 		tbio->bi_op = REQ_OP_WRITE;
-		tbio->bi_rw = WRITE;
+		tbio->bi_rw = 0;
 		tbio->bi_private = r10_bio;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
 		tbio->bi_end_io = end_sync_write;
@@ -2550,7 +2546,7 @@ read_more:
 		+ choose_data_offset(r10_bio, rdev);
 	bio->bi_bdev = rdev->bdev;
 	bio->bi_op = REQ_OP_READ;
-	bio->bi_rw = READ | do_sync;
+	bio->bi_rw = do_sync;
 	bio->bi_private = r10_bio;
 	bio->bi_end_io = raid10_end_read_request;
 	if (max_sectors < r10_bio->sectors) {
@@ -3038,7 +3034,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_read;
 				bio->bi_op = REQ_OP_READ;
-				bio->bi_rw = READ;
+				bio->bi_rw = 0;
 				from_addr = r10_bio->devs[j].addr;
 				bio->bi_iter.bi_sector = from_addr +
 					rdev->data_offset;
@@ -3065,7 +3061,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 					bio->bi_private = r10_bio;
 					bio->bi_end_io = end_sync_write;
 					bio->bi_op = REQ_OP_WRITE;
-					bio->bi_rw = WRITE;
+					bio->bi_rw = 0;
 					bio->bi_iter.bi_sector = to_addr
 						+ rdev->data_offset;
 					bio->bi_bdev = rdev->bdev;
@@ -3095,7 +3091,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_write;
 				bio->bi_op = REQ_OP_WRITE;
-				bio->bi_rw = WRITE;
+				bio->bi_rw = 0;
 				bio->bi_iter.bi_sector = to_addr +
 					rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
@@ -3216,7 +3212,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_read;
 			bio->bi_op = REQ_OP_READ;
-			bio->bi_rw = READ;
+			bio->bi_rw = 0;
 			bio->bi_iter.bi_sector = sector +
 				conf->mirrors[d].rdev->data_offset;
 			bio->bi_bdev = conf->mirrors[d].rdev->bdev;
@@ -3239,7 +3235,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_write;
 			bio->bi_op = REQ_OP_WRITE;
-			bio->bi_rw = WRITE;
+			bio->bi_rw = 0;
 			bio->bi_iter.bi_sector = sector +
 				conf->mirrors[d].replacement->data_offset;
 			bio->bi_bdev = conf->mirrors[d].replacement->bdev;
@@ -4323,7 +4319,7 @@ read_more:
 	read_bio->bi_private = r10_bio;
 	read_bio->bi_end_io = end_sync_read;
 	read_bio->bi_op = REQ_OP_READ;
-	read_bio->bi_rw = READ;
+	read_bio->bi_rw = 0;
 	read_bio->bi_flags &= (~0UL << BIO_RESET_BITS);
 	read_bio->bi_error = 0;
 	read_bio->bi_vcnt = 0;
@@ -4358,7 +4354,7 @@ read_more:
 		b->bi_private = r10_bio;
 		b->bi_end_io = end_reshape_write;
 		b->bi_op = REQ_OP_WRITE;
-		b->bi_rw = WRITE;
+		b->bi_rw = 0;
 		b->bi_next = blist;
 		blist = b;
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7480155..9b084b2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -813,7 +813,8 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 	dd_idx = 0;
 	while (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
 		dd_idx++;
-	if (head->dev[dd_idx].towrite->bi_rw != sh->dev[dd_idx].towrite->bi_rw)
+	if (head->dev[dd_idx].towrite->bi_rw != sh->dev[dd_idx].towrite->bi_rw &&
+	    head->dev[dd_idx].towrite->bi_op != sh->dev[dd_idx].towrite->bi_op)
 		goto unlock_out;
 
 	if (head->batch_head) {
@@ -910,15 +911,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			} else {
 				op = REQ_OP_WRITE;
 			}
-			if (test_bit(R5_Discard, &sh->dev[i].flags)) {
+			if (test_bit(R5_Discard, &sh->dev[i].flags))
 				op = REQ_OP_DISCARD;
-				/*
-				 * this temporary for compat because drivers
-				 * expected this to be set for discards. It
-				 * will be removed in the next patches.
-				 */
-				op_flags |= REQ_WRITE;
-			}
 		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
 			op = REQ_OP_READ;
 		else if (test_and_clear_bit(R5_WantReplace,
@@ -1011,7 +1005,7 @@ again:
 			bio_reset(bi);
 			bi->bi_bdev = rdev->bdev;
 			bi->bi_op = op;
-			bi->bi_rw = op | op_flags;
+			bi->bi_rw = op_flags;
 			bi->bi_end_io = (op_to_data_dir(op) == WRITE)
 				? raid5_end_write_request
 				: raid5_end_read_request;
@@ -1064,7 +1058,7 @@ again:
 			bio_reset(rbi);
 			rbi->bi_bdev = rrdev->bdev;
 			rbi->bi_op = op;
-			rbi->bi_rw = op | op_flags;
+			rbi->bi_rw = op_flags;
 			BUG_ON(!(op_to_data_dir(op)));
 			rbi->bi_end_io = raid5_end_write_request;
 			rbi->bi_private = sh;
@@ -1640,7 +1634,7 @@ again:
 					set_bit(R5_WantFUA, &dev->flags);
 				if (wbi->bi_rw & REQ_SYNC)
 					set_bit(R5_SyncIO, &dev->flags);
-				if (wbi->bi_rw & REQ_DISCARD)
+				if (wbi->bi_op == REQ_OP_DISCARD)
 					set_bit(R5_Discard, &dev->flags);
 				else {
 					tx = async_copy_data(1, wbi, &dev->page,
@@ -5164,7 +5158,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 			return;
 	}
 
-	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
+	if (unlikely(bi->bi_op == REQ_OP_DISCARD)) {
 		make_discard_request(mddev, bi);
 		return;
 	}
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 650ba1c..b55be71 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -730,7 +730,6 @@ static int _osd_req_list_objects(struct osd_request *or,
 	}
 
 	bio->bi_op = REQ_OP_READ;
-	bio->bi_rw &= ~REQ_WRITE;
 	or->in.bio = bio;
 	or->in.total_bytes = bio->bi_iter.bi_size;
 	return 0;
@@ -844,7 +843,6 @@ int osd_req_write_kern(struct osd_request *or,
 		return PTR_ERR(bio);
 
 	bio->bi_op = REQ_OP_WRITE;
-	bio->bi_rw |= REQ_WRITE; /* FIXME: bio_set_dir() */
 	osd_req_write(or, obj, offset, bio, len);
 	return 0;
 }
@@ -962,7 +960,6 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
 		return PTR_ERR(bio);
 
 	bio->bi_op = REQ_OP_WRITE;
-	bio->bi_rw |= REQ_WRITE;
 
 	/* integrity check the continuation before the bio is linked
 	 * with the other data segments since the continuation
@@ -1084,7 +1081,6 @@ int osd_req_write_sg_kern(struct osd_request *or,
 		return PTR_ERR(bio);
 
 	bio->bi_op = REQ_OP_WRITE;
-	bio->bi_rw |= REQ_WRITE;
 	osd_req_write_sg(or, obj, bio, sglist, numentries);
 
 	return 0;
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 5f0d80c..9531cd8 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -212,9 +212,9 @@ static int do_bio_lustrebacked(struct lloop_device *lo, struct bio *head)
 	io->ci_lockreq = CILR_NEVER;
 
 	LASSERT(head != NULL);
-	rw = head->bi_rw;
+	rw = bio_data_dir(head);
 	for (bio = head; bio != NULL; bio = bio->bi_next) {
-		LASSERT(rw == bio->bi_rw);
+		LASSERT(rw == bio_data_dir(bio));
 
 		offset = (pgoff_t)(bio->bi_iter.bi_sector << 9) + lo->lo_offset;
 		bio_for_each_segment(bvec, bio, iter) {
@@ -305,9 +305,9 @@ static unsigned int loop_get_bio(struct lloop_device *lo, struct bio **req)
 	/* TODO: need to split the bio, too bad. */
 	LASSERT(first->bi_vcnt <= LLOOP_MAX_SEGMENTS);
 
-	rw = first->bi_rw;
+	rw = bio_data_dir(first);
 	bio = &lo->lo_bio;
-	while (*bio && (*bio)->bi_rw == rw) {
+	while (*bio && bio_data_dir(*bio) == rw) {
 		CDEBUG(D_INFO, "bio sector %llu size %u count %u vcnt%u \n",
 		       (unsigned long long)(*bio)->bi_iter.bi_sector,
 		       (*bio)->bi_iter.bi_size,
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 00a7bda5..2cf915c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -921,10 +921,8 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 				if (!bio)
 					goto fail;
 
-				if (rw) {
+				if (rw)
 					bio->bi_op = REQ_OP_WRITE;
-					bio->bi_rw |= REQ_WRITE;
-				}
 
 				pr_debug("PSCSI: Allocated bio: %p,"
 					" dir: %s nr_vecs: %d\n", bio,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ef67c2f..06c7c1d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -367,7 +367,7 @@ loop_lock:
 			sync_pending = 0;
 		}
 
-		btrfsic_submit_bio(cur->bi_rw, 0, cur);
+		btrfsic_submit_bio(cur->bi_op, cur->bi_rw, cur);
 		num_run++;
 		batch_run++;
 
@@ -5766,7 +5766,7 @@ static void btrfs_end_bio(struct bio *bio)
 			BUG_ON(stripe_index >= bbio->num_stripes);
 			dev = bbio->stripes[stripe_index].dev;
 			if (dev->bdev) {
-				if (bio->bi_rw & WRITE)
+				if (bio_data_dir(bio) == WRITE)
 					btrfs_dev_stat_inc(dev,
 						BTRFS_DEV_STAT_WRITE_ERRS);
 				else
@@ -5848,7 +5848,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	WARN_ON(bio->bi_next);
 	bio->bi_next = NULL;
 	bio->bi_op = op;
-	bio->bi_rw |= op | op_flags;
+	bio->bi_rw |= op_flags;
 
 	spin_lock(&device->io_lock);
 	if (bio->bi_rw & REQ_SYNC)
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 7339bef..c40ed74 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -879,7 +879,6 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 				bio = master_dev->bio;
 				/* FIXME: bio_set_dir() */
 				bio->bi_op = REQ_OP_WRITE;
-				bio->bi_rw |= REQ_WRITE;
 			}
 
 			osd_req_write(or, _ios_obj(ios, cur_comp),
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7796e0b..7cbad7a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -106,18 +106,23 @@ static inline bool bio_has_data(struct bio *bio)
 {
 	if (bio &&
 	    bio->bi_iter.bi_size &&
-	    !(bio->bi_rw & REQ_DISCARD))
+	    !(bio->bi_op == REQ_OP_DISCARD))
 		return true;
 
 	return false;
 }
 
+static inline bool bio_no_advance_iter(struct bio *bio)
+{
+	return bio->bi_op == REQ_OP_DISCARD || bio->bi_op == REQ_OP_WRITE_SAME;
+}
+
 static inline bool bio_is_rw(struct bio *bio)
 {
 	if (!bio_has_data(bio))
 		return false;
 
-	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
+	if (bio_no_advance_iter(bio))
 		return false;
 
 	return true;
@@ -225,7 +230,7 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
+	if (bio_no_advance_iter(bio))
 		iter->bi_size -= bytes;
 	else
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
@@ -253,10 +258,10 @@ static inline unsigned bio_segments(struct bio *bio)
 	 * differently:
 	 */
 
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio->bi_op == REQ_OP_DISCARD)
 		return 1;
 
-	if (bio->bi_rw & REQ_WRITE_SAME)
+	if (bio->bi_op == REQ_OP_WRITE_SAME)
 		return 1;
 
 	bio_for_each_segment(bv, bio, iter)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index b974aea..581d353 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -213,13 +213,10 @@ enum rq_flag_bits {
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
-	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
-	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
-	 REQ_SECURE | REQ_INTEGRITY)
+	(REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | REQ_NOIDLE | \
+	 REQ_FLUSH | REQ_FUA | REQ_SECURE | REQ_INTEGRITY)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
-#define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
-
 /* This mask is used for both bio and request merge checking */
 #define REQ_NOMERGE_FLAGS \
 	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_FLUSH_SEQ)
@@ -252,9 +249,9 @@ enum rq_flag_bits {
 
 enum req_op {
 	REQ_OP_READ,
-	REQ_OP_WRITE		= REQ_WRITE,
-	REQ_OP_DISCARD		= REQ_DISCARD,
-	REQ_OP_WRITE_SAME	= REQ_WRITE_SAME,
+	REQ_OP_WRITE,
+	REQ_OP_DISCARD,
+	REQ_OP_WRITE_SAME,
 };
 
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index afc1343..ee25ba4 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -109,7 +109,7 @@ static inline int blk_cmd_buf_len(struct request *rq)
 }
 
 extern void blk_dump_cmd(char *buf, struct request *rq);
-extern void blk_fill_rwbs(char *rwbs, u32 rw, int bytes);
+extern void blk_fill_rwbs(char *rwbs, int op, u32 rw, int bytes);
 
 #endif /* CONFIG_EVENT_TRACING && CONFIG_BLOCK */
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 66dd4b91..91f645e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -191,19 +191,19 @@ typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
  *			non-volatile media on completion.
  *
  */
-#define RW_MASK			REQ_WRITE
+#define RW_MASK			REQ_OP_WRITE
 #define RWA_MASK		REQ_RAHEAD
 
 #define READ			0
 #define WRITE			RW_MASK
 #define READA			RWA_MASK
 
-#define READ_SYNC		(READ | REQ_SYNC)
-#define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
-#define WRITE_ODIRECT		(WRITE | REQ_SYNC)
-#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
-#define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
-#define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+#define READ_SYNC		REQ_SYNC
+#define WRITE_SYNC		(REQ_SYNC | REQ_NOIDLE)
+#define WRITE_ODIRECT		REQ_SYNC
+#define WRITE_FLUSH		(REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
+#define WRITE_FUA		(REQ_SYNC | REQ_NOIDLE | REQ_FUA)
+#define WRITE_FLUSH_FUA		(REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
 
 /*
  * Attribute flags.  These should be or-ed together to figure out what
@@ -2389,16 +2389,23 @@ extern void make_bad_inode(struct inode *);
 extern int is_bad_inode(struct inode *);
 
 #ifdef CONFIG_BLOCK
-/*
- * return READ, READA, or WRITE
- */
-#define bio_rw(bio)		((bio)->bi_rw & (RW_MASK | RWA_MASK))
 
 /*
  * return data direction, READ or WRITE
  */
 #define bio_data_dir(bio)	((bio)->bi_op == REQ_OP_READ ? READ : WRITE)
 
+/*
+ * return READ, READA, or WRITE
+ */
+static inline int bio_rw(struct bio *bio)
+{
+	if (bio->bi_rw & RWA_MASK)
+		return READA;
+
+	return bio_data_dir(bio);
+}
+
 extern void check_disk_size_change(struct gendisk *disk,
 				   struct block_device *bdev);
 extern int revalidate_disk(struct gendisk *);
diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
index 981acf7..8abe564 100644
--- a/include/trace/events/bcache.h
+++ b/include/trace/events/bcache.h
@@ -27,7 +27,8 @@ DECLARE_EVENT_CLASS(bcache_request,
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->orig_sector	= bio->bi_iter.bi_sector - 16;
 		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 	),
 
 	TP_printk("%d,%d %s %llu + %u (from %d,%d @ %llu)",
@@ -101,7 +102,8 @@ DECLARE_EVENT_CLASS(bcache_bio,
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 	),
 
 	TP_printk("%d,%d  %s %llu + %u",
@@ -136,7 +138,8 @@ TRACE_EVENT(bcache_read,
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 		__entry->cache_hit = hit;
 		__entry->bypass = bypass;
 	),
@@ -167,7 +170,8 @@ TRACE_EVENT(bcache_write,
 		__entry->inode		= inode;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 		__entry->writeback = writeback;
 		__entry->bypass = bypass;
 	),
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index e8a5eca..4416dcd 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -84,7 +84,8 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
 					0 : blk_rq_sectors(rq);
 		__entry->errors    = rq->errors;
 
-		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
+		blk_fill_rwbs(__entry->rwbs, rq->op, rq->cmd_flags,
+			      blk_rq_bytes(rq));
 		blk_dump_cmd(__get_str(cmd), rq);
 	),
 
@@ -162,7 +163,7 @@ TRACE_EVENT(block_rq_complete,
 		__entry->nr_sector = nr_bytes >> 9;
 		__entry->errors    = rq->errors;
 
-		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, nr_bytes);
+		blk_fill_rwbs(__entry->rwbs, rq->op, rq->cmd_flags, nr_bytes);
 		blk_dump_cmd(__get_str(cmd), rq);
 	),
 
@@ -198,7 +199,8 @@ DECLARE_EVENT_CLASS(block_rq,
 		__entry->bytes     = (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
 					blk_rq_bytes(rq) : 0;
 
-		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
+		blk_fill_rwbs(__entry->rwbs, rq->op, rq->cmd_flags,
+			      blk_rq_bytes(rq));
 		blk_dump_cmd(__get_str(cmd), rq);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
@@ -272,7 +274,8 @@ TRACE_EVENT(block_bio_bounce,
 					  bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
@@ -310,7 +313,8 @@ TRACE_EVENT(block_bio_complete,
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		__entry->error		= error;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%d]",
@@ -337,7 +341,8 @@ DECLARE_EVENT_CLASS(block_bio_merge,
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
@@ -404,7 +409,8 @@ TRACE_EVENT(block_bio_queue,
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
@@ -432,7 +438,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
 		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio ? bio->bi_iter.bi_sector : 0;
 		__entry->nr_sector	= bio ? bio_sectors(bio) : 0;
-		blk_fill_rwbs(__entry->rwbs,
+		blk_fill_rwbs(__entry->rwbs, bio ? bio->bi_op : 0,
 			      bio ? bio->bi_rw : 0, __entry->nr_sector);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
         ),
@@ -567,7 +573,8 @@ TRACE_EVENT(block_split,
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->new_sector	= new_sector;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
@@ -610,7 +617,8 @@ TRACE_EVENT(block_bio_remap,
 		__entry->nr_sector	= bio_sectors(bio);
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_op, bio->bi_rw,
+			      bio->bi_iter.bi_size);
 	),
 
 	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
@@ -656,7 +664,8 @@ TRACE_EVENT(block_rq_remap,
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
 		__entry->nr_bios	= blk_rq_count_bios(rq);
-		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
+		blk_fill_rwbs(__entry->rwbs, rq->op, rq->cmd_flags,
+			      blk_rq_bytes(rq));
 	),
 
 	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu %u",
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 90e72a0..36e3862 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -199,7 +199,8 @@ static const u32 ddir_act[2] = { BLK_TC_ACT(BLK_TC_READ),
  * blk_io_trace structure and places it in a per-cpu subbuffer.
  */
 static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
-		     int rw, u32 what, int error, int pdu_len, void *pdu_data)
+		     int op, int op_flags, u32 what, int error, int pdu_len,
+		     void *pdu_data)
 {
 	struct task_struct *tsk = current;
 	struct ring_buffer_event *event = NULL;
@@ -214,13 +215,14 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (unlikely(bt->trace_state != Blktrace_running && !blk_tracer))
 		return;
 
-	what |= ddir_act[rw & WRITE];
-	what |= MASK_TC_BIT(rw, SYNC);
-	what |= MASK_TC_BIT(rw, RAHEAD);
-	what |= MASK_TC_BIT(rw, META);
-	what |= MASK_TC_BIT(rw, DISCARD);
-	what |= MASK_TC_BIT(rw, FLUSH);
-	what |= MASK_TC_BIT(rw, FUA);
+	what |= ddir_act[op_to_data_dir(op)];
+	what |= MASK_TC_BIT(op_flags, SYNC);
+	what |= MASK_TC_BIT(op_flags, RAHEAD);
+	what |= MASK_TC_BIT(op_flags, META);
+	what |= MASK_TC_BIT(op_flags, FLUSH);
+	what |= MASK_TC_BIT(op_flags, FUA);
+	if (op == REQ_OP_DISCARD)
+		what |= BLK_TC_ACT(BLK_TC_DISCARD);
 
 	pid = tsk->pid;
 	if (act_log_check(bt, what, sector, pid))
@@ -717,11 +719,11 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
-		__blk_add_trace(bt, 0, nr_bytes, rq->cmd_flags,
+		__blk_add_trace(bt, 0, nr_bytes, rq->op, rq->cmd_flags,
 				what, rq->errors, rq->cmd_len, rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
-		__blk_add_trace(bt, blk_rq_pos(rq), nr_bytes,
+		__blk_add_trace(bt, blk_rq_pos(rq), nr_bytes, rq->op,
 				rq->cmd_flags, what, rq->errors, 0, NULL);
 	}
 }
@@ -779,7 +781,7 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 		return;
 
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
-			bio->bi_rw, what, error, 0, NULL);
+			bio->bi_op, bio->bi_rw, what, error, 0, NULL);
 }
 
 static void blk_add_trace_bio_bounce(void *ignore,
@@ -827,7 +829,8 @@ static void blk_add_trace_getrq(void *ignore,
 		struct blk_trace *bt = q->blk_trace;
 
 		if (bt)
-			__blk_add_trace(bt, 0, 0, rw, BLK_TA_GETRQ, 0, 0, NULL);
+			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_GETRQ, 0, 0,
+					NULL);
 	}
 }
 
@@ -842,7 +845,7 @@ static void blk_add_trace_sleeprq(void *ignore,
 		struct blk_trace *bt = q->blk_trace;
 
 		if (bt)
-			__blk_add_trace(bt, 0, 0, rw, BLK_TA_SLEEPRQ,
+			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_SLEEPRQ,
 					0, 0, NULL);
 	}
 }
@@ -852,7 +855,7 @@ static void blk_add_trace_plug(void *ignore, struct request_queue *q)
 	struct blk_trace *bt = q->blk_trace;
 
 	if (bt)
-		__blk_add_trace(bt, 0, 0, 0, BLK_TA_PLUG, 0, 0, NULL);
+		__blk_add_trace(bt, 0, 0, 0, 0, BLK_TA_PLUG, 0, 0, NULL);
 }
 
 static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
@@ -869,7 +872,7 @@ static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
 		else
 			what = BLK_TA_UNPLUG_TIMER;
 
-		__blk_add_trace(bt, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu);
+		__blk_add_trace(bt, 0, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu);
 	}
 }
 
@@ -883,8 +886,9 @@ static void blk_add_trace_split(void *ignore,
 		__be64 rpdu = cpu_to_be64(pdu);
 
 		__blk_add_trace(bt, bio->bi_iter.bi_sector,
-				bio->bi_iter.bi_size, bio->bi_rw, BLK_TA_SPLIT,
-				bio->bi_error, sizeof(rpdu), &rpdu);
+				bio->bi_iter.bi_size, bio->bi_op, bio->bi_rw,
+				BLK_TA_SPLIT, bio->bi_error, sizeof(rpdu),
+				&rpdu);
 	}
 }
 
@@ -916,7 +920,7 @@ static void blk_add_trace_bio_remap(void *ignore,
 	r.sector_from = cpu_to_be64(from);
 
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
-			bio->bi_rw, BLK_TA_REMAP, bio->bi_error,
+			bio->bi_op, bio->bi_rw, BLK_TA_REMAP, bio->bi_error,
 			sizeof(r), &r);
 }
 
@@ -949,7 +953,7 @@ static void blk_add_trace_rq_remap(void *ignore,
 	r.sector_from = cpu_to_be64(from);
 
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
-			rq_data_dir(rq), BLK_TA_REMAP, !!rq->errors,
+			rq_data_dir(rq), 0, BLK_TA_REMAP, !!rq->errors,
 			sizeof(r), &r);
 }
 
@@ -974,10 +978,10 @@ void blk_add_driver_data(struct request_queue *q,
 		return;
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
-		__blk_add_trace(bt, 0, blk_rq_bytes(rq), 0,
+		__blk_add_trace(bt, 0, blk_rq_bytes(rq), 0, 0,
 				BLK_TA_DRV_DATA, rq->errors, len, data);
 	else
-		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq), 0,
+		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq), 0, 0,
 				BLK_TA_DRV_DATA, rq->errors, len, data);
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
@@ -1778,16 +1782,16 @@ void blk_dump_cmd(char *buf, struct request *rq)
 	}
 }
 
-void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
+void blk_fill_rwbs(char *rwbs, int op, u32 rw, int bytes)
 {
 	int i = 0;
 
 	if (rw & REQ_FLUSH)
 		rwbs[i++] = 'F';
 
-	if (rw & WRITE)
+	if (op == WRITE)
 		rwbs[i++] = 'W';
-	else if (rw & REQ_DISCARD)
+	else if (op == REQ_OP_DISCARD)
 		rwbs[i++] = 'D';
 	else if (bytes)
 		rwbs[i++] = 'R';
-- 
1.8.3.1
