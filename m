From: mchristi@redhat.com
Subject: [PATCH 03/32] dio/btrfs: prep dio->submit_bio users for
	bi_rw split.
Date: Wed,  4 Nov 2015 16:08:00 -0600
Message-ID: <1446674909-5371-4-git-send-email-mchristi@redhat.com>
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

Instead of passing around a bitmap of ops and flags, the
next patches separate it into a op field and a flags field.
This patch prepares the dio code and dio->submit_bio users
for the split.

Note that the next patches will fix up the submit_bio() call
with along other users of that function.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/btrfs/inode.c   |  9 ++++-----
 fs/direct-io.c     | 34 +++++++++++++++++++++-------------
 include/linux/fs.h |  4 ++--
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 611b66d..0ad8bab 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8196,14 +8196,13 @@ out_err:
 	return 0;
 }
 
-static void btrfs_submit_direct(int rw, struct bio *dio_bio,
+static void btrfs_submit_direct(int op, int op_flags, struct bio *dio_bio,
 				struct inode *inode, loff_t file_offset)
 {
 	struct btrfs_dio_private *dip = NULL;
 	struct bio *io_bio = NULL;
 	struct btrfs_io_bio *btrfs_bio;
 	int skip_sum;
-	int write = rw & REQ_WRITE;
 	int ret = 0;
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
@@ -8232,14 +8231,14 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 	btrfs_bio = btrfs_io_bio(io_bio);
 	btrfs_bio->logical = file_offset;
 
-	if (write) {
+	if (op == REQ_OP_WRITE) {
 		io_bio->bi_end_io = btrfs_endio_direct_write;
 	} else {
 		io_bio->bi_end_io = btrfs_endio_direct_read;
 		dip->subio_endio = btrfs_subio_endio_read;
 	}
 
-	ret = btrfs_submit_direct_hook(rw, dip, skip_sum);
+	ret = btrfs_submit_direct_hook(op | op_flags, dip, skip_sum);
 	if (!ret)
 		return;
 
@@ -8267,7 +8266,7 @@ free_ordered:
 		dip = NULL;
 		io_bio = NULL;
 	} else {
-		if (write) {
+		if (op == REQ_OP_WRITE) {
 			struct btrfs_ordered_extent *ordered;
 
 			ordered = btrfs_lookup_ordered_extent(inode,
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1125629..5e1b1a0 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -108,7 +108,8 @@ struct dio_submit {
 /* dio_state communicated between submission path and end_io */
 struct dio {
 	int flags;			/* doesn't change */
-	int rw;
+	int op;
+	int op_flags;
 	struct inode *inode;
 	loff_t i_size;			/* i_size when submitted */
 	dio_iodone_t *end_io;		/* IO completion function */
@@ -160,7 +161,7 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 	ret = iov_iter_get_pages(sdio->iter, dio->pages, LONG_MAX, DIO_PAGES,
 				&sdio->from);
 
-	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
+	if (ret < 0 && sdio->blocks_available && (dio->op == REQ_OP_WRITE)) {
 		struct page *page = ZERO_PAGE(0);
 		/*
 		 * A memory fault, but the filesystem has some outstanding
@@ -239,7 +240,8 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
 		transferred = dio->result;
 
 		/* Check for short read case */
-		if ((dio->rw == READ) && ((offset + transferred) > dio->i_size))
+		if ((dio->op == REQ_OP_READ) &&
+		    ((offset + transferred) > dio->i_size))
 			transferred = dio->i_size - offset;
 	}
 
@@ -257,7 +259,7 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
 		inode_dio_end(dio->inode);
 
 	if (is_async) {
-		if (dio->rw & WRITE) {
+		if (dio->op == REQ_OP_WRITE) {
 			int err;
 
 			err = generic_write_sync(dio->iocb->ki_filp, offset,
@@ -393,14 +395,14 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	dio->refcount++;
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
-	if (dio->is_async && dio->rw == READ)
+	if (dio->is_async && dio->op == REQ_OP_READ)
 		bio_set_pages_dirty(bio);
 
 	if (sdio->submit_io)
-		sdio->submit_io(dio->rw, bio, dio->inode,
+		sdio->submit_io(dio->op, dio->op_flags, bio, dio->inode,
 			       sdio->logical_offset_in_bio);
 	else
-		submit_bio(dio->rw, bio);
+		submit_bio(dio->op | dio->op_flags, bio);
 
 	sdio->bio = NULL;
 	sdio->boundary = 0;
@@ -464,14 +466,14 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 	if (bio->bi_error)
 		dio->io_error = -EIO;
 
-	if (dio->is_async && dio->rw == READ) {
+	if (dio->is_async && dio->op == REQ_OP_READ) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 		err = bio->bi_error;
 	} else {
 		bio_for_each_segment_all(bvec, bio, i) {
 			struct page *page = bvec->bv_page;
 
-			if (dio->rw == READ && !PageCompound(page))
+			if (dio->op == REQ_OP_READ && !PageCompound(page))
 				set_page_dirty_lock(page);
 			page_cache_release(page);
 		}
@@ -623,7 +625,7 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 		 * which may decide to handle it or also return an unmapped
 		 * buffer head.
 		 */
-		create = dio->rw & WRITE;
+		create = dio->op == REQ_OP_WRITE;
 		if (dio->flags & DIO_SKIP_HOLES) {
 			if (sdio->block_in_file < (i_size_read(dio->inode) >>
 							sdio->blkbits))
@@ -773,7 +775,7 @@ submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 {
 	int ret = 0;
 
-	if (dio->rw & WRITE) {
+	if (dio->op == REQ_OP_WRITE) {
 		/*
 		 * Read accounting is performed in submit_bio()
 		 */
@@ -973,7 +975,7 @@ do_holes:
 				loff_t i_size_aligned;
 
 				/* AKPM: eargh, -ENOTBLK is a hack */
-				if (dio->rw & WRITE) {
+				if (dio->op == REQ_OP_WRITE) {
 					page_cache_release(page);
 					return -ENOTBLK;
 				}
@@ -1176,7 +1178,13 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 		dio->is_async = true;
 
 	dio->inode = inode;
-	dio->rw = iov_iter_rw(iter) == WRITE ? WRITE_ODIRECT : READ;
+	if (iov_iter_rw(iter) == WRITE) {
+		dio->op = REQ_OP_WRITE;
+		dio->op_flags = WRITE_ODIRECT;
+	} else {
+		dio->op = REQ_OP_READ;
+		dio->op_flags = 0;
+	}
 
 	/*
 	 * For AIO O_(D)SYNC writes we need to defer completions to a workqueue
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 72d8a84..601b842 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2678,8 +2678,8 @@ extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
 #ifdef CONFIG_BLOCK
-typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
-			    loff_t file_offset);
+typedef void (dio_submit_t)(int op, int op_flags, struct bio *bio,
+			    struct inode *inode, loff_t file_offset);
 
 enum {
 	/* need locking between buffered and direct access */
-- 
1.8.3.1
