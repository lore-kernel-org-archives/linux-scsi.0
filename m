From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v12 2/5] scsi: use REQ_PM in sd's runtime suspend operation
Date: Sat, 23 Mar 2013 11:42:25 +0800
Message-ID: <1364010148-8584-3-git-send-email-aaron.lu@intel.com>
References: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oneukum@suse.de>
List-Id: linux-scsi@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

With the introduction of REQ_PM, modify sd's runtime suspend operation
functions to use that flag so that the operations to put the device into
runtime suspended state(i.e. sync cache and stop device) will not affect
its runtime PM status.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/scsi/scsi_lib.c    |  9 ++++-----
 drivers/scsi/sd.c          |  9 +++++----
 include/scsi/scsi_device.h | 16 ++++++++++++----
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c31187d..86d5220 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -276,11 +276,10 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 }
 EXPORT_SYMBOL(scsi_execute);
 
-
-int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
+int scsi_execute_req_flags(struct scsi_device *sdev, const unsigned char *cmd,
 		     int data_direction, void *buffer, unsigned bufflen,
 		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
-		     int *resid)
+		     int *resid, int flags)
 {
 	char *sense = NULL;
 	int result;
@@ -291,14 +290,14 @@ int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			return DRIVER_ERROR << 24;
 	}
 	result = scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
-			      sense, timeout, retries, 0, resid);
+			      sense, timeout, retries, flags, resid);
 	if (sshdr)
 		scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, sshdr);
 
 	kfree(sense);
 	return result;
 }
-EXPORT_SYMBOL(scsi_execute_req);
+EXPORT_SYMBOL(scsi_execute_req_flags);
 
 /*
  * Function:    scsi_init_cmd_errh()
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..c6e2b34 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1424,8 +1424,9 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL);
+		res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0,
+					     &sshdr, SD_FLUSH_TIMEOUT,
+					     SD_MAX_RETRIES, NULL, REQ_PM);
 		if (res == 0)
 			break;
 	}
@@ -3021,8 +3022,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-			       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+	res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+			       SD_TIMEOUT, SD_MAX_RETRIES, NULL, REQ_PM);
 	if (res) {
 		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
 		sd_print_result(sdkp, res);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a7f9cba..cc64587 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -394,10 +394,18 @@ extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, int timeout, int retries,
 			int flag, int *resid);
-extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
-			    int data_direction, void *buffer, unsigned bufflen,
-			    struct scsi_sense_hdr *, int timeout, int retries,
-			    int *resid);
+extern int scsi_execute_req_flags(struct scsi_device *sdev,
+	const unsigned char *cmd, int data_direction, void *buffer,
+	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
+	int retries, int *resid, int flags);
+static inline int scsi_execute_req(struct scsi_device *sdev,
+	const unsigned char *cmd, int data_direction, void *buffer,
+	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
+	int retries, int *resid)
+{
+	return scsi_execute_req_flags(sdev, cmd, data_direction, buffer,
+		bufflen, sshdr, timeout, retries, resid, 0);
+}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 
-- 
1.8.1.4
