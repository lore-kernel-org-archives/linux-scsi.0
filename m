From: mchristi@redhat.com
Subject: [PATCH 02/32] block/fs/mm: prepare submit_bio_wait users for bi_rw split
Date: Wed,  4 Nov 2015 16:07:59 -0600
Message-ID: <1446674909-5371-3-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch prepares submit_bio_wait callers for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers now pass them in seperately.

Temp issue: When the fs.h read/write types, like WRITE_SYNC or
WRITE_FUA, are used we still pass in the operation along with the
flags in the flags argument. When all the code has been converted
that will be cleaned up. It is left in here for compat and git
bisect use and to try and make the patches smaller.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/bio.c                |  8 ++++----
 block/blk-flush.c          |  2 +-
 drivers/md/bcache/debug.c  |  4 ++--
 drivers/md/md.c            |  2 +-
 drivers/md/raid1.c         |  2 +-
 drivers/md/raid10.c        |  2 +-
 fs/btrfs/check-integrity.c |  8 ++++----
 fs/btrfs/check-integrity.h |  2 +-
 fs/btrfs/extent_io.c       |  2 +-
 fs/btrfs/scrub.c           |  6 +++---
 fs/ext4/crypto.c           |  2 +-
 fs/f2fs/segment.c          |  4 ++--
 fs/hfsplus/hfsplus_fs.h    |  2 +-
 fs/hfsplus/part_tbl.c      |  5 +++--
 fs/hfsplus/super.c         |  6 ++++--
 fs/hfsplus/wrapper.c       | 14 ++++++++------
 fs/logfs/dev_bdev.c        |  2 +-
 include/linux/bio.h        |  2 +-
 kernel/power/swap.c        | 30 ++++++++++++++++++------------
 19 files changed, 58 insertions(+), 47 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ad3f276..610c704 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -859,21 +859,21 @@ static void submit_bio_wait_endio(struct bio *bio)
 
 /**
  * submit_bio_wait - submit a bio, and wait until it completes
- * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
+ * @op: REQ_OP_*
+ * @flags: rq_flag_bits
  * @bio: The &struct bio which describes the I/O
  *
  * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
  * bio_endio() on failure.
  */
-int submit_bio_wait(int rw, struct bio *bio)
+int submit_bio_wait(int op, int flags, struct bio *bio)
 {
 	struct submit_bio_ret ret;
 
-	rw |= REQ_SYNC;
 	init_completion(&ret.event);
 	bio->bi_private = &ret;
 	bio->bi_end_io = submit_bio_wait_endio;
-	submit_bio(rw, bio);
+	submit_bio(op | flags | REQ_SYNC, bio);
 	wait_for_completion(&ret.event);
 
 	return ret.error;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 9c423e5..f707ba1 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -485,7 +485,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_bdev = bdev;
 
-	ret = submit_bio_wait(WRITE_FLUSH, bio);
+	ret = submit_bio_wait(REQ_OP_WRITE, WRITE_FLUSH, bio);
 
 	/*
 	 * The driver must store the error location in ->bi_sector, if
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8b1f1d5..001f5f1 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -54,7 +54,7 @@ void bch_btree_verify(struct btree *b)
 	bio->bi_iter.bi_size	= KEY_SIZE(&v->key) << 9;
 	bch_bio_map(bio, sorted);
 
-	submit_bio_wait(REQ_META|READ_SYNC, bio);
+	submit_bio_wait(REQ_OP_READ, READ_SYNC, bio);
 	bch_bbio_free(bio, b->c);
 
 	memcpy(ondisk, sorted, KEY_SIZE(&v->key) << 9);
@@ -117,7 +117,7 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	if (bio_alloc_pages(check, GFP_NOIO))
 		goto out_put;
 
-	submit_bio_wait(READ_SYNC, check);
+	submit_bio_wait(REQ_OP_READ, READ_SYNC, check);
 
 	bio_for_each_segment(bv, bio, iter) {
 		void *p1 = kmap_atomic(bv.bv_page);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c702de1..1ca5959 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -771,7 +771,7 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 	else
 		bio->bi_iter.bi_sector = sector + rdev->data_offset;
 	bio_add_page(bio, page, size, 0);
-	submit_bio_wait(rw, bio);
+	submit_bio_wait(rw, 0, bio);
 
 	ret = !bio->bi_error;
 	bio_put(bio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d9d031e..527fdf5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2195,7 +2195,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_iter.bi_sector += rdev->data_offset;
 		wbio->bi_bdev = rdev->bdev;
-		if (submit_bio_wait(WRITE, wbio) < 0)
+		if (submit_bio_wait(REQ_OP_WRITE, 0, wbio) < 0)
 			/* failure! */
 			ok = rdev_set_badblocks(rdev, sector,
 						sectors, 0)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 96f3659..69352a6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2470,7 +2470,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 				   choose_data_offset(r10_bio, rdev) +
 				   (sector - r10_bio->sector));
 		wbio->bi_bdev = rdev->bdev;
-		if (submit_bio_wait(WRITE, wbio) < 0)
+		if (submit_bio_wait(REQ_OP_WRITE, 0, wbio) < 0)
 			/* Failure! */
 			ok = rdev_set_badblocks(rdev, sector,
 						sectors, 0)
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 541fbfa..fd50b2f 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1695,7 +1695,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 			       "btrfsic: error, failed to add a single page!\n");
 			return -1;
 		}
-		if (submit_bio_wait(READ, bio)) {
+		if (submit_bio_wait(REQ_OP_READ, 0, bio)) {
 			printk(KERN_INFO
 			       "btrfsic: read error at logical %llu dev %s!\n",
 			       block_ctx->start, block_ctx->dev->name);
@@ -3064,10 +3064,10 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 	submit_bio(rw, bio);
 }
 
-int btrfsic_submit_bio_wait(int rw, struct bio *bio)
+int btrfsic_submit_bio_wait(int op, int op_flags, struct bio *bio)
 {
-	__btrfsic_submit_bio(rw, bio);
-	return submit_bio_wait(rw, bio);
+	__btrfsic_submit_bio(op | op_flags, bio);
+	return submit_bio_wait(op, op_flags, bio);
 }
 
 int btrfsic_mount(struct btrfs_root *root,
diff --git a/fs/btrfs/check-integrity.h b/fs/btrfs/check-integrity.h
index 13b8566..13b0d54 100644
--- a/fs/btrfs/check-integrity.h
+++ b/fs/btrfs/check-integrity.h
@@ -22,7 +22,7 @@
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 int btrfsic_submit_bh(int rw, struct buffer_head *bh);
 void btrfsic_submit_bio(int rw, struct bio *bio);
-int btrfsic_submit_bio_wait(int rw, struct bio *bio);
+int btrfsic_submit_bio_wait(int op, int op_flags, struct bio *bio);
 #else
 #define btrfsic_submit_bh submit_bh
 #define btrfsic_submit_bio submit_bio
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3915c94..9a68a83 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2071,7 +2071,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 	bio->bi_bdev = dev->bdev;
 	bio_add_page(bio, page, length, pg_offset);
 
-	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio)) {
+	if (btrfsic_submit_bio_wait(REQ_OP_WRITE, WRITE_SYNC, bio)) {
 		/* try to remap that extent elsewhere? */
 		bio_put(bio);
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a39f5d1..9cb6f9a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1510,7 +1510,7 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 		} else {
 			bio->bi_iter.bi_sector = page->physical >> 9;
 
-			if (btrfsic_submit_bio_wait(READ, bio))
+			if (btrfsic_submit_bio_wait(REQ_OP_READ, 0, bio))
 				sblock->no_io_error_seen = 0;
 		}
 
@@ -1644,7 +1644,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 			return -EIO;
 		}
 
-		if (btrfsic_submit_bio_wait(WRITE, bio)) {
+		if (btrfsic_submit_bio_wait(REQ_OP_WRITE, 0, bio)) {
 			btrfs_dev_stat_inc_and_print(page_bad->dev,
 				BTRFS_DEV_STAT_WRITE_ERRS);
 			btrfs_dev_replace_stats_inc(
@@ -4397,7 +4397,7 @@ leave_with_eio:
 		return -EIO;
 	}
 
-	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio))
+	if (btrfsic_submit_bio_wait(REQ_OP_WRITE, WRITE_SYNC, bio))
 		goto leave_with_eio;
 
 	bio_put(bio);
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 4573155..2782a95 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -444,7 +444,7 @@ int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex)
 			bio_put(bio);
 			goto errout;
 		}
-		err = submit_bio_wait(WRITE, bio);
+		err = submit_bio_wait(REQ_OP_WRITE, 0, bio);
 		bio_put(bio);
 		if (err)
 			goto errout;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 78e6d06..7d2972b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -340,7 +340,7 @@ repeat:
 		fcc->dispatch_list = llist_reverse_order(fcc->dispatch_list);
 
 		bio->bi_bdev = sbi->sb->s_bdev;
-		ret = submit_bio_wait(WRITE_FLUSH, bio);
+		ret = submit_bio_wait(REQ_OP_WRITE, WRITE_FLUSH, bio);
 
 		llist_for_each_entry_safe(cmd, next,
 					  fcc->dispatch_list, llnode) {
@@ -372,7 +372,7 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 		int ret;
 
 		bio->bi_bdev = sbi->sb->s_bdev;
-		ret = submit_bio_wait(WRITE_FLUSH, bio);
+		ret = submit_bio_wait(REQ_OP_WRITE, WRITE_FLUSH, bio);
 		bio_put(bio);
 		return ret;
 	}
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index f91a1fa..7288375 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -525,7 +525,7 @@ int hfsplus_compare_dentry(const struct dentry *parent,
 
 /* wrapper.c */
 int hfsplus_submit_bio(struct super_block *sb, sector_t sector, void *buf,
-		       void **data, int rw);
+		       void **data, int op, int flags);
 int hfsplus_read_wrapper(struct super_block *sb);
 
 /* time macros */
diff --git a/fs/hfsplus/part_tbl.c b/fs/hfsplus/part_tbl.c
index eb355d8..63164eb 100644
--- a/fs/hfsplus/part_tbl.c
+++ b/fs/hfsplus/part_tbl.c
@@ -112,7 +112,8 @@ static int hfs_parse_new_pmap(struct super_block *sb, void *buf,
 		if ((u8 *)pm - (u8 *)buf >= buf_size) {
 			res = hfsplus_submit_bio(sb,
 						 *part_start + HFS_PMAP_BLK + i,
-						 buf, (void **)&pm, READ);
+						 buf, (void **)&pm, REQ_OP_READ,
+						 0);
 			if (res)
 				return res;
 		}
@@ -136,7 +137,7 @@ int hfs_part_find(struct super_block *sb,
 		return -ENOMEM;
 
 	res = hfsplus_submit_bio(sb, *part_start + HFS_PMAP_BLK,
-				 buf, &data, READ);
+				 buf, &data, REQ_OP_READ, 0);
 	if (res)
 		goto out;
 
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 7302d96..f9ea6aa 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -219,7 +219,8 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 
 	error2 = hfsplus_submit_bio(sb,
 				   sbi->part_start + HFSPLUS_VOLHEAD_SECTOR,
-				   sbi->s_vhdr_buf, NULL, WRITE_SYNC);
+				   sbi->s_vhdr_buf, NULL, REQ_OP_WRITE,
+				   WRITE_SYNC);
 	if (!error)
 		error = error2;
 	if (!write_backup)
@@ -227,7 +228,8 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 
 	error2 = hfsplus_submit_bio(sb,
 				  sbi->part_start + sbi->sect_count - 2,
-				  sbi->s_backup_vhdr_buf, NULL, WRITE_SYNC);
+				  sbi->s_backup_vhdr_buf, NULL, REQ_OP_WRITE,
+				  WRITE_SYNC);
 	if (!error)
 		error2 = error;
 out:
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index cc62356..ac5750b 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -30,7 +30,8 @@ struct hfsplus_wd {
  * @sector: block to read or write, for blocks of HFSPLUS_SECTOR_SIZE bytes
  * @buf: buffer for I/O
  * @data: output pointer for location of requested data
- * @rw: direction of I/O
+ * @op: direction of I/O
+ * @flags: request op flags
  *
  * The unit of I/O is hfsplus_min_io_size(sb), which may be bigger than
  * HFSPLUS_SECTOR_SIZE, and @buf must be sized accordingly. On reads
@@ -44,7 +45,7 @@ struct hfsplus_wd {
  * will work correctly.
  */
 int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
-		void *buf, void **data, int rw)
+		       void *buf, void **data, int op, int flags)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -66,7 +67,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = sb->s_bdev;
 
-	if (!(rw & WRITE) && data)
+	if (!(op == WRITE) && data)
 		*data = (u8 *)buf + offset;
 
 	while (io_size > 0) {
@@ -83,7 +84,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 		buf = (u8 *)buf + len;
 	}
 
-	ret = submit_bio_wait(rw, bio);
+	ret = submit_bio_wait(op, flags, bio);
 out:
 	bio_put(bio);
 	return ret < 0 ? ret : 0;
@@ -181,7 +182,7 @@ int hfsplus_read_wrapper(struct super_block *sb)
 reread:
 	error = hfsplus_submit_bio(sb, part_start + HFSPLUS_VOLHEAD_SECTOR,
 				   sbi->s_vhdr_buf, (void **)&sbi->s_vhdr,
-				   READ);
+				   REQ_OP_READ, 0);
 	if (error)
 		goto out_free_backup_vhdr;
 
@@ -213,7 +214,8 @@ reread:
 
 	error = hfsplus_submit_bio(sb, part_start + part_size - 2,
 				   sbi->s_backup_vhdr_buf,
-				   (void **)&sbi->s_backup_vhdr, READ);
+				   (void **)&sbi->s_backup_vhdr, REQ_OP_READ,
+				   0);
 	if (error)
 		goto out_free_backup_vhdr;
 
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index a7fdbd8..149c480 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -30,7 +30,7 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio.bi_iter.bi_sector = page->index * (PAGE_SIZE >> 9);
 	bio.bi_iter.bi_size = PAGE_SIZE;
 
-	return submit_bio_wait(rw, &bio);
+	return submit_bio_wait(rw, 0, &bio);
 }
 
 static int bdev_readpage(void *_sb, struct page *page)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b9b6e04..7796e0b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -441,7 +441,7 @@ static inline void bio_io_error(struct bio *bio)
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
-extern int submit_bio_wait(int rw, struct bio *bio);
+extern int submit_bio_wait(int op, int flags, struct bio *bio);
 extern void bio_advance(struct bio *, unsigned);
 
 extern void bio_init(struct bio *);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index b2066fb..aa4ca997 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -250,7 +250,7 @@ static void hib_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
-static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
+static int hib_submit_io(int rw, int flags, pgoff_t page_off, void *addr,
 		struct hib_bio_batch *hb)
 {
 	struct page *page = virt_to_page(addr);
@@ -274,7 +274,7 @@ static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
 		atomic_inc(&hb->count);
 		submit_bio(rw, bio);
 	} else {
-		error = submit_bio_wait(rw, bio);
+		error = submit_bio_wait(rw, flags, bio);
 		bio_put(bio);
 	}
 
@@ -295,7 +295,8 @@ static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
 {
 	int error;
 
-	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(REQ_OP_READ, READ_SYNC, swsusp_resume_block,
+		      swsusp_header, NULL);
 	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
@@ -304,8 +305,8 @@ static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
 		swsusp_header->flags = flags;
 		if (flags & SF_CRC32_MODE)
 			swsusp_header->crc32 = handle->crc32;
-		error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
-					swsusp_header, NULL);
+		error = hib_submit_io(REQ_OP_WRITE, WRITE_SYNC,
+				      swsusp_resume_block, swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Swap header not found!\n");
 		error = -ENODEV;
@@ -378,7 +379,7 @@ static int write_page(void *buf, sector_t offset, struct hib_bio_batch *hb)
 	} else {
 		src = buf;
 	}
-	return hib_submit_io(WRITE_SYNC, offset, src, hb);
+	return hib_submit_io(REQ_OP_WRITE, WRITE_SYNC, offset, src, hb);
 }
 
 static void release_swap_writer(struct swap_map_handle *handle)
@@ -981,7 +982,8 @@ static int get_swap_reader(struct swap_map_handle *handle,
 			return -ENOMEM;
 		}
 
-		error = hib_submit_io(READ_SYNC, offset, tmp->map, NULL);
+		error = hib_submit_io(REQ_OP_READ, READ_SYNC, offset,
+				      tmp->map, NULL);
 		if (error) {
 			release_swap_reader(handle);
 			return error;
@@ -1005,7 +1007,7 @@ static int swap_read_page(struct swap_map_handle *handle, void *buf,
 	offset = handle->cur->entries[handle->k];
 	if (!offset)
 		return -EFAULT;
-	error = hib_submit_io(READ_SYNC, offset, buf, hb);
+	error = hib_submit_io(REQ_OP_READ, READ_SYNC, offset, buf, hb);
 	if (error)
 		return error;
 	if (++handle->k >= MAP_PAGE_ENTRIES) {
@@ -1507,7 +1509,8 @@ int swsusp_check(void)
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		clear_page(swsusp_header);
-		error = hib_submit_io(READ_SYNC, swsusp_resume_block,
+		error = hib_submit_io(REQ_OP_READ, READ_SYNC,
+					swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
 			goto put;
@@ -1515,7 +1518,8 @@ int swsusp_check(void)
 		if (!memcmp(HIBERNATE_SIG, swsusp_header->sig, 10)) {
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
-			error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
+			error = hib_submit_io(REQ_OP_WRITE, WRITE_SYNC,
+						swsusp_resume_block,
 						swsusp_header, NULL);
 		} else {
 			error = -EINVAL;
@@ -1559,10 +1563,12 @@ int swsusp_unmark(void)
 {
 	int error;
 
-	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(REQ_OP_READ, READ_SYNC, swsusp_resume_block,
+		      swsusp_header, NULL);
 	if (!memcmp(HIBERNATE_SIG,swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->sig,swsusp_header->orig_sig, 10);
-		error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
+		error = hib_submit_io(REQ_OP_WRITE, WRITE_SYNC,
+					swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Cannot find swsusp signature!\n");
-- 
1.8.3.1

