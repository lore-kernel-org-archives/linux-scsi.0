From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH]SCSI: No sleep stop for devices in disconnection
Date: Wed, 6 Oct 2010 15:45:17 +0200
Message-ID: <201010061545.18215.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57973 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab0JFNoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 09:44:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, hare@suse.de

>From 75de5ee7afc17322c61a1188b21e59b13b4a2bdb Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Wed, 6 Oct 2010 15:33:37 +0200
Subject: [PATCH] SCSI: No sleep stop for devices in disconnection

If the system is going to sleep while a device is being
disconnected, the commands send during preparation for
sleep are likely to fail. However if that happens it
can be ignored as the devices are going away anyway.
This can happen with eSATA because it takes long to
process a disconnection.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/scsi_pm.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d70e91a..9285726 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -17,16 +17,27 @@
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
+	case SDEV_CANCEL:
+	case SDEV_DEL:
+		/* lost a race against a disconnection handler */
+		return 0;
+	default:
+		return err;
+	}
 }
 
 static int scsi_dev_type_resume(struct device *dev)
-- 
1.7.1

