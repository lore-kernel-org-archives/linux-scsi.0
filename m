From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/2] fc_transport: The softirq_done function registration for BSG request
Date: Fri, 19 Jun 2009 16:26:53 -0700
Message-ID: <1245454014-1889-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1245454014-1889-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:57599 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751654AbZFSXcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2009 19:32:46 -0400
In-Reply-To: <1245454014-1889-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Registered the softirq_done function, since this is requried iby an request using block level
request timeout functionality. This function will be called by the block layer
as part of time out clean process to release the  BSG request.

Moved some of the BSG request completion activities to softirq_done routine to take
care of both normal and timout completions.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_transport_fc.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3f64d93..453d9e6 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3397,7 +3397,6 @@ fc_destroy_bsgjob(struct fc_bsg_job *job)
 	kfree(job);
 }
 
-
 /**
  * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
  *                  completed
@@ -3408,15 +3407,10 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 {
 	struct request *req = job->req;
 	struct request *rsp = req->next_rq;
-	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&job->job_lock, flags);
-	job->state_flags |= FC_RQST_STATE_DONE;
-	job->ref_cnt--;
-	spin_unlock_irqrestore(&job->job_lock, flags);
-
 	err = job->req->errors = job->reply->result;
+
 	if (err < 0)
 		/* we're only returning the result field in the reply */
 		job->req->sense_len = sizeof(uint32_t);
@@ -3433,13 +3427,27 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
 				      rsp->resid_len);
 	}
+	blk_complete_request(req);
+}
+
+/**
+ * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
+ * @req:        BSG request that holds the job to be destroyed
+ */
+static void fc_bsg_softirq_done(struct request *rq)
+{
+	struct fc_bsg_job *job = rq->special;
+	unsigned long flags;
 
-	blk_end_request_all(req, err);
+	spin_lock_irqsave(&job->job_lock, flags);
+	job->state_flags |= FC_RQST_STATE_DONE;
+	job->ref_cnt--;
+	spin_unlock_irqrestore(&job->job_lock, flags);
 
+	blk_end_request_all(rq, rq->errors);
 	fc_destroy_bsgjob(job);
 }
 
-
 /**
  * fc_bsg_job_timeout - handler for when a bsg request timesout
  * @req:	request that timed out
@@ -3471,19 +3479,10 @@ fc_bsg_job_timeout(struct request *req)
 				"abort failed with status %d\n", err);
 	}
 
-	if (!done) {
-		spin_lock_irqsave(&job->job_lock, flags);
-		job->ref_cnt--;
-		spin_unlock_irqrestore(&job->job_lock, flags);
-		fc_destroy_bsgjob(job);
-	}
-
 	/* the blk_end_sync_io() doesn't check the error */
 	return BLK_EH_HANDLED;
 }
 
-
-
 static int
 fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
 {
@@ -3879,6 +3878,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 
 	q->queuedata = shost;
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	blk_queue_softirq_done(q, fc_bsg_softirq_done);
 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
 	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
 
@@ -3924,6 +3924,7 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 
 	q->queuedata = rport;
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	blk_queue_softirq_done(q, fc_bsg_softirq_done);
 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
-- 
1.6.2.rc1.30.gd43c

