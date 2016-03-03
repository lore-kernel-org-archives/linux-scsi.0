From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 6/6] scsi_sysfs: call 'device_add' after attaching device handler
Date: Thu,  3 Mar 2016 07:54:12 +0100
Message-ID: <1456988052-78791-7-git-send-email-hare@suse.de>
References: <1456988052-78791-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbcCCGy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Mar 2016 01:54:28 -0500
In-Reply-To: <1456988052-78791-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

'device_add' will be evaluating the 'is_visible' callback
when creating the sysfs attributes. As by this time the
device handler has not been attached the 'access_state'
attribute will never be visible.

This patch moves the code around so that the device handler
is present by the time 'is_visible' is evaluated to
correctly display the 'access_state' attribute.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c5ac171..d164419 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1220,13 +1220,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 
 	scsi_autopm_get_device(sdev);
 
-	error = device_add(&sdev->sdev_gendev);
-	if (error) {
-		sdev_printk(KERN_INFO, sdev,
-				"failed to add device: %d\n", error);
-		return error;
-	}
-
 	error = scsi_dh_add_device(sdev);
 	if (error)
 		/*
@@ -1235,6 +1228,14 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		sdev_printk(KERN_INFO, sdev,
 				"failed to add device handler: %d\n", error);
 
+	error = device_add(&sdev->sdev_gendev);
+	if (error) {
+		sdev_printk(KERN_INFO, sdev,
+				"failed to add device: %d\n", error);
+		scsi_dh_remove_device(sdev);
+		return error;
+	}
+
 	device_enable_async_suspend(&sdev->sdev_dev);
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
-- 
1.8.5.6

