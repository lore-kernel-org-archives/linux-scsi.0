From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Kernel bug triggered in multipath
Date: Fri, 14 Mar 2014 12:13:52 +0100
Message-ID: <1394795632-86434-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaCNLNy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2014 07:13:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Starting multipath on a cciss device will cause a kernel
warning to be triggered. Problem is that we're using the
->queuedata field of the request_queue to derefence the
scsi device; however, for other (non-SCSI) devices this
points to a totally different structure.
So we should rather be using accessors here which make
sure we're only returning valid SCSI device structures.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |  6 +++---
 drivers/scsi/scsi_lib.c               | 11 +++++++++++
 include/scsi/scsi_device.h            |  1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 33e422e..b89f204 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -388,7 +388,7 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	struct device *dev = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = scsi_device_from_queue(q);
 	if (!sdev) {
 		spin_unlock_irqrestore(q->queue_lock, flags);
 		err = SCSI_DH_NOSYS;
@@ -484,7 +484,7 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = scsi_device_from_queue(q);
 	if (!sdev || !get_device(&sdev->sdev_gendev))
 		err = -ENODEV;
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -513,7 +513,7 @@ void scsi_dh_detach(struct request_queue *q)
 	struct scsi_device_handler *scsi_dh = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = scsi_device_from_queue(q);
 	if (!sdev || !get_device(&sdev->sdev_gendev))
 		sdev = NULL;
 	spin_unlock_irqrestore(q->queue_lock, flags);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bd7f0d..12184a4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1668,6 +1668,17 @@ out:
 	spin_lock_irq(q->queue_lock);
 }
 
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
index d65fbec..4d43642 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -325,6 +325,7 @@ extern void starget_for_each_device(struct scsi_target *, void *,
 extern void __starget_for_each_device(struct scsi_target *, void *,
 				      void (*fn)(struct scsi_device *,
 						 void *));
+extern struct scsi_device *scsi_device_from_queue(struct request_queue *);
 
 /* only exposed to implement shost_for_each_device */
 extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
-- 
1.7.12.4

