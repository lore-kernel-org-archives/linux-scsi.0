From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/18] scsi: ignore errors from scsi_dh_add_device()
Date: Tue,  1 Dec 2015 10:16:42 +0100
Message-ID: <1448961418-29013-3-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbbLAJRC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:02 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

device handler initialisation might fail due to a number of
reasons. But as device_handlers are optional this shouldn't
cause us to disable the device entirely.
So just ignore errors from scsi_dh_add_device().

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fc3cd26..d015374 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1120,11 +1120,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
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

