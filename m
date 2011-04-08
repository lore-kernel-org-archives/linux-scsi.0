From: Mike Snitzer <snitzer@redhat.com>
Subject: [RESEND][2.6.39-rc PATCH] [SCSI] scsi_dh: fix reference counting in
 scsi_dh_activate error path
Date: Fri, 8 Apr 2011 15:05:36 -0400
Message-ID: <20110408190536.GA11001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab1DHTFk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2011 15:05:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

Commit db422318cbca55168cf965f655471dbf8be82433 ([SCSI] scsi_dh:
propagate SCSI device deletion) introduced a regression where the device
reference is not dropped prior to scsi_dh_activate's early return from
the error path.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@kernel.org # 2.6.38
---
 drivers/scsi/device_handler/scsi_dh.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

(I embedded this fix in another scsi_dh_emc thread on 3/21 so figured I'd resend to
get it back on the radar)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 564e6ec..0119b81 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -394,12 +394,14 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	unsigned long flags;
 	struct scsi_device *sdev;
 	struct scsi_device_handler *scsi_dh = NULL;
+	struct device *dev = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	sdev = q->queuedata;
 	if (sdev && sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-	if (!scsi_dh || !get_device(&sdev->sdev_gendev) ||
+	dev = get_device(&sdev->sdev_gendev);
+	if (!scsi_dh || !dev ||
 	    sdev->sdev_state == SDEV_CANCEL ||
 	    sdev->sdev_state == SDEV_DEL)
 		err = SCSI_DH_NOSYS;
@@ -410,12 +412,13 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	if (err) {
 		if (fn)
 			fn(data, err);
-		return err;
+		goto out;
 	}
 
 	if (scsi_dh->activate)
 		err = scsi_dh->activate(sdev, fn, data);
-	put_device(&sdev->sdev_gendev);
+out:
+	put_device(dev);
 	return err;
 }
 EXPORT_SYMBOL_GPL(scsi_dh_activate);

