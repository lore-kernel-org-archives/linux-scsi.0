From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v4 5/5] sd: update sd to use the new pm callbacks
Date: Fri,  9 Nov 2012 15:27:55 +0800
Message-ID: <1352446075-1814-6-git-send-email-aaron.lu@intel.com>
References: <1352446075-1814-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34949 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab2KIH2X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2012 02:28:23 -0500
In-Reply-To: <1352446075-1814-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Update sd driver to use the callbacks defined in dev_pm_ops.

sd_freeze is NULL, the bus level callback has taken care of quiescing
the device so there should be nothing needs to be done here.
Consequently, sd_thaw is not needed here either.

suspend, poweroff and runtime suspend share the same routine sd_suspend,
which will sync flush and then stop the drive, this is the same as before.

resume, restore and runtime resume share the same routine sd_resume,
which will start the drive by putting it into active power state, this
is also the same as before.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/scsi/sd.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8b6e004..6564305 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -104,7 +104,7 @@ static void sd_unlock_native_capacity(struct gendisk *disk);
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
-static int sd_suspend(struct device *, pm_message_t state);
+static int sd_suspend(struct device *);
 static int sd_resume(struct device *);
 static void sd_rescan(struct device *);
 static int sd_done(struct scsi_cmnd *);
@@ -423,15 +423,23 @@ static struct class sd_disk_class = {
 	.dev_attrs	= sd_disk_attrs,
 };
 
+static const struct dev_pm_ops sd_pm_ops = {
+	.suspend		= sd_suspend,
+	.resume			= sd_resume,
+	.poweroff		= sd_suspend,
+	.restore		= sd_resume,
+	.runtime_suspend	= sd_suspend,
+	.runtime_resume		= sd_resume,
+};
+
 static struct scsi_driver sd_template = {
 	.owner			= THIS_MODULE,
 	.gendrv = {
 		.name		= "sd",
 		.probe		= sd_probe,
 		.remove		= sd_remove,
-		.suspend	= sd_suspend,
-		.resume		= sd_resume,
 		.shutdown	= sd_shutdown,
+		.pm		= &sd_pm_ops,
 	},
 	.rescan			= sd_rescan,
 	.done			= sd_done,
@@ -2896,7 +2904,7 @@ exit:
 	scsi_disk_put(sdkp);
 }
 
-static int sd_suspend(struct device *dev, pm_message_t mesg)
+static int sd_suspend(struct device *dev)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret = 0;
@@ -2911,8 +2919,7 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 			goto done;
 	}
 
-	if (((mesg.event & PM_EVENT_SLEEP) || PMSG_IS_AUTO(mesg)) &&
-			sdkp->device->manage_start_stop) {
+	if (sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
 	}
-- 
1.7.12.21.g871e293

