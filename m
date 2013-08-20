From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/7] Introduce scsi_device_being_removed()
Date: Tue, 20 Aug 2013 14:06:35 +0200
Message-ID: <52135BCB.9000902@acm.org>
References: <52135B99.2000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:55146 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3HTMGg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 08:06:36 -0400
In-Reply-To: <52135B99.2000102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Introduce the helper function scsi_device_being_removed(). This patch
does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Hannes Reinecke <hare@suse.de>
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
index a44954c..69540bf 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -455,6 +455,11 @@ static inline int scsi_device_created(struct scsi_device *sdev)
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

