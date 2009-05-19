From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] [SQUASHME] "FC Pass Thru support" fixed for block/for-2.6.31
 tree
Date: Tue, 19 May 2009 12:18:51 +0300
Message-ID: <4A12797B.2060901@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:51177 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZESJS5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2009 05:18:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-sc>
Cc: FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>


Hi Stephen below is the correct patch for the scsi-misc build
failure when merged after block/for-next branch.
(Note that current linux-next fix will not work)

Tejun please review?

James, I still think the easiest is to squash this into
The FC Pass Thru support patch and put it in a post-merge
tree.
---
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] [SQUASHME] "FC Pass Thru support" fixed for block/for-2.6.31 tree

This patch should be squashed into:
    [SCSI] FC Pass Thru support

If it needs to compile after Tejun's block-layer revamps

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_transport_fc.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4df8c3c..41c90fe 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3409,7 +3409,6 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 	struct request *req = job->req;
 	struct request *rsp = req->next_rq;
 	unsigned long flags;
-	unsigned rsp_len = 0, req_len = blk_rq_bytes(req);
 	int err;
 
 	spin_lock_irqsave(&job->job_lock, flags);
@@ -3425,16 +3424,15 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 		job->req->sense_len = job->reply_len;
 
 	/* we assume all request payload was transferred, residual == 0 */
-	req->data_len = 0;
+	req->resid_len = 0;
 
 	if (rsp) {
-		rsp_len = blk_rq_bytes(rsp);
-		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
 		/* set reply (bidi) residual */
-		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
+		rsp->resid_len = blk_rq_bytes(rsp) -
+					job->reply->reply_payload_rcv_len;
 	}
 
-	blk_end_bidi_request(req, err, req_len, rsp_len);
+	blk_end_request_all(req, err);
 
 	fc_destroy_bsgjob(job);
 }
@@ -3496,7 +3494,7 @@ fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
 		return -ENOMEM;
 	sg_init_table(buf->sg_list, req->nr_phys_segments);
 	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
-	buf->payload_len = req->data_len;
+	buf->payload_len = blk_rq_bytes(req);
 	return 0;
 }
 
@@ -3762,14 +3760,12 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
 		return;
 
 	while (!blk_queue_plugged(q)) {
-		req = elv_next_request(q);
-		if (!req)
-			break;
-
 		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED))
 				break;
 
-		blkdev_dequeue_request(req);
+		req = blk_fetch_request(q);
+		if (!req)
+			break;
 
 		if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
 			req->errors = -ENXIO;
-- 
1.6.2.1


