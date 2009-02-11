From: James Smart <James.Smart@Emulex.Com>
Subject: [RFC] FC pass thru - Rev V
Date: Wed, 11 Feb 2009 10:13:45 -0500
Message-ID: <1234365225.24194.3.camel@ogier>
References: <1227043498.4949.21.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53329 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbZBKPVz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 10:21:55 -0500
In-Reply-To: <1227043498.4949.21.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, sven@linux.vnet.ibm.com, futjita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com

Trying to kick-start this again...  
I've updated the prior RFC with the comments from Seokmann,
SvenFujita, and Boaz. I would still like review on the
blk_xxx completion calls in the std and error paths.

It currently expects that blk_end_request() has been updated
by Fujita's patch to incorporate blk_end_bidi_request()
functionality :
http://marc.info/?l-linux-scsi&m=122785157116659&w=2

-- james s

======

All,

I've reworked Seokmann's patch for the following items:
- Add an fchost interface for bsg requests

- Formalized the request/response structures that I expect
  to have us stuff into the bsg cmd/sense data areas. These
  are now genericized so we can essentially pass any kind of
  transaction. It can be a request that has no transmit or
  receive payload, and simply returns a response.

- A new file was created, scsi_bsg_fc.h, which contains the
  request/response data structures that should be shared
  between the application and the kernel entities. 

- I stripped out some things that were in the request
  structure that were actually LLD fields. Instead, I added
  a dd_bsgsize structure to the template, so the transport
  will allocate LLD work space along with the job structure.
  I expect the missing fields to move to this area.

- I've made a strong attempt at ensuring that the request
  has all the information necessary for the LLD, so that
  there is no need to have the LLD remap the transmit payload
  to figure things out. Granted, this comes at the cost of
  replicating some data items.

  Sven, I've added the CT information you needed as part of this.

- I've renamed things quite a bit, hoping to make it clarity
  better. The "service" struct is now a job. I still have
  headaches with "request" (is it the blk request, or the job
  request, or what..)

- The CT/ELS response is a bit funky. I've noted that the
  way Emulex returns a response, vs Qlogic is a bit different,
  thus the 2 ways to indicate "reject".

- fixed a couple of bugs in Seokmann's code, in the teardown,
  error flows, request que dma settings, etc.

- I added a "vendor_id" field to the scsi_host_template to
  use when verifying that the recipient knows how to decode
  vendor-specific message. I didn't do this with the netlink
  things as I was prepping it to not break kabi in existing
  and older kernels. But, I believe this is a good time to
  add it.

- I've started the Documentation/scsi/scsi_transport_fc.txt
  documentation, but punted finishing it in lieu of sending
  this RFC. I'm starting from Seokman's original emails and
  will be updating for this reformat.

I'm only starting to debug this, so user beware.

I could really use some code review from Fujita or Boaz, to
make sure I'm calling the right blk_xx completion functions
relative to the setup flow, and to ensure that the "goose"
when I jump out while the rport is blocked is correct.

Comments welcome

-- james s





 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 Documentation/scsi/scsi_fc_transport.txt |   11 
 Documentation/scsi/scsi_mid_low_api.txt  |    5 
 drivers/scsi/scsi_transport_fc.c         |  614 ++++++++++++++++++++++++++++++-
 include/scsi/scsi_bsg_fc.h               |  322 ++++++++++++++++
 include/scsi/scsi_host.h                 |    9 
 include/scsi/scsi_transport_fc.h         |   52 ++
 6 files changed, 1009 insertions(+), 4 deletions(-)


diff -upNr a/Documentation/scsi/scsi_fc_transport.txt b/Documentation/scsi/scsi_fc_transport.txt
--- a/Documentation/scsi/scsi_fc_transport.txt	2009-01-27 09:44:22.000000000 -0500
+++ b/Documentation/scsi/scsi_fc_transport.txt	2009-02-10 10:34:42.000000000 -0500
@@ -1,10 +1,11 @@
                              SCSI FC Tansport
                  =============================================
 
-Date:  4/12/2007
+Date:  11/18/2008
 Kernel Revisions for features:
   rports : <<TBS>>
   vports : 2.6.22 (? TBD)
+  bsg support : 2.6.29 (?TBD)
 
 
 Introduction
@@ -15,6 +16,7 @@ The FC transport can be found at:
   drivers/scsi/scsi_transport_fc.c
   include/scsi/scsi_transport_fc.h
   include/scsi/scsi_netlink_fc.h
+  include/scsi/scsi_bsg_fc.h
 
 This file is found at Documentation/scsi/scsi_fc_transport.txt
 
@@ -472,6 +474,13 @@ int
 fc_vport_terminate(struct fc_vport *vport)
 
 
+FC BSG support (CT & ELS passthru, and more)
+========================================================================
+<< To Be Supplied >>
+
+
+
+
 Credits
 =======
 The following people have contributed to this document:
diff -upNr a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
--- a/Documentation/scsi/scsi_mid_low_api.txt	2008-09-23 15:11:57.000000000 -0400
+++ b/Documentation/scsi/scsi_mid_low_api.txt	2009-02-10 10:34:42.000000000 -0500
@@ -1271,6 +1271,11 @@ of interest:
     hostdata[0]  - area reserved for LLD at end of struct Scsi_Host. Size
                    is set by the second argument (named 'xtr_bytes') to
                    scsi_host_alloc() or scsi_register().
+    vendor_id    - a unique value that identifies the vendor supplying
+                   the LLD for the Scsi_Host.  Used most often in validating
+                   vendor-specific message requests.  Value consists of an
+                   identifier type and a vendor-specific value.
+                   See scsi_netlink.h for a description of valid formats.
 
 The scsi_host structure is defined in include/scsi/scsi_host.h
 
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2009-01-27 09:44:31.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2009-02-10 14:58:39.000000000 -0500
@@ -35,6 +35,7 @@
 #include <linux/netlink.h>
 #include <net/netlink.h>
 #include <scsi/scsi_netlink_fc.h>
+#include <scsi/scsi_bsg_fc.h>
 #include "scsi_priv.h"
 #include "scsi_transport_fc_internal.h"
 
@@ -43,6 +44,10 @@ static void fc_vport_sched_delete(struct
 static int fc_vport_setup(struct Scsi_Host *shost, int channel,
 	struct device *pdev, struct fc_vport_identifiers  *ids,
 	struct fc_vport **vport);
+static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
+static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
+static void fc_bsg_remove(struct request_queue *);
+static void fc_bsg_goose_queue(struct fc_rport *);
 
 /*
  * Redefine so that we can have same named attributes in the
@@ -411,13 +416,26 @@ static int fc_host_setup(struct transpor
 		return -ENOMEM;
 	}
 
+	fc_bsg_hostadd(shost, fc_host);
+	/* ignore any bsg add error - we just can't do sgio */
+
+	return 0;
+}
+
+static int fc_host_remove(struct transport_container *tc, struct device *dev,
+			 struct device *cdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+
+	fc_bsg_remove(fc_host->rqst_q);
 	return 0;
 }
 
 static DECLARE_TRANSPORT_CLASS(fc_host_class,
 			       "fc_host",
 			       fc_host_setup,
-			       NULL,
+			       fc_host_remove,
 			       NULL);
 
 /*
@@ -2383,6 +2401,7 @@ fc_rport_final_delete(struct work_struct
 		scsi_flush_work(shost);
 
 	fc_terminate_rport_io(rport);
+
 	/*
 	 * Cancel any outstanding timers. These should really exist
 	 * only when rmmod'ing the LLDD and we're asking for
@@ -2415,6 +2434,8 @@ fc_rport_final_delete(struct work_struct
 	    (i->f->dev_loss_tmo_callbk))
 		i->f->dev_loss_tmo_callbk(rport);
 
+	fc_bsg_remove(rport->rqst_q);
+
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
@@ -2502,6 +2523,9 @@ fc_rport_create(struct Scsi_Host *shost,
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
+	fc_bsg_rportadd(shost, rport);
+	/* ignore any bsg add error - we just can't do sgio */
+
 	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
 		/* initiate a scan of the target */
 		rport->flags |= FC_RPORT_SCAN_PENDING;
@@ -2666,6 +2690,8 @@ fc_remote_port_add(struct Scsi_Host *sho
 					spin_unlock_irqrestore(shost->host_lock,
 							flags);
 
+				fc_bsg_goose_queue(rport);
+
 				return rport;
 			}
 		}
@@ -3351,6 +3377,592 @@ fc_vport_sched_delete(struct work_struct
 }
 
 
+/*
+ * BSG support
+ */
+
+
+/**
+ * fc_destroy_bsgjob - routine to teardown/delete a fc bsg job
+ * @job:	fc_bsg_job that is to be torn down
+ */
+static void
+fc_destroy_bsgjob(struct fc_bsg_job *job)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	if (job->ref_cnt) {
+		spin_unlock_irqrestore(&job->job_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	put_device(job->dev);	/* release reference for the request */
+
+	kfree(job->request_payload.sg_list);
+	kfree(job->reply_payload.sg_list);
+	kfree(job);
+}
+
+
+/**
+ * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
+ *                  completed
+ * @job:	fc_bsg_job that is complete
+ */
+static void
+fc_bsg_jobdone(struct fc_bsg_job *job)
+{
+	struct request *req = job->req;
+	struct request *rsp = req->next_rq;
+	unsigned long flags;
+	unsigned rsp_len;
+	int err;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	job->state_flags |= FC_RQST_STATE_DONE;
+	job->ref_cnt--;
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	err = job->req->errors = job->reply->result;
+	if (err < 0)
+		/* we're only returning the result field in the reply */
+		job->req->sense_len = sizeof(uint32_t);
+	else
+		job->req->sense_len = job->reply_len;
+
+	if (rsp) {
+		rsp_len = blk_rq_bytes(rsp);
+		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
+		/* set reply (bidi) residual */
+		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
+	}
+
+	/* we assume all request payload was transferred */
+	blk_end_request(req, err, blk_rq_bytes(req));
+
+	fc_destroy_bsgjob(job);
+}
+
+
+/**
+ * fc_bsg_job_timeout - handler for when a bsg request timesout
+ * @req:	request that timed out
+ */
+static enum blk_eh_timer_return
+fc_bsg_job_timeout(struct request *req)
+{
+	struct fc_bsg_job *job = (void *) req->special;
+	struct Scsi_Host *shost = job->shost;
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	unsigned long flags;
+	int err = 0, done = 0;
+
+	if (job->rport && job->rport->port_state == FC_PORTSTATE_BLOCKED)
+		return BLK_EH_RESET_TIMER;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	if (job->state_flags & FC_RQST_STATE_DONE)
+		done = 1;
+	else
+		job->ref_cnt++;
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	if (!done && i->f->bsg_timeout) {
+		/* call LLDD to abort the i/o as it has timed out */
+		err = i->f->bsg_timeout(job);
+		if (err)
+			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
+				"abort failed with status %d\n", err);
+	}
+
+	if (!done) {
+		spin_lock_irqsave(&job->job_lock, flags);
+		job->ref_cnt--;
+		spin_unlock_irqrestore(&job->job_lock, flags);
+		fc_destroy_bsgjob(job);
+	}
+
+	/* the blk_end_sync_io() doesn't check the error */
+	return BLK_EH_HANDLED;
+}
+
+
+
+static int
+fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
+{
+	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
+
+	BUG_ON(!req->nr_phys_segments);
+
+	buf->sg_list = kzalloc(sz, GFP_KERNEL);
+	if (!buf->sg_list)
+		return -ENOMEM;
+	sg_init_table(buf->sg_list, req->nr_phys_segments);
+	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
+	buf->payload_len = req->data_len;
+	return 0;
+}
+
+
+/**
+ * fc_req_to_bsgjob - Allocate/create the fc_bsg_job structure for the
+ *                   bsg request
+ * @shost:	SCSI Host corresponding to the bsg object
+ * @rport:	(optional) FC Remote Port corresponding to the bsg object
+ * @req:	BSG request that needs a job structure
+ */
+static int
+fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
+	struct request *req)
+{
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct request *rsp = req->next_rq;
+	struct fc_bsg_job *job;
+	int ret;
+
+	BUG_ON(req->special);
+
+	job = kzalloc(sizeof(struct fc_bsg_job) + i->f->dd_bsg_size,
+			GFP_KERNEL);
+	if (!job)
+		return -ENOMEM;
+
+	/*
+	 * Note: this is a bit silly.
+	 * The request gets formatted as a SGIO v4 ioctl request, which
+	 * then gets reformatted as a blk request, which then gets
+	 * reformatted as a fc bsg request. And on completion, we have
+	 * to wrap return results such that SGIO v4 thinks it was a scsi
+	 * status.  I hope this was all worth it.
+	 */
+
+	req->special = job;
+	job->shost = shost;
+	job->rport = rport;
+	job->req = req;
+	if (i->f->dd_bsg_size)
+		job->dd_data = (void *)&job[1];
+	spin_lock_init(&job->job_lock);
+	job->request = (struct fc_bsg_request *)req->cmd;
+	job->request_len = req->cmd_len;
+	job->reply = req->sense;
+	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
+						 * allocated */
+	if (req->bio) {
+		ret = fc_bsg_map_buffer(&job->request_payload, req);
+		if (ret)
+			goto failjob_rls_job;
+	}
+	if (rsp && rsp->bio) {
+		ret = fc_bsg_map_buffer(&job->reply_payload, rsp);
+		if (ret)
+			goto failjob_rls_rqst_payload;
+	}
+	job->job_done = fc_bsg_jobdone;
+	if (rport)
+		job->dev = &rport->dev;
+	else
+		job->dev = &shost->shost_gendev;
+	get_device(job->dev);		/* take a reference for the request */
+
+	job->ref_cnt = 1;
+
+	return 0;
+
+
+failjob_rls_rqst_payload:
+	kfree(job->request_payload.sg_list);
+failjob_rls_job:
+	kfree(job);
+	return -ENOMEM;
+}
+
+
+enum fc_dispatch_result {
+	FC_DISPATCH_BREAK,	/* on return, q is locked, break from q loop */
+	FC_DISPATCH_LOCKED,	/* on return, q is locked, continue on */
+	FC_DISPATCH_UNLOCKED,	/* on return, q is unlocked, continue on */
+};
+
+
+/**
+ * fc_bsg_host_dispatch - process fc host bsg requests and dispatch to LLDD
+ * @shost:	scsi host rport attached to
+ * @job:	bsg job to be processed
+ */
+static enum fc_dispatch_result
+fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
+			 struct fc_bsg_job *job)
+{
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	int ret;
+
+	/* Validate the host command */
+	switch (job->request->msgcode) {
+	case FC_BSG_HST_ADD_RPORT:
+		cmdlen += sizeof(struct fc_bsg_host_add_rport);
+		break;
+
+	case FC_BSG_HST_DEL_RPORT:
+		cmdlen += sizeof(struct fc_bsg_host_del_rport);
+		break;
+
+	case FC_BSG_HST_ELS_NOLOGIN:
+		cmdlen += sizeof(struct fc_bsg_host_els);
+		/* there better be a xmt and rcv payloads */
+		if ((!job->request_payload.payload_len) ||
+		    (!job->reply_payload.payload_len)) {
+			ret = -EINVAL;
+			goto fail_host_msg;
+		}
+		break;
+
+	case FC_BSG_HST_CT:
+		cmdlen += sizeof(struct fc_bsg_host_ct);
+		/* there better be xmt and rcv payloads */
+		if ((!job->request_payload.payload_len) ||
+		    (!job->reply_payload.payload_len)) {
+			ret = -EINVAL;
+			goto fail_host_msg;
+		}
+		break;
+
+	case FC_BSG_HST_VENDOR:
+		cmdlen += sizeof(struct fc_bsg_host_vendor);
+		if ((shost->hostt->vendor_id == 0L) ||
+		    (job->request->rqst_data.h_vendor.vendor_id !=
+			shost->hostt->vendor_id)) {
+			ret = -ESRCH;
+			goto fail_host_msg;
+		}
+		break;
+
+	default:
+		ret = -EBADR;
+		goto fail_host_msg;
+	}
+
+	/* check if we really have all the request data needed */
+	if (job->request_len < cmdlen) {
+		ret = -ENOMSG;
+		goto fail_host_msg;
+	}
+
+	ret = i->f->bsg_request(job);
+	if (!ret)
+		return FC_DISPATCH_UNLOCKED;
+
+fail_host_msg:
+	/* return the errno failure code as the only status */
+	BUG_ON(job->reply_len < sizeof(uint32_t));
+	job->reply->result = ret;
+	job->reply_len = sizeof(uint32_t);
+	fc_bsg_jobdone(job);
+	return FC_DISPATCH_UNLOCKED;
+}
+
+
+/*
+ * fc_bsg_goose_queue - restart rport queue in case it was stopped
+ * @rport:	rport to be restarted
+ */
+static void
+fc_bsg_goose_queue(struct fc_rport *rport)
+{
+	int flagset;
+
+	if (!rport->rqst_q)
+		return;
+
+	get_device(&rport->dev);
+
+	spin_lock(rport->rqst_q->queue_lock);
+	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
+		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
+	if (flagset)
+		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
+	__blk_run_queue(rport->rqst_q);
+	if (flagset)
+		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
+	spin_unlock(rport->rqst_q->queue_lock);
+
+	put_device(&rport->dev);
+}
+
+
+/**
+ * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
+ * @shost:	scsi host rport attached to
+ * @rport:	rport request destined to
+ * @job:	bsg job to be processed
+ */
+static enum fc_dispatch_result
+fc_bsg_rport_dispatch(struct request_queue *q, struct Scsi_Host *shost,
+			 struct fc_rport *rport, struct fc_bsg_job *job)
+{
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	int ret;
+
+	/* Validate the rport command */
+	switch (job->request->msgcode) {
+	case FC_BSG_RPT_ELS:
+		cmdlen += sizeof(struct fc_bsg_rport_els);
+		goto check_bidi;
+
+	case FC_BSG_RPT_CT:
+		cmdlen += sizeof(struct fc_bsg_rport_ct);
+check_bidi:
+		/* there better be xmt and rcv payloads */
+		if ((!job->request_payload.payload_len) ||
+		    (!job->reply_payload.payload_len)) {
+			ret = -EINVAL;
+			goto fail_rport_msg;
+		}
+		break;
+	default:
+		ret = -EBADR;
+		goto fail_rport_msg;
+	}
+
+	/* check if we really have all the request data needed */
+	if (job->request_len < cmdlen) {
+		ret = -ENOMSG;
+		goto fail_rport_msg;
+	}
+
+	ret = i->f->bsg_request(job);
+	if (!ret)
+		return FC_DISPATCH_UNLOCKED;
+
+fail_rport_msg:
+	/* return the errno failure code as the only status */
+	BUG_ON(job->reply_len < sizeof(uint32_t));
+	job->reply->result = ret;
+	job->reply_len = sizeof(uint32_t);
+	fc_bsg_jobdone(job);
+	return FC_DISPATCH_UNLOCKED;
+}
+
+
+/**
+ * fc_bsg_request_handler - generic handler for bsg requests
+ * @q:		request queue to manage
+ * @shost:	Scsi_Host related to the bsg object
+ * @rport:	FC remote port related to the bsg object (optional)
+ * @dev:	device structure for bsg object
+ */
+static void
+fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
+		       struct fc_rport *rport, struct device *dev)
+{
+	struct request *req;
+	struct fc_bsg_job *job;
+	enum fc_dispatch_result ret;
+
+	if (!get_device(dev))
+		return;
+
+	while (!blk_queue_plugged(q)) {
+		req = elv_next_request(q);
+		if (!req)
+			break;
+
+		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED))
+				break;
+
+		blkdev_dequeue_request(req);
+
+		if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
+			req->errors = -ENXIO;
+			spin_unlock_irq(q->queue_lock);
+			blk_end_request(req, -ENXIO, blk_rq_bytes(req));
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
+		spin_unlock_irq(q->queue_lock);
+
+		ret = fc_req_to_bsgjob(shost, rport, req);
+		if (ret) {
+			req->errors = ret;
+			blk_end_request(req, ret, blk_rq_bytes(req));
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
+		job = req->special;
+
+		/* check if we have the msgcode value at least */
+		if (job->request_len < sizeof(uint32_t)) {
+			BUG_ON(job->reply_len < sizeof(uint32_t));
+			job->reply->result = -ENOMSG;
+			job->reply_len = sizeof(uint32_t);
+			fc_bsg_jobdone(job);
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
+		/* the dispatch routines will unlock the queue_lock */
+		if (rport)
+			ret = fc_bsg_rport_dispatch(q, shost, rport, job);
+		else
+			ret = fc_bsg_host_dispatch(q, shost, job);
+
+		/* did dispatcher hit state that can't process any more */
+		if (ret == FC_DISPATCH_BREAK)
+			break;
+
+		/* did dispatcher had released the lock */
+		if (ret == FC_DISPATCH_UNLOCKED)
+			spin_lock_irq(q->queue_lock);
+	}
+
+	spin_unlock_irq(q->queue_lock);
+	put_device(dev);
+	spin_lock_irq(q->queue_lock);
+}
+
+
+/**
+ * fc_bsg_host_handler - handler for bsg requests for a fc host
+ * @q:		fc host request queue
+ */
+static void
+fc_bsg_host_handler(struct request_queue *q)
+{
+	struct Scsi_Host *shost = q->queuedata;
+
+	fc_bsg_request_handler(q, shost, NULL, &shost->shost_gendev);
+}
+
+
+/**
+ * fc_bsg_rport_handler - handler for bsg requests for a fc rport
+ * @q:		rport request queue
+ */
+static void
+fc_bsg_rport_handler(struct request_queue *q)
+{
+	struct fc_rport *rport = q->queuedata;
+	struct Scsi_Host *shost = rport_to_shost(rport);
+
+	fc_bsg_request_handler(q, shost, rport, &rport->dev);
+}
+
+
+/**
+ * fc_bsg_hostadd - Create and add the bsg hooks so we can receive requests
+ * @shost:	shost for fc_host
+ * @fc_host:	fc_host adding the structures to
+ */
+static int
+fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
+{
+	struct device *dev = &shost->shost_gendev;
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct request_queue *q;
+	int err;
+	char bsg_name[BUS_ID_SIZE]; /*20*/
+
+	fc_host->rqst_q = NULL;
+
+	if (!i->f->bsg_request)
+		return -ENOTSUPP;
+
+	snprintf(bsg_name, sizeof(bsg_name),
+		 "fc_host%d", shost->host_no);
+
+	q = __scsi_alloc_queue(shost, fc_bsg_host_handler);
+	if (!q) {
+		printk(KERN_ERR "fc_host%d: bsg interface failed to "
+				"initialize - no request queue\n",
+				 shost->host_no);
+		return -ENOMEM;
+	}
+
+	q->queuedata = shost;
+	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
+	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
+
+	err = bsg_register_queue(q, dev, bsg_name, NULL);
+	if (err) {
+		printk(KERN_ERR "fc_host%d: bsg interface failed to "
+				"initialize - register queue\n",
+				shost->host_no);
+		blk_cleanup_queue(q);
+		return err;
+	}
+
+	fc_host->rqst_q = q;
+	return 0;
+}
+
+
+/**
+ * fc_bsg_rportadd - Create and add the bsg hooks so we can receive requests
+ * @shost:	shost that rport is attached to
+ * @rport:	rport that the bsg hooks are being attached to
+ */
+static int
+fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
+{
+	struct device *dev = &rport->dev;
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct request_queue *q;
+	int err;
+
+	rport->rqst_q = NULL;
+
+	if (!i->f->bsg_request)
+		return -ENOTSUPP;
+
+	q = __scsi_alloc_queue(shost, fc_bsg_rport_handler);
+	if (!q) {
+		printk(KERN_ERR "%s: bsg interface failed to "
+				"initialize - no request queue\n",
+				 dev->bus_id);
+		return -ENOMEM;
+	}
+
+	q->queuedata = rport;
+	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
+	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
+
+	err = bsg_register_queue(q, dev, NULL, NULL);
+	if (err) {
+		printk(KERN_ERR "%s: bsg interface failed to "
+				"initialize - register queue\n",
+				 dev->bus_id);
+		blk_cleanup_queue(q);
+		return err;
+	}
+
+	rport->rqst_q = q;
+	return 0;
+}
+
+
+/**
+ * fc_bsg_remove - Deletes the bsg hooks on fchosts/rports
+ * @q:	the request_queue that is to be torn down.
+ */
+static void
+fc_bsg_remove(struct request_queue *q)
+{
+	if (q) {
+		bsg_unregister_queue(q);
+		blk_cleanup_queue(q);
+	}
+}
+
+
 /* Original Author:  Martin Hicks */
 MODULE_AUTHOR("James Smart");
 MODULE_DESCRIPTION("FC Transport Attributes");
diff -upNr a/include/scsi/scsi_bsg_fc.h b/include/scsi/scsi_bsg_fc.h
--- a/include/scsi/scsi_bsg_fc.h	1969-12-31 19:00:00.000000000 -0500
+++ b/include/scsi/scsi_bsg_fc.h	2009-02-10 13:26:17.000000000 -0500
@@ -0,0 +1,322 @@
+/*
+ *  FC Transport BSG Interface
+ *
+ *  Copyright (C) 2008   James Smart, Emulex Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef SCSI_BSG_FC_H
+#define SCSI_BSG_FC_H
+
+/*
+ * This file intended to be included by both kernel and user space
+ */
+
+#include <scsi/scsi.h>
+
+/*
+ * FC Transport SGIO v4 BSG Message Support
+ */
+
+/* Default BSG request timeout (in seconds) */
+#define FC_DEFAULT_BSG_TIMEOUT		(10 * HZ)
+
+
+/*
+ * Request Message Codes supported by the FC Transport
+ */
+
+/* define the class masks for the message codes */
+#define FC_BSG_CLS_MASK		0xF0000000	/* find object class */
+#define FC_BSG_HST_MASK		0x80000000	/* fc host class */
+#define FC_BSG_RPT_MASK		0x40000000	/* fc rport class */
+
+	/* fc_host Message Codes */
+#define FC_BSG_HST_ADD_RPORT		(FC_BSG_HST_MASK | 0x00000001)
+#define FC_BSG_HST_DEL_RPORT		(FC_BSG_HST_MASK | 0x00000002)
+#define FC_BSG_HST_ELS_NOLOGIN		(FC_BSG_HST_MASK | 0x00000003)
+#define FC_BSG_HST_CT			(FC_BSG_HST_MASK | 0x00000004)
+#define FC_BSG_HST_VENDOR		(FC_BSG_HST_MASK | 0x000000FF)
+
+	/* fc_rport Message Codes */
+#define FC_BSG_RPT_ELS			(FC_BSG_RPT_MASK | 0x00000001)
+#define FC_BSG_RPT_CT			(FC_BSG_RPT_MASK | 0x00000002)
+
+
+
+/*
+ * FC Address Identifiers in Message Structures :
+ *
+ *   Whenever a command payload contains a FC Address Identifier
+ *   (aka port_id), the value is effectively in big-endian
+ *   order, thus the array elements are decoded as follows:
+ *     element [0] is bits 23:16 of the FC Address Identifier
+ *     element [1] is bits 15:8 of the FC Address Identifier
+ *     element [2] is bits 7:0 of the FC Address Identifier
+ */
+
+
+/*
+ * FC Host Messages
+ */
+
+/* FC_BSG_HST_ADDR_PORT : */
+
+/* Request:
+ * This message requests the FC host to login to the remote port
+ * at the specified N_Port_Id.  The remote port is to be enumerated
+ * with the transport upon completion of the login.
+ */
+struct fc_bsg_host_add_rport {
+	uint8_t		reserved;
+
+	/* FC Address Identier of the remote port to login to */
+	uint8_t		port_id[3];
+};
+
+/* Response:
+ * There is no additional response data - fc_bsg_reply->result is sufficient
+ */
+
+
+/* FC_BSG_HST_DEL_RPORT : */
+
+/* Request:
+ * This message requests the FC host to remove an enumerated
+ * remote port and to terminate the login to it.
+ *
+ * Note: The driver is free to reject this request if it desires to
+ * remain logged in with the remote port.
+ */
+struct fc_bsg_host_del_rport {
+	uint8_t		reserved;
+
+	/* FC Address Identier of the remote port to logout of */
+	uint8_t		port_id[3];
+};
+
+/* Response:
+ * There is no additional response data - fc_bsg_reply->result is sufficient
+ */
+
+
+/* FC_BSG_HST_ELS_NOLOGIN : */
+
+/* Request:
+ * This message requests the FC_Host to send an ELS to a specific
+ * N_Port_ID. The host does not need to log into the remote port,
+ * nor does it need to enumerate the rport for further traffic
+ * (although, the FC host is free to do so if it desires).
+ */
+struct fc_bsg_host_els {
+	/*
+	 * ELS Command Code being sent (must be the same as byte 0
+	 * of the payload)
+	 */
+	uint8_t 	command_code;
+
+	/* FC Address Identier of the remote port to send the ELS to */
+	uint8_t		port_id[3];
+};
+
+/* Response:
+ */
+/* fc_bsg_ctels_reply->status values */
+#define FC_CTELS_STATUS_OK	0x00000000
+#define FC_CTELS_STATUS_REJECT	0x00000001
+#define FC_CTELS_STATUS_P_RJT	0x00000002
+#define FC_CTELS_STATUS_F_RJT	0x00000003
+#define FC_CTELS_STATUS_P_BSY	0x00000004
+#define FC_CTELS_STATUS_F_BSY	0x00000006
+struct fc_bsg_ctels_reply {
+	/*
+	 * Note: An ELS LS_RJT may be reported in 2 ways:
+	 *  a) A status of FC_CTELS_STATUS_OK is returned. The caller
+	 *     is to look into the ELS receive payload to determine
+	 *     LS_ACC or LS_RJT (by contents of word 0). The reject
+	 *     data will be in word 1.
+	 *  b) A status of FC_CTELS_STATUS_REJECT is returned, The
+	 *     rjt_data field will contain valid data.
+	 *
+	 * Note: ELS LS_ACC is determined by an FC_CTELS_STATUS_OK, and
+	 *   the receive payload word 0 indicates LS_ACC
+	 *   (e.g. value is 0x02xxxxxx).
+	 *
+	 * Note: Similarly, a CT Reject may be reported in 2 ways:
+	 *  a) A status of FC_CTELS_STATUS_OK is returned. The caller
+	 *     is to look into the CT receive payload to determine
+	 *     Accept or Reject (by contents of word 2). The reject
+	 *     data will be in word 3.
+	 *  b) A status of FC_CTELS_STATUS_REJECT is returned, The
+	 *     rjt_data field will contain valid data.
+	 *
+	 * Note: x_RJT/BSY status will indicae that the rjt_data field
+	 *   is valid and contains the reason/explanation values.
+	 */
+	uint32_t	status;		/* See FC_CTELS_STATUS_xxx */
+
+	/* valid if status is not FC_CTELS_STATUS_OK */
+	struct	{
+		uint8_t	action;		/* fragment_id for CT REJECT */
+		uint8_t	reason_code;
+		uint8_t	reason_explanation;
+		uint8_t	vendor_unique;
+	} rjt_data;
+};
+
+
+/* FC_BSG_HST_CT : */
+
+/* Request:
+ * This message requests that a CT Request be performed with the
+ * indicated N_Port_ID. The driver is responsible for logging in with
+ * the fabric and/or N_Port_ID, etc as per FC rules. This request does
+ * not mandate that the driver must enumerate the destination in the
+ * transport. The driver is allowed to decide whether to enumerate it,
+ * and whether to tear it down after the request.
+ */
+struct fc_bsg_host_ct {
+	uint8_t		reserved;
+
+	/* FC Address Identier of the remote port to send the ELS to */
+	uint8_t		port_id[3];
+
+	/*
+	 * We need words 0-2 of the generic preamble for the LLD's
+	 */
+	uint32_t	preamble_word0;	/* revision & IN_ID */
+	uint32_t	preamble_word1;	/* GS_Type, GS_SubType, Options, Rsvd */
+	uint32_t	preamble_word2;	/* Cmd Code, Max Size */
+
+};
+/* Response:
+ *
+ * The reply structure is an fc_bsg_ctels_reply structure
+ */
+
+
+/* FC_BSG_HST_VENDOR : */
+
+/* Request:
+ * Note: When specifying vendor_id, be sure to read the Vendor Type and ID
+ *   formatting requirements specified in scsi_netlink.h
+ */
+struct fc_bsg_host_vendor {
+	/*
+	 * Identifies the vendor that the message is formatted for. This
+	 * should be the recipient of the message.
+	 */
+	uint64_t vendor_id;
+
+	/* start of vendor command area */
+	uint32_t vendor_cmd[0];
+};
+
+/* Response:
+ */
+struct fc_bsg_host_vendor_reply {
+	/* start of vendor response area */
+	uint32_t vendor_rsp[0];
+};
+
+
+
+/*
+ * FC Remote Port Messages
+ */
+
+/* FC_BSG_RPT_ELS : */
+
+/* Request:
+ * This message requests that an ELS be performed with the rport.
+ */
+struct fc_bsg_rport_els {
+	/*
+	 * ELS Command Code being sent (must be the same as
+	 * byte 0 of the payload)
+	 */
+	uint8_t els_code;
+};
+
+/* Response:
+ *
+ * The reply structure is an fc_bsg_ctels_reply structure
+ */
+
+
+/* FC_BSG_RPT_CT : */
+
+/* Request:
+ * This message requests that a CT Request be performed with the rport.
+ */
+struct fc_bsg_rport_ct {
+	/*
+	 * We need words 0-2 of the generic preamble for the LLD's
+	 */
+	uint32_t	preamble_word0;	/* revision & IN_ID */
+	uint32_t	preamble_word1;	/* GS_Type, GS_SubType, Options, Rsvd */
+	uint32_t	preamble_word2;	/* Cmd Code, Max Size */
+};
+/* Response:
+ *
+ * The reply structure is an fc_bsg_ctels_reply structure
+ */
+
+
+
+
+/* request (CDB) structure of the sg_io_v4 */
+struct fc_bsg_request {
+	uint32_t msgcode;
+	union {
+		struct fc_bsg_host_add_rport	h_addrport;
+		struct fc_bsg_host_del_rport	h_delrport;
+		struct fc_bsg_host_els		h_els;
+		struct fc_bsg_host_ct		h_ct;
+		struct fc_bsg_host_vendor	h_vendor;
+
+		struct fc_bsg_rport_els		r_els;
+		struct fc_bsg_rport_ct		r_ct;
+	} rqst_data;
+};
+
+
+/* response (request sense data) structure of the sg_io_v4 */
+struct fc_bsg_reply {
+	/*
+	 * The completion result. Result exists in two forms:
+	 *  if negative, it is an -Exxx system errno value. There will
+	 *    be no further reply information supplied.
+	 *  else, it's the 4-byte scsi error result, with driver, host,
+	 *    msg and status fields. The per-msgcode reply structure
+	 *    will contain valid data.
+	 */
+	uint32_t result;
+
+	/* If there was reply_payload, how much was recevied ? */
+	uint32_t reply_payload_rcv_len;
+
+	union {
+		struct fc_bsg_host_vendor_reply		vendor_reply;
+
+		struct fc_bsg_ctels_reply		ctels_reply;
+	} reply_data;
+};
+
+
+#endif /* SCSI_BSG_FC_H */
+
diff -upNr a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2008-10-18 10:32:54.000000000 -0400
+++ b/include/scsi/scsi_host.h	2009-02-10 10:34:42.000000000 -0500
@@ -478,6 +478,15 @@ struct scsi_host_template {
 	 * module_init/module_exit.
 	 */
 	struct list_head legacy_hosts;
+
+	/*
+	 * Vendor Identifier associated with the host
+	 *
+	 * Note: When specifying vendor_id, be sure to read the
+	 *   Vendor Type and ID formatting requirements specified in
+	 *   scsi_netlink.h
+	 */
+	u64 vendor_id;
 };
 
 /*
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2009-01-27 09:44:40.000000000 -0500
+++ b/include/scsi/scsi_transport_fc.h	2009-02-10 13:12:20.000000000 -0500
@@ -33,7 +33,6 @@
 
 struct scsi_transport_template;
 
-
 /*
  * FC Port definitions - Following FC HBAAPI guidelines
  *
@@ -352,6 +351,7 @@ struct fc_rport {	/* aka fc_starget_attr
  	struct delayed_work fail_io_work;
  	struct work_struct stgt_delete_work;
 	struct work_struct rport_delete_work;
+	struct request_queue *rqst_q;	/* bsg support */
 } __attribute__((aligned(sizeof(unsigned long))));
 
 /* bit field values for struct fc_rport "flags" field: */
@@ -514,6 +514,9 @@ struct fc_host_attrs {
 	struct workqueue_struct *work_q;
 	char devloss_work_q_name[20];
 	struct workqueue_struct *devloss_work_q;
+
+	/* bsg support */
+	struct request_queue *rqst_q;
 };
 
 #define shost_to_fc_host(x) \
@@ -579,6 +582,47 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
 
 
+struct fc_bsg_buffer {
+	unsigned int payload_len;
+	int sg_cnt;
+	struct scatterlist *sg_list;
+};
+
+/* Values for fc_bsg_job->state_flags (bitflags) */
+#define FC_RQST_STATE_INPROGRESS	0
+#define FC_RQST_STATE_DONE		1
+
+struct fc_bsg_job {
+	struct Scsi_Host *shost;
+	struct fc_rport *rport;
+	struct device *dev;
+	struct request *req;
+	spinlock_t job_lock;
+	unsigned int state_flags;
+	unsigned int ref_cnt;
+	void (*job_done)(struct fc_bsg_job *);
+
+	struct fc_bsg_request *request;
+	struct fc_bsg_reply *reply;
+	unsigned int request_len;
+	unsigned int reply_len;
+	/*
+	 * On entry : reply_len indicates the buffer size allocated for
+	 * the reply.
+	 *
+	 * Upon completion : the message handler must set reply_len
+	 *  to indicates the size of the reply to be returned to the
+	 *  caller.
+	 */
+
+	/* DMA payloads for the request/response */
+	struct fc_bsg_buffer request_payload;
+	struct fc_bsg_buffer reply_payload;
+
+	void *dd_data;			/* Used for driver-specific storage */
+};
+
+
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
 	void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
@@ -614,9 +658,14 @@ struct fc_function_template {
 	int     (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);
 
+	/* bsg support */
+	int	(*bsg_request)(struct fc_bsg_job *);
+	int	(*bsg_timeout)(struct fc_bsg_job *);
+
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
 	u32	 			dd_fcvport_size;
+	u32				dd_bsg_size;
 
 	/*
 	 * The driver sets these to tell the transport class it
@@ -737,7 +786,6 @@ fc_vport_set_state(struct fc_vport *vpor
 	vport->vport_state = new_state;
 }
 
-
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);


