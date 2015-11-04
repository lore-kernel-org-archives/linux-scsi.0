From: mchristi@redhat.com
Subject: [PATCH 23/32] block/fs: pass in op and flags to ll_rw_block
Date: Wed,  4 Nov 2015 16:08:20 -0600
Message-ID: <1446674909-5371-24-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This has ll_rw_block users pass in the request op and flags seperately
instead of as a bitmap.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/buffer.c                 | 19 ++++++++++---------
 fs/ext4/inode.c             |  6 +++---
 fs/ext4/namei.c             |  3 ++-
 fs/ext4/super.c             |  2 +-
 fs/gfs2/bmap.c              |  2 +-
 fs/gfs2/meta_io.c           |  4 ++--
 fs/gfs2/quota.c             |  2 +-
 fs/isofs/compress.c         |  2 +-
 fs/jbd2/journal.c           |  2 +-
 fs/jbd2/recovery.c          |  4 ++--
 fs/ocfs2/aops.c             |  2 +-
 fs/ocfs2/super.c            |  2 +-
 fs/reiserfs/journal.c       |  8 ++++----
 fs/reiserfs/stree.c         |  4 ++--
 fs/reiserfs/super.c         |  2 +-
 fs/squashfs/block.c         |  4 ++--
 fs/udf/dir.c                |  2 +-
 fs/udf/directory.c          |  2 +-
 fs/udf/inode.c              |  2 +-
 fs/ufs/balloc.c             |  2 +-
 include/linux/buffer_head.h |  2 +-
 21 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index cd07d86..ba84126 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -595,7 +595,7 @@ void write_boundary_block(struct block_device *bdev,
 	struct buffer_head *bh = __find_get_block(bdev, bblock + 1, blocksize);
 	if (bh) {
 		if (buffer_dirty(bh))
-			ll_rw_block(WRITE, 1, &bh);
+			ll_rw_block(REQ_OP_WRITE, 0, 1, &bh);
 		put_bh(bh);
 	}
 }
@@ -1406,7 +1406,7 @@ void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = __getblk(bdev, block, size);
 	if (likely(bh)) {
-		ll_rw_block(READA, 1, &bh);
+		ll_rw_block(REQ_OP_READ, REQ_RAHEAD, 1, &bh);
 		brelse(bh);
 	}
 }
@@ -1966,7 +1966,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		     (block_start < from || block_end > to)) {
-			ll_rw_block(READ, 1, &bh);
+			ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 			*wait_bh++=bh;
 		}
 	}
@@ -2883,7 +2883,7 @@ int block_truncate_page(struct address_space *mapping,
 
 	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
 		err = -EIO;
-		ll_rw_block(READ, 1, &bh);
+		ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 		wait_on_buffer(bh);
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
@@ -3081,7 +3081,8 @@ EXPORT_SYMBOL(submit_bh);
 
 /**
  * ll_rw_block: low-level access to block devices (DEPRECATED)
- * @rw: whether to %READ or %WRITE or maybe %READA (readahead)
+ * @op: REQ_OP_READ or REQ_OP_WRITE
+ * op_flags: rq_flag_bits
  * @nr: number of &struct buffer_heads in the array
  * @bhs: array of pointers to &struct buffer_head
  *
@@ -3104,7 +3105,7 @@ EXPORT_SYMBOL(submit_bh);
  * All of the buffers must be for the same device, and must also be a
  * multiple of the current approved size for the device.
  */
-void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
+void ll_rw_block(int op, int op_flags, int nr, struct buffer_head *bhs[])
 {
 	int i;
 
@@ -3113,18 +3114,18 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 
 		if (!trylock_buffer(bh))
 			continue;
-		if (rw == WRITE) {
+		if (op == REQ_OP_WRITE) {
 			if (test_clear_buffer_dirty(bh)) {
 				bh->b_end_io = end_buffer_write_sync;
 				get_bh(bh);
-				submit_bh(REQ_OP_WRITE, 0, bh);
+				submit_bh(REQ_OP_WRITE, op_flags, bh);
 				continue;
 			}
 		} else {
 			if (!buffer_uptodate(bh)) {
 				bh->b_end_io = end_buffer_read_sync;
 				get_bh(bh);
-				submit_bh(rw, 0, bh);
+				submit_bh(REQ_OP_READ, op_flags, bh);
 				continue;
 			}
 		}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f34ef29..dd2e197 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -791,7 +791,7 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 		return bh;
 	if (!bh || buffer_uptodate(bh))
 		return bh;
-	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
+	ll_rw_block(REQ_OP_READ,  REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
@@ -948,7 +948,7 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		    (block_start < from || block_end > to)) {
-			ll_rw_block(READ, 1, &bh);
+			ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 			*wait_bh++ = bh;
 			decrypt = ext4_encrypted_inode(inode) &&
 				S_ISREG(inode->i_mode);
@@ -3383,7 +3383,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 
 	if (!buffer_uptodate(bh)) {
 		err = -EIO;
-		ll_rw_block(READ, 1, &bh);
+		ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 		wait_on_buffer(bh);
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9f61e76..0336536 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1438,7 +1438,8 @@ restart:
 				}
 				bh_use[ra_max] = bh;
 				if (bh)
-					ll_rw_block(READ | REQ_META | REQ_PRIO,
+					ll_rw_block(REQ_OP_READ,
+						    REQ_META | REQ_PRIO,
 						    1, &bh);
 			}
 		}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d9e4329..037dd9e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4512,7 +4512,7 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 		goto out_bdev;
 	}
 	journal->j_private = sb;
-	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &journal->j_sb_buffer);
+	ll_rw_block(REQ_OP_READ, REQ_META | REQ_PRIO, 1, &journal->j_sb_buffer);
 	wait_on_buffer(journal->j_sb_buffer);
 	if (!buffer_uptodate(journal->j_sb_buffer)) {
 		ext4_msg(sb, KERN_ERR, "I/O error on journal device");
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 967154c..1a22952 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -974,7 +974,7 @@ static int gfs2_block_truncate_page(struct address_space *mapping, loff_t from)
 
 	if (!buffer_uptodate(bh)) {
 		err = -EIO;
-		ll_rw_block(READ, 1, &bh);
+		ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 		wait_on_buffer(bh);
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index ff483bc..264c95c 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -379,7 +379,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 	if (buffer_uptodate(first_bh))
 		goto out;
 	if (!buffer_locked(first_bh))
-		ll_rw_block(READ_SYNC | REQ_META, 1, &first_bh);
+		ll_rw_block(REQ_OP_READ, READ_SYNC | REQ_META, 1, &first_bh);
 
 	dblock++;
 	extlen--;
@@ -388,7 +388,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 		bh = gfs2_getbuf(gl, dblock, CREATE);
 
 		if (!buffer_uptodate(bh) && !buffer_locked(bh))
-			ll_rw_block(READA | REQ_META, 1, &bh);
+			ll_rw_block(REQ_OP_READ, REQ_RAHEAD | REQ_META, 1, &bh);
 		brelse(bh);
 		dblock++;
 		extlen--;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 3a31226..841f15a 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -697,7 +697,7 @@ static int gfs2_write_buf_to_page(struct gfs2_inode *ip, unsigned long index,
 		if (PageUptodate(page))
 			set_buffer_uptodate(bh);
 		if (!buffer_uptodate(bh)) {
-			ll_rw_block(READ | REQ_META, 1, &bh);
+			ll_rw_block(REQ_OP_READ, REQ_META, 1, &bh);
 			wait_on_buffer(bh);
 			if (!buffer_uptodate(bh))
 				goto unlock_out;
diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index f311bf0..f9b5fc8 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -81,7 +81,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 	blocknum = block_start >> bufshift;
 	memset(bhs, 0, (needblocks + 1) * sizeof(struct buffer_head *));
 	haveblocks = isofs_get_blocks(inode, blocknum, bhs, needblocks);
-	ll_rw_block(READ, haveblocks, bhs);
+	ll_rw_block(REQ_OP_READ, 0, haveblocks, bhs);
 
 	curbh = 0;
 	curpage = 0;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e3855b0..4ba109f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1474,7 +1474,7 @@ static int journal_get_superblock(journal_t *journal)
 
 	J_ASSERT(bh != NULL);
 	if (!buffer_uptodate(bh)) {
-		ll_rw_block(READ, 1, &bh);
+		ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			printk(KERN_ERR
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index a9079d0..3147a89 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -104,7 +104,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
 		if (!buffer_uptodate(bh) && !buffer_locked(bh)) {
 			bufs[nbufs++] = bh;
 			if (nbufs == MAXBUF) {
-				ll_rw_block(READ, nbufs, bufs);
+				ll_rw_block(REQ_OP_READ, 0, nbufs, bufs);
 				journal_brelse_array(bufs, nbufs);
 				nbufs = 0;
 			}
@@ -113,7 +113,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
 	}
 
 	if (nbufs)
-		ll_rw_block(READ, nbufs, bufs);
+		ll_rw_block(REQ_OP_READ, 0, nbufs, bufs);
 	err = 0;
 
 failed:
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 64b11d9..247ad9d 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1141,7 +1141,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 			   !buffer_new(bh) &&
 			   ocfs2_should_read_blk(inode, page, block_start) &&
 			   (block_start < from || block_end > to)) {
-			ll_rw_block(READ, 1, &bh);
+			ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 			*wait_bh++=bh;
 		}
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2de4c8a..e860b60 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1837,7 +1837,7 @@ static int ocfs2_get_sector(struct super_block *sb,
 	if (!buffer_dirty(*bh))
 		clear_buffer_uptodate(*bh);
 	unlock_buffer(*bh);
-	ll_rw_block(READ, 1, bh);
+	ll_rw_block(REQ_OP_READ, 0, 1, bh);
 	wait_on_buffer(*bh);
 	if (!buffer_uptodate(*bh)) {
 		mlog_errno(-EIO);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index df69581..feff389 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -872,7 +872,7 @@ loop_next:
 		 */
 		if (buffer_dirty(bh) && unlikely(bh->b_page->mapping == NULL)) {
 			spin_unlock(lock);
-			ll_rw_block(WRITE, 1, &bh);
+			ll_rw_block(REQ_OP_WRITE, 0, 1, &bh);
 			spin_lock(lock);
 		}
 		put_bh(bh);
@@ -1059,7 +1059,7 @@ static int flush_commit_list(struct super_block *s,
 		if (tbh) {
 			if (buffer_dirty(tbh)) {
 		            depth = reiserfs_write_unlock_nested(s);
-			    ll_rw_block(WRITE, 1, &tbh);
+			    ll_rw_block(REQ_OP_WRITE, 0, 1, &tbh);
 			    reiserfs_write_lock_nested(s, depth);
 			}
 			put_bh(tbh) ;
@@ -2248,7 +2248,7 @@ abort_replay:
 		}
 	}
 	/* read in the log blocks, memcpy to the corresponding real block */
-	ll_rw_block(READ, get_desc_trans_len(desc), log_blocks);
+	ll_rw_block(REQ_OP_READ, 0, get_desc_trans_len(desc), log_blocks);
 	for (i = 0; i < get_desc_trans_len(desc); i++) {
 
 		wait_on_buffer(log_blocks[i]);
@@ -2350,7 +2350,7 @@ static struct buffer_head *reiserfs_breada(struct block_device *dev,
 		} else
 			bhlist[j++] = bh;
 	}
-	ll_rw_block(READ, j, bhlist);
+	ll_rw_block(REQ_OP_READ, 0, j, bhlist);
 	for (i = 1; i < j; i++)
 		brelse(bhlist[i]);
 	bh = bhlist[0];
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 24cbe01..e887401 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -551,7 +551,7 @@ static int search_by_key_reada(struct super_block *s,
 		if (!buffer_uptodate(bh[j])) {
 			if (depth == -1)
 				depth = reiserfs_write_unlock_nested(s);
-			ll_rw_block(READA, 1, bh + j);
+			ll_rw_block(REQ_OP_READ, REQ_RAHEAD, 1, bh + j);
 		}
 		brelse(bh[j]);
 	}
@@ -660,7 +660,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,
 			if (!buffer_uptodate(bh) && depth == -1)
 				depth = reiserfs_write_unlock_nested(sb);
 
-			ll_rw_block(READ, 1, &bh);
+			ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 			wait_on_buffer(bh);
 
 			if (depth != -1)
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 4a62fe8..68f5f5c 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1659,7 +1659,7 @@ static int read_super_block(struct super_block *s, int offset)
 /* after journal replay, reread all bitmap and super blocks */
 static int reread_meta_blocks(struct super_block *s)
 {
-	ll_rw_block(READ, 1, &SB_BUFFER_WITH_SB(s));
+	ll_rw_block(REQ_OP_READ, 0, 1, &SB_BUFFER_WITH_SB(s));
 	wait_on_buffer(SB_BUFFER_WITH_SB(s));
 	if (!buffer_uptodate(SB_BUFFER_WITH_SB(s))) {
 		reiserfs_warning(s, "reiserfs-2504", "error reading the super");
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 0cea9b9..59375be 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -124,7 +124,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 				goto block_release;
 			bytes += msblk->devblksize;
 		}
-		ll_rw_block(READ, b, bh);
+		ll_rw_block(REQ_OP_READ, 0, b, bh);
 	} else {
 		/*
 		 * Metadata block.
@@ -156,7 +156,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 				goto block_release;
 			bytes += msblk->devblksize;
 		}
-		ll_rw_block(READ, b - 1, bh + 1);
+		ll_rw_block(REQ_OP_READ, 0, b - 1, bh + 1);
 	}
 
 	for (i = 0; i < b; i++) {
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 541d9c6..1792fa0 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -113,7 +113,7 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(READA, num, bha);
+				ll_rw_block(REQ_OP_READ, REQ_RAHEAD, num, bha);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index c763fda..988d535 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -87,7 +87,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(READA, num, bha);
+				ll_rw_block(REQ_OP_READ, REQ_RAHEAD, num, bha);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 8d0b3ad..240c0cc 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1191,7 +1191,7 @@ struct buffer_head *udf_bread(struct inode *inode, int block,
 	if (buffer_uptodate(bh))
 		return bh;
 
-	ll_rw_block(READ, 1, &bh);
+	ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index dc5fae6..26a3bb1 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -292,7 +292,7 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
 			if (!buffer_mapped(bh))
 					map_bh(bh, inode->i_sb, oldb + pos);
 			if (!buffer_uptodate(bh)) {
-				ll_rw_block(READ, 1, &bh);
+				ll_rw_block(REQ_OP_READ, 0, 1, &bh);
 				wait_on_buffer(bh);
 				if (!buffer_uptodate(bh)) {
 					ufs_error(inode->i_sb, __func__,
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 6edc8dd..8505ee7 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -187,7 +187,7 @@ struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
 void unlock_buffer(struct buffer_head *bh);
 void __lock_buffer(struct buffer_head *bh);
-void ll_rw_block(int, int, struct buffer_head * bh[]);
+void ll_rw_block(int, int, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, int op, int op_flags);
 void write_dirty_buffer(struct buffer_head *bh, int op_flags);
-- 
1.8.3.1
