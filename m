From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] block: add bio_copy_user_iov support to blk_rq_map_user_iov
Date: Thu, 10 Apr 2008 23:17:12 +0900
Message-ID: <1207837033-23835-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1207837033-23835-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35807 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbYDJOT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2008 10:19:58 -0400
In-Reply-To: <1207837033-23835-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tejun Heo <htejun@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

With this patch, blk_rq_map_user_iov uses bio_copy_user_iov when a low
level driver needs padding or a buffer in sg_iovec isn't aligned. That
is, it uses temporary kernel buffers instead of mapping user pages
directly.

When a LLD needs padding, later blk_rq_map_sg needs to extend the last
entry of a scatter list. bio_copy_user_iov guarantees that there is
enough space for padding by using temporary kernel buffers instead of
user pages.

blk_rq_map_user_iov needs buffers in sg_iovec to be aligned. The
comment in blk_rq_map_user_iov indicates that drivers/scsi/sg.c also
needs buffers in sg_iovec to be aligned. Actually, drivers/scsi/sg.c
works with unaligned buffers in sg_iovec (it always uses temporary
kernel buffers).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-map.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index c07d9c8..ab43533 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <scsi/sg.h>		/* for struct sg_iovec */
 
 #include "blk.h"
 
@@ -194,15 +195,26 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			struct sg_iovec *iov, int iov_count, unsigned int len)
 {
 	struct bio *bio;
+	int i, read = rq_data_dir(rq) == READ;
+	int unaligned = 0;
 
 	if (!iov || iov_count <= 0)
 		return -EINVAL;
 
-	/* we don't allow misaligned data like bio_map_user() does.  If the
-	 * user is using sg, they're expected to know the alignment constraints
-	 * and respect them accordingly */
-	bio = bio_map_user_iov(q, NULL, iov, iov_count,
-				rq_data_dir(rq) == READ);
+	for (i = 0; i < iov_count; i++) {
+		unsigned long uaddr = (unsigned long)iov[i].iov_base;
+
+		if (uaddr & queue_dma_alignment(q)) {
+			unaligned = 1;
+			break;
+		}
+	}
+
+	if (unaligned || (q->dma_pad_mask & len))
+		bio = bio_copy_user_iov(q, iov, iov_count, read);
+	else
+		bio = bio_map_user_iov(q, NULL, iov, iov_count, read);
+
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-- 
1.5.4.2

