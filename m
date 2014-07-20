From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] block: support > 16 byte CDBs for SG_IO
Date: Sun, 20 Jul 2014 12:23:24 +0200
Message-ID: <1405851804-29096-3-git-send-email-hch@lst.de>
References: <1405851804-29096-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50465 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaGTKVN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jul 2014 06:21:13 -0400
In-Reply-To: <1405851804-29096-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index c4e6633..a804f3e 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -288,8 +288,6 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 
 	if (hdr->interface_id != 'S')
 		return -EINVAL;
-	if (hdr->cmd_len > BLK_MAX_CDB)
-		return -EINVAL;
 
 	if (hdr->dxfer_len > (queue_max_hw_sectors(q) << 9))
 		return -EIO;
@@ -306,14 +304,21 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 			break;
 		}
 
+	ret = -ENOMEM;
 	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
 	if (!rq)
-		return -ENOMEM;
+		goto out;
 	blk_rq_set_block_pc(rq);
 
+	if (hdr->cmd_len > BLK_MAX_CDB) {
+		rq->cmd = kzalloc(hdr->cmd_len, GFP_KERNEL);
+		if (!rq->cmd)
+			goto out_put_request;
+	}
+
 	ret = -EFAULT;
 	if (blk_fill_sghdr_rq(q, rq, hdr, mode))
-		goto out;
+		goto out_free_cdb;
 
 	if (hdr->iovec_count) {
 		size_t iov_data_len;
@@ -323,7 +328,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 					    0, NULL, &iov);
 		if (ret < 0) {
 			kfree(iov);
-			goto out;
+			goto out_free_cdb;
 		}
 
 		iov_data_len = ret;
@@ -346,7 +351,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 				      GFP_KERNEL);
 
 	if (ret)
-		goto out;
+		goto out_free_cdb;
 
 	bio = rq->bio;
 	memset(sense, 0, sizeof(sense));
@@ -365,8 +370,13 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	hdr->duration = jiffies_to_msecs(jiffies - start_time);
 
 	ret = blk_complete_sghdr_rq(rq, hdr, bio);
-out:
+
+out_free_cdb:
+	if (rq->cmd != rq->__cmd)
+		kfree(rq->cmd);
+out_put_request:
 	blk_put_request(rq);
+out:
 	return ret;
 }
 
-- 
1.9.1

