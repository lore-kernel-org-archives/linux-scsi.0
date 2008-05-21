From: michaelc@cs.wisc.edu
Subject: [PATCH 17/25] iscsi class: user device_for_each_child instead of duplicating session list
Date: Wed, 21 May 2008 15:54:12 -0500
Message-ID: <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937099AbYEUUye (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:34 -0400
In-Reply-To: <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Currently we duplicate the list of sessions, because we were using the
test for if a session was on the host list to indicate if the session
was bound or unbound. We can instead use the target_id and fix up
the class so that drivers like bnx2i do not have to manage the target id
space.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
 drivers/scsi/iscsi_tcp.c                 |    2 +-
 drivers/scsi/libiscsi.c                  |    4 +-
 drivers/scsi/scsi_transport_iscsi.c      |  125 +++++++++++++++++++++++-------
 include/scsi/libiscsi.h                  |    2 +-
 include/scsi/scsi_transport_iscsi.h      |    6 +-
 6 files changed, 104 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 86d9c42..3a89039 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -437,7 +437,7 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 	cls_session = iscsi_session_setup(&iscsi_iser_transport, shost,
 					  ISCSI_DEF_XMIT_CMDS_MAX,
 					  sizeof(struct iscsi_iser_task),
-					  initial_cmdsn);
+					  initial_cmdsn, 0);
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 33cd0ca..aa3c7f0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1868,7 +1868,7 @@ iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 
 	cls_session = iscsi_session_setup(&iscsi_tcp_transport, shost, cmds_max,
 					  sizeof(struct iscsi_tcp_task),
-					  initial_cmdsn);
+					  initial_cmdsn, 0);
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 92ee6d9..e88b726 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1897,7 +1897,7 @@ EXPORT_SYMBOL_GPL(iscsi_host_free);
 struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 		    uint16_t scsi_cmds_max, int cmd_task_size,
-		    uint32_t initial_cmdsn)
+		    uint32_t initial_cmdsn, unsigned int id)
 {
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
@@ -1957,7 +1957,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	if (!try_module_get(iscsit->owner))
 		goto module_get_fail;
 
-	if (iscsi_add_session(cls_session, 0))
+	if (iscsi_add_session(cls_session, id))
 		goto cls_session_fail;
 	return cls_session;
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 6b8516a..ac9d298 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -119,9 +119,8 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 	struct iscsi_cls_host *ihost = shost->shost_data;
 
 	memset(ihost, 0, sizeof(*ihost));
-	INIT_LIST_HEAD(&ihost->sessions);
-	mutex_init(&ihost->mutex);
 	atomic_set(&ihost->nr_scans, 0);
+	mutex_init(&ihost->mutex);
 
 	snprintf(ihost->scan_workq_name, KOBJ_NAME_LEN, "iscsi_scan_%d",
 		shost->host_no);
@@ -316,42 +315,76 @@ int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time)
 }
 EXPORT_SYMBOL_GPL(iscsi_scan_finished);
 
-static int iscsi_user_scan(struct Scsi_Host *shost, uint channel,
-			   uint id, uint lun)
+struct iscsi_scan_data {
+	unsigned int channel;
+	unsigned int id;
+	unsigned int lun;
+};
+
+static int iscsi_user_scan_session(struct device *dev, void *data)
 {
-	struct iscsi_cls_host *ihost = shost->shost_data;
+	struct iscsi_scan_data *scan_data = data;
 	struct iscsi_cls_session *session;
+	struct Scsi_Host *shost;
+	struct iscsi_cls_host *ihost;
+	unsigned long flags;
+	unsigned int id;
+
+	if (!iscsi_is_session_dev(dev))
+		return 0;
+
+	session = iscsi_dev_to_session(dev);
+	shost = iscsi_session_to_shost(session);
+	ihost = shost->shost_data;
 
 	mutex_lock(&ihost->mutex);
-	list_for_each_entry(session, &ihost->sessions, host_list) {
-		if ((channel == SCAN_WILD_CARD || channel == 0) &&
-		    (id == SCAN_WILD_CARD || id == session->target_id))
-			scsi_scan_target(&session->dev, 0,
-					 session->target_id, lun, 1);
+	spin_lock_irqsave(&session->lock, flags);
+	if (session->state != ISCSI_SESSION_LOGGED_IN) {
+		spin_unlock_irqrestore(&session->lock, flags);
+		mutex_unlock(&ihost->mutex);
+		return 0;
 	}
-	mutex_unlock(&ihost->mutex);
+	id = session->target_id;
+	spin_unlock_irqrestore(&session->lock, flags);
 
+	if (id != ISCSI_MAX_TARGET) {
+		if ((scan_data->channel == SCAN_WILD_CARD ||
+		     scan_data->channel == 0) &&
+		    (scan_data->id == SCAN_WILD_CARD ||
+		     scan_data->id == id))
+			scsi_scan_target(&session->dev, 0, id,
+					 scan_data->lun, 1);
+	}
+	mutex_unlock(&ihost->mutex);
 	return 0;
 }
 
+static int iscsi_user_scan(struct Scsi_Host *shost, uint channel,
+			   uint id, uint lun)
+{
+	struct iscsi_scan_data scan_data;
+
+	scan_data.channel = channel;
+	scan_data.id = id;
+	scan_data.lun = lun;
+
+	return device_for_each_child(&shost->shost_gendev, &scan_data,
+				     iscsi_user_scan_session);
+}
+
 static void iscsi_scan_session(struct work_struct *work)
 {
 	struct iscsi_cls_session *session =
 			container_of(work, struct iscsi_cls_session, scan_work);
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_cls_host *ihost = shost->shost_data;
-	unsigned long flags;
+	struct iscsi_scan_data scan_data;
 
-	spin_lock_irqsave(&session->lock, flags);
-	if (session->state != ISCSI_SESSION_LOGGED_IN) {
-		spin_unlock_irqrestore(&session->lock, flags);
-		goto done;
-	}
-	spin_unlock_irqrestore(&session->lock, flags);
+	scan_data.channel = 0;
+	scan_data.id = SCAN_WILD_CARD;
+	scan_data.lun = SCAN_WILD_CARD;
 
-	scsi_scan_target(&session->dev, 0, session->target_id,
-			 SCAN_WILD_CARD, 1);
-done:
+	iscsi_user_scan_session(&session->dev, &scan_data);
 	atomic_dec(&ihost->nr_scans);
 }
 
@@ -460,14 +493,18 @@ static void __iscsi_unbind_session(struct work_struct *work)
 				     unbind_work);
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_cls_host *ihost = shost->shost_data;
+	unsigned long flags;
 
 	/* Prevent new scans and make sure scanning is not in progress */
 	mutex_lock(&ihost->mutex);
-	if (list_empty(&session->host_list)) {
+	spin_lock_irqsave(&session->lock, flags);
+	if (session->target_id == ISCSI_MAX_TARGET) {
+		spin_unlock_irqrestore(&session->lock, flags);
 		mutex_unlock(&ihost->mutex);
 		return;
 	}
-	list_del_init(&session->host_list);
+	session->target_id = ISCSI_MAX_TARGET;
+	spin_unlock_irqrestore(&session->lock, flags);
 	mutex_unlock(&ihost->mutex);
 
 	scsi_remove_target(&session->dev);
@@ -497,7 +534,6 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 	session->recovery_tmo = 120;
 	session->state = ISCSI_SESSION_FREE;
 	INIT_DELAYED_WORK(&session->recovery_work, session_recovery_timedout);
-	INIT_LIST_HEAD(&session->host_list);
 	INIT_LIST_HEAD(&session->sess_list);
 	INIT_WORK(&session->unblock_work, __iscsi_unblock_session);
 	INIT_WORK(&session->block_work, __iscsi_block_session);
@@ -516,16 +552,51 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 }
 EXPORT_SYMBOL_GPL(iscsi_alloc_session);
 
+static int iscsi_get_next_target_id(struct device *dev, void *data)
+{
+	struct iscsi_cls_session *session;
+	unsigned long flags;
+	int err = 0;
+
+	if (!iscsi_is_session_dev(dev))
+		return 0;
+
+	session = iscsi_dev_to_session(dev);
+	spin_lock_irqsave(&session->lock, flags);
+	if (*((unsigned int *) data) == session->target_id)
+		err = -EEXIST;
+	spin_unlock_irqrestore(&session->lock, flags);
+	return err;
+}
+
 int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_cls_host *ihost;
 	unsigned long flags;
+	unsigned int id = target_id;
 	int err;
 
 	ihost = shost->shost_data;
 	session->sid = atomic_add_return(1, &iscsi_session_nr);
-	session->target_id = target_id;
+
+	if (id == ISCSI_MAX_TARGET) {
+		for (id = 0; id < ISCSI_MAX_TARGET; id++) {
+			err = device_for_each_child(&shost->shost_gendev, &id,
+						    iscsi_get_next_target_id);
+			if (!err)
+				break;
+		}
+
+		if (id == ISCSI_MAX_TARGET) {
+			iscsi_cls_session_printk(KERN_ERR, session,
+						 "Too many iscsi targets. Max "
+						 "number of targets is %d.\n",
+						 ISCSI_MAX_TARGET - 1);
+			goto release_host;
+		}
+	}
+	session->target_id = id;
 
 	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u",
 		 session->sid);
@@ -541,10 +612,6 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	list_add(&session->sess_list, &sesslist);
 	spin_unlock_irqrestore(&sesslock, flags);
 
-	mutex_lock(&ihost->mutex);
-	list_add(&session->host_list, &ihost->sessions);
-	mutex_unlock(&ihost->mutex);
-
 	iscsi_session_event(session, ISCSI_KEVENT_CREATE_SESSION);
 	return 0;
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 176353c..13c92d7 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -331,7 +331,7 @@ extern void iscsi_host_free(struct Scsi_Host *shost);
  */
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
-		    uint16_t, int, uint32_t);
+		    uint16_t, int, uint32_t, unsigned int);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 0553240..d6b8231 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -161,9 +161,10 @@ enum {
 	ISCSI_SESSION_FREE,
 };
 
+#define ISCSI_MAX_TARGET -1
+
 struct iscsi_cls_session {
 	struct list_head sess_list;		/* item in session_list */
-	struct list_head host_list;
 	struct iscsi_transport *transport;
 	spinlock_t lock;
 	struct work_struct block_work;
@@ -175,7 +176,7 @@ struct iscsi_cls_session {
 	int recovery_tmo;
 	struct delayed_work recovery_work;
 
-	int target_id;
+	unsigned int target_id;
 
 	int state;
 	int sid;				/* session id */
@@ -193,7 +194,6 @@ struct iscsi_cls_session {
 	iscsi_dev_to_session(_stgt->dev.parent)
 
 struct iscsi_cls_host {
-	struct list_head sessions;
 	atomic_t nr_scans;
 	struct mutex mutex;
 	struct workqueue_struct *scan_workq;
-- 
1.5.4.1

