From: michaelc@cs.wisc.edu
Subject: [PATCH 03/25] iscsi class: rename iscsi_host to iscsi_cls_host
Date: Wed, 21 May 2008 15:53:58 -0500
Message-ID: <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935670AbYEUUy0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:26 -0400
In-Reply-To: <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This renames the iscsi_host to iscsi_cls_host to match the other
structs, because libiscsi wants to use the iscsi_host name in
the future.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   24 +++++++++++-------------
 include/scsi/scsi_transport_iscsi.h |    2 +-
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e6a090e..5577a60 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -114,13 +114,11 @@ static struct attribute_group iscsi_transport_group = {
 	.attrs = iscsi_transport_attrs,
 };
 
-
-
 static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 			    struct device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_host *ihost = shost->shost_data;
 
 	memset(ihost, 0, sizeof(*ihost));
 	INIT_LIST_HEAD(&ihost->sessions);
@@ -140,7 +138,7 @@ static int iscsi_remove_host(struct transport_container *tc, struct device *dev,
 			     struct device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_host *ihost = shost->shost_data;
 
 	destroy_workqueue(ihost->scan_workq);
 	return 0;
@@ -293,7 +291,7 @@ static int iscsi_is_session_dev(const struct device *dev)
  */
 int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
-	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_host *ihost = shost->shost_data;
 	/*
 	 * qla4xxx will have kicked off some session unblocks before calling
 	 * scsi_scan_host, so just wait for them to complete.
@@ -305,7 +303,7 @@ EXPORT_SYMBOL_GPL(iscsi_scan_finished);
 static int iscsi_user_scan(struct Scsi_Host *shost, uint channel,
 			   uint id, uint lun)
 {
-	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_host *ihost = shost->shost_data;
 	struct iscsi_cls_session *session;
 
 	mutex_lock(&ihost->mutex);
@@ -325,7 +323,7 @@ static void iscsi_scan_session(struct work_struct *work)
 	struct iscsi_cls_session *session =
 			container_of(work, struct iscsi_cls_session, scan_work);
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&session->lock, flags);
@@ -377,7 +375,7 @@ static void __iscsi_unblock_session(struct work_struct *work)
 			container_of(work, struct iscsi_cls_session,
 				     unblock_work);
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
 
 	/*
@@ -445,7 +443,7 @@ static void __iscsi_unbind_session(struct work_struct *work)
 			container_of(work, struct iscsi_cls_session,
 				     unbind_work);
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_host *ihost = shost->shost_data;
 
 	/* Prevent new scans and make sure scanning is not in progress */
 	mutex_lock(&ihost->mutex);
@@ -463,7 +461,7 @@ static void __iscsi_unbind_session(struct work_struct *work)
 static int iscsi_unbind_session(struct iscsi_cls_session *session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_host *ihost = shost->shost_data;
 
 	return queue_work(ihost->scan_workq, &session->unbind_work);
 }
@@ -505,7 +503,7 @@ EXPORT_SYMBOL_GPL(iscsi_alloc_session);
 int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_host *ihost;
+	struct iscsi_cls_host *ihost;
 	unsigned long flags;
 	int err;
 
@@ -591,7 +589,7 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 void iscsi_remove_session(struct iscsi_cls_session *session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_host *ihost = shost->shost_data;
+	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
 	int err;
 
@@ -1619,7 +1617,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	priv->t.host_attrs.ac.attrs = &priv->host_attrs[0];
 	priv->t.host_attrs.ac.class = &iscsi_host_class.class;
 	priv->t.host_attrs.ac.match = iscsi_host_match;
-	priv->t.host_size = sizeof(struct iscsi_host);
+	priv->t.host_size = sizeof(struct iscsi_cls_host);
 	transport_container_register(&priv->t.host_attrs);
 
 	SETUP_HOST_RD_ATTR(netdev, ISCSI_HOST_NETDEV_NAME);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index afed70e..7287022 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -201,7 +201,7 @@ struct iscsi_cls_session {
 #define starget_to_session(_stgt) \
 	iscsi_dev_to_session(_stgt->dev.parent)
 
-struct iscsi_host {
+struct iscsi_cls_host {
 	struct list_head sessions;
 	atomic_t nr_scans;
 	struct mutex mutex;
-- 
1.5.4.1

