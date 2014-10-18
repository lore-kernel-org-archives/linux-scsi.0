From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Sparc ESP problem with blk-mq
Date: Sat, 18 Oct 2014 10:57:03 -0700
Message-ID: <20141018175703.GA16988@infradead.org>
References: <20141015.165324.1768019967735260346.davem@davemloft.net>
 <alpine.LRH.2.11.1410160942150.13273@adalberg.ut.ee>
 <20141017.155612.266274322805506383.davem@davemloft.net>
 <20141018.133132.1505060820853861420.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141018.133132.1505060820853861420.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, hch@infradead.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 18, 2014 at 01:31:32PM -0400, David Miller wrote:
> 
> Christoph, I don't see how the new tagging code with blk-mq can
> be providing compatible behavior for existing SCSI drivers.

It doesn't, and that's my fault.

Please try the patch below:


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diff

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 2101e71..e465344 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -740,11 +740,6 @@ one outstanding command on a queue at any given time.
 	Initialize internal command tagging structures for a maximum
 	depth of 'depth'.
 
-	blk_queue_free_tags((struct request_queue *q)
-
-	Teardown tag info associated with the queue. This will be done
-	automatically by block if blk_queue_cleanup() is called on a queue
-	that is using tagging.
 
 The above are initialization and exit management, the main helpers during
 normal operations are:
diff --git a/block/blk-tag.c b/block/blk-tag.c
index a185b86..5daff44 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -71,20 +71,6 @@ void __blk_queue_free_tags(struct request_queue *q)
 	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
 }
 
-/**
- * blk_queue_free_tags - release tag maintenance info
- * @q:  the request queue for the device
- *
- *  Notes:
- *	This is used to disable tagged queuing to a device, yet leave
- *	queue in function.
- **/
-void blk_queue_free_tags(struct request_queue *q)
-{
-	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
-}
-EXPORT_SYMBOL(blk_queue_free_tags);
-
 static int
 init_tag_map(struct request_queue *q, struct blk_queue_tag *tags, int depth)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 87be398..06d1254 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1142,13 +1142,18 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 /*
  * tag stuff
  */
-#define blk_rq_tagged(rq) \
-	((rq)->mq_ctx || ((rq)->cmd_flags & REQ_QUEUED))
+static inline bool blk_rq_tagged(struct request *rq)
+{
+	if (rq->mq_ctx)
+		return blk_queue_tagged(rq->q);
+	else
+		return (rq->cmd_flags & REQ_QUEUED);
+}
+
 extern int blk_queue_start_tag(struct request_queue *, struct request *);
 extern struct request *blk_queue_find_tag(struct request_queue *, int);
 extern void blk_queue_end_tag(struct request_queue *, struct request *);
 extern int blk_queue_init_tags(struct request_queue *, int, struct blk_queue_tag *);
-extern void blk_queue_free_tags(struct request_queue *);
 extern int blk_queue_resize_tags(struct request_queue *, int);
 extern void blk_queue_invalidate_tags(struct request_queue *);
 extern struct blk_queue_tag *blk_init_tags(int);
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index e645835..c977a25 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -67,10 +67,13 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
 	if (!sdev->tagged_supported)
 		return;
 
-	if (!shost_use_blk_mq(sdev->host) &&
-	    !blk_queue_tagged(sdev->request_queue))
-		blk_queue_init_tags(sdev->request_queue, depth,
-				    sdev->host->bqt);
+	if (shost_use_blk_mq(sdev->host)) {
+		queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, sdev->request_queue);
+	} else {
+		if (!blk_queue_tagged(sdev->request_queue))
+			blk_queue_init_tags(sdev->request_queue, depth,
+					    sdev->host->bqt);
+	}
 
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
 }
@@ -81,9 +84,9 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
  **/
 static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
 {
-	if (!shost_use_blk_mq(sdev->host) &&
-	    blk_queue_tagged(sdev->request_queue))
-		blk_queue_free_tags(sdev->request_queue);
+	if (blk_queue_tagged(sdev->request_queue))
+		queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED,
+				sdev->request_queue);
 	scsi_adjust_queue_depth(sdev, 0, depth);
 }
 

--oyUTqETQ0mS9luUI--
