From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] block: add blk_rq_aligned helper function
Date: Thu, 28 Aug 2008 15:05:58 +0900
Message-ID: <1219903559-32612-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1219903559-32612-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219903559-32612-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49411 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbYH1GIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 02:08:02 -0400
In-Reply-To: <1219903559-32612-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This adds blk_rq_aligned helper function to see if alignment and
padding requirement is satisfied for DMA transfer. This also converts
blk_rq_map_kern and __blk_rq_map_user to use the helper function.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-map.c        |   12 ++----------
 include/linux/blkdev.h |    7 +++++++
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index dad6a29..572140c 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -45,7 +45,6 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 			     unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long uaddr;
-	unsigned int alignment;
 	struct bio *bio, *orig_bio;
 	int reading, ret;
 
@@ -56,8 +55,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	 * direct dma. else, set up kernel bounce buffers
 	 */
 	uaddr = (unsigned long) ubuf;
-	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-	if (!(uaddr & alignment) && !(len & alignment) && !map_data)
+	if (blk_rq_aligned(q, ubuf, len) && !map_data)
 		bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
 	else
 		bio = bio_copy_user(q, map_data, uaddr, len, reading, gfp_mask);
@@ -274,8 +272,6 @@ EXPORT_SYMBOL(blk_rq_unmap_user);
 int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		    unsigned int len, gfp_t gfp_mask)
 {
-	unsigned long kaddr;
-	unsigned int alignment;
 	int reading = rq_data_dir(rq) == READ;
 	int do_copy = 0;
 	struct bio *bio;
@@ -285,11 +281,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (!len || !kbuf)
 		return -EINVAL;
 
-	kaddr = (unsigned long)kbuf;
-	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-	do_copy = ((kaddr & alignment) || (len & alignment) ||
-		   object_is_on_stack(kbuf));
-
+	do_copy = !blk_rq_aligned(q, kbuf, len) || object_is_on_stack(kbuf);
 	if (do_copy)
 		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
 	else
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d2faa72..4cd8caa 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -901,6 +901,13 @@ static inline int queue_dma_alignment(struct request_queue *q)
 	return q ? q->dma_alignment : 511;
 }
 
+static inline int blk_rq_aligned(struct request_queue *q, void *addr,
+				 unsigned int len)
+{
+	unsigned int alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+	return !((unsigned long)addr & alignment) && !(len & alignment);
+}
+
 /* assumes size > 256 */
 static inline unsigned int blksize_bits(unsigned int size)
 {
-- 
1.5.5.GIT

