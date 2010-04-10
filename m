From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] RFC: iscsi class: add bsg support to iscsi class
Date: Sat, 10 Apr 2010 05:17:41 -0500
Message-ID: <1270894661-28402-5-git-send-email-michaelc@cs.wisc.edu>
References: <1270894661-28402-1-git-send-email-michaelc@cs.wisc.edu>
 <1270894661-28402-2-git-send-email-michaelc@cs.wisc.edu>
 <1270894661-28402-3-git-send-email-michaelc@cs.wisc.edu>
 <1270894661-28402-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0DJKR4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2010 06:17:56 -0400
In-Reply-To: <1270894661-28402-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This is just an initial conversion of Jay's patch to
the bsg lib. I disabled the code that copys the sg to
a buffer, because it was a little broken.

Patch is only compile tested.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |  196 +++++++++++++++++++++++++++-
 include/scsi/Kbuild                 |    1 +
 include/scsi/scsi_bsg_iscsi.h       |  253 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |    6 +
 4 files changed, 455 insertions(+), 1 deletions(-)
 create mode 100644 include/scsi/scsi_bsg_iscsi.h

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 1e6d479..48281ae 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -30,6 +30,9 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
+#include <scsi/scsi_bsg_iscsi.h>
+#include <scsi/scsi_bsg.h>
+#include <scsi/scsi_cmnd.h>
 
 #define ISCSI_SESSION_ATTRS 22
 #define ISCSI_CONN_ATTRS 13
@@ -269,6 +272,182 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
+
+/*
+ * BSG support
+ */
+
+/**
+ * iscsi_bsg_job_timeout - handler for when a bsg request timesout
+ * @req:	request that timed out
+ */
+static enum blk_eh_timer_return iscsi_bsg_job_timeout(struct request *req)
+{
+	struct scsi_bsg_job *job = req->special;
+	struct Scsi_Host *shost = job->shost;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	int err = 0;
+
+	if (i->iscsi_transport->bsg_timeout)
+		err = i->iscsi_transport->bsg_timeout(job);
+	return err;
+}
+
+static int iscsi_req_to_bsg_job(struct Scsi_Host *shost, struct device *dev,
+				struct request *req)
+{
+	return scsi_bsg_req_to_job(shost, dev, req, 0, 0);
+}
+
+/**
+ * iscsi_bsg_host_dispatch - process bsg requests and dispatch to LLD
+ * @q:		iscsi host request queue
+ * @shost:	scsi host request queue attached to
+ * @job:	bsg job to be processed
+ */
+static enum scsi_dispatch_result
+iscsi_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
+			 struct scsi_bsg_job *job)
+{
+	unsigned char *pdata;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
+	int ret, num;
+	unsigned int tot_len = 0;
+	struct scatterlist *sge = NULL;
+	struct iscsi_bsg_request *bsg_req = job->request;
+	struct iscsi_bsg_reply *bsg_reply = job->reply;
+
+	/* check if we have the msgcode value at least */
+	if (job->request_len < sizeof(uint32_t)) {
+		ret = -ENOMSG;
+		goto fail_host_msg;
+	}
+
+	/* Validate the host command */
+	switch (bsg_req->msgcode) {
+	case ISCSI_BSG_HST_NET_CONFIG:
+		cmdlen += sizeof(struct iscsi_bsg_host_net_config);
+		/*
+		 * Validate set ops have a request payload.
+		 * Get ops are allowed to have none/partial/all reply payloads
+		 */
+		if ((bsg_req->rqst_data.h_netconfig.set_op) &&
+		    (!job->request_payload.payload_len)) {
+			ret = -EINVAL;
+			goto fail_host_msg;
+		}
+#if 0
+This should be using kmap instead of sg_virt
+
+Should also move this to a new function so other cmds can use it
+
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
+#endif
+		break;
+
+	case ISCSI_BSG_HST_VENDOR:
+#if 0
+		cmdlen += sizeof(struct iscsi_bsg_host_vendor);
+		if ((shost->hostt->vendor_id == 0L) ||
+		    (bsg_req->rqst_data.h_vendor.vendor_id !=
+			shost->hostt->vendor_id)) {
+			ret = -ESRCH;
+			goto fail_host_msg;
+		}
+		break;
+#endif
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
+		return SCSI_DISPATCH_UNLOCKED;
+
+fail_host_msg:
+	/* return the errno failure code as the only status */
+	BUG_ON(job->reply_len < sizeof(uint32_t));
+	bsg_reply->reply_payload_rcv_len = 0;
+	bsg_reply->result = ret;
+	job->reply_len = sizeof(uint32_t);
+	scsi_bsg_job_done(job, ret, 0);
+	return SCSI_DISPATCH_UNLOCKED;
+}
+
+/**
+ * iscsi_bsg_host_handler - handler for bsg requests for a iscsi host
+ * @q: iscsi host request queue
+ */
+static void
+iscsi_bsg_host_handler(struct request_queue *q)
+{
+	struct Scsi_Host *shost = q->queuedata;
+
+	scsi_bsg_request_handler(q, shost, &shost->shost_gendev,
+				 iscsi_req_to_bsg_job,
+				 iscsi_bsg_host_dispatch);
+}
+
+/**
+ * iscsi_bsg_host_add - Create and add the bsg hooks so we can receive requests
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
+	q = scsi_bsg_add(shost, dev, bsg_name, iscsi_bsg_host_handler);
+	if (!q) {
+		printk(KERN_ERR "iscsi_host%d: bsg interface failed to "
+				"initialize - no request queue\n",
+				 shost->host_no);
+		return -ENOMEM;
+	}
+
+	q->queuedata = shost;
+	ihost->rqst_q = q;
+	return 0;
+}
+
 static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 			    struct device *cdev)
 {
@@ -278,13 +457,27 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
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
+static int iscsi_remove_host(struct transport_container *tc, struct device *dev,
+			 struct device *cdev)
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
@@ -1930,6 +2123,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	priv->iscsi_transport = tt;
 	priv->t.user_scan = iscsi_user_scan;
 	priv->t.create_work_queue = 1;
+	priv->t.eh_bsg_timed_out = iscsi_bsg_job_timeout;
 
 	priv->dev.class = &iscsi_transport_class;
 	dev_set_name(&priv->dev, "%s", tt->name);
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
index 0000000..7c723a7
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
+#define ISCSI_GET_MAC_ADDRESS           9
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
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 349c7f3..354091f 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -36,6 +36,7 @@ struct iscsi_cls_conn;
 struct iscsi_conn;
 struct iscsi_task;
 struct sockaddr;
+struct scsi_bsg_job;
 
 /**
  * struct iscsi_transport - iSCSI Transport template
@@ -134,6 +135,10 @@ struct iscsi_transport {
 	int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
 			  uint32_t enable, struct sockaddr *dst_addr);
 	int (*set_path) (struct Scsi_Host *shost, struct iscsi_path *params);
+
+	/* bsg support */
+	int (*bsg_request)(struct scsi_bsg_job *job);
+	int (*bsg_timeout)(struct scsi_bsg_job *job);
 };
 
 /*
@@ -212,6 +217,7 @@ struct iscsi_cls_session {
 struct iscsi_cls_host {
 	atomic_t nr_scans;
 	struct mutex mutex;
+	struct request_queue *rqst_q;	/* bsg support */
 };
 
 extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
-- 
1.6.6.1

