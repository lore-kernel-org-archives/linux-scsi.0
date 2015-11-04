From: mchristi@redhat.com
Subject: [PATCH 16/32] block/fs/md: pass in op and flags to
	submit_bh
Date: Wed,  4 Nov 2015 16:08:13 -0600
Message-ID: <1446674909-5371-17-git-send-email-mchristi@redhat.com>
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

This patch prepares submit_bh callers for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers now pass them in seperately.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/md/bitmap.c         |  4 ++--
 fs/btrfs/check-integrity.c  |  4 ++--
 fs/buffer.c                 | 52 ++++++++++++++++++++++-----------------------
 fs/ext4/balloc.c            |  2 +-
 fs/ext4/ialloc.c            |  2 +-
 fs/ext4/inode.c             |  2 +-
 fs/ext4/mmp.c               |  4 ++--
 fs/ext4/super.c             |  2 +-
 fs/fat/misc.c               |  2 +-
 fs/gfs2/bmap.c              |  2 +-
 fs/gfs2/dir.c               |  2 +-
 fs/gfs2/meta_io.c           |  8 +++----
 fs/jbd2/commit.c            |  7 +++---
 fs/jbd2/journal.c           |  8 +++----
 fs/nilfs2/btnode.c          |  6 +++---
 fs/nilfs2/btnode.h          |  2 +-
 fs/nilfs2/btree.c           |  6 ++++--
 fs/nilfs2/gcinode.c         |  5 +++--
 fs/nilfs2/mdt.c             | 11 +++++-----
 fs/nilfs2/super.c           |  4 ++--
 fs/ntfs/aops.c              |  6 +++---
 fs/ntfs/compress.c          |  2 +-
 fs/ntfs/file.c              |  2 +-
 fs/ntfs/logfile.c           |  2 +-
 fs/ntfs/mft.c               |  4 ++--
 fs/ocfs2/buffer_head_io.c   |  8 +++----
 fs/reiserfs/inode.c         |  4 ++--
 fs/reiserfs/journal.c       | 12 ++++++-----
 fs/ufs/util.c               |  2 +-
 include/linux/buffer_head.h |  9 ++++----
 30 files changed, 97 insertions(+), 89 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 48b5890..9070ee8 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -299,7 +299,7 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 			atomic_inc(&bitmap->pending_writes);
 			set_buffer_locked(bh);
 			set_buffer_mapped(bh);
-			submit_bh(WRITE | REQ_SYNC, bh);
+			submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
 			bh = bh->b_this_page;
 		}
 
@@ -394,7 +394,7 @@ static int read_page(struct file *file, unsigned long index,
 			atomic_inc(&bitmap->pending_writes);
 			set_buffer_locked(bh);
 			set_buffer_mapped(bh);
-			submit_bh(READ, bh);
+			submit_bh(REQ_OP_READ, 0, bh);
 		}
 		block++;
 		bh = bh->b_this_page;
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 17eba2d..9cb367f0 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2908,7 +2908,7 @@ int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh)
 	struct btrfsic_dev_state *dev_state;
 
 	if (!btrfsic_is_initialized)
-		return submit_bh(op | op_flags, bh);
+		return submit_bh(op, op_flags, bh);
 
 	mutex_lock(&btrfsic_mutex);
 	/* since btrfsic_submit_bh() might also be called before
@@ -2964,7 +2964,7 @@ int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh)
 		}
 	}
 	mutex_unlock(&btrfsic_mutex);
-	return submit_bh(op | op_flags, bh);
+	return submit_bh(op, op_flags, bh);
 }
 
 static void __btrfsic_submit_bio(int op, int op_flags, struct bio *bio)
diff --git a/fs/buffer.c b/fs/buffer.c
index a190c25..cd07d86 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -45,7 +45,7 @@
 #include <trace/events/block.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
-static int submit_bh_wbc(int rw, struct buffer_head *bh,
+static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 			 unsigned long bio_flags,
 			 struct writeback_control *wbc);
 
@@ -1236,7 +1236,7 @@ static struct buffer_head *__bread_slow(struct buffer_head *bh)
 	} else {
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ, bh);
+		submit_bh(REQ_OP_READ, 0, bh);
 		wait_on_buffer(bh);
 		if (buffer_uptodate(bh))
 			return bh;
@@ -1708,7 +1708,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	struct buffer_head *bh, *head;
 	unsigned int blocksize, bbits;
 	int nr_underway = 0;
-	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
+	int write_flags = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC: 0);
 
 	head = create_page_buffers(page, inode,
 					(1 << BH_Dirty)|(1 << BH_Uptodate));
@@ -1797,7 +1797,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh_wbc(write_op, bh, 0, wbc);
+			submit_bh_wbc(REQ_OP_WRITE, write_flags, bh, 0, wbc);
 			nr_underway++;
 		}
 		bh = next;
@@ -1851,7 +1851,7 @@ recover:
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
 			clear_buffer_dirty(bh);
-			submit_bh_wbc(write_op, bh, 0, wbc);
+			submit_bh_wbc(REQ_OP_WRITE, write_flags, bh, 0, wbc);
 			nr_underway++;
 		}
 		bh = next;
@@ -2259,7 +2259,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 		if (buffer_uptodate(bh))
 			end_buffer_async_read(bh, 1);
 		else
-			submit_bh(READ, bh);
+			submit_bh(REQ_OP_READ, 0, bh);
 	}
 	return 0;
 }
@@ -2613,7 +2613,7 @@ int nobh_write_begin(struct address_space *mapping,
 		if (block_start < from || block_end > to) {
 			lock_buffer(bh);
 			bh->b_end_io = end_buffer_read_nobh;
-			submit_bh(READ, bh);
+			submit_bh(REQ_OP_READ, 0, bh);
 			nr_reads++;
 		}
 	}
@@ -2980,7 +2980,7 @@ static void end_bio_bh_io_sync(struct bio *bio)
  * errors, this only handles the "we need to be able to
  * do IO at the final sector" case.
  */
-void guard_bio_eod(int rw, struct bio *bio)
+void guard_bio_eod(int op, struct bio *bio)
 {
 	sector_t maxsector;
 	struct bio_vec *bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
@@ -3010,17 +3010,16 @@ void guard_bio_eod(int rw, struct bio *bio)
 	bvec->bv_len -= truncated_bytes;
 
 	/* ..and clear the end of the buffer for reads */
-	if ((rw & RW_MASK) == READ) {
+	if (op == REQ_OP_READ) {
 		zero_user(bvec->bv_page, bvec->bv_offset + bvec->bv_len,
 				truncated_bytes);
 	}
 }
 
-static int submit_bh_wbc(int rw, struct buffer_head *bh,
+static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 			 unsigned long bio_flags, struct writeback_control *wbc)
 {
 	struct bio *bio;
-	int op_flags = 0;
 
 	BUG_ON(!buffer_locked(bh));
 	BUG_ON(!buffer_mapped(bh));
@@ -3031,7 +3030,7 @@ static int submit_bh_wbc(int rw, struct buffer_head *bh,
 	/*
 	 * Only clear out a write error when rewriting
 	 */
-	if (test_set_buffer_req(bh) && (rw & WRITE))
+	if (test_set_buffer_req(bh) && (op == REQ_OP_WRITE))
 		clear_buffer_write_io_error(bh);
 
 	/*
@@ -3056,26 +3055,27 @@ static int submit_bh_wbc(int rw, struct buffer_head *bh,
 	bio->bi_flags |= bio_flags;
 
 	/* Take care of bh's that straddle the end of the device */
-	guard_bio_eod(rw, bio);
+	guard_bio_eod(op, bio);
 
 	if (buffer_meta(bh))
 		op_flags |= REQ_META;
 	if (buffer_prio(bh))
 		op_flags |= REQ_PRIO;
 
-	submit_bio(rw, op_flags, bio);
+	submit_bio(op, op_flags, bio);
 	return 0;
 }
 
-int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
+int _submit_bh(int op, int op_flags, struct buffer_head *bh,
+	       unsigned long bio_flags)
 {
-	return submit_bh_wbc(rw, bh, bio_flags, NULL);
+	return submit_bh_wbc(op, op_flags, bh, bio_flags, NULL);
 }
 EXPORT_SYMBOL_GPL(_submit_bh);
 
-int submit_bh(int rw, struct buffer_head *bh)
+int submit_bh(int op, int op_flags, struct buffer_head *bh)
 {
-	return submit_bh_wbc(rw, bh, 0, NULL);
+	return submit_bh_wbc(op, op_flags, bh, 0, NULL);
 }
 EXPORT_SYMBOL(submit_bh);
 
@@ -3117,14 +3117,14 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 			if (test_clear_buffer_dirty(bh)) {
 				bh->b_end_io = end_buffer_write_sync;
 				get_bh(bh);
-				submit_bh(WRITE, bh);
+				submit_bh(REQ_OP_WRITE, 0, bh);
 				continue;
 			}
 		} else {
 			if (!buffer_uptodate(bh)) {
 				bh->b_end_io = end_buffer_read_sync;
 				get_bh(bh);
-				submit_bh(rw, bh);
+				submit_bh(rw, 0, bh);
 				continue;
 			}
 		}
@@ -3133,7 +3133,7 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 }
 EXPORT_SYMBOL(ll_rw_block);
 
-void write_dirty_buffer(struct buffer_head *bh, int rw)
+void write_dirty_buffer(struct buffer_head *bh, int op_flags)
 {
 	lock_buffer(bh);
 	if (!test_clear_buffer_dirty(bh)) {
@@ -3142,7 +3142,7 @@ void write_dirty_buffer(struct buffer_head *bh, int rw)
 	}
 	bh->b_end_io = end_buffer_write_sync;
 	get_bh(bh);
-	submit_bh(rw, bh);
+	submit_bh(REQ_OP_WRITE, op_flags, bh);
 }
 EXPORT_SYMBOL(write_dirty_buffer);
 
@@ -3151,7 +3151,7 @@ EXPORT_SYMBOL(write_dirty_buffer);
  * and then start new I/O and then wait upon it.  The caller must have a ref on
  * the buffer_head.
  */
-int __sync_dirty_buffer(struct buffer_head *bh, int rw)
+int __sync_dirty_buffer(struct buffer_head *bh, int op, int op_flags)
 {
 	int ret = 0;
 
@@ -3160,7 +3160,7 @@ int __sync_dirty_buffer(struct buffer_head *bh, int rw)
 	if (test_clear_buffer_dirty(bh)) {
 		get_bh(bh);
 		bh->b_end_io = end_buffer_write_sync;
-		ret = submit_bh(rw, bh);
+		ret = submit_bh(op, op_flags, bh);
 		wait_on_buffer(bh);
 		if (!ret && !buffer_uptodate(bh))
 			ret = -EIO;
@@ -3173,7 +3173,7 @@ EXPORT_SYMBOL(__sync_dirty_buffer);
 
 int sync_dirty_buffer(struct buffer_head *bh)
 {
-	return __sync_dirty_buffer(bh, WRITE_SYNC);
+	return __sync_dirty_buffer(bh, REQ_OP_WRITE, WRITE_SYNC);
 }
 EXPORT_SYMBOL(sync_dirty_buffer);
 
@@ -3423,7 +3423,7 @@ int bh_submit_read(struct buffer_head *bh)
 
 	get_bh(bh);
 	bh->b_end_io = end_buffer_read_sync;
-	submit_bh(READ, bh);
+	submit_bh(REQ_OP_READ, 0, bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return 0;
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index cd6ea29..61f64f0 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -465,7 +465,7 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 	trace_ext4_read_block_bitmap_load(sb, block_group);
 	bh->b_end_io = ext4_end_bitmap_read;
 	get_bh(bh);
-	submit_bh(READ | REQ_META | REQ_PRIO, bh);
+	submit_bh(REQ_OP_READ, REQ_META | REQ_PRIO, bh);
 	return bh;
 verify:
 	ext4_validate_block_bitmap(sb, desc, block_group, bh);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 619bfc1..803212e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -175,7 +175,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	trace_ext4_load_inode_bitmap(sb, block_group);
 	bh->b_end_io = ext4_end_bitmap_read;
 	get_bh(bh);
-	submit_bh(READ | REQ_META | REQ_PRIO, bh);
+	submit_bh(REQ_OP_READ, REQ_META | REQ_PRIO, bh);
 	wait_on_buffer(bh);
 	if (!buffer_uptodate(bh)) {
 		put_bh(bh);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 612fbcf..f34ef29 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3932,7 +3932,7 @@ make_io:
 		trace_ext4_load_inode(inode);
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ | REQ_META | REQ_PRIO, bh);
+		submit_bh(REQ_OP_READ, REQ_META | REQ_PRIO, bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			EXT4_ERROR_INODE_BLOCK(inode, block,
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 6eb1a61..381d3d0 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -52,7 +52,7 @@ static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
 	lock_buffer(bh);
 	bh->b_end_io = end_buffer_write_sync;
 	get_bh(bh);
-	submit_bh(WRITE_SYNC | REQ_META | REQ_PRIO, bh);
+	submit_bh(REQ_OP_WRITE, WRITE_SYNC | REQ_META | REQ_PRIO, bh);
 	wait_on_buffer(bh);
 	sb_end_write(sb);
 	if (unlikely(!buffer_uptodate(bh)))
@@ -88,7 +88,7 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	get_bh(*bh);
 	lock_buffer(*bh);
 	(*bh)->b_end_io = end_buffer_read_sync;
-	submit_bh(READ_SYNC | REQ_META | REQ_PRIO, *bh);
+	submit_bh(REQ_OP_READ, READ_SYNC | REQ_META | REQ_PRIO, *bh);
 	wait_on_buffer(*bh);
 	if (!buffer_uptodate(*bh)) {
 		brelse(*bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a63c7b0..d9e4329 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4681,7 +4681,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	ext4_superblock_csum_set(sb);
 	mark_buffer_dirty(sbh);
 	if (sync) {
-		error = __sync_dirty_buffer(sbh,
+		error = __sync_dirty_buffer(sbh, REQ_OP_WRITE,
 			test_opt(sb, BARRIER) ? WRITE_FUA : WRITE_SYNC);
 		if (error)
 			return error;
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index c4589e9..8a86981 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -267,7 +267,7 @@ int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 	int i, err = 0;
 
 	for (i = 0; i < nr_bhs; i++)
-		write_dirty_buffer(bhs[i], WRITE);
+		write_dirty_buffer(bhs[i], 0);
 
 	for (i = 0; i < nr_bhs; i++) {
 		wait_on_buffer(bhs[i]);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 61296ec..967154c 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -285,7 +285,7 @@ static void gfs2_metapath_ra(struct gfs2_glock *gl,
 		if (trylock_buffer(rabh)) {
 			if (!buffer_uptodate(rabh)) {
 				rabh->b_end_io = end_buffer_read_sync;
-				submit_bh(READA | REQ_META, rabh);
+				submit_bh(REQ_OP_READ, READA | REQ_META, rabh);
 				continue;
 			}
 			unlock_buffer(rabh);
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 487527b..f11f377 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1418,7 +1418,7 @@ static void gfs2_dir_readahead(struct inode *inode, unsigned hsize, u32 index,
 				continue;
 			}
 			bh->b_end_io = end_buffer_read_sync;
-			submit_bh(READA | REQ_META, bh);
+			submit_bh(REQ_OP_READ, READA | REQ_META, bh);
 			continue;
 		}
 		brelse(bh);
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 0e1d4be..ff483bc 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -37,8 +37,8 @@ static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wb
 {
 	struct buffer_head *bh, *head;
 	int nr_underway = 0;
-	int write_op = REQ_META | REQ_PRIO |
-		(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
+	int write_flags = REQ_META | REQ_PRIO |
+		(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : 0);
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!page_has_buffers(page));
@@ -79,7 +79,7 @@ static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wb
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(write_op, bh);
+			submit_bh(REQ_OP_WRITE, write_flags, bh);
 			nr_underway++;
 		}
 		bh = next;
@@ -217,7 +217,7 @@ int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
 	}
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
-	submit_bh(READ_SYNC | REQ_META | REQ_PRIO, bh);
+	submit_bh(REQ_OP_READ, READ_SYNC | REQ_META | REQ_PRIO, bh);
 	if (!(flags & DIO_WAIT))
 		return 0;
 
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 362e5f6..4471d28 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -159,9 +159,10 @@ static int journal_submit_commit_record(journal_t *journal,
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !JBD2_HAS_INCOMPAT_FEATURE(journal,
 				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
-		ret = submit_bh(WRITE_SYNC | WRITE_FLUSH_FUA, bh);
+		ret = submit_bh(REQ_OP_WRITE,
+				WRITE_SYNC | WRITE_FLUSH_FUA, bh);
 	else
-		ret = submit_bh(WRITE_SYNC, bh);
+		ret = submit_bh(REQ_OP_WRITE, WRITE_SYNC, bh);
 
 	*cbh = bh;
 	return ret;
@@ -740,7 +741,7 @@ start_journal_io:
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(WRITE_SYNC, bh);
+				submit_bh(REQ_OP_WRITE, WRITE_SYNC, bh);
 			}
 			cond_resched();
 			stats.run.rs_blocks_logged += bufs;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8270fe9..e3855b0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1323,15 +1323,15 @@ static int journal_reset(journal_t *journal)
 	return jbd2_journal_start_thread(journal);
 }
 
-static int jbd2_write_superblock(journal_t *journal, int write_op)
+static int jbd2_write_superblock(journal_t *journal, int write_flags)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
 	journal_superblock_t *sb = journal->j_superblock;
 	int ret;
 
-	trace_jbd2_write_superblock(journal, write_op);
+	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))
-		write_op &= ~(REQ_FUA | REQ_FLUSH);
+		write_flags &= ~(REQ_FUA | REQ_FLUSH);
 	lock_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		/*
@@ -1351,7 +1351,7 @@ static int jbd2_write_superblock(journal_t *journal, int write_op)
 	jbd2_superblock_csum_set(journal, sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
-	ret = submit_bh(write_op, bh);
+	ret = submit_bh(REQ_OP_WRITE, write_flags, bh);
 	wait_on_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		clear_buffer_write_io_error(bh);
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index a35ae35..07fe874 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -67,7 +67,7 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 }
 
 int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
-			      sector_t pblocknr, int mode,
+			      sector_t pblocknr, int mode, int mode_flags,
 			      struct buffer_head **pbh, sector_t *submit_ptr)
 {
 	struct buffer_head *bh;
@@ -100,7 +100,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 		}
 	}
 
-	if (mode == READA) {
+	if (mode_flags & REQ_RAHEAD) {
 		if (pblocknr != *submit_ptr + 1 || !trylock_buffer(bh)) {
 			err = -EBUSY; /* internal code */
 			brelse(bh);
@@ -119,7 +119,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	bh->b_blocknr = pblocknr; /* set block address for read */
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
-	submit_bh(mode, bh);
+	submit_bh(mode, mode_flags, bh);
 	bh->b_blocknr = blocknr; /* set back to the given block address */
 	*submit_ptr = pblocknr;
 	err = 0;
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index d876b56..3f93197 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -47,7 +47,7 @@ void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
 					      __u64 blocknr);
 int nilfs_btnode_submit_block(struct address_space *, __u64, sector_t, int,
-			      struct buffer_head **, sector_t *);
+			      int, struct buffer_head **, sector_t *);
 void nilfs_btnode_delete(struct buffer_head *);
 int nilfs_btnode_prepare_change_key(struct address_space *,
 				    struct nilfs_btnode_chkey_ctxt *);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 919fd5b..0cc1a24 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -480,7 +480,8 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 	sector_t submit_ptr = 0;
 	int ret;
 
-	ret = nilfs_btnode_submit_block(btnc, ptr, 0, READ, &bh, &submit_ptr);
+	ret = nilfs_btnode_submit_block(btnc, ptr, 0, REQ_OP_READ, 0, &bh,
+					&submit_ptr);
 	if (ret) {
 		if (ret != -EEXIST)
 			return ret;
@@ -496,7 +497,8 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 		     n > 0 && i < ra->ncmax; n--, i++) {
 			ptr2 = nilfs_btree_node_get_ptr(ra->node, i, ra->ncmax);
 
-			ret = nilfs_btnode_submit_block(btnc, ptr2, 0, READA,
+			ret = nilfs_btnode_submit_block(btnc, ptr2, 0,
+							REQ_OP_READ, REQ_RAHEAD,
 							&ra_bh, &submit_ptr);
 			if (likely(!ret || ret == -EEXIST))
 				brelse(ra_bh);
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 748ca23..1f18ffc 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -106,7 +106,7 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 	bh->b_blocknr = pbn;
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
-	submit_bh(READ, bh);
+	submit_bh(REQ_OP_READ, 0, bh);
 	if (vbn)
 		bh->b_blocknr = vbn;
  out:
@@ -143,7 +143,8 @@ int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 	int ret;
 
 	ret = nilfs_btnode_submit_block(&NILFS_I(inode)->i_btnode_cache,
-					vbn ? : pbn, pbn, READ, out_bh, &pbn);
+					vbn ? : pbn, pbn, REQ_OP_READ, 0,
+					out_bh, &pbn);
 	if (ret == -EEXIST) /* internal code (cache hit) */
 		ret = 0;
 	return ret;
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index dee34d9..febc510 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -120,7 +120,7 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 
 static int
 nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
-		       int mode, struct buffer_head **out_bh)
+		       int mode, int mode_flags, struct buffer_head **out_bh)
 {
 	struct buffer_head *bh;
 	__u64 blknum = 0;
@@ -134,7 +134,7 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
 	if (buffer_uptodate(bh))
 		goto out;
 
-	if (mode == READA) {
+	if (mode_flags & REQ_RAHEAD) {
 		if (!trylock_buffer(bh)) {
 			ret = -EBUSY;
 			goto failed_bh;
@@ -156,7 +156,7 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
 
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
-	submit_bh(mode, bh);
+	submit_bh(mode, mode_flags, bh);
 	ret = 0;
  out:
 	get_bh(bh);
@@ -178,7 +178,7 @@ static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
 	int i, nr_ra_blocks = NILFS_MDT_MAX_RA_BLOCKS;
 	int err;
 
-	err = nilfs_mdt_submit_block(inode, block, READ, &first_bh);
+	err = nilfs_mdt_submit_block(inode, block, REQ_OP_READ, 0, &first_bh);
 	if (err == -EEXIST) /* internal code */
 		goto out;
 
@@ -188,7 +188,8 @@ static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
 	if (readahead) {
 		blkoff = block + 1;
 		for (i = 0; i < nr_ra_blocks; i++, blkoff++) {
-			err = nilfs_mdt_submit_block(inode, blkoff, READA, &bh);
+			err = nilfs_mdt_submit_block(inode, blkoff, REQ_OP_READ,
+						     REQ_RAHEAD, &bh);
 			if (likely(!err || err == -EEXIST))
 				brelse(bh);
 			else if (err != -EBUSY)
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f47585b..b2451f2 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -195,8 +195,8 @@ static int nilfs_sync_super(struct super_block *sb, int flag)
  retry:
 	set_buffer_dirty(nilfs->ns_sbh[0]);
 	if (nilfs_test_opt(nilfs, BARRIER)) {
-		err = __sync_dirty_buffer(nilfs->ns_sbh[0],
-					  WRITE_SYNC | WRITE_FLUSH_FUA);
+		err = __sync_dirty_buffer(nilfs->ns_sbh[0], REQ_OP_WRITE,
+				WRITE_SYNC | WRITE_FLUSH_FUA);
 	} else {
 		err = sync_dirty_buffer(nilfs->ns_sbh[0]);
 	}
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 7521e11..57c64bd 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -362,7 +362,7 @@ handle_zblock:
 		for (i = 0; i < nr; i++) {
 			tbh = arr[i];
 			if (likely(!buffer_uptodate(tbh)))
-				submit_bh(READ, tbh);
+				submit_bh(REQ_OP_READ, 0, tbh);
 			else
 				ntfs_end_buffer_async_read(tbh, 1);
 		}
@@ -877,7 +877,7 @@ lock_retry_remap:
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(WRITE, bh);
+			submit_bh(REQ_OP_WRITE, 0, bh);
 			need_end_writeback = false;
 		}
 		bh = next;
@@ -1202,7 +1202,7 @@ lock_retry_remap:
 		BUG_ON(!buffer_mapped(tbh));
 		get_bh(tbh);
 		tbh->b_end_io = end_buffer_write_sync;
-		submit_bh(WRITE, tbh);
+		submit_bh(REQ_OP_WRITE, 0, tbh);
 	}
 	/* Synchronize the mft mirror now if not @sync. */
 	if (is_mft && !sync)
diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index f82498c..1fd482c 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -674,7 +674,7 @@ lock_retry_remap:
 		}
 		get_bh(tbh);
 		tbh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ, tbh);
+		submit_bh(REQ_OP_READ, 0, tbh);
 	}
 
 	/* Wait for io completion on all buffer heads. */
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 262561f..bcd3d84 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -553,7 +553,7 @@ static inline int ntfs_submit_bh_for_read(struct buffer_head *bh)
 	lock_buffer(bh);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_read_sync;
-	return submit_bh(READ, bh);
+	return submit_bh(REQ_OP_READ, 0, bh);
 }
 
 /**
diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index c71de29..1c95c41 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -821,7 +821,7 @@ map_vcn:
 			 * completed ignore errors afterwards as we can assume
 			 * that if one buffer worked all of them will work.
 			 */
-			submit_bh(WRITE, bh);
+			submit_bh(REQ_OP_WRITE, 0, bh);
 			if (should_wait) {
 				should_wait = false;
 				wait_on_buffer(bh);
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 3014a36..38c6f7a 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -592,7 +592,7 @@ int ntfs_sync_mft_mirror(ntfs_volume *vol, const unsigned long mft_no,
 			clear_buffer_dirty(tbh);
 			get_bh(tbh);
 			tbh->b_end_io = end_buffer_write_sync;
-			submit_bh(WRITE, tbh);
+			submit_bh(REQ_OP_WRITE, 0, tbh);
 		}
 		/* Wait on i/o completion of buffers. */
 		for (i_bhs = 0; i_bhs < nr_bhs; i_bhs++) {
@@ -785,7 +785,7 @@ int write_mft_record_nolock(ntfs_inode *ni, MFT_RECORD *m, int sync)
 		clear_buffer_dirty(tbh);
 		get_bh(tbh);
 		tbh->b_end_io = end_buffer_write_sync;
-		submit_bh(WRITE, tbh);
+		submit_bh(REQ_OP_WRITE, 0, tbh);
 	}
 	/* Synchronize the mft mirror now if not @sync. */
 	if (!sync && ni->mft_no < vol->mftmirr_size)
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index fe50ded..fb775c9 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -79,7 +79,7 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 
 	get_bh(bh); /* for end_buffer_write_sync() */
 	bh->b_end_io = end_buffer_write_sync;
-	submit_bh(WRITE, bh);
+	submit_bh(REQ_OP_WRITE, 0, bh);
 
 	wait_on_buffer(bh);
 
@@ -149,7 +149,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 		clear_buffer_uptodate(bh);
 		get_bh(bh); /* for end_buffer_read_sync() */
 		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(READ, bh);
+		submit_bh(REQ_OP_READ, 0, bh);
 	}
 
 	for (i = nr; i > 0; i--) {
@@ -305,7 +305,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 			if (validate)
 				set_buffer_needs_validate(bh);
 			bh->b_end_io = end_buffer_read_sync;
-			submit_bh(READ, bh);
+			submit_bh(REQ_OP_READ, 0, bh);
 			continue;
 		}
 	}
@@ -419,7 +419,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 	get_bh(bh); /* for end_buffer_write_sync() */
 	bh->b_end_io = end_buffer_write_sync;
 	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &di->i_check);
-	submit_bh(WRITE, bh);
+	submit_bh(REQ_OP_WRITE, 0, bh);
 
 	wait_on_buffer(bh);
 
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 3d8e7e6..f491ef4 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2667,7 +2667,7 @@ static int reiserfs_write_full_page(struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(WRITE, bh);
+			submit_bh(REQ_OP_WRITE, 0, bh);
 			nr++;
 		}
 		put_bh(bh);
@@ -2727,7 +2727,7 @@ fail:
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
 			clear_buffer_dirty(bh);
-			submit_bh(WRITE, bh);
+			submit_bh(REQ_OP_WRITE, 0, bh);
 			nr++;
 		}
 		put_bh(bh);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 9d6486d..df69581 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -654,7 +654,7 @@ static void submit_logged_buffer(struct buffer_head *bh)
 		BUG();
 	if (!buffer_uptodate(bh))
 		BUG();
-	submit_bh(WRITE, bh);
+	submit_bh(REQ_OP_WRITE, 0, bh);
 }
 
 static void submit_ordered_buffer(struct buffer_head *bh)
@@ -664,7 +664,7 @@ static void submit_ordered_buffer(struct buffer_head *bh)
 	clear_buffer_dirty(bh);
 	if (!buffer_uptodate(bh))
 		BUG();
-	submit_bh(WRITE, bh);
+	submit_bh(REQ_OP_WRITE, 0, bh);
 }
 
 #define CHUNK_SIZE 32
@@ -1113,7 +1113,8 @@ static int flush_commit_list(struct super_block *s,
 		mark_buffer_dirty(jl->j_commit_bh) ;
 		depth = reiserfs_write_unlock_nested(s);
 		if (reiserfs_barrier_flush(s))
-			__sync_dirty_buffer(jl->j_commit_bh, WRITE_FLUSH_FUA);
+			__sync_dirty_buffer(jl->j_commit_bh, REQ_OP_WRITE,
+					    WRITE_FLUSH_FUA);
 		else
 			sync_dirty_buffer(jl->j_commit_bh);
 		reiserfs_write_lock_nested(s, depth);
@@ -1271,7 +1272,8 @@ static int _update_journal_header_block(struct super_block *sb,
 		depth = reiserfs_write_unlock_nested(sb);
 
 		if (reiserfs_barrier_flush(sb))
-			__sync_dirty_buffer(journal->j_header_bh, WRITE_FLUSH_FUA);
+			__sync_dirty_buffer(journal->j_header_bh, REQ_OP_WRITE,
+					    WRITE_FLUSH_FUA);
 		else
 			sync_dirty_buffer(journal->j_header_bh);
 
@@ -2271,7 +2273,7 @@ abort_replay:
 	/* flush out the real blocks */
 	for (i = 0; i < get_desc_trans_len(desc); i++) {
 		set_buffer_dirty(real_blocks[i]);
-		write_dirty_buffer(real_blocks[i], WRITE);
+		write_dirty_buffer(real_blocks[i], 0);
 	}
 	for (i = 0; i < get_desc_trans_len(desc); i++) {
 		wait_on_buffer(real_blocks[i]);
diff --git a/fs/ufs/util.c b/fs/ufs/util.c
index b6c2f94..5f68b1a 100644
--- a/fs/ufs/util.c
+++ b/fs/ufs/util.c
@@ -118,7 +118,7 @@ void ubh_sync_block(struct ufs_buffer_head *ubh)
 		unsigned i;
 
 		for (i = 0; i < ubh->count; i++)
-			write_dirty_buffer(ubh->bh[i], WRITE);
+			write_dirty_buffer(ubh->bh[i], 0);
 
 		for (i = 0; i < ubh->count; i++)
 			wait_on_buffer(ubh->bh[i]);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e6797de..6edc8dd 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -189,10 +189,11 @@ void unlock_buffer(struct buffer_head *bh);
 void __lock_buffer(struct buffer_head *bh);
 void ll_rw_block(int, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
-int __sync_dirty_buffer(struct buffer_head *bh, int rw);
-void write_dirty_buffer(struct buffer_head *bh, int rw);
-int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags);
-int submit_bh(int, struct buffer_head *);
+int __sync_dirty_buffer(struct buffer_head *bh, int op, int op_flags);
+void write_dirty_buffer(struct buffer_head *bh, int op_flags);
+int _submit_bh(int op, int op_flags, struct buffer_head *bh,
+	       unsigned long bio_flags);
+int submit_bh(int, int, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
-- 
1.8.3.1
