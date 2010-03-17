From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/2] RFC: Proposal for BSG Interface
Date: Wed, 17 Mar 2010 23:36:09 +0530
Message-ID: <20100317180557.GA25841@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:59026 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755322Ab0CQSGH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 14:06:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu, open-iscsi@googlegroups.com

  This patch contains the bsg interface based on
the bsg interface in FC.

Developed and submitted earlier by James Smart.

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/scsi_transport_iscsi.c |  459 ++++++++++++++++++++++++++++++++++-
 include/scsi/Kbuild                 |    1 +
 include/scsi/scsi_bsg_iscsi.h       |  253 +++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |   47 ++++
 4 files changed, 759 insertions(+), 1 deletions(-)
 create mode 100644 include/scsi/scsi_bsg_iscsi.h

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ea3892e..2b7218c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -29,6 +29,8 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
+#include <scsi/scsi_bsg_iscsi.h>
+#include <scsi/scsi_cmnd.h>
 
 #define ISCSI_SESSION_ATTRS 22
 #define ISCSI_CONN_ATTRS 13
@@ -268,6 +270,447 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
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
+ * iscsi_bsg_jobdone - completion routine for bsg requests that the LLD has
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
+ * iscsi_bsg_softirq_done - softirq done routine for destroying the bsg requests
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
+		if (err == -EAGAIN) {
+			job->ref_cnt--;
+			return BLK_EH_RESET_TIMER;
+		} else if (err)
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
+ * iscsi_req_to_bsgjob - Allocate/create the iscsi_bsg_job structure for the
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
+iscsi_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
+			 struct iscsi_bsg_job *job)
+{
+	unsigned char *pdata;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	int ret, num;
+	unsigned int tot_len = 0;
+	struct scatterlist *sge = NULL;
+
+	/* Validate the host command */
+	job->request_payload.va = NULL;
+	switch (job->request->msgcode) {
+	case ISCSI_BSG_HST_NET_CONFIG:
+		cmdlen += sizeof(struct iscsi_bsg_host_net_config);
+		/*
+		 * Validate set ops have a request payload.
+		 * Get ops are allowed to have none/partial/all reply payloads
+		 */
+		if ((job->request->rqst_data.h_netconfig.set_op) &&
+		    (!job->request_payload.payload_len)) {
+			ret = -EINVAL;
+			goto fail_host_msg;
+		}
+		tot_len = 0;
+		for_each_sg(job->request_payload.sg_list, sge,
+			    job->request_payload.sg_cnt, num) {
+			tot_len += sge->length;
+		}
+
+		job->request_payload.va =  kmalloc(tot_len, GFP_KERNEL);
+		if (job->request_payload.va == NULL) {
+			ret = -EINVAL;
+			goto fail_host_msg;
+		}
+		pdata = job->request_payload.va;
+		job->request_payload.size = tot_len;
+		for_each_sg(job->request_payload.sg_list, sge,
+				 job->request_payload.sg_cnt, num) {
+			memcpy(pdata, sg_virt(sge), sge->length);
+			pdata += sge->length;
+
+		}
+		break;
+
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
+	if (!ret) {
+		kfree(job->request_payload.va);
+		return DISPATCH_UNLOCKED;
+	}
+
+fail_host_msg:
+	kfree(job->request_payload.va);
+
+	/* return the errno failure code as the only status */
+	BUG_ON(job->reply_len < sizeof(uint32_t));
+	job->reply->reply_payload_rcv_len = 0;
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
+iscsi_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
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
+			job->reply->reply_payload_rcv_len = 0;
+			job->reply->result = -ENOMSG;
+			job->reply_len = sizeof(uint32_t);
+			iscsi_bsg_jobdone(job);
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
+		/* the dispatch routines will unlock the queue_lock */
+		ret = iscsi_bsg_host_dispatch(q, shost, job);
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
+ * iscsi_bsg_hostadd - Create and add the bsg hooks so we can receive requests
+ * @shost:	shost for iscsi_host
+ * @cls_host:	iscsi_cls_host adding the structures to
+ */
+static int
+iscsi_bsg_hostadd(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
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
 static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 			    struct device *cdev)
 {
@@ -277,13 +720,27 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
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
+static int iscsi_remove_host(struct transport_container *tc, struct device *dev,
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
diff --git a/include/scsi/Kbuild b/include/scsi/Kbuild
index b3a0ee6..f513500 100644
--- a/include/scsi/Kbuild
+++ b/include/scsi/Kbuild
@@ -2,4 +2,5 @@ header-y += scsi.h
 header-y += scsi_netlink.h
 header-y += scsi_netlink_fc.h
 header-y += scsi_bsg_fc.h
+header-y += scsi_bsg_iscsi.h
 header-y += fc/
diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
new file mode 100644
index 0000000..10c91c3
--- /dev/null
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -0,0 +1,253 @@
+/*
+ *  iSCSI Transport BSG Interface
+ *
+ *  Copyright (C) 2009   James Smart, Emulex Corporation
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
+#define	ISCSI_BSG_HST_NET_CONFIG	(ISCSI_BSG_HST_MASK | 0x00000001)
+#define ISCSI_BSG_HST_VENDOR		(ISCSI_BSG_HST_MASK | 0x000000FF)
+
+#define ISCSI_SET_IP_ADDR		1
+#define ISCSI_SET_DEFAULT_GATEWAY	2
+#define ISCSI_SET_VLAN			3
+#define ISCSI_SET_HBA_NAME		4
+#define ISCSI_CONFIGURE_STATELESS_IP	5
+#define ISCSI_GET_HBA_NAME		6
+#define ISCSI_GET_IF_INFO		7
+#define ISCSI_GET_DEFAULT_GATEWAY	8
+
+/*
+ * iSCSI Host Messages
+ */
+
+struct ip_address_subnet_format {
+	u16 sizeofstructure;
+	u8  iptype;
+	u8  ipv6_prefix_length;
+	u8  ipaddress[16];
+	u8  subnetmask[16];
+	u32 rsvd0;
+} __packed;
+
+struct iscsi_ip_addr_record {
+	u32  action;
+	u32  interface_hndl;
+	struct ip_address_subnet_format ip_address;
+	u32  status;
+} __packed;
+
+struct iscsi_ip_addr_record_params {
+	u32 record_entry_count;
+	struct iscsi_ip_addr_record ip_record[1];
+} __packed;
+
+struct ip_address_format {
+	u16	sizeofstructure;
+	u8	reserved;
+	u8	ip_type;
+	u8	ip_address[16];
+	u32	rsvd0;
+} __packed;
+
+struct iscsi_bsg_common_format {
+	u8 opcode;		/* dword 0 */
+	u8 subsystem;		/* dword 0 */
+	u8 port_number;		/* dword 0 */
+	u8 domain;		/* dword 0 */
+	u32 timeout;		/* dword 1 */
+	u32 request_length;	/* dword 2 */
+	u32 rsvd0;		/* dword 3 */
+	u32    action;
+	struct ip_address_format gateway;
+	u32  interface_hndl;
+	u32  vlan_priority;
+	u32  flags;
+	u8   iscsiname[224];
+	u8   iscsialias[32];
+	u32  ip_type;
+	u32  retry_count;
+	struct iscsi_ip_addr_record_params ip_params;
+} __packed;
+
+/* ISCSI_BSG_HST_NET_CONFIG : */
+
+/* bsg network parameter ids */
+enum iscsi_bsg_netparam {
+	BSG_NETPARAM_UNKNOWN		= 0x00000000,
+	BSG_NETPARAM_MAC		= BSG_NETPARAM_UNKNOWN + 1,
+	BSG_NETPARAM_MTU		= BSG_NETPARAM_UNKNOWN + 2,
+	BSG_NETPARAM_VLAN		= BSG_NETPARAM_UNKNOWN + 3,
+	BSG_NETPARAM_BOOTPROTO		= BSG_NETPARAM_UNKNOWN + 4,
+	BSG_NETPARAM_IPV4_ADDR		= BSG_NETPARAM_UNKNOWN + 5,
+	BSG_NETPARAM_IPV4_MASK		= BSG_NETPARAM_UNKNOWN + 6,
+	BSG_NETPARAM_IPV4_GW		= BSG_NETPARAM_UNKNOWN + 7,
+	BSG_NETPARAM_IPV6_ADDR		= BSG_NETPARAM_UNKNOWN + 8,
+	BSG_NETPARAM_IPV6_MASK		= BSG_NETPARAM_UNKNOWN + 9,
+	BSG_NETPARAM_IPV6_GW		= BSG_NETPARAM_UNKNOWN + 10,
+	BSG_NETPARAM_IPV6_AUTO_PARAM	= BSG_NETPARAM_UNKNOWN + 11,
+};
+
+/* network parameter TLV (type, length, value) structure */
+struct iscsi_bsg_netparam_tlv {
+	uint32_t	netparam;
+	uint32_t	length;
+	uint8_t		value[1];
+};
+
+/* Request:
+ * This message sets or gets Network configuration parameters on/from the
+ * iscsi host network interface.
+ *
+ * On set operations, the request payload buffer contains a set of
+ * netparam tlv's with the values to be set.
+ *
+ * On get operations, the request payload is unused.
+ */
+struct iscsi_bsg_host_net_config {
+	/*
+	 * Specifies the operation type:  0x0 = GET;  0x1 = SET
+	 */
+	uint8_t		set_op;
+
+	/*
+	 * If SET operation, contains the total number of netparam tlv's
+	 * in the request payload.
+	 */
+	uint8_t		netparam_count;
+};
+
+/* Response:
+ *
+ * On set operations, the response structure will specify the number of
+ * successfully processed netparam TLVs from the request payload.
+ * The reply payload will contain (as many as can fit) the successfully
+ * processed TLVs and their new values.
+ *
+ * On get operations, the response structure will specify the total
+ * number of netparam TLVs supported on the iscsi host network interface,
+ * and the reply payload size that is required to obtain the entire
+ * TLV list.  The reply payload will contain (as many as can fit) the
+ * TLV's supported on the iscsi host network interface.
+ *
+ * Note: Reply payloads will be truncated to whole TLVs that fit within
+ * the specified reply payload size.
+ *
+ */
+struct iscsi_bsg_host_net_config_reply {
+	/*
+	 * On SET operations: contains the number of successfully
+	 * processed netparam TLV elements.
+	 *
+	 * On GET operations: contains the total number of netparams
+	 * that are supported on the iscsi host network interface.
+	 */
+	uint8_t		netparam_count;
+
+	/*
+	 * On GET operations: specifies the size of the reply payload
+	 * that is required to obtain the entire list of netparam TLVs.
+	 */
+	uint32_t	netparam_payload_len;
+};
+
+
+/* ISCSI_BSG_HST_VENDOR : */
+
+/* Request:
+ * Note: When specifying vendor_id, be sure to read the Vendor Type and ID
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
+		struct iscsi_bsg_host_net_config	h_netconfig;
+		struct iscsi_bsg_host_vendor		h_vendor;
+	} rqst_data;
+} __attribute__((packed));
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
+		struct iscsi_bsg_host_net_config_reply	h_netconfig_reply;
+	} reply_data;
+};
+
+
+#endif /* SCSI_BSG_ISCSI_H */
+
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 349c7f3..30a07ee 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -37,6 +37,47 @@ struct iscsi_conn;
 struct iscsi_task;
 struct sockaddr;
 
+struct iscsi_bsg_buffer {
+	unsigned int payload_len;
+	int sg_cnt;
+	struct scatterlist *sg_list;
+	void *va;
+	unsigned int size;
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
@@ -134,6 +175,11 @@ struct iscsi_transport {
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
@@ -212,6 +258,7 @@ struct iscsi_cls_session {
 struct iscsi_cls_host {
 	atomic_t nr_scans;
 	struct mutex mutex;
+	struct request_queue *rqst_q;	/* bsg support */
 };
 
 extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
-- 
1.6.4

