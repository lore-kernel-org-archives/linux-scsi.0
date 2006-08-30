From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH, take2] block: add support for shared tag maps
Date: Wed, 30 Aug 2006 15:48:45 -0400
Message-ID: <1156967326.7701.17.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38597 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751431AbWH3Tss (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 15:48:48 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k7UJmk514605
	for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2006 15:48:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is redone with Randy's comments plus Jens' via IRC.  And I've added the missing header diffs.

James

----

[PATCH] block: add support for shared tag maps

The current block queue implementation already contains most of the
machinery for shared tag maps.  The only remaining pieces are a way to
allocate and destroy a tag map independently of the queues (so that
the maps can be managed on the life cycle of the overseeing entity)


Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -848,21 +848,18 @@ struct request *blk_queue_find_tag(reque
 EXPORT_SYMBOL(blk_queue_find_tag);
 
 /**
- * __blk_queue_free_tags - release tag maintenance info
- * @q:  the request queue for the device
+ * __blk_free_tags - release a given set of tag maintenance info
+ * @bqt:	the tag map to free
  *
- *  Notes:
- *    blk_cleanup_queue() will take care of calling this function, if tagging
- *    has been used. So there's no need to call this directly.
- **/
-static void __blk_queue_free_tags(request_queue_t *q)
+ * Tries to free the specified @bqt@.  Returns true if it was
+ * actually freed and false if there are still references using it
+ */
+static int __blk_free_tags(struct blk_queue_tag *bqt)
 {
-	struct blk_queue_tag *bqt = q->queue_tags;
-
-	if (!bqt)
-		return;
+	int retval;
 
-	if (atomic_dec_and_test(&bqt->refcnt)) {
+	retval = atomic_dec_and_test(&bqt->refcnt);
+	if (retval) {
 		BUG_ON(bqt->busy);
 		BUG_ON(!list_empty(&bqt->busy_list));
 
@@ -873,12 +870,48 @@ static void __blk_queue_free_tags(reques
 		bqt->tag_map = NULL;
 
 		kfree(bqt);
+
 	}
 
+	return retval;
+}
+
+/**
+ * __blk_queue_free_tags - release tag maintenance info
+ * @q:  the request queue for the device
+ *
+ *  Notes:
+ *    blk_cleanup_queue() will take care of calling this function, if tagging
+ *    has been used. So there's no need to call this directly.
+ **/
+static void __blk_queue_free_tags(request_queue_t *q)
+{
+	struct blk_queue_tag *bqt = q->queue_tags;
+
+	if (!bqt)
+		return;
+
+	__blk_free_tags(bqt);
+
 	q->queue_tags = NULL;
 	q->queue_flags &= ~(1 << QUEUE_FLAG_QUEUED);
 }
 
+
+/**
+ * blk_free_tags - release a given set of tag maintenance info
+ * @bqt:	the tag map to free
+ *
+ * For externally managed @bqt@ frees the map.  Callers of this
+ * function must guarantee to have released all the queues that
+ * might have been using this tag map.
+ */
+void blk_free_tags(struct blk_queue_tag *bqt)
+{
+	if (unlikely(!__blk_free_tags(bqt)))
+		BUG();
+}
+
 /**
  * blk_queue_free_tags - release tag maintenance info
  * @q:  the request queue for the device
@@ -901,7 +934,7 @@ init_tag_map(request_queue_t *q, struct 
 	unsigned long *tag_map;
 	int nr_ulongs;
 
-	if (depth > q->nr_requests * 2) {
+	if (q && depth > q->nr_requests * 2) {
 		depth = q->nr_requests * 2;
 		printk(KERN_ERR "%s: adjusted depth to %d\n",
 				__FUNCTION__, depth);
@@ -927,6 +960,38 @@ fail:
 	return -ENOMEM;
 }
 
+static struct blk_queue_tag *__blk_queue_init_tags(struct request_queue *q,
+						   int depth)
+{
+	struct blk_queue_tag *tags;
+
+	tags = kmalloc(sizeof(struct blk_queue_tag), GFP_ATOMIC);
+	if (!tags)
+		goto fail;
+
+	if (init_tag_map(q, tags, depth))
+		goto fail;
+
+	INIT_LIST_HEAD(&tags->busy_list);
+	tags->busy = 0;
+	atomic_set(&tags->refcnt, 1);
+	return tags;
+fail:
+	kfree(tags);
+	return NULL;
+}
+
+/**
+ * blk_init_tags - initialize the tag info for an external tag map
+ * @depth:	the maximum queue depth supported
+ * @tags: the tag to use
+ **/
+struct blk_queue_tag *blk_init_tags(int depth)
+{
+	return __blk_queue_init_tags(NULL, depth);
+}
+EXPORT_SYMBOL(blk_init_tags);
+
 /**
  * blk_queue_init_tags - initialize the queue tag info
  * @q:  the request queue for the device
@@ -941,16 +1006,10 @@ int blk_queue_init_tags(request_queue_t 
 	BUG_ON(tags && q->queue_tags && tags != q->queue_tags);
 
 	if (!tags && !q->queue_tags) {
-		tags = kmalloc(sizeof(struct blk_queue_tag), GFP_ATOMIC);
-		if (!tags)
-			goto fail;
+		tags = __blk_queue_init_tags(q, depth);
 
-		if (init_tag_map(q, tags, depth))
+		if (!tags)
 			goto fail;
-
-		INIT_LIST_HEAD(&tags->busy_list);
-		tags->busy = 0;
-		atomic_set(&tags->refcnt, 1);
 	} else if (q->queue_tags) {
 		if ((rc = blk_queue_resize_tags(q, depth)))
 			return rc;
@@ -1002,6 +1061,13 @@ int blk_queue_resize_tags(request_queue_
 	}
 
 	/*
+	 * Currently cannot replace a shared tag map with a new
+	 * one, so error out if this is the case
+	 */
+	if (atomic_read(&bqt->refcnt) != 1)
+		return -EBUSY;
+
+	/*
 	 * save the old state info, so we can copy it back
 	 */
 	tag_index = bqt->tag_index;
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -746,6 +746,8 @@ extern void blk_queue_free_tags(request_
 extern int blk_queue_resize_tags(request_queue_t *, int);
 extern void blk_queue_invalidate_tags(request_queue_t *);
 extern long blk_congestion_wait(int rw, long timeout);
+extern struct blk_queue_tag *blk_init_tags(int);
+extern void blk_free_tags(struct blk_queue_tag *);
 
 extern void blk_rq_bio_prep(request_queue_t *, struct request *, struct bio *);
 extern int blkdev_issue_flush(struct block_device *, sector_t *);


