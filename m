From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH]SCSI:Do not block suspend for abandoned devices
Date: Tue, 5 Oct 2010 17:21:25 +0200
Message-ID: <201010051721.25431.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab0JEPU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2010 11:20:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, hare@suse.de

>From d0e0b88a5b271a45f00ab8ae9f22b992d5d090ba Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Tue, 5 Oct 2010 17:06:46 +0200
Subject: [PATCH] SCSI:Do not block suspend for abandoned devices

If a device becomes inaccessible while a suspension
is carried out, the device is gone anyhow. There's
no need to block the suspension, as we'd ignore the
devices on later attempts anyway.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/scsi_pm.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d70e91a..396a60c 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -17,16 +17,28 @@
 static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 {
 	struct device_driver *drv;
-	int err;
+	struct scsi_device *sdev;
+	int err, state;
 
-	err = scsi_device_quiesce(to_scsi_device(dev));
+	sdev = to_scsi_device(dev);
+	err = scsi_device_quiesce(sdev);
 	if (err == 0) {
 		drv = dev->driver;
 		if (drv && drv->suspend)
 			err = drv->suspend(dev, msg);
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
-	return err;
+	
+	state = sdev->sdev_state;
+	switch (state) {
+	case SDEV_OFFLINE:
+	case SDEV_CANCEL:
+	case SDEV_DEL:
+		/* the device is dead, we can ignore the problem */
+		return 0;
+	default:
+		return err;
+	}
 }
 
 static int scsi_dev_type_resume(struct device *dev)
-- 
1.7.1



