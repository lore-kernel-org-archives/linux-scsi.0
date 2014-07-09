From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect the
 values on the host
Date: Tue,  8 Jul 2014 17:46:45 -0700
Message-ID: <1404866812-26950-1-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1404866789-26910-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hyper-V hosts can support multiple targets and multiple channels and larger number of
LUNs per target. Update the code to reflect this. With this patch we can correctly
enumerate all the paths in a multi-path storage environment.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   53 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9969fa1..2e4131c 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -331,16 +331,19 @@ static int storvsc_timeout = 180;
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
+#define STORVSC_MAX_LUNS_PER_TARGET			255
+#define STORVSC_MAX_TARGETS				2
+#define STORVSC_MAX_CHANNELS				8
 
+#define STORVSC_FC_MAX_LUNS_PER_TARGET			255
+#define STORVSC_FC_MAX_TARGETS				128
+#define STORVSC_FC_MAX_CHANNELS				8
 
+#define STORVSC_IDE_MAX_LUNS_PER_TARGET			64
+#define STORVSC_IDE_MAX_TARGETS				1
+#define STORVSC_IDE_MAX_CHANNELS			1
 
 struct storvsc_cmd_request {
 	struct list_head entry;
@@ -1690,7 +1693,7 @@ static struct scsi_host_template scsi_driver = {
 	.slave_alloc =		storvsc_device_alloc,
 	.slave_destroy =	storvsc_device_destroy,
 	.slave_configure =	storvsc_device_configure,
-	.cmd_per_lun =		1,
+	.cmd_per_lun =		255,
 	/* 64 max_queue * 1 target */
 	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
 	.this_id =		-1,
@@ -1789,12 +1792,34 @@ static int storvsc_probe(struct hv_device *device,
 	host_dev->path = stor_device->path_id;
 	host_dev->target = stor_device->target_id;
 
-	/* max # of devices per target */
-	host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
-	/* max # of targets per channel */
-	host->max_id = STORVSC_MAX_TARGETS;
-	/* max # of channels */
-	host->max_channel = STORVSC_MAX_CHANNELS - 1;
+	switch (dev_id->driver_data) {
+	case SFC_GUID:
+		/* max # of devices per target */
+		host->max_lun = STORVSC_FC_MAX_LUNS_PER_TARGET;
+		/* max # of targets per channel */
+		host->max_id = STORVSC_FC_MAX_TARGETS;
+		/* max # of channels */
+		host->max_channel = STORVSC_FC_MAX_CHANNELS - 1;
+		break;
+
+	case SCSI_GUID:
+		/* max # of devices per target */
+		host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
+		/* max # of targets per channel */
+		host->max_id = STORVSC_MAX_TARGETS;
+		/* max # of channels */
+		host->max_channel = STORVSC_MAX_CHANNELS - 1;
+		break;
+
+	default:
+		/* max # of devices per target */
+		host->max_lun = STORVSC_IDE_MAX_LUNS_PER_TARGET;
+		/* max # of targets per channel */
+		host->max_id = STORVSC_IDE_MAX_TARGETS;
+		/* max # of channels */
+		host->max_channel = STORVSC_IDE_MAX_CHANNELS - 1;
+		break;
+	}
 	/* max cmd length */
 	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
 
-- 
1.7.4.1
