From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] unexport sg v3 helper functions
Date: Sun, 22 Jul 2007 10:06:50 +0900
Message-ID: <20070722033008L.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:42630 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbXGVBHD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 21:07:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

blk_fill_sghdr_rq, blk_unmap_sghdr_rq, and blk_complete_sghdr_rq were
exported for bsg, however bsg was changed to support only sg v4.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/scsi_ioctl.c     |   13 +++++--------
 include/linux/blkdev.h |    5 -----
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 71bdf88..d359a71 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -214,8 +214,8 @@ int blk_verify_command(unsigned char *cm
 }
 EXPORT_SYMBOL_GPL(blk_verify_command);
 
-int blk_fill_sghdr_rq(request_queue_t *q, struct request *rq,
-		      struct sg_io_hdr *hdr, int has_write_perm)
+static int blk_fill_sghdr_rq(request_queue_t *q, struct request *rq,
+			     struct sg_io_hdr *hdr, int has_write_perm)
 {
 	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
 
@@ -238,22 +238,20 @@ int blk_fill_sghdr_rq(request_queue_t *q
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(blk_fill_sghdr_rq);
 
 /*
  * unmap a request that was previously mapped to this sg_io_hdr. handles
  * both sg and non-sg sg_io_hdr.
  */
-int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
+static int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
 {
 	blk_rq_unmap_user(rq->bio);
 	blk_put_request(rq);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(blk_unmap_sghdr_rq);
 
-int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
-			  struct bio *bio)
+static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
+				 struct bio *bio)
 {
 	int r, ret = 0;
 
@@ -287,7 +285,6 @@ int blk_complete_sghdr_rq(struct request
 
 	return r;
 }
-EXPORT_SYMBOL_GPL(blk_complete_sghdr_rq);
 
 static int sg_io(struct file *file, request_queue_t *q,
 		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f78965f..695e349 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -698,11 +698,6 @@ extern int blk_execute_rq(request_queue_
 			  struct request *, int);
 extern void blk_execute_rq_nowait(request_queue_t *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
-extern int blk_fill_sghdr_rq(request_queue_t *, struct request *,
-		      struct sg_io_hdr *, int);
-extern int blk_unmap_sghdr_rq(struct request *, struct sg_io_hdr *);
-extern int blk_complete_sghdr_rq(struct request *, struct sg_io_hdr *,
-			  struct bio *);
 extern int blk_verify_command(unsigned char *, int);
 
 static inline request_queue_t *bdev_get_queue(struct block_device *bdev)
-- 
1.4.3.2

