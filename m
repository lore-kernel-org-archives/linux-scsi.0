From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] p00001_scsi_tcq_queue_lock
Date: Mon, 09 Aug 2004 09:04:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4117846B.7030302@us.ibm.com>
References: <410FD03E.6040305@us.ibm.com> <1091815154.2421.15.camel@mulgrave>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000005050402090305040800"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:12506 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266578AbUHIOEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 10:04:30 -0400
In-Reply-To: <1091815154.2421.15.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000005050402090305040800
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Tue, 2004-08-03 at 10:49, Brian King wrote:
> 
>>Add locking to scsi_activate_tcq and scsi_deactivate_tcq to fix a race
>>condition that can occur when disabling tcqing with commands in flight.
> 
> 
> It's possible to do it like this.  However, we should really quiesce the
> SCSI device before disabling tcq.  It is not legal in the scsi spec to
> have both tagged and untagged commands outstanding.  Most drives do the
> right thing and return BUSY to an untagged request if they have tags in
> flight.  

Ok. I agree that we do not want both tagged and untagged requests going 
to the device. In the case of the ipr driver, the adapter microcode 
handles this for me. If there are tagged requests outstanding to a 
device and an untagged request is sent, the tagged requests must first 
finish, then the untagged request is sent to the device with no other 
requests outstanding.

> Also, we have to wait until all tags return before freeing the
> block layer tag structures...and there's always the devices that do
> strange things in this situation...

I sent the following patch to Jens last week as well and he applied it. 
This fixes the free problem you mention.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------000005050402090305040800
Content-Type: text/plain;
 name="blk_queue_free_tags.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blk_queue_free_tags.patch"



Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc2-bjking1/drivers/block/ll_rw_blk.c |   47 +++++++++++++++++-----
 linux-2.6.8-rc2-bjking1/include/scsi/scsi_tcq.h   |    8 +++
 2 files changed, 46 insertions(+), 9 deletions(-)

diff -puN drivers/block/ll_rw_blk.c~blk_queue_free_tags_bug2 drivers/block/ll_rw_blk.c
--- linux-2.6.8-rc2/drivers/block/ll_rw_blk.c~blk_queue_free_tags_bug2	2004-08-02 17:02:43.000000000 -0500
+++ linux-2.6.8-rc2-bjking1/drivers/block/ll_rw_blk.c	2004-08-03 10:45:14.000000000 -0500
@@ -482,15 +482,14 @@ struct request *blk_queue_find_tag(reque
 EXPORT_SYMBOL(blk_queue_find_tag);
 
 /**
- * blk_queue_free_tags - release tag maintenance info
+ * _blk_queue_free_tags - release tag maintenance info
  * @q:  the request queue for the device
  *
  *  Notes:
  *    blk_cleanup_queue() will take care of calling this function, if tagging
- *    has been used. So there's usually no need to call this directly, unless
- *    tagging is just being disabled but the queue remains in function.
+ *    has been used.
  **/
-void blk_queue_free_tags(request_queue_t *q)
+static void _blk_queue_free_tags(request_queue_t *q)
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
 
@@ -511,7 +510,21 @@ void blk_queue_free_tags(request_queue_t
 	}
 
 	q->queue_tags = NULL;
-	q->queue_flags &= ~(1 << QUEUE_FLAG_QUEUED);
+	clear_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+}
+
+/**
+ * blk_queue_free_tags - release tag maintenance info
+ * @q:  the request queue for the device
+ *
+ *  Notes:
+ *    blk_cleanup_queue() will take care of calling this function, if tagging
+ *    has been used. So there's usually no need to call this directly, unless
+ *    tagging is just being disabled but the queue remains in function.
+ **/
+void blk_queue_free_tags(request_queue_t *q)
+{
+	clear_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
 }
 
 EXPORT_SYMBOL(blk_queue_free_tags);
@@ -564,13 +577,22 @@ fail:
 int blk_queue_init_tags(request_queue_t *q, int depth,
 			struct blk_queue_tag *tags)
 {
-	if (!tags) {
+	int rc;
+
+	BUG_ON(tags && q->queue_tags && tags != q->queue_tags);
+
+	if (!tags && !q->queue_tags) {
 		tags = kmalloc(sizeof(struct blk_queue_tag), GFP_ATOMIC);
 		if (!tags)
 			goto fail;
 
 		if (init_tag_map(q, tags, depth))
 			goto fail;
+	} else if (q->queue_tags) {
+		if ((rc = blk_queue_resize_tags(q, depth)))
+			return rc;
+		set_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+		return 0;
 	} else
 		atomic_inc(&tags->refcnt);
 
@@ -578,7 +600,7 @@ int blk_queue_init_tags(request_queue_t 
 	 * assign it, all done
 	 */
 	q->queue_tags = tags;
-	q->queue_flags |= (1 << QUEUE_FLAG_QUEUED);
+	set_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
 	return 0;
 fail:
 	kfree(tags);
@@ -1333,8 +1355,8 @@ void blk_cleanup_queue(request_queue_t *
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 
-	if (blk_queue_tagged(q))
-		blk_queue_free_tags(q);
+	if (q->queue_tags)
+		_blk_queue_free_tags(q);
 
 	kmem_cache_free(requestq_cachep, q);
 }
@@ -2034,6 +2056,13 @@ void __blk_put_request(request_queue_t *
 
 		elv_completed_request(q, req);
 
+		if (!list_empty(&req->queuelist)) {
+			if (req->flags & REQ_QUEUED)
+				printk(KERN_ERR "REQ_QUEUED still set in __blk_put_request\n");
+			printk(KERN_ERR "req: %p, q: %p, req_flags: %lx, q_flags: %lx\n",
+			       req, q, req->flags, q->queue_flags);
+		}
+
 		BUG_ON(!list_empty(&req->queuelist));
 
 		blk_free_request(q, req);
diff -puN include/scsi/scsi_tcq.h~blk_queue_free_tags_bug2 include/scsi/scsi_tcq.h
--- linux-2.6.8-rc2/include/scsi/scsi_tcq.h~blk_queue_free_tags_bug2	2004-08-02 17:02:43.000000000 -0500
+++ linux-2.6.8-rc2-bjking1/include/scsi/scsi_tcq.h	2004-08-02 17:02:43.000000000 -0500
@@ -25,9 +25,13 @@
  **/
 static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
 {
+        unsigned long flags;
+
         if (sdev->tagged_supported) {
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 		if (!blk_queue_tagged(sdev->request_queue))
 			blk_queue_init_tags(sdev->request_queue, depth, NULL);
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
         }
 }
@@ -38,8 +42,12 @@ static inline void scsi_activate_tcq(str
  **/
 static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	if (blk_queue_tagged(sdev->request_queue))
 		blk_queue_free_tags(sdev->request_queue);
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 	scsi_adjust_queue_depth(sdev, 0, depth);
 }
 
_

--------------000005050402090305040800--

