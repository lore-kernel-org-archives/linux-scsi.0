From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] block: cleanup error handling in sg_io
Date: Sun, 20 Jul 2014 12:23:23 +0200
Message-ID: <1405851804-29096-2-git-send-email-hch@lst.de>
References: <1405851804-29096-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaGTKVM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jul 2014 06:21:12 -0400
In-Reply-To: <1405851804-29096-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Make sure we always clean up through the out label and just have
a single place to put the request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 14695c6..c4e6633 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -272,7 +272,6 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	r = blk_rq_unmap_user(bio);
 	if (!ret)
 		ret = r;
-	blk_put_request(rq);
 
 	return ret;
 }
@@ -312,10 +311,9 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		return -ENOMEM;
 	blk_rq_set_block_pc(rq);
 
-	if (blk_fill_sghdr_rq(q, rq, hdr, mode)) {
-		blk_put_request(rq);
-		return -EFAULT;
-	}
+	ret = -EFAULT;
+	if (blk_fill_sghdr_rq(q, rq, hdr, mode))
+		goto out;
 
 	if (hdr->iovec_count) {
 		size_t iov_data_len;
@@ -366,7 +364,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 
 	hdr->duration = jiffies_to_msecs(jiffies - start_time);
 
-	return blk_complete_sghdr_rq(rq, hdr, bio);
+	ret = blk_complete_sghdr_rq(rq, hdr, bio);
 out:
 	blk_put_request(rq);
 	return ret;
-- 
1.9.1

