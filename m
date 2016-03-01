From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] scsi_sysfs: call 'device_add' after attaching device handler
Date: Tue,  1 Mar 2016 05:55:43 +0100
Message-ID: <1456808143-88932-7-git-send-email-hare@suse.de>
References: <1456808143-88932-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbcCAE4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 23:56:09 -0500
In-Reply-To: <1456808143-88932-1-git-send-email-hare@suse.de>
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

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b6a1af8..4e7f944 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1226,13 +1226,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 
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
@@ -1241,6 +1234,13 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		sdev_printk(KERN_INFO, sdev,
 				"failed to add device handler: %d\n", error);
 
+	error = device_add(&sdev->sdev_gendev);
+	if (error) {
+		sdev_printk(KERN_INFO, sdev,
+				"failed to add device: %d\n", error);
+		return error;
+	}
+
 	device_enable_async_suspend(&sdev->sdev_dev);
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
-- 
2.6.2

