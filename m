From: Nick Piggin <npiggin@suse.de>
Subject: [rfc][patch 2/3] block: non-atomic queue_flags
Date: Sat, 15 Dec 2007 06:43:46 +0100
Message-ID: <20071215054346.GB30335@wotan.suse.de>
References: <20071215054315.GA30335@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755749AbXLOFoE@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071215054315.GA30335@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


All queue_flag manipulations are performed under queue_lock (or eg. during
allocation-time where parallelism isn't a problem). So we can use non-atomic
bitops for these.

Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c
+++ linux-2.6/block/elevator.c
@@ -1032,7 +1032,7 @@ static int elevator_switch(struct reques
 	 */
 	spin_lock_irq(q->queue_lock);
 
-	set_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+	__set_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
 
 	elv_drain_elevator(q);
 
@@ -1067,7 +1067,7 @@ static int elevator_switch(struct reques
 	 */
 	elevator_exit(old_elevator);
 	spin_lock_irq(q->queue_lock);
-	clear_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+	__clear_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
 	spin_unlock_irq(q->queue_lock);
 
 	return 1;
@@ -1082,7 +1082,7 @@ fail_register:
 	elv_register_queue(q);
 
 	spin_lock_irq(q->queue_lock);
-	clear_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+	__clear_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
 	spin_unlock_irq(q->queue_lock);
 
 	return 0;
Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -720,7 +720,7 @@ void blk_queue_stack_limits(struct reque
 	t->max_segment_size = min(t->max_segment_size,b->max_segment_size);
 	t->hardsect_size = max(t->hardsect_size,b->hardsect_size);
 	if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags))
-		clear_bit(QUEUE_FLAG_CLUSTER, &t->queue_flags);
+		__clear_bit(QUEUE_FLAG_CLUSTER, &t->queue_flags);
 }
 
 EXPORT_SYMBOL(blk_queue_stack_limits);
@@ -823,7 +823,7 @@ static void __blk_queue_free_tags(struct
 	__blk_free_tags(bqt);
 
 	q->queue_tags = NULL;
-	q->queue_flags &= ~(1 << QUEUE_FLAG_QUEUED);
+	__clear_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
 }
 
 
@@ -852,7 +852,7 @@ EXPORT_SYMBOL(blk_free_tags);
  **/
 void blk_queue_free_tags(struct request_queue *q)
 {
-	clear_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+	__clear_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
 }
 
 EXPORT_SYMBOL(blk_queue_free_tags);
@@ -942,7 +942,7 @@ int blk_queue_init_tags(struct request_q
 	} else if (q->queue_tags) {
 		if ((rc = blk_queue_resize_tags(q, depth)))
 			return rc;
-		set_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+		__set_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
 		return 0;
 	} else
 		atomic_inc(&tags->refcnt);
@@ -951,7 +951,7 @@ int blk_queue_init_tags(struct request_q
 	 * assign it, all done
 	 */
 	q->queue_tags = tags;
-	q->queue_flags |= (1 << QUEUE_FLAG_QUEUED);
+	__set_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
 	INIT_LIST_HEAD(&q->tag_busy_list);
 	return 0;
 fail:
@@ -1205,7 +1205,7 @@ static void blk_recalc_rq_segments(struc
 	if (!rq->bio)
 		return;
 
-	cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
+	cluster = test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	hw_seg_size = seg_size = 0;
 	phys_size = hw_size = nr_phys_segs = nr_hw_segs = 0;
 	rq_for_each_segment(bv, rq, iter) {
@@ -1263,7 +1263,7 @@ new_hw_segment:
 static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 				   struct bio *nxt)
 {
-	if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER)))
+	if (!test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags))
 		return 0;
 
 	if (!BIOVEC_PHYS_MERGEABLE(__BVEC_END(bio), __BVEC_START(nxt)))
@@ -1310,7 +1310,7 @@ int blk_rq_map_sg(struct request_queue *
 	int nsegs, cluster;
 
 	nsegs = 0;
-	cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
+	cluster = test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 
 	/*
 	 * for each bio in rq
@@ -1557,7 +1557,8 @@ void blk_plug_device(struct request_queu
 	if (blk_queue_stopped(q))
 		return;
 
-	if (!test_and_set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
+	if (!test_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
+		__set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
 		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
 		blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
 	}
@@ -1573,8 +1574,9 @@ int blk_remove_plug(struct request_queue
 {
 	WARN_ON(!irqs_disabled());
 
-	if (!test_and_clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags))
+	if (!test_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags))
 		return 0;
+	__clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
 
 	del_timer(&q->unplug_timer);
 	return 1;
@@ -1672,15 +1674,16 @@ void blk_start_queue(struct request_queu
 {
 	WARN_ON(!irqs_disabled());
 
-	clear_bit(QUEUE_FLAG_STOPPED, &q->queue_flags);
+	__clear_bit(QUEUE_FLAG_STOPPED, &q->queue_flags);
 
 	/*
 	 * one level of recursion is ok and is much faster than kicking
 	 * the unplug handling
 	 */
-	if (!test_and_set_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+	if (!test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+		__set_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 		q->request_fn(q);
-		clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
+		__clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 	} else {
 		blk_plug_device(q);
 		kblockd_schedule_work(&q->unplug_work);
@@ -1706,7 +1709,7 @@ EXPORT_SYMBOL(blk_start_queue);
 void blk_stop_queue(struct request_queue *q)
 {
 	blk_remove_plug(q);
-	set_bit(QUEUE_FLAG_STOPPED, &q->queue_flags);
+	__set_bit(QUEUE_FLAG_STOPPED, &q->queue_flags);
 }
 EXPORT_SYMBOL(blk_stop_queue);
 
@@ -1744,9 +1747,10 @@ void __blk_run_queue(struct request_queu
 	 * handling reinvoke the handler shortly if we already got there.
 	 */
 	if (!elv_queue_empty(q)) {
-		if (!test_and_set_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+		if (!test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+			__set_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 			q->request_fn(q);
-			clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
+			__clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 		} else {
 			blk_plug_device(q);
 			kblockd_schedule_work(&q->unplug_work);
@@ -1814,7 +1818,7 @@ void blk_cleanup_queue(struct request_qu
 {
 	mutex_lock(&q->sysfs_lock);
 	spin_lock_irq(q->queue_lock);
-	set_bit(QUEUE_FLAG_DEAD, &q->queue_flags);
+	__set_bit(QUEUE_FLAG_DEAD, &q->queue_flags);
 	spin_unlock_irq(q->queue_lock);
 	mutex_unlock(&q->sysfs_lock);
 
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c
+++ linux-2.6/drivers/block/loop.c
@@ -545,7 +545,7 @@ static void loop_unplug(struct request_q
 	struct loop_device *lo = q->queuedata;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+	__clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 	blk_run_address_space(lo->lo_backing_file->f_mapping);
 }
Index: linux-2.6/drivers/block/ub.c
===================================================================
--- linux-2.6.orig/drivers/block/ub.c
+++ linux-2.6/drivers/block/ub.c
@@ -2402,7 +2402,7 @@ static void ub_disconnect(struct usb_int
 		del_gendisk(lun->disk);
 		/*
 		 * I wish I could do:
-		 *    set_bit(QUEUE_FLAG_DEAD, &q->queue_flags);
+		 *    __set_bit(QUEUE_FLAG_DEAD, &q->queue_flags);
 		 * As it is, we rely on our internal poisoning and let
 		 * the upper levels to spin furiously failing all the I/O.
 		 */
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -899,9 +899,9 @@ void dm_table_set_restrictions(struct dm
 	q->seg_boundary_mask = t->limits.seg_boundary_mask;
 	q->bounce_pfn = t->limits.bounce_pfn;
 	if (t->limits.no_cluster)
-		q->queue_flags &= ~(1 << QUEUE_FLAG_CLUSTER);
+		__clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	else
-		q->queue_flags |= (1 << QUEUE_FLAG_CLUSTER);
+		__set_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 
 }
 
Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -281,7 +281,7 @@ static mddev_t * mddev_find(dev_t unit)
 		kfree(new);
 		return NULL;
 	}
-	set_bit(QUEUE_FLAG_CLUSTER, &new->queue->queue_flags);
+	__set_bit(QUEUE_FLAG_CLUSTER, &new->queue->queue_flags);
 
 	blk_queue_make_request(new->queue, md_fail_request);
 
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -552,11 +552,14 @@ static void scsi_run_queue(struct reques
 
 		spin_lock(sdev->request_queue->queue_lock);
 		flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
-				!test_and_set_bit(QUEUE_FLAG_REENTER,
+				!test_bit(QUEUE_FLAG_REENTER,
+					&sdev->request_queue->queue_flags);
+		if (flagset)
+			__set_bit(QUEUE_FLAG_REENTER,
 					&sdev->request_queue->queue_flags);
 		__blk_run_queue(sdev->request_queue);
 		if (flagset)
-			clear_bit(QUEUE_FLAG_REENTER,
+			__clear_bit(QUEUE_FLAG_REENTER,
 					&sdev->request_queue->queue_flags);
 		spin_unlock(sdev->request_queue->queue_lock);
 
@@ -1677,7 +1680,7 @@ struct request_queue *__scsi_alloc_queue
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 
 	if (!shost->use_clustering)
-		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+		__clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	return q;
 }
 EXPORT_SYMBOL(__scsi_alloc_queue);
Index: linux-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_sas.c
+++ linux-2.6/drivers/scsi/scsi_transport_sas.c
@@ -234,7 +234,7 @@ static int sas_bsg_initialize(struct Scs
 	else
 		q->queuedata = shost;
 
-	set_bit(QUEUE_FLAG_BIDI, &q->queue_flags);
+	__set_bit(QUEUE_FLAG_BIDI, &q->queue_flags);
 
 	return 0;
 }
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -560,17 +560,17 @@ static inline int blk_queue_full(struct 
 static inline void blk_set_queue_full(struct request_queue *q, int rw)
 {
 	if (rw == READ)
-		set_bit(QUEUE_FLAG_READFULL, &q->queue_flags);
+		__set_bit(QUEUE_FLAG_READFULL, &q->queue_flags);
 	else
-		set_bit(QUEUE_FLAG_WRITEFULL, &q->queue_flags);
+		__set_bit(QUEUE_FLAG_WRITEFULL, &q->queue_flags);
 }
 
 static inline void blk_clear_queue_full(struct request_queue *q, int rw)
 {
 	if (rw == READ)
-		clear_bit(QUEUE_FLAG_READFULL, &q->queue_flags);
+		__clear_bit(QUEUE_FLAG_READFULL, &q->queue_flags);
 	else
-		clear_bit(QUEUE_FLAG_WRITEFULL, &q->queue_flags);
+		__clear_bit(QUEUE_FLAG_WRITEFULL, &q->queue_flags);
 }
 
 
