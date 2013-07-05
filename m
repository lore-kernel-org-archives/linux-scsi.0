From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v14 3/6] Introduce scsi_device_being_removed()
Date: Fri, 05 Jul 2013 15:25:23 +0200
Message-ID: <51D6C943.30504@acm.org>
References: <51D6C885.9050000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:35796 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3GENZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jul 2013 09:25:25 -0400
In-Reply-To: <51D6C885.9050000@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, David Milburn <dmilburn@redhat.com>

Introduce the helper function scsi_device_being_removed(). This patch
does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
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
index cc64587..fead252 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -454,6 +454,11 @@ static inline int scsi_device_created(struct scsi_device *sdev)
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

