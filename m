From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] drop vmerge accounting
Date: Fri, 15 Aug 2008 14:23:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0808151418240.24727@hs20-bc2-1.build.redhat.com>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp>
 <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp>
 <20080808063527.GJ20055@kernel.dk> <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com>
 <20080815094800.GI20055@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216AbYHOSZe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 14:25:34 -0400
In-Reply-To: <20080815094800.GI20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net, drzeus-mmc@drzeus.cx

> I have applied this and the previous, with a fixup to raid5 to overload
> both active stripe and process count in bi_phys_segments.
> 
> -- 
> Jens Axboe

Hi

So here are two new patches. Patch 3 drops blk_queue_max_hw_segments 
function and max_hw_segments entry. I checked all the drivers, most of 
them set blk_queue_max_hw_segments equal to blk_queue_max_phys_segments, 
for the few ones that don't (for example scsi_lib.c), I set minimum of the 
two values with blk_queue_max_phys_segments.

The next patch 4 drops the hw_segments logic from MMC card subsystem.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com

---
 arch/um/drivers/ubd_kern.c          |    2 -
 block/blk-core.c                    |    1 
 block/blk-merge.c                   |    6 -----
 block/blk-settings.c                |   38 ++++--------------------------------
 block/elevator.c                    |    2 -
 drivers/ata/sata_nv.c               |    2 -
 drivers/block/DAC960.c              |    1 
 drivers/block/cciss.c               |    3 --
 drivers/block/cpqarray.c            |    3 --
 drivers/block/paride/pf.c           |    1 
 drivers/block/ps3disk.c             |    1 
 drivers/block/sunvdc.c              |    1 
 drivers/block/sx8.c                 |    1 
 drivers/block/ub.c                  |    1 
 drivers/block/viodasd.c             |    1 
 drivers/block/virtio_blk.c          |    2 -
 drivers/block/xen-blkfront.c        |    1 
 drivers/cdrom/gdrom.c               |    2 -
 drivers/cdrom/viocd.c               |    1 
 drivers/ide/ide-probe.c             |    1 
 drivers/md/dm-table.c               |    9 --------
 drivers/md/raid5.c                  |    3 --
 drivers/memstick/core/mspro_block.c |    1 
 drivers/message/i2o/i2o_block.c     |    4 ---
 drivers/mmc/card/queue.c            |    5 +---
 drivers/s390/block/dasd.c           |    1 
 drivers/s390/char/tape_block.c      |    1 
 drivers/scsi/scsi_lib.c             |    3 --
 drivers/scsi/sg.c                   |    5 +---
 drivers/scsi/st.c                   |    3 --
 fs/bio.c                            |    5 ----
 include/linux/blkdev.h              |    3 --
 include/linux/device-mapper.h       |    1 
 33 files changed, 20 insertions(+), 95 deletions(-)

Index: linux-2.6.27-rc3-devel/block/blk-merge.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/block/blk-merge.c	2008-08-15 19:07:26.000000000 +0200
+++ linux-2.6.27-rc3-devel/block/blk-merge.c	2008-08-15 19:07:42.000000000 +0200
@@ -236,8 +236,7 @@ static inline int ll_new_hw_segment(stru
 {
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_phys_segments + nr_phys_segs > q->max_hw_segments
-	    || req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
+	if (req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -326,9 +325,6 @@ static int ll_merge_requests_fn(struct r
 	if (total_phys_segments > q->max_phys_segments)
 		return 0;
 
-	if (total_phys_segments > q->max_hw_segments)
-		return 0;
-
 	/* Merge is OK... */
 	req->nr_phys_segments = total_phys_segments;
 	return 1;
Index: linux-2.6.27-rc3-devel/include/linux/blkdev.h
===================================================================
--- linux-2.6.27-rc3-devel.orig/include/linux/blkdev.h	2008-08-15 19:05:50.000000000 +0200
+++ linux-2.6.27-rc3-devel/include/linux/blkdev.h	2008-08-15 19:16:29.000000000 +0200
@@ -353,7 +353,6 @@ struct request_queue
 	unsigned int		max_sectors;
 	unsigned int		max_hw_sectors;
 	unsigned short		max_phys_segments;
-	unsigned short		max_hw_segments;
 	unsigned short		hardsect_size;
 	unsigned int		max_segment_size;
 
@@ -764,7 +763,6 @@ extern void blk_queue_make_request(struc
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_queue_max_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_phys_segments(struct request_queue *, unsigned short);
-extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
@@ -833,7 +831,6 @@ extern int blk_register_filter(struct ge
 extern void blk_unregister_filter(struct gendisk *disk);
 
 #define MAX_PHYS_SEGMENTS 128
-#define MAX_HW_SEGMENTS 128
 #define SAFE_MAX_SECTORS 255
 #define BLK_DEF_MAX_SECTORS 1024
 
Index: linux-2.6.27-rc3-devel/block/blk-settings.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/block/blk-settings.c	2008-08-15 19:09:45.000000000 +0200
+++ linux-2.6.27-rc3-devel/block/blk-settings.c	2008-08-15 19:09:49.000000000 +0200
@@ -89,7 +89,6 @@ void blk_queue_make_request(struct reque
 	 */
 	q->nr_requests = BLKDEV_MAX_RQ;
 	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
-	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
 	q->make_request_fn = mfn;
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
@@ -205,30 +204,6 @@ void blk_queue_max_phys_segments(struct 
 EXPORT_SYMBOL(blk_queue_max_phys_segments);
 
 /**
- * blk_queue_max_hw_segments - set max hw segments for a request for this queue
- * @q:  the request queue for the device
- * @max_segments:  max number of segments
- *
- * Description:
- *    Enables a low level driver to set an upper limit on the number of
- *    hw data segments in a request.  This would be the largest number of
- *    address/length pairs the host adapter can actually give as once
- *    to the device.
- **/
-void blk_queue_max_hw_segments(struct request_queue *q,
-			       unsigned short max_segments)
-{
-	if (!max_segments) {
-		max_segments = 1;
-		printk(KERN_INFO "%s: set to minimum %d\n",
-		       __func__, max_segments);
-	}
-
-	q->max_hw_segments = max_segments;
-}
-EXPORT_SYMBOL(blk_queue_max_hw_segments);
-
-/**
  * blk_queue_max_segment_size - set max segment size for blk_rq_map_sg
  * @q:  the request queue for the device
  * @max_size:  max size of segment in bytes
@@ -283,7 +258,6 @@ void blk_queue_stack_limits(struct reque
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
 
 	t->max_phys_segments = min(t->max_phys_segments, b->max_phys_segments);
-	t->max_hw_segments = min(t->max_hw_segments, b->max_hw_segments);
 	t->max_segment_size = min(t->max_segment_size, b->max_segment_size);
 	t->hardsect_size = max(t->hardsect_size, b->hardsect_size);
 	if (!t->queue_lock)
@@ -346,21 +320,19 @@ EXPORT_SYMBOL(blk_queue_update_dma_pad);
  * does is adjust the queue so that the buf is always appended
  * silently to the scatterlist.
  *
- * Note: This routine adjusts max_hw_segments to make room for
- * appending the drain buffer.  If you call
- * blk_queue_max_hw_segments() or blk_queue_max_phys_segments() after
- * calling this routine, you must set the limit to one fewer than your
- * device can support otherwise there won't be room for the drain
+ * Note: This routine adjusts max_phys_segments to make room for
+ * appending the drain buffer.  If you call * blk_queue_max_phys_segments()
+ * after calling this routine, you must set the limit to one fewer than
+ * your device can support otherwise there won't be room for the drain
  * buffer.
  */
 int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size)
 {
-	if (q->max_hw_segments < 2 || q->max_phys_segments < 2)
+	if (q->max_phys_segments < 2)
 		return -EINVAL;
 	/* make room for appending the drain */
-	--q->max_hw_segments;
 	--q->max_phys_segments;
 	q->dma_drain_needed = dma_drain_needed;
 	q->dma_drain_buffer = buf;
Index: linux-2.6.27-rc3-devel/block/elevator.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/block/elevator.c	2008-08-15 19:10:00.000000000 +0200
+++ linux-2.6.27-rc3-devel/block/elevator.c	2008-08-15 19:10:15.000000000 +0200
@@ -777,7 +777,7 @@ struct request *elv_next_request(struct 
 		if (q->dma_drain_size && rq->data_len) {
 			/*
 			 * make sure space for the drain appears we
-			 * know we can do this because max_hw_segments
+			 * know we can do this because max_phys_segments
 			 * has been adjusted to be one fewer than the
 			 * device can handle
 			 */
Index: linux-2.6.27-rc3-devel/drivers/md/dm-table.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/md/dm-table.c	2008-08-15 19:10:24.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/md/dm-table.c	2008-08-15 19:10:56.000000000 +0200
@@ -91,9 +91,6 @@ static void combine_restrictions_low(str
 	lhs->max_phys_segments =
 		min_not_zero(lhs->max_phys_segments, rhs->max_phys_segments);
 
-	lhs->max_hw_segments =
-		min_not_zero(lhs->max_hw_segments, rhs->max_hw_segments);
-
 	lhs->hardsect_size = max(lhs->hardsect_size, rhs->hardsect_size);
 
 	lhs->max_segment_size =
@@ -504,9 +501,6 @@ void dm_set_device_limits(struct dm_targ
 		min_not_zero(rs->max_phys_segments,
 			     q->max_phys_segments);
 
-	rs->max_hw_segments =
-		min_not_zero(rs->max_hw_segments, q->max_hw_segments);
-
 	rs->hardsect_size = max(rs->hardsect_size, q->hardsect_size);
 
 	rs->max_segment_size =
@@ -656,8 +650,6 @@ static void check_for_valid_limits(struc
 		rs->max_hw_sectors = SAFE_MAX_SECTORS;
 	if (!rs->max_phys_segments)
 		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
-	if (!rs->max_hw_segments)
-		rs->max_hw_segments = MAX_HW_SEGMENTS;
 	if (!rs->hardsect_size)
 		rs->hardsect_size = 1 << SECTOR_SHIFT;
 	if (!rs->max_segment_size)
@@ -849,7 +841,6 @@ void dm_table_set_restrictions(struct dm
 	 */
 	blk_queue_max_sectors(q, t->limits.max_sectors);
 	q->max_phys_segments = t->limits.max_phys_segments;
-	q->max_hw_segments = t->limits.max_hw_segments;
 	q->hardsect_size = t->limits.hardsect_size;
 	q->max_segment_size = t->limits.max_segment_size;
 	q->max_hw_sectors = t->limits.max_hw_sectors;
Index: linux-2.6.27-rc3-devel/drivers/message/i2o/i2o_block.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/message/i2o/i2o_block.c	2008-08-15 19:11:34.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/message/i2o/i2o_block.c	2008-08-15 19:25:40.000000000 +0200
@@ -1069,13 +1069,11 @@ static int i2o_block_probe(struct device
 	queue = gd->queue;
 	queue->queuedata = i2o_blk_dev;
 
-	blk_queue_max_phys_segments(queue, I2O_MAX_PHYS_SEGMENTS);
+	blk_queue_max_phys_segments(queue, min(I2O_MAX_PHYS_SEGMENTS, i2o_sg_tablesize(c, body_size)));
 	blk_queue_max_sectors(queue, max_sectors);
-	blk_queue_max_hw_segments(queue, i2o_sg_tablesize(c, body_size));
 
 	osm_debug("max sectors = %d\n", queue->max_sectors);
 	osm_debug("phys segments = %d\n", queue->max_phys_segments);
-	osm_debug("max hw segments = %d\n", queue->max_hw_segments);
 
 	/*
 	 *      Ask for the current media data. If that isn't supported
Index: linux-2.6.27-rc3-devel/drivers/scsi/sg.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/scsi/sg.c	2008-08-15 19:12:00.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/scsi/sg.c	2008-08-15 19:12:16.000000000 +0200
@@ -292,8 +292,7 @@ sg_open(struct inode *inode, struct file
 	if (!sdp->headfp) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
-		sdp->sg_tablesize = min(q->max_hw_segments,
-					q->max_phys_segments);
+		sdp->sg_tablesize = q->max_phys_segments;
 	}
 	if ((sfp = sg_add_sfp(sdp, dev)))
 		filp->private_data = sfp;
@@ -1394,7 +1393,7 @@ static Sg_device *sg_alloc(struct gendis
 	sdp->disk = disk;
 	sdp->device = scsidp;
 	init_waitqueue_head(&sdp->o_excl_wait);
-	sdp->sg_tablesize = min(q->max_hw_segments, q->max_phys_segments);
+	sdp->sg_tablesize = q->max_phys_segments;
 	sdp->index = k;
 
 	error = 0;
Index: linux-2.6.27-rc3-devel/drivers/scsi/st.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/scsi/st.c	2008-08-15 19:12:24.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/scsi/st.c	2008-08-15 19:12:35.000000000 +0200
@@ -3930,8 +3930,7 @@ static int st_probe(struct device *dev)
 		return -ENODEV;
 	}
 
-	i = min(SDp->request_queue->max_hw_segments,
-		SDp->request_queue->max_phys_segments);
+	i = SDp->request_queue->max_phys_segments;
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
 	buffer = new_tape_buffer(1, (SDp->host)->unchecked_isa_dma, i);
Index: linux-2.6.27-rc3-devel/fs/bio.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/fs/bio.c	2008-08-15 19:12:44.000000000 +0200
+++ linux-2.6.27-rc3-devel/fs/bio.c	2008-08-15 19:13:08.000000000 +0200
@@ -281,8 +281,6 @@ int bio_get_nr_vecs(struct block_device 
 	nr_pages = ((q->max_sectors << 9) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (nr_pages > q->max_phys_segments)
 		nr_pages = q->max_phys_segments;
-	if (nr_pages > q->max_hw_segments)
-		nr_pages = q->max_hw_segments;
 
 	return nr_pages;
 }
@@ -341,8 +339,7 @@ static int __bio_add_page(struct request
 	 * make this too complex.
 	 */
 
-	while (bio->bi_phys_segments >= q->max_phys_segments
-	       || bio->bi_phys_segments >= q->max_hw_segments) {
+	while (bio->bi_phys_segments >= q->max_phys_segments) {
 
 		if (retried_segments)
 			return 0;
Index: linux-2.6.27-rc3-devel/include/linux/device-mapper.h
===================================================================
--- linux-2.6.27-rc3-devel.orig/include/linux/device-mapper.h	2008-08-15 19:13:20.000000000 +0200
+++ linux-2.6.27-rc3-devel/include/linux/device-mapper.h	2008-08-15 19:13:27.000000000 +0200
@@ -122,7 +122,6 @@ struct io_restrictions {
 	unsigned max_sectors;
 	unsigned max_segment_size;
 	unsigned short hardsect_size;
-	unsigned short max_hw_segments;
 	unsigned short max_phys_segments;
 	unsigned char no_cluster; /* inverted so that 0 is default */
 };
Index: linux-2.6.27-rc3-devel/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/arch/um/drivers/ubd_kern.c	2008-08-15 19:15:02.000000000 +0200
+++ linux-2.6.27-rc3-devel/arch/um/drivers/ubd_kern.c	2008-08-15 19:15:21.000000000 +0200
@@ -870,7 +870,7 @@ static int ubd_add(int n, char **error_o
 	}
 	ubd_dev->queue->queuedata = ubd_dev;
 
-	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
+	blk_queue_max_phys_segments(ubd_dev->queue, MAX_SG);
 	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
Index: linux-2.6.27-rc3-devel/block/blk-core.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/block/blk-core.c	2008-08-15 19:15:29.000000000 +0200
+++ linux-2.6.27-rc3-devel/block/blk-core.c	2008-08-15 19:16:17.000000000 +0200
@@ -577,7 +577,6 @@ blk_init_queue_node(request_fn_proc *rfn
 	blk_queue_make_request(q, __make_request);
 	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);
 
-	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
 	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
 
 	q->sg_reserved_size = INT_MAX;
Index: linux-2.6.27-rc3-devel/drivers/ata/sata_nv.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/ata/sata_nv.c	2008-08-15 19:16:51.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/ata/sata_nv.c	2008-08-15 19:18:06.000000000 +0200
@@ -702,7 +702,7 @@ static int nv_adma_slave_config(struct s
 	}
 
 	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
-	blk_queue_max_hw_segments(sdev->request_queue, sg_tablesize);
+	blk_queue_max_phys_segments(sdev->request_queue, sg_tablesize);
 	ata_port_printk(ap, KERN_INFO,
 		"DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
 		(unsigned long long)*ap->host->dev->dma_mask,
Index: linux-2.6.27-rc3-devel/drivers/block/DAC960.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/DAC960.c	2008-08-15 19:18:12.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/DAC960.c	2008-08-15 19:18:47.000000000 +0200
@@ -2531,7 +2531,6 @@ static bool DAC960_RegisterBlockDevice(D
   	Controller->RequestQueue[n] = RequestQueue;
   	blk_queue_bounce_limit(RequestQueue, Controller->BounceBufferLimit);
   	RequestQueue->queuedata = Controller;
-  	blk_queue_max_hw_segments(RequestQueue, Controller->DriverScatterGatherLimit);
 	blk_queue_max_phys_segments(RequestQueue, Controller->DriverScatterGatherLimit);
 	blk_queue_max_sectors(RequestQueue, Controller->MaxBlocksPerCommand);
 	disk->queue = RequestQueue;
Index: linux-2.6.27-rc3-devel/drivers/block/cciss.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/cciss.c	2008-08-15 19:18:55.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/cciss.c	2008-08-15 19:19:20.000000000 +0200
@@ -1370,9 +1370,6 @@ static void cciss_add_disk(ctlr_info_t *
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
 
 	/* This is a hardware imposed limit. */
-	blk_queue_max_hw_segments(disk->queue, MAXSGENTRIES);
-
-	/* This is a limit in the driver and could be eliminated. */
 	blk_queue_max_phys_segments(disk->queue, MAXSGENTRIES);
 
 	blk_queue_max_sectors(disk->queue, h->cciss_max_sectors);
Index: linux-2.6.27-rc3-devel/drivers/block/cpqarray.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/cpqarray.c	2008-08-15 19:19:25.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/cpqarray.c	2008-08-15 19:19:31.000000000 +0200
@@ -451,9 +451,6 @@ static int __init cpqarray_register_ctlr
 		blk_queue_bounce_limit(q, hba[i]->pci_dev->dma_mask);
 
 	/* This is a hardware imposed limit. */
-	blk_queue_max_hw_segments(q, SG_MAX);
-
-	/* This is a driver limit and could be eliminated. */
 	blk_queue_max_phys_segments(q, SG_MAX);
 	
 	init_timer(&hba[i]->timer);
Index: linux-2.6.27-rc3-devel/drivers/block/paride/pf.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/paride/pf.c	2008-08-15 19:19:38.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/paride/pf.c	2008-08-15 19:20:06.000000000 +0200
@@ -958,7 +958,6 @@ static int __init pf_init(void)
 	}
 
 	blk_queue_max_phys_segments(pf_queue, cluster);
-	blk_queue_max_hw_segments(pf_queue, cluster);
 
 	for (pf = units, unit = 0; unit < PF_UNITS; pf++, unit++) {
 		struct gendisk *disk = pf->disk;
Index: linux-2.6.27-rc3-devel/drivers/block/ps3disk.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/ps3disk.c	2008-08-15 19:20:13.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/ps3disk.c	2008-08-15 19:20:24.000000000 +0200
@@ -484,7 +484,6 @@ static int __devinit ps3disk_probe(struc
 			  ps3disk_prepare_flush);
 
 	blk_queue_max_phys_segments(queue, -1);
-	blk_queue_max_hw_segments(queue, -1);
 	blk_queue_max_segment_size(queue, dev->bounce_size);
 
 	gendisk = alloc_disk(PS3DISK_MINORS);
Index: linux-2.6.27-rc3-devel/drivers/block/sunvdc.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/sunvdc.c	2008-08-15 19:20:28.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/sunvdc.c	2008-08-15 19:20:33.000000000 +0200
@@ -697,7 +697,6 @@ static int probe_disk(struct vdc_port *p
 
 	port->disk = g;
 
-	blk_queue_max_hw_segments(q, port->ring_cookies);
 	blk_queue_max_phys_segments(q, port->ring_cookies);
 	blk_queue_max_sectors(q, port->max_xfer_size);
 	g->major = vdc_major;
Index: linux-2.6.27-rc3-devel/drivers/block/sx8.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/sx8.c	2008-08-15 19:20:39.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/sx8.c	2008-08-15 19:20:44.000000000 +0200
@@ -1521,7 +1521,6 @@ static int carm_init_disks(struct carm_h
 			break;
 		}
 		disk->queue = q;
-		blk_queue_max_hw_segments(q, CARM_MAX_REQ_SG);
 		blk_queue_max_phys_segments(q, CARM_MAX_REQ_SG);
 		blk_queue_segment_boundary(q, CARM_SG_BOUNDARY);
 
Index: linux-2.6.27-rc3-devel/drivers/block/ub.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/ub.c	2008-08-15 19:20:49.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/ub.c	2008-08-15 19:20:54.000000000 +0200
@@ -2325,7 +2325,6 @@ static int ub_probe_lun(struct ub_dev *s
 	disk->queue = q;
 
 	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
-	blk_queue_max_hw_segments(q, UB_MAX_REQ_SG);
 	blk_queue_max_phys_segments(q, UB_MAX_REQ_SG);
 	blk_queue_segment_boundary(q, 0xffffffff);	/* Dubious. */
 	blk_queue_max_sectors(q, UB_MAX_SECTORS);
Index: linux-2.6.27-rc3-devel/drivers/block/viodasd.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/viodasd.c	2008-08-15 19:21:00.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/viodasd.c	2008-08-15 19:21:05.000000000 +0200
@@ -482,7 +482,6 @@ retry:
 	}
 
 	d->disk = g;
-	blk_queue_max_hw_segments(q, VIOMAXBLOCKDMA);
 	blk_queue_max_phys_segments(q, VIOMAXBLOCKDMA);
 	blk_queue_max_sectors(q, VIODASD_MAXSECTORS);
 	g->major = VIODASD_MAJOR;
Index: linux-2.6.27-rc3-devel/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/virtio_blk.c	2008-08-15 19:21:09.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/virtio_blk.c	2008-08-15 19:21:23.000000000 +0200
@@ -289,7 +289,7 @@ static int virtblk_probe(struct virtio_d
 				offsetof(struct virtio_blk_config, seg_max),
 				&v);
 	if (!err)
-		blk_queue_max_hw_segments(vblk->disk->queue, v);
+		blk_queue_max_phys_segments(vblk->disk->queue, v);
 
 	/* Host can optionally specify the block size of the device */
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_BLK_SIZE,
Index: linux-2.6.27-rc3-devel/drivers/block/xen-blkfront.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/block/xen-blkfront.c	2008-08-15 19:21:28.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/block/xen-blkfront.c	2008-08-15 19:21:35.000000000 +0200
@@ -354,7 +354,6 @@ static int xlvbd_init_blk_queue(struct g
 
 	/* Ensure a merged request will fit in a single I/O ring slot. */
 	blk_queue_max_phys_segments(rq, BLKIF_MAX_SEGMENTS_PER_REQUEST);
-	blk_queue_max_hw_segments(rq, BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
 	/* Make sure buffer addresses are sector-aligned. */
 	blk_queue_dma_alignment(rq, 511);
Index: linux-2.6.27-rc3-devel/drivers/cdrom/gdrom.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/cdrom/gdrom.c	2008-08-15 19:21:47.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/cdrom/gdrom.c	2008-08-15 19:22:03.000000000 +0200
@@ -737,7 +737,7 @@ static int __devinit probe_gdrom_setupqu
 {
 	blk_queue_hardsect_size(gd.gdrom_rq, GDROM_HARD_SECTOR);
 	/* using DMA so memory will need to be contiguous */
-	blk_queue_max_hw_segments(gd.gdrom_rq, 1);
+	blk_queue_max_phys_segments(gd.gdrom_rq, 1);
 	/* set a large max size to get most from DMA */
 	blk_queue_max_segment_size(gd.gdrom_rq, 0x40000);
 	gd.disk->queue = gd.gdrom_rq;
Index: linux-2.6.27-rc3-devel/drivers/cdrom/viocd.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/cdrom/viocd.c	2008-08-15 19:22:08.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/cdrom/viocd.c	2008-08-15 19:22:15.000000000 +0200
@@ -625,7 +625,6 @@ static int viocd_probe(struct vio_dev *v
 	gendisk->first_minor = deviceno;
 	strncpy(gendisk->disk_name, c->name,
 			sizeof(gendisk->disk_name));
-	blk_queue_max_hw_segments(q, 1);
 	blk_queue_max_phys_segments(q, 1);
 	blk_queue_max_sectors(q, 4096 / 512);
 	gendisk->queue = q;
Index: linux-2.6.27-rc3-devel/drivers/ide/ide-probe.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/ide/ide-probe.c	2008-08-15 19:22:20.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/ide/ide-probe.c	2008-08-15 19:22:27.000000000 +0200
@@ -927,7 +927,6 @@ static int ide_init_queue(ide_drive_t *d
 		max_sg_entries >>= 1;
 #endif /* CONFIG_PCI */
 
-	blk_queue_max_hw_segments(q, max_sg_entries);
 	blk_queue_max_phys_segments(q, max_sg_entries);
 
 	/* assign drive queue */
Index: linux-2.6.27-rc3-devel/drivers/memstick/core/mspro_block.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/memstick/core/mspro_block.c	2008-08-15 19:22:36.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/memstick/core/mspro_block.c	2008-08-15 19:22:42.000000000 +0200
@@ -1215,7 +1215,6 @@ static int mspro_block_init_disk(struct 
 	blk_queue_bounce_limit(msb->queue, limit);
 	blk_queue_max_sectors(msb->queue, MSPRO_BLOCK_MAX_PAGES);
 	blk_queue_max_phys_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
-	blk_queue_max_hw_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
 	blk_queue_max_segment_size(msb->queue,
 				   MSPRO_BLOCK_MAX_PAGES * msb->page_size);
 
Index: linux-2.6.27-rc3-devel/drivers/mmc/card/queue.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/card/queue.c	2008-08-15 19:22:48.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/card/queue.c	2008-08-15 19:27:48.000000000 +0200
@@ -151,7 +151,6 @@ int mmc_init_queue(struct mmc_queue *mq,
 			blk_queue_bounce_limit(mq->queue, BLK_BOUNCE_ANY);
 			blk_queue_max_sectors(mq->queue, bouncesz / 512);
 			blk_queue_max_phys_segments(mq->queue, bouncesz / 512);
-			blk_queue_max_hw_segments(mq->queue, bouncesz / 512);
 			blk_queue_max_segment_size(mq->queue, bouncesz);
 
 			mq->sg = kmalloc(sizeof(struct scatterlist),
@@ -176,8 +175,8 @@ int mmc_init_queue(struct mmc_queue *mq,
 	if (!mq->bounce_buf) {
 		blk_queue_bounce_limit(mq->queue, limit);
 		blk_queue_max_sectors(mq->queue, host->max_req_size / 512);
-		blk_queue_max_phys_segments(mq->queue, host->max_phys_segs);
-		blk_queue_max_hw_segments(mq->queue, host->max_hw_segs);
+	/* TODO: drop host->max_hw_segs */
+		blk_queue_max_phys_segments(mq->queue, min(host->max_phys_segs, host->max_hw_segs));
 		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
 
 		mq->sg = kmalloc(sizeof(struct scatterlist) *
Index: linux-2.6.27-rc3-devel/drivers/s390/block/dasd.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/s390/block/dasd.c	2008-08-15 19:23:16.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/s390/block/dasd.c	2008-08-15 19:23:22.000000000 +0200
@@ -1976,7 +1976,6 @@ static void dasd_setup_queue(struct dasd
 	max = block->base->discipline->max_blocks << block->s2b_shift;
 	blk_queue_max_sectors(block->request_queue, max);
 	blk_queue_max_phys_segments(block->request_queue, -1L);
-	blk_queue_max_hw_segments(block->request_queue, -1L);
 	blk_queue_max_segment_size(block->request_queue, -1L);
 	blk_queue_segment_boundary(block->request_queue, -1L);
 	blk_queue_ordered(block->request_queue, QUEUE_ORDERED_DRAIN, NULL);
Index: linux-2.6.27-rc3-devel/drivers/s390/char/tape_block.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/s390/char/tape_block.c	2008-08-15 19:23:27.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/s390/char/tape_block.c	2008-08-15 19:23:30.000000000 +0200
@@ -233,7 +233,6 @@ tapeblock_setup_device(struct tape_devic
 	blk_queue_hardsect_size(blkdat->request_queue, TAPEBLOCK_HSEC_SIZE);
 	blk_queue_max_sectors(blkdat->request_queue, TAPEBLOCK_MAX_SEC);
 	blk_queue_max_phys_segments(blkdat->request_queue, -1L);
-	blk_queue_max_hw_segments(blkdat->request_queue, -1L);
 	blk_queue_max_segment_size(blkdat->request_queue, -1L);
 	blk_queue_segment_boundary(blkdat->request_queue, -1L);
 
Index: linux-2.6.27-rc3-devel/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/scsi/scsi_lib.c	2008-08-15 19:23:35.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/scsi/scsi_lib.c	2008-08-15 19:39:19.000000000 +0200
@@ -1639,8 +1639,7 @@ struct request_queue *__scsi_alloc_queue
 	/*
 	 * this limit is imposed by hardware restrictions
 	 */
-	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
+	blk_queue_max_phys_segments(q, min(shost->sg_tablesize, (unsigned short)SCSI_MAX_SG_CHAIN_SEGMENTS));
 
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
Index: linux-2.6.27-rc3-devel/drivers/md/raid5.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/md/raid5.c	2008-08-15 19:11:08.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/md/raid5.c	2008-08-15 19:32:50.000000000 +0200
@@ -3193,8 +3193,7 @@ static int bio_fits_rdev(struct bio *bi)
 	if ((bi->bi_size>>9) > q->max_sectors)
 		return 0;
 	blk_recount_segments(q, bi);
-	if (bi->bi_phys_segments > q->max_phys_segments ||
-	    bi->bi_hw_segments > q->max_hw_segments)
+	if (bi->bi_phys_segments > q->max_phys_segments)
 		return 0;
 
 	if (q->merge_bvec_fn)
