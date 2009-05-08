From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/18] block: implement and enforce request peek/start/fetch
Date: Fri,  8 May 2009 11:54:16 +0900
Message-ID: <1241751256-17435-19-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761559AbZEHC4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2009 22:56:25 -0400
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>

Till now block layer allowed two separate modes of request execution.
A request is always acquired from the request queue via
elv_next_request().  After that, drivers are free to either dequeue it
or process it without dequeueing.  Dequeue allows elv_next_request()
to return the next request so that multiple requests can be in flight.

Executing requests without dequeueing has its merits mostly in
allowing drivers for simpler devices which can't do sg to deal with
segments only without considering request boundary.  However, the
benefit this brings is dubious and declining while the cost of the API
ambiguity is increasing.  Segment based drivers are usually for very
old or limited devices and as converting to dequeueing model isn't
difficult, it doesn't justify the API overhead it puts on block layer
and its more modern users.

Previous patches converted all block low level drivers to dequeueing
model.  This patch completes the API transition by...

* renaming elv_next_request() to blk_peek_request()

* renaming blkdev_dequeue_request() to blk_start_request()

* adding blk_fetch_request() which is combination of peek and start

* disallowing completion of queued (not started) requests

* applying new API to all LLDs

Renamings are for consistency and to break out of tree code so that
it's apparent that out of tree drivers need updating.

[ Impact: block request issue API cleanup, no functional change ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: unsik Kim <donari75@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Cc: Tim Waugh <tim@cyberelk.net>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Laurent Vivier <Laurent@lvivier.info>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: Stefan Weinhuber <wein@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/arm/plat-omap/mailbox.c        |   12 +---
 arch/um/drivers/ubd_kern.c          |    3 +-
 block/blk-barrier.c                 |    4 +-
 block/blk-core.c                    |  105 +++++++++++++++++++++++++---------
 block/blk-tag.c                     |    2 +-
 block/blk.h                         |    1 +
 drivers/block/DAC960.c              |    4 +-
 drivers/block/amiflop.c             |    3 +-
 drivers/block/ataflop.c             |    3 +-
 drivers/block/cciss.c               |    4 +-
 drivers/block/cpqarray.c            |    4 +-
 drivers/block/floppy.c              |    6 +-
 drivers/block/hd.c                  |    3 +-
 drivers/block/mg_disk.c             |   12 +---
 drivers/block/nbd.c                 |    4 +-
 drivers/block/paride/pcd.c          |    3 +-
 drivers/block/paride/pd.c           |    7 +--
 drivers/block/paride/pf.c           |    3 +-
 drivers/block/ps3disk.c             |    4 +-
 drivers/block/sunvdc.c              |    3 +-
 drivers/block/swim.c                |   12 +---
 drivers/block/swim3.c               |    3 +-
 drivers/block/sx8.c                 |    8 +--
 drivers/block/ub.c                  |    8 +-
 drivers/block/viodasd.c             |    4 +-
 drivers/block/virtio_blk.c          |    4 +-
 drivers/block/xd.c                  |   12 +---
 drivers/block/xen-blkfront.c        |    4 +-
 drivers/block/xsysace.c             |   10 +--
 drivers/block/z2ram.c               |   12 +---
 drivers/cdrom/gdrom.c               |    4 +-
 drivers/cdrom/viocd.c               |    4 +-
 drivers/ide/ide-atapi.c             |    2 +-
 drivers/ide/ide-io.c                |    9 +--
 drivers/memstick/core/mspro_block.c |    9 +--
 drivers/message/i2o/i2o_block.c     |    6 +-
 drivers/mmc/card/queue.c            |   11 +---
 drivers/mtd/mtd_blkdevs.c           |    7 +--
 drivers/s390/block/dasd.c           |   16 ++----
 drivers/s390/char/tape_block.c      |    7 +--
 drivers/sbus/char/jsflash.c         |   12 +---
 drivers/scsi/scsi_lib.c             |   10 ++--
 drivers/scsi/scsi_transport_sas.c   |    4 +-
 include/linux/blkdev.h              |    9 ++-
 include/linux/elevator.h            |    2 -
 45 files changed, 172 insertions(+), 207 deletions(-)

diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index 7a1f5c2..40424ed 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -197,9 +197,7 @@ static void mbox_tx_work(struct work_struct *work)
 		struct omap_msg_tx_data *tx_data;
 
 		spin_lock(q->queue_lock);
-		rq = elv_next_request(q);
-		if (rq)
-			blkdev_dequeue_request(rq);
+		rq = blk_fetch_request(q);
 		spin_unlock(q->queue_lock);
 
 		if (!rq)
@@ -242,9 +240,7 @@ static void mbox_rx_work(struct work_struct *work)
 
 	while (1) {
 		spin_lock_irqsave(q->queue_lock, flags);
-		rq = elv_next_request(q);
-		if (rq)
-			blkdev_dequeue_request(rq);
+		rq = blk_fetch_request(q);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 		if (!rq)
 			break;
@@ -351,9 +347,7 @@ omap_mbox_read(struct device *dev, struct device_attribute *attr, char *buf)
 
 	while (1) {
 		spin_lock_irqsave(q->queue_lock, flags);
-		rq = elv_next_request(q);
-		if (rq)
-			blkdev_dequeue_request(rq);
+		rq = blk_fetch_request(q);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		if (!rq)
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 402ba8f..aa9e926 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1228,12 +1228,11 @@ static void do_ubd_request(struct request_queue *q)
 	while(1){
 		struct ubd *dev = q->queuedata;
 		if(dev->end_sg == 0){
-			struct request *req = elv_next_request(q);
+			struct request *req = blk_fetch_request(q);
 			if(req == NULL)
 				return;
 
 			dev->request = req;
-			blkdev_dequeue_request(req);
 			dev->start_sg = 0;
 			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
 		}
diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 8713c2f..0ab81a0 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -180,7 +180,7 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 	}
 
 	/* stash away the original request */
-	elv_dequeue_request(q, rq);
+	blk_dequeue_request(rq);
 	q->orig_bar_rq = rq;
 	rq = NULL;
 
@@ -248,7 +248,7 @@ bool blk_do_ordered(struct request_queue *q, struct request **rqp)
 			 * Queue ordering not supported.  Terminate
 			 * with prejudice.
 			 */
-			elv_dequeue_request(q, rq);
+			blk_dequeue_request(rq);
 			__blk_end_request_all(rq, -EOPNOTSUPP);
 			*rqp = NULL;
 			return false;
diff --git a/block/blk-core.c b/block/blk-core.c
index 6226a38..93691d2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -902,6 +902,8 @@ EXPORT_SYMBOL(blk_get_request);
  */
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
+	BUG_ON(blk_queued_rq(rq));
+
 	blk_delete_timer(rq);
 	blk_clear_rq_complete(rq);
 	trace_block_rq_requeue(q, rq);
@@ -1610,28 +1612,6 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
 
-/**
- * blkdev_dequeue_request - dequeue request and start timeout timer
- * @req: request to dequeue
- *
- * Dequeue @req and start timeout timer on it.  This hands off the
- * request to the driver.
- *
- * Block internal functions which don't want to start timer should
- * call elv_dequeue_request().
- */
-void blkdev_dequeue_request(struct request *req)
-{
-	elv_dequeue_request(req->q, req);
-
-	/*
-	 * We are now handing the request to the hardware, add the
-	 * timeout handler.
-	 */
-	blk_add_timer(req);
-}
-EXPORT_SYMBOL(blkdev_dequeue_request);
-
 static void blk_account_io_completion(struct request *req, unsigned int bytes)
 {
 	if (blk_do_io_stat(req)) {
@@ -1671,7 +1651,23 @@ static void blk_account_io_done(struct request *req)
 	}
 }
 
-struct request *elv_next_request(struct request_queue *q)
+/**
+ * blk_peek_request - peek at the top of a request queue
+ * @q: request queue to peek at
+ *
+ * Description:
+ *     Return the request at the top of @q.  The returned request
+ *     should be started using blk_start_request() before LLD starts
+ *     processing it.
+ *
+ * Return:
+ *     Pointer to the request at the top of @q if available.  Null
+ *     otherwise.
+ *
+ * Context:
+ *     queue_lock must be held.
+ */
+struct request *blk_peek_request(struct request_queue *q)
 {
 	struct request *rq;
 	int ret;
@@ -1748,10 +1744,12 @@ struct request *elv_next_request(struct request_queue *q)
 
 	return rq;
 }
-EXPORT_SYMBOL(elv_next_request);
+EXPORT_SYMBOL(blk_peek_request);
 
-void elv_dequeue_request(struct request_queue *q, struct request *rq)
+void blk_dequeue_request(struct request *rq)
 {
+	struct request_queue *q = rq->q;
+
 	BUG_ON(list_empty(&rq->queuelist));
 	BUG_ON(ELV_ON_HASH(rq));
 
@@ -1767,6 +1765,58 @@ void elv_dequeue_request(struct request_queue *q, struct request *rq)
 }
 
 /**
+ * blk_start_request - start request processing on the driver
+ * @req: request to dequeue
+ *
+ * Description:
+ *     Dequeue @req and start timeout timer on it.  This hands off the
+ *     request to the driver.
+ *
+ *     Block internal functions which don't want to start timer should
+ *     call blk_dequeue_request().
+ *
+ * Context:
+ *     queue_lock must be held.
+ */
+void blk_start_request(struct request *req)
+{
+	blk_dequeue_request(req);
+
+	/*
+	 * We are now handing the request to the hardware, add the
+	 * timeout handler.
+	 */
+	blk_add_timer(req);
+}
+EXPORT_SYMBOL(blk_start_request);
+
+/**
+ * blk_fetch_request - fetch a request from a request queue
+ * @q: request queue to fetch a request from
+ *
+ * Description:
+ *     Return the request at the top of @q.  The request is started on
+ *     return and LLD can start processing it immediately.
+ *
+ * Return:
+ *     Pointer to the request at the top of @q if available.  Null
+ *     otherwise.
+ *
+ * Context:
+ *     queue_lock must be held.
+ */
+struct request *blk_fetch_request(struct request_queue *q)
+{
+	struct request *rq;
+
+	rq = blk_peek_request(q);
+	if (rq)
+		blk_start_request(rq);
+	return rq;
+}
+EXPORT_SYMBOL(blk_fetch_request);
+
+/**
  * blk_update_request - Special helper function for request stacking drivers
  * @rq:	      the request being processed
  * @error:    %0 for success, < %0 for error
@@ -1937,12 +1987,11 @@ static bool blk_update_bidi_request(struct request *rq, int error,
  */
 static void blk_finish_request(struct request *req, int error)
 {
+	BUG_ON(blk_queued_rq(req));
+
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(req->q, req);
 
-	if (blk_queued_rq(req))
-		elv_dequeue_request(req->q, req);
-
 	if (unlikely(laptop_mode) && blk_fs_request(req))
 		laptop_io_completion();
 
diff --git a/block/blk-tag.c b/block/blk-tag.c
index 3c518e3..c260f7c 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -374,7 +374,7 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	rq->cmd_flags |= REQ_QUEUED;
 	rq->tag = tag;
 	bqt->tag_index[tag] = rq;
-	blkdev_dequeue_request(rq);
+	blk_start_request(rq);
 	list_add(&rq->queuelist, &q->tag_busy_list);
 	return 0;
 }
diff --git a/block/blk.h b/block/blk.h
index ab54529..9e0042c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -13,6 +13,7 @@ extern struct kobj_type blk_queue_ktype;
 void init_request_from_bio(struct request *req, struct bio *bio);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
+void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 
 void blk_unplug_work(struct work_struct *work);
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 774ab05..668dc23 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -3321,7 +3321,7 @@ static int DAC960_process_queue(DAC960_Controller_T *Controller, struct request_
 	DAC960_Command_T *Command;
 
    while(1) {
-	Request = elv_next_request(req_q);
+	Request = blk_peek_request(req_q);
 	if (!Request)
 		return 1;
 
@@ -3341,7 +3341,7 @@ static int DAC960_process_queue(DAC960_Controller_T *Controller, struct request_
 	Command->BlockNumber = blk_rq_pos(Request);
 	Command->BlockCount = blk_rq_sectors(Request);
 	Command->Request = Request;
-	blkdev_dequeue_request(Request);
+	blk_start_request(Request);
 	Command->SegmentCount = blk_rq_map_sg(req_q,
 		  Command->Request, Command->cmd_sglist);
 	/* pci_map_sg MAY change the value of SegCount */
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 80a68b2..9c6e5b0 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1342,12 +1342,11 @@ static void redo_fd_request(void)
 	int err;
 
 next_req:
-	rq = elv_next_request(floppy_queue);
+	rq = blk_fetch_request(floppy_queue);
 	if (!rq) {
 		/* Nothing left to do */
 		return;
 	}
-	blkdev_dequeue_request(rq);
 
 	floppy = rq->rq_disk->private_data;
 	drive = floppy - unit;
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 89a591d..f5e7180 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1404,10 +1404,9 @@ static void redo_fd_request(void)
 
 repeat:
 	if (!fd_request) {
-		fd_request = elv_next_request(floppy_queue);
+		fd_request = blk_fetch_request(floppy_queue);
 		if (!fd_request)
 			goto the_end;
-		blkdev_dequeue_request(fd_request);
 	}
 
 	floppy = fd_request->rq_disk->private_data;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ab7b04c..e714e7c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2801,7 +2801,7 @@ static void do_cciss_request(struct request_queue *q)
 		goto startio;
 
       queue:
-	creq = elv_next_request(q);
+	creq = blk_peek_request(q);
 	if (!creq)
 		goto startio;
 
@@ -2810,7 +2810,7 @@ static void do_cciss_request(struct request_queue *q)
 	if ((c = cmd_alloc(h, 1)) == NULL)
 		goto full;
 
-	blkdev_dequeue_request(creq);
+	blk_start_request(creq);
 
 	spin_unlock_irq(q->queue_lock);
 
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index a5caeff..a02dcfc 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -903,7 +903,7 @@ static void do_ida_request(struct request_queue *q)
 		goto startio;
 
 queue_next:
-	creq = elv_next_request(q);
+	creq = blk_peek_request(q);
 	if (!creq)
 		goto startio;
 
@@ -912,7 +912,7 @@ queue_next:
 	if ((c = cmd_alloc(h,1)) == NULL)
 		goto startio;
 
-	blkdev_dequeue_request(creq);
+	blk_start_request(creq);
 
 	c->ctlr = h->ctlr;
 	c->hdr.unit = (drv_info_t *)(creq->rq_disk->private_data) - h->drv;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index e2c70d2..90877fe 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -931,7 +931,7 @@ static inline void unlock_fdc(void)
 	del_timer(&fd_timeout);
 	cont = NULL;
 	clear_bit(0, &fdc_busy);
-	if (current_req || elv_next_request(floppy_queue))
+	if (current_req || blk_peek_request(floppy_queue))
 		do_fd_request(floppy_queue);
 	spin_unlock_irqrestore(&floppy_lock, flags);
 	wake_up(&fdc_wait);
@@ -2912,9 +2912,7 @@ static void redo_fd_request(void)
 			struct request *req;
 
 			spin_lock_irq(floppy_queue->queue_lock);
-			req = elv_next_request(floppy_queue);
-			if (req)
-				blkdev_dequeue_request(req);
+			req = blk_fetch_request(floppy_queue);
 			spin_unlock_irq(floppy_queue->queue_lock);
 			if (!req) {
 				do_floppy = NULL;
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 288ab63..961de56 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -592,12 +592,11 @@ repeat:
 	del_timer(&device_timer);
 
 	if (!hd_req) {
-		hd_req = elv_next_request(hd_queue);
+		hd_req = blk_fetch_request(hd_queue);
 		if (!hd_req) {
 			do_hd = NULL;
 			return;
 		}
-		blkdev_dequeue_request(hd_req);
 	}
 	req = hd_req;
 
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 1ca5d14..c0cd0a0 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -671,10 +671,8 @@ static void mg_request_poll(struct request_queue *q)
 
 	while (1) {
 		if (!host->req) {
-			host->req = elv_next_request(q);
-			if (host->req)
-				blkdev_dequeue_request(host->req);
-			else
+			host->req = blk_fetch_request(q);
+			if (!host->req)
 				break;
 		}
 
@@ -744,10 +742,8 @@ static void mg_request(struct request_queue *q)
 
 	while (1) {
 		if (!host->req) {
-			host->req = elv_next_request(q);
-			if (host->req)
-				blkdev_dequeue_request(host->req);
-			else
+			host->req = blk_fetch_request(q);
+			if (!host->req)
 				break;
 		}
 		req = host->req;
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fad167d..5d23ffa 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -533,11 +533,9 @@ static void do_nbd_request(struct request_queue *q)
 {
 	struct request *req;
 	
-	while ((req = elv_next_request(q)) != NULL) {
+	while ((req = blk_fetch_request(q)) != NULL) {
 		struct nbd_device *lo;
 
-		blkdev_dequeue_request(req);
-
 		spin_unlock_irq(q->queue_lock);
 
 		dprintk(DBG_BLKDEV, "%s: request %p: dequeued (flags=%x)\n",
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 425f815..911dfd9 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -720,10 +720,9 @@ static void do_pcd_request(struct request_queue * q)
 		return;
 	while (1) {
 		if (!pcd_req) {
-			pcd_req = elv_next_request(q);
+			pcd_req = blk_fetch_request(q);
 			if (!pcd_req)
 				return;
-			blkdev_dequeue_request(pcd_req);
 		}
 
 		if (rq_data_dir(pcd_req) == READ) {
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index d2ca3f5..bf5955b 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -412,11 +412,9 @@ static void run_fsm(void)
 				spin_lock_irqsave(&pd_lock, saved_flags);
 				if (!__blk_end_request_cur(pd_req,
 						res == Ok ? 0 : -EIO)) {
-					pd_req = elv_next_request(pd_queue);
+					pd_req = blk_fetch_request(pd_queue);
 					if (!pd_req)
 						stop = 1;
-					else
-						blkdev_dequeue_request(pd_req);
 				}
 				spin_unlock_irqrestore(&pd_lock, saved_flags);
 				if (stop)
@@ -706,10 +704,9 @@ static void do_pd_request(struct request_queue * q)
 {
 	if (pd_req)
 		return;
-	pd_req = elv_next_request(q);
+	pd_req = blk_fetch_request(q);
 	if (!pd_req)
 		return;
-	blkdev_dequeue_request(pd_req);
 
 	schedule_fsm();
 }
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index d6f7bd8..68a9083 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -762,10 +762,9 @@ static void do_pf_request(struct request_queue * q)
 		return;
 repeat:
 	if (!pf_req) {
-		pf_req = elv_next_request(q);
+		pf_req = blk_fetch_request(q);
 		if (!pf_req)
 			return;
-		blkdev_dequeue_request(pf_req);
 	}
 
 	pf_current = pf_req->rq_disk->private_data;
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index f4d8db9..338cee4 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -194,9 +194,7 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 
 	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
 
-	while ((req = elv_next_request(q))) {
-		blkdev_dequeue_request(req);
-
+	while ((req = blk_fetch_request(q))) {
 		if (blk_fs_request(req)) {
 			if (ps3disk_submit_request_sg(dev, req))
 				break;
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 9f351bf..cbfd9c0 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -441,12 +441,11 @@ out:
 static void do_vdc_request(struct request_queue *q)
 {
 	while (1) {
-		struct request *req = elv_next_request(q);
+		struct request *req = blk_fetch_request(q);
 
 		if (!req)
 			break;
 
-		blkdev_dequeue_request(req);
 		if (__send_request(req) < 0)
 			__blk_end_request_all(req, -EIO);
 	}
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index dedd489..cf7877f 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -528,10 +528,7 @@ static void redo_fd_request(struct request_queue *q)
 	struct request *req;
 	struct floppy_state *fs;
 
-	req = elv_next_request(q);
-	if (req)
-		blkdev_dequeue_request(req);
-
+	req = blk_fetch_request(q);
 	while (req) {
 		int err = -EIO;
 
@@ -554,11 +551,8 @@ static void redo_fd_request(struct request_queue *q)
 			break;
 		}
 	done:
-		if (!__blk_end_request_cur(req, err)) {
-			req = elv_next_request(q);
-			if (req)
-				blkdev_dequeue_request(req);
-		}
+		if (!__blk_end_request_cur(req, err))
+			req = blk_fetch_request(q);
 	}
 }
 
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index f48c6dd..80df93e 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -326,10 +326,9 @@ static void start_request(struct floppy_state *fs)
 	}
 	while (fs->state == idle) {
 		if (!fd_req) {
-			fd_req = elv_next_request(swim3_queue);
+			fd_req = blk_fetch_request(swim3_queue);
 			if (!fd_req)
 				break;
-			blkdev_dequeue_request(fd_req);
 		}
 		req = fd_req;
 #if 0
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 087c94c..da403b6 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -810,12 +810,10 @@ static void carm_oob_rq_fn(struct request_queue *q)
 
 	while (1) {
 		DPRINTK("get req\n");
-		rq = elv_next_request(q);
+		rq = blk_fetch_request(q);
 		if (!rq)
 			break;
 
-		blkdev_dequeue_request(rq);
-
 		crq = rq->special;
 		assert(crq != NULL);
 		assert(crq->rq == rq);
@@ -846,7 +844,7 @@ static void carm_rq_fn(struct request_queue *q)
 
 queue_one_request:
 	VPRINTK("get req\n");
-	rq = elv_next_request(q);
+	rq = blk_peek_request(q);
 	if (!rq)
 		return;
 
@@ -857,7 +855,7 @@ queue_one_request:
 	}
 	crq->rq = rq;
 
-	blkdev_dequeue_request(rq);
+	blk_start_request(rq);
 
 	if (rq_data_dir(rq) == WRITE) {
 		writing = 1;
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 40d03cf..178f459 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -627,7 +627,7 @@ static void ub_request_fn(struct request_queue *q)
 	struct ub_lun *lun = q->queuedata;
 	struct request *rq;
 
-	while ((rq = elv_next_request(q)) != NULL) {
+	while ((rq = blk_peek_request(q)) != NULL) {
 		if (ub_request_fn_1(lun, rq) != 0) {
 			blk_stop_queue(q);
 			break;
@@ -643,13 +643,13 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 	int n_elem;
 
 	if (atomic_read(&sc->poison)) {
-		blkdev_dequeue_request(rq);
+		blk_start_request(rq);
 		ub_end_rq(rq, DID_NO_CONNECT << 16, blk_rq_bytes(rq));
 		return 0;
 	}
 
 	if (lun->changed && !blk_pc_request(rq)) {
-		blkdev_dequeue_request(rq);
+		blk_start_request(rq);
 		ub_end_rq(rq, SAM_STAT_CHECK_CONDITION, blk_rq_bytes(rq));
 		return 0;
 	}
@@ -660,7 +660,7 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 		return -1;
 	memset(cmd, 0, sizeof(struct ub_scsi_cmd));
 
-	blkdev_dequeue_request(rq);
+	blk_start_request(rq);
 
 	urq = &lun->urq;
 	memset(urq, 0, sizeof(struct ub_request));
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index 2086cb1..390d69b 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -361,11 +361,9 @@ static void do_viodasd_request(struct request_queue *q)
 	 * back later.
 	 */
 	while (num_req_outstanding < VIOMAXREQ) {
-		req = elv_next_request(q);
+		req = blk_fetch_request(q);
 		if (req == NULL)
 			return;
-		/* dequeue the current request from the queue */
-		blkdev_dequeue_request(req);
 		/* check that request contains a valid command */
 		if (!blk_fs_request(req)) {
 			viodasd_end_request(req, -EIO, blk_rq_sectors(req));
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 1980ab4..29a9daf 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -128,7 +128,7 @@ static void do_virtblk_request(struct request_queue *q)
 	struct request *req;
 	unsigned int issued = 0;
 
-	while ((req = elv_next_request(q)) != NULL) {
+	while ((req = blk_peek_request(q)) != NULL) {
 		vblk = req->rq_disk->private_data;
 		BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
@@ -138,7 +138,7 @@ static void do_virtblk_request(struct request_queue *q)
 			blk_stop_queue(q);
 			break;
 		}
-		blkdev_dequeue_request(req);
+		blk_start_request(req);
 		issued++;
 	}
 
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index d4c4352..ce24292 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -305,10 +305,7 @@ static void do_xd_request (struct request_queue * q)
 	if (xdc_busy)
 		return;
 
-	req = elv_next_request(q);
-	if (req)
-		blkdev_dequeue_request(req);
-
+	req = blk_fetch_request(q);
 	while (req) {
 		unsigned block = blk_rq_pos(req);
 		unsigned count = blk_rq_cur_sectors(req);
@@ -325,11 +322,8 @@ static void do_xd_request (struct request_queue * q)
 					   block, count);
 	done:
 		/* wrap up, 0 = success, -errno = fail */
-		if (!__blk_end_request_cur(req, res)) {
-			req = elv_next_request(q);
-			if (req)
-				blkdev_dequeue_request(req);
-		}
+		if (!__blk_end_request_cur(req, res))
+			req = blk_fetch_request(q);
 	}
 }
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 66f8345..6d4ac76 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -299,13 +299,13 @@ static void do_blkif_request(struct request_queue *rq)
 
 	queued = 0;
 
-	while ((req = elv_next_request(rq)) != NULL) {
+	while ((req = blk_peek_request(rq)) != NULL) {
 		info = req->rq_disk->private_data;
 
 		if (RING_FULL(&info->ring))
 			goto wait;
 
-		blkdev_dequeue_request(req);
+		blk_start_request(req);
 
 		if (!blk_fs_request(req)) {
 			__blk_end_request_all(req, -EIO);
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index edf137b..3a4397e 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -463,10 +463,10 @@ struct request *ace_get_next_request(struct request_queue * q)
 {
 	struct request *req;
 
-	while ((req = elv_next_request(q)) != NULL) {
+	while ((req = blk_peek_request(q)) != NULL) {
 		if (blk_fs_request(req))
 			break;
-		blkdev_dequeue_request(req);
+		blk_start_request(req);
 		__blk_end_request_all(req, -EIO);
 	}
 	return req;
@@ -498,10 +498,8 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			__blk_end_request_all(ace->req, -EIO);
 			ace->req = NULL;
 		}
-		while ((req = elv_next_request(ace->queue)) != NULL) {
-			blkdev_dequeue_request(req);
+		while ((req = blk_fetch_request(ace->queue)) != NULL)
 			__blk_end_request_all(req, -EIO);
-		}
 
 		/* Drop back to IDLE state and notify waiters */
 		ace->fsm_state = ACE_FSM_STATE_IDLE;
@@ -649,7 +647,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			ace->fsm_state = ACE_FSM_STATE_IDLE;
 			break;
 		}
-		blkdev_dequeue_request(req);
+		blk_start_request(req);
 
 		/* Okay, it's a data request, set it up for transfer */
 		dev_dbg(ace->dev,
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index c909c1a..4575171 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -71,10 +71,7 @@ static void do_z2_request(struct request_queue *q)
 {
 	struct request *req;
 
-	req = elv_next_request(q);
-	if (req)
-		blkdev_dequeue_request(req);
-
+	req = blk_fetch_request(q);
 	while (req) {
 		unsigned long start = blk_rq_pos(req) << 9;
 		unsigned long len  = blk_rq_cur_bytes(req);
@@ -100,11 +97,8 @@ static void do_z2_request(struct request_queue *q)
 			len -= size;
 		}
 	done:
-		if (!__blk_end_request_cur(req, err)) {
-			req = elv_next_request(q);
-			if (req)
-				blkdev_dequeue_request(req);
-		}
+		if (!__blk_end_request_cur(req, err))
+			req = blk_fetch_request(q);
 	}
 }
 
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 3cc02bf..1e366ad 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -642,9 +642,7 @@ static void gdrom_request(struct request_queue *rq)
 {
 	struct request *req;
 
-	while ((req = elv_next_request(rq)) != NULL) {
-		blkdev_dequeue_request(req);
-
+	while ((req = blk_fetch_request(rq)) != NULL) {
 		if (!blk_fs_request(req)) {
 			printk(KERN_DEBUG "GDROM: Non-fs request ignored\n");
 			__blk_end_request_all(req, -EIO);
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index bbe9f08..ca741c2 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -297,9 +297,7 @@ static void do_viocd_request(struct request_queue *q)
 {
 	struct request *req;
 
-	while ((rwreq == 0) && ((req = elv_next_request(q)) != NULL)) {
-		blkdev_dequeue_request(req);
-
+	while ((rwreq == 0) && ((req = blk_fetch_request(q)) != NULL)) {
 		if (!blk_fs_request(req))
 			__blk_end_request_all(req, -EIO);
 		else if (send_request(req) < 0) {
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2874c3d..8a894fa 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -269,7 +269,7 @@ void ide_retry_pc(ide_drive_t *drive)
 	blk_requeue_request(failed_rq->q, failed_rq);
 	drive->hwif->rq = NULL;
 	if (ide_queue_sense_rq(drive, pc)) {
-		blkdev_dequeue_request(failed_rq);
+		blk_start_request(failed_rq);
 		ide_complete_rq(drive, -EIO, blk_rq_bytes(failed_rq));
 	}
 }
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index abda733..e4e3a0e 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -519,11 +519,8 @@ repeat:
 		 * we know that the queue isn't empty, but this can happen
 		 * if the q->prep_rq_fn() decides to kill a request
 		 */
-		if (!rq) {
-			rq = elv_next_request(drive->queue);
-			if (rq)
-				blkdev_dequeue_request(rq);
-		}
+		if (!rq)
+			rq = blk_fetch_request(drive->queue);
 
 		spin_unlock_irq(q->queue_lock);
 		spin_lock_irq(&hwif->lock);
@@ -536,7 +533,7 @@ repeat:
 		/*
 		 * Sanity: don't accept a request that isn't a PM request
 		 * if we are currently power managed. This is very important as
-		 * blk_stop_queue() doesn't prevent the elv_next_request()
+		 * blk_stop_queue() doesn't prevent the blk_fetch_request()
 		 * above to return us whatever is in the queue. Since we call
 		 * ide_do_request() ourselves, we end up taking requests while
 		 * the queue is blocked...
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 58f5be8..c0bebc6 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -704,13 +704,12 @@ try_again:
 		return 0;
 	}
 
-	dev_dbg(&card->dev, "elv_next\n");
-	msb->block_req = elv_next_request(msb->queue);
+	dev_dbg(&card->dev, "blk_fetch\n");
+	msb->block_req = blk_fetch_request(msb->queue);
 	if (!msb->block_req) {
 		dev_dbg(&card->dev, "issue end\n");
 		return -EAGAIN;
 	}
-	blkdev_dequeue_request(msb->block_req);
 
 	dev_dbg(&card->dev, "trying again\n");
 	chunk = 1;
@@ -825,10 +824,8 @@ static void mspro_block_submit_req(struct request_queue *q)
 		return;
 
 	if (msb->eject) {
-		while ((req = elv_next_request(q)) != NULL) {
-			blkdev_dequeue_request(req);
+		while ((req = blk_fetch_request(q)) != NULL)
 			__blk_end_request_all(req, -ENODEV);
-		}
 
 		return;
 	}
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 8b5cbfc..6573ef4 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -877,7 +877,7 @@ static void i2o_block_request_fn(struct request_queue *q)
 	struct request *req;
 
 	while (!blk_queue_plugged(q)) {
-		req = elv_next_request(q);
+		req = blk_peek_request(q);
 		if (!req)
 			break;
 
@@ -890,7 +890,7 @@ static void i2o_block_request_fn(struct request_queue *q)
 
 			if (queue_depth < I2O_BLOCK_MAX_OPEN_REQUESTS) {
 				if (!i2o_block_transfer(req)) {
-					blkdev_dequeue_request(req);
+					blk_start_request(req);
 					continue;
 				} else
 					osm_info("transfer error\n");
@@ -917,7 +917,7 @@ static void i2o_block_request_fn(struct request_queue *q)
 				break;
 			}
 		} else {
-			blkdev_dequeue_request(req);
+			blk_start_request(req);
 			__blk_end_request_all(req, -EIO);
 		}
 	}
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 4b70f1e..49e5823 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -54,11 +54,8 @@ static int mmc_queue_thread(void *d)
 
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (!blk_queue_plugged(q)) {
-			req = elv_next_request(q);
-			if (req)
-				blkdev_dequeue_request(req);
-		}
+		if (!blk_queue_plugged(q))
+			req = blk_fetch_request(q);
 		mq->req = req;
 		spin_unlock_irq(q->queue_lock);
 
@@ -94,10 +91,8 @@ static void mmc_request(struct request_queue *q)
 
 	if (!mq) {
 		printk(KERN_ERR "MMC: killing requests for dead queue\n");
-		while ((req = elv_next_request(q)) != NULL) {
-			blkdev_dequeue_request(req);
+		while ((req = blk_fetch_request(q)) != NULL)
 			__blk_end_request_all(req, -EIO);
-		}
 		return;
 	}
 
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 3e10442..502622f 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -100,12 +100,7 @@ static int mtd_blktrans_thread(void *arg)
 		struct mtd_blktrans_dev *dev;
 		int res;
 
-		if (!req) {
-			req = elv_next_request(rq);
-			if (req)
-				blkdev_dequeue_request(req);
-		}
-		if (!req) {
+		if (!req && !(req = blk_fetch_request(rq))) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_irq(rq->queue_lock);
 			schedule();
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 7df03c7..e64f62d 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1656,17 +1656,13 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 	if (basedev->state < DASD_STATE_READY)
 		return;
 	/* Now we try to fetch requests from the request queue */
-	while (!blk_queue_plugged(queue) &&
-	       elv_next_request(queue)) {
-
-		req = elv_next_request(queue);
-
+	while (!blk_queue_plugged(queue) && (req = blk_peek_request(queue))) {
 		if (basedev->features & DASD_FEATURE_READONLY &&
 		    rq_data_dir(req) == WRITE) {
 			DBF_DEV_EVENT(DBF_ERR, basedev,
 				      "Rejecting write request %p",
 				      req);
-			blkdev_dequeue_request(req);
+			blk_start_request(req);
 			__blk_end_request_all(req, -EIO);
 			continue;
 		}
@@ -1695,7 +1691,7 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 				      "CCW creation failed (rc=%ld) "
 				      "on request %p",
 				      PTR_ERR(cqr), req);
-			blkdev_dequeue_request(req);
+			blk_start_request(req);
 			__blk_end_request_all(req, -EIO);
 			continue;
 		}
@@ -1705,7 +1701,7 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 		 */
 		cqr->callback_data = (void *) req;
 		cqr->status = DASD_CQR_FILLED;
-		blkdev_dequeue_request(req);
+		blk_start_request(req);
 		list_add_tail(&cqr->blocklist, &block->ccw_queue);
 		dasd_profile_start(block, cqr, req);
 	}
@@ -2029,10 +2025,8 @@ static void dasd_flush_request_queue(struct dasd_block *block)
 		return;
 
 	spin_lock_irq(&block->request_queue_lock);
-	while ((req = elv_next_request(block->request_queue))) {
-		blkdev_dequeue_request(req);
+	while ((req = blk_fetch_request(block->request_queue)))
 		__blk_end_request_all(req, -EIO);
-	}
 	spin_unlock_irq(&block->request_queue_lock);
 }
 
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index 5d035e4..1e79676 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -93,7 +93,7 @@ __tapeblock_end_request(struct tape_request *ccw_req, void *data)
 		device->blk_data.block_position = -1;
 	device->discipline->free_bread(ccw_req);
 	if (!list_empty(&device->req_queue) ||
-	    elv_next_request(device->blk_data.request_queue))
+	    blk_peek_request(device->blk_data.request_queue))
 		tapeblock_trigger_requeue(device);
 }
 
@@ -162,19 +162,16 @@ tapeblock_requeue(struct work_struct *work) {
 	spin_lock_irq(&device->blk_data.request_queue_lock);
 	while (
 		!blk_queue_plugged(queue) &&
-		elv_next_request(queue)   &&
+		(req = blk_fetch_request(queue)) &&
 		nr_queued < TAPEBLOCK_MIN_REQUEUE
 	) {
-		req = elv_next_request(queue);
 		if (rq_data_dir(req) == WRITE) {
 			DBF_EVENT(1, "TBLOCK: Rejecting write request\n");
-			blkdev_dequeue_request(req);
 			spin_unlock_irq(&device->blk_data.request_queue_lock);
 			blk_end_request_all(req, -EIO);
 			spin_lock_irq(&device->blk_data.request_queue_lock);
 			continue;
 		}
-		blkdev_dequeue_request(req);
 		nr_queued++;
 		spin_unlock_irq(&device->blk_data.request_queue_lock);
 		rc = tapeblock_start_request(device, req);
diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index f572a4a..6d46516 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -186,10 +186,7 @@ static void jsfd_do_request(struct request_queue *q)
 {
 	struct request *req;
 
-	req = elv_next_request(q);
-	if (req)
-		blkdev_dequeue_request(req);
-
+	req = blk_fetch_request(q);
 	while (req) {
 		struct jsfd_part *jdp = req->rq_disk->private_data;
 		unsigned long offset = blk_rq_pos(req) << 9;
@@ -212,11 +209,8 @@ static void jsfd_do_request(struct request_queue *q)
 		jsfd_read(req->buffer, jdp->dbase + offset, len);
 		err = 0;
 	end:
-		if (!__blk_end_request_cur(req, err)) {
-			req = elv_next_request(q);
-			if (req)
-				blkdev_dequeue_request(req);
-		}
+		if (!__blk_end_request_cur(req, err))
+			req = blk_fetch_request(q);
 	}
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ee308f6..b12750f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1207,7 +1207,7 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 		break;
 	case BLKPREP_DEFER:
 		/*
-		 * If we defer, the elv_next_request() returns NULL, but the
+		 * If we defer, the blk_peek_request() returns NULL, but the
 		 * queue must be restarted, so we plug here if no returning
 		 * command will automatically do that.
 		 */
@@ -1385,7 +1385,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	struct scsi_target *starget = scsi_target(sdev);
 	struct Scsi_Host *shost = sdev->host;
 
-	blkdev_dequeue_request(req);
+	blk_start_request(req);
 
 	if (unlikely(cmd == NULL)) {
 		printk(KERN_CRIT "impossible request in %s.\n",
@@ -1477,7 +1477,7 @@ static void scsi_request_fn(struct request_queue *q)
 
 	if (!sdev) {
 		printk("scsi: killing requests for dead queue\n");
-		while ((req = elv_next_request(q)) != NULL)
+		while ((req = blk_peek_request(q)) != NULL)
 			scsi_kill_request(req, q);
 		return;
 	}
@@ -1498,7 +1498,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * that the request is fully prepared even if we cannot 
 		 * accept it.
 		 */
-		req = elv_next_request(q);
+		req = blk_peek_request(q);
 		if (!req || !scsi_dev_queue_ready(q, sdev))
 			break;
 
@@ -1514,7 +1514,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * Remove the request from the request list.
 		 */
 		if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
-			blkdev_dequeue_request(req);
+			blk_start_request(req);
 		sdev->device_busy++;
 
 		spin_unlock(q->queue_lock);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 50988cb..d606452 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -163,12 +163,10 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 	int (*handler)(struct Scsi_Host *, struct sas_rphy *, struct request *);
 
 	while (!blk_queue_plugged(q)) {
-		req = elv_next_request(q);
+		req = blk_fetch_request(q);
 		if (!req)
 			break;
 
-		blkdev_dequeue_request(req);
-
 		spin_unlock_irq(q->queue_lock);
 
 		handler = to_sas_internal(shost->transportt)->f->smp_handler;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6617abd..8919683 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -819,8 +819,6 @@ static inline void blk_run_address_space(struct address_space *mapping)
 		blk_run_backing_dev(mapping->backing_dev_info, NULL);
 }
 
-extern void blkdev_dequeue_request(struct request *req);
-
 /*
  * blk_rq_pos()		: the current sector
  * blk_rq_bytes()	: bytes left in the entire request
@@ -854,6 +852,13 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 }
 
 /*
+ * Request issue related functions.
+ */
+extern struct request *blk_peek_request(struct request_queue *q);
+extern void blk_start_request(struct request *rq);
+extern struct request *blk_fetch_request(struct request_queue *q);
+
+/*
  * Request completion related functions.
  *
  * blk_update_request() completes given number of bytes and updates
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 4e46287..1cb3372 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -103,10 +103,8 @@ extern int elv_merge(struct request_queue *, struct request **, struct bio *);
 extern void elv_merge_requests(struct request_queue *, struct request *,
 			       struct request *);
 extern void elv_merged_request(struct request_queue *, struct request *, int);
-extern void elv_dequeue_request(struct request_queue *, struct request *);
 extern void elv_requeue_request(struct request_queue *, struct request *);
 extern int elv_queue_empty(struct request_queue *);
-extern struct request *elv_next_request(struct request_queue *q);
 extern struct request *elv_former_request(struct request_queue *, struct request *);
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
-- 
1.6.0.2

