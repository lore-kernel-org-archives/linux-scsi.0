From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v8 03/10] Introduce scsi_device_being_removed()
Date: Tue, 05 Feb 2013 13:47:16 +0100
Message-ID: <5110FF54.9090301@acm.org>
References: <5110FE98.8030209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:41694 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3BEMrR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 07:47:17 -0500
In-Reply-To: <5110FE98.8030209@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh.c |    7 ++-----
 include/scsi/scsi_device.h            |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

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
index e65c62e..1dbf4ac 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -427,54 +427,69 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
 /*
  * checks for positions of the SCSI state machine
  */
+
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return (sdev->sdev_state != SDEV_OFFLINE &&
 		sdev->sdev_state != SDEV_TRANSPORT_OFFLINE &&
 		sdev->sdev_state != SDEV_DEL);
 }
+
 static inline int scsi_device_blocked(struct scsi_device *sdev)
 {
 	return sdev->sdev_state == SDEV_BLOCK ||
 		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
+
 static inline int scsi_device_created(struct scsi_device *sdev)
 {
 	return sdev->sdev_state == SDEV_CREATED ||
 		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
 
+static inline int scsi_device_being_removed(struct scsi_device *sdev)
+{
+	return sdev->sdev_state == SDEV_CANCEL ||
+		sdev->sdev_state == SDEV_DEL;
+}
+
 /* accessor functions for the SCSI parameters */
 static inline int scsi_device_sync(struct scsi_device *sdev)
 {
 	return sdev->sdtr;
 }
+
 static inline int scsi_device_wide(struct scsi_device *sdev)
 {
 	return sdev->wdtr;
 }
+
 static inline int scsi_device_dt(struct scsi_device *sdev)
 {
 	return sdev->ppr;
 }
+
 static inline int scsi_device_dt_only(struct scsi_device *sdev)
 {
 	if (sdev->inquiry_len < 57)
 		return 0;
 	return (sdev->inquiry[56] & 0x0c) == 0x04;
 }
+
 static inline int scsi_device_ius(struct scsi_device *sdev)
 {
 	if (sdev->inquiry_len < 57)
 		return 0;
 	return sdev->inquiry[56] & 0x01;
 }
+
 static inline int scsi_device_qas(struct scsi_device *sdev)
 {
 	if (sdev->inquiry_len < 57)
 		return 0;
 	return sdev->inquiry[56] & 0x02;
 }
+
 static inline int scsi_device_enclosure(struct scsi_device *sdev)
 {
 	return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
-- 
1.7.10.4

