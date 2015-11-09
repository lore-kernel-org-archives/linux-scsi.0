From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/18] scsi: ignore errors from scsi_dh_add_device()
Date: Mon,  9 Nov 2015 16:08:07 +0100
Message-ID: <1447081703-110552-3-git-send-email-hare@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbbKIPIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 10:08:25 -0500
In-Reply-To: <1447081703-110552-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

device handler initialisation might fail due to a number of
reasons. But as device_handlers are optional this shouldn't
cause us to disable the device entirely.
So just ignore errors from scsi_dh_add_device().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 13a5ede..7b41b2c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1118,11 +1118,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
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

