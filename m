From: mchristi@redhat.com
Subject: [PATCH 15/32] btrfs: prepare for bi_rw split
Date: Wed,  4 Nov 2015 16:08:12 -0600
Message-ID: <1446674909-5371-16-git-send-email-mchristi@redhat.com>
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

This patch prepares btrfs's submit_bh use for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers will now pass them in seperately.

This patch modifies the code related to the submit_bh calls
so the flags and operation are seperated. When this is done
for all code, one of the later patches in the series will
the actual submit_bh call, so the patches are bisectable.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/btrfs/check-integrity.c | 68 ++++++++++++++++++++++++++--------------------
 fs/btrfs/check-integrity.h |  2 +-
 fs/btrfs/disk-io.c         |  4 +--
 3 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index a5ff6e4..17eba2d 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -168,7 +168,8 @@ struct btrfsic_block {
 		bio_end_io_t *bio;
 		bh_end_io_t *bh;
 	} orig_bio_bh_end_io;
-	int submit_bio_bh_rw;
+	int submit_bio_bh_op;
+	int submit_bio_bh_op_flags;
 	u64 flush_gen; /* only valid if !never_written */
 };
 
@@ -338,7 +339,8 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 					  unsigned int num_pages,
 					  struct bio *bio, int *bio_is_patched,
 					  struct buffer_head *bh,
-					  int submit_bio_bh_rw);
+					  int submit_bio_bh_op,
+					  int submit_bio_bh_op_flags);
 static int btrfsic_process_written_superblock(
 		struct btrfsic_state *state,
 		struct btrfsic_block *const block,
@@ -418,7 +420,8 @@ static void btrfsic_block_init(struct btrfsic_block *b)
 	INIT_LIST_HEAD(&b->all_blocks_node);
 	INIT_LIST_HEAD(&b->ref_to_list);
 	INIT_LIST_HEAD(&b->ref_from_list);
-	b->submit_bio_bh_rw = 0;
+	b->submit_bio_bh_op = 0;
+	b->submit_bio_bh_op_flags = 0;
 	b->flush_gen = 0;
 }
 
@@ -1820,7 +1823,8 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 					  unsigned int num_pages,
 					  struct bio *bio, int *bio_is_patched,
 					  struct buffer_head *bh,
-					  int submit_bio_bh_rw)
+					  int submit_bio_bh_op,
+					  int submit_bio_bh_op_flags)
 {
 	int is_metadata;
 	struct btrfsic_block *block;
@@ -2038,7 +2042,8 @@ again:
 		}
 
 		block->flush_gen = dev_state->last_flush_gen + 1;
-		block->submit_bio_bh_rw = submit_bio_bh_rw;
+		block->submit_bio_bh_op = submit_bio_bh_op;
+		block->submit_bio_bh_op_flags = submit_bio_bh_op_flags;
 		if (is_metadata) {
 			block->logical_bytenr = bytenr;
 			block->is_metadata = 1;
@@ -2141,7 +2146,8 @@ again:
 		block->iodone_w_error = 0;
 		block->mirror_num = 0;	/* unknown */
 		block->flush_gen = dev_state->last_flush_gen + 1;
-		block->submit_bio_bh_rw = submit_bio_bh_rw;
+		block->submit_bio_bh_op = submit_bio_bh_op;
+		block->submit_bio_bh_op_flags = submit_bio_bh_op_flags;
 		if (NULL != bio) {
 			block->is_iodone = 0;
 			BUG_ON(NULL == bio_is_patched);
@@ -2236,7 +2242,7 @@ static void btrfsic_bio_end_io(struct bio *bp)
 			       block->dev_bytenr, block->mirror_num);
 		next_block = block->next_in_same_bio;
 		block->iodone_w_error = iodone_w_error;
-		if (block->submit_bio_bh_rw & REQ_FLUSH) {
+		if (block->submit_bio_bh_op_flags & REQ_FLUSH) {
 			dev_state->last_flush_gen++;
 			if ((dev_state->state->print_mask &
 			     BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
@@ -2245,7 +2251,7 @@ static void btrfsic_bio_end_io(struct bio *bp)
 				       dev_state->name,
 				       dev_state->last_flush_gen);
 		}
-		if (block->submit_bio_bh_rw & REQ_FUA)
+		if (block->submit_bio_bh_op_flags & REQ_FUA)
 			block->flush_gen = 0; /* FUA completed means block is
 					       * on disk */
 		block->is_iodone = 1; /* for FLUSH, this releases the block */
@@ -2272,7 +2278,7 @@ static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
 		       block->dev_bytenr, block->mirror_num);
 
 	block->iodone_w_error = iodone_w_error;
-	if (block->submit_bio_bh_rw & REQ_FLUSH) {
+	if (block->submit_bio_bh_op_flags & REQ_FLUSH) {
 		dev_state->last_flush_gen++;
 		if ((dev_state->state->print_mask &
 		     BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
@@ -2280,7 +2286,7 @@ static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
 			       "bh_end_io() new %s flush_gen=%llu\n",
 			       dev_state->name, dev_state->last_flush_gen);
 	}
-	if (block->submit_bio_bh_rw & REQ_FUA)
+	if (block->submit_bio_bh_op_flags & REQ_FUA)
 		block->flush_gen = 0; /* FUA completed means block is on disk */
 
 	bh->b_private = block->orig_bio_bh_private;
@@ -2897,12 +2903,12 @@ static struct btrfsic_dev_state *btrfsic_dev_state_lookup(
 	return ds;
 }
 
-int btrfsic_submit_bh(int rw, struct buffer_head *bh)
+int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh)
 {
 	struct btrfsic_dev_state *dev_state;
 
 	if (!btrfsic_is_initialized)
-		return submit_bh(rw, bh);
+		return submit_bh(op | op_flags, bh);
 
 	mutex_lock(&btrfsic_mutex);
 	/* since btrfsic_submit_bh() might also be called before
@@ -2911,26 +2917,26 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 
 	/* Only called to write the superblock (incl. FLUSH/FUA) */
 	if (NULL != dev_state &&
-	    (rw & WRITE) && bh->b_size > 0) {
+	    (op == REQ_OP_WRITE) && bh->b_size > 0) {
 		u64 dev_bytenr;
 
 		dev_bytenr = 4096 * bh->b_blocknr;
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bh(rw=0x%x, blocknr=%llu (bytenr %llu),"
-			       " size=%zu, data=%p, bdev=%p)\n",
-			       rw, (unsigned long long)bh->b_blocknr,
+			       "submit_bh(op=%d rw=0x%x, blocknr=%llu "
+			       "(bytenr %llu), size=%zu, data=%p, bdev=%p)\n",
+			       op, op_flags, (unsigned long long)bh->b_blocknr,
 			       dev_bytenr, bh->b_size, bh->b_data, bh->b_bdev);
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      &bh->b_data, 1, NULL,
-					      NULL, bh, rw);
-	} else if (NULL != dev_state && (rw & REQ_FLUSH)) {
+					      NULL, bh, op, op_flags);
+	} else if (NULL != dev_state && (op_flags & REQ_FLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
 			       "submit_bh(rw=0x%x FLUSH, bdev=%p)\n",
-			       rw, bh->b_bdev);
+			       op, bh->b_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
 			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
@@ -2948,7 +2954,8 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 			block->never_written = 0;
 			block->iodone_w_error = 0;
 			block->flush_gen = dev_state->last_flush_gen + 1;
-			block->submit_bio_bh_rw = rw;
+			block->submit_bio_bh_op = op;
+			block->submit_bio_bh_op_flags = op_flags;
 			block->orig_bio_bh_private = bh->b_private;
 			block->orig_bio_bh_end_io.bh = bh->b_end_io;
 			block->next_in_same_bio = NULL;
@@ -2957,10 +2964,10 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 		}
 	}
 	mutex_unlock(&btrfsic_mutex);
-	return submit_bh(rw, bh);
+	return submit_bh(op | op_flags, bh);
 }
 
-static void __btrfsic_submit_bio(int rw, struct bio *bio)
+static void __btrfsic_submit_bio(int op, int op_flags, struct bio *bio)
 {
 	struct btrfsic_dev_state *dev_state;
 
@@ -2972,7 +2979,7 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 	 * btrfsic_mount(), this might return NULL */
 	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev);
 	if (NULL != dev_state &&
-	    (rw & WRITE) && NULL != bio->bi_io_vec) {
+	    (op == REQ_OP_WRITE) && NULL != bio->bi_io_vec) {
 		unsigned int i;
 		u64 dev_bytenr;
 		u64 cur_bytenr;
@@ -2986,7 +2993,7 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 			printk(KERN_INFO
 			       "submit_bio(rw=0x%x, bi_vcnt=%u,"
 			       " bi_sector=%llu (bytenr %llu), bi_bdev=%p)\n",
-			       rw, bio->bi_vcnt,
+			       op, bio->bi_vcnt,
 			       (unsigned long long)bio->bi_iter.bi_sector,
 			       dev_bytenr, bio->bi_bdev);
 
@@ -3017,18 +3024,18 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      mapped_datav, bio->bi_vcnt,
 					      bio, &bio_is_patched,
-					      NULL, rw);
+					      NULL, op, op_flags);
 		while (i > 0) {
 			i--;
 			kunmap(bio->bi_io_vec[i].bv_page);
 		}
 		kfree(mapped_datav);
-	} else if (NULL != dev_state && (rw & REQ_FLUSH)) {
+	} else if (NULL != dev_state && (op_flags & REQ_FLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
 			       "submit_bio(rw=0x%x FLUSH, bdev=%p)\n",
-			       rw, bio->bi_bdev);
+			       op, bio->bi_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
 			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
@@ -3046,7 +3053,8 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 			block->never_written = 0;
 			block->iodone_w_error = 0;
 			block->flush_gen = dev_state->last_flush_gen + 1;
-			block->submit_bio_bh_rw = rw;
+			block->submit_bio_bh_op = op;
+			block->submit_bio_bh_op_flags = op_flags;
 			block->orig_bio_bh_private = bio->bi_private;
 			block->orig_bio_bh_end_io.bio = bio->bi_end_io;
 			block->next_in_same_bio = NULL;
@@ -3060,13 +3068,13 @@ leave:
 
 void btrfsic_submit_bio(int op, int op_flags, struct bio *bio)
 {
-	__btrfsic_submit_bio(op | op_flags, bio);
+	__btrfsic_submit_bio(op, op_flags, bio);
 	submit_bio(op, op_flags, bio);
 }
 
 int btrfsic_submit_bio_wait(int op, int op_flags, struct bio *bio)
 {
-	__btrfsic_submit_bio(op | op_flags, bio);
+	__btrfsic_submit_bio(op, op_flags, bio);
 	return submit_bio_wait(op, op_flags, bio);
 }
 
diff --git a/fs/btrfs/check-integrity.h b/fs/btrfs/check-integrity.h
index a8edc424..97f7d49 100644
--- a/fs/btrfs/check-integrity.h
+++ b/fs/btrfs/check-integrity.h
@@ -20,7 +20,7 @@
 #define __BTRFS_CHECK_INTEGRITY__
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
-int btrfsic_submit_bh(int rw, struct buffer_head *bh);
+int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh);
 void btrfsic_submit_bio(int op, int op_flags, struct bio *bio);
 int btrfsic_submit_bio_wait(int op, int op_flags, struct bio *bio);
 #else
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6c17d5d..f1262e6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3323,9 +3323,9 @@ static int write_dev_supers(struct btrfs_device *device,
 		 * to go down lazy.
 		 */
 		if (i == 0)
-			ret = btrfsic_submit_bh(WRITE_FUA, bh);
+			ret = btrfsic_submit_bh(REQ_OP_WRITE, WRITE_FUA, bh);
 		else
-			ret = btrfsic_submit_bh(WRITE_SYNC, bh);
+			ret = btrfsic_submit_bh(REQ_OP_WRITE, WRITE_SYNC, bh);
 		if (ret)
 			errors++;
 	}
-- 
1.8.3.1
