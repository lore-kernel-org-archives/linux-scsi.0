From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] scsi_dh: add a common helper to get a scsi_device from a request_queue
Date: Sun, 10 May 2015 20:40:59 +0200
Message-ID: <1431283260-13406-8-git-send-email-hch@lst.de>
References: <1431283260-13406-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbbEJSmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2015 14:42:38 -0400
In-Reply-To: <1431283260-13406-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

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
index f0b100e..8cae1c9 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -281,6 +281,20 @@ int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
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
@@ -296,41 +310,37 @@ EXPORT_SYMBOL_GPL(scsi_unregister_device_handler);
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
 
@@ -346,21 +356,15 @@ EXPORT_SYMBOL_GPL(scsi_dh_activate);
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
@@ -374,23 +378,19 @@ EXPORT_SYMBOL_GPL(scsi_dh_set_params);
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
@@ -417,22 +417,15 @@ EXPORT_SYMBOL_GPL(scsi_dh_attach);
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
1.9.1

