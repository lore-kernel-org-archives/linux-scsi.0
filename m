From: mchristi@redhat.com
Subject: [PATCH 21/32] bcache: set bi_op to REQ_OP
Date: Wed,  4 Nov 2015 16:08:18 -0600
Message-ID: <1446674909-5371-22-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch has bcache set the bi_op.

For compat reasons, we are still ORing the op into bi_rw. This
will be dropped in later patches in this series when everyone
is updated.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/md/bcache/btree.c     |  2 ++
 drivers/md/bcache/journal.c   |  3 +++
 drivers/md/bcache/movinggc.c  |  1 +
 drivers/md/bcache/request.c   |  2 ++
 drivers/md/bcache/super.c     | 24 ++++++++++++++----------
 drivers/md/bcache/writeback.c |  2 ++
 6 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 83392f8..3be5b05 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -295,6 +295,7 @@ static void bch_btree_node_read(struct btree *b)
 	closure_init_stack(&cl);
 
 	bio = bch_bbio_alloc(b->c);
+	bio->bi_op	= REQ_OP_READ;
 	bio->bi_rw	= REQ_META|READ_SYNC;
 	bio->bi_iter.bi_size = KEY_SIZE(&b->key) << 9;
 	bio->bi_end_io	= btree_node_read_endio;
@@ -397,6 +398,7 @@ static void do_btree_node_write(struct btree *b)
 
 	b->bio->bi_end_io	= btree_node_write_endio;
 	b->bio->bi_private	= cl;
+	b->bio->bi_op		= REQ_OP_WRITE;
 	b->bio->bi_rw		= REQ_META|WRITE_SYNC|REQ_FUA;
 	b->bio->bi_iter.bi_size	= roundup(set_bytes(i), block_bytes(b->c));
 	bch_bio_map(b->bio, i);
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index ba9192b..d152e78 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -54,6 +54,7 @@ reread:		left = ca->sb.bucket_size - offset;
 		bio_reset(bio);
 		bio->bi_iter.bi_sector	= bucket + offset;
 		bio->bi_bdev	= ca->bdev;
+		bio->bi_op	= REQ_OP_READ;
 		bio->bi_rw	= READ;
 		bio->bi_iter.bi_size	= len << 9;
 
@@ -452,6 +453,7 @@ static void do_journal_discard(struct cache *ca)
 		bio->bi_iter.bi_sector	= bucket_to_sector(ca->set,
 						ca->sb.d[ja->discard_idx]);
 		bio->bi_bdev		= ca->bdev;
+		bio->bi_op		= REQ_OP_DISCARD;
 		bio->bi_rw		= REQ_WRITE|REQ_DISCARD;
 		bio->bi_max_vecs	= 1;
 		bio->bi_io_vec		= bio->bi_inline_vecs;
@@ -626,6 +628,7 @@ static void journal_write_unlocked(struct closure *cl)
 		bio_reset(bio);
 		bio->bi_iter.bi_sector	= PTR_OFFSET(k, i);
 		bio->bi_bdev	= ca->bdev;
+		bio->bi_op	= REQ_OP_WRITE;
 		bio->bi_rw	= REQ_WRITE|REQ_SYNC|REQ_META|REQ_FLUSH|REQ_FUA;
 		bio->bi_iter.bi_size = sectors << 9;
 
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index b929fc9..1318f32 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -163,6 +163,7 @@ static void read_moving(struct cache_set *c)
 		moving_init(io);
 		bio = &io->bio.bio;
 
+		bio->bi_op	= REQ_OP_READ;
 		bio->bi_rw	= READ;
 		bio->bi_end_io	= read_moving_endio;
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 8e9877b..7a84f3b 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -253,6 +253,7 @@ static void bch_data_insert_start(struct closure *cl)
 		trace_bcache_cache_insert(k);
 		bch_keylist_push(&op->insert_keys);
 
+		n->bi_op = REQ_OP_WRITE;
 		n->bi_rw |= REQ_WRITE;
 		bch_submit_bbio(n, op->c, k, 0);
 	} while (n != bio);
@@ -925,6 +926,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 			struct bio *flush = bio_alloc_bioset(GFP_NOIO, 0,
 							     dc->disk.bio_split);
 
+			flush->bi_op	= REQ_OP_WRITE;
 			flush->bi_rw	= WRITE_FLUSH;
 			flush->bi_bdev	= bio->bi_bdev;
 			flush->bi_end_io = request_endio;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a987c90..ccc6266 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -212,6 +212,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 	unsigned i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
+	bio->bi_op		= 0;
 	bio->bi_rw		= REQ_SYNC|REQ_META;
 	bio->bi_iter.bi_size	= SB_SIZE;
 	bch_bio_map(bio, NULL);
@@ -333,7 +334,7 @@ static void uuid_io_unlock(struct closure *cl)
 	up(&c->uuid_write_mutex);
 }
 
-static void uuid_io(struct cache_set *c, unsigned long rw,
+static void uuid_io(struct cache_set *c, int op, unsigned long op_flags,
 		    struct bkey *k, struct closure *parent)
 {
 	struct closure *cl = &c->uuid_write;
@@ -348,7 +349,8 @@ static void uuid_io(struct cache_set *c, unsigned long rw,
 	for (i = 0; i < KEY_PTRS(k); i++) {
 		struct bio *bio = bch_bbio_alloc(c);
 
-		bio->bi_rw	= REQ_SYNC|REQ_META|rw;
+		bio->bi_op	= op;
+		bio->bi_rw	= REQ_SYNC|REQ_META|op_flags;
 		bio->bi_iter.bi_size = KEY_SIZE(k) << 9;
 
 		bio->bi_end_io	= uuid_endio;
@@ -357,12 +359,12 @@ static void uuid_io(struct cache_set *c, unsigned long rw,
 
 		bch_submit_bbio(bio, c, k, i);
 
-		if (!(rw & WRITE))
+		if (op != REQ_OP_WRITE)
 			break;
 	}
 
 	bch_extent_to_text(buf, sizeof(buf), k);
-	pr_debug("%s UUIDs at %s", rw & REQ_WRITE ? "wrote" : "read", buf);
+	pr_debug("%s UUIDs at %s", op == REQ_OP_WRITE ? "wrote" : "read", buf);
 
 	for (u = c->uuids; u < c->uuids + c->nr_uuids; u++)
 		if (!bch_is_zero(u->uuid, 16))
@@ -381,7 +383,7 @@ static char *uuid_read(struct cache_set *c, struct jset *j, struct closure *cl)
 		return "bad uuid pointer";
 
 	bkey_copy(&c->uuid_bucket, k);
-	uuid_io(c, READ_SYNC, k, cl);
+	uuid_io(c, REQ_OP_READ, READ_SYNC, k, cl);
 
 	if (j->version < BCACHE_JSET_VERSION_UUIDv1) {
 		struct uuid_entry_v0	*u0 = (void *) c->uuids;
@@ -426,7 +428,7 @@ static int __uuid_write(struct cache_set *c)
 		return 1;
 
 	SET_KEY_SIZE(&k.key, c->sb.bucket_size);
-	uuid_io(c, REQ_WRITE, &k.key, &cl);
+	uuid_io(c, REQ_OP_WRITE, 0, &k.key, &cl);
 	closure_sync(&cl);
 
 	bkey_copy(&c->uuid_bucket, &k.key);
@@ -498,7 +500,8 @@ static void prio_endio(struct bio *bio)
 	closure_put(&ca->prio);
 }
 
-static void prio_io(struct cache *ca, uint64_t bucket, unsigned long rw)
+static void prio_io(struct cache *ca, uint64_t bucket, int op,
+		    unsigned long op_flags)
 {
 	struct closure *cl = &ca->prio;
 	struct bio *bio = bch_bbio_alloc(ca->set);
@@ -507,7 +510,8 @@ static void prio_io(struct cache *ca, uint64_t bucket, unsigned long rw)
 
 	bio->bi_iter.bi_sector	= bucket * ca->sb.bucket_size;
 	bio->bi_bdev		= ca->bdev;
-	bio->bi_rw		= REQ_SYNC|REQ_META|rw;
+	bio->bi_op		= op;
+	bio->bi_rw		= REQ_SYNC|REQ_META|op_flags;
 	bio->bi_iter.bi_size	= bucket_bytes(ca);
 
 	bio->bi_end_io	= prio_endio;
@@ -557,7 +561,7 @@ void bch_prio_write(struct cache *ca)
 		BUG_ON(bucket == -1);
 
 		mutex_unlock(&ca->set->bucket_lock);
-		prio_io(ca, bucket, REQ_WRITE);
+		prio_io(ca, bucket, REQ_OP_WRITE, 0);
 		mutex_lock(&ca->set->bucket_lock);
 
 		ca->prio_buckets[i] = bucket;
@@ -599,7 +603,7 @@ static void prio_read(struct cache *ca, uint64_t bucket)
 			ca->prio_last_buckets[bucket_nr] = bucket;
 			bucket_nr++;
 
-			prio_io(ca, bucket, READ_SYNC);
+			prio_io(ca, bucket, REQ_OP_READ, READ_SYNC);
 
 			if (p->csum != bch_crc64(&p->magic, bucket_bytes(ca) - 8))
 				pr_warn("bad csum reading priorities");
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index b23f88d..28b1bae 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -183,6 +183,7 @@ static void write_dirty(struct closure *cl)
 	struct keybuf_key *w = io->bio.bi_private;
 
 	dirty_init(w);
+	io->bio.bi_op		= REQ_OP_WRITE;
 	io->bio.bi_rw		= WRITE;
 	io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 	io->bio.bi_bdev		= io->dc->bdev;
@@ -256,6 +257,7 @@ static void read_dirty(struct cached_dev *dc)
 		io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
 		io->bio.bi_bdev		= PTR_CACHE(dc->disk.c,
 						    &w->key, 0)->bdev;
+		io->bio.bi_op		= REQ_OP_READ;
 		io->bio.bi_rw		= READ;
 		io->bio.bi_end_io	= read_dirty_endio;
 
-- 
1.8.3.1
