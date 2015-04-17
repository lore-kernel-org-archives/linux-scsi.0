From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/7] block: move PM request support to IDE
Date: Fri, 17 Apr 2015 22:37:20 +0200
Message-ID: <1429303042-12078-6-git-send-email-hch@lst.de>
References: <1429303042-12078-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbbDQUid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 16:38:33 -0400
In-Reply-To: <1429303042-12078-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

This removes the request types and hacks from the block code and into the
old IDE driver.  There is a small amunt of code duplication due to this,
but it's not too bad.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c           |  1 +
 block/blk-exec.c           | 10 ---------
 block/blk.h                |  2 --
 drivers/ide/ide-eh.c       |  2 +-
 drivers/ide/ide-io.c       |  8 +++----
 drivers/ide/ide-pm.c       | 56 +++++++++++++++++++++++++++++++++++-----------
 drivers/ide/ide-taskfile.c |  2 +-
 include/linux/blkdev.h     | 21 +----------------
 include/linux/ide.h        | 19 ++++++++++++++++
 9 files changed, 70 insertions(+), 51 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fd154b9..2e5020f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -285,6 +285,7 @@ inline void __blk_run_queue_uncond(struct request_queue *q)
 	q->request_fn(q);
 	q->request_fn_active--;
 }
+EXPORT_SYMBOL_GPL(__blk_run_queue_uncond);
 
 /**
  * __blk_run_queue - run a single device queue
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 9924725..3fec8a2 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -53,7 +53,6 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 			   rq_end_io_fn *done)
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
-	bool is_pm_resume;
 
 	WARN_ON(irqs_disabled());
 	WARN_ON(rq->cmd_type == REQ_TYPE_FS);
@@ -70,12 +69,6 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 		return;
 	}
 
-	/*
-	 * need to check this before __blk_run_queue(), because rq can
-	 * be freed before that returns.
-	 */
-	is_pm_resume = rq->cmd_type == REQ_TYPE_PM_RESUME;
-
 	spin_lock_irq(q->queue_lock);
 
 	if (unlikely(blk_queue_dying(q))) {
@@ -88,9 +81,6 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
-	/* the queue is stopped so it won't be run */
-	if (is_pm_resume)
-		__blk_run_queue_uncond(q);
 	spin_unlock_irq(q->queue_lock);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
diff --git a/block/blk.h b/block/blk.h
index 43b0361..4b48d55 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -193,8 +193,6 @@ int blk_try_merge(struct request *rq, struct bio *bio);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
-void __blk_run_queue_uncond(struct request_queue *q);
-
 int blk_dev_init(void);
 
 
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 19d809c..d6da011 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -129,7 +129,7 @@ ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
 
 			if (cmd)
 				ide_complete_cmd(drive, cmd, stat, err);
-		} else if (blk_pm_request(rq)) {
+		} else if (ata_pm_request(rq)) {
 			rq->errors = 1;
 			ide_complete_pm_rq(drive, rq);
 			return ide_stopped;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 8e55abd..669ea1e 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -320,7 +320,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 		goto kill_rq;
 	}
 
-	if (blk_pm_request(rq))
+	if (ata_pm_request(rq))
 		ide_check_pm_state(drive, rq);
 
 	drive->hwif->tp_ops->dev_select(drive);
@@ -342,8 +342,8 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 
 		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 			return execute_drive_cmd(drive, rq);
-		else if (blk_pm_request(rq)) {
-			struct request_pm_state *pm = rq->special;
+		else if (ata_pm_request(rq)) {
+			struct ide_pm_state *pm = rq->special;
 #ifdef DEBUG_PM
 			printk("%s: start_power_step(step: %d)\n",
 				drive->name, pm->pm_step);
@@ -538,7 +538,7 @@ repeat:
 		 * state machine.
 		 */
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
-		    blk_pm_request(rq) == 0 &&
+		    ata_pm_request(rq) == 0 &&
 		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
 			/* there should be no pending command at this point */
 			ide_unlock_port(hwif);
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 8d1e32d..6a8bfed 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -8,7 +8,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
-	struct request_pm_state rqpm;
+	struct ide_pm_state rqpm;
 	int ret;
 
 	if (ide_port_acpi(hwif)) {
@@ -19,7 +19,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 
 	memset(&rqpm, 0, sizeof(rqpm));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
+	rq->cmd_type = REQ_TYPE_ATA_PM_SUSPEND;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
 	if (mesg.event == PM_EVENT_PRETHAW)
@@ -38,13 +38,43 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	return ret;
 }
 
+static void ide_end_sync_rq(struct request *rq, int error)
+{
+	complete(rq->end_io_data);
+}
+
+static int ide_pm_execute_rq(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+	DECLARE_COMPLETION_ONSTACK(wait);
+
+	rq->end_io_data = &wait;
+	rq->end_io = ide_end_sync_rq;
+
+	spin_lock_irq(q->queue_lock);
+	if (unlikely(blk_queue_dying(q))) {
+		rq->cmd_flags |= REQ_QUIET; 
+		rq->errors = -ENXIO;
+		__blk_end_request_all(rq, rq->errors);
+		spin_unlock_irq(q->queue_lock);
+		return -ENXIO;
+	}
+	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT);
+	__blk_run_queue_uncond(q);
+	spin_unlock_irq(q->queue_lock);
+
+	wait_for_completion_io(&wait);
+
+	return rq->errors ? -EIO : 0;
+}
+
 int generic_ide_resume(struct device *dev)
 {
 	ide_drive_t *drive = to_ide_device(dev);
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
-	struct request_pm_state rqpm;
+	struct ide_pm_state rqpm;
 	int err;
 
 	if (ide_port_acpi(hwif)) {
@@ -59,13 +89,13 @@ int generic_ide_resume(struct device *dev)
 
 	memset(&rqpm, 0, sizeof(rqpm));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_PM_RESUME;
+	rq->cmd_type = REQ_TYPE_ATA_PM_RESUME;
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
 	rqpm.pm_state = PM_EVENT_ON;
 
-	err = blk_execute_rq(drive->queue, NULL, rq, 1);
+	err = ide_pm_execute_rq(rq);
 	blk_put_request(rq);
 
 	if (err == 0 && dev->driver) {
@@ -80,7 +110,7 @@ int generic_ide_resume(struct device *dev)
 
 void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm = rq->special;
+	struct ide_pm_state *pm = rq->special;
 
 #ifdef DEBUG_PM
 	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",
@@ -110,7 +140,7 @@ void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 
 ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm = rq->special;
+	struct ide_pm_state *pm = rq->special;
 	struct ide_cmd cmd = { };
 
 	switch (pm->pm_step) {
@@ -182,7 +212,7 @@ out_do_tf:
 void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 {
 	struct request_queue *q = drive->queue;
-	struct request_pm_state *pm = rq->special;
+	struct ide_pm_state *pm = rq->special;
 	unsigned long flags;
 
 	ide_complete_power_step(drive, rq);
@@ -191,10 +221,10 @@ void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 
 #ifdef DEBUG_PM
 	printk("%s: completing PM request, %s\n", drive->name,
-	       (rq->cmd_type == REQ_TYPE_PM_SUSPEND) ? "suspend" : "resume");
+	       (rq->cmd_type == REQ_TYPE_ATA_PM_SUSPEND) ? "suspend" : "resume");
 #endif
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (rq->cmd_type == REQ_TYPE_PM_SUSPEND)
+	if (rq->cmd_type == REQ_TYPE_ATA_PM_SUSPEND)
 		blk_stop_queue(q);
 	else
 		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
@@ -208,13 +238,13 @@ void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 
 void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm = rq->special;
+	struct ide_pm_state *pm = rq->special;
 
-	if (rq->cmd_type == REQ_TYPE_PM_SUSPEND &&
+	if (rq->cmd_type == REQ_TYPE_ATA_PM_SUSPEND &&
 	    pm->pm_step == IDE_PM_START_SUSPEND)
 		/* Mark drive blocked when starting the suspend sequence. */
 		drive->dev_flags |= IDE_DFLAG_BLOCKED;
-	else if (rq->cmd_type == REQ_TYPE_PM_RESUME &&
+	else if (rq->cmd_type == REQ_TYPE_ATA_PM_RESUME &&
 		 pm->pm_step == IDE_PM_START_RESUME) {
 		/*
 		 * The first thing we do on wakeup is to wait for BSY bit to
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index dabb88b..0979e12 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -186,7 +186,7 @@ static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 	    tf->command == ATA_CMD_CHK_POWER) {
 		struct request *rq = hwif->rq;
 
-		if (blk_pm_request(rq))
+		if (ata_pm_request(rq))
 			ide_complete_pm_rq(drive, rq);
 		else
 			ide_finish_cmd(drive, cmd, stat);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c2829ba..2da818a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -30,7 +30,6 @@ struct scsi_ioctl_command;
 
 struct request_queue;
 struct elevator_queue;
-struct request_pm_state;
 struct blk_trace;
 struct request;
 struct sg_io_hdr;
@@ -75,8 +74,6 @@ struct request_list {
 enum rq_cmd_type_bits {
 	REQ_TYPE_FS		= 1,	/* fs request */
 	REQ_TYPE_BLOCK_PC,		/* scsi command */
-	REQ_TYPE_PM_SUSPEND,		/* suspend request */
-	REQ_TYPE_PM_RESUME,		/* resume request */
 	REQ_TYPE_DRV_PRIV,		/* driver defined types from here */
 };
 
@@ -207,19 +204,6 @@ static inline unsigned short req_get_ioprio(struct request *req)
 	return req->ioprio;
 }
 
-/*
- * State information carried for REQ_TYPE_PM_SUSPEND and REQ_TYPE_PM_RESUME
- * requests. Some step values could eventually be made generic.
- */
-struct request_pm_state
-{
-	/* PM state machine step value, currently driver specific */
-	int	pm_step;
-	/* requested PM state value (S1, S2, S3, S4, ...) */
-	u32	pm_state;
-	void*	data;		/* for driver use */
-};
-
 #include <linux/elevator.h>
 
 struct blk_queue_ctx;
@@ -601,10 +585,6 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	(((rq)->cmd_flags & REQ_STARTED) && \
 	 ((rq)->cmd_type == REQ_TYPE_FS))
 
-#define blk_pm_request(rq)	\
-	((rq)->cmd_type == REQ_TYPE_PM_SUSPEND || \
-	 (rq)->cmd_type == REQ_TYPE_PM_RESUME)
-
 #define blk_rq_cpu_valid(rq)	((rq)->cpu != -1)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
 /* rq->queuelist of dequeued request must be list_empty() */
@@ -838,6 +818,7 @@ extern void blk_stop_queue(struct request_queue *q);
 extern void blk_sync_queue(struct request_queue *q);
 extern void __blk_stop_queue(struct request_queue *q);
 extern void __blk_run_queue(struct request_queue *q);
+extern void __blk_run_queue_uncond(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_run_queue_async(struct request_queue *q);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 9856b7d..a633898 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -44,8 +44,14 @@ enum ata_cmd_type_bits {
 	REQ_TYPE_ATA_TASKFILE = REQ_TYPE_DRV_PRIV + 1,
 	REQ_TYPE_ATA_PC,
 	REQ_TYPE_ATA_SENSE,	/* sense request */
+	REQ_TYPE_ATA_PM_SUSPEND,/* suspend request */
+	REQ_TYPE_ATA_PM_RESUME,	/* resume request */
 };
 
+#define ata_pm_request(rq)	\
+	((rq)->cmd_type == REQ_TYPE_ATA_PM_SUSPEND || \
+	 (rq)->cmd_type == REQ_TYPE_ATA_PM_RESUME)
+
 /* Error codes returned in rq->errors to the higher part of the driver. */
 enum {
 	IDE_DRV_ERROR_GENERAL	= 101,
@@ -1321,6 +1327,19 @@ struct ide_port_info {
 	u8			udma_mask;
 };
 
+/*
+ * State information carried for REQ_TYPE_ATA_PM_SUSPEND and REQ_TYPE_ATA_PM_RESUME
+ * requests.
+ */
+struct ide_pm_state {
+	/* PM state machine step value, currently driver specific */
+	int	pm_step;
+	/* requested PM state value (S1, S2, S3, S4, ...) */
+	u32	pm_state;
+	void*	data;		/* for driver use */
+};
+
+
 int ide_pci_init_one(struct pci_dev *, const struct ide_port_info *, void *);
 int ide_pci_init_two(struct pci_dev *, struct pci_dev *,
 		     const struct ide_port_info *, void *);
-- 
1.9.1

