From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 3/9] Introduce scsi_device_being_removed()
Date: Thu, 06 Dec 2012 16:55:01 +0100
Message-ID: <50C0BFD5.9030604@acm.org>
References: <50C0BEEE.4040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:50984 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424105Ab2LFPzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 10:55:06 -0500
In-Reply-To: <50C0BEEE.4040907@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh.c |    7 ++-----
 include/scsi/scsi_device.h            |    5 +++++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 33e422e..78b3ddb 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -156,8 +156,7 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 	struct scsi_device_handler *scsi_dh;
 	int err = -EINVAL;
 
-	if (sdev->sdev_state == SDEV_CANCEL ||
-	    sdev->sdev_state == SDEV_DEL)
+	if (scsi_device_being_removed(sdev))
 		return -ENODEV;
 
 	if (!sdev->scsi_dh_data) {
@@ -400,9 +399,7 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	if (sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 	dev = get_device(&sdev->sdev_gendev);
-	if (!scsi_dh || !dev ||
-	    sdev->sdev_state == SDEV_CANCEL ||
-	    sdev->sdev_state == SDEV_DEL)
+	if (!scsi_dh || !dev || scsi_device_being_removed(sdev))
 		err = SCSI_DH_NOSYS;
 	if (sdev->sdev_state == SDEV_OFFLINE)
 		err = SCSI_DH_DEV_OFFLINED;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 55367b0..767dd16 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -442,6 +442,11 @@ static inline int scsi_device_created(struct scsi_device *sdev)
 	return sdev->sdev_state == SDEV_CREATED ||
 		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
+static inline int scsi_device_being_removed(struct scsi_device *sdev)
+{
+	return sdev->sdev_state == SDEV_CANCEL ||
+		sdev->sdev_state == SDEV_DEL;
+}
 
 /* accessor functions for the SCSI parameters */
 static inline int scsi_device_sync(struct scsi_device *sdev)
-- 
1.7.10.4

