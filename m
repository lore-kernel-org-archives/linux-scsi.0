From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [9/21] Add blk_kmalloc/blk_alloc_pages
Date: Thu,  6 Mar 2008 21:51:29 +0100 (CET)
Message-ID: <20080306205129.AAB8D1B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:53297 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762292AbYCFUvl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:41 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


When a user is doing IO in the kernel and wants to avoid bouncing
it is best to just ask the block layer to allocate the memory for it.
This patch adds two simple wrappers: blk_kmalloc and blk_alloc_pages
and respective free functions to do this.

blk_alloc_pages is a little unusual in that it takes size
instead of order arguments -- i did this because I have later
patches to convert it over to a new allocator which does not 
require power of two for pages.

Needed for followup patches

Signed-off-by: Andi Kleen <ak@suse.de>

---
 block/blk-settings.c   |   13 +++++++++++++
 include/linux/blkdev.h |   12 ++++++++++++
 2 files changed, 25 insertions(+)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h
+++ linux/include/linux/blkdev.h
@@ -555,6 +555,18 @@ static inline void blk_queue_bounce(stru
 }
 #endif /* CONFIG_MMU */
 
+extern struct page *blk_alloc_pages(struct request_queue *q, gfp_t gfp, int size);
+extern void *blk_kmalloc(struct request_queue *q, unsigned size, gfp_t gfp);
+static inline void blk_free_pages(struct page *p, int size)
+{
+	__free_pages(p, get_order(size));
+}
+
+static inline void blk_kfree(void *p, int size)
+{
+	kfree(p);
+}
+
 struct req_iterator {
 	int i;
 	struct bio *bio;
Index: linux/block/blk-settings.c
===================================================================
--- linux.orig/block/blk-settings.c
+++ linux/block/blk-settings.c
@@ -156,6 +156,19 @@ void blk_queue_bounce_limit(struct reque
 }
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
+struct page *blk_alloc_pages(struct request_queue *q,
+				   gfp_t gfp, int size)
+{
+	return alloc_pages((q->bounce_gfp & ~GFP_NOIO) | gfp, get_order(size));
+}
+EXPORT_SYMBOL(blk_alloc_pages);
+
+void *blk_kmalloc(struct request_queue *q, unsigned size, gfp_t gfp)
+{
+	return kmalloc(size, gfp | (q->bounce_gfp & ~GFP_NOIO));
+}
+EXPORT_SYMBOL(blk_kmalloc);
+
 /**
  * blk_queue_max_sectors - set max sectors for a request for this queue
  * @q:  the request queue for the device
