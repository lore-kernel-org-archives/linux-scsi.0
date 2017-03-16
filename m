From: Thierry Escande <thierry.escande@collabora.com>
Subject: [PATCH] sd: Ignore sync cache failures when not supported
Date: Thu, 16 Mar 2017 17:48:52 +0100
Message-ID: <1489682932-18543-1-git-send-email-thierry.escande@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53783 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752490AbdCPQtH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2017 12:49:07 -0400
Content-Transfert-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Derek Basehore <dbasehore@chromium.org>

Some external hard drives don't support the sync command even though the
hard drive has write cache enabled. In this case, upon suspend request,
sync cache failures are ignored if the error code in the sense header is
ILLEGAL_REQUEST. There's not much we can do for these drives, so we
shouldn't fail to suspend for this error case. The drive may stay
powered if that's the setup for the port it's plugged into.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/scsi/sd.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b193304..c0388ff 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1492,7 +1492,7 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return retval;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp)
+static int sd_sync_cache(struct scsi_disk *sdkp, int *sense_key)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
@@ -1521,8 +1521,11 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-		if (driver_byte(res) & DRIVER_SENSE)
+		if (driver_byte(res) & DRIVER_SENSE) {
 			sd_print_sense_hdr(sdkp, &sshdr);
+			if (sense_key)
+				*sense_key = sshdr.sense_key;
+		}
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(&sshdr) &&
 			(sshdr.asc == 0x3a ||	/* medium not present */
@@ -3304,7 +3307,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp);
+		sd_sync_cache(sdkp, NULL);
 	}
 
 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
@@ -3316,6 +3319,7 @@ static void sd_shutdown(struct device *dev)
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	int sense_key = NO_SENSE;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3323,8 +3327,17 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp);
+		ret = sd_sync_cache(sdkp, &sense_key);
 		if (ret) {
+			/*
+			 * If this drive doesn't support sync, there's not much
+			 * to do and suspend shouldn't fail.
+			 */
+			if (sense_key == ILLEGAL_REQUEST) {
+				ret = 0;
+				goto start_stop;
+			}
+
 			/* ignore OFFLINE device */
 			if (ret == -ENODEV)
 				ret = 0;
@@ -3332,6 +3345,7 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 		}
 	}
 
+start_stop:
 	if (sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		/* an error is not worth aborting a system sleep */
-- 
2.7.4
