From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/16] scsi_dh: return individual errors in scsi_dh_activate()
Date: Fri, 20 Dec 2013 13:13:37 +0100
Message-ID: <1387541621-54967-13-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab3LTMNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:45 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

When calling scsi_dh_activate() we should be returning
individual errors and not lumping all into one.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 33e422e..ae7f399 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -381,7 +381,7 @@ EXPORT_SYMBOL_GPL(scsi_unregister_device_handler);
  */
 int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 {
-	int err = 0;
+	int err = SCSI_DH_OK;
 	unsigned long flags;
 	struct scsi_device *sdev;
 	struct scsi_device_handler *scsi_dh = NULL;
@@ -400,15 +400,18 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	if (sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 	dev = get_device(&sdev->sdev_gendev);
-	if (!scsi_dh || !dev ||
-	    sdev->sdev_state == SDEV_CANCEL ||
-	    sdev->sdev_state == SDEV_DEL)
+	if (!scsi_dh)
 		err = SCSI_DH_NOSYS;
-	if (sdev->sdev_state == SDEV_OFFLINE)
+	else if (!dev)
+		err = SCSI_DH_DEV_OFFLINED;
+	else if (sdev->sdev_state == SDEV_CANCEL ||
+		 sdev->sdev_state == SDEV_DEL)
+		err = SCSI_DH_NOTCONN;
+	else if (sdev->sdev_state == SDEV_OFFLINE)
 		err = SCSI_DH_DEV_OFFLINED;
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	if (err) {
+	if (err != SCSI_DH_OK) {
 		if (fn)
 			fn(data, err);
 		goto out;
@@ -417,7 +420,8 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	if (scsi_dh->activate)
 		err = scsi_dh->activate(sdev, fn, data);
 out:
-	put_device(dev);
+	if (dev)
+		put_device(dev);
 	return err;
 }
 EXPORT_SYMBOL_GPL(scsi_dh_activate);
-- 
1.7.12.4

