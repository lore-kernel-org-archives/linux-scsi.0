From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/3] scsi_dh: add scsi_dh_attached_handler_name
Date: Mon,  7 May 2012 23:19:06 -0400
Message-ID: <1336447147-3830-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab2EHDTt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 May 2012 23:19:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: agk@redhat.com, hare@suse.de, babu.moger@netapp.com, sekharan@us.ibm.com, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>

The following dm-mpath patch may be considered PATCH 1/3 of this series:
http://www.redhat.com/archives/dm-devel/2012-May/msg00006.html

----8<---------

Introduce scsi_dh_attached_handler_name() to retrieve the name of the
scsi_dh that is attached to the scsi_device associated with the provided
request queue.  Returns NULL if a scsi_dh is not attached.

Also, fix scsi_dh_{attach,detach} function header comments to document
@q rather than @sdev.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh.c |   31 +++++++++++++++++++++++++++++--
 include/scsi/scsi_dh.h                |    5 +++++
 2 files changed, 34 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6/drivers/scsi/device_handler/scsi_dh.c
@@ -468,7 +468,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_handler_exist)
 
 /*
  * scsi_dh_attach - Attach device handler
- * @sdev - sdev the handler should be attached to
+ * @q - Request queue that is associated with the scsi_device
+ *      the handler should be attached to
  * @name - name of the handler to attach
  */
 int scsi_dh_attach(struct request_queue *q, const char *name)
@@ -498,7 +499,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_attach);
 
 /*
  * scsi_dh_detach - Detach device handler
- * @sdev - sdev the handler should be detached from
+ * @q - Request queue that is associated with the scsi_device
+ *      the handler should be detached from
  *
  * This function will detach the device handler only
  * if the sdev is not part of the internal list, ie
@@ -527,6 +529,31 @@ void scsi_dh_detach(struct request_queue
 }
 EXPORT_SYMBOL_GPL(scsi_dh_detach);
 
+/*
+ * scsi_dh_attached_handler_name - Get attached device handler's name
+ * @q - Request queue that is associated with the scsi_device
+ *      that may have a device handler attached
+ *
+ * Returns name of attached scsi_dh, NULL if no handler is attached.
+ */
+const char *scsi_dh_attached_handler_name(struct request_queue *q)
+{
+	unsigned long flags;
+	struct scsi_device *sdev;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	if (!sdev || !get_device(&sdev->sdev_gendev))
+		sdev = NULL;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (!sdev || !sdev->scsi_dh_data)
+		return NULL;
+
+	return sdev->scsi_dh_data->scsi_dh->name;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_attached_handler_name);
+
 static struct notifier_block scsi_dh_nb = {
 	.notifier_call = scsi_dh_notifier
 };
Index: linux-2.6/include/scsi/scsi_dh.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_dh.h
+++ linux-2.6/include/scsi/scsi_dh.h
@@ -60,6 +60,7 @@ extern int scsi_dh_activate(struct reque
 extern int scsi_dh_handler_exist(const char *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern void scsi_dh_detach(struct request_queue *);
+extern const char *scsi_dh_attached_handler_name(struct request_queue *q);
 extern int scsi_dh_set_params(struct request_queue *, const char *);
 #else
 static inline int scsi_dh_activate(struct request_queue *req,
@@ -80,6 +81,10 @@ static inline void scsi_dh_detach(struct
 {
 	return;
 }
+static inline const char *scsi_dh_attached_handler_name(struct request_queue *q)
+{
+	return NULL;
+}
 static inline int scsi_dh_set_params(struct request_queue *req, const char *params)
 {
 	return -SCSI_DH_NOSYS;
