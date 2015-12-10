From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 8/15] block copy: introduce "copy_boundary" limits
Date: Thu, 10 Dec 2015 12:30:44 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101213000.25927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is no way to split copy requests, so the creator of the requests
(the function blkdev_issue_copy) must make requests with proper size.
Device mapper splits the requests at a boundary between targets or at
a boundary specified by each target driver. We must make sure that the
copy requets do not cross these boundaries.

This patch introduces a new queue limit "copy_boundary", it is log2 of the
boundary in sectors that the request must not cross. Device mapper will
use this limit to propagate its requirements through the device stack.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-lib.c        |   21 ++++++++++++++++++++-
 block/blk-settings.c   |   17 +++++++++++++++++
 block/blk-sysfs.c      |   13 +++++++++++++
 include/linux/blkdev.h |    1 +
 4 files changed, 51 insertions(+), 1 deletion(-)

Index: linux-4.4-rc4/block/blk-settings.c
===================================================================
--- linux-4.4-rc4.orig/block/blk-settings.c	2015-12-10 17:04:30.000000000 +0100
+++ linux-4.4-rc4/block/blk-settings.c	2015-12-10 17:04:54.000000000 +0100
@@ -96,6 +96,7 @@ void blk_set_default_limits(struct queue
 	lim->chunk_sectors = 0;
 	lim->max_write_same_sectors = 0;
 	lim->max_copy_sectors = 0;
+	lim->copy_boundary = 63;
 	lim->max_discard_sectors = 0;
 	lim->max_hw_discard_sectors = 0;
 	lim->discard_granularity = 0;
@@ -311,6 +312,18 @@ void blk_queue_max_copy_sectors(struct r
 EXPORT_SYMBOL(blk_queue_max_copy_sectors);
 
 /**
+ * blk_queue_copy_boundary - set a boundary for copy operations. No copy
+ * operation may cross the boundary
+ * @q:  the request queue for the device
+ * @copy_boundary: log2 of the copy boundary in sectors
+ **/
+void blk_queue_copy_boundary(struct request_queue *q,
+			     unsigned char copy_boundary)
+{
+	q->limits.copy_boundary = copy_boundary;
+}
+
+/**
  * blk_queue_max_segments - set max hw segments for a request for this queue
  * @q:  the request queue for the device
  * @max_segments:  max number of segments
@@ -552,6 +565,10 @@ int blk_stack_limits(struct queue_limits
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
 
+	t->copy_boundary = min(t->copy_boundary, b->copy_boundary);
+	if (start)
+		t->copy_boundary = min(t->copy_boundary, (unsigned char)__ffs64(start));
+
 	t->misaligned |= b->misaligned;
 
 	alignment = queue_limit_alignment_offset(b, start);
Index: linux-4.4-rc4/block/blk-sysfs.c
===================================================================
--- linux-4.4-rc4.orig/block/blk-sysfs.c	2015-12-10 17:04:30.000000000 +0100
+++ linux-4.4-rc4/block/blk-sysfs.c	2015-12-10 17:04:54.000000000 +0100
@@ -199,6 +199,13 @@ static ssize_t queue_copy_max_show(struc
 		(unsigned long long)q->limits.max_copy_sectors << 9);
 }
 
+static ssize_t queue_copy_boundary_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n",
+		!q->limits.max_copy_sectors || q->limits.copy_boundary == 63 ?
+		0ULL : 512ULL << q->limits.copy_boundary);
+}
+
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -453,6 +460,11 @@ static struct queue_sysfs_entry queue_co
 	.show = queue_copy_max_show,
 };
 
+static struct queue_sysfs_entry queue_copy_boundary_entry = {
+	.attr = {.name = "copy_boundary_bytes", .mode = S_IRUGO },
+	.show = queue_copy_boundary_show,
+};
+
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_show_nonrot,
@@ -509,6 +521,7 @@ static struct attribute *default_attrs[]
 	&queue_discard_zeroes_data_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_copy_max_entry.attr,
+	&queue_copy_boundary_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
Index: linux-4.4-rc4/include/linux/blkdev.h
===================================================================
--- linux-4.4-rc4.orig/include/linux/blkdev.h	2015-12-10 17:04:46.000000000 +0100
+++ linux-4.4-rc4/include/linux/blkdev.h	2015-12-10 17:04:54.000000000 +0100
@@ -273,6 +273,7 @@ struct queue_limits {
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 
+	unsigned char		copy_boundary;
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		cluster;
Index: linux-4.4-rc4/block/blk-lib.c
===================================================================
--- linux-4.4-rc4.orig/block/blk-lib.c	2015-12-10 17:04:46.000000000 +0100
+++ linux-4.4-rc4/block/blk-lib.c	2015-12-10 17:04:54.000000000 +0100
@@ -447,6 +447,12 @@ int blkdev_issue_copy(struct block_devic
 		goto end_callback;
 	}
 
+	/*
+	 * TODO: if copy_boundary is too small, we'd better reject this
+	 * request and let the caller perform copy manually. The threshold
+	 * should be determined experimentally.
+	 */
+
 	if (src_sector + nr_sects < src_sector ||
 	    dst_sector + nr_sects < dst_sector) {
 		ret = -EINVAL;
@@ -484,7 +490,20 @@ int blkdev_issue_copy(struct block_devic
 	while (nr_sects && !ACCESS_ONCE(batch->async_error)) {
 		struct bio *read_bio, *write_bio;
 		struct bio_copy *bc;
-		unsigned chunk = (unsigned)min(nr_sects, (sector_t)max_copy_sectors);
+		unsigned chunk;
+		u64 boundary, max_io;
+
+		chunk = (unsigned)min(nr_sects, (sector_t)max_copy_sectors);
+
+		boundary = 1ULL << sq->limits.copy_boundary;
+		max_io = boundary - (src_sector & (boundary - 1));
+		if (chunk > max_io)
+			chunk = max_io;
+
+		boundary = 1ULL << dq->limits.copy_boundary;
+		max_io = boundary - (dst_sector & (boundary - 1));
+		if (chunk > max_io)
+			chunk = max_io;
 
 		bc = kmalloc(sizeof(struct bio_copy), gfp_mask);
 		if (!bc) {
