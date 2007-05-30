From: michaelc@cs.wisc.edu
Subject: [PATCH 4/19] iscsi class, qla4xxx: have class lookup host for drivers
Date: Wed, 30 May 2007 12:57:10 -0500
Message-ID: <1180547849438-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbXE3R5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:44 -0400
In-Reply-To: <11805478483268-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We are going to be adding more host level sysfs attrs and
set_params, so this patch has them take a scsi_host instead
of either a scsi_host or host no.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c       |   19 ++++++-------------
 drivers/scsi/scsi_transport_iscsi.c |   17 ++++++++++++++---
 include/scsi/scsi_transport_iscsi.h |    2 +-
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 01308e7..29cd4b9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -54,8 +54,9 @@ static void qla4xxx_config_dma_addressin
 /*
  * iSCSI template entry points
  */
-static int qla4xxx_tgt_dscvr(enum iscsi_tgt_dscvr type, uint32_t host_no,
-			     uint32_t enable, struct sockaddr *dst_addr);
+static int qla4xxx_tgt_dscvr(struct Scsi_Host *shost,
+			     enum iscsi_tgt_dscvr type, uint32_t enable,
+			     struct sockaddr *dst_addr);
 static int qla4xxx_conn_get_param(struct iscsi_cls_conn *conn,
 				  enum iscsi_param param, char *buf);
 static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
@@ -243,21 +244,15 @@ static int qla4xxx_conn_get_param(struct
 	return len;
 }
 
-static int qla4xxx_tgt_dscvr(enum iscsi_tgt_dscvr type, uint32_t host_no,
-			     uint32_t enable, struct sockaddr *dst_addr)
+static int qla4xxx_tgt_dscvr(struct Scsi_Host *shost,
+			     enum iscsi_tgt_dscvr type, uint32_t enable,
+			     struct sockaddr *dst_addr)
 {
 	struct scsi_qla_host *ha;
-	struct Scsi_Host *shost;
 	struct sockaddr_in *addr;
 	struct sockaddr_in6 *addr6;
 	int ret = 0;
 
-	shost = scsi_host_lookup(host_no);
-	if (IS_ERR(shost)) {
-		printk(KERN_ERR "Could not find host no %u\n", host_no);
-		return -ENODEV;
-	}
-
 	ha = (struct scsi_qla_host *) shost->hostdata;
 
 	switch (type) {
@@ -281,8 +276,6 @@ static int qla4xxx_tgt_dscvr(enum iscsi_
 	default:
 		ret = -ENOSYS;
 	}
-
-	scsi_host_put(shost);
 	return ret;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 1ba98d2..5928760 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -945,15 +945,26 @@ static int
 iscsi_tgt_dscvr(struct iscsi_transport *transport,
 		struct iscsi_uevent *ev)
 {
+	struct Scsi_Host *shost;
 	struct sockaddr *dst_addr;
+	int err;
 
 	if (!transport->tgt_dscvr)
 		return -EINVAL;
 
+	shost = scsi_host_lookup(ev->u.tgt_dscvr.host_no);
+	if (IS_ERR(shost)) {
+		printk(KERN_ERR "target discovery could not find host no %u\n",
+		       ev->u.tgt_dscvr.host_no);
+		return -ENODEV;
+	}
+
+
 	dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
-	return transport->tgt_dscvr(ev->u.tgt_dscvr.type,
-				    ev->u.tgt_dscvr.host_no,
-				    ev->u.tgt_dscvr.enable, dst_addr);
+	err = transport->tgt_dscvr(shost, ev->u.tgt_dscvr.type,
+				   ev->u.tgt_dscvr.enable, dst_addr);
+	scsi_host_put(shost);
+	return err;
 }
 
 static int
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index e962c53..902e69f 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -127,7 +127,7 @@ struct iscsi_transport {
 			   uint64_t *ep_handle);
 	int (*ep_poll) (uint64_t ep_handle, int timeout_ms);
 	void (*ep_disconnect) (uint64_t ep_handle);
-	int (*tgt_dscvr) (enum iscsi_tgt_dscvr type, uint32_t host_no,
+	int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
 			  uint32_t enable, struct sockaddr *dst_addr);
 };
 
-- 
1.4.1.1

