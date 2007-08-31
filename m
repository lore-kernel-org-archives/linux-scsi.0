From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 7/7] blk_end_request: change rq->end_io to cover
 request completion as a whole
Date: Fri, 31 Aug 2007 18:43:57 -0400 (EDT)
Message-ID: <20070831.184357.125900174.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch moves the rq->end_io() calling point to the top of
blk_end_request() from the last of end_that_request_last().
This means that whole request completion can be hooked by rq->end_io()
because all device drivers call blk_end_request() to complete request.

Because the meaning of rq->end_io() is changed, existing rq->end_io()
users are changed as below:
  o Create a new end_io handler using blk_end_io().
    blk_end_io() is a default rq->end_io() handler and can take
    a callback function, which is called after end_that_request_last().
    So the old end_io() handler can be used as the callback.
  o Set the new end_io handler to rq->end_io.

scsi_transport_sas.c:sas_smp_request() seems expecting the request
is bsg and rq->end_io() is bsg_rq_end_io().
So changed to call it directly.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/bsg.c                       |   20 +++++++++-
 block/ll_rw_blk.c                 |   70 ++++++++++++++++++++++++++++++-------- drivers/md/dm-mpath-rdac.c        |   45 +++++++++++++++++++++---
 drivers/scsi/scsi_lib.c           |    9 ++++
 drivers/scsi/scsi_transport_sas.c |    2 -
 include/linux/blkdev.h            |   12 +++++-
 include/linux/bsg.h               |    5 ++
 7 files changed, 139 insertions(+), 24 deletions(-)

diff -rupN 06-remove-old-interface/block/bsg.c 07-change-end-io/block/bsg.c
--- 06-remove-old-interface/block/bsg.c	2007-08-13 00:25:24.000000000 -0400
+++ 07-change-end-io/block/bsg.c	2007-08-24 12:34:14.000000000 -0400
@@ -312,9 +312,9 @@ out:
 
 /*
  * async completion call-back from the block layer, when scsi/ide/whatever
- * calls end_that_request_last() on a request
+ * calls blk_end_request() on a request
  */
-static void bsg_rq_end_io(struct request *rq, int uptodate)
+static void bsg_rq_dtor(struct request *rq, int uptodate)
 {
 	struct bsg_command *bc = rq->end_io_data;
 	struct bsg_device *bd = bc->bd;
@@ -333,6 +333,22 @@ static void bsg_rq_end_io(struct request
 	wake_up(&bd->wq_done);
 }
 
+static int bsg_rq_end_io(struct request *rq, int uptodate, int nr_bytes,
+			 int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(rq, uptodate, nr_bytes, needlock, bsg_rq_dtor,
+			  drv_callback);
+}
+
+/*
+ * rq->q's lock must be held.
+ */
+void bsg_end_request(struct request *rq, int uptodate)
+{
+	bsg_rq_dtor(rq, uptodate);
+}
+EXPORT_SYMBOL_GPL(bsg_end_request);
+
 /*
  * do final setup of a 'bc' and submit the matching 'rq' to the block
  * layer for io
diff -rupN 06-remove-old-interface/block/ll_rw_blk.c 07-change-end-io/block/ll_rw_blk.c
--- 06-remove-old-interface/block/ll_rw_blk.c	2007-08-24 12:19:02.000000000 -0400
+++ 07-change-end-io/block/ll_rw_blk.c	2007-08-24 12:31:41.000000000 -0400
@@ -383,24 +383,45 @@ void blk_ordered_complete_seq(struct req
 		BUG();
 }
 
-static void pre_flush_end_io(struct request *rq, int error)
+static void pre_flush_dtor(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
 	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_PREFLUSH, error);
 }
 
-static void bar_end_io(struct request *rq, int error)
+static int pre_flush_end_io(struct request *rq, int uptodate, int nr_bytes,
+			    int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(rq, uptodate, nr_bytes, needlock, pre_flush_dtor,
+			  drv_callback);
+}
+
+static void bar_dtor(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
 	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_BAR, error);
 }
 
-static void post_flush_end_io(struct request *rq, int error)
+static int bar_end_io(struct request *rq, int uptodate, int nr_bytes,
+		      int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(rq, uptodate, nr_bytes, needlock, bar_dtor,
+			  drv_callback);
+}
+
+static void post_flush_dtor(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
 	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_POSTFLUSH, error);
 }
 
+static int post_flush_end_io(struct request *rq, int uptodate, int nr_bytes,
+			     int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(rq, uptodate, nr_bytes, needlock, post_flush_dtor,
+			  drv_callback);
+}
+
 static void queue_flush(struct request_queue *q, unsigned which)
 {
 	struct request *rq;
@@ -2780,11 +2801,11 @@ void blk_put_request(struct request *req
 EXPORT_SYMBOL(blk_put_request);
 
 /**
- * blk_end_sync_rq - executes a completion event on a request
+ * blk_sync_rq_dtor - executes a completion event on a request
  * @rq: request to complete
  * @error: end io status of the request
  */
-void blk_end_sync_rq(struct request *rq, int error)
+static void blk_sync_rq_dtor(struct request *rq, int error)
 {
 	struct completion *waiting = rq->end_io_data;
 
@@ -2797,6 +2818,13 @@ void blk_end_sync_rq(struct request *rq,
 	 */
 	complete(waiting);
 }
+
+int blk_end_sync_rq(struct request *rq, int uptodate, int nr_bytes,
+		    int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(rq, uptodate, nr_bytes, needlock, blk_sync_rq_dtor,
+			  drv_callback);
+}
 EXPORT_SYMBOL(blk_end_sync_rq);
 
 /*
@@ -3591,7 +3619,8 @@ EXPORT_SYMBOL(blk_complete_request);
 /*
  * queue lock must be held
  */
-static void end_that_request_last(struct request *req, int uptodate)
+static void end_that_request_last(struct request *req, int uptodate,
+				  void (dtor)(struct request *, int))
 {
 	struct gendisk *disk = req->rq_disk;
 	int error;
@@ -3620,8 +3649,8 @@ static void end_that_request_last(struct
 		disk_round_stats(disk);
 		disk->in_flight--;
 	}
-	if (req->end_io)
-		req->end_io(req, error);
+	if (dtor)
+		dtor(req, error);
 	else
 		__blk_put_request(req->q, req);
 }
@@ -3634,12 +3663,13 @@ void end_request(struct request *req, in
 EXPORT_SYMBOL(end_request);
 
 /**
- * ____blk_end_request - Generic end_io function to complete a request.
+ * blk_end_io - Generic end_io function to complete a request.
  * @rq:           the request being processed
  * @uptodate:     1 for success, 0 for I/O error, < 0 for specific error
  * @nr_bytes:     number of bytes to complete
  * @needlock:     1 for queue lock need to be held.
  *                0 for queue lock held already.
+ * @dtor:         destructor function for the request.
  * @drv_callback: function called between completion of bios in the request
  *                and completion of the request.
  *                If the callback returns non 0, this helper returns without
@@ -3648,14 +3678,16 @@ EXPORT_SYMBOL(end_request);
  * Description:
  *     Ends I/O on a number of bytes attached to @rq.
  *     If @rq has leftover, sets it up for the next range of segments.
+ *     This function should be called only from request end_io function
+ *     or blk_end_request().
  *
  * Return:
  *     0 - we are done with this request
  *     1 - this request is not freed yet, it still has pending buffers.
  **/
-static int ____blk_end_request(struct request *rq, int uptodate, int nr_bytes,
-			       int needlock,
-			       int (drv_callback)(struct request *))
+int blk_end_io(struct request *rq, int uptodate, int nr_bytes, int needlock,
+	       void (dtor)(struct request *, int),
+	       int (drv_callback)(struct request *))
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
@@ -3684,13 +3716,25 @@ static int ____blk_end_request(struct re
 	if (!list_empty(&rq->queuelist))
 		blkdev_dequeue_request(rq);
 
-	end_that_request_last(rq, uptodate);
+	end_that_request_last(rq, uptodate, dtor);
 
 	if (needlock)
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_end_io);
+
+static inline int ____blk_end_request(struct request *rq, int uptodate,
+				      int nr_bytes, int needlock,
+				      int (drv_callback)(struct request *))
+{
+	if (rq->end_io)
+		return rq->end_io(rq, uptodate, nr_bytes, needlock,
+				  drv_callback);
+
+	return blk_end_io(rq, uptodate, nr_bytes, needlock, NULL, drv_callback);
+}
 
 /**
  * blk_end_request - Helper function for drivers to complete the request.
diff -rupN 06-remove-old-interface/drivers/md/dm-mpath-rdac.c 07-change-end-io/drivers/md/dm-mpath-rdac.c
--- 06-remove-old-interface/drivers/md/dm-mpath-rdac.c	2007-08-22 18:54:04.000000000 -0400
+++ 07-change-end-io/drivers/md/dm-mpath-rdac.c	2007-08-24 12:26:06.000000000 -0400
@@ -223,7 +223,7 @@ static void rdac_resubmit_all(struct rda
 	spin_unlock(&ctlr->lock);
 }
 
-static void mode_select_endio(struct request *req, int error)
+static void mode_select_dtor(struct request *req, int error)
 {
 	struct rdac_handler *h = req->end_io_data;
 	struct scsi_sense_hdr sense_hdr;
@@ -265,6 +265,13 @@ done:
 	__blk_put_request(req->q, req);
 }
 
+static int mode_select_endio(struct request *req, int uptodate, int nr_bytes,
+			     int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(req, uptodate, nr_bytes, needlock, mode_select_dtor,
+			  drv_callback);
+}
+
 static struct request *get_rdac_req(struct rdac_handler *h,
 			void *buffer, unsigned buflen, int rw)
 {
@@ -427,7 +434,7 @@ done:
 	return ctlr;
 }
 
-static void c4_endio(struct request *req, int error)
+static void c4_dtor(struct request *req, int error)
 {
 	struct rdac_handler *h = req->end_io_data;
 	struct c4_inquiry *sp;
@@ -450,7 +457,14 @@ done:
 	__blk_put_request(req->q, req);
 }
 
-static void c2_endio(struct request *req, int error)
+static int c4_endio(struct request *req, int uptodate, int nr_bytes,
+		    int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(req, uptodate, nr_bytes, needlock, c4_dtor,
+			  drv_callback);
+}
+
+static void c2_dtor(struct request *req, int error)
 {
 	struct rdac_handler *h = req->end_io_data;
 	struct c2_inquiry *sp;
@@ -474,7 +488,14 @@ done:
 	__blk_put_request(req->q, req);
 }
 
-static void c9_endio(struct request *req, int error)
+static int c2_endio(struct request *req, int uptodate, int nr_bytes,
+		    int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(req, uptodate, nr_bytes, needlock, c2_dtor,
+			  drv_callback);
+}
+
+static void c9_dtor(struct request *req, int error)
 {
 	struct rdac_handler *h = req->end_io_data;
 	struct c9_inquiry *sp;
@@ -515,7 +536,14 @@ done:
 	__blk_put_request(req->q, req);
 }
 
-static void c8_endio(struct request *req, int error)
+static int c9_endio(struct request *req, int uptodate, int nr_bytes,
+		    int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(req, uptodate, nr_bytes, needlock, c9_dtor,
+			  drv_callback);
+}
+
+static void c8_dtor(struct request *req, int error)
 {
 	struct rdac_handler *h = req->end_io_data;
 	struct c8_inquiry *sp;
@@ -536,6 +564,13 @@ done:
 	__blk_put_request(req->q, req);
 }
 
+static int c8_endio(struct request *req, int uptodate, int nr_bytes,
+		    int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(req, uptodate, nr_bytes, needlock, c8_dtor,
+			  drv_callback);
+}
+
 static void submit_inquiry(struct rdac_handler *h, int page_code,
 		unsigned int len, rq_end_io_fn endio)
 {
diff -rupN 06-remove-old-interface/drivers/scsi/scsi_lib.c 07-change-end-io/drivers/scsi/scsi_lib.c
--- 06-remove-old-interface/drivers/scsi/scsi_lib.c	2007-08-23 17:51:33.000000000 -0400
+++ 07-change-end-io/drivers/scsi/scsi_lib.c	2007-08-24 12:26:06.000000000 -0400
@@ -248,7 +248,7 @@ struct scsi_io_context {
 
 static struct kmem_cache *scsi_io_context_cache;
 
-static void scsi_end_async(struct request *req, int uptodate)
+static void scsi_async_dtor(struct request *req, int uptodate)
 {
 	struct scsi_io_context *sioc = req->end_io_data;
 
@@ -259,6 +259,13 @@ static void scsi_end_async(struct reques
 	__blk_put_request(req->q, req);
 }
 
+static int scsi_end_async(struct request *req, int uptodate, int nr_bytes,
+			  int needlock, int (drv_callback)(struct request *))
+{
+	return blk_end_io(req, uptodate, nr_bytes, needlock, scsi_async_dtor,
+			  drv_callback);
+}
+
 static int scsi_merge_bio(struct request *rq, struct bio *bio)
 {
 	struct request_queue *q = rq->q;
diff -rupN 06-remove-old-interface/drivers/scsi/scsi_transport_sas.c 07-change-end-io/drivers/scsi/scsi_transport_sas.c
--- 06-remove-old-interface/drivers/scsi/scsi_transport_sas.c	2007-08-13 00:25:24.000000000 -0400
+++ 07-change-end-io/drivers/scsi/scsi_transport_sas.c	2007-08-24 12:35:24.000000000 -0400
@@ -176,7 +176,7 @@ static void sas_smp_request(struct reque
 
 		spin_lock_irq(q->queue_lock);
 
-		req->end_io(req, ret);
+		bsg_end_request(req, ret);
 	}
 }
 
diff -rupN 06-remove-old-interface/include/linux/blkdev.h 07-change-end-io/include/linux/blkdev.h
--- 06-remove-old-interface/include/linux/blkdev.h	2007-08-24 12:21:15.000000000 -0400
+++ 07-change-end-io/include/linux/blkdev.h	2007-08-24 12:32:44.000000000 -0400
@@ -129,7 +129,8 @@ void copy_io_context(struct io_context *
 void swap_io_context(struct io_context **ioc1, struct io_context **ioc2);
 
 struct request;
-typedef void (rq_end_io_fn)(struct request *, int);
+typedef int (rq_end_io_fn)(struct request *rq, int uptodate, int nr_bytes,
+			   int needlock, int (drv_callback)(struct request *));
 
 struct request_list {
 	int count[2];
@@ -647,7 +648,8 @@ extern void register_disk(struct gendisk
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
-extern void blk_end_sync_rq(struct request *rq, int error);
+extern int blk_end_sync_rq(struct request *rq, int uptodate, int nr_bytes,
+			   int needlock, int (drv_callback)(struct request *));
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
@@ -734,6 +736,12 @@ extern void end_request(struct request *
 extern int blk_end_request_callback(struct request *rq, int uptodate,
 				    int nr_bytes,
 				    int (drv_callback)(struct request *));
+
+/* blk_end_io: Helper function for custom end_io function */
+extern int blk_end_io(struct request *rq, int uptodate, int nr_bytes,
+		      int needlock, void (dtor)(struct request *, int),
+		      int (drv_callback)(struct request *));
+
 extern void blk_complete_request(struct request *);
 
 /*
diff -rupN 06-remove-old-interface/include/linux/bsg.h 07-change-end-io/include/linux/bsg.h
--- 06-remove-old-interface/include/linux/bsg.h	2007-08-22 18:54:07.000000000 -0400
+++ 07-change-end-io/include/linux/bsg.h	2007-08-24 12:36:16.000000000 -0400
@@ -53,6 +53,7 @@ struct sg_io_v4 {
 
 #ifdef __KERNEL__
 
+struct request;
 struct request_queue;
 struct device;
 
@@ -66,6 +67,7 @@ struct bsg_class_device {
 
 extern int bsg_register_queue(struct request_queue *, struct device *, const char *);
 extern void bsg_unregister_queue(struct request_queue *);
+extern void bsg_end_request(struct request *rq, int uptodate);
 #else
 static inline int bsg_register_queue(struct request_queue * rq, struct device *dev, const char *name)
 {
@@ -74,6 +76,9 @@ static inline int bsg_register_queue(str
 static inline void bsg_unregister_queue(struct request_queue *rq)
 {
 }
+static inline void bsg_end_request(struct request *rq, int uptodate)
+{
+}
 #endif
 
 #endif /* __KERNEL__ */
