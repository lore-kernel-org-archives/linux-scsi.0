From: mchristi@redhat.com
Subject: [PATCH 09/32] btrfs: prepare for bi_rw split
Date: Wed,  4 Nov 2015 16:08:06 -0600
Message-ID: <1446674909-5371-10-git-send-email-mchristi@redhat.com>
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

This patch prepares btrfs's submit_bio use for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers will now pass them in seperately.

This patch modifies the code related to the submit_bio calls
so the flags and operation are seperated. When this is done
for all code, one of the later patches in the series will
the actual submit_bio call, so the patches are bisectable.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/btrfs/check-integrity.c |   6 +--
 fs/btrfs/check-integrity.h |   2 +-
 fs/btrfs/compression.c     |   8 ++--
 fs/btrfs/ctree.h           |   3 +-
 fs/btrfs/disk-io.c         |  48 +++++++++++----------
 fs/btrfs/disk-io.h         |   2 +-
 fs/btrfs/extent-tree.c     |   2 +-
 fs/btrfs/extent_io.c       | 103 ++++++++++++++++++++++++---------------------
 fs/btrfs/extent_io.h       |   7 +--
 fs/btrfs/inode.c           |  65 ++++++++++++++--------------
 fs/btrfs/scrub.c           |   4 +-
 fs/btrfs/volumes.c         |  88 ++++++++++++++++++++------------------
 fs/btrfs/volumes.h         |   4 +-
 13 files changed, 177 insertions(+), 165 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index fd50b2f..515a92e 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -3058,10 +3058,10 @@ leave:
 	mutex_unlock(&btrfsic_mutex);
 }
 
-void btrfsic_submit_bio(int rw, struct bio *bio)
+void btrfsic_submit_bio(int op, int op_flags, struct bio *bio)
 {
-	__btrfsic_submit_bio(rw, bio);
-	submit_bio(rw, bio);
+	__btrfsic_submit_bio(op | op_flags, bio);
+	submit_bio(op | op_flags, bio);
 }
 
 int btrfsic_submit_bio_wait(int op, int op_flags, struct bio *bio)
diff --git a/fs/btrfs/check-integrity.h b/fs/btrfs/check-integrity.h
index 13b0d54..a8edc424 100644
--- a/fs/btrfs/check-integrity.h
+++ b/fs/btrfs/check-integrity.h
@@ -21,7 +21,7 @@
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 int btrfsic_submit_bh(int rw, struct buffer_head *bh);
-void btrfsic_submit_bio(int rw, struct bio *bio);
+void btrfsic_submit_bio(int op, int op_flags, struct bio *bio);
 int btrfsic_submit_bio_wait(int op, int op_flags, struct bio *bio);
 #else
 #define btrfsic_submit_bh submit_bh
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 57ee8ca..a7b245d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -401,7 +401,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				BUG_ON(ret); /* -ENOMEM */
 			}
 
-			ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
+			ret = btrfs_map_bio(root, REQ_OP_WRITE, 0, bio, 0, 1);
 			BUG_ON(ret); /* -ENOMEM */
 
 			bio_put(bio);
@@ -431,7 +431,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 		BUG_ON(ret); /* -ENOMEM */
 	}
 
-	ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
+	ret = btrfs_map_bio(root, REQ_OP_WRITE, 0, bio, 0, 1);
 	BUG_ON(ret); /* -ENOMEM */
 
 	bio_put(bio);
@@ -692,7 +692,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			sums += DIV_ROUND_UP(comp_bio->bi_iter.bi_size,
 					     root->sectorsize);
 
-			ret = btrfs_map_bio(root, READ, comp_bio,
+			ret = btrfs_map_bio(root, REQ_OP_READ, 0, comp_bio,
 					    mirror_num, 0);
 			if (ret) {
 				bio->bi_error = ret;
@@ -722,7 +722,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 		BUG_ON(ret); /* -ENOMEM */
 	}
 
-	ret = btrfs_map_bio(root, READ, comp_bio, mirror_num, 0);
+	ret = btrfs_map_bio(root, REQ_OP_READ, 0, comp_bio, mirror_num, 0);
 	if (ret) {
 		bio->bi_error = ret;
 		bio_endio(comp_bio);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..e4489dd1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3910,8 +3910,7 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *parent_root,
 			     u64 new_dirid);
 int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
-			 size_t size, struct bio *bio,
-			 unsigned long bio_flags);
+			 size_t size, struct bio *bio, unsigned long bio_flags);
 int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_evict_inode(struct inode *inode);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1e60d00..6c17d5d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -118,7 +118,8 @@ struct async_submit_bio {
 	struct list_head list;
 	extent_submit_bio_hook_t *submit_bio_start;
 	extent_submit_bio_hook_t *submit_bio_done;
-	int rw;
+	int op;
+	int op_flags;
 	int mirror_num;
 	unsigned long bio_flags;
 	/*
@@ -783,9 +784,9 @@ static void run_one_async_start(struct btrfs_work *work)
 	int ret;
 
 	async = container_of(work, struct  async_submit_bio, work);
-	ret = async->submit_bio_start(async->inode, async->rw, async->bio,
-				      async->mirror_num, async->bio_flags,
-				      async->bio_offset);
+	ret = async->submit_bio_start(async->inode, async->op, async->op_flags,
+				      async->bio, async->mirror_num,
+				      async->bio_flags, async->bio_offset);
 	if (ret)
 		async->error = ret;
 }
@@ -813,8 +814,8 @@ static void run_one_async_done(struct btrfs_work *work)
 		return;
 	}
 
-	async->submit_bio_done(async->inode, async->rw, async->bio,
-			       async->mirror_num, async->bio_flags,
+	async->submit_bio_done(async->inode, async->op, async->op_flags,
+			       async->bio, async->mirror_num, async->bio_flags,
 			       async->bio_offset);
 }
 
@@ -827,7 +828,7 @@ static void run_one_async_free(struct btrfs_work *work)
 }
 
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
-			int rw, struct bio *bio, int mirror_num,
+			int op, int op_flags, struct bio *bio, int mirror_num,
 			unsigned long bio_flags,
 			u64 bio_offset,
 			extent_submit_bio_hook_t *submit_bio_start,
@@ -840,7 +841,8 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 		return -ENOMEM;
 
 	async->inode = inode;
-	async->rw = rw;
+	async->op = op;
+	async->op_flags = op_flags;
 	async->bio = bio;
 	async->mirror_num = mirror_num;
 	async->submit_bio_start = submit_bio_start;
@@ -856,7 +858,7 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 
 	atomic_inc(&fs_info->nr_async_submits);
 
-	if (rw & REQ_SYNC)
+	if (op_flags & REQ_SYNC)
 		btrfs_set_work_high_priority(&async->work);
 
 	btrfs_queue_work(fs_info->workers, &async->work);
@@ -886,7 +888,7 @@ static int btree_csum_one_bio(struct bio *bio)
 	return ret;
 }
 
-static int __btree_submit_bio_start(struct inode *inode, int rw,
+static int __btree_submit_bio_start(struct inode *inode, int op, int op_flags,
 				    struct bio *bio, int mirror_num,
 				    unsigned long bio_flags,
 				    u64 bio_offset)
@@ -898,9 +900,9 @@ static int __btree_submit_bio_start(struct inode *inode, int rw,
 	return btree_csum_one_bio(bio);
 }
 
-static int __btree_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
-				 int mirror_num, unsigned long bio_flags,
-				 u64 bio_offset)
+static int __btree_submit_bio_done(struct inode *inode, int op, int op_flags,
+				   struct bio *bio, int mirror_num,
+				   unsigned long bio_flags, u64 bio_offset)
 {
 	int ret;
 
@@ -908,7 +910,7 @@ static int __btree_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
 	 * when we're called for a write, we're already in the async
 	 * submission context.  Just jump into btrfs_map_bio
 	 */
-	ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio, mirror_num, 1);
+	ret = btrfs_map_bio(BTRFS_I(inode)->root, op, op_flags, bio, mirror_num, 1);
 	if (ret) {
 		bio->bi_error = ret;
 		bio_endio(bio);
@@ -927,14 +929,14 @@ static int check_async_write(struct inode *inode, unsigned long bio_flags)
 	return 1;
 }
 
-static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
-				 int mirror_num, unsigned long bio_flags,
-				 u64 bio_offset)
+static int btree_submit_bio_hook(struct inode *inode, int op, int op_flags,
+				 struct bio *bio, int mirror_num,
+				 unsigned long bio_flags, u64 bio_offset)
 {
 	int async = check_async_write(inode, bio_flags);
 	int ret;
 
-	if (!(rw & REQ_WRITE)) {
+	if (!(op == REQ_OP_WRITE)) {
 		/*
 		 * called for a read, do the setup so that checksum validation
 		 * can happen in the async kernel threads
@@ -943,13 +945,13 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 					  bio, BTRFS_WQ_ENDIO_METADATA);
 		if (ret)
 			goto out_w_error;
-		ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
+		ret = btrfs_map_bio(BTRFS_I(inode)->root, op, op_flags, bio,
 				    mirror_num, 0);
 	} else if (!async) {
 		ret = btree_csum_one_bio(bio);
 		if (ret)
 			goto out_w_error;
-		ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
+		ret = btrfs_map_bio(BTRFS_I(inode)->root, op, op_flags, bio,
 				    mirror_num, 0);
 	} else {
 		/*
@@ -957,8 +959,8 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 		 * checksumming can happen in parallel across all CPUs
 		 */
 		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
-					  inode, rw, bio, mirror_num, 0,
-					  bio_offset,
+					  inode, op, op_flags, bio, mirror_num,
+					  0, bio_offset,
 					  __btree_submit_bio_start,
 					  __btree_submit_bio_done);
 	}
@@ -3392,7 +3394,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 	device->flush_bio = bio;
 
 	bio_get(bio);
-	btrfsic_submit_bio(WRITE_FLUSH, bio);
+	btrfsic_submit_bio(REQ_OP_WRITE, WRITE_FLUSH, bio);
 
 	return 0;
 }
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index bdfb479..caa47a3 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -121,7 +121,7 @@ void btrfs_csum_final(u32 crc, char *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			enum btrfs_wq_endio_type metadata);
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
-			int rw, struct bio *bio, int mirror_num,
+			int op, int op_flags, struct bio *bio, int mirror_num,
 			unsigned long bio_flags, u64 bio_offset,
 			extent_submit_bio_hook_t *submit_bio_start,
 			extent_submit_bio_hook_t *submit_bio_done);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 601d7d4..d28d4b2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1964,7 +1964,7 @@ int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 
 
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(root->fs_info, REQ_DISCARD,
+	ret = btrfs_map_block(root->fs_info, REQ_OP_DISCARD,
 			      bytenr, &num_bytes, &bbio, 0);
 	/* Error condition is -ENOMEM */
 	if (!ret) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9a68a83..0dc9ec6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2407,7 +2407,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct bio *bio;
-	int read_mode;
+	int read_mode_flags = READ_SYNC;
 	int ret;
 
 	BUG_ON(failed_bio->bi_rw & REQ_WRITE);
@@ -2423,9 +2423,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	}
 
 	if (failed_bio->bi_vcnt > 1)
-		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
-	else
-		read_mode = READ_SYNC;
+		read_mode_flags |= REQ_FAILFAST_DEV;
 
 	phy_offset >>= inode->i_sb->s_blocksize_bits;
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
@@ -2438,10 +2436,10 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	}
 
 	pr_debug("Repair Read Error: submitting new read[%#x] to this_mirror=%d, in_validation=%d\n",
-		 read_mode, failrec->this_mirror, failrec->in_validation);
+		 read_mode_flags, failrec->this_mirror, failrec->in_validation);
 
-	ret = tree->ops->submit_bio_hook(inode, read_mode, bio,
-					 failrec->this_mirror,
+	ret = tree->ops->submit_bio_hook(inode, REQ_OP_READ, read_mode_flags,
+					 bio, failrec->this_mirror,
 					 failrec->bio_flags, 0);
 	if (ret) {
 		free_io_failure(inode, failrec);
@@ -2750,7 +2748,7 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 
 
-static int __must_check submit_one_bio(int rw, struct bio *bio,
+static int __must_check submit_one_bio(int op, int op_flags, struct bio *bio,
 				       int mirror_num, unsigned long bio_flags)
 {
 	int ret = 0;
@@ -2766,18 +2764,19 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 	bio_get(bio);
 
 	if (tree->ops && tree->ops->submit_bio_hook)
-		ret = tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
-					   mirror_num, bio_flags, start);
+		ret = tree->ops->submit_bio_hook(page->mapping->host, op,
+						 op_flags, bio, mirror_num,
+						 bio_flags, start);
 	else
-		btrfsic_submit_bio(rw, bio);
+		btrfsic_submit_bio(op, op_flags, bio);
 
 	bio_put(bio);
 	return ret;
 }
 
-static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
-		     unsigned long offset, size_t size, struct bio *bio,
-		     unsigned long bio_flags)
+static int merge_bio(int rw, struct extent_io_tree *tree,
+		     struct page *page, unsigned long offset, size_t size,
+		     struct bio *bio, unsigned long bio_flags)
 {
 	int ret = 0;
 	if (tree->ops && tree->ops->merge_bio_hook)
@@ -2788,7 +2787,7 @@ static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
 
 }
 
-static int submit_extent_page(int rw, struct extent_io_tree *tree,
+static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 			      struct writeback_control *wbc,
 			      struct page *page, sector_t sector,
 			      size_t size, unsigned long offset,
@@ -2816,9 +2815,10 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 
 		if (prev_bio_flags != bio_flags || !contig ||
 		    force_bio_submit ||
-		    merge_bio(rw, tree, page, offset, page_size, bio, bio_flags) ||
+		    merge_bio(op, tree, page, offset, page_size, bio,
+			      bio_flags) ||
 		    bio_add_page(bio, page, page_size, offset) < page_size) {
-			ret = submit_one_bio(rw, bio, mirror_num,
+			ret = submit_one_bio(op, op_flags, bio, mirror_num,
 					     prev_bio_flags);
 			if (ret < 0) {
 				*bio_ret = NULL;
@@ -2848,7 +2848,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	if (bio_ret)
 		*bio_ret = bio;
 	else
-		ret = submit_one_bio(rw, bio, mirror_num, bio_flags);
+		ret = submit_one_bio(op, op_flags, bio, mirror_num, bio_flags);
 
 	return ret;
 }
@@ -2912,7 +2912,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			 get_extent_t *get_extent,
 			 struct extent_map **em_cached,
 			 struct bio **bio, int mirror_num,
-			 unsigned long *bio_flags, int rw,
+			 unsigned long *bio_flags, int op, int op_flags,
 			 u64 *prev_em_start)
 {
 	struct inode *inode = page->mapping->host;
@@ -3099,7 +3099,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 		}
 
 		pnr -= page->index;
-		ret = submit_extent_page(rw, tree, NULL, page,
+		ret = submit_extent_page(op, op_flags, tree, NULL, page,
 					 sector, disk_io_size, pg_offset,
 					 bdev, bio, pnr,
 					 end_bio_extent_readpage, mirror_num,
@@ -3132,7 +3132,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 					     get_extent_t *get_extent,
 					     struct extent_map **em_cached,
 					     struct bio **bio, int mirror_num,
-					     unsigned long *bio_flags, int rw,
+					     unsigned long *bio_flags,
 					     u64 *prev_em_start)
 {
 	struct inode *inode;
@@ -3153,7 +3153,8 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 
 	for (index = 0; index < nr_pages; index++) {
 		__do_readpage(tree, pages[index], get_extent, em_cached, bio,
-			      mirror_num, bio_flags, rw, prev_em_start);
+			      mirror_num, bio_flags, REQ_OP_READ, 0,
+			      prev_em_start);
 		page_cache_release(pages[index]);
 	}
 }
@@ -3163,7 +3164,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 			       int nr_pages, get_extent_t *get_extent,
 			       struct extent_map **em_cached,
 			       struct bio **bio, int mirror_num,
-			       unsigned long *bio_flags, int rw,
+			       unsigned long *bio_flags,
 			       u64 *prev_em_start)
 {
 	u64 start = 0;
@@ -3185,7 +3186,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 						  index - first_index, start,
 						  end, get_extent, em_cached,
 						  bio, mirror_num, bio_flags,
-						  rw, prev_em_start);
+						  prev_em_start);
 			start = page_start;
 			end = start + PAGE_CACHE_SIZE - 1;
 			first_index = index;
@@ -3196,7 +3197,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 		__do_contiguous_readpages(tree, &pages[first_index],
 					  index - first_index, start,
 					  end, get_extent, em_cached, bio,
-					  mirror_num, bio_flags, rw,
+					  mirror_num, bio_flags,
 					  prev_em_start);
 }
 
@@ -3204,7 +3205,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 				   struct page *page,
 				   get_extent_t *get_extent,
 				   struct bio **bio, int mirror_num,
-				   unsigned long *bio_flags, int rw)
+				   unsigned long *bio_flags, int op,
+				   int op_flags)
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_ordered_extent *ordered;
@@ -3223,7 +3225,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	}
 
 	ret = __do_readpage(tree, page, get_extent, NULL, bio, mirror_num,
-			    bio_flags, rw, NULL);
+			    bio_flags, op, op_flags, NULL);
 	return ret;
 }
 
@@ -3235,9 +3237,10 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 	int ret;
 
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
-				      &bio_flags, READ);
+				      &bio_flags, REQ_OP_READ, 0);
 	if (bio)
-		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
+		ret = submit_one_bio(REQ_OP_READ, 0, bio, mirror_num,
+				     bio_flags);
 	return ret;
 }
 
@@ -3249,9 +3252,10 @@ int extent_read_full_page_nolock(struct extent_io_tree *tree, struct page *page,
 	int ret;
 
 	ret = __do_readpage(tree, page, get_extent, NULL, &bio, mirror_num,
-			    &bio_flags, READ, NULL);
+			    &bio_flags, REQ_OP_READ, 0, NULL);
 	if (bio)
-		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
+		ret = submit_one_bio(REQ_OP_READ, 0, bio, mirror_num,
+				     bio_flags);
 	return ret;
 }
 
@@ -3498,9 +3502,10 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 				       page->index, cur, end);
 			}
 
-			ret = submit_extent_page(write_flags, tree, wbc, page,
-						 sector, iosize, pg_offset,
-						 bdev, &epd->bio, max_nr,
+			ret = submit_extent_page(REQ_OP_WRITE, write_flags,
+						 tree, wbc, page, sector,
+						 iosize, pg_offset, bdev,
+						 &epd->bio, max_nr,
 						 end_bio_extent_writepage,
 						 0, 0, 0, false);
 			if (ret)
@@ -3538,13 +3543,11 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	size_t pg_offset = 0;
 	loff_t i_size = i_size_read(inode);
 	unsigned long end_index = i_size >> PAGE_CACHE_SHIFT;
-	int write_flags;
+	int write_flags = 0;
 	unsigned long nr_written = 0;
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		write_flags = WRITE_SYNC;
-	else
-		write_flags = WRITE;
 
 	trace___extent_writepage(page, inode, wbc);
 
@@ -3788,7 +3791,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	u64 offset = eb->start;
 	unsigned long i, num_pages;
 	unsigned long bio_flags = 0;
-	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
+	int op_flags = (epd->sync_io ? WRITE_SYNC : 0) | REQ_META;
 	int ret = 0;
 
 	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags);
@@ -3802,9 +3805,10 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
-		ret = submit_extent_page(rw, tree, wbc, p, offset >> 9,
-					 PAGE_CACHE_SIZE, 0, bdev, &epd->bio,
-					 -1, end_bio_extent_buffer_writepage,
+		ret = submit_extent_page(REQ_OP_WRITE, op_flags, tree, wbc, p,
+					 offset >> 9, PAGE_CACHE_SIZE, 0, bdev,
+					 &epd->bio, -1,
+					 end_bio_extent_buffer_writepage,
 					 0, epd->bio_flags, bio_flags, false);
 		epd->bio_flags = bio_flags;
 		if (ret) {
@@ -4093,13 +4097,14 @@ retry:
 static void flush_epd_write_bio(struct extent_page_data *epd)
 {
 	if (epd->bio) {
-		int rw = WRITE;
+		int op_flags  = 0;
 		int ret;
 
 		if (epd->sync_io)
-			rw = WRITE_SYNC;
+			op_flags = WRITE_SYNC;
 
-		ret = submit_one_bio(rw, epd->bio, 0, epd->bio_flags);
+		ret = submit_one_bio(REQ_OP_WRITE, op_flags, epd->bio, 0,
+				     epd->bio_flags);
 		BUG_ON(ret < 0); /* -ENOMEM */
 		epd->bio = NULL;
 	}
@@ -4226,19 +4231,19 @@ int extent_readpages(struct extent_io_tree *tree,
 		if (nr < ARRAY_SIZE(pagepool))
 			continue;
 		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
-				   &bio, 0, &bio_flags, READ, &prev_em_start);
+				   &bio, 0, &bio_flags, &prev_em_start);
 		nr = 0;
 	}
 	if (nr)
 		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
-				   &bio, 0, &bio_flags, READ, &prev_em_start);
+				   &bio, 0, &bio_flags, &prev_em_start);
 
 	if (em_cached)
 		free_extent_map(em_cached);
 
 	BUG_ON(!list_empty(pages));
 	if (bio)
-		return submit_one_bio(READ, bio, 0, bio_flags);
+		return submit_one_bio(REQ_OP_READ, 0, bio, 0, bio_flags);
 	return 0;
 }
 
@@ -5254,7 +5259,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			err = __extent_read_full_page(tree, page,
 						      get_extent, &bio,
 						      mirror_num, &bio_flags,
-						      READ | REQ_META);
+						      REQ_OP_READ, REQ_META);
 			if (err)
 				ret = err;
 		} else {
@@ -5263,7 +5268,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	}
 
 	if (bio) {
-		err = submit_one_bio(READ | REQ_META, bio, mirror_num,
+		err = submit_one_bio(REQ_OP_READ, REQ_META, bio, mirror_num,
 				     bio_flags);
 		if (err)
 			return err;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c668f36..28d8929 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -61,9 +61,10 @@ struct extent_state;
 struct btrfs_root;
 struct btrfs_io_bio;
 
-typedef	int (extent_submit_bio_hook_t)(struct inode *inode, int rw,
-				       struct bio *bio, int mirror_num,
-				       unsigned long bio_flags, u64 bio_offset);
+typedef	int (extent_submit_bio_hook_t)(struct inode *inode, int op,
+				       int op_flags, struct bio *bio,
+				       int mirror_num, unsigned long bio_flags,
+				       u64 bio_offset);
 struct extent_io_ops {
 	int (*fill_delalloc)(struct inode *inode, struct page *locked_page,
 			     u64 start, u64 end, int *page_started,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ad8bab..dd0b769 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1785,8 +1785,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
  * we don't create bios that span stripes or chunks
  */
 int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
-			 size_t size, struct bio *bio,
-			 unsigned long bio_flags)
+			 size_t size, struct bio *bio, unsigned long bio_flags)
 {
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 	u64 logical = (u64)bio->bi_iter.bi_sector << 9;
@@ -1816,7 +1815,7 @@ int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-static int __btrfs_submit_bio_start(struct inode *inode, int rw,
+static int __btrfs_submit_bio_start(struct inode *inode, int op, int op_flags,
 				    struct bio *bio, int mirror_num,
 				    unsigned long bio_flags,
 				    u64 bio_offset)
@@ -1837,14 +1836,14 @@ static int __btrfs_submit_bio_start(struct inode *inode, int rw,
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-static int __btrfs_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
-			  int mirror_num, unsigned long bio_flags,
-			  u64 bio_offset)
+static int __btrfs_submit_bio_done(struct inode *inode, int op, int op_flags,
+				   struct bio *bio, int mirror_num,
+				   unsigned long bio_flags, u64 bio_offset)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	ret = btrfs_map_bio(root, rw, bio, mirror_num, 1);
+	ret = btrfs_map_bio(root, op, op_flags, bio, mirror_num, 1);
 	if (ret) {
 		bio->bi_error = ret;
 		bio_endio(bio);
@@ -1856,9 +1855,9 @@ static int __btrfs_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
  * extent_io.c submission hook. This does the right thing for csum calculation
  * on write, or reading the csums from the tree before a read
  */
-static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
-			  int mirror_num, unsigned long bio_flags,
-			  u64 bio_offset)
+static int btrfs_submit_bio_hook(struct inode *inode, int op, int op_flags,
+				 struct bio *bio, int mirror_num,
+				 unsigned long bio_flags, u64 bio_offset)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret = 0;
@@ -1871,7 +1870,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	if (btrfs_is_free_space_inode(inode))
 		metadata = 2;
 
-	if (!(rw & REQ_WRITE)) {
+	if (!(op == REQ_OP_WRITE)) {
 		ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
 		if (ret)
 			goto out;
@@ -1893,7 +1892,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 			goto mapit;
 		/* we're doing a write, do the async checksumming */
 		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
-				   inode, rw, bio, mirror_num,
+				   inode, op, op_flags, bio, mirror_num,
 				   bio_flags, bio_offset,
 				   __btrfs_submit_bio_start,
 				   __btrfs_submit_bio_done);
@@ -1905,7 +1904,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	}
 
 mapit:
-	ret = btrfs_map_bio(root, rw, bio, mirror_num, 0);
+	ret = btrfs_map_bio(root, op, op_flags, bio, mirror_num, 0);
 
 out:
 	if (ret < 0) {
@@ -7613,13 +7612,11 @@ unlock_err:
 }
 
 static inline int submit_dio_repair_bio(struct inode *inode, struct bio *bio,
-					int rw, int mirror_num)
+					int op_flags, int mirror_num)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	BUG_ON(rw & REQ_WRITE);
-
 	bio_get(bio);
 
 	ret = btrfs_bio_wq_end_io(root->fs_info, bio,
@@ -7627,7 +7624,7 @@ static inline int submit_dio_repair_bio(struct inode *inode, struct bio *bio,
 	if (ret)
 		goto err;
 
-	ret = btrfs_map_bio(root, rw, bio, mirror_num, 0);
+	ret = btrfs_map_bio(root, REQ_OP_READ, op_flags, bio, mirror_num, 0);
 err:
 	bio_put(bio);
 	return ret;
@@ -7939,9 +7936,11 @@ out_test:
 	bio_put(bio);
 }
 
-static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
-				    struct bio *bio, int mirror_num,
-				    unsigned long bio_flags, u64 offset)
+static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int op,
+					      int op_flags, struct bio *bio,
+					      int mirror_num,
+					      unsigned long bio_flags,
+					      u64 offset)
 {
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -8032,11 +8031,11 @@ static inline int btrfs_lookup_and_bind_dio_csum(struct btrfs_root *root,
 }
 
 static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
-					 int rw, u64 file_offset, int skip_sum,
-					 int async_submit)
+					 int op, int op_flags, u64 file_offset,
+					 int skip_sum, int async_submit)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
-	int write = rw & REQ_WRITE;
+	bool write = op == REQ_OP_WRITE ? true : false;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
@@ -8057,7 +8056,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 
 	if (write && async_submit) {
 		ret = btrfs_wq_submit_bio(root->fs_info,
-				   inode, rw, bio, 0, 0,
+				   inode, op, op_flags, bio, 0, 0,
 				   file_offset,
 				   __btrfs_submit_bio_start_direct_io,
 				   __btrfs_submit_bio_done);
@@ -8077,14 +8076,14 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 			goto err;
 	}
 map:
-	ret = btrfs_map_bio(root, rw, bio, 0, async_submit);
+	ret = btrfs_map_bio(root, op, op_flags, bio, 0, async_submit);
 err:
 	bio_put(bio);
 	return ret;
 }
 
-static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
-				    int skip_sum)
+static int btrfs_submit_direct_hook(int op, int op_flags,
+				    struct btrfs_dio_private *dip, int skip_sum)
 {
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -8100,7 +8099,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	int async_submit = 0;
 
 	map_length = orig_bio->bi_iter.bi_size;
-	ret = btrfs_map_block(root->fs_info, rw, start_sector << 9,
+	ret = btrfs_map_block(root->fs_info, op, start_sector << 9,
 			      &map_length, NULL, 0);
 	if (ret)
 		return -EIO;
@@ -8137,7 +8136,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			 * before we're done setting it up
 			 */
 			atomic_inc(&dip->pending_bios);
-			ret = __btrfs_submit_dio_bio(bio, inode, rw,
+			ret = __btrfs_submit_dio_bio(bio, inode, op, op_flags,
 						     file_offset, skip_sum,
 						     async_submit);
 			if (ret) {
@@ -8161,7 +8160,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			btrfs_io_bio(bio)->logical = file_offset;
 
 			map_length = orig_bio->bi_iter.bi_size;
-			ret = btrfs_map_block(root->fs_info, rw,
+			ret = btrfs_map_block(root->fs_info, op,
 					      start_sector << 9,
 					      &map_length, NULL, 0);
 			if (ret) {
@@ -8176,8 +8175,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	}
 
 submit:
-	ret = __btrfs_submit_dio_bio(bio, inode, rw, file_offset, skip_sum,
-				     async_submit);
+	ret = __btrfs_submit_dio_bio(bio, inode, op, op_flags, file_offset,
+				     skip_sum, async_submit);
 	if (!ret)
 		return 0;
 
@@ -8238,7 +8237,7 @@ static void btrfs_submit_direct(int op, int op_flags, struct bio *dio_bio,
 		dip->subio_endio = btrfs_subio_endio_read;
 	}
 
-	ret = btrfs_submit_direct_hook(op | op_flags, dip, skip_sum);
+	ret = btrfs_submit_direct_hook(op, op_flags, dip, skip_sum);
 	if (!ret)
 		return;
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9cb6f9a..8b72207 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1784,7 +1784,7 @@ static void scrub_wr_submit(struct scrub_ctx *sctx)
 	 * orders the requests before sending them to the driver which
 	 * doubled the write performance on spinning disks when measured
 	 * with Linux 3.5 */
-	btrfsic_submit_bio(WRITE, sbio->bio);
+	btrfsic_submit_bio(REQ_OP_WRITE, 0, sbio->bio);
 }
 
 static void scrub_wr_bio_end_io(struct bio *bio)
@@ -2084,7 +2084,7 @@ static void scrub_submit(struct scrub_ctx *sctx)
 	sbio = sctx->bios[sctx->curr];
 	sctx->curr = -1;
 	scrub_pending_bio_inc(sctx);
-	btrfsic_submit_bio(READ, sbio->bio);
+	btrfsic_submit_bio(REQ_OP_READ, 0, sbio->bio);
 }
 
 static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6fc73586..3dfac71 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -367,7 +367,7 @@ loop_lock:
 			sync_pending = 0;
 		}
 
-		btrfsic_submit_bio(cur->bi_rw, cur);
+		btrfsic_submit_bio(cur->bi_rw, 0, cur);
 		num_run++;
 		batch_run++;
 
@@ -5091,7 +5091,7 @@ void btrfs_put_bbio(struct btrfs_bio *bbio)
 		kfree(bbio);
 }
 
-static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
+static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 			     u64 logical, u64 *length,
 			     struct btrfs_bio **bbio_ret,
 			     int mirror_num, int need_raid_map)
@@ -5169,7 +5169,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		raid56_full_stripe_start *= full_stripe_len;
 	}
 
-	if (rw & REQ_DISCARD) {
+	if (op == REQ_OP_DISCARD) {
 		/* we don't discard raid56 yet */
 		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
 			ret = -EOPNOTSUPP;
@@ -5182,7 +5182,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		   For other RAID types and for RAID[56] reads, just allow a single
 		   stripe (on a single disk). */
 		if ((map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) &&
-		    (rw & REQ_WRITE)) {
+		    (op == REQ_OP_WRITE)) {
 			max_len = stripe_len * nr_data_stripes(map) -
 				(offset - raid56_full_stripe_start);
 		} else {
@@ -5205,8 +5205,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		btrfs_dev_replace_unlock(dev_replace);
 
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
-	    !(rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)) &&
-	    dev_replace->tgtdev != NULL) {
+	    !(op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
+	     op == REQ_GET_READ_MIRRORS) && dev_replace->tgtdev != NULL) {
 		/*
 		 * in dev-replace case, for repair case (that's the only
 		 * case where the mirror is selected explicitly when
@@ -5295,15 +5295,17 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			    (offset + *length);
 
 	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
-		if (rw & REQ_DISCARD)
+		if (op == REQ_OP_DISCARD)
 			num_stripes = min_t(u64, map->num_stripes,
 					    stripe_nr_end - stripe_nr_orig);
 		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes,
 				&stripe_index);
-		if (!(rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)))
+		if (!(op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
+		    op == REQ_GET_READ_MIRRORS))
 			mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		if (rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS))
+		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
+		    op == REQ_GET_READ_MIRRORS)
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -5316,7 +5318,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		if (rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)) {
+		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
+		    op == REQ_GET_READ_MIRRORS) {
 			num_stripes = map->num_stripes;
 		} else if (mirror_num) {
 			stripe_index = mirror_num - 1;
@@ -5330,9 +5333,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
 		stripe_index *= map->sub_stripes;
 
-		if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS))
+		if (op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS)
 			num_stripes = map->sub_stripes;
-		else if (rw & REQ_DISCARD)
+		else if (op == REQ_OP_DISCARD)
 			num_stripes = min_t(u64, map->sub_stripes *
 					    (stripe_nr_end - stripe_nr_orig),
 					    map->num_stripes);
@@ -5350,7 +5353,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
 		if (need_raid_map &&
-		    ((rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) ||
+		    ((op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS) ||
 		     mirror_num > 1)) {
 			/* push stripe_nr back to the start of the full stripe */
 			stripe_nr = div_u64(raid56_full_stripe_start,
@@ -5378,8 +5381,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			/* We distribute the parity blocks across stripes */
 			div_u64_rem(stripe_nr + stripe_index, map->num_stripes,
 					&stripe_index);
-			if (!(rw & (REQ_WRITE | REQ_DISCARD |
-				    REQ_GET_READ_MIRRORS)) && mirror_num <= 1)
+			if (!(op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
+			      op == REQ_GET_READ_MIRRORS) && mirror_num <= 1)
 				mirror_num = 1;
 		}
 	} else {
@@ -5396,9 +5399,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	num_alloc_stripes = num_stripes;
 	if (dev_replace_is_ongoing) {
-		if (rw & (REQ_WRITE | REQ_DISCARD))
+		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD)
 			num_alloc_stripes <<= 1;
-		if (rw & REQ_GET_READ_MIRRORS)
+		if (op == REQ_GET_READ_MIRRORS)
 			num_alloc_stripes++;
 		tgtdev_indexes = num_stripes;
 	}
@@ -5413,7 +5416,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	/* build raid_map */
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK &&
-	    need_raid_map && ((rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) ||
+	    need_raid_map &&
+	   ((op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS) ||
 	    mirror_num > 1)) {
 		u64 tmp;
 		unsigned rot;
@@ -5438,7 +5442,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 				RAID6_Q_STRIPE;
 	}
 
-	if (rw & REQ_DISCARD) {
+	if (op == REQ_OP_DISCARD) {
 		u32 factor = 0;
 		u32 sub_stripes = 0;
 		u64 stripes_per_dev = 0;
@@ -5518,14 +5522,15 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		}
 	}
 
-	if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS))
+	if (op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS)
 		max_errors = btrfs_chunk_max_errors(map);
 
 	if (bbio->raid_map)
 		sort_parity_stripes(bbio, num_stripes);
 
 	tgtdev_indexes = 0;
-	if (dev_replace_is_ongoing && (rw & (REQ_WRITE | REQ_DISCARD)) &&
+	if (dev_replace_is_ongoing &&
+	    (op == REQ_OP_WRITE || op == REQ_OP_DISCARD) &&
 	    dev_replace->tgtdev != NULL) {
 		int index_where_to_add;
 		u64 srcdev_devid = dev_replace->srcdev->devid;
@@ -5560,7 +5565,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			}
 		}
 		num_stripes = index_where_to_add;
-	} else if (dev_replace_is_ongoing && (rw & REQ_GET_READ_MIRRORS) &&
+	} else if (dev_replace_is_ongoing && (op == REQ_GET_READ_MIRRORS) &&
 		   dev_replace->tgtdev != NULL) {
 		u64 srcdev_devid = dev_replace->srcdev->devid;
 		int index_srcdev = 0;
@@ -5637,8 +5642,8 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		      u64 logical, u64 *length,
 		      struct btrfs_bio **bbio_ret, int mirror_num)
 {
-	return __btrfs_map_block(fs_info, rw, logical, length, bbio_ret,
-				 mirror_num, 0);
+	return __btrfs_map_block(fs_info, rw, logical, length,
+				 bbio_ret, mirror_num, 0);
 }
 
 /* For Scrub/replace */
@@ -5815,7 +5820,7 @@ static void btrfs_end_bio(struct bio *bio)
  */
 static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 					struct btrfs_device *device,
-					int rw, struct bio *bio)
+					int op, int op_flags, struct bio *bio)
 {
 	int should_queue = 1;
 	struct btrfs_pending_bios *pending_bios;
@@ -5826,9 +5831,9 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	}
 
 	/* don't bother with additional async steps for reads, right now */
-	if (!(rw & REQ_WRITE)) {
+	if (!(op == REQ_OP_WRITE)) {
 		bio_get(bio);
-		btrfsic_submit_bio(rw, bio);
+		btrfsic_submit_bio(op, op_flags, bio);
 		bio_put(bio);
 		return;
 	}
@@ -5842,7 +5847,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	atomic_inc(&root->fs_info->nr_async_bios);
 	WARN_ON(bio->bi_next);
 	bio->bi_next = NULL;
-	bio->bi_rw |= rw;
+	bio->bi_rw |= op | op_flags;
 
 	spin_lock(&device->io_lock);
 	if (bio->bi_rw & REQ_SYNC)
@@ -5868,7 +5873,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 
 static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 			      struct bio *bio, u64 physical, int dev_nr,
-			      int rw, int async)
+			      int op, int op_flags, int async)
 {
 	struct btrfs_device *dev = bbio->stripes[dev_nr].dev;
 
@@ -5882,8 +5887,8 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 
 		rcu_read_lock();
 		name = rcu_dereference(dev->name);
-		pr_debug("btrfs_map_bio: rw %d, sector=%llu, dev=%lu "
-			 "(%s id %llu), size=%u\n", rw,
+		pr_debug("btrfs_map_bio: rw %d,%d, sector=%llu, dev=%lu "
+			 "(%s id %llu), size=%u\n", op, op_flags,
 			 (u64)bio->bi_iter.bi_sector, (u_long)dev->bdev->bd_dev,
 			 name->str, dev->devid, bio->bi_iter.bi_size);
 		rcu_read_unlock();
@@ -5894,9 +5899,9 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 	btrfs_bio_counter_inc_noblocked(root->fs_info);
 
 	if (async)
-		btrfs_schedule_bio(root, dev, rw, bio);
+		btrfs_schedule_bio(root, dev, op, op_flags, bio);
 	else
-		btrfsic_submit_bio(rw, bio);
+		btrfsic_submit_bio(op, op_flags, bio);
 }
 
 static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
@@ -5913,8 +5918,8 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 	}
 }
 
-int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
-		  int mirror_num, int async_submit)
+int btrfs_map_bio(struct btrfs_root *root, int op, int op_flags,
+		  struct bio *bio, int mirror_num, int async_submit)
 {
 	struct btrfs_device *dev;
 	struct bio *first_bio = bio;
@@ -5930,8 +5935,8 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	map_length = length;
 
 	btrfs_bio_counter_inc_blocked(root->fs_info);
-	ret = __btrfs_map_block(root->fs_info, rw, logical, &map_length, &bbio,
-			      mirror_num, 1);
+	ret = __btrfs_map_block(root->fs_info, op, logical, &map_length, &bbio,
+				mirror_num, 1);
 	if (ret) {
 		btrfs_bio_counter_dec(root->fs_info);
 		return ret;
@@ -5947,7 +5952,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	if (bbio->raid_map) {
 		/* In this case, map_length has been set to the length of
 		   a single stripe; not the whole write */
-		if (rw & WRITE) {
+		if (op == REQ_OP_WRITE) {
 			ret = raid56_parity_write(root, bio, bbio, map_length);
 		} else {
 			ret = raid56_parity_recover(root, bio, bbio, map_length,
@@ -5966,7 +5971,8 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
 		dev = bbio->stripes[dev_nr].dev;
-		if (!dev || !dev->bdev || (rw & WRITE && !dev->writeable)) {
+		if (!dev || !dev->bdev ||
+		    (op == REQ_OP_WRITE && !dev->writeable)) {
 			bbio_error(bbio, first_bio, logical);
 			continue;
 		}
@@ -5978,8 +5984,8 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 			bio = first_bio;
 
 		submit_stripe_bio(root, bbio, bio,
-				  bbio->stripes[dev_nr].physical, dev_nr, rw,
-				  async_submit);
+				  bbio->stripes[dev_nr].physical, dev_nr, op,
+				  op_flags, async_submit);
 	}
 	btrfs_bio_counter_dec(root->fs_info);
 	return 0;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 595279a..22cd8c3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -426,8 +426,8 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 type);
 void btrfs_mapping_init(struct btrfs_mapping_tree *tree);
 void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree);
-int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
-		  int mirror_num, int async_submit);
+int btrfs_map_bio(struct btrfs_root *root, int op, int op_flags,
+		  struct bio *bio, int mirror_num, int async_submit);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
-- 
1.8.3.1
