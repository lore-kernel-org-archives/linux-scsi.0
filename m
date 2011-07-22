From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 04/10] iscsi class: add bsg support to iscsi class
Date: Fri, 22 Jul 2011 05:04:54 -0500
Message-ID: <1311329100-2982-5-git-send-email-michaelc@cs.wisc.edu>
References: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab1GVKC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 06:02:29 -0400
In-Reply-To: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds bsg support to the iscsi class. There is only
1 request, the host vendor one, supported. It is expected that
this would be used for things like flash updates.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |  126 ++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_bsg_iscsi.h       |  110 ++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |    5 ++
 3 files changed, 240 insertions(+), 1 deletions(-)
 create mode 100644 include/scsi/scsi_bsg_iscsi.h

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 3fd16d7..7820940 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -31,6 +31,8 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_bsg_iscsi.h>
+#include <scsi/scsi_bsg.h>
 
 #define ISCSI_SESSION_ATTRS 23
 #define ISCSI_CONN_ATTRS 13
@@ -270,6 +272,112 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
+/*
+ * BSG support
+ */
+/**
+ * iscsi_bsg_job_timeout - handler for when a bsg request timesout
+ * @job: bsg job
+ */
+static int iscsi_bsg_job_timeout(struct scsi_bsg_job *job)
+{
+	struct Scsi_Host *shost = job->shost;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	int err = 0;
+
+	if (i->iscsi_transport->bsg_timeout)
+		err = i->iscsi_transport->bsg_timeout(job);
+	return err;
+}
+
+/**
+ * iscsi_bsg_host_dispatch - Dispatch command to LLD.
+ * @job:	bsg job to be processed
+ */
+static int iscsi_bsg_host_dispatch(struct scsi_bsg_job *job)
+{
+	struct Scsi_Host *shost = job->shost;
+	struct iscsi_bsg_request *req = job->request;
+	struct iscsi_bsg_reply *reply = job->reply;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	int ret;
+
+	/* check if we have the msgcode value at least */
+	if (job->request_len < sizeof(uint32_t)) {
+		ret = -ENOMSG;
+		goto fail_host_msg;
+	}
+
+	/* Validate the host command */
+	switch (req->msgcode) {
+	case ISCSI_BSG_HST_VENDOR:
+		cmdlen += sizeof(struct iscsi_bsg_host_vendor);
+		if ((shost->hostt->vendor_id == 0L) ||
+		    (req->rqst_data.h_vendor.vendor_id !=
+			shost->hostt->vendor_id)) {
+			ret = -ESRCH;
+			goto fail_host_msg;
+		}
+		break;
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
+		return 0;
+
+fail_host_msg:
+	/* return the errno failure code as the only status */
+	BUG_ON(job->reply_len < sizeof(uint32_t));
+	reply->reply_payload_rcv_len = 0;
+	reply->result = ret;
+	job->reply_len = sizeof(uint32_t);
+	scsi_bsg_job_done(job, ret, 0);
+	return 0;
+}
+
+/**
+ * iscsi_bsg_host_add - Create and add the bsg hooks to receive requests
+ * @shost: shost for iscsi_host
+ * @cls_host: iscsi_cls_host adding the structures to
+ */
+static int
+iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
+{
+	struct device *dev = &shost->shost_gendev;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	struct request_queue *q;
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
+	q = scsi_bsg_add(dev, bsg_name);
+	if (!q) {
+		printk(KERN_ERR "iscsi_host%d: bsg interface failed to "
+				"initialize - no request queue\n",
+				 shost->host_no);
+		return -ENOMEM;
+	}
+
+	ihost->rqst_q = q;
+	return 0;
+}
+
 static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 			    struct device *cdev)
 {
@@ -279,13 +387,27 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 	memset(ihost, 0, sizeof(*ihost));
 	atomic_set(&ihost->nr_scans, 0);
 	mutex_init(&ihost->mutex);
+
+	iscsi_bsg_host_add(shost, ihost);
+	/* ignore any bsg add error - we just can't do sgio */
+
+	return 0;
+}
+
+static int iscsi_remove_host(struct transport_container *tc,
+			     struct device *dev, struct device *cdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+
+	scsi_bsg_remove(ihost->rqst_q);
 	return 0;
 }
 
 static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
 			       "iscsi_host",
 			       iscsi_setup_host,
-			       NULL,
+			       iscsi_remove_host,
 			       NULL);
 
 static DECLARE_TRANSPORT_CLASS(iscsi_session_class,
@@ -2066,6 +2188,8 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	priv->iscsi_transport = tt;
 	priv->t.user_scan = iscsi_user_scan;
 	priv->t.create_work_queue = 1;
+	priv->t.eh_bsg_job_timed_out = iscsi_bsg_job_timeout;
+	priv->t.queue_bsg_job = iscsi_bsg_host_dispatch;
 
 	priv->dev.class = &iscsi_transport_class;
 	dev_set_name(&priv->dev, "%s", tt->name);
diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
new file mode 100644
index 0000000..fd5689d
--- /dev/null
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -0,0 +1,110 @@
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
+#define ISCSI_DEFAULT_BSG_TIMEOUT      (10 * HZ)
+
+
+/*
+ * Request Message Codes supported by the iSCSI Transport
+ */
+
+/* define the class masks for the message codes */
+#define ISCSI_BSG_CLS_MASK     0xF0000000      /* find object class */
+#define ISCSI_BSG_HST_MASK     0x80000000      /* iscsi host class */
+
+/* iscsi host Message Codes */
+#define ISCSI_BSG_HST_VENDOR           (ISCSI_BSG_HST_MASK | 0x000000FF)
+
+
+/*
+ * iSCSI Host Messages
+ */
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
+		struct iscsi_bsg_host_vendor    h_vendor;
+	} rqst_data;
+} __attribute__((packed));
+
+
+/* response (request sense data) structure of the sg_io_v4 */
+struct iscsi_bsg_reply {
+	/*
+	 * The completion result. Result exists in two forms:
+	 * if negative, it is an -Exxx system errno value. There will
+	 * be no further reply information supplied.
+	 * else, it's the 4-byte scsi error result, with driver, host,
+	 * msg and status fields. The per-msgcode reply structure
+	 * will contain valid data.
+	 */
+	uint32_t result;
+
+	/* If there was reply_payload, how much was recevied ? */
+	uint32_t reply_payload_rcv_len;
+
+	union {
+		struct iscsi_bsg_host_vendor_reply      vendor_reply;
+	} reply_data;
+};
+
+
+#endif /* SCSI_BSG_ISCSI_H */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index bf8f529..b396630 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -37,6 +37,7 @@ struct iscsi_cls_conn;
 struct iscsi_conn;
 struct iscsi_task;
 struct sockaddr;
+struct scsi_bsg_job;
 
 /**
  * struct iscsi_transport - iSCSI Transport template
@@ -137,6 +138,9 @@ struct iscsi_transport {
 	int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
 			  uint32_t enable, struct sockaddr *dst_addr);
 	int (*set_path) (struct Scsi_Host *shost, struct iscsi_path *params);
+	/* bsg support */
+	int (*bsg_request)(struct scsi_bsg_job *job);
+	int (*bsg_timeout)(struct scsi_bsg_job *job);
 };
 
 /*
@@ -216,6 +220,7 @@ struct iscsi_cls_session {
 struct iscsi_cls_host {
 	atomic_t nr_scans;
 	struct mutex mutex;
+	struct request_queue *rqst_q;	/* bsg support */
 };
 
 extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
-- 
1.7.2.3

