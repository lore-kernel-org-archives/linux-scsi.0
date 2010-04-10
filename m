From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] RFC: fc class: convert to common scsi bsg lib
Date: Sat, 10 Apr 2010 05:17:40 -0500
Message-ID: <1270894661-28402-4-git-send-email-michaelc@cs.wisc.edu>
References: <1270894661-28402-1-git-send-email-michaelc@cs.wisc.edu>
 <1270894661-28402-2-git-send-email-michaelc@cs.wisc.edu>
 <1270894661-28402-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0DJKRw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2010 06:17:52 -0400
In-Reply-To: <1270894661-28402-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This converts the fc class to the common scsi bsg lib.

Patch is only compile tested.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |  486 ++++++++------------------------------
 include/scsi/scsi_transport_fc.h |   43 +---
 2 files changed, 104 insertions(+), 425 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 55fe730..1ca1ecc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -38,6 +38,7 @@
 #include <net/netlink.h>
 #include <scsi/scsi_netlink_fc.h>
 #include <scsi/scsi_bsg_fc.h>
+#include <scsi/scsi_bsg.h>
 #include "scsi_priv.h"
 #include "scsi_transport_fc_internal.h"
 
@@ -48,8 +49,7 @@ static int fc_vport_setup(struct Scsi_Host *shost, int channel,
 	struct fc_vport **vport);
 static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
 static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
-static void fc_bsg_remove(struct request_queue *);
-static void fc_bsg_goose_queue(struct fc_rport *);
+static int fc_bsg_job_timeout(struct request *req);
 
 /*
  * Redefine so that we can have same named attributes in the
@@ -430,7 +430,7 @@ static int fc_host_remove(struct transport_container *tc, struct device *dev,
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 
-	fc_bsg_remove(fc_host->rqst_q);
+	scsi_bsg_remove(fc_host->rqst_q);
 	return 0;
 }
 
@@ -2121,6 +2121,8 @@ fc_attach_transport(struct fc_function_template *ft)
 
 	i->t.user_scan = fc_user_scan;
 
+	i->t.eh_bsg_timed_out = fc_bsg_job_timeout;
+
 	/* target-mode drivers' functions */
 	i->t.tsk_mgmt_response = fc_tsk_mgmt_response;
 	i->t.it_nexus_response = fc_it_nexus_response;
@@ -2481,7 +2483,7 @@ fc_rport_final_delete(struct work_struct *work)
 	if (do_callback)
 		i->f->dev_loss_tmo_callbk(rport);
 
-	fc_bsg_remove(rport->rqst_q);
+	scsi_bsg_remove(rport->rqst_q);
 
 	transport_remove_device(dev);
 	device_del(dev);
@@ -2737,8 +2739,8 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 					spin_unlock_irqrestore(shost->host_lock,
 							flags);
 
-				fc_bsg_goose_queue(rport);
-
+				scsi_bsg_goose_queue(&rport->dev,
+						     rport->rqst_q);
 				return rport;
 			}
 		}
@@ -3449,236 +3451,41 @@ fc_vport_sched_delete(struct work_struct *work)
  * BSG support
  */
 
-
-/**
- * fc_destroy_bsgjob - routine to teardown/delete a fc bsg job
- * @job:	fc_bsg_job that is to be torn down
- */
-static void
-fc_destroy_bsgjob(struct fc_bsg_job *job)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&job->job_lock, flags);
-	if (job->ref_cnt) {
-		spin_unlock_irqrestore(&job->job_lock, flags);
-		return;
-	}
-	spin_unlock_irqrestore(&job->job_lock, flags);
-
-	put_device(job->dev);	/* release reference for the request */
-
-	kfree(job->request_payload.sg_list);
-	kfree(job->reply_payload.sg_list);
-	kfree(job);
-}
-
-/**
- * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
- *                  completed
- * @job:	fc_bsg_job that is complete
- */
-static void
-fc_bsg_jobdone(struct fc_bsg_job *job)
+static void fc_bsg_fail_job(struct scsi_bsg_job *job, int ret)
 {
-	struct request *req = job->req;
-	struct request *rsp = req->next_rq;
-	int err;
-
-	err = job->req->errors = job->reply->result;
-
-	if (err < 0)
-		/* we're only returning the result field in the reply */
-		job->req->sense_len = sizeof(uint32_t);
-	else
-		job->req->sense_len = job->reply_len;
-
-	/* we assume all request payload was transferred, residual == 0 */
-	req->resid_len = 0;
-
-	if (rsp) {
-		WARN_ON(job->reply->reply_payload_rcv_len > rsp->resid_len);
-
-		/* set reply (bidi) residual */
-		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
-				      rsp->resid_len);
-	}
-	blk_complete_request(req);
-}
-
-/**
- * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
- * @rq:        BSG request that holds the job to be destroyed
- */
-static void fc_bsg_softirq_done(struct request *rq)
-{
-	struct fc_bsg_job *job = rq->special;
-	unsigned long flags;
-
-	spin_lock_irqsave(&job->job_lock, flags);
-	job->state_flags |= FC_RQST_STATE_DONE;
-	job->ref_cnt--;
-	spin_unlock_irqrestore(&job->job_lock, flags);
-
-	blk_end_request_all(rq, rq->errors);
-	fc_destroy_bsgjob(job);
-}
-
-/**
- * fc_bsg_job_timeout - handler for when a bsg request timesout
- * @req:	request that timed out
- */
-static enum blk_eh_timer_return
-fc_bsg_job_timeout(struct request *req)
-{
-	struct fc_bsg_job *job = (void *) req->special;
-	struct Scsi_Host *shost = job->shost;
-	struct fc_internal *i = to_fc_internal(shost->transportt);
-	unsigned long flags;
-	int err = 0, done = 0;
-
-	if (job->rport && job->rport->port_state == FC_PORTSTATE_BLOCKED)
-		return BLK_EH_RESET_TIMER;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 
-	spin_lock_irqsave(&job->job_lock, flags);
-	if (job->state_flags & FC_RQST_STATE_DONE)
-		done = 1;
-	else
-		job->ref_cnt++;
-	spin_unlock_irqrestore(&job->job_lock, flags);
-
-	if (!done && i->f->bsg_timeout) {
-		/* call LLDD to abort the i/o as it has timed out */
-		err = i->f->bsg_timeout(job);
-		if (err == -EAGAIN) {
-			job->ref_cnt--;
-			return BLK_EH_RESET_TIMER;
-		} else if (err)
-			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
-				"abort failed with status %d\n", err);
-	}
-
-	/* the blk_end_sync_io() doesn't check the error */
-	if (done)
-		return BLK_EH_NOT_HANDLED;
-	else
-		return BLK_EH_HANDLED;
-}
-
-static int
-fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
-{
-	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
-
-	BUG_ON(!req->nr_phys_segments);
-
-	buf->sg_list = kzalloc(sz, GFP_KERNEL);
-	if (!buf->sg_list)
-		return -ENOMEM;
-	sg_init_table(buf->sg_list, req->nr_phys_segments);
-	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
-	buf->payload_len = blk_rq_bytes(req);
-	return 0;
-}
-
-
-/**
- * fc_req_to_bsgjob - Allocate/create the fc_bsg_job structure for the
- *                   bsg request
- * @shost:	SCSI Host corresponding to the bsg object
- * @rport:	(optional) FC Remote Port corresponding to the bsg object
- * @req:	BSG request that needs a job structure
- */
-static int
-fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
-	struct request *req)
-{
-	struct fc_internal *i = to_fc_internal(shost->transportt);
-	struct request *rsp = req->next_rq;
-	struct fc_bsg_job *job;
-	int ret;
-
-	BUG_ON(req->special);
-
-	job = kzalloc(sizeof(struct fc_bsg_job) + i->f->dd_bsg_size,
-			GFP_KERNEL);
-	if (!job)
-		return -ENOMEM;
-
-	/*
-	 * Note: this is a bit silly.
-	 * The request gets formatted as a SGIO v4 ioctl request, which
-	 * then gets reformatted as a blk request, which then gets
-	 * reformatted as a fc bsg request. And on completion, we have
-	 * to wrap return results such that SGIO v4 thinks it was a scsi
-	 * status.  I hope this was all worth it.
-	 */
-
-	req->special = job;
-	job->shost = shost;
-	job->rport = rport;
-	job->req = req;
-	if (i->f->dd_bsg_size)
-		job->dd_data = (void *)&job[1];
-	spin_lock_init(&job->job_lock);
-	job->request = (struct fc_bsg_request *)req->cmd;
-	job->request_len = req->cmd_len;
-	job->reply = req->sense;
-	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
-						 * allocated */
-	if (req->bio) {
-		ret = fc_bsg_map_buffer(&job->request_payload, req);
-		if (ret)
-			goto failjob_rls_job;
-	}
-	if (rsp && rsp->bio) {
-		ret = fc_bsg_map_buffer(&job->reply_payload, rsp);
-		if (ret)
-			goto failjob_rls_rqst_payload;
-	}
-	job->job_done = fc_bsg_jobdone;
-	if (rport)
-		job->dev = &rport->dev;
-	else
-		job->dev = &shost->shost_gendev;
-	get_device(job->dev);		/* take a reference for the request */
-
-	job->ref_cnt = 1;
-
-	return 0;
-
-
-failjob_rls_rqst_payload:
-	kfree(job->request_payload.sg_list);
-failjob_rls_job:
-	kfree(job);
-	return -ENOMEM;
+	BUG_ON(job->reply_len < sizeof(uint32_t));
+	bsg_reply->reply_payload_rcv_len = 0;
+	/* return the errno failure code as the only status */
+	bsg_reply->result = ret;
+	job->reply_len = sizeof(uint32_t);
+	scsi_bsg_job_done(job, ret, 0);
 }
 
-
-enum fc_dispatch_result {
-	FC_DISPATCH_BREAK,	/* on return, q is locked, break from q loop */
-	FC_DISPATCH_LOCKED,	/* on return, q is locked, continue on */
-	FC_DISPATCH_UNLOCKED,	/* on return, q is unlocked, continue on */
-};
-
-
 /**
  * fc_bsg_host_dispatch - process fc host bsg requests and dispatch to LLDD
  * @q:		fc host request queue
  * @shost:	scsi host rport attached to
  * @job:	bsg job to be processed
  */
-static enum fc_dispatch_result
+static enum scsi_dispatch_result
 fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
-			 struct fc_bsg_job *job)
+			 struct scsi_bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	struct fc_bsg_request *bsg_req = job->request;
 	int ret;
 
+	/* check if we have the msgcode value at least */
+	if (job->request_len < sizeof(uint32_t)) {
+		ret = -ENOMSG;
+		goto fail_host_msg;
+	}
+
 	/* Validate the host command */
-	switch (job->request->msgcode) {
+	switch (bsg_req->msgcode) {
 	case FC_BSG_HST_ADD_RPORT:
 		cmdlen += sizeof(struct fc_bsg_host_add_rport);
 		break;
@@ -3710,7 +3517,7 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
 	case FC_BSG_HST_VENDOR:
 		cmdlen += sizeof(struct fc_bsg_host_vendor);
 		if ((shost->hostt->vendor_id == 0L) ||
-		    (job->request->rqst_data.h_vendor.vendor_id !=
+		    (bsg_req->rqst_data.h_vendor.vendor_id !=
 			shost->hostt->vendor_id)) {
 			ret = -ESRCH;
 			goto fail_host_msg;
@@ -3730,65 +3537,36 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
 
 	ret = i->f->bsg_request(job);
 	if (!ret)
-		return FC_DISPATCH_UNLOCKED;
+		return SCSI_DISPATCH_UNLOCKED;
 
 fail_host_msg:
-	/* return the errno failure code as the only status */
-	BUG_ON(job->reply_len < sizeof(uint32_t));
-	job->reply->reply_payload_rcv_len = 0;
-	job->reply->result = ret;
-	job->reply_len = sizeof(uint32_t);
-	fc_bsg_jobdone(job);
-	return FC_DISPATCH_UNLOCKED;
-}
-
-
-/*
- * fc_bsg_goose_queue - restart rport queue in case it was stopped
- * @rport:	rport to be restarted
- */
-static void
-fc_bsg_goose_queue(struct fc_rport *rport)
-{
-	int flagset;
-	unsigned long flags;
-
-	if (!rport->rqst_q)
-		return;
-
-	get_device(&rport->dev);
-
-	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
-	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
-		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
-	if (flagset)
-		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
-	__blk_run_queue(rport->rqst_q);
-	if (flagset)
-		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
-	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
-
-	put_device(&rport->dev);
+	fc_bsg_fail_job(job, ret);
+	return SCSI_DISPATCH_UNLOCKED;
 }
 
-
 /**
  * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
  * @q:		rport request queue
  * @shost:	scsi host rport attached to
- * @rport:	rport request destined to
  * @job:	bsg job to be processed
  */
-static enum fc_dispatch_result
+static enum scsi_dispatch_result
 fc_bsg_rport_dispatch(struct request_queue *q, struct Scsi_Host *shost,
-			 struct fc_rport *rport, struct fc_bsg_job *job)
+		      struct scsi_bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	struct fc_bsg_request *bsg_req = job->request;
 	int ret;
 
+	/* check if we have the msgcode value at least */
+	if (job->request_len < sizeof(uint32_t)) {
+		ret = -ENOMSG;
+		goto fail_rport_msg;
+	}
+
 	/* Validate the rport command */
-	switch (job->request->msgcode) {
+	switch (bsg_req->msgcode) {
 	case FC_BSG_RPT_ELS:
 		cmdlen += sizeof(struct fc_bsg_rport_els);
 		goto check_bidi;
@@ -3816,98 +3594,75 @@ check_bidi:
 
 	ret = i->f->bsg_request(job);
 	if (!ret)
-		return FC_DISPATCH_UNLOCKED;
+		return SCSI_DISPATCH_UNLOCKED;
 
 fail_rport_msg:
-	/* return the errno failure code as the only status */
-	BUG_ON(job->reply_len < sizeof(uint32_t));
-	job->reply->reply_payload_rcv_len = 0;
-	job->reply->result = ret;
-	job->reply_len = sizeof(uint32_t);
-	fc_bsg_jobdone(job);
-	return FC_DISPATCH_UNLOCKED;
+	fc_bsg_fail_job(job, ret);
+	return SCSI_DISPATCH_UNLOCKED;
 }
 
-
 /**
- * fc_bsg_request_handler - generic handler for bsg requests
- * @q:		request queue to manage
- * @shost:	Scsi_Host related to the bsg object
- * @rport:	FC remote port related to the bsg object (optional)
- * @dev:	device structure for bsg object
+ * fc_bsg_job_timeout - handler for when a bsg request timesout
+ * @req:	request that timed out
  */
-static void
-fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
-		       struct fc_rport *rport, struct device *dev)
+static int fc_bsg_job_timeout(struct request *req)
 {
-	struct request *req;
-	struct fc_bsg_job *job;
-	enum fc_dispatch_result ret;
-
-	if (!get_device(dev))
-		return;
-
-	while (!blk_queue_plugged(q)) {
-		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED) &&
-		    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
-			break;
-
-		req = blk_fetch_request(q);
-		if (!req)
-			break;
-
-		if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
-			req->errors = -ENXIO;
-			spin_unlock_irq(q->queue_lock);
-			blk_end_request_all(req, -ENXIO);
-			spin_lock_irq(q->queue_lock);
-			continue;
-		}
-
-		spin_unlock_irq(q->queue_lock);
+	struct scsi_bsg_job *job = (void *) req->special;
+	struct fc_bsg_job *fc_job = job->transport_data;
+	struct Scsi_Host *shost = job->shost;
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	int err = 0;
 
-		ret = fc_req_to_bsgjob(shost, rport, req);
-		if (ret) {
-			req->errors = ret;
-			blk_end_request_all(req, ret);
-			spin_lock_irq(q->queue_lock);
-			continue;
-		}
+	if (fc_job->rport && fc_job->rport->port_state == FC_PORTSTATE_BLOCKED)
+		return -EAGAIN;
 
-		job = req->special;
+	if (i->f->bsg_timeout)
+		err = i->f->bsg_timeout(job);
+	return err;
+}
 
-		/* check if we have the msgcode value at least */
-		if (job->request_len < sizeof(uint32_t)) {
-			BUG_ON(job->reply_len < sizeof(uint32_t));
-			job->reply->reply_payload_rcv_len = 0;
-			job->reply->result = -ENOMSG;
-			job->reply_len = sizeof(uint32_t);
-			fc_bsg_jobdone(job);
-			spin_lock_irq(q->queue_lock);
-			continue;
-		}
+/**
+ * fc_req_to_bsgjob - Allocate/create the fc_bsg_job structure for the
+ *                   bsg request
+ * @shost:	SCSI Host corresponding to the bsg object
+ * @dev:	device for bsg object
+ * @req:	BSG request that needs a job structure
+ */
+static int
+fc_req_to_bsgjob(struct Scsi_Host *shost, struct device *dev,
+		 struct request *req)
+{
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct fc_bsg_job *fc_job;
+	struct scsi_bsg_job *job;
+	int rc;
+
+	rc = scsi_bsg_req_to_job(shost, dev, req, sizeof(struct fc_bsg_job),
+				 i->f->dd_bsg_size);
+	if (rc)
+		return rc;
+	job = req->special;
+	fc_job = job->transport_data;
+
+	if (dev != &shost->shost_gendev)
+		fc_job->rport = dev_to_rport(dev);
+	return 0;
+}
 
-		/* the dispatch routines will unlock the queue_lock */
-		if (rport)
-			ret = fc_bsg_rport_dispatch(q, shost, rport, job);
-		else
-			ret = fc_bsg_host_dispatch(q, shost, job);
+static int fc_bsg_rport_prep(struct request_queue *q, struct request *req)
+{
+	struct fc_rport *rport = q->queuedata;
 
-		/* did dispatcher hit state that can't process any more */
-		if (ret == FC_DISPATCH_BREAK)
-			break;
+	if (rport->port_state == FC_PORTSTATE_BLOCKED &&
+	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
+		return BLKPREP_DEFER;
 
-		/* did dispatcher had released the lock */
-		if (ret == FC_DISPATCH_UNLOCKED)
-			spin_lock_irq(q->queue_lock);
-	}
+	if (rport->port_state != FC_PORTSTATE_ONLINE)
+		return BLKPREP_KILL;
 
-	spin_unlock_irq(q->queue_lock);
-	put_device(dev);
-	spin_lock_irq(q->queue_lock);
+	return BLKPREP_OK;
 }
 
-
 /**
  * fc_bsg_host_handler - handler for bsg requests for a fc host
  * @q:		fc host request queue
@@ -3917,7 +3672,8 @@ fc_bsg_host_handler(struct request_queue *q)
 {
 	struct Scsi_Host *shost = q->queuedata;
 
-	fc_bsg_request_handler(q, shost, NULL, &shost->shost_gendev);
+	scsi_bsg_request_handler(q, shost, &shost->shost_gendev,
+				 fc_req_to_bsgjob, fc_bsg_host_dispatch);
 }
 
 
@@ -3931,7 +3687,8 @@ fc_bsg_rport_handler(struct request_queue *q)
 	struct fc_rport *rport = q->queuedata;
 	struct Scsi_Host *shost = rport_to_shost(rport);
 
-	fc_bsg_request_handler(q, shost, rport, &rport->dev);
+	scsi_bsg_request_handler(q, shost, &rport->dev,
+				 fc_req_to_bsgjob, fc_bsg_rport_dispatch);
 }
 
 
@@ -3946,7 +3703,6 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	struct device *dev = &shost->shost_gendev;
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct request_queue *q;
-	int err;
 	char bsg_name[20];
 
 	fc_host->rqst_q = NULL;
@@ -3957,7 +3713,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	snprintf(bsg_name, sizeof(bsg_name),
 		 "fc_host%d", shost->host_no);
 
-	q = __scsi_alloc_queue(shost, fc_bsg_host_handler);
+	q = scsi_bsg_add(shost, dev, bsg_name, fc_bsg_host_handler);
 	if (!q) {
 		printk(KERN_ERR "fc_host%d: bsg interface failed to "
 				"initialize - no request queue\n",
@@ -3966,20 +3722,6 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	}
 
 	q->queuedata = shost;
-	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
-	blk_queue_softirq_done(q, fc_bsg_softirq_done);
-	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
-	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
-
-	err = bsg_register_queue(q, dev, bsg_name, NULL);
-	if (err) {
-		printk(KERN_ERR "fc_host%d: bsg interface failed to "
-				"initialize - register queue\n",
-				shost->host_no);
-		blk_cleanup_queue(q);
-		return err;
-	}
-
 	fc_host->rqst_q = q;
 	return 0;
 }
@@ -3996,54 +3738,26 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 	struct device *dev = &rport->dev;
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct request_queue *q;
-	int err;
 
 	rport->rqst_q = NULL;
 
 	if (!i->f->bsg_request)
 		return -ENOTSUPP;
 
-	q = __scsi_alloc_queue(shost, fc_bsg_rport_handler);
+	q = scsi_bsg_add(shost, dev, NULL, fc_bsg_rport_handler);
 	if (!q) {
 		printk(KERN_ERR "%s: bsg interface failed to "
 				"initialize - no request queue\n",
 				 dev->kobj.name);
 		return -ENOMEM;
 	}
-
 	q->queuedata = rport;
-	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
-	blk_queue_softirq_done(q, fc_bsg_softirq_done);
-	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
-	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
-
-	err = bsg_register_queue(q, dev, NULL, NULL);
-	if (err) {
-		printk(KERN_ERR "%s: bsg interface failed to "
-				"initialize - register queue\n",
-				 dev->kobj.name);
-		blk_cleanup_queue(q);
-		return err;
-	}
-
 	rport->rqst_q = q;
+	blk_queue_prep_rq(q, fc_bsg_rport_prep);
 	return 0;
 }
 
 
-/**
- * fc_bsg_remove - Deletes the bsg hooks on fchosts/rports
- * @q:	the request_queue that is to be torn down.
- */
-static void
-fc_bsg_remove(struct request_queue *q)
-{
-	if (q) {
-		bsg_unregister_queue(q);
-		blk_cleanup_queue(q);
-	}
-}
-
 
 /* Original Author:  Martin Hicks */
 MODULE_AUTHOR("James Smart");
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 8e86a94..33d56fe 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -32,6 +32,7 @@
 #include <scsi/scsi_netlink.h>
 
 struct scsi_transport_template;
+struct scsi_bsg_job;
 
 /*
  * FC Port definitions - Following FC HBAAPI guidelines
@@ -582,47 +583,11 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
 
 
-struct fc_bsg_buffer {
-	unsigned int payload_len;
-	int sg_cnt;
-	struct scatterlist *sg_list;
-};
-
-/* Values for fc_bsg_job->state_flags (bitflags) */
-#define FC_RQST_STATE_INPROGRESS	0
-#define FC_RQST_STATE_DONE		1
-
+/* TODO: we can kill this if we can get LLDs using dev_to_rport(job->dev) */
 struct fc_bsg_job {
-	struct Scsi_Host *shost;
 	struct fc_rport *rport;
-	struct device *dev;
-	struct request *req;
-	spinlock_t job_lock;
-	unsigned int state_flags;
-	unsigned int ref_cnt;
-	void (*job_done)(struct fc_bsg_job *);
-
-	struct fc_bsg_request *request;
-	struct fc_bsg_reply *reply;
-	unsigned int request_len;
-	unsigned int reply_len;
-	/*
-	 * On entry : reply_len indicates the buffer size allocated for
-	 * the reply.
-	 *
-	 * Upon completion : the message handler must set reply_len
-	 *  to indicates the size of the reply to be returned to the
-	 *  caller.
-	 */
-
-	/* DMA payloads for the request/response */
-	struct fc_bsg_buffer request_payload;
-	struct fc_bsg_buffer reply_payload;
-
-	void *dd_data;			/* Used for driver-specific storage */
 };
 
-
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
 	void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
@@ -659,8 +624,8 @@ struct fc_function_template {
 	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);
 
 	/* bsg support */
-	int	(*bsg_request)(struct fc_bsg_job *);
-	int	(*bsg_timeout)(struct fc_bsg_job *);
+	int	(*bsg_request)(struct scsi_bsg_job *);
+	int	(*bsg_timeout)(struct scsi_bsg_job *);
 
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
-- 
1.6.6.1

