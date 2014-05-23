From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: scsi: storvsc: Change the limits to reflect the values on the host
Date: Thu, 22 May 2014 19:51:52 -0700
Message-ID: <1400813512-22394-1-git-send-email-kys@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hyper-V hosts can support multiple targets and multiple channels and larger number of
LUNs per target. Update the code to reflect this. With this patch we can correctly
enumerate all the paths in a multi-path storage environment.

MS-TFS: 173725

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9969fa1..5a63772 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -331,16 +331,15 @@ static int storvsc_timeout = 180;
 static void storvsc_on_channel_callback(void *context);
 
 /*
- * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In
- * reality, the path/target is not used (ie always set to 0) so our
- * scsi host adapter essentially has 1 bus with 1 target that contains
- * up to 256 luns.
+ * In Hyper-V, each port/path/target maps to 1 scsi host adapter.
  */
-#define STORVSC_MAX_LUNS_PER_TARGET			64
-#define STORVSC_MAX_TARGETS				1
-#define STORVSC_MAX_CHANNELS				1
-
+#define STORVSC_MAX_LUNS_PER_TARGET			255
+#define STORVSC_MAX_TARGETS				2
+#define STORVSC_MAX_CHANNELS				8
 
+#define STORVSC_FC_MAX_LUNS_PER_TARGET			255
+#define STORVSC_FC_MAX_TARGETS				128
+#define STORVSC_FC_MAX_CHANNELS				8
 
 struct storvsc_cmd_request {
 	struct list_head entry;
@@ -1789,12 +1788,21 @@ static int storvsc_probe(struct hv_device *device,
 	host_dev->path = stor_device->path_id;
 	host_dev->target = stor_device->target_id;
 
-	/* max # of devices per target */
-	host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
-	/* max # of targets per channel */
-	host->max_id = STORVSC_MAX_TARGETS;
-	/* max # of channels */
-	host->max_channel = STORVSC_MAX_CHANNELS - 1;
+	if (dev_id->driver_data == SFC_GUID) {
+		/* max # of devices per target */
+		host->max_lun = STORVSC_FC_MAX_LUNS_PER_TARGET;
+		/* max # of targets per channel */
+		host->max_id = STORVSC_FC_MAX_TARGETS;
+		/* max # of channels */
+		host->max_channel = STORVSC_FC_MAX_CHANNELS - 1;
+	} else {
+		/* max # of devices per target */
+		host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
+		/* max # of targets per channel */
+		host->max_id = STORVSC_MAX_TARGETS;
+		/* max # of channels */
+		host->max_channel = STORVSC_MAX_CHANNELS - 1;
+	}
 	/* max cmd length */
 	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
 
-- 
1.7.4.1
