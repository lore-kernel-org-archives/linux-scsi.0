From: Abhijeet Joglekar <ajoglekar@nuovasystems.com>
Subject: [RFC][PATCH] blk-tag: Use atomic_t type for bqt->busy.
Date: Mon, 25 Aug 2008 18:03:30 -0700
Message-ID: <20080826010306.27375.59063.stgit@feynman.nuovasystems.com>
References: <20080826005856.27375.59152.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:29697 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753751AbYHZByc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 21:54:32 -0400
In-Reply-To: <20080826005856.27375.59152.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, ajoglekar@nuovasystems.com

blk-tag: Use atomic_t type for bqt->busy.

bqt->busy is an integer that keeps count of number of outstanding tags. For
host-wide shared tag map, busy is accessed in a queue lock (not host lock)
which corrupts the busy value. Change busy to atomic_t and use atomic
macros to access it.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
---
 block/blk-tag.c        |    8 ++++----
 include/linux/blkdev.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/block/blk-tag.c b/block/blk-tag.c
index 32667be..8f37d08 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -38,7 +38,7 @@ static int __blk_free_tags(struct blk_queue_tag *bqt)
 
 	retval = atomic_dec_and_test(&bqt->refcnt);
 	if (retval) {
-		BUG_ON(bqt->busy);
+		BUG_ON(atomic_read(&bqt->busy));
 
 		kfree(bqt->tag_index);
 		bqt->tag_index = NULL;
@@ -147,7 +147,7 @@ static struct blk_queue_tag *__blk_queue_init_tags(struct request_queue *q,
 	if (init_tag_map(q, tags, depth))
 		goto fail;
 
-	tags->busy = 0;
+	atomic_set(&tags->busy, 0);
 	atomic_set(&tags->refcnt, 1);
 	return tags;
 fail:
@@ -313,7 +313,7 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 	 * unlock memory barrier semantics.
 	 */
 	clear_bit_unlock(tag, bqt->tag_map);
-	bqt->busy--;
+	atomic_dec(&bqt->busy);
 }
 EXPORT_SYMBOL(blk_queue_end_tag);
 
@@ -368,7 +368,7 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	bqt->tag_index[tag] = rq;
 	blkdev_dequeue_request(rq);
 	list_add(&rq->queuelist, &q->tag_busy_list);
-	bqt->busy++;
+	atomic_inc(&bqt->busy);
 	return 0;
 }
 EXPORT_SYMBOL(blk_queue_start_tag);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 88d6808..106531e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -274,7 +274,7 @@ enum blk_queue_state {
 struct blk_queue_tag {
 	struct request **tag_index;	/* map of busy tags */
 	unsigned long *tag_map;		/* bit map of free/busy tags */
-	int busy;			/* current depth */
+	atomic_t busy;			/* current depth */
 	int max_depth;			/* what we will send to device */
 	int real_max_depth;		/* what the array can hold */
 	atomic_t refcnt;		/* map can be shared */


