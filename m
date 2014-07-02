From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel BUG() in block/blk-tag.c:89 causing panic.
Date: Wed, 2 Jul 2014 12:00:43 -0700
Message-ID: <20140702190043.GA10046@infradead.org>
References: <CAE6A3M1UUJWL4ZoUsLdtSjaWb92kdB7MvzHVeAgA+3ewBRG=LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44804 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaGBTAo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2014 15:00:44 -0400
Content-Disposition: inline
In-Reply-To: <CAE6A3M1UUJWL4ZoUsLdtSjaWb92kdB7MvzHVeAgA+3ewBRG=LA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saran Neti <sarannmr@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

Hi Saran,

can you please test the patch below?

---
From: Christoph Hellwig <hch@lst.de>
Subject: block: don't assume last put of shared tags is for the host

There is no inherent reason why the last put of a tag structure must be
the one for the Scsi_Host, as device model objects can be held for
arbitrary periods.  Merge blk_free_tags and __blk_free_tags into a single
funtion that just release a references and get rid of the BUG() when the
host reference wasn't the last.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/block/blk-tag.c b/block/blk-tag.c
index 3f33d86..a185b86 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -27,18 +27,15 @@ struct request *blk_queue_find_tag(struct request_queue *q, int tag)
 EXPORT_SYMBOL(blk_queue_find_tag);
 
 /**
- * __blk_free_tags - release a given set of tag maintenance info
+ * blk_free_tags - release a given set of tag maintenance info
  * @bqt:	the tag map to free
  *
- * Tries to free the specified @bqt.  Returns true if it was
- * actually freed and false if there are still references using it
+ * Drop the reference count on @bqt and frees it when the last reference
+ * is dropped.
  */
-static int __blk_free_tags(struct blk_queue_tag *bqt)
+void blk_free_tags(struct blk_queue_tag *bqt)
 {
-	int retval;
-
-	retval = atomic_dec_and_test(&bqt->refcnt);
-	if (retval) {
+	if (atomic_dec_and_test(&bqt->refcnt)) {
 		BUG_ON(find_first_bit(bqt->tag_map, bqt->max_depth) <
 							bqt->max_depth);
 
@@ -50,9 +47,8 @@ static int __blk_free_tags(struct blk_queue_tag *bqt)
 
 		kfree(bqt);
 	}
-
-	return retval;
 }
+EXPORT_SYMBOL(blk_free_tags);
 
 /**
  * __blk_queue_free_tags - release tag maintenance info
@@ -69,28 +65,13 @@ void __blk_queue_free_tags(struct request_queue *q)
 	if (!bqt)
 		return;
 
-	__blk_free_tags(bqt);
+	blk_free_tags(bqt);
 
 	q->queue_tags = NULL;
 	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
 }
 
 /**
- * blk_free_tags - release a given set of tag maintenance info
- * @bqt:	the tag map to free
- *
- * For externally managed @bqt frees the map.  Callers of this
- * function must guarantee to have released all the queues that
- * might have been using this tag map.
- */
-void blk_free_tags(struct blk_queue_tag *bqt)
-{
-	if (unlikely(!__blk_free_tags(bqt)))
-		BUG();
-}
-EXPORT_SYMBOL(blk_free_tags);
-
-/**
  * blk_queue_free_tags - release tag maintenance info
  * @q:  the request queue for the device
  *
