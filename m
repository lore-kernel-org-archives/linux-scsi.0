From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] scsi_dh_alua: suppress errors from unsupported devices
Date: Tue,  8 Aug 2017 10:53:33 +0200
Message-ID: <1502182413-23560-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53255 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752944AbdHHIxg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 04:53:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

ALUA is only relevant for disk-like devices, so we shouldn't
be printing out warning messages for other device types.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |  2 ++
 drivers/scsi/scsi_dh.c                     | 15 +++++++++------
 drivers/scsi/scsi_priv.h                   |  2 +-
 drivers/scsi/scsi_sysfs.c                  |  8 +-------
 4 files changed, 13 insertions(+), 14 deletions(-)

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
index 84addee..df521aba 100644
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
@@ -153,18 +154,20 @@ static void scsi_dh_handler_detach(struct scsi_device *sdev)
 	module_put(sdev->handler->module);
 }
 
-int scsi_dh_add_device(struct scsi_device *sdev)
+void scsi_dh_add_device(struct scsi_device *sdev)
 {
 	struct scsi_device_handler *devinfo = NULL;
 	const char *drv;
-	int err = 0;
 
 	drv = scsi_dh_find_driver(sdev);
 	if (drv)
 		devinfo = __scsi_dh_lookup(drv);
+	/*
+	 * device_handler is optional, so ignore errors
+	 * from scsi_dh_handler_attach()
+	 */
 	if (devinfo)
-		err = scsi_dh_handler_attach(sdev, devinfo);
-	return err;
+		scsi_dh_handler_attach(sdev, devinfo);
 }
 
 void scsi_dh_release_device(struct scsi_device *sdev)
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index c11c1f9c..f2925a2 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -176,7 +176,7 @@ static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 
 /* scsi_dh.c */
 #ifdef CONFIG_SCSI_DH
-int scsi_dh_add_device(struct scsi_device *sdev);
+void scsi_dh_add_device(struct scsi_device *sdev);
 void scsi_dh_release_device(struct scsi_device *sdev);
 #else
 static inline int scsi_dh_add_device(struct scsi_device *sdev) { return 0; }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d6984df..a8d3f8b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1221,13 +1221,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 
 	scsi_autopm_get_device(sdev);
 
-	error = scsi_dh_add_device(sdev);
-	if (error)
-		/*
-		 * device_handler is optional, so any error can be ignored
-		 */
-		sdev_printk(KERN_INFO, sdev,
-				"failed to add device handler: %d\n", error);
+	scsi_dh_add_device(sdev);
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-- 
1.8.5.6
