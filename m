From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] RFC: scsi bsg: add scsi bsg helper lib
Date: Sat, 10 Apr 2010 05:17:39 -0500
Message-ID: <1270894661-28402-3-git-send-email-michaelc@cs.wisc.edu>
References: <1270894661-28402-1-git-send-email-michaelc@cs.wisc.edu>
 <1270894661-28402-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab0DJKRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2010 06:17:53 -0400
In-Reply-To: <1270894661-28402-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This moves the FC class bsg code to a scsi lib, so
all drivers and classes do not have to duplicate common
bits.

Patch is only compile tested.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/Kconfig    |    7 +
 drivers/scsi/Makefile   |    1 +
 drivers/scsi/scsi_bsg.c |  358 +++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_bsg.h |  102 ++++++++++++++
 4 files changed, 468 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/scsi_bsg.c
 create mode 100644 include/scsi/scsi_bsg.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 75f2336..9bde1f5 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -47,6 +47,11 @@ config SCSI_TGT
 	  If you want to use SCSI target mode drivers enable this option.
 	  If you choose M, the module will be called scsi_tgt.
 
+config SCSI_BSG
+	bool
+	default	n
+	select BLK_DEV_BSG
+
 config SCSI_NETLINK
 	bool
 	default	n
@@ -294,6 +299,7 @@ config SCSI_FC_ATTRS
 	tristate "FiberChannel Transport Attributes"
 	depends on SCSI
 	select SCSI_NETLINK
+	select SCSI_BSG
 	help
 	  If you wish to export transport-specific information about
 	  each attached FiberChannel device to sysfs, say Y.
@@ -309,6 +315,7 @@ config SCSI_FC_TGT_ATTRS
 config SCSI_ISCSI_ATTRS
 	tristate "iSCSI Transport Attributes"
 	depends on SCSI && NET
+	select SCSI_BSG
 	help
 	  If you wish to export transport-specific information about
 	  each attached iSCSI device to sysfs, say Y.
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 92a8c50..5895a36 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -159,6 +159,7 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
 scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
+scsi_mod-$(CONFIG_SCSI_BSG)	+= scsi_bsg.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
new file mode 100644
index 0000000..c3124bf
--- /dev/null
+++ b/drivers/scsi/scsi_bsg.c
@@ -0,0 +1,358 @@
+/*
+ *  BSG helper library for scsi classes
+ *
+ *  Copyright (C) 2008   James Smart, Emulex Corporation
+ *  Copyright (C) 2010   Red Hat, Inc.  All rights reserved.
+ *  Copyright (C) 2010   Mike Christie
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
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <scsi/scsi_bsg.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+
+/**
+ * scsi_destroy_bsgjob - routine to teardown/delete a bsg job
+ * @job: scsi_bsg_job that is to be torn down
+ */
+static void scsi_destroy_bsgjob(struct scsi_bsg_job *job)
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
+ * scsi_bsg_job_done - completion routine for bsg requests
+ * @job: scsi_bsg_job that is complete
+ * @result: job reply result
+ * @reply_payload_rcv_len: length of payload recvd
+ */
+void scsi_bsg_job_done(struct scsi_bsg_job *job, int result,
+		       unsigned int reply_payload_rcv_len)
+{
+	struct request *req = job->req;
+	struct request *rsp = req->next_rq;
+	int err;
+
+	err = job->req->errors = result;
+	if (err < 0)
+		/* we're only returning the result field in the reply */
+		job->req->sense_len = sizeof(u32);
+	else
+		job->req->sense_len = job->reply_len;
+	/* we assume all request payload was transferred, residual == 0 */
+	req->resid_len = 0;
+
+	if (rsp) {
+		WARN_ON(reply_payload_rcv_len > rsp->resid_len);
+
+		/* set reply (bidi) residual */
+		rsp->resid_len -= min(reply_payload_rcv_len, rsp->resid_len);
+	}
+	blk_complete_request(req);
+}
+EXPORT_SYMBOL_GPL(scsi_bsg_job_done);
+
+/**
+ * scsi_bsg_softirq_done - softirq done routine for destroying the bsg requests
+ * @rq: BSG request that holds the job to be destroyed
+ */
+static void scsi_bsg_softirq_done(struct request *rq)
+{
+	struct scsi_bsg_job *job = rq->special;
+	unsigned long flags;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	job->state_flags |= SCSI_RQST_STATE_DONE;
+	job->ref_cnt--;
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	blk_end_request_all(rq, rq->errors);
+	scsi_destroy_bsgjob(job);
+}
+
+/**
+ * scsi_bsg_job_timeout - handler for when a bsg request timesout
+ * @req: request that timed out
+ */
+static enum blk_eh_timer_return scsi_bsg_job_timeout(struct request *req)
+{
+	struct scsi_bsg_job *job = req->special;
+	struct Scsi_Host *shost = job->shost;
+	unsigned long flags;
+	int err = 0, done = 0;
+
+	spin_lock_irqsave(&job->job_lock, flags);
+	if (job->state_flags & SCSI_RQST_STATE_DONE)
+		done = 1;
+	else
+		job->ref_cnt++;
+	spin_unlock_irqrestore(&job->job_lock, flags);
+
+	if (!done && shost->transportt->eh_bsg_timed_out) {
+		/* call LLDD to abort the i/o as it has timed out */
+		err = shost->transportt->eh_bsg_timed_out(req);
+		if (err == -EAGAIN) {
+			job->ref_cnt--;
+			return BLK_EH_RESET_TIMER;
+		} else if (err)
+			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
+				"abort failed with status %d\n", err);
+	}
+
+	/* the blk_end_sync_io() doesn't check the error */
+	if (done)
+		return BLK_EH_NOT_HANDLED;
+	else
+		return BLK_EH_HANDLED;
+}
+
+static int scsi_bsg_map_buffer(struct scsi_bsg_buffer *buf, struct request *req)
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
+ * scsi_bsg_req_to_job - create the scsi_bsg_job structure for the bsg request
+ * @shost: SCSI Host corresponding to the bsg object
+ * @dev: device that is being sent the bsg request
+ * @req: BSG request that needs a job structure
+ * @transport_bsg_size: Size of transport private data for bsg req
+ * @dd_bsg_size: Size of LLD private data for bsg req if needed
+ */
+int scsi_bsg_req_to_job(struct Scsi_Host *shost, struct device *dev,
+			struct request *req, int transport_bsg_size,
+			int dd_bsg_size)
+{
+	struct request *rsp = req->next_rq;
+	struct scsi_bsg_job *job;
+	int ret;
+
+	BUG_ON(req->special);
+
+	job = kzalloc(sizeof(struct scsi_bsg_job) + transport_bsg_size +
+		      dd_bsg_size, GFP_KERNEL);
+	if (!job)
+		return -ENOMEM;
+
+	/*
+	 * Note: this is a bit silly.
+	 * The request gets formatted as a SGIO v4 ioctl request, which
+	 * then gets reformatted as a blk request, which then gets
+	 * reformatted as a scsi bsg request. And on completion, we have
+	 * to wrap return results such that SGIO v4 thinks it was a scsi
+	 * status.  I hope this was all worth it.
+	 */
+
+	req->special = job;
+	job->shost = shost;
+	job->req = req;
+	if (dd_bsg_size)
+		job->dd_data = (void *)&job[1];
+	if (transport_bsg_size)
+		job->transport_data = (void *)&job[1] + dd_bsg_size;
+	spin_lock_init(&job->job_lock);
+	job->request = req->cmd;
+	job->request_len = req->cmd_len;
+	job->reply = req->sense;
+	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
+						 * allocated */
+	if (req->bio) {
+		ret = scsi_bsg_map_buffer(&job->request_payload, req);
+		if (ret)
+			goto failjob_rls_job;
+	}
+	if (rsp && rsp->bio) {
+		ret = scsi_bsg_map_buffer(&job->reply_payload, rsp);
+		if (ret)
+			goto failjob_rls_rqst_payload;
+	}
+	job->job_done = scsi_bsg_job_done;
+	job->dev = dev;
+	/* take a reference for the request */
+	get_device(job->dev);
+	job->ref_cnt = 1;
+	return 0;
+
+failjob_rls_rqst_payload:
+	kfree(job->request_payload.sg_list);
+failjob_rls_job:
+	kfree(job);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(scsi_bsg_req_to_job);
+
+/*
+ * scsi_bsg_goose_queue - restart queue in case it was stopped
+ * @dev: device that owns queue
+ * @q: request q to be restarted
+ */
+void scsi_bsg_goose_queue(struct device *dev, struct request_queue *q)
+{
+	int flagset;
+	unsigned long flags;
+
+	if (!q)
+		return;
+
+	get_device(dev);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
+		  !test_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
+	if (flagset)
+		queue_flag_set(QUEUE_FLAG_REENTER, q);
+	__blk_run_queue(q);
+	if (flagset)
+		queue_flag_clear(QUEUE_FLAG_REENTER, q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	put_device(dev);
+}
+EXPORT_SYMBOL_GPL(scsi_bsg_goose_queue);
+
+/**
+ * scsi_bsg_request_handler - generic handler for bsg requests
+ * @q: request queue to manage
+ * @shost: Scsi_Host related to the bsg object
+ * @dev: device structure for bsg object
+ * @create_bsg_job: function to create job struct
+ *
+ * On error the create_bsg_job function should return a -Exyz error value
+ * that will be set to the req->errors.
+ */
+void
+scsi_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
+			 struct device *dev,
+			 int (*create_job)(struct Scsi_Host *shost,
+					   struct device *dev,
+					   struct request *req),
+			 enum scsi_dispatch_result (*dispatch_job) (
+						struct request_queue *q,
+						struct Scsi_Host *shost,
+						struct scsi_bsg_job *job))
+{
+	struct request *req;
+	struct scsi_bsg_job *job;
+	enum scsi_dispatch_result ret;
+
+	if (!get_device(dev))
+		return;
+
+	while (!blk_queue_plugged(q)) {
+		req = blk_fetch_request(q);
+		if (!req)
+			break;
+		spin_unlock_irq(q->queue_lock);
+
+		ret = create_job(shost, dev, req);
+		if (ret) {
+			req->errors = ret;
+			blk_end_request_all(req, ret);
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
+		job = req->special;
+		/* the dispatch routines will unlock the queue_lock */
+		ret = dispatch_job(q, shost, job);
+		/* did dispatcher hit state that can't process any more */
+		if (ret == SCSI_DISPATCH_BREAK)
+			break;
+
+		/* did dispatcher had released the lock */
+		if (ret == SCSI_DISPATCH_UNLOCKED)
+			spin_lock_irq(q->queue_lock);
+	}
+
+	spin_unlock_irq(q->queue_lock);
+	put_device(dev);
+	spin_lock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL_GPL(scsi_bsg_request_handler);
+
+/**
+ * scsi_bsg_add - Create and add the bsg hooks so we can receive requests
+ * @shost: shost that rport is attached to
+ * @dev: device to attach bsg device to
+ * @request_fn: bsg request handler
+ */
+struct request_queue *scsi_bsg_add(struct Scsi_Host *shost, struct device *dev,
+				   char *name, request_fn_proc *request_fn)
+{
+	struct request_queue *q;
+
+	q = __scsi_alloc_queue(shost, request_fn);
+	if (!q) {
+		printk(KERN_ERR "%s: bsg interface failed to "
+				"initialize - no request queue\n",
+				 dev->kobj.name);
+		return NULL;
+	}
+
+	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	blk_queue_softirq_done(q, scsi_bsg_softirq_done);
+	blk_queue_rq_timed_out(q, scsi_bsg_job_timeout);
+	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
+
+	if (bsg_register_queue(q, dev, name, NULL)) {
+		printk(KERN_ERR "%s: bsg interface failed to "
+		       "initialize - register queue\n", dev->kobj.name);
+		blk_cleanup_queue(q);
+		return NULL;
+	}
+
+	return q;
+}
+EXPORT_SYMBOL_GPL(scsi_bsg_add);
+
+/**
+ * scsi_bsg_remove - Deletes the bsg dev from the q
+ * @q:	the request_queue that is to be torn down.
+ */
+void scsi_bsg_remove(struct request_queue *q)
+{
+	if (q) {
+		bsg_unregister_queue(q);
+		blk_cleanup_queue(q);
+	}
+}
+EXPORT_SYMBOL_GPL(scsi_bsg_remove);
diff --git a/include/scsi/scsi_bsg.h b/include/scsi/scsi_bsg.h
new file mode 100644
index 0000000..9773a77
--- /dev/null
+++ b/include/scsi/scsi_bsg.h
@@ -0,0 +1,102 @@
+/*
+ *  BSG helper library for scsi classes
+ *
+ *  Copyright (C) 2008   James Smart, Emulex Corporation
+ *  Copyright (C) 2010   Red Hat, Inc.  All rights reserved.
+ *  Copyright (C) 2010   Mike Christie
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
+#ifndef _SCSI_BSG_
+#define _SCSI_BSG_
+
+struct Scsi_Host;
+struct request;
+struct device;
+struct scatterlist;
+struct request_queue;
+
+struct scsi_bsg_buffer {
+	unsigned int payload_len;
+	int sg_cnt;
+	struct scatterlist *sg_list;
+};
+
+/* Values for scsi_bsg_job->state_flags (bitflags) */
+#define SCSI_RQST_STATE_INPROGRESS	0
+#define SCSI_RQST_STATE_DONE		1
+
+enum scsi_dispatch_result {
+	SCSI_DISPATCH_BREAK,	/* on return, q is locked, break from q loop */
+	SCSI_DISPATCH_LOCKED,	/* on return, q is locked, continue on */
+	SCSI_DISPATCH_UNLOCKED,	/* on return, q is unlocked, continue on */
+};
+
+struct scsi_bsg_job {
+	struct Scsi_Host *shost;
+
+	struct device *dev;
+	struct request *req;
+	spinlock_t job_lock;
+	unsigned int state_flags;
+	unsigned int ref_cnt;
+
+	void (*job_done)(struct scsi_bsg_job *job, int result,
+			 unsigned int reply_payload_rcv_len);
+
+	/* Transport/driver specific request/reply structs */
+	void *request;
+	void *reply;
+
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
+	struct scsi_bsg_buffer request_payload;
+	struct scsi_bsg_buffer reply_payload;
+
+	void *dd_data;		/* Used for driver-specific storage */
+	void *transport_data;	/* Used for transport-specific storage */
+};
+
+void scsi_bsg_job_done(struct scsi_bsg_job *job, int result,
+		       unsigned int reply_payload_rcv_len);
+int scsi_bsg_req_to_job(struct Scsi_Host *shost, struct device *dev,
+			struct request *req, int transport_bsg_size,
+			int dd_bsg_size);
+struct request_queue *scsi_bsg_add(struct Scsi_Host *shost, struct device *dev,
+				   char *name, request_fn_proc *request_fn);
+void scsi_bsg_remove(struct request_queue *q);
+void scsi_bsg_goose_queue(struct device *dev, struct request_queue *q);
+void scsi_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
+			      struct device *dev,
+			      int (*create_bsg_job)(struct Scsi_Host *shost,
+						    struct device *dev,
+						    struct request *req),
+			      enum scsi_dispatch_result (*dispatch_job) (
+						struct request_queue *q,
+						struct Scsi_Host *shost,
+						struct scsi_bsg_job *job));
+
+#endif
-- 
1.6.6.1

