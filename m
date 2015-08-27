From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/10] scsi_dh: add a common helper to get a scsi_device from a request_queue
Date: Thu, 27 Aug 2015 14:17:00 +0200
Message-ID: <1440677823-11695-8-git-send-email-hare@suse.de>
References: <1440677823-11695-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbbH0MRI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:17:08 -0400
In-Reply-To: <1440677823-11695-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

And cleanup the various messy opencoded versions of this.  Note that this
moves the sdev_state checks outside the queue_lock coverage, but as
we don't hold the lock over the activation they are only advisory anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_dh.c | 99 +++++++++++++++++++++++---------------------------
 1 file changed, 46 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index f752a45..489083c 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -282,6 +282,20 @@ int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 }
 EXPORT_SYMBOL_GPL(scsi_unregister_device_handler);
 
+static struct scsi_device *get_sdev_from_queue(struct request_queue *q)
+{
+	struct scsi_device *sdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	if (!sdev || !get_device(&sdev->sdev_gendev))
+		sdev = NULL;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return sdev;
+}
+
 /*
  * scsi_dh_activate - activate the path associated with the scsi_device
  *      corresponding to the given request queue.
@@ -297,41 +311,37 @@ EXPORT_SYMBOL_GPL(scsi_unregister_device_handler);
  */
 int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 {
-	int err = 0;
-	unsigned long flags;
 	struct scsi_device *sdev;
-	struct device *dev = NULL;
+	int err = SCSI_DH_NOSYS;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = get_sdev_from_queue(q);
 	if (!sdev) {
-		spin_unlock_irqrestore(q->queue_lock, flags);
-		err = SCSI_DH_NOSYS;
 		if (fn)
 			fn(data, err);
 		return err;
 	}
 
-	dev = get_device(&sdev->sdev_gendev);
-	if (!sdev->handler || !dev ||
-	    sdev->sdev_state == SDEV_CANCEL ||
+	if (!sdev->handler)
+		goto out_fn;
+	if (sdev->sdev_state == SDEV_CANCEL ||
 	    sdev->sdev_state == SDEV_DEL)
-		err = SCSI_DH_NOSYS;
-	if (sdev->sdev_state == SDEV_OFFLINE)
-		err = SCSI_DH_DEV_OFFLINED;
-	spin_unlock_irqrestore(q->queue_lock, flags);
+		goto out_fn;
 
-	if (err) {
-		if (fn)
-			fn(data, err);
-		goto out;
-	}
+	err = SCSI_DH_DEV_OFFLINED;
+	if (sdev->sdev_state == SDEV_OFFLINE)
+		goto out_fn;
 
 	if (sdev->handler->activate)
 		err = sdev->handler->activate(sdev, fn, data);
-out:
-	put_device(dev);
+
+out_put_device:
+	put_device(&sdev->sdev_gendev);
 	return err;
+
+out_fn:
+	if (fn)
+		fn(data, err);
+	goto out_put_device;
 }
 EXPORT_SYMBOL_GPL(scsi_dh_activate);
 
@@ -347,21 +357,15 @@ EXPORT_SYMBOL_GPL(scsi_dh_activate);
  */
 int scsi_dh_set_params(struct request_queue *q, const char *params)
 {
-	int err = -SCSI_DH_NOSYS;
-	unsigned long flags;
 	struct scsi_device *sdev;
+	int err = -SCSI_DH_NOSYS;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
-	if (sdev->handler &&
-	    sdev->handler->set_params &&
-	    get_device(&sdev->sdev_gendev))
-		err = 0;
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	if (err)
+	sdev = get_sdev_from_queue(q);
+	if (!sdev)
 		return err;
-	err = sdev->handler->set_params(sdev, params);
+
+	if (sdev->handler && sdev->handler->set_params)
+		err = sdev->handler->set_params(sdev, params);
 	put_device(&sdev->sdev_gendev);
 	return err;
 }
@@ -375,23 +379,19 @@ EXPORT_SYMBOL_GPL(scsi_dh_set_params);
  */
 int scsi_dh_attach(struct request_queue *q, const char *name)
 {
-	unsigned long flags;
 	struct scsi_device *sdev;
 	struct scsi_device_handler *scsi_dh;
 	int err = 0;
 
-	scsi_dh = scsi_dh_lookup(name);
-	if (!scsi_dh)
-		return -EINVAL;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
-	if (!sdev || !get_device(&sdev->sdev_gendev))
-		err = -ENODEV;
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	sdev = get_sdev_from_queue(q);
+	if (!sdev)
+		return -ENODEV;
 
-	if (err)
-		return err;
+	scsi_dh = scsi_dh_lookup(name);
+	if (!scsi_dh) {
+		err = -EINVAL;
+		goto out_put_device;
+	}
 
 	if (sdev->handler) {
 		if (sdev->handler != scsi_dh)
@@ -418,22 +418,15 @@ EXPORT_SYMBOL_GPL(scsi_dh_attach);
  */
 const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
 {
-	unsigned long flags;
 	struct scsi_device *sdev;
 	const char *handler_name = NULL;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
-	if (!sdev || !get_device(&sdev->sdev_gendev))
-		sdev = NULL;
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
+	sdev = get_sdev_from_queue(q);
 	if (!sdev)
 		return NULL;
 
 	if (sdev->handler)
 		handler_name = kstrdup(sdev->handler->name, gfp);
-
 	put_device(&sdev->sdev_gendev);
 	return handler_name;
 }
-- 
1.8.5.6

