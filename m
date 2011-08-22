From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Use queuedata accessors for device handler
Date: Mon, 22 Aug 2011 15:35:43 +0200
Message-ID: <201108221335.p7MDZhBm013520@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab1HVNfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 09:35:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org


Starting multipath on a cciss device will cause a kernel
warning to be triggered. Problem is that we're using the
->queuedata field of the request_queue to dereference the
scsi device; however, for other (non-SCSI) devices this
points to a totally different structure.
So we should rather be using accessors here to make
sure ->queuedata points to a valid sdev.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 0119b81..bc96ca6 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -441,7 +441,7 @@ int scsi_dh_set_params(struct request_queue *q, const char *params)
 	struct scsi_device_handler *scsi_dh = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = scsi_device_from_queue(q);
 	if (sdev && sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 	if (scsi_dh && scsi_dh->set_params && get_device(&sdev->sdev_gendev))
@@ -484,7 +484,7 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = scsi_device_from_queue(q);
 	if (!sdev || !get_device(&sdev->sdev_gendev))
 		err = -ENODEV;
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -512,7 +512,7 @@ void scsi_dh_detach(struct request_queue *q)
 	struct scsi_device_handler *scsi_dh = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = scsi_device_from_queue(q);
 	if (!sdev || !get_device(&sdev->sdev_gendev))
 		sdev = NULL;
 	spin_unlock_irqrestore(q->queue_lock, flags);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc3f168..a96fe54 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1614,6 +1614,24 @@ out:
 	spin_lock_irq(q->queue_lock);
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
+
+	if (q->request_fn == scsi_request_fn)
+		sdev = q->queuedata;
+
+	return sdev;
+}
+EXPORT_SYMBOL_GPL(scsi_device_from_queue);
+
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
 	struct device *host_dev;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d371c3c..6712446 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -301,6 +301,7 @@ extern void starget_for_each_device(struct scsi_target *, void *,
 extern void __starget_for_each_device(struct scsi_target *, void *,
 				      void (*fn)(struct scsi_device *,
 						 void *));
+extern struct scsi_device *scsi_device_from_queue(struct request_queue *);
 
 /* only exposed to implement shost_for_each_device */
 extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
