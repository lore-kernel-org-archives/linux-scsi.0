From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/6] block: changes for blk_rq_unmap_user new API
Date: Wed, 20 Dec 2006 14:42:58 +0900
Message-ID: <20061220144258J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:56882 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbWLTFm7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2006 00:42:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net

This converts block/scsi_ioctl.c use blk_rq_unmap_user new
API. blk_unmap_sghdr_rq is too simple and it might be better to remove
it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/scsi_ioctl.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 28e545d..5e69ef6 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -243,17 +243,7 @@ EXPORT_SYMBOL_GPL(blk_fill_sghdr_rq);
  */
 int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
 {
-	struct bio *bio = rq->bio;
-
-	/*
-	 * also releases request
-	 */
-	if (!hdr->iovec_count)
-		return blk_rq_unmap_user(bio, hdr->dxfer_len);
-
-	rq_for_each_bio(bio, rq)
-		bio_unmap_user(bio);
-
+	blk_rq_unmap_user(rq->bio);
 	blk_put_request(rq);
 	return 0;
 }
@@ -333,7 +323,6 @@ static int sg_io(struct file *file, requ
 		has_write_perm = file->f_mode & FMODE_WRITE;
 
 	if (blk_fill_sghdr_rq(q, rq, hdr, has_write_perm)) {
-		blk_rq_unmap_user(bio, hdr->dxfer_len);
 		blk_put_request(rq);
 		return -EFAULT;
 	}
-- 
1.4.3.2

