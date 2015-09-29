From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/36] scsi: ignore errors from scsi_dh_add_device()
Date: Tue, 29 Sep 2015 12:47:04 +0200
Message-ID: <1443523658-87622-3-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934615AbbI2Kru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:50 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

device handler initialisation might fail due to a number of
reasons. But as device_handlers are optional this shouldn't
cause us to disable the device entirely.
So just ignore errors from scsi_dh_add_device().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5d64c3f..81d05ec 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1090,11 +1090,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	}
 
 	error = scsi_dh_add_device(sdev);
-	if (error) {
+	if (error)
+		/*
+		 * device_handler is optional, so any error can be ignored
+		 */
 		sdev_printk(KERN_INFO, sdev,
 				"failed to add device handler: %d\n", error);
-		return error;
-	}
 
 	device_enable_async_suspend(&sdev->sdev_dev);
 	error = device_add(&sdev->sdev_dev);
-- 
1.8.5.6

