From: Christoph Hellwig <hch@infradead.org>
Subject: Re: uas: kernel BUG at block/blk-tag.c:89 is back again :|
Date: Tue, 8 Jul 2014 02:56:19 -0700
Message-ID: <20140708095619.GA11196@infradead.org>
References: <53B2B4B2.8050100@redhat.com>
 <20140703060135.GA5292@infradead.org>
 <53B93FE3.8050607@redhat.com>
 <20140707101015.GB3544@infradead.org>
 <53BA95C0.3020607@redhat.com>
 <20140708095317.GA4306@infradead.org>
 <53BBBFC6.2030205@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaGHJ4Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2014 05:56:25 -0400
Content-Disposition: inline
In-Reply-To: <53BBBFC6.2030205@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Hans de Goede <hdegoede@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi@vger.kernel.org

On Tue, Jul 08, 2014 at 11:54:14AM +0200, Jens Axboe wrote:
> >I've posted the patch in reply to another report and added Jens to the
> >Cc list.  As the block maintainer he need to review and merge it.
> 
> Which patch is this?

This one:

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
