From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 2/5] scsi_dh: add scsi_dh_attached_handler_name
Date: Wed,  9 May 2012 21:12:46 -0400
Message-ID: <1336612366-30794-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab2EJBND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 May 2012 21:13:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: agk@redhat.com, hare@suse.de, babu.moger@netapp.com, sekharan@us.ibm.com, Mike Snitzer <snitzer@redhat.com>

Originally posted to dm-devel but Chandra reminded me to post to
linux-scsi for James to pick it up.

-------8<-------

Introduce scsi_dh_attached_handler_name() to retrieve the name of the
scsi_dh that is attached to the scsi_device associated with the provided
request queue.  Returns NULL if a scsi_dh is not attached.

Also, fix scsi_dh_{attach,detach} function header comments to document
@q rather than @sdev.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh.c |   36 ++++++++++++++++++++++++++++++++--
 include/scsi/scsi_dh.h                |    5 ++++
 2 files changed, 39 insertions(+), 2 deletions(-)

v3: fixed missing put_device that Babu pointed out

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
@@ -527,6 +529,36 @@ void scsi_dh_detach(struct request_queue
 }
 EXPORT_SYMBOL_GPL(scsi_dh_detach);
 
+/*
+ * scsi_dh_attached_handler_name - Get attached device handler's name
+ * @q - Request queue that is associated with the scsi_device
+ *      that may have a device handler attached
+ *
+ * Returns name of attached handler, NULL if no handler is attached.
+ */
+const char *scsi_dh_attached_handler_name(struct request_queue *q)
+{
+	unsigned long flags;
+	struct scsi_device *sdev;
+	const char *handler_name = NULL;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	if (!sdev || !get_device(&sdev->sdev_gendev))
+		sdev = NULL;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (!sdev)
+		return NULL;
+
+	if (sdev->scsi_dh_data)
+		handler_name = sdev->scsi_dh_data->scsi_dh->name;
+
+	put_device(&sdev->sdev_gendev);
+	return handler_name;
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
