From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_dh_alua: suppress errors from unsupported devices
Date: Fri,  4 Aug 2017 08:37:40 +0200
Message-ID: <1501828660-89497-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56101 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751261AbdHDGhq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Aug 2017 02:37:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

ALUA is only relevant for disk-like devices, so we shouldn't
be printing out warning messages for other device types.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 ++
 drivers/scsi/scsi_dh.c                     | 5 +++--
 drivers/scsi/scsi_sysfs.c                  | 7 +------
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0962fd5..c3aea06 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1100,6 +1100,8 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	err = alua_initialize(sdev, h);
 	if (err == SCSI_DH_NOMEM)
 		ret = -ENOMEM;
+	if (err == SCSI_DH_DEV_UNSUPP)
+		ret = -ENODEV;
 	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
 		goto failed;
 
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 84addee..16e780d 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -133,8 +133,9 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 
 	error = scsi_dh->attach(sdev);
 	if (error) {
-		sdev_printk(KERN_ERR, sdev, "%s: Attach failed (%d)\n",
-			    scsi_dh->name, error);
+		if (error != -ENODEV)
+			sdev_printk(KERN_ERR, sdev, "%s: Attach failed (%d)\n",
+				    scsi_dh->name, error);
 		module_put(scsi_dh->module);
 	} else
 		sdev->handler = scsi_dh;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d6984df..5e8ace2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1222,12 +1222,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	scsi_autopm_get_device(sdev);
 
 	error = scsi_dh_add_device(sdev);
-	if (error)
-		/*
-		 * device_handler is optional, so any error can be ignored
-		 */
-		sdev_printk(KERN_INFO, sdev,
-				"failed to add device handler: %d\n", error);
+	/* device_handler is optional, so any error can be ignored */
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-- 
1.8.5.6
