From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4 2/5] scsi_dh: add scsi_dh_attached_handler_name
Date: Thu, 10 May 2012 17:31:12 -0400
Message-ID: <20120510213112.GA7374@redhat.com>
References: <1336612366-30794-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab2EJVbX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2012 17:31:23 -0400
Content-Disposition: inline
In-Reply-To: <1336612366-30794-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: agk@redhat.com, hare@suse.de, babu.moger@netapp.com, sekharan@us.ibm.com, dm-devel@redhat.com

Introduce scsi_dh_attached_handler_name() to retrieve the name of the
scsi_dh that is attached to the scsi_device associated with the provided
request queue.  Returns NULL if a scsi_dh is not attached.

Also, fix scsi_dh_{attach,detach} function header comments to document
@q rather than @sdev.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Tested-by: Babu Moger <babu.moger@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh.c |   38 ++++++++++++++++++++++++++++++++--
 include/scsi/scsi_dh.h                |    6 +++++
 2 files changed, 42 insertions(+), 2 deletions(-)

v4: fixed potential for returned string to be invalid (hch)
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
@@ -527,6 +529,38 @@ void scsi_dh_detach(struct request_queue
 }
 EXPORT_SYMBOL_GPL(scsi_dh_detach);
 
+/*
+ * scsi_dh_attached_handler_name - Get attached device handler's name
+ * @q - Request queue that is associated with the scsi_device
+ *      that may have a device handler attached
+ * @gfp - the GFP mask used in the kmalloc() call when allocating memory
+ *
+ * Returns name of attached handler, NULL if no handler is attached.
+ * Caller must take care to free the returned string.
+ */
+const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
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
+		handler_name = kstrdup(sdev->scsi_dh_data->scsi_dh->name, gfp);
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
+extern const char *scsi_dh_attached_handler_name(struct request_queue *, gfp_t);
 extern int scsi_dh_set_params(struct request_queue *, const char *);
 #else
 static inline int scsi_dh_activate(struct request_queue *req,
@@ -80,6 +81,11 @@ static inline void scsi_dh_detach(struct
 {
 	return;
 }
+static inline const char *scsi_dh_attached_handler_name(struct request_queue *q,
+							gfp_t gfp)
+{
+	return NULL;
+}
 static inline int scsi_dh_set_params(struct request_queue *req, const char *params)
 {
 	return -SCSI_DH_NOSYS;
