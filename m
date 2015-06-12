From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] [RFC] block: Add blk_max_rw_sectors attribute
Date: Fri, 12 Jun 2015 11:12:42 -0500
Message-ID: <201506121612.t5CGCiTa004134@d01av05.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:40001 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbFLQMv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2015 12:12:51 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 12 Jun 2015 12:12:50 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id DDEB06E8048
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2015 12:04:33 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5CGCkUq64487478
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2015 16:12:46 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5CGCjNb004251
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2015 12:12:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, axboe@kernel.dk, brking@linux.vnet.ibm.com


The commit bcdb247c6b6a1f3e72b9b787b73f47dd509d17ec "sd: Limit transfer length"
added support for setting max_hw_sectors based on the block limits VPD page.
As defined in the transfer limit table in the block limits VPD page section
of SBC4, this value is only supposed to apply to a small subset of SCSI
opcodes. However, we are using that value for all SCSI commands. I ran into
this with a new disk drive we are qualifying which is reporting a value here
that is smaller than the size of its firmware image, which means
sg_write_buffer fails when trying to update the drive code. This can be
worked around at the application level by segmenting the write buffer, but
given that we are not obeying SBC4 in our treatment of this field, it would
be nice to fix up the kernel to do the right thing. Additionally, we might
run into other issues related to this in the future. This patch adds a new
max_rw_sectors attribute on the block device to reflect this max read/write
transfer size for media commands that the device supports.

Its not clear to me we want to expose yet another max transfer size attribute
on the block device. An alternative would be to keep this attibute hidden and
then either allow non medium commands larger than max_hw_sectors through the
block layer or have max_hw_sectors reflect the max transfer size supported
by the adapter, as it used to be, and then only allow userspace to increase
max_sectors to the largest value supported by the device, but that would
likely be confusing to users wondering why they can't set max_sectors to
max_hw_sectors.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 block/blk-map.c        |    2 +-
 block/blk-settings.c   |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 block/blk-sysfs.c      |   17 ++++++++++++++++-
 block/scsi_ioctl.c     |    5 +++++
 drivers/scsi/sd.c      |    2 +-
 include/linux/blkdev.h |   36 +++++++++++++++++++++++++++++++++++-
 6 files changed, 103 insertions(+), 5 deletions(-)

diff -puN block/blk-sysfs.c~blk_max_rw_sectors block/blk-sysfs.c
--- linux/block/blk-sysfs.c~blk_max_rw_sectors	2015-06-11 20:34:58.982990113 -0500
+++ linux-bjking1/block/blk-sysfs.c	2015-06-11 20:34:59.007989898 -0500
@@ -167,13 +167,15 @@ queue_max_sectors_store(struct request_q
 {
 	unsigned long max_sectors_kb,
 		max_hw_sectors_kb = queue_max_hw_sectors(q) >> 1,
+			max_rw_sectors_kb = queue_max_rw_sectors(q) >> 1,
 			page_kb = 1 << (PAGE_CACHE_SHIFT - 10);
 	ssize_t ret = queue_var_store(&max_sectors_kb, page, count);
 
 	if (ret < 0)
 		return ret;
 
-	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb)
+	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb ||
+	    max_sectors_kb > max_rw_sectors_kb)
 		return -EINVAL;
 
 	spin_lock_irq(q->queue_lock);
@@ -190,6 +192,13 @@ static ssize_t queue_max_hw_sectors_show
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_max_rw_sectors_show(struct request_queue *q, char *page)
+{
+	int max_rw_sectors_kb = queue_max_rw_sectors(q) >> 1;
+
+	return queue_var_show(max_rw_sectors_kb, (page));
+}
+
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
 static ssize_t								\
 queue_show_##name(struct request_queue *q, char *page)			\
@@ -308,6 +317,11 @@ static struct queue_sysfs_entry queue_ma
 	.show = queue_max_hw_sectors_show,
 };
 
+static struct queue_sysfs_entry queue_max_rw_sectors_entry = {
+	.attr = {.name = "max_rw_sectors_kb", .mode = S_IRUGO },
+	.show = queue_max_rw_sectors_show,
+};
+
 static struct queue_sysfs_entry queue_max_segments_entry = {
 	.attr = {.name = "max_segments", .mode = S_IRUGO },
 	.show = queue_max_segments_show,
@@ -408,6 +422,7 @@ static struct attribute *default_attrs[]
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
+	&queue_max_rw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
 	&queue_max_segments_entry.attr,
 	&queue_max_integrity_segments_entry.attr,
diff -puN block/blk-settings.c~blk_max_rw_sectors block/blk-settings.c
--- linux/block/blk-settings.c~blk_max_rw_sectors	2015-06-11 20:34:58.986990077 -0500
+++ linux-bjking1/block/blk-settings.c	2015-06-11 20:34:59.012989853 -0500
@@ -112,7 +112,7 @@ void blk_set_default_limits(struct queue
 	lim->max_integrity_segments = 0;
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
-	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
+	lim->max_sectors = lim->max_rw_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
 	lim->chunk_sectors = 0;
 	lim->max_write_same_sectors = 0;
 	lim->max_discard_sectors = 0;
@@ -145,6 +145,7 @@ void blk_set_stacking_limits(struct queu
 	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
+	lim->max_rw_sectors = UINT_MAX;
 	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
 	lim->max_write_same_sectors = UINT_MAX;
@@ -262,6 +263,48 @@ void blk_limits_max_hw_sectors(struct qu
 EXPORT_SYMBOL(blk_limits_max_hw_sectors);
 
 /**
+ * blk_limits_max_rw_sectors - set hard and soft limit of max sectors for request
+ * @limits: the queue limits
+ * @max_rw_sectors:  max read/write sectors in the usual 512b unit
+ *
+ * Description:
+ *    Enables a low level driver to set a hard upper limit,
+ *    max_rw_sectors, on the size of requests.  max_rw_sectors is set by
+ *    the device driver based upon the combined capabilities of I/O
+ *    controller and storage device. This limit applies only to read/write requests
+ *
+ *    max_sectors is a soft limit imposed by the block layer for
+ *    filesystem type requests.  This value can be overridden on a
+ *    per-device basis in /sys/block/<device>/queue/max_sectors_kb.
+ *    The soft limit can not exceed max_hw_sectors or max_rw_sectors
+ **/
+void blk_limits_max_rw_sectors(struct queue_limits *limits, unsigned int max_rw_sectors)
+{
+	if ((max_rw_sectors << 9) < PAGE_CACHE_SIZE) {
+		max_rw_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_rw_sectors);
+	}
+
+	limits->max_sectors = limits->max_rw_sectors = max_rw_sectors;
+}
+EXPORT_SYMBOL(blk_limits_max_rw_sectors);
+
+/**
+ * blk_queue_max_rw_sectors - set max sectors for a request for this queue
+ * @q:  the request queue for the device
+ * @max_rw_sectors:  max read/write sectors in the usual 512b unit
+ *
+ * Description:
+ *    See description for blk_limits_max_rw_sectors().
+ **/
+void blk_queue_max_rw_sectors(struct request_queue *q, unsigned int max_rw_sectors)
+{
+	blk_limits_max_rw_sectors(&q->limits, max_rw_sectors);
+}
+EXPORT_SYMBOL(blk_queue_max_rw_sectors);
+
+/**
  * blk_queue_max_hw_sectors - set max sectors for a request for this queue
  * @q:  the request queue for the device
  * @max_hw_sectors:  max hardware sectors in the usual 512b unit
@@ -544,6 +587,7 @@ int blk_stack_limits(struct queue_limits
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
+	t->max_rw_sectors = min_not_zero(t->max_rw_sectors, b->max_rw_sectors);
 	t->max_write_same_sectors = min(t->max_write_same_sectors,
 					b->max_write_same_sectors);
 	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
diff -puN include/linux/blkdev.h~blk_max_rw_sectors include/linux/blkdev.h
--- linux/include/linux/blkdev.h~blk_max_rw_sectors	2015-06-11 20:34:58.989990053 -0500
+++ linux-bjking1/include/linux/blkdev.h	2015-06-11 20:34:59.015989829 -0500
@@ -22,6 +22,7 @@
 #include <linux/smp.h>
 #include <linux/rcupdate.h>
 #include <linux/percpu-refcount.h>
+#include <scsi/scsi.h>
 
 #include <asm/scatterlist.h>
 
@@ -286,6 +287,7 @@ struct queue_limits {
 	unsigned long		seg_boundary_mask;
 
 	unsigned int		max_hw_sectors;
+	unsigned int		max_rw_sectors;
 	unsigned int		chunk_sectors;
 	unsigned int		max_sectors;
 	unsigned int		max_segment_size;
@@ -928,12 +930,37 @@ static inline unsigned int blk_max_size_
 			(offset & (q->limits.chunk_sectors - 1));
 }
 
+static inline unsigned int blk_rq_get_max_hw_sectors(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+
+	/* move to scsi.c or scsi_lib.c and do table lookup instead? */
+	switch (rq->cmd[0]) {
+	case READ_6:
+	case READ_10:
+	case READ_12:
+	case READ_16:
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+	case VERIFY:
+	case VERIFY_12:
+	case VERIFY_16:
+	case WRITE_VERIFY:
+	case WRITE_VERIFY_12:
+		return q->limits.max_rw_sectors;
+	default:
+		return q->limits.max_hw_sectors;
+	};
+}
+
 static inline unsigned int blk_rq_get_max_sectors(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
 	if (unlikely(rq->cmd_type == REQ_TYPE_BLOCK_PC))
-		return q->limits.max_hw_sectors;
+		return blk_rq_get_max_hw_sectors(rq);
 
 	if (!q->limits.chunk_sectors)
 		return blk_queue_get_max_sectors(q, rq->cmd_flags);
@@ -1004,7 +1031,9 @@ extern void blk_cleanup_queue(struct req
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_limits_max_hw_sectors(struct queue_limits *, unsigned int);
+extern void blk_limits_max_rw_sectors(struct queue_limits *, unsigned int);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
+extern void blk_queue_max_rw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
@@ -1213,6 +1242,11 @@ static inline unsigned int queue_max_hw_
 	return q->limits.max_hw_sectors;
 }
 
+static inline unsigned int queue_max_rw_sectors(struct request_queue *q)
+{
+	return q->limits.max_rw_sectors;
+}
+
 static inline unsigned short queue_max_segments(struct request_queue *q)
 {
 	return q->limits.max_segments;
diff -puN block/blk-map.c~blk_max_rw_sectors block/blk-map.c
--- linux/block/blk-map.c~blk_max_rw_sectors	2015-06-11 20:34:58.992990026 -0500
+++ linux-bjking1/block/blk-map.c	2015-06-11 20:34:59.017989812 -0500
@@ -187,7 +187,7 @@ int blk_rq_map_kern(struct request_queue
 	struct bio *bio;
 	int ret;
 
-	if (len > (queue_max_hw_sectors(q) << 9))
+	if (len > (blk_rq_get_max_hw_sectors(rq) << 9))
 		return -EINVAL;
 	if (!len || !kbuf)
 		return -EINVAL;
diff -puN block/bio.c~blk_max_rw_sectors block/bio.c
diff -puN block/scsi_ioctl.c~blk_max_rw_sectors block/scsi_ioctl.c
--- linux/block/scsi_ioctl.c~blk_max_rw_sectors	2015-06-11 20:34:58.998989975 -0500
+++ linux-bjking1/block/scsi_ioctl.c	2015-06-11 20:34:59.020989785 -0500
@@ -330,6 +330,11 @@ static int sg_io(struct request_queue *q
 	if (blk_fill_sghdr_rq(q, rq, hdr, mode))
 		goto out_free_cdb;
 
+	if (hdr->dxfer_len > (blk_rq_get_max_hw_sectors(rq) << 9)) {
+		ret = -EIO;
+		goto out_free_cdb;
+	}
+
 	ret = 0;
 	if (hdr->iovec_count) {
 		struct iov_iter i;
diff -puN drivers/scsi/sd.c~blk_max_rw_sectors drivers/scsi/sd.c
--- linux/drivers/scsi/sd.c~blk_max_rw_sectors	2015-06-11 20:34:59.001989948 -0500
+++ linux-bjking1/drivers/scsi/sd.c	2015-06-11 20:34:59.022989767 -0500
@@ -2781,7 +2781,7 @@ static int sd_revalidate_disk(struct gen
 
 	max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
 				max_xfer);
-	blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
+	blk_queue_max_rw_sectors(sdkp->disk->queue, max_xfer);
 	set_capacity(disk, sdkp->capacity);
 	sd_config_write_same(sdkp);
 	kfree(buffer);
_

