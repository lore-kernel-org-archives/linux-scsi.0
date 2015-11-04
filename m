From: mchristi@redhat.com
Subject: [PATCH 07/32] dm: prepare for bi_rw split
Date: Wed,  4 Nov 2015 16:08:04 -0600
Message-ID: <1446674909-5371-8-git-send-email-mchristi@redhat.com>
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

This patch prepares dm's submit_bio use for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers will now pass them in seperately.

This patch modifies the code related to the submit_bio calls
so the flags and operation are seperated. When this is done
for all code, one of the later patches in the series will
the actual submit_bio call, so the patches are bisectable.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/md/dm-bufio.c           |  6 +++--
 drivers/md/dm-io.c              | 56 ++++++++++++++++++++++-------------------
 drivers/md/dm-kcopyd.c          |  3 ++-
 drivers/md/dm-log.c             |  5 ++--
 drivers/md/dm-raid1.c           | 11 +++++---
 drivers/md/dm-snap-persistent.c | 24 ++++++++++--------
 drivers/md/dm-thin.c            |  6 ++---
 include/linux/dm-io.h           |  3 ++-
 8 files changed, 64 insertions(+), 50 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 83cc52e..9d5ef0c 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -554,7 +554,8 @@ static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
 {
 	int r;
 	struct dm_io_request io_req = {
-		.bi_rw = rw,
+		.bi_op = rw,
+		.bi_op_flags = 0,
 		.notify.fn = dmio_complete,
 		.notify.context = b,
 		.client = b->c->dm_io,
@@ -1302,7 +1303,8 @@ EXPORT_SYMBOL_GPL(dm_bufio_write_dirty_buffers);
 int dm_bufio_issue_flush(struct dm_bufio_client *c)
 {
 	struct dm_io_request io_req = {
-		.bi_rw = WRITE_FLUSH,
+		.bi_op = REQ_OP_WRITE,
+		.bi_op_flags = WRITE_FLUSH,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
 		.client = c->dm_io,
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 6f8e83b2..6479096 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -279,8 +279,9 @@ static void km_dp_init(struct dpages *dp, void *data)
 /*-----------------------------------------------------------------
  * IO routines that accept a list of pages.
  *---------------------------------------------------------------*/
-static void do_region(int rw, unsigned region, struct dm_io_region *where,
-		      struct dpages *dp, struct io *io)
+static void do_region(int op, int op_flags, unsigned region,
+		      struct dm_io_region *where, struct dpages *dp,
+		      struct io *io)
 {
 	struct bio *bio;
 	struct page *page;
@@ -296,24 +297,25 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 	/*
 	 * Reject unsupported discard and write same requests.
 	 */
-	if (rw & REQ_DISCARD)
+	if (op == REQ_DISCARD)
 		special_cmd_max_sectors = q->limits.max_discard_sectors;
-	else if (rw & REQ_WRITE_SAME)
+	else if (op == REQ_WRITE_SAME)
 		special_cmd_max_sectors = q->limits.max_write_same_sectors;
-	if ((rw & (REQ_DISCARD | REQ_WRITE_SAME)) && special_cmd_max_sectors == 0) {
+	if ((op == REQ_DISCARD || op == REQ_WRITE_SAME) &&
+	    special_cmd_max_sectors == 0) {
 		dec_count(io, region, -EOPNOTSUPP);
 		return;
 	}
 
 	/*
-	 * where->count may be zero if rw holds a flush and we need to
+	 * where->count may be zero if op holds a flush and we need to
 	 * send a zero-sized flush.
 	 */
 	do {
 		/*
 		 * Allocate a suitably sized-bio.
 		 */
-		if ((rw & REQ_DISCARD) || (rw & REQ_WRITE_SAME))
+		if ((op == REQ_DISCARD) || (op == REQ_WRITE_SAME))
 			num_bvecs = 1;
 		else
 			num_bvecs = min_t(int, BIO_MAX_PAGES,
@@ -325,11 +327,11 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		bio->bi_end_io = endio;
 		store_io_and_region_in_bio(bio, io, region);
 
-		if (rw & REQ_DISCARD) {
+		if (op == REQ_DISCARD) {
 			num_sectors = min_t(sector_t, special_cmd_max_sectors, remaining);
 			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 			remaining -= num_sectors;
-		} else if (rw & REQ_WRITE_SAME) {
+		} else if (op == REQ_WRITE_SAME) {
 			/*
 			 * WRITE SAME only uses a single page.
 			 */
@@ -356,11 +358,11 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		}
 
 		atomic_inc(&io->count);
-		submit_bio(rw, bio);
+		submit_bio(op | op_flags, bio);
 	} while (remaining);
 }
 
-static void dispatch_io(int rw, unsigned int num_regions,
+static void dispatch_io(int op, int op_flags, unsigned int num_regions,
 			struct dm_io_region *where, struct dpages *dp,
 			struct io *io, int sync)
 {
@@ -370,7 +372,7 @@ static void dispatch_io(int rw, unsigned int num_regions,
 	BUG_ON(num_regions > DM_IO_MAX_REGIONS);
 
 	if (sync)
-		rw |= REQ_SYNC;
+		op_flags |= REQ_SYNC;
 
 	/*
 	 * For multiple regions we need to be careful to rewind
@@ -378,8 +380,8 @@ static void dispatch_io(int rw, unsigned int num_regions,
 	 */
 	for (i = 0; i < num_regions; i++) {
 		*dp = old_pages;
-		if (where[i].count || (rw & REQ_FLUSH))
-			do_region(rw, i, where + i, dp, io);
+		if (where[i].count || (op_flags & REQ_FLUSH))
+			do_region(op, op_flags, i, where + i, dp, io);
 	}
 
 	/*
@@ -403,13 +405,13 @@ static void sync_io_complete(unsigned long error, void *context)
 }
 
 static int sync_io(struct dm_io_client *client, unsigned int num_regions,
-		   struct dm_io_region *where, int rw, struct dpages *dp,
-		   unsigned long *error_bits)
+		   struct dm_io_region *where, int op, int op_flags,
+		   struct dpages *dp, unsigned long *error_bits)
 {
 	struct io *io;
 	struct sync_io sio;
 
-	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
+	if (num_regions > 1 && op != WRITE) {
 		WARN_ON(1);
 		return -EIO;
 	}
@@ -426,7 +428,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
-	dispatch_io(rw, num_regions, where, dp, io, 1);
+	dispatch_io(op, op_flags, num_regions, where, dp, io, 1);
 
 	wait_for_completion_io(&sio.wait);
 
@@ -437,12 +439,12 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 }
 
 static int async_io(struct dm_io_client *client, unsigned int num_regions,
-		    struct dm_io_region *where, int rw, struct dpages *dp,
-		    io_notify_fn fn, void *context)
+		    struct dm_io_region *where, int op, int op_flags,
+		    struct dpages *dp, io_notify_fn fn, void *context)
 {
 	struct io *io;
 
-	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
+	if (num_regions > 1 && op != WRITE) {
 		WARN_ON(1);
 		fn(1, context);
 		return -EIO;
@@ -458,7 +460,7 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
-	dispatch_io(rw, num_regions, where, dp, io, 0);
+	dispatch_io(op, op_flags, num_regions, where, dp, io, 0);
 	return 0;
 }
 
@@ -481,7 +483,7 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 
 	case DM_IO_VMA:
 		flush_kernel_vmap_range(io_req->mem.ptr.vma, size);
-		if ((io_req->bi_rw & RW_MASK) == READ) {
+		if (io_req->bi_op == READ) {
 			dp->vma_invalidate_address = io_req->mem.ptr.vma;
 			dp->vma_invalidate_size = size;
 		}
@@ -519,10 +521,12 @@ int dm_io(struct dm_io_request *io_req, unsigned num_regions,
 
 	if (!io_req->notify.fn)
 		return sync_io(io_req->client, num_regions, where,
-			       io_req->bi_rw, &dp, sync_error_bits);
+			       io_req->bi_op, io_req->bi_op_flags, &dp,
+			       sync_error_bits);
 
-	return async_io(io_req->client, num_regions, where, io_req->bi_rw,
-			&dp, io_req->notify.fn, io_req->notify.context);
+	return async_io(io_req->client, num_regions, where, io_req->bi_op,
+			io_req->bi_op_flags, &dp, io_req->notify.fn,
+			io_req->notify.context);
 }
 EXPORT_SYMBOL(dm_io);
 
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 3a7cade..02dccbe 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -496,7 +496,8 @@ static int run_io_job(struct kcopyd_job *job)
 {
 	int r;
 	struct dm_io_request io_req = {
-		.bi_rw = job->rw,
+		.bi_op = job->rw,
+		.bi_op_flags = 0,
 		.mem.type = DM_IO_PAGE_LIST,
 		.mem.ptr.pl = job->pages,
 		.mem.offset = 0,
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 627d191..4ca2d1d 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -293,7 +293,7 @@ static void header_from_disk(struct log_header_core *core, struct log_header_dis
 
 static int rw_header(struct log_c *lc, int rw)
 {
-	lc->io_req.bi_rw = rw;
+	lc->io_req.bi_op = rw;
 
 	return dm_io(&lc->io_req, 1, &lc->header_location, NULL);
 }
@@ -306,7 +306,8 @@ static int flush_header(struct log_c *lc)
 		.count = 0,
 	};
 
-	lc->io_req.bi_rw = WRITE_FLUSH;
+	lc->io_req.bi_op = REQ_OP_WRITE;
+	lc->io_req.bi_op_flags = WRITE_FLUSH;
 
 	return dm_io(&lc->io_req, 1, &null_location, NULL);
 }
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index f2a363a..ec48487 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -260,7 +260,8 @@ static int mirror_flush(struct dm_target *ti)
 	struct dm_io_region io[ms->nr_mirrors];
 	struct mirror *m;
 	struct dm_io_request io_req = {
-		.bi_rw = WRITE_FLUSH,
+		.bi_op = REQ_OP_WRITE,
+		.bi_op_flags = WRITE_FLUSH,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
 		.client = ms->io_client,
@@ -541,7 +542,8 @@ static void read_async_bio(struct mirror *m, struct bio *bio)
 {
 	struct dm_io_region io;
 	struct dm_io_request io_req = {
-		.bi_rw = READ,
+		.bi_op = REQ_OP_READ,
+		.bi_op_flags = 0,
 		.mem.type = DM_IO_BIO,
 		.mem.ptr.bio = bio,
 		.notify.fn = read_callback,
@@ -654,7 +656,8 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 	struct dm_io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 	struct dm_io_request io_req = {
-		.bi_rw = WRITE | (bio->bi_rw & WRITE_FLUSH_FUA),
+		.bi_op = REQ_OP_WRITE,
+		.bi_op_flags = bio->bi_rw & WRITE_FLUSH_FUA,
 		.mem.type = DM_IO_BIO,
 		.mem.ptr.bio = bio,
 		.notify.fn = write_callback,
@@ -663,7 +666,7 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 	};
 
 	if (bio->bi_rw & REQ_DISCARD) {
-		io_req.bi_rw |= REQ_DISCARD;
+		io_req.bi_op_flags |= REQ_DISCARD;
 		io_req.mem.type = DM_IO_KMEM;
 		io_req.mem.ptr.addr = NULL;
 	}
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 117a05e..1032fcb 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -226,8 +226,8 @@ static void do_metadata(struct work_struct *work)
 /*
  * Read or write a chunk aligned and sized block of data from a device.
  */
-static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw,
-		    int metadata)
+static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int op,
+		    int op_flags, int metadata)
 {
 	struct dm_io_region where = {
 		.bdev = dm_snap_cow(ps->store->snap)->bdev,
@@ -235,7 +235,8 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw,
 		.count = ps->store->chunk_size,
 	};
 	struct dm_io_request io_req = {
-		.bi_rw = rw,
+		.bi_op = op,
+		.bi_op_flags = op_flags,
 		.mem.type = DM_IO_VMA,
 		.mem.ptr.vma = area,
 		.client = ps->io_client,
@@ -281,14 +282,14 @@ static void skip_metadata(struct pstore *ps)
  * Read or write a metadata area.  Remembering to skip the first
  * chunk which holds the header.
  */
-static int area_io(struct pstore *ps, int rw)
+static int area_io(struct pstore *ps, int op, int op_flags)
 {
 	int r;
 	chunk_t chunk;
 
 	chunk = area_location(ps, ps->current_area);
 
-	r = chunk_io(ps, ps->area, chunk, rw, 0);
+	r = chunk_io(ps, ps->area, chunk, op, op_flags, 0);
 	if (r)
 		return r;
 
@@ -302,7 +303,8 @@ static void zero_memory_area(struct pstore *ps)
 
 static int zero_disk_area(struct pstore *ps, chunk_t area)
 {
-	return chunk_io(ps, ps->zero_area, area_location(ps, area), WRITE, 0);
+	return chunk_io(ps, ps->zero_area, area_location(ps, area), WRITE, 0,
+			0);
 }
 
 static int read_header(struct pstore *ps, int *new_snapshot)
@@ -334,7 +336,7 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 	if (r)
 		return r;
 
-	r = chunk_io(ps, ps->header_area, 0, READ, 1);
+	r = chunk_io(ps, ps->header_area, 0, READ, 0, 1);
 	if (r)
 		goto bad;
 
@@ -395,7 +397,7 @@ static int write_header(struct pstore *ps)
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->store->chunk_size);
 
-	return chunk_io(ps, ps->header_area, 0, WRITE, 1);
+	return chunk_io(ps, ps->header_area, 0, WRITE, 0, 1);
 }
 
 /*
@@ -736,7 +738,7 @@ static void persistent_commit_exception(struct dm_exception_store *store,
 	/*
 	 * Commit exceptions to disk.
 	 */
-	if (ps->valid && area_io(ps, WRITE_FLUSH_FUA))
+	if (ps->valid && area_io(ps, REQ_OP_WRITE, WRITE_FLUSH_FUA))
 		ps->valid = 0;
 
 	/*
@@ -776,7 +778,7 @@ static int persistent_prepare_merge(struct dm_exception_store *store,
 			return 0;
 
 		ps->current_area--;
-		r = area_io(ps, READ);
+		r = area_io(ps, REQ_OP_READ, 0);
 		if (r < 0)
 			return r;
 		ps->current_committed = ps->exceptions_per_area;
@@ -813,7 +815,7 @@ static int persistent_commit_merge(struct dm_exception_store *store,
 	for (i = 0; i < nr_merged; i++)
 		clear_exception(ps, ps->current_committed - 1 - i);
 
-	r = area_io(ps, WRITE_FLUSH_FUA);
+	r = area_io(ps, REQ_OP_WRITE, WRITE_FLUSH_FUA);
 	if (r < 0)
 		return r;
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 3897b90..1500582 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -338,7 +338,7 @@ static int __blkdev_issue_discard_async(struct block_device *bdev, sector_t sect
 					struct bio *parent_bio)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	int type = REQ_WRITE | REQ_DISCARD;
+	int op_flags = 0;
 	struct bio *bio;
 
 	if (!q || !nr_sects)
@@ -350,7 +350,7 @@ static int __blkdev_issue_discard_async(struct block_device *bdev, sector_t sect
 	if (flags & BLKDEV_DISCARD_SECURE) {
 		if (!blk_queue_secdiscard(q))
 			return -EOPNOTSUPP;
-		type |= REQ_SECURE;
+		op_flags |= REQ_SECURE;
 	}
 
 	/*
@@ -366,7 +366,7 @@ static int __blkdev_issue_discard_async(struct block_device *bdev, sector_t sect
 	bio->bi_bdev = bdev;
 	bio->bi_iter.bi_size = nr_sects << 9;
 
-	submit_bio(type, bio);
+	submit_bio(REQ_OP_DISCARD | op_flags, bio);
 
 	return 0;
 }
diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
index a68cbe5..b91b023 100644
--- a/include/linux/dm-io.h
+++ b/include/linux/dm-io.h
@@ -57,7 +57,8 @@ struct dm_io_notify {
  */
 struct dm_io_client;
 struct dm_io_request {
-	int bi_rw;			/* READ|WRITE - not READA */
+	int bi_op;			/* REQ_OP */
+	int bi_op_flags;		/* rq_flag_bits */
 	struct dm_io_memory mem;	/* Memory to use for io */
 	struct dm_io_notify notify;	/* Synchronous if notify.fn is NULL */
 	struct dm_io_client *client;	/* Client memory handler */
-- 
1.8.3.1
