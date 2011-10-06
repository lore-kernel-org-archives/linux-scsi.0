From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] iscsi class: Replace iscsi_get_next_target_id with IDA
Date: Thu,  6 Oct 2011 03:56:57 -0500
Message-ID: <1317891420-7116-2-git-send-email-michaelc@cs.wisc.edu>
References: <1317891420-7116-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839Ab1JFIvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Oct 2011 04:51:55 -0400
In-Reply-To: <1317891420-7116-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, John Soni Jose <jose0here@gmail.com>

From: Mike Christie <michaelc@cs.wisc.edu>

 Replaced the iscsi_get_next_target_id with IDA to make
 target-id allocation efficient for iscsi offload drivers

 This patch should be applied after Jonathen Cameron Patch
 "ida : simplified functions for id allocation"

Signed-off-by: John Soni Jose <jose0here@gmail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   59 +++++++++++++---------------------
 include/scsi/scsi_transport_iscsi.h |    1 +
 2 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c58f676..d746c35 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/bsg-lib.h>
+#include <linux/idr.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -81,6 +82,7 @@ struct iscsi_internal {
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
+static DEFINE_IDA(iscsi_sess_ida);
 /*
  * list of registered transports and lock that must
  * be held while accessing list. The iscsi_transport_lock must
@@ -990,6 +992,7 @@ static void __iscsi_unbind_session(struct work_struct *work)
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
+	unsigned int target_id;
 
 	ISCSI_DBG_TRANS_SESSION(session, "Unbinding session\n");
 
@@ -1001,10 +1004,15 @@ static void __iscsi_unbind_session(struct work_struct *work)
 		mutex_unlock(&ihost->mutex);
 		return;
 	}
+
+	target_id = session->target_id;
 	session->target_id = ISCSI_MAX_TARGET;
 	spin_unlock_irqrestore(&session->lock, flags);
 	mutex_unlock(&ihost->mutex);
 
+	if (session->ida_used)
+		ida_simple_remove(&iscsi_sess_ida, target_id);
+
 	scsi_remove_target(&session->dev);
 	iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed target removal\n");
@@ -1045,59 +1053,36 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 }
 EXPORT_SYMBOL_GPL(iscsi_alloc_session);
 
-static int iscsi_get_next_target_id(struct device *dev, void *data)
-{
-	struct iscsi_cls_session *session;
-	unsigned long flags;
-	int err = 0;
-
-	if (!iscsi_is_session_dev(dev))
-		return 0;
-
-	session = iscsi_dev_to_session(dev);
-	spin_lock_irqsave(&session->lock, flags);
-	if (*((unsigned int *) data) == session->target_id)
-		err = -EEXIST;
-	spin_unlock_irqrestore(&session->lock, flags);
-	return err;
-}
-
 int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_cls_host *ihost;
 	unsigned long flags;
-	unsigned int id = target_id;
+	int id = 0;
 	int err;
 
 	ihost = shost->shost_data;
 	session->sid = atomic_add_return(1, &iscsi_session_nr);
 
-	if (id == ISCSI_MAX_TARGET) {
-		for (id = 0; id < ISCSI_MAX_TARGET; id++) {
-			err = device_for_each_child(&shost->shost_gendev, &id,
-						    iscsi_get_next_target_id);
-			if (!err)
-				break;
-		}
+	if (target_id == ISCSI_MAX_TARGET) {
+		id = ida_simple_get(&iscsi_sess_ida, 0, 0, GFP_KERNEL);
 
-		if (id == ISCSI_MAX_TARGET) {
+		if (id < 0) {
 			iscsi_cls_session_printk(KERN_ERR, session,
-						 "Too many iscsi targets. Max "
-						 "number of targets is %d.\n",
-						 ISCSI_MAX_TARGET - 1);
-			err = -EOVERFLOW;
-			goto release_host;
+					"Failure in Target ID Allocation\n");
+			return id;
 		}
-	}
-	session->target_id = id;
+		session->target_id = (unsigned int)id;
+		session->ida_used = true;
+	} else
+		session->target_id = target_id;
 
 	dev_set_name(&session->dev, "session%u", session->sid);
 	err = device_add(&session->dev);
 	if (err) {
 		iscsi_cls_session_printk(KERN_ERR, session,
 					 "could not register session's dev\n");
-		goto release_host;
+		goto release_ida;
 	}
 	transport_register_device(&session->dev);
 
@@ -1109,8 +1094,10 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	ISCSI_DBG_TRANS_SESSION(session, "Completed session adding\n");
 	return 0;
 
-release_host:
-	scsi_host_put(shost);
+release_ida:
+	if (session->ida_used)
+		ida_simple_remove(&iscsi_sess_ida, session->target_id);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(iscsi_add_session);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 3389cd5..a498cce 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -208,6 +208,7 @@ struct iscsi_cls_session {
 	struct delayed_work recovery_work;
 
 	unsigned int target_id;
+	bool ida_used;
 
 	int state;
 	int sid;				/* session id */
-- 
1.7.6

