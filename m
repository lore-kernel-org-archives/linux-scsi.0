From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 2/2] [SCSI] sd: update sd to use the new pm callbacks
Date: Wed, 10 Oct 2012 15:28:06 +0800
Message-ID: <1349854086-2502-3-git-send-email-aaron.lu@intel.com>
References: <1349854086-2502-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38350 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab2JJH2h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 03:28:37 -0400
In-Reply-To: <1349854086-2502-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Update sd driver to use the callbacks defined in dev_pm_ops.

sd_freeze is NULL, the bus level callback has taken care of quiescing
the device so there should be nothing needs to be done here.
Consequently, sd_thaw is not needed here either.

Both suspend and poweroff shares the same routine sd_suspend, which will
sync flush and then stop the drive, this is the same as before.

sd_runtime_suspend also uses sd_suspend, so when a scsi disk is runtime
suspended, it will be placed to stopped power state.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..09ab14a 100644
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
 
+static struct dev_pm_ops sd_pm_ops = {
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
@@ -2911,7 +2919,7 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 			goto done;
 	}
 
-	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
+	if (sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
 	}
-- 
1.7.12.21.g871e293

