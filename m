From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 1/4] block: add a flag to identify PM request
Date: Wed, 30 Jan 2013 17:34:51 +0800
Message-ID: <1359538494-2936-2-git-send-email-aaron.lu@intel.com>
References: <1359538494-2936-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359538494-2936-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

Add a flag REQ_PM to identify the request is PM related, such requests
will not change the device request queue's runtime status. It is
intended to be used in driver's runtime PM callback, so that driver can
perform some IO to the device there with the queue's runtime status
unaffected. e.g. in SCSI disk's runtime suspend callback, the disk will
be put into stopped power state, and this require sending a command to
the device. Such command processing should not change the disk's runtime
status.

As an example, modify scsi code to use this flag.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_lib.c    |  9 ++++-----
 drivers/scsi/sd.c          |  8 ++++----
 include/linux/blk_types.h  |  2 ++
 include/scsi/scsi_device.h | 16 ++++++++++++----
 4 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 765398c..23f795f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -271,11 +271,10 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
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
@@ -286,14 +285,14 @@ int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
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
index 7992635..698923f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1424,8 +1424,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL);
+		res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+				SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL, REQ_PM);
 		if (res == 0)
 			break;
 	}
@@ -3021,8 +3021,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-			       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+	res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+			       SD_TIMEOUT, SD_MAX_RETRIES, NULL, REQ_PM);
 	if (res) {
 		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
 		sd_print_result(sdkp, res);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index cdf1119..fcc1ce2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -175,6 +175,7 @@ enum rq_flag_bits {
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_KERNEL, 		/* direct IO to kernel pages */
+	__REQ_PM,		/* runtime pm request */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -223,5 +224,6 @@ enum rq_flag_bits {
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
 #define REQ_KERNEL		(1 << __REQ_KERNEL)
+#define REQ_PM			(1 << __REQ_PM)
 
 #endif /* __LINUX_BLK_TYPES_H */
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
1.8.1
