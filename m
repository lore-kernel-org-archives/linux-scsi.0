From: James Smart <James.Smart@Emulex.Com>
Subject: [RFC] iscsi transport : add sgio pass-thru support
Date: Fri, 30 Oct 2009 09:49:17 -0400
Message-ID: <1256910577.2985.4.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:35333 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbZJ3Nth (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2009 09:49:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

[reposting to include open-iscsi list]

This patch implements the same infrastructure as found in the FC transport
for sgio request/response handling.

The patch creates (and exports to userland) a new header -
scsi_bsg_iscsi.h


-- james s



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 drivers/scsi/scsi_transport_iscsi.c |  414
+++++++++++++++++++++++++++++++++++-
 include/scsi/Kbuild                 |    1 
 include/scsi/scsi_bsg_iscsi.h       |  111 +++++++++
 include/scsi/scsi_transport_iscsi.h |   45 +++
 4 files changed, 570 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/scsi_transport_iscsi.c
b/drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c	2009-10-26 12:58:17.000000000
-0400
+++ b/drivers/scsi/scsi_transport_iscsi.c	2009-10-29 15:00:57.000000000
-0400
@@ -29,6 +29,8 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
+#include <scsi/scsi_bsg_iscsi.h>
+#include <scsi/scsi_cmnd.h>
 
 #define ISCSI_SESSION_ATTRS 21
 #define ISCSI_CONN_ATTRS 13
@@ -268,6 +270,402 @@ struct iscsi_endpoint *iscsi_lookup_endp
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
+
+/*
+ * BSG support
+ */
+
+/**
+ * iscsi_destroy_bsgjob - routine to teardown/delete a iscsi bsg job
+ * @job:	iscsi_bsg_job that is to be torn down
+ */
+static void
+iscsi_destroy_bsgjob(struct iscsi_bsg_job *job)
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
+/**
+ * iscsi_bsg_jobdone - completion routine for bsg requests that the LLD
has
+ *                  completed
+ * @job:	iscsi_bsg_job that is complete
+ */
+static void
+iscsi_bsg_jobdone(struct iscsi_bsg_job *job)
+{
+	struct request *req = job->req;
+	struct request *rsp = req->next_rq;
+	int err;
+
+	err = job->req->errors = job->reply->result;
+
+	if (err < 0)
+		/* we're only returning the result field in the reply */
+		job->req->sense_len = sizeof(uint32_t);
+	else
+		job->req->sense_len = job->reply_len;
+
+	/* we assume all request payload was transferred, residual == 0 */
+	req->resid_len = 0;
+
+	if (rsp) {
+		WARN_ON(job->reply->reply_payload_rcv_len > rsp->resid_len);
+
+		/* set reply (bidi) residual */
+		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
+				      rsp->resid_len);
+	}
+	blk_complete_request(req);
+}
+
+/**
+ * iscsi_bsg_softirq_done - softirq done routine for destroying the bsg
requests
+ * @rq:        BSG request that holds the job to be destroyed
+ */
+static void
+iscsi_bsg_softirq_done(struct request *rq)
+{
+	struct iscsi_bsg_job *job = rq->special;
+	unsigned long flags;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	job->state_flags |= ISCSI_RQST_STATE_DONE;
+	job->ref_cnt--;
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	blk_end_request_all(rq, rq->errors);
+	iscsi_destroy_bsgjob(job);
+}
+
+/**
+ * iscsi_bsg_job_timeout - handler for when a bsg request timesout
+ * @req:	request that timed out
+ */
+static enum blk_eh_timer_return
+iscsi_bsg_job_timeout(struct request *req)
+{
+	struct iscsi_bsg_job *job = (void *) req->special;
+	struct Scsi_Host *shost = job->shost;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	unsigned long flags;
+	int err = 0, done = 0;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	if (job->state_flags & ISCSI_RQST_STATE_DONE)
+		done = 1;
+	else
+		job->ref_cnt++;
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	if (!done && i->iscsi_transport->bsg_timeout) {
+		/* call LLDD to abort the i/o as it has timed out */
+		err = i->iscsi_transport->bsg_timeout(job);
+		if (err)
+			printk(KERN_ERR "ERROR: iSCSI BSG request timeout - "
+				"LLD abort failed with status %d\n", err);
+	}
+
+	/* the blk_end_sync_io() doesn't check the error */
+	if (done)
+		return BLK_EH_NOT_HANDLED;
+	else
+		return BLK_EH_HANDLED;
+}
+
+static int
+iscsi_bsg_map_buffer(struct iscsi_bsg_buffer *buf, struct request *req)
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
+	buf->payload_len = blk_rq_bytes(req);
+	return 0;
+}
+
+/**
+ * iscsi_req_to_bsgjob - Allocate/create the iscsi_bsg_job structure
for the
+ *                   bsg request
+ * @req:	BSG request that needs a job structure
+ * @shost:	SCSI Host corresponding to the bsg object
+ */
+static int
+iscsi_req_to_bsgjob(struct request *req, struct Scsi_Host *shost)
+{
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	struct request *rsp = req->next_rq;
+	struct iscsi_bsg_job *job;
+	int ret;
+
+	BUG_ON(req->special);
+
+	job = kzalloc(sizeof(struct iscsi_bsg_job) +
+				 i->iscsi_transport->dd_bsg_size, GFP_KERNEL);
+	if (!job)
+		return -ENOMEM;
+
+	/*
+	 * Note: this is a bit silly.
+	 * The request gets formatted as a SGIO v4 ioctl request, which
+	 * then gets reformatted as a blk request, which then gets
+	 * reformatted as a iscsi bsg request. And on completion, we have
+	 * to wrap return results such that SGIO v4 thinks it was a scsi
+	 * status.  I hope this was all worth it.
+	 */
+
+	req->special = job;
+	job->shost = shost;
+	job->req = req;
+	if (i->iscsi_transport->dd_bsg_size)
+		job->dd_data = (void *)&job[1];
+	spin_lock_init(&job->job_lock);
+	job->request = (struct iscsi_bsg_request *)req->cmd;
+	job->request_len = req->cmd_len;
+	job->reply = req->sense;
+	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
+						 * allocated */
+	if (req->bio) {
+		ret = iscsi_bsg_map_buffer(&job->request_payload, req);
+		if (ret)
+			goto failjob_rls_job;
+	}
+	if (rsp && rsp->bio) {
+		ret = iscsi_bsg_map_buffer(&job->reply_payload, rsp);
+		if (ret)
+			goto failjob_rls_rqst_payload;
+	}
+	job->job_done = iscsi_bsg_jobdone;
+	job->dev = &shost->shost_gendev;
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
+enum iscsi_dispatch_result {
+	DISPATCH_BREAK,		/* on return, q is locked, break from q loop */
+	DISPATCH_LOCKED,	/* on return, q is locked, continue on */
+	DISPATCH_UNLOCKED,	/* on return, q is unlocked, continue on */
+};
+
+/**
+ * iscsi_bsg_host_dispatch - process iscsi host bsg requests and
+ *                           dispatch to LLDD
+ * @q:		iscsi host request queue
+ * @shost:	scsi host request queue attached to
+ * @job:	bsg job to be processed
+ */
+static enum iscsi_dispatch_result
+iscsi_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host
*shost,
+			 struct iscsi_bsg_job *job)
+{
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	int ret;
+
+	/* Validate the host command */
+	switch (job->request->msgcode) {
+	case ISCSI_BSG_HST_VENDOR:
+		cmdlen += sizeof(struct iscsi_bsg_host_vendor);
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
+	ret = i->iscsi_transport->bsg_request(job);
+	if (!ret)
+		return DISPATCH_UNLOCKED;
+
+fail_host_msg:
+	/* return the errno failure code as the only status */
+	BUG_ON(job->reply_len < sizeof(uint32_t));
+	job->reply->result = ret;
+	job->reply_len = sizeof(uint32_t);
+	iscsi_bsg_jobdone(job);
+	return DISPATCH_UNLOCKED;
+}
+
+/**
+ * iscsi_bsg_request_handler - generic handler for bsg requests
+ * @q:		request queue to manage
+ * @shost:	Scsi_Host related to the bsg object
+ * @dev:	device structure for bsg object
+ *
+ * NOTE: only shost messages are expected
+ */
+static void
+iscsi_bsg_request_handler(struct request_queue *q, struct Scsi_Host
*shost,
+			struct device *dev)
+{
+	struct request *req;
+	struct iscsi_bsg_job *job;
+	enum iscsi_dispatch_result ret;
+
+	if (!get_device(dev))
+		return;
+
+	while (!blk_queue_plugged(q)) {
+
+		req = blk_fetch_request(q);
+		if (!req)
+			break;
+
+		spin_unlock_irq(q->queue_lock);
+
+		ret = iscsi_req_to_bsgjob(req, shost);
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
+			iscsi_bsg_jobdone(job);
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
+		/* the dispatch routines will unlock the queue_lock */
+		iscsi_bsg_host_dispatch(q, shost, job);
+
+		/* did dispatcher hit state that can't process any more */
+		if (ret == DISPATCH_BREAK)
+			break;
+
+		/* did dispatcher had released the lock */
+		if (ret == DISPATCH_UNLOCKED)
+			spin_lock_irq(q->queue_lock);
+	}
+
+	spin_unlock_irq(q->queue_lock);
+	put_device(dev);
+	spin_lock_irq(q->queue_lock);
+}
+
+/**
+ * iscsi_bsg_host_handler - handler for bsg requests for a iscsi host
+ * @q:		iscsi host request queue
+ */
+static void
+iscsi_bsg_host_handler(struct request_queue *q)
+{
+	struct Scsi_Host *shost = q->queuedata;
+
+	iscsi_bsg_request_handler(q, shost, &shost->shost_gendev);
+}
+
+/**
+ * iscsi_bsg_hostadd - Create and add the bsg hooks so we can receive
requests
+ * @shost:	shost for iscsi_host
+ * @cls_host:	iscsi_cls_host adding the structures to
+ */
+static int
+iscsi_bsg_hostadd(struct Scsi_Host *shost, struct iscsi_cls_host
*ihost)
+{
+	struct device *dev = &shost->shost_gendev;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	struct request_queue *q;
+	int err;
+	char bsg_name[20];
+
+	ihost->rqst_q = NULL;
+
+	if (!i->iscsi_transport->bsg_request)
+		return -ENOTSUPP;
+
+	snprintf(bsg_name, sizeof(bsg_name),
+		 "iscsi_host%d", shost->host_no);
+
+	q = __scsi_alloc_queue(shost, iscsi_bsg_host_handler);
+	if (!q) {
+		printk(KERN_ERR "iscsi_host%d: bsg interface failed to "
+				"initialize - no request queue\n",
+				 shost->host_no);
+		return -ENOMEM;
+	}
+
+	q->queuedata = shost;
+	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	blk_queue_softirq_done(q, iscsi_bsg_softirq_done);
+	blk_queue_rq_timed_out(q, iscsi_bsg_job_timeout);
+	blk_queue_rq_timeout(q, ISCSI_DEFAULT_BSG_TIMEOUT);
+
+	err = bsg_register_queue(q, dev, bsg_name, NULL);
+	if (err) {
+		printk(KERN_ERR "iscsi_host%d: bsg interface failed to "
+				"initialize - register queue\n",
+				shost->host_no);
+		blk_cleanup_queue(q);
+		return err;
+	}
+
+	ihost->rqst_q = q;
+	return 0;
+}
+
+/**
+ * iscsi_bsg_remove - Deletes the bsg hooks on iscsi objects
+ * @q:	the request_queue that is to be torn down.
+ */
+static void
+iscsi_bsg_remove(struct request_queue *q)
+{
+	if (q) {
+		bsg_unregister_queue(q);
+		blk_cleanup_queue(q);
+	}
+}
+
+/* End BSG routines */
+
 static int iscsi_setup_host(struct transport_container *tc, struct
device *dev,
 			    struct device *cdev)
 {
@@ -277,13 +675,27 @@ static int iscsi_setup_host(struct trans
 	memset(ihost, 0, sizeof(*ihost));
 	atomic_set(&ihost->nr_scans, 0);
 	mutex_init(&ihost->mutex);
+
+	iscsi_bsg_hostadd(shost, ihost);
+	/* ignore any bsg add error - we just can't do sgio */
+
+	return 0;
+}
+
+static int iscsi_remove_host(struct transport_container *tc, struct
device *dev,
+			 struct device *cdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+
+	iscsi_bsg_remove(ihost->rqst_q);
 	return 0;
 }
 
 static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
 			       "iscsi_host",
 			       iscsi_setup_host,
-			       NULL,
+			       iscsi_remove_host,
 			       NULL);
 
 static DECLARE_TRANSPORT_CLASS(iscsi_session_class,
diff -upNr a/include/scsi/Kbuild b/include/scsi/Kbuild
--- a/include/scsi/Kbuild	2009-10-26 12:58:28.000000000 -0400
+++ b/include/scsi/Kbuild	2009-10-28 09:17:36.000000000 -0400
@@ -2,3 +2,4 @@ header-y += scsi.h
 header-y += scsi_netlink.h
 header-y += scsi_netlink_fc.h
 header-y += scsi_bsg_fc.h
+header-y += scsi_bsg_iscsi.h
diff -upNr a/include/scsi/scsi_bsg_iscsi.h
b/include/scsi/scsi_bsg_iscsi.h
--- a/include/scsi/scsi_bsg_iscsi.h	1969-12-31 19:00:00.000000000 -0500
+++ b/include/scsi/scsi_bsg_iscsi.h	2009-10-29 14:29:31.000000000 -0400
@@ -0,0 +1,111 @@
+/*
+ *  iSCSI Transport BSG Interface
+ *
+ *  Copyright (C) 2009   James Smart, Emulex Corporation
+ *
+ *  This program is free software; you can redistribute it and/or
modify
+ *  it under the terms of the GNU General Public License as published
by
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
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
02111-1307  USA
+ *
+ */
+
+#ifndef SCSI_BSG_ISCSI_H
+#define SCSI_BSG_ISCSI_H
+
+/*
+ * This file intended to be included by both kernel and user space
+ */
+
+#include <scsi/scsi.h>
+
+/*
+ * iSCSI Transport SGIO v4 BSG Message Support
+ */
+
+/* Default BSG request timeout (in seconds) */
+#define ISCSI_DEFAULT_BSG_TIMEOUT	(10 * HZ)
+
+
+/*
+ * Request Message Codes supported by the iSCSI Transport
+ */
+
+/* define the class masks for the message codes */
+#define ISCSI_BSG_CLS_MASK	0xF0000000	/* find object class */
+#define ISCSI_BSG_HST_MASK	0x80000000	/* iscsi host class */
+
+	/* iscsi host Message Codes */
+#define ISCSI_BSG_HST_VENDOR		(ISCSI_BSG_HST_MASK | 0x000000FF)
+
+
+/*
+ * iSCSI Host Messages
+ */
+
+/* ISCSI_BSG_HST_VENDOR : */
+
+/* Request:
+ * Note: When specifying vendor_id, be sure to read the Vendor Type and
ID
+ *   formatting requirements specified in scsi_netlink.h
+ */
+struct iscsi_bsg_host_vendor {
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
+struct iscsi_bsg_host_vendor_reply {
+	/* start of vendor response area */
+	uint32_t vendor_rsp[0];
+};
+
+
+/* request (CDB) structure of the sg_io_v4 */
+struct iscsi_bsg_request {
+	uint32_t msgcode;
+	union {
+		struct iscsi_bsg_host_vendor	h_vendor;
+	} rqst_data;
+};
+
+
+/* response (request sense data) structure of the sg_io_v4 */
+struct iscsi_bsg_reply {
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
+		struct iscsi_bsg_host_vendor_reply	vendor_reply;
+	} reply_data;
+};
+
+
+#endif /* SCSI_BSG_ISCSI_H */
+
diff -upNr a/include/scsi/scsi_transport_iscsi.h
b/include/scsi/scsi_transport_iscsi.h
--- a/include/scsi/scsi_transport_iscsi.h	2009-10-26 12:58:28.000000000
-0400
+++ b/include/scsi/scsi_transport_iscsi.h	2009-10-29 14:55:04.000000000
-0400
@@ -37,6 +37,45 @@ struct iscsi_conn;
 struct iscsi_task;
 struct sockaddr;
 
+struct iscsi_bsg_buffer {
+	unsigned int payload_len;
+	int sg_cnt;
+	struct scatterlist *sg_list;
+};
+
+/* Values for iscsi_bsg_job->state_flags (bitflags) */
+#define ISCSI_RQST_STATE_INPROGRESS	0
+#define ISCSI_RQST_STATE_DONE		1
+
+struct iscsi_bsg_job {
+	struct Scsi_Host *shost;
+	struct device *dev;
+	struct request *req;
+	spinlock_t job_lock;
+	unsigned int state_flags;
+	unsigned int ref_cnt;
+	void (*job_done)(struct iscsi_bsg_job *);
+
+	struct iscsi_bsg_request *request;
+	struct iscsi_bsg_reply *reply;
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
+	struct iscsi_bsg_buffer request_payload;
+	struct iscsi_bsg_buffer reply_payload;
+
+	void *dd_data;			/* Used for driver-specific storage */
+};
+
 /**
  * struct iscsi_transport - iSCSI Transport template
  *
@@ -134,6 +173,11 @@ struct iscsi_transport {
 	int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
 			  uint32_t enable, struct sockaddr *dst_addr);
 	int (*set_path) (struct Scsi_Host *shost, struct iscsi_path *params);
+
+	/* bsg support */
+	int	(*bsg_request)(struct iscsi_bsg_job *);
+	int	(*bsg_timeout)(struct iscsi_bsg_job *);
+	u32	dd_bsg_size;	/* allocation length for host-specific data */
 };
 
 /*
@@ -212,6 +256,7 @@ struct iscsi_cls_session {
 struct iscsi_cls_host {
 	atomic_t nr_scans;
 	struct mutex mutex;
+	struct request_queue *rqst_q;	/* bsg support */
 };
 
 extern void iscsi_host_for_each_session(struct Scsi_Host *shost,


