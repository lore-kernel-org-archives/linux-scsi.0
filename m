From: Nick Piggin <npiggin@suse.de>
Subject: [rfc][patch 3/3] block: non-atomic queue_flags accessors
Date: Sat, 15 Dec 2007 06:44:10 +0100
Message-ID: <20071215054410.GC30335@wotan.suse.de>
References: <20071215054315.GA30335@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:37481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbXLOFoM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Dec 2007 00:44:12 -0500
Content-Disposition: inline
In-Reply-To: <20071215054315.GA30335@wotan.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>


Introduce queue_ accessors to set and clear queue_flags, which include debug
checks to ensure queue_lock is held. Non-checking versions are provided where
it is known that there can be no parallelism on queue_flags.

Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c
+++ linux-2.6/block/elevator.c
@@ -1032,7 +1032,7 @@ static int elevator_switch(struct reques
 	 */
 	spin_lock_irq(q->queue_lock);
 
-	__set_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
 
 	elv_drain_elevator(q);
 
@@ -1067,7 +1067,7 @@ static int elevator_switch(struct reques
 	 */
 	elevator_exit(old_elevator);
 	spin_lock_irq(q->queue_lock);
-	__clear_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
 	spin_unlock_irq(q->queue_lock);
 
 	return 1;
@@ -1082,7 +1082,7 @@ fail_register:
 	elv_register_queue(q);
 
 	spin_lock_irq(q->queue_lock);
-	__clear_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
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
-		__clear_bit(QUEUE_FLAG_CLUSTER, &t->queue_flags);
+		queue_flag_clear(QUEUE_FLAG_CLUSTER, t);
 }
 
 EXPORT_SYMBOL(blk_queue_stack_limits);
@@ -823,7 +823,7 @@ static void __blk_queue_free_tags(struct
 	__blk_free_tags(bqt);
 
 	q->queue_tags = NULL;
-	__clear_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+	queue_flag_clear(QUEUE_FLAG_QUEUED, q);
 }
 
 
@@ -852,7 +852,7 @@ EXPORT_SYMBOL(blk_free_tags);
  **/
 void blk_queue_free_tags(struct request_queue *q)
 {
-	__clear_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+	queue_flag_clear(QUEUE_FLAG_QUEUED, q);
 }
 
 EXPORT_SYMBOL(blk_queue_free_tags);
@@ -942,7 +942,7 @@ int blk_queue_init_tags(struct request_q
 	} else if (q->queue_tags) {
 		if ((rc = blk_queue_resize_tags(q, depth)))
 			return rc;
-		__set_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+		queue_flag_set(QUEUE_FLAG_QUEUED, q);
 		return 0;
 	} else
 		atomic_inc(&tags->refcnt);
@@ -951,7 +951,7 @@ int blk_queue_init_tags(struct request_q
 	 * assign it, all done
 	 */
 	q->queue_tags = tags;
-	__set_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+	queue_flag_set(QUEUE_FLAG_QUEUED, q);
 	INIT_LIST_HEAD(&q->tag_busy_list);
 	return 0;
 fail:
@@ -1558,7 +1558,7 @@ void blk_plug_device(struct request_queu
 		return;
 
 	if (!test_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
-		__set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
 		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
 		blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
 	}
@@ -1576,7 +1576,7 @@ int blk_remove_plug(struct request_queue
 
 	if (!test_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags))
 		return 0;
-	__clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+	queue_flag_clear(QUEUE_FLAG_PLUGGED, q);
 
 	del_timer(&q->unplug_timer);
 	return 1;
@@ -1674,16 +1674,16 @@ void blk_start_queue(struct request_queu
 {
 	WARN_ON(!irqs_disabled());
 
-	__clear_bit(QUEUE_FLAG_STOPPED, &q->queue_flags);
+	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
 
 	/*
 	 * one level of recursion is ok and is much faster than kicking
 	 * the unplug handling
 	 */
 	if (!test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
-		__set_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
+		queue_flag_set(QUEUE_FLAG_REENTER, q);
 		q->request_fn(q);
-		__clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
+		queue_flag_clear(QUEUE_FLAG_REENTER, q);
 	} else {
 		blk_plug_device(q);
 		kblockd_schedule_work(&q->unplug_work);
@@ -1709,7 +1709,7 @@ EXPORT_SYMBOL(blk_start_queue);
 void blk_stop_queue(struct request_queue *q)
 {
 	blk_remove_plug(q);
-	__set_bit(QUEUE_FLAG_STOPPED, &q->queue_flags);
+	queue_flag_set(QUEUE_FLAG_STOPPED, q);
 }
 EXPORT_SYMBOL(blk_stop_queue);
 
@@ -1748,9 +1748,9 @@ void __blk_run_queue(struct request_queu
 	 */
 	if (!elv_queue_empty(q)) {
 		if (!test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
-			__set_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
+			queue_flag_set(QUEUE_FLAG_REENTER, q);
 			q->request_fn(q);
-			__clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
+			queue_flag_clear(QUEUE_FLAG_REENTER, q);
 		} else {
 			blk_plug_device(q);
 			kblockd_schedule_work(&q->unplug_work);
@@ -1818,7 +1818,7 @@ void blk_cleanup_queue(struct request_qu
 {
 	mutex_lock(&q->sysfs_lock);
 	spin_lock_irq(q->queue_lock);
-	__set_bit(QUEUE_FLAG_DEAD, &q->queue_flags);
+	queue_flag_set(QUEUE_FLAG_DEAD, q);
 	spin_unlock_irq(q->queue_lock);
 	mutex_unlock(&q->sysfs_lock);
 
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c
+++ linux-2.6/drivers/block/loop.c
@@ -541,12 +541,9 @@ out:
  */
 static void loop_unplug(struct request_queue *q)
 {
-	unsigned long flags;
 	struct loop_device *lo = q->queuedata;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	__clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	queue_flag_clear_unlocked(QUEUE_FLAG_PLUGGED, q);
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
-		 *    __set_bit(QUEUE_FLAG_DEAD, &q->queue_flags);
+		 *    queue_flag_set(QUEUE_FLAG_DEAD, q);
 		 * As it is, we rely on our internal poisoning and let
 		 * the upper levels to spin furiously failing all the I/O.
 		 */
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -898,10 +898,13 @@ void dm_table_set_restrictions(struct dm
 	q->max_segment_size = t->limits.max_segment_size;
 	q->seg_boundary_mask = t->limits.seg_boundary_mask;
 	q->bounce_pfn = t->limits.bounce_pfn;
+	/* XXX: the below will probably go bug. must ensure there can be no
+	 * concurrency on queue_flags, and use the unlocked versions...
+	 */
 	if (t->limits.no_cluster)
-		__clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+		queue_flag_clear(QUEUE_FLAG_CLUSTER, q);
 	else
-		__set_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+		queue_flag_set(QUEUE_FLAG_CLUSTER, q);
 
 }
 
Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -281,7 +281,8 @@ static mddev_t * mddev_find(dev_t unit)
 		kfree(new);
 		return NULL;
 	}
-	__set_bit(QUEUE_FLAG_CLUSTER, &new->queue->queue_flags);
+	/* Can be unlocked because the queue is new: no concurrency */
+	queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, new->queue);
 
 	blk_queue_make_request(new->queue, md_fail_request);
 
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -555,12 +555,10 @@ static void scsi_run_queue(struct reques
 				!test_bit(QUEUE_FLAG_REENTER,
 					&sdev->request_queue->queue_flags);
 		if (flagset)
-			__set_bit(QUEUE_FLAG_REENTER,
-					&sdev->request_queue->queue_flags);
+			queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
 		__blk_run_queue(sdev->request_queue);
 		if (flagset)
-			__clear_bit(QUEUE_FLAG_REENTER,
-					&sdev->request_queue->queue_flags);
+			queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
 		spin_unlock(sdev->request_queue->queue_lock);
 
 		spin_lock(shost->host_lock);
@@ -1679,8 +1677,9 @@ struct request_queue *__scsi_alloc_queue
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 
+	/* New queue, no concurrency on queue_flags */
 	if (!shost->use_clustering)
-		__clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
 	return q;
 }
 EXPORT_SYMBOL(__scsi_alloc_queue);
Index: linux-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_sas.c
+++ linux-2.6/drivers/scsi/scsi_transport_sas.c
@@ -218,6 +218,8 @@ static int sas_bsg_initialize(struct Scs
 	if (!q)
 		return -ENOMEM;
 
+	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+
 	error = bsg_register_queue(q, dev, name);
 	if (error) {
 		blk_cleanup_queue(q);
@@ -234,8 +236,6 @@ static int sas_bsg_initialize(struct Scs
 	else
 		q->queuedata = shost;
 
-	__set_bit(QUEUE_FLAG_BIDI, &q->queue_flags);
-
 	return 0;
 }
 
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -474,6 +474,28 @@ struct request_queue
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
 
+static inline void queue_flag_set_unlocked(unsigned int flag, struct request_queue *q)
+{
+	__set_bit(flag, &q->queue_flags);
+}
+
+static inline void queue_flag_set(unsigned int flag, struct request_queue *q)
+{
+	BUG_ON(!spin_is_locked(q->queue_lock));
+	__set_bit(flag, &q->queue_flags);
+}
+
+static inline void queue_flag_clear_unlocked(unsigned int flag, struct request_queue *q)
+{
+	__clear_bit(flag, &q->queue_flags);
+}
+
+static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
+{
+	BUG_ON(!spin_is_locked(q->queue_lock));
+	__clear_bit(flag, &q->queue_flags);
+}
+
 enum {
 	/*
 	 * Hardbarrier is supported with one of the following methods.
@@ -560,17 +582,17 @@ static inline int blk_queue_full(struct 
 static inline void blk_set_queue_full(struct request_queue *q, int rw)
 {
 	if (rw == READ)
-		__set_bit(QUEUE_FLAG_READFULL, &q->queue_flags);
+		queue_flag_set(QUEUE_FLAG_READFULL, q);
 	else
-		__set_bit(QUEUE_FLAG_WRITEFULL, &q->queue_flags);
+		queue_flag_set(QUEUE_FLAG_WRITEFULL, q);
 }
 
 static inline void blk_clear_queue_full(struct request_queue *q, int rw)
 {
 	if (rw == READ)
-		__clear_bit(QUEUE_FLAG_READFULL, &q->queue_flags);
+		queue_flag_clear(QUEUE_FLAG_READFULL, q);
 	else
-		__clear_bit(QUEUE_FLAG_WRITEFULL, &q->queue_flags);
+		queue_flag_clear(QUEUE_FLAG_WRITEFULL, q);
 }
 
 
