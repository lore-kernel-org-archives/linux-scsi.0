From: Mike Snitzer <snitzer@redhat.com>
Subject: [RESEND PATCH 1/3] scsi_dh: add
	scsi_dh_attached_handler_name
Date: Tue, 26 Jun 2012 14:32:03 -0400
Message-ID: <1340735525-21083-2-git-send-email-snitzer@redhat.com>
References: <1340735525-21083-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1340735525-21083-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <jbottomley@parallels.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Introduce scsi_dh_attached_handler_name() to retrieve the name of the
scsi_dh that is attached to the scsi_device associated with the provided
request queue.  Returns NULL if a scsi_dh is not attached.

Also, fix scsi_dh_{attach,detach} function header comments to document
@q rather than @sdev.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Tested-by: Babu Moger <babu.moger@netapp.com>
Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |   38 +++++++++++++++++++++++++++++++-
 include/scsi/scsi_dh.h                |    6 +++++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 48e46f5..33e422e 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -468,7 +468,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
 
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
@@ -527,6 +529,38 @@ void scsi_dh_detach(struct request_queue *q)
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
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index e3f2db2..620c723 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -60,6 +60,7 @@ extern int scsi_dh_activate(struct request_queue *, activate_complete, void *);
 extern int scsi_dh_handler_exist(const char *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern void scsi_dh_detach(struct request_queue *);
+extern const char *scsi_dh_attached_handler_name(struct request_queue *, gfp_t);
 extern int scsi_dh_set_params(struct request_queue *, const char *);
 #else
 static inline int scsi_dh_activate(struct request_queue *req,
@@ -80,6 +81,11 @@ static inline void scsi_dh_detach(struct request_queue *q)
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
-- 
1.7.4.4
