From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH v3 1/4] block: add a flag to identify PM request
Date: Tue, 22 May 2012 15:21:29 +0800
Message-ID: <1337671292-15583-2-git-send-email-ming.m.lin@intel.com>
References: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49152 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab2EVHVy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 03:21:54 -0400
In-Reply-To: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

Add a flag REQ_PM to identify the request is PM related.
As an example, modify scsi code to use this flag.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_lib.c    |   25 ++++++++++++++++++++++---
 drivers/scsi/sd.c          |    9 +++++----
 include/linux/blk_types.h  |    2 ++
 include/scsi/scsi_device.h |    4 ++++
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5dfd749..db4a40d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -256,10 +256,10 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 EXPORT_SYMBOL(scsi_execute);
 
 
-int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
+static int __scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 		     int data_direction, void *buffer, unsigned bufflen,
 		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
-		     int *resid)
+		     int *resid, int flags)
 {
 	char *sense = NULL;
 	int result;
@@ -270,15 +270,34 @@ int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
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
+
+int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
+		     int data_direction, void *buffer, unsigned bufflen,
+		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
+		     int *resid)
+{
+	return __scsi_execute_req(sdev, cmd, data_direction, buffer, bufflen,
+			      sshdr, timeout, retries, resid, 0);
+}
 EXPORT_SYMBOL(scsi_execute_req);
 
+int scsi_execute_req_flag(struct scsi_device *sdev, const unsigned char *cmd,
+		     int data_direction, void *buffer, unsigned bufflen,
+		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
+		     int *resid, int flags)
+{
+	return __scsi_execute_req(sdev, cmd, data_direction, buffer, bufflen,
+			      sshdr, timeout, retries, resid, flags);
+}
+EXPORT_SYMBOL(scsi_execute_req_flag);
+
 /*
  * Function:    scsi_init_cmd_errh()
  *
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5ba5c2a..1205a8b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1269,8 +1269,9 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL);
+		res = scsi_execute_req_flag(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL,
+				       REQ_PM);
 		if (res == 0)
 			break;
 	}
@@ -2812,8 +2813,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-			       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+	res = scsi_execute_req_flag(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+			       SD_TIMEOUT, SD_MAX_RETRIES, NULL, REQ_PM);
 	if (res) {
 		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
 		sd_print_result(sdkp, res);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..a75f854 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -150,6 +150,7 @@ enum rq_flag_bits {
 	__REQ_FLUSH_SEQ,	/* request for flush sequence */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
+	__REQ_PM,		/* runtime pm request */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -191,5 +192,6 @@ enum rq_flag_bits {
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
+#define REQ_PM			(1 << __REQ_PM)
 
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..7735b46 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -387,6 +387,10 @@ extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries,
 			    int *resid);
+extern int scsi_execute_req_flag(struct scsi_device *sdev, const unsigned char *cmd,
+			    int data_direction, void *buffer, unsigned bufflen,
+			    struct scsi_sense_hdr *, int timeout, int retries,
+			    int *resid, int flags);
 
 #ifdef CONFIG_PM_RUNTIME
 extern int scsi_autopm_get_device(struct scsi_device *);
-- 
1.7.2.5

