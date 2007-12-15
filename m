From: Nick Piggin <npiggin@suse.de>
Subject: [rfc][patch 1/3] block: non-atomic queue_flags prep
Date: Sat, 15 Dec 2007 06:43:16 +0100
Message-ID: <20071215054315.GA30335@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754558AbXLOFna@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

This is just an idea I had, which might make request processing a little
bit cheaper depending on queue behaviour. For example if it is getting plugged
unplugged frequently (as I think is the case for some database workloads),
then we might save one or two atomic operations per request.

Anyway, I'm not completely sure if I have ensured all queue_flags users are
safe (I think md may need a bit of help). But overall it seems quite doable.

Comments?
---
Prep queue_flags to be non-atomic and taking protection from queue_lock.
Do this by ensuring the queue_lock is held everywhere that queue_flags
are changed. Locking additions are confined to slowpaths.

Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c
+++ linux-2.6/block/elevator.c
@@ -1066,7 +1066,10 @@ static int elevator_switch(struct reques
 	 * finally exit old elevator and turn off BYPASS.
 	 */
 	elevator_exit(old_elevator);
+	spin_lock_irq(q->queue_lock);
 	clear_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+	spin_unlock_irq(q->queue_lock);
+
 	return 1;
 
 fail_register:
@@ -1077,7 +1080,11 @@ fail_register:
 	elevator_exit(e);
 	q->elevator = old_elevator;
 	elv_register_queue(q);
+
+	spin_lock_irq(q->queue_lock);
 	clear_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+	spin_unlock_irq(q->queue_lock);
+
 	return 0;
 }
 
Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -1732,14 +1732,11 @@ void blk_sync_queue(struct request_queue
 EXPORT_SYMBOL(blk_sync_queue);
 
 /**
- * blk_run_queue - run a single device queue
+ * __blk_run_queue - run a single device queue. queue_lock must be held.
  * @q:	The queue to run
  */
-void blk_run_queue(struct request_queue *q)
+void __blk_run_queue(struct request_queue *q)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
 	blk_remove_plug(q);
 
 	/*
@@ -1755,7 +1752,19 @@ void blk_run_queue(struct request_queue 
 			kblockd_schedule_work(&q->unplug_work);
 		}
 	}
+}
+EXPORT_SYMBOL(__blk_run_queue);
 
+/**
+ * blk_run_queue - run a single device queue
+ * @q:	The queue to run
+ */
+void blk_run_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(blk_run_queue);
@@ -1804,7 +1813,9 @@ EXPORT_SYMBOL(blk_put_queue);
 void blk_cleanup_queue(struct request_queue * q)
 {
 	mutex_lock(&q->sysfs_lock);
+	spin_lock_irq(q->queue_lock);
 	set_bit(QUEUE_FLAG_DEAD, &q->queue_flags);
+	spin_unlock_irq(q->queue_lock);
 	mutex_unlock(&q->sysfs_lock);
 
 	if (q->elevator)
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -532,6 +532,9 @@ static void scsi_run_queue(struct reques
 	       !shost->host_blocked && !shost->host_self_blocked &&
 		!((shost->can_queue > 0) &&
 		  (shost->host_busy >= shost->can_queue))) {
+
+		int flagset;
+
 		/*
 		 * As long as shost is accepting commands and we have
 		 * starved queues, call blk_run_queue. scsi_request_fn
@@ -547,17 +550,17 @@ static void scsi_run_queue(struct reques
 		list_del_init(&sdev->starved_entry);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
-
-		if (test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
-		    !test_and_set_bit(QUEUE_FLAG_REENTER,
-				      &sdev->request_queue->queue_flags)) {
-			blk_run_queue(sdev->request_queue);
+		spin_lock(sdev->request_queue->queue_lock);
+		flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
+				!test_and_set_bit(QUEUE_FLAG_REENTER,
+					&sdev->request_queue->queue_flags);
+		__blk_run_queue(sdev->request_queue);
+		if (flagset)
 			clear_bit(QUEUE_FLAG_REENTER,
-				  &sdev->request_queue->queue_flags);
-		} else
-			blk_run_queue(sdev->request_queue);
+					&sdev->request_queue->queue_flags);
+		spin_unlock(sdev->request_queue->queue_lock);
 
-		spin_lock_irqsave(shost->host_lock, flags);
+		spin_lock(shost->host_lock);
 		if (unlikely(!list_empty(&sdev->starved_entry)))
 			/*
 			 * sdev lost a race, and was put back on the
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c
+++ linux-2.6/drivers/block/loop.c
@@ -541,9 +541,12 @@ out:
  */
 static void loop_unplug(struct request_queue *q)
 {
+	unsigned long flags;
 	struct loop_device *lo = q->queuedata;
 
+	spin_lock_irqsave(q->queue_lock, flags);
 	clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 	blk_run_address_space(lo->lo_backing_file->f_mapping);
 }
 
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -685,6 +685,7 @@ extern void blk_start_queue(struct reque
 extern void blk_stop_queue(struct request_queue *q);
 extern void blk_sync_queue(struct request_queue *q);
 extern void __blk_stop_queue(struct request_queue *q);
+extern void __blk_run_queue(struct request_queue *);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_start_queueing(struct request_queue *);
 extern int blk_rq_map_user(struct request_queue *, struct request *, void __user *, unsigned long);
