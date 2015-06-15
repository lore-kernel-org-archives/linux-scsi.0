From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] [PATCH] block: Add blk_max_rw_sectors limit
Date: Mon, 15 Jun 2015 14:02:42 -0500
Message-ID: <201506151902.t5FJ2giY001071@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:41123 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbbFOTCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2015 15:02:50 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 15 Jun 2015 15:02:50 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id E9AD56E804D
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2015 14:54:34 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5FJ2m7552887648
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2015 19:02:48 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5FJ2iwR001259
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2015 15:02:47 -0400
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
sg_write_buffer fails when trying to update the drive code. This patch adds a
new max_rw_sectors limit on the block device to reflect this max read/write
transfer size for media commands that the device supports. It restricts
max_sectors_kb from being set to a value larger than this and removes any
policing of per target limits for BLOCK_PC requests.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 block/blk-settings.c   |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 block/blk-sysfs.c      |    4 +++-
 drivers/scsi/sd.c      |    2 +-
 include/linux/blkdev.h |    8 ++++++++
 4 files changed, 57 insertions(+), 3 deletions(-)

diff -puN block/blk-settings.c~blk_max_rw_sectors2 block/blk-settings.c
--- linux/block/blk-settings.c~blk_max_rw_sectors2	2015-06-15 07:58:04.654048551 -0500
+++ linux-bjking1/block/blk-settings.c	2015-06-15 13:55:39.367136836 -0500
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
+ *    the device driver based upon the capabilities of the storage device.
+ *    This limit does not apply to REQ_TYPE_BLOCK_PC requests.
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
diff -puN block/blk-sysfs.c~blk_max_rw_sectors2 block/blk-sysfs.c
--- linux/block/blk-sysfs.c~blk_max_rw_sectors2	2015-06-15 07:58:04.658048519 -0500
+++ linux-bjking1/block/blk-sysfs.c	2015-06-15 07:58:04.680048347 -0500
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
diff -puN drivers/scsi/sd.c~blk_max_rw_sectors2 drivers/scsi/sd.c
--- linux/drivers/scsi/sd.c~blk_max_rw_sectors2	2015-06-15 07:58:04.665048465 -0500
+++ linux-bjking1/drivers/scsi/sd.c	2015-06-15 07:58:04.684048315 -0500
@@ -2781,7 +2781,7 @@ static int sd_revalidate_disk(struct gen
 
 	max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
 				max_xfer);
-	blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
+	blk_queue_max_rw_sectors(sdkp->disk->queue, max_xfer);
 	set_capacity(disk, sdkp->capacity);
 	sd_config_write_same(sdkp);
 	kfree(buffer);
diff -puN include/linux/blkdev.h~blk_max_rw_sectors2 include/linux/blkdev.h
--- linux/include/linux/blkdev.h~blk_max_rw_sectors2	2015-06-15 07:58:04.669048433 -0500
+++ linux-bjking1/include/linux/blkdev.h	2015-06-15 07:58:04.688048283 -0500
@@ -286,6 +286,7 @@ struct queue_limits {
 	unsigned long		seg_boundary_mask;
 
 	unsigned int		max_hw_sectors;
+	unsigned int		max_rw_sectors;
 	unsigned int		chunk_sectors;
 	unsigned int		max_sectors;
 	unsigned int		max_segment_size;
@@ -1004,7 +1005,9 @@ extern void blk_cleanup_queue(struct req
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_limits_max_hw_sectors(struct queue_limits *, unsigned int);
+extern void blk_limits_max_rw_sectors(struct queue_limits *, unsigned int);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
+extern void blk_queue_max_rw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
@@ -1213,6 +1216,11 @@ static inline unsigned int queue_max_hw_
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
_

