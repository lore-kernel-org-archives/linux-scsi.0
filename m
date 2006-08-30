From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] block: add support for shared tag maps
Date: Wed, 30 Aug 2006 09:44:18 -0400
Message-ID: <1156945459.3735.14.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:58045 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751048AbWH3NoT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 09:44:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Ed Lin <ed.lin@promise.com>, Jens Axboe <axboe@suse.de>

[PATCH] block: add support for shared tag maps

The current block queue implementation already contains most of the
machinery for shared tag maps.  The only remaining pieces are a way to
allocate and destroy a tag map independently of the queues (so that
the maps can be managed on the life cycle of the overseeing entity)


Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -848,6 +848,34 @@ struct request *blk_queue_find_tag(reque
 EXPORT_SYMBOL(blk_queue_find_tag);
 
 /**
+ * __blk_free_tags - release a given set of tag maintenance info
+ *
+ * @bqt:	the tag map to free
+ *
+ * Tries to free the specified @bqt@.  Returns true if it was
+ * actually freed and false if there are still references using it
+ */
+static int __blk_free_tags(struct blk_queue_tag *bqt)
+{
+	int retval = atomic_dec_and_test(&bqt->refcnt);
+	if (retval) {
+		BUG_ON(bqt->busy);
+		BUG_ON(!list_empty(&bqt->busy_list));
+
+		kfree(bqt->tag_index);
+		bqt->tag_index = NULL;
+
+		kfree(bqt->tag_map);
+		bqt->tag_map = NULL;
+
+		kfree(bqt);
+
+	}
+
+	return retval;
+}
+
+/**
  * __blk_queue_free_tags - release tag maintenance info
  * @q:  the request queue for the device
  *
@@ -862,23 +890,28 @@ static void __blk_queue_free_tags(reques
 	if (!bqt)
 		return;
 
-	if (atomic_dec_and_test(&bqt->refcnt)) {
-		BUG_ON(bqt->busy);
-		BUG_ON(!list_empty(&bqt->busy_list));
-
-		kfree(bqt->tag_index);
-		bqt->tag_index = NULL;
-
-		kfree(bqt->tag_map);
-		bqt->tag_map = NULL;
-
-		kfree(bqt);
-	}
+	__blk_free_tags(bqt);
 
 	q->queue_tags = NULL;
 	q->queue_flags &= ~(1 << QUEUE_FLAG_QUEUED);
 }
 
+
+/**
+ * blk_free_tags - release a given set of tag maintenance info
+ *
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
+ fail:
+	return NULL;
+}
+
+/**
+ * blk_init_tags - initialize the tag info for an external tag map
+ *
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


