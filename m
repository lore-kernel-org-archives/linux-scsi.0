From: Thierry Escande <thierry.escande@collabora.com>
Subject: [PATCH v2] sd: Ignore sync cache failures when not supported
Date: Thu,  4 May 2017 11:43:30 +0200
Message-ID: <1493891010-24258-1-git-send-email-thierry.escande@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Transfert-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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

v2 changes:
- Change sense_key type to u8 in sd_sync_cache()

 drivers/scsi/sd.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fcfeddc..6c6db1b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1489,7 +1489,7 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return retval;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp)
+static int sd_sync_cache(struct scsi_disk *sdkp, u8 *sense_key)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
@@ -1517,8 +1517,11 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
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
@@ -3323,7 +3326,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp);
+		sd_sync_cache(sdkp, NULL);
 	}
 
 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
@@ -3335,6 +3338,7 @@ static void sd_shutdown(struct device *dev)
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	u8 sense_key = NO_SENSE;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3342,8 +3346,17 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 
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
@@ -3351,6 +3364,7 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 		}
 	}
 
+start_stop:
 	if (sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		/* an error is not worth aborting a system sleep */
-- 
2.7.4
