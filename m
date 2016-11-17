From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v4 14/15] scsi: fc: move FC transport's bsg code to bsg-lib
Date: Thu, 17 Nov 2016 10:31:24 +0100
Message-ID: <ff0ba8c04b6b9457696eae54f91461f33a15da53.1479374720.git.jthumshirn@suse.de>
References: <cover.1479374719.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55729 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932347AbcKQJb6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 04:31:58 -0500
In-Reply-To: <cover.1479374719.git.jthumshirn@suse.de>
In-Reply-To: <cover.1479374719.git.jthumshirn@suse.de>
References: <cover.1479374719.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Now that all conversions are done, move the FibreChannel bsg code over to the
bsg library.

This patch is derived from work done by Mike Christie in 2011 [1] but only the
iscsi parts got merged back then.

[1] http://marc.info/?l=linux-scsi&m=131149780921009&w=2

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_transport_fc.c | 285 ++++++---------------------------------
 1 file changed, 43 insertions(+), 242 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index fb45d3a..a6160dc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3591,109 +3591,12 @@ struct fc_vport *
 		return BLK_EH_HANDLED;
 }
 
-static int
-fc_bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
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
-	struct bsg_job *job;
-	int ret;
-
-	BUG_ON(req->special);
-
-	job = kzalloc(sizeof(struct bsg_job) + i->f->dd_bsg_size,
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
-	job->req = req;
-	if (i->f->dd_bsg_size)
-		job->dd_data = (void *)&job[1];
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
-	if (rport)
-		job->dev = &rport->dev;
-	else
-		job->dev = &shost->shost_gendev;
-	get_device(job->dev);		/* take a reference for the request */
-
-	kref_init(&job->kref);
-
-	return 0;
-
-
-failjob_rls_rqst_payload:
-	kfree(job->request_payload.sg_list);
-failjob_rls_job:
-	kfree(job);
-	return -ENOMEM;
-}
-
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
- * @q:		fc host request queue
  * @shost:	scsi host rport attached to
  * @job:	bsg job to be processed
  */
-static enum fc_dispatch_result
-fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
-			 struct bsg_job *job)
+static int fc_bsg_host_dispatch(struct Scsi_Host *shost, struct bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct fc_bsg_request *bsg_request = job->request;
@@ -3754,7 +3657,7 @@ enum fc_dispatch_result {
 
 	ret = i->f->bsg_request(job);
 	if (!ret)
-		return FC_DISPATCH_UNLOCKED;
+		return 0;
 
 fail_host_msg:
 	/* return the errno failure code as the only status */
@@ -3764,7 +3667,7 @@ enum fc_dispatch_result {
 	job->reply_len = sizeof(uint32_t);
 	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
-	return FC_DISPATCH_UNLOCKED;
+	return 0;
 }
 
 
@@ -3788,14 +3691,10 @@ enum fc_dispatch_result {
 
 /**
  * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
- * @q:		rport request queue
  * @shost:	scsi host rport attached to
- * @rport:	rport request destined to
  * @job:	bsg job to be processed
  */
-static enum fc_dispatch_result
-fc_bsg_rport_dispatch(struct request_queue *q, struct Scsi_Host *shost,
-			 struct fc_rport *rport, struct bsg_job *job)
+static int fc_bsg_rport_dispatch(struct Scsi_Host *shost, struct bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct fc_bsg_request *bsg_request = job->request;
@@ -3832,7 +3731,7 @@ enum fc_dispatch_result {
 
 	ret = i->f->bsg_request(job);
 	if (!ret)
-		return FC_DISPATCH_UNLOCKED;
+		return 0;
 
 fail_rport_msg:
 	/* return the errno failure code as the only status */
@@ -3842,119 +3741,19 @@ enum fc_dispatch_result {
 	job->reply_len = sizeof(uint32_t);
 	bsg_job_done(job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
-	return FC_DISPATCH_UNLOCKED;
-}
-
-
-/**
- * fc_bsg_request_handler - generic handler for bsg requests
- * @q:		request queue to manage
- * @shost:	Scsi_Host related to the bsg object
- * @rport:	FC remote port related to the bsg object (optional)
- * @dev:	device structure for bsg object
- */
-static void
-fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
-		       struct fc_rport *rport, struct device *dev)
-{
-	struct request *req;
-	struct bsg_job *job;
-	enum fc_dispatch_result ret;
-	struct fc_bsg_reply *bsg_reply;
-
-	if (!get_device(dev))
-		return;
-
-	while (1) {
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
-
-		ret = fc_req_to_bsgjob(shost, rport, req);
-		if (ret) {
-			req->errors = ret;
-			blk_end_request_all(req, ret);
-			spin_lock_irq(q->queue_lock);
-			continue;
-		}
-
-		job = req->special;
-
-		/* check if we have the msgcode value at least */
-		if (job->request_len < sizeof(uint32_t)) {
-			BUG_ON(job->reply_len < sizeof(uint32_t));
-			bsg_reply = job->reply;
-			bsg_reply->reply_payload_rcv_len = 0;
-			bsg_reply->result = -ENOMSG;
-			job->reply_len = sizeof(uint32_t);
-			bsg_job_done(job, bsg_reply->result,
-				       bsg_reply->reply_payload_rcv_len);
-			spin_lock_irq(q->queue_lock);
-			continue;
-		}
-
-		/* the dispatch routines will unlock the queue_lock */
-		if (rport)
-			ret = fc_bsg_rport_dispatch(q, shost, rport, job);
-		else
-			ret = fc_bsg_host_dispatch(q, shost, job);
-
-		/* did dispatcher hit state that can't process any more */
-		if (ret == FC_DISPATCH_BREAK)
-			break;
-
-		/* did dispatcher had released the lock */
-		if (ret == FC_DISPATCH_UNLOCKED)
-			spin_lock_irq(q->queue_lock);
-	}
-
-	spin_unlock_irq(q->queue_lock);
-	put_device(dev);
-	spin_lock_irq(q->queue_lock);
-}
-
-
-/**
- * fc_bsg_host_handler - handler for bsg requests for a fc host
- * @q:		fc host request queue
- */
-static void
-fc_bsg_host_handler(struct request_queue *q)
-{
-	struct Scsi_Host *shost = q->queuedata;
-
-	fc_bsg_request_handler(q, shost, NULL, &shost->shost_gendev);
+	return 0;
 }
 
-
-/**
- * fc_bsg_rport_handler - handler for bsg requests for a fc rport
- * @q:		rport request queue
- */
-static void
-fc_bsg_rport_handler(struct request_queue *q)
+static int fc_bsg_dispatch(struct bsg_job *job)
 {
-	struct fc_rport *rport = q->queuedata;
-	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 
-	fc_bsg_request_handler(q, shost, rport, &rport->dev);
+	if (scsi_is_fc_rport(job->dev))
+		return fc_bsg_rport_dispatch(shost, job);
+	else
+		return fc_bsg_host_dispatch(shost, job);
 }
 
-
 /**
  * fc_bsg_hostadd - Create and add the bsg hooks so we can receive requests
  * @shost:	shost for fc_host
@@ -3977,33 +3776,42 @@ enum fc_dispatch_result {
 	snprintf(bsg_name, sizeof(bsg_name),
 		 "fc_host%d", shost->host_no);
 
-	q = __scsi_alloc_queue(shost, fc_bsg_host_handler);
+	q = __scsi_alloc_queue(shost, bsg_request_fn);
 	if (!q) {
-		printk(KERN_ERR "fc_host%d: bsg interface failed to "
-				"initialize - no request queue\n",
-				 shost->host_no);
+		dev_err(dev,
+			"fc_host%d: bsg interface failed to initialize - no request queue\n",
+			shost->host_no);
 		return -ENOMEM;
 	}
 
-	q->queuedata = shost;
-	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
-	blk_queue_softirq_done(q, bsg_softirq_done);
-	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
-	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
-
-	err = bsg_register_queue(q, dev, bsg_name, NULL);
+	err = bsg_setup_queue(dev, q, bsg_name, fc_bsg_dispatch,
+				 i->f->dd_bsg_size);
 	if (err) {
-		printk(KERN_ERR "fc_host%d: bsg interface failed to "
-				"initialize - register queue\n",
-				shost->host_no);
+		dev_err(dev,
+			"fc_host%d: bsg interface failed to initialize - setup queue\n",
+			shost->host_no);
 		blk_cleanup_queue(q);
 		return err;
 	}
-
+	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
+	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
 	fc_host->rqst_q = q;
 	return 0;
 }
 
+static int fc_bsg_rport_prep(struct request_queue *q, struct request *req)
+{
+	struct fc_rport *rport = dev_to_rport(q->queuedata);
+
+	if (rport->port_state == FC_PORTSTATE_BLOCKED &&
+	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
+		return BLKPREP_DEFER;
+
+	if (rport->port_state != FC_PORTSTATE_ONLINE)
+		return BLKPREP_KILL;
+
+	return BLKPREP_OK;
+}
 
 /**
  * fc_bsg_rportadd - Create and add the bsg hooks so we can receive requests
@@ -4023,29 +3831,22 @@ enum fc_dispatch_result {
 	if (!i->f->bsg_request)
 		return -ENOTSUPP;
 
-	q = __scsi_alloc_queue(shost, fc_bsg_rport_handler);
+	q = __scsi_alloc_queue(shost, bsg_request_fn);
 	if (!q) {
-		printk(KERN_ERR "%s: bsg interface failed to "
-				"initialize - no request queue\n",
-				 dev->kobj.name);
+		dev_err(dev, "bsg interface failed to initialize - no request queue\n");
 		return -ENOMEM;
 	}
 
-	q->queuedata = rport;
-	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
-	blk_queue_softirq_done(q, bsg_softirq_done);
-	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
-	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
-
-	err = bsg_register_queue(q, dev, NULL, NULL);
+	err = bsg_setup_queue(dev, q, NULL, fc_bsg_dispatch, i->f->dd_bsg_size);
 	if (err) {
-		printk(KERN_ERR "%s: bsg interface failed to "
-				"initialize - register queue\n",
-				 dev->kobj.name);
+		dev_err(dev, "failed to setup bsg queue\n");
 		blk_cleanup_queue(q);
 		return err;
 	}
 
+	blk_queue_prep_rq(q, fc_bsg_rport_prep);
+	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
+	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 	rport->rqst_q = q;
 	return 0;
 }
-- 
1.8.5.6

