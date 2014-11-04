From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/11] scsi: add new scsi-command flag for tagged commands
Date: Tue,  4 Nov 2014 08:54:07 +0100
Message-ID: <1415087656-9491-3-git-send-email-hch@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaKDHyM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:54:12 -0500
In-Reply-To: <1415087656-9491-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Currently scsi piggy backs on the block layer to define the concept
of a tagged command.  But we want to be able to have block-level host-wide
tags assigned even for untagged commands like the initial INQUIRY, so add
a new SCSI-level flag for commands that are tagged at the scsi level, so
that even commands without that set can have tags assigned to them.  Note
that this alredy is the case for the blk-mq code path, and this just lets
the old path catch up with it.

We also set this flag based upon sdev->simple_tags instead of the block
queue flag, so that it is entirely independent of the block layer tagging,
and thus always correct even if a driver doesn't use block level tagging
yet.

Also remove the old blk_rq_tagged; it was only used by SCSI drivers, and
removing it forces them to look for the proper replacement.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/block/biodoc.txt     |  4 ----
 block/blk-core.c                   |  4 ++--
 drivers/scsi/53c700.c              |  6 +++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c |  2 +-
 drivers/scsi/scsi_lib.c            | 13 +++++++++----
 drivers/usb/storage/uas.c          |  2 +-
 include/linux/blkdev.h             |  1 -
 include/scsi/scsi_cmnd.h           |  4 ++++
 include/scsi/scsi_tcq.h            |  6 ++----
 9 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 2101e71..6b972b2 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -827,10 +827,6 @@ but in the event of any barrier requests in the tag queue we need to ensure
 that requests are restarted in the order they were queue. This may happen
 if the driver needs to use blk_queue_invalidate_tags().
 
-Tagging also defines a new request flag, REQ_QUEUED. This is set whenever
-a request is currently tagged. You should not use this flag directly,
-blk_rq_tagged(rq) is the portable way to do so.
-
 3.3 I/O Submission
 
 The routine submit_bio() is used to submit a single io. Higher level i/o
diff --git a/block/blk-core.c b/block/blk-core.c
index 0421b53..2e7424b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1266,7 +1266,7 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
 	blk_clear_rq_complete(rq);
 	trace_block_rq_requeue(q, rq);
 
-	if (blk_rq_tagged(rq))
+	if (rq->cmd_flags & REQ_QUEUED)
 		blk_queue_end_tag(q, rq);
 
 	BUG_ON(blk_queued_rq(rq));
@@ -2554,7 +2554,7 @@ EXPORT_SYMBOL_GPL(blk_unprep_request);
  */
 void blk_finish_request(struct request *req, int error)
 {
-	if (blk_rq_tagged(req))
+	if (req->cmd_flags & REQ_QUEUED)
 		blk_queue_end_tag(req->q, req);
 
 	BUG_ON(blk_queued_rq(req));
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 474cc6d..5143d32 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1767,7 +1767,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 	 */
 	if(NCR_700_get_depth(SCp->device) != 0
 	   && (!(hostdata->tag_negotiated & (1<<scmd_id(SCp)))
-	       || !blk_rq_tagged(SCp->request))) {
+	       || !(SCp->flags & SCMD_TAGGED))) {
 		CDEBUG(KERN_ERR, SCp, "has non zero depth %d\n",
 		       NCR_700_get_depth(SCp->device));
 		return SCSI_MLQUEUE_DEVICE_BUSY;
@@ -1795,7 +1795,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 	printk("53c700: scsi%d, command ", SCp->device->host->host_no);
 	scsi_print_command(SCp);
 #endif
-	if(blk_rq_tagged(SCp->request)
+	if ((SCp->flags & SCMD_TAGGED)
 	   && (hostdata->tag_negotiated &(1<<scmd_id(SCp))) == 0
 	   && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_START_TAG_NEGOTIATION) {
 		scmd_printk(KERN_ERR, SCp, "Enabling Tag Command Queuing\n");
@@ -1809,7 +1809,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 	 *
 	 * FIXME: This will royally screw up on multiple LUN devices
 	 * */
-	if(!blk_rq_tagged(SCp->request)
+	if (!(SCp->flags & SCMD_TAGGED)
 	   && (hostdata->tag_negotiated &(1<<scmd_id(SCp)))) {
 		scmd_printk(KERN_INFO, SCp, "Disabling Tag Command Queuing\n");
 		hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d2c9bf3..63bae7c 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1447,7 +1447,7 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 	 * we are storing a full busy target *lun*
 	 * table in SCB space.
 	 */
-	if (!blk_rq_tagged(cmd->request)
+	if (!(cmd->flags & SCMD_TAGGED)
 	    && (ahc->features & AHC_SCB_BTT) == 0) {
 		int target_offset;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc0a8a0..6b57fae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1740,7 +1740,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * we add the dev to the starved list so it eventually gets
 		 * a run when a tag is freed.
 		 */
-		if (blk_queue_tagged(q) && !blk_rq_tagged(req)) {
+		if (blk_queue_tagged(q) && !(req->cmd_flags & REQ_QUEUED)) {
 			spin_lock_irq(shost->host_lock);
 			if (list_empty(&sdev->starved_entry))
 				list_add_tail(&sdev->starved_entry,
@@ -1754,6 +1754,11 @@ static void scsi_request_fn(struct request_queue *q)
 
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto host_not_ready;
+	
+		if (sdev->simple_tags)
+			cmd->flags |= SCMD_TAGGED;
+		else
+			cmd->flags &= ~SCMD_TAGGED;
 
 		/*
 		 * Finally, initialize any error handling parameters, and set up
@@ -1908,10 +1913,10 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
 		blk_mq_start_request(req);
 	}
 
-	if (blk_queue_tagged(q))
-		req->cmd_flags |= REQ_QUEUED;
+	if (sdev->simple_tags)
+		cmd->flags |= SCMD_TAGGED;
 	else
-		req->cmd_flags &= ~REQ_QUEUED;
+		cmd->flags &= ~SCMD_TAGGED;
 
 	scsi_init_cmd_errh(cmd);
 	cmd->scsi_done = scsi_mq_done;
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 89b2434..b38bc13 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -181,7 +181,7 @@ static int uas_get_tag(struct scsi_cmnd *cmnd)
 {
 	int tag;
 
-	if (blk_rq_tagged(cmnd->request))
+	if (cmnd->flags & SCMD_TAGGED)
 		tag = cmnd->request->tag + 2;
 	else
 		tag = 1;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aac0f9e..6d76b8b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1136,7 +1136,6 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 /*
  * tag stuff
  */
-#define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
 extern int blk_queue_start_tag(struct request_queue *, struct request *);
 extern struct request *blk_queue_find_tag(struct request_queue *, int);
 extern void blk_queue_end_tag(struct request_queue *, struct request *);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 522a5f27..e119142 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -53,6 +53,9 @@ struct scsi_pointer {
 	volatile int phase;
 };
 
+/* for scmd->flags */
+#define SCMD_TAGGED		(1 << 0)
+
 struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
@@ -132,6 +135,7 @@ struct scsi_cmnd {
 					 * to be at an address < 16Mb). */
 
 	int result;		/* Status code from lower level driver */
+	int flags;		/* Command flags */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 };
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index 3090fd0..8f16b94a 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -101,11 +101,9 @@ static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
  **/
 static inline int scsi_populate_tag_msg(struct scsi_cmnd *cmd, char *msg)
 {
-        struct request *req = cmd->request;
-
-        if (blk_rq_tagged(req)) {
+        if (cmd->flags & SCMD_TAGGED) {
 		*msg++ = MSG_SIMPLE_TAG;
-        	*msg++ = req->tag;
+        	*msg++ = cmd->request->tag;
         	return 2;
 	}
 
-- 
1.9.1

