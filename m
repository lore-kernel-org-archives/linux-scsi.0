From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] block: remove REQ_HARDBARRIER
Date: Sat, 23 Oct 2010 18:59:24 +0200
Message-ID: <20101023165924.GA1395@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CC311D5.9040904@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

REQ_HARDBARRIER is dead now, so remove the leftovers.  What's left
at this point is:

 - various checks inside the block layer.
 - sanity checks in bio based drivers.
 - now unused bio_empty_barrier helper.
 - Xen blockfront use of BLKIF_OP_WRITE_BARRIER - it's dead for a while,
   but Xen really needs to sort out it's barrier situaton.
 - setting of ordered tags in uas - dead code copied from old scsi
   drivers.
 - scsi different retry for barriers - it's dead and should have been
   removed when flushes were converted to FS requests.
 - blktrace handling of barriers - removed.  Someone who knows blktrace
   better should add support for REQ_FLUSH and REQ_FUA, though.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2010-10-23 17:03:30.119004105 +0200
+++ linux-2.6/block/blk-core.c	2010-10-23 17:03:40.797255816 +0200
@@ -1204,13 +1204,6 @@ static int __make_request(struct request
 	int where = ELEVATOR_INSERT_SORT;
 	int rw_flags;
 
-	/* REQ_HARDBARRIER is no more */
-	if (WARN_ONCE(bio->bi_rw & REQ_HARDBARRIER,
-		"block: HARDBARRIER is deprecated, use FLUSH/FUA instead\n")) {
-		bio_endio(bio, -EOPNOTSUPP);
-		return 0;
-	}
-
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c	2010-10-23 17:03:44.740255886 +0200
+++ linux-2.6/block/elevator.c	2010-10-23 17:05:30.715017097 +0200
@@ -429,7 +429,7 @@ void elv_dispatch_sort(struct request_qu
 	q->nr_sorted--;
 
 	boundary = q->end_sector;
-	stop_flags = REQ_SOFTBARRIER | REQ_HARDBARRIER | REQ_STARTED;
+	stop_flags = REQ_SOFTBARRIER | REQ_STARTED;
 	list_for_each_prev(entry, &q->queue_head) {
 		struct request *pos = list_entry_rq(entry);
 
@@ -691,7 +691,7 @@ void elv_insert(struct request_queue *q,
 void __elv_add_request(struct request_queue *q, struct request *rq, int where,
 		       int plug)
 {
-	if (rq->cmd_flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER)) {
+	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
 		if (rq->cmd_type == REQ_TYPE_FS ||
 		    (rq->cmd_flags & REQ_DISCARD)) {
Index: linux-2.6/drivers/block/aoe/aoeblk.c
===================================================================
--- linux-2.6.orig/drivers/block/aoe/aoeblk.c	2010-10-23 17:04:52.011004455 +0200
+++ linux-2.6/drivers/block/aoe/aoeblk.c	2010-10-23 17:04:56.381005921 +0200
@@ -178,9 +178,6 @@ aoeblk_make_request(struct request_queue
 		BUG();
 		bio_endio(bio, -ENXIO);
 		return 0;
-	} else if (bio->bi_rw & REQ_HARDBARRIER) {
-		bio_endio(bio, -EOPNOTSUPP);
-		return 0;
 	} else if (bio->bi_io_vec == NULL) {
 		printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
 		BUG();
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c	2010-10-23 17:04:59.923254002 +0200
+++ linux-2.6/drivers/block/loop.c	2010-10-23 17:05:07.163009317 +0200
@@ -481,12 +481,6 @@ static int do_bio_filebacked(struct loop
 	if (bio_rw(bio) == WRITE) {
 		struct file *file = lo->lo_backing_file;
 
-		/* REQ_HARDBARRIER is deprecated */
-		if (bio->bi_rw & REQ_HARDBARRIER) {
-			ret = -EOPNOTSUPP;
-			goto out;
-		}
-
 		if (bio->bi_rw & REQ_FLUSH) {
 			ret = vfs_fsync(file, 0);
 			if (unlikely(ret && ret != -EINVAL)) {
Index: linux-2.6/drivers/block/xen-blkfront.c
===================================================================
--- linux-2.6.orig/drivers/block/xen-blkfront.c	2010-10-23 17:05:10.627004036 +0200
+++ linux-2.6/drivers/block/xen-blkfront.c	2010-10-23 17:05:13.922298265 +0200
@@ -289,8 +289,6 @@ static int blkif_queue_request(struct re
 
 	ring_req->operation = rq_data_dir(req) ?
 		BLKIF_OP_WRITE : BLKIF_OP_READ;
-	if (req->cmd_flags & REQ_HARDBARRIER)
-		ring_req->operation = BLKIF_OP_WRITE_BARRIER;
 
 	ring_req->nr_segments = blk_rq_map_sg(req->q, req, info->sg);
 	BUG_ON(ring_req->nr_segments > BLKIF_MAX_SEGMENTS_PER_REQUEST);
Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c	2010-10-23 17:04:03.455261404 +0200
+++ linux-2.6/drivers/scsi/scsi_error.c	2010-10-23 17:04:25.223266782 +0200
@@ -320,19 +320,11 @@ static int scsi_check_sense(struct scsi_
 				    "changed. The Linux SCSI layer does not "
 				    "automatically adjust these parameters.\n");
 
-		if (scmd->request->cmd_flags & REQ_HARDBARRIER)
-			/*
-			 * barrier requests should always retry on UA
-			 * otherwise block will get a spurious error
-			 */
-			return NEEDS_RETRY;
-		else
-			/*
-			 * for normal (non barrier) commands, pass the
-			 * UA upwards for a determination in the
-			 * completion functions
-			 */
-			return SUCCESS;
+		/*
+		 * Pass the UA upwards for a determination in the completion
+		 * functions.
+		 */
+		return SUCCESS;
 
 		/* these three are not supported */
 	case COPY_ABORTED:
Index: linux-2.6/drivers/usb/storage/uas.c
===================================================================
--- linux-2.6.orig/drivers/usb/storage/uas.c	2010-10-23 17:04:38.136003757 +0200
+++ linux-2.6/drivers/usb/storage/uas.c	2010-10-23 17:04:43.154006271 +0200
@@ -331,10 +331,7 @@ static struct urb *uas_alloc_cmd_urb(str
 
 	iu->iu_id = IU_ID_COMMAND;
 	iu->tag = cpu_to_be16(stream_id);
-	if (sdev->ordered_tags && (cmnd->request->cmd_flags & REQ_HARDBARRIER))
-		iu->prio_attr = UAS_ORDERED_TAG;
-	else
-		iu->prio_attr = UAS_SIMPLE_TAG;
+	iu->prio_attr = UAS_SIMPLE_TAG;
 	iu->len = len;
 	int_to_scsilun(sdev->lun, &iu->lun);
 	memcpy(iu->cdb, cmnd->cmnd, cmnd->cmd_len);
Index: linux-2.6/include/linux/bio.h
===================================================================
--- linux-2.6.orig/include/linux/bio.h	2010-10-23 17:06:25.614253861 +0200
+++ linux-2.6/include/linux/bio.h	2010-10-23 17:06:32.574005589 +0200
@@ -66,10 +66,6 @@
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
-#define bio_empty_barrier(bio) \
-	((bio->bi_rw & REQ_HARDBARRIER) && \
-	 !bio_has_data(bio) && \
-	 !(bio->bi_rw & REQ_DISCARD))
 
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
Index: linux-2.6/include/linux/blk_types.h
===================================================================
--- linux-2.6.orig/include/linux/blk_types.h	2010-10-23 17:06:39.999010113 +0200
+++ linux-2.6/include/linux/blk_types.h	2010-10-23 17:07:04.544035045 +0200
@@ -122,7 +122,6 @@ enum rq_flag_bits {
 	__REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
 	__REQ_FAILFAST_DRIVER,	/* no driver retries of driver errors */
 
-	__REQ_HARDBARRIER,	/* may not be passed by drive either */
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
 	__REQ_DISCARD,		/* request to discard sectors */
@@ -159,7 +158,6 @@ enum rq_flag_bits {
 #define REQ_FAILFAST_DEV	(1 << __REQ_FAILFAST_DEV)
 #define REQ_FAILFAST_TRANSPORT	(1 << __REQ_FAILFAST_TRANSPORT)
 #define REQ_FAILFAST_DRIVER	(1 << __REQ_FAILFAST_DRIVER)
-#define REQ_HARDBARRIER		(1 << __REQ_HARDBARRIER)
 #define REQ_SYNC		(1 << __REQ_SYNC)
 #define REQ_META		(1 << __REQ_META)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
@@ -168,8 +166,8 @@ enum rq_flag_bits {
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
-	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_HARDBARRIER | REQ_SYNC | \
-	 REQ_META | REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
+	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_UNPLUG		(1 << __REQ_UNPLUG)
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2010-10-23 17:05:54.520003617 +0200
+++ linux-2.6/include/linux/blkdev.h	2010-10-23 17:06:17.909255871 +0200
@@ -553,8 +553,7 @@ static inline void blk_clear_queue_full(
  * it already be started by driver.
  */
 #define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER | \
-	 REQ_FLUSH | REQ_FUA)
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
 	 (((rq)->cmd_flags & REQ_DISCARD) || \
Index: linux-2.6/kernel/trace/blktrace.c
===================================================================
--- linux-2.6.orig/kernel/trace/blktrace.c	2010-10-23 17:05:41.146010043 +0200
+++ linux-2.6/kernel/trace/blktrace.c	2010-10-23 17:15:36.085255887 +0200
@@ -168,7 +168,6 @@ static int act_log_check(struct blk_trac
 static const u32 ddir_act[2] = { BLK_TC_ACT(BLK_TC_READ),
 				 BLK_TC_ACT(BLK_TC_WRITE) };
 
-#define BLK_TC_HARDBARRIER	BLK_TC_BARRIER
 #define BLK_TC_RAHEAD		BLK_TC_AHEAD
 
 /* The ilog2() calls fall out because they're constant */
@@ -196,7 +195,6 @@ static void __blk_add_trace(struct blk_t
 		return;
 
 	what |= ddir_act[rw & WRITE];
-	what |= MASK_TC_BIT(rw, HARDBARRIER);
 	what |= MASK_TC_BIT(rw, SYNC);
 	what |= MASK_TC_BIT(rw, RAHEAD);
 	what |= MASK_TC_BIT(rw, META);
@@ -1807,8 +1805,6 @@ void blk_fill_rwbs(char *rwbs, u32 rw, i
 
 	if (rw & REQ_RAHEAD)
 		rwbs[i++] = 'A';
-	if (rw & REQ_HARDBARRIER)
-		rwbs[i++] = 'B';
 	if (rw & REQ_SYNC)
 		rwbs[i++] = 'S';
 	if (rw & REQ_META)
