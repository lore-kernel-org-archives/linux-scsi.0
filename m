From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/15] block copy: report the amount of copied data
Date: Thu, 10 Dec 2015 12:30:14 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101207360.25927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch changes blkdev_issue_copy so that it returns the number of
copied sectors in the variable "copied".

The kernel makes best effort to copy as much data as possible, but because
of device mapper mapping, it may be possible that copying fails at some
stage. If we just returned the error number, the caller wouldn't know if
all or part of the operation failed and the caller would be required to
redo the whole copy operation.

We return the number of copied sectors so that the caller can skip these
sectors when doing the copy manually. On success (zero return code), the
number of copied sectors is equal to the number of requested sectors. On
error (negative return code), the number of copied sectors is smaller than
the number of requested sectors.

The number of copied bytes is returned as a fourth uint64_t argument in
the BLKCOPY ioctl.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-lib.c           |   30 +++++++++++++++++++++++++-----
 block/ioctl.c             |   25 ++++++++++++++++---------
 include/linux/blk_types.h |    2 ++
 include/linux/blkdev.h    |    3 ++-
 4 files changed, 45 insertions(+), 15 deletions(-)

Index: linux-4.4-rc4/block/blk-lib.c
===================================================================
--- linux-4.4-rc4.orig/block/blk-lib.c	2015-12-10 17:04:38.000000000 +0100
+++ linux-4.4-rc4/block/blk-lib.c	2015-12-10 17:04:40.000000000 +0100
@@ -324,8 +324,17 @@ static void bio_copy_end_io(struct bio *
 	bio_put(bio);
 	if (atomic_dec_and_test(&bc->in_flight)) {
 		struct bio_batch *bb = bc->private;
-		if (unlikely(bc->error < 0) && !ACCESS_ONCE(bb->error))
-			ACCESS_ONCE(bb->error) = bc->error;
+		if (unlikely(bc->error < 0)) {
+			u64 first_error;
+			if (!ACCESS_ONCE(bb->error))
+				ACCESS_ONCE(bb->error) = bc->error;
+			do {
+				first_error = atomic64_read(bc->first_error);
+				if (bc->offset >= first_error)
+					break;
+			} while (unlikely(atomic64_cmpxchg(bc->first_error,
+				first_error, bc->offset) != first_error));
+		}
 		kfree(bc);
 		if (atomic_dec_and_test(&bb->done))
 			complete(bb->wait);
@@ -346,7 +355,7 @@ static void bio_copy_end_io(struct bio *
  */
 int blkdev_issue_copy(struct block_device *src_bdev, sector_t src_sector,
 		      struct block_device *dst_bdev, sector_t dst_sector,
-		      unsigned int nr_sects, gfp_t gfp_mask)
+		      sector_t nr_sects, gfp_t gfp_mask, sector_t *copied)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *sq = bdev_get_queue(src_bdev);
@@ -354,6 +363,11 @@ int blkdev_issue_copy(struct block_devic
 	unsigned int max_copy_sectors;
 	struct bio_batch bb;
 	int ret = 0;
+	atomic64_t first_error = ATOMIC64_INIT(nr_sects);
+	sector_t offset = 0;
+
+	if (copied)
+		*copied = 0;
 
 	if (!sq || !dq)
 		return -ENXIO;
@@ -377,10 +391,10 @@ int blkdev_issue_copy(struct block_devic
 	bb.error = 0;
 	bb.wait = &wait;
 
-	while (nr_sects) {
+	while (nr_sects && !ACCESS_ONCE(bb.error)) {
 		struct bio *read_bio, *write_bio;
 		struct bio_copy *bc;
-		unsigned int chunk = min(nr_sects, max_copy_sectors);
+		unsigned chunk = (unsigned)min(nr_sects, (sector_t)max_copy_sectors);
 
 		bc = kmalloc(sizeof(struct bio_copy), gfp_mask);
 		if (!bc) {
@@ -408,6 +422,8 @@ int blkdev_issue_copy(struct block_devic
 		bc->pair[0] = NULL;
 		bc->pair[1] = NULL;
 		bc->private = &bb;
+		bc->first_error = &first_error;
+		bc->offset = offset;
 		spin_lock_init(&bc->spinlock);
 
 		read_bio->bi_iter.bi_sector = src_sector;
@@ -429,12 +445,16 @@ int blkdev_issue_copy(struct block_devic
 		src_sector += chunk;
 		dst_sector += chunk;
 		nr_sects -= chunk;
+		offset += chunk;
 	}
 
 	/* Wait for bios in-flight */
 	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion_io(&wait);
 
+	if (copied)
+		*copied = min((sector_t)atomic64_read(&first_error), offset);
+
 	if (likely(!ret))
 		ret = bb.error;
 
Index: linux-4.4-rc4/include/linux/blk_types.h
===================================================================
--- linux-4.4-rc4.orig/include/linux/blk_types.h	2015-12-10 17:04:38.000000000 +0100
+++ linux-4.4-rc4/include/linux/blk_types.h	2015-12-10 17:04:40.000000000 +0100
@@ -49,6 +49,8 @@ struct bio_copy {
 	atomic_t in_flight;
 	struct bio *pair[2];
 	void *private;
+	atomic64_t *first_error;
+	sector_t offset;
 	spinlock_t spinlock;
 };
 
Index: linux-4.4-rc4/include/linux/blkdev.h
===================================================================
--- linux-4.4-rc4.orig/include/linux/blkdev.h	2015-12-10 17:04:30.000000000 +0100
+++ linux-4.4-rc4/include/linux/blkdev.h	2015-12-10 17:04:40.000000000 +0100
@@ -1141,7 +1141,8 @@ extern int blkdev_issue_discard(struct b
 extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_copy(struct block_device *, sector_t,
-		struct block_device *, sector_t, unsigned int, gfp_t);
+		struct block_device *, sector_t, sector_t, gfp_t,
+		sector_t *);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, bool discard);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
Index: linux-4.4-rc4/block/ioctl.c
===================================================================
--- linux-4.4-rc4.orig/block/ioctl.c	2015-12-10 17:04:30.000000000 +0100
+++ linux-4.4-rc4/block/ioctl.c	2015-12-10 17:04:40.000000000 +0100
@@ -250,8 +250,13 @@ static int blk_ioctl_zeroout(struct bloc
 }
 
 static int blk_ioctl_copy(struct block_device *bdev, uint64_t src_offset,
-			  uint64_t dst_offset, uint64_t len)
+			  uint64_t dst_offset, uint64_t len, uint64_t *copied)
 {
+	int ret;
+	sector_t copied_sec;
+
+	*copied = 0;
+
 	if (src_offset & 511)
 		return -EINVAL;
 	if (dst_offset & 511)
@@ -270,8 +275,12 @@ static int blk_ioctl_copy(struct block_d
 	    unlikely(dst_offset + len > (i_size_read(bdev->bd_inode) >> 9)))
 		return -EINVAL;
 
-	return blkdev_issue_copy(bdev, src_offset, bdev, dst_offset, len,
-				 GFP_KERNEL);
+	ret = blkdev_issue_copy(bdev, src_offset, bdev, dst_offset, len,
+				GFP_KERNEL, &copied_sec);
+
+	*copied = (uint64_t)copied_sec << 9;
+
+	return ret;
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
@@ -553,12 +562,10 @@ int blkdev_ioctl(struct block_device *bd
 		if (copy_from_user(range, (void __user *)arg, 24))
 			return -EFAULT;
 
-		ret = blk_ioctl_copy(bdev, range[0], range[1], range[2]);
-		if (!ret) {
-			range[3] = range[2];
-			if (copy_to_user((void __user *)(arg + 24), &range[3], 8))
-				return -EFAULT;
-		}
+		ret = blk_ioctl_copy(bdev, range[0], range[1], range[2], &range[3]);
+
+		if (copy_to_user((void __user *)(arg + 24), &range[3], 8))
+			return -EFAULT;
 
 		return ret;
 	}
