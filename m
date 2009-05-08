From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/18] ide: dequeue in-flight request
Date: Fri,  8 May 2009 11:53:59 +0900
Message-ID: <1241751256-17435-2-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

ide generally has single request in flight and tracks it using
hwif->rq and all state handlers follow the following convention.

* ide_started is returned if the request is in flight.

* ide_stopped is returned if the queue needs to be restarted.  The
  request might or might not have been processed fully or partially.

* hwif->rq is set to NULL, when an issued request completes.

So, dequeueing model can be implemented by dequeueing after fetch,
requeueing if hwif->rq isn't NULL on ide_stopped return and doing
about the same thing on completion / port unlock paths.  These changes
can be made in ide-io proper.

In addition to the above main changes, the following updates are
necessary.

* ide-cd shouldn't dequeue a request when issuing REQUEST SENSE for it
  as the request is already dequeued.

* ide-atapi uses request queue as stack when issuing REQUEST SENSE to
  put the REQUEST SENSE in front of the failed request.  This now
  needs to be done using requeueing.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
 drivers/ide/ide-atapi.c |   14 ++++++++++++--
 drivers/ide/ide-cd.c    |    8 --------
 drivers/ide/ide-io.c    |   34 +++++++++++++++++++++++++++-------
 3 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 792534d..2874c3d 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -246,6 +246,7 @@ EXPORT_SYMBOL_GPL(ide_queue_sense_rq);
  */
 void ide_retry_pc(ide_drive_t *drive)
 {
+	struct request *failed_rq = drive->hwif->rq;
 	struct request *sense_rq = &drive->sense_rq;
 	struct ide_atapi_pc *pc = &drive->request_sense_pc;
 
@@ -260,8 +261,17 @@ void ide_retry_pc(ide_drive_t *drive)
 	if (drive->media == ide_tape)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 
-	if (ide_queue_sense_rq(drive, pc))
-		ide_complete_rq(drive, -EIO, blk_rq_bytes(drive->hwif->rq));
+	/*
+	 * Push back the failed request and put request sense on top
+	 * of it.  The failed command will be retried after sense data
+	 * is acquired.
+	 */
+	blk_requeue_request(failed_rq->q, failed_rq);
+	drive->hwif->rq = NULL;
+	if (ide_queue_sense_rq(drive, pc)) {
+		blkdev_dequeue_request(failed_rq);
+		ide_complete_rq(drive, -EIO, blk_rq_bytes(failed_rq));
+	}
 }
 EXPORT_SYMBOL_GPL(ide_retry_pc);
 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 1a58b38..1f88911 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -404,15 +404,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 
 end_request:
 	if (stat & ATA_ERR) {
-		struct request_queue *q = drive->queue;
-		unsigned long flags;
-
-		spin_lock_irqsave(q->queue_lock, flags);
-		blkdev_dequeue_request(rq);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-
 		hwif->rq = NULL;
-
 		return ide_queue_sense_rq(drive, rq) ? 2 : 1;
 	} else
 		return 2;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index ca2519d..abda733 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -487,10 +487,10 @@ void do_ide_request(struct request_queue *q)
 
 	if (!ide_lock_port(hwif)) {
 		ide_hwif_t *prev_port;
+
+		WARN_ON_ONCE(hwif->rq);
 repeat:
 		prev_port = hwif->host->cur_port;
-		hwif->rq = NULL;
-
 		if (drive->dev_flags & IDE_DFLAG_SLEEPING &&
 		    time_after(drive->sleep, jiffies)) {
 			ide_unlock_port(hwif);
@@ -519,7 +519,12 @@ repeat:
 		 * we know that the queue isn't empty, but this can happen
 		 * if the q->prep_rq_fn() decides to kill a request
 		 */
-		rq = elv_next_request(drive->queue);
+		if (!rq) {
+			rq = elv_next_request(drive->queue);
+			if (rq)
+				blkdev_dequeue_request(rq);
+		}
+
 		spin_unlock_irq(q->queue_lock);
 		spin_lock_irq(&hwif->lock);
 
@@ -555,8 +560,11 @@ repeat:
 		startstop = start_request(drive, rq);
 		spin_lock_irq(&hwif->lock);
 
-		if (startstop == ide_stopped)
+		if (startstop == ide_stopped) {
+			rq = hwif->rq;
+			hwif->rq = NULL;
 			goto repeat;
+		}
 	} else
 		goto plug_device;
 out:
@@ -572,18 +580,24 @@ plug_device:
 plug_device_2:
 	spin_lock_irq(q->queue_lock);
 
+	if (rq)
+		blk_requeue_request(q, rq);
 	if (!elv_queue_empty(q))
 		blk_plug_device(q);
 }
 
-static void ide_plug_device(ide_drive_t *drive)
+static void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
 {
 	struct request_queue *q = drive->queue;
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
+
+	if (rq)
+		blk_requeue_request(q, rq);
 	if (!elv_queue_empty(q))
 		blk_plug_device(q);
+
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
@@ -632,6 +646,7 @@ void ide_timer_expiry (unsigned long data)
 	unsigned long	flags;
 	int		wait = -1;
 	int		plug_device = 0;
+	struct request	*uninitialized_var(rq_in_flight);
 
 	spin_lock_irqsave(&hwif->lock, flags);
 
@@ -693,6 +708,8 @@ void ide_timer_expiry (unsigned long data)
 		spin_lock_irq(&hwif->lock);
 		enable_irq(hwif->irq);
 		if (startstop == ide_stopped) {
+			rq_in_flight = hwif->rq;
+			hwif->rq = NULL;
 			ide_unlock_port(hwif);
 			plug_device = 1;
 		}
@@ -701,7 +718,7 @@ void ide_timer_expiry (unsigned long data)
 
 	if (plug_device) {
 		ide_unlock_host(hwif->host);
-		ide_plug_device(drive);
+		ide_requeue_and_plug(drive, rq_in_flight);
 	}
 }
 
@@ -787,6 +804,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	ide_startstop_t startstop;
 	irqreturn_t irq_ret = IRQ_NONE;
 	int plug_device = 0;
+	struct request *uninitialized_var(rq_in_flight);
 
 	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
 		if (hwif != host->cur_port)
@@ -866,6 +884,8 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	 */
 	if (startstop == ide_stopped) {
 		BUG_ON(hwif->handler);
+		rq_in_flight = hwif->rq;
+		hwif->rq = NULL;
 		ide_unlock_port(hwif);
 		plug_device = 1;
 	}
@@ -875,7 +895,7 @@ out:
 out_early:
 	if (plug_device) {
 		ide_unlock_host(hwif->host);
-		ide_plug_device(drive);
+		ide_requeue_and_plug(drive, rq_in_flight);
 	}
 
 	return irq_ret;
-- 
1.6.0.2

