From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3] scsi: use 'scsi_device_from_queue()' for scsi_dh
Date: Fri, 17 Feb 2017 09:02:45 +0100
Message-ID: <1487318565-96759-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33719 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753744AbdBQICt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:02:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, linux-scsi@vger.kernel.org, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The device handler needs to check if a given queue belongs to
a scsi device; only then does it make sense to attach a device
handler.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_dh.c     | 22 ++++------------------
 drivers/scsi/scsi_lib.c    | 24 ++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 3 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index b8d3b97..84addee 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -219,20 +219,6 @@ int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 }
 EXPORT_SYMBOL_GPL(scsi_unregister_device_handler);
 
-static struct scsi_device *get_sdev_from_queue(struct request_queue *q)
-{
-	struct scsi_device *sdev;
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
-	if (!sdev || !get_device(&sdev->sdev_gendev))
-		sdev = NULL;
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	return sdev;
-}
-
 /*
  * scsi_dh_activate - activate the path associated with the scsi_device
  *      corresponding to the given request queue.
@@ -251,7 +237,7 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	struct scsi_device *sdev;
 	int err = SCSI_DH_NOSYS;
 
-	sdev = get_sdev_from_queue(q);
+	sdev = scsi_device_from_queue(q);
 	if (!sdev) {
 		if (fn)
 			fn(data, err);
@@ -298,7 +284,7 @@ int scsi_dh_set_params(struct request_queue *q, const char *params)
 	struct scsi_device *sdev;
 	int err = -SCSI_DH_NOSYS;
 
-	sdev = get_sdev_from_queue(q);
+	sdev = scsi_device_from_queue(q);
 	if (!sdev)
 		return err;
 
@@ -321,7 +307,7 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 	struct scsi_device_handler *scsi_dh;
 	int err = 0;
 
-	sdev = get_sdev_from_queue(q);
+	sdev = scsi_device_from_queue(q);
 	if (!sdev)
 		return -ENODEV;
 
@@ -359,7 +345,7 @@ const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
 	struct scsi_device *sdev;
 	const char *handler_name = NULL;
 
-	sdev = get_sdev_from_queue(q);
+	sdev = scsi_device_from_queue(q);
 	if (!sdev)
 		return NULL;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9d6aed5..1756cd8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2145,6 +2145,30 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
 	blk_mq_free_tag_set(&shost->tag_set);
 }
 
+/**
+ * scsi_device_from_queue - return sdev associated with a request_queue
+ * @q: The request queue to return the sdev from
+ *
+ * Return the sdev associated with a request queue or NULL if the
+ * request_queue does not reference a SCSI device.
+ */
+struct scsi_device *scsi_device_from_queue(struct request_queue *q)
+{
+	struct scsi_device *sdev = NULL;
+	unsigned long flags;
+
+	if (q->mq_ops) {
+		if (q->mq_ops == &scsi_mq_ops)
+			sdev = q->queuedata;
+	} else if (q->request_fn == scsi_request_fn)
+		sdev = q->queuedata;
+	if (!sdev || !get_device(&sdev->sdev_gendev))
+		sdev = NULL;
+
+	return sdev;
+}
+EXPORT_SYMBOL_GPL(scsi_device_from_queue);
+
 /*
  * Function:    scsi_block_requests()
  *
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8990e58..be41c76 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -315,6 +315,7 @@ extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
 
+extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
-- 
1.8.5.6
