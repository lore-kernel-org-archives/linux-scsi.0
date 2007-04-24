From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 1/2] bsg: compile with bidi
Date: Tue, 24 Apr 2007 13:27:43 -0400
Message-ID: <20070424172743.GC21882@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:42085 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422778AbXDXR1o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2007 13:27:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

Fixes to common functions added with bsg so that they compile in
a kernel that has the bidi patches.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c        |    6 +++---
 block/scsi_ioctl.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index a333c93..f0753c0 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -368,7 +368,7 @@ static void bsg_add_command(struct bsg_device *bd, request_queue_t *q,
 	 * add bc command to busy queue and submit rq for io
 	 */
 	bc->rq = rq;
-	bc->bio = rq->bio;
+	bc->bio = rq_uni(rq)->bio;
 	bc->hdr.duration = jiffies;
 	spin_lock_irq(&bd->lock);
 	list_add_tail(&bc->list, &bd->busy_list);
@@ -446,7 +446,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	hdr->info = 0;
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->din_resid = rq->data_len;
+	hdr->din_resid = rq_uni(rq)->data_len;
 	hdr->response_len = 0;
 
 	if (rq->sense_len && hdr->response) {
@@ -915,7 +915,7 @@ bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		if (IS_ERR(rq))
 			return PTR_ERR(rq);
 
-		bio = rq->bio;
+		bio = rq_uni(rq)->bio;
 		blk_execute_rq(bd->queue, NULL, rq, 0);
 		blk_complete_sgv4_hdr_rq(rq, &hdr, bio);
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index cb29ea1..c1cfae9 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -244,7 +244,7 @@ EXPORT_SYMBOL_GPL(blk_fill_sghdr_rq);
  */
 int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
 {
-	blk_rq_unmap_user(rq->bio);
+	blk_rq_unmap_user(rq_uni(rq)->bio);
 	blk_put_request(rq);
 	return 0;
 }
@@ -266,7 +266,7 @@ int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->data_len;
+	hdr->resid = rq_uni(rq)->data_len;
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
@@ -278,7 +278,7 @@ int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 			ret = -EFAULT;
 	}
 
-	rq->bio = bio;
+	rq_uni(rq)->bio = bio;
 	r = blk_unmap_sghdr_rq(rq, hdr);
 	if (ret)
 		r = ret;
-- 
1.5.0.6

