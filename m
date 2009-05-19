From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for block/for-2.6.31
 tree
Date: Tue, 19 May 2009 15:54:59 +0300
Message-ID: <4A12AC23.30808@panasas.com>
References: <4A12797B.2060901@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:9546 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849AbZESM4Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2009 08:56:25 -0400
In-Reply-To: <4A12797B.2060901@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-sc>
Cc: FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>


This patch should be squashed into
    [SCSI] FC Pass Thru support

If it needs to compile after Tejun's block-layer revamps
(all of them)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_transport_fc.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4df8c3c..809b75c 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3409,7 +3409,6 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 	struct request *req = job->req;
 	struct request *rsp = req->next_rq;
 	unsigned long flags;
-	unsigned rsp_len = 0, req_len = blk_rq_bytes(req);
 	int err;
 
 	spin_lock_irqsave(&job->job_lock, flags);
@@ -3425,16 +3424,17 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 		job->req->sense_len = job->reply_len;
 
 	/* we assume all request payload was transferred, residual == 0 */
-	req->data_len = 0;
+	req->resid_len = 0;
 
 	if (rsp) {
-		rsp_len = blk_rq_bytes(rsp);
-		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
+		WARN_ON(job->reply->reply_payload_rcv_len > rsp->resid_len);
+
 		/* set reply (bidi) residual */
-		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
+		rsp->resid_len -= min(job->reply->reply_payload_rcv_len, 
+				      rsp->resid_len);
 	}
 
-	blk_end_bidi_request(req, err, req_len, rsp_len);
+	blk_end_request_all(req, err);
 
 	fc_destroy_bsgjob(job);
 }
@@ -3496,7 +3496,7 @@ fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
 		return -ENOMEM;
 	sg_init_table(buf->sg_list, req->nr_phys_segments);
 	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
-	buf->payload_len = req->data_len;
+	buf->payload_len = blk_rq_bytes(req);
 	return 0;
 }
 
@@ -3762,14 +3762,12 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
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


