From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 04/12] scsi_debug: make jiffy delay name clearer
Date: Fri, 29 Apr 2016 21:39:11 -0400
Message-ID: <1461980359-4320-5-git-send-email-dgilbert@interlog.com>
References: <1461980359-4320-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46721 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbcD3Bjh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2016 21:39:37 -0400
In-Reply-To: <1461980359-4320-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

Add 'j' to delay names to make it clearer that its unit is
jiffies and to differentiate it from sdebug_ndelay whose unit is
nanoseconds.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c3f3a84..2a50e9d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -104,7 +104,7 @@ static const char *sdebug_version_date = "20160427";
  * (id 0) containing 1 logical unit (lun 0). That is 1 device.
  */
 #define DEF_ATO 1
-#define DEF_DELAY   1		/* if > 0 unit is a jiffy */
+#define DEF_JDELAY   1		/* if > 0 unit is a jiffy */
 #define DEF_DEV_SIZE_MB   8
 #define DEF_DIF 0
 #define DEF_DIX 0
@@ -136,7 +136,7 @@ static const char *sdebug_version_date = "20160427";
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
 #define DEF_STRICT 0
-#define DELAY_OVERRIDDEN -9999
+#define JDELAY_OVERRIDDEN -9999
 
 #define SDEBUG_LUN_0_VAL 0
 
@@ -208,7 +208,7 @@ static const char *sdebug_version_date = "20160427";
 
 /* SCSI_DEBUG_CANQUEUE is the maximum number of commands that can be queued
  * (for response) at one time. Can be reduced by max_queue option. Command
- * responses are not queued when delay=0 and ndelay=0. The per-device
+ * responses are not queued when jdelay=0 and ndelay=0. The per-device
  * DEF_CMD_PER_LUN can be changed via sysfs:
  * /sys/class/scsi_device/<h:c:t:l>/device/queue_depth but cannot exceed
  * SCSI_DEBUG_CANQUEUE. */
@@ -520,7 +520,7 @@ struct sdebug_scmd_extra_t {
 
 static int sdebug_add_host = DEF_NUM_HOST;
 static int sdebug_ato = DEF_ATO;
-static int sdebug_delay = DEF_DELAY;	/* in jiffies */
+static int sdebug_jdelay = DEF_JDELAY;	/* if > 0 then unit is jiffies */
 static int sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 static int sdebug_dif = DEF_DIF;
 static int sdebug_dix = DEF_DIX;
@@ -532,7 +532,7 @@ static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns = DEF_MAX_LUNS;
 static int sdebug_max_queue = SCSI_DEBUG_CANQUEUE;
 static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
-static int sdebug_ndelay = DEF_NDELAY;	/* in nanoseconds */
+static int sdebug_ndelay = DEF_NDELAY;	/* if > 0 then unit is nanoseconds */
 static int sdebug_no_lun_0 = DEF_NO_LUN_0;
 static int sdebug_no_uld;
 static int sdebug_num_parts = DEF_NUM_PARTS;
@@ -3593,11 +3593,11 @@ static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 				sqcp->a_cmnd = NULL;
 				spin_unlock_irqrestore(&queued_arr_lock,
 						       iflags);
-				if (sdebug_delay > 0 || sdebug_ndelay > 0) {
+				if (sdebug_jdelay > 0 || sdebug_ndelay > 0) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
 							&sqcp->sd_hrtp->hrt);
-				} else if (sdebug_delay < 0) {
+				} else if (sdebug_jdelay < 0) {
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
 				}
@@ -3630,11 +3630,11 @@ static void stop_all_queued(void)
 				sqcp->a_cmnd = NULL;
 				spin_unlock_irqrestore(&queued_arr_lock,
 						       iflags);
-				if (sdebug_delay > 0 || sdebug_ndelay > 0) {
+				if (sdebug_jdelay > 0 || sdebug_ndelay > 0) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
 							&sqcp->sd_hrtp->hrt);
-				} else if (sdebug_delay < 0) {
+				} else if (sdebug_jdelay < 0) {
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
 				}
@@ -3934,7 +3934,7 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			sd_hp->qa_indx = k;
 		}
 		hrtimer_start(&sd_hp->hrt, kt, HRTIMER_MODE_REL);
-	} else {	/* delay < 0 */
+	} else {	/* jdelay < 0 */
 		if (NULL == sqcp->tletp) {
 			sqcp->tletp = kzalloc(sizeof(*sqcp->tletp),
 					      GFP_ATOMIC);
@@ -3971,7 +3971,7 @@ respond_in_thread:	/* call back to mid-layer using invocation thread */
 module_param_named(add_host, sdebug_add_host, int, S_IRUGO | S_IWUSR);
 module_param_named(ato, sdebug_ato, int, S_IRUGO);
 module_param_named(clustering, sdebug_clustering, bool, S_IRUGO | S_IWUSR);
-module_param_named(delay, sdebug_delay, int, S_IRUGO | S_IWUSR);
+module_param_named(delay, sdebug_jdelay, int, S_IRUGO | S_IWUSR);
 module_param_named(dev_size_mb, sdebug_dev_size_mb, int, S_IRUGO);
 module_param_named(dif, sdebug_dif, int, S_IRUGO);
 module_param_named(dix, sdebug_dix, int, S_IRUGO);
@@ -4113,7 +4113,7 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 		"usec_in_jiffy=%lu\n",
 		SDEBUG_VERSION, sdebug_version_date,
 		sdebug_num_tgts, sdebug_dev_size_mb, sdebug_opts,
-		sdebug_every_nth, b, sdebug_delay, sdebug_ndelay,
+		sdebug_every_nth, b, sdebug_jdelay, sdebug_ndelay,
 		sdebug_max_luns, atomic_read(&sdebug_completions),
 		sdebug_sector_size, sdebug_cylinders_per, sdebug_heads,
 		sdebug_sectors_per, num_aborts, num_dev_resets,
@@ -4131,17 +4131,17 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 
 static ssize_t delay_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_delay);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_jdelay);
 }
-/* Returns -EBUSY if delay is being changed and commands are queued */
+/* Returns -EBUSY if jdelay is being changed and commands are queued */
 static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 			   size_t count)
 {
-	int delay, res;
+	int jdelay, res;
 
-	if ((count > 0) && (1 == sscanf(buf, "%d", &delay))) {
+	if (count > 0 && sscanf(buf, "%d", &jdelay) == 1) {
 		res = count;
-		if (sdebug_delay != delay) {
+		if (sdebug_jdelay != jdelay) {
 			unsigned long iflags;
 			int k;
 
@@ -4150,7 +4150,7 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 			if (k != sdebug_max_queue)
 				res = -EBUSY;	/* have queued commands */
 			else {
-				sdebug_delay = delay;
+				sdebug_jdelay = jdelay;
 				sdebug_ndelay = 0;
 			}
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
@@ -4166,7 +4166,7 @@ static ssize_t ndelay_show(struct device_driver *ddp, char *buf)
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_ndelay);
 }
 /* Returns -EBUSY if ndelay is being changed and commands are queued */
-/* If > 0 and accepted then sdebug_delay is set to DELAY_OVERRIDDEN */
+/* If > 0 and accepted then sdebug_jdelay is set to JDELAY_OVERRIDDEN */
 static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 			   size_t count)
 {
@@ -4183,8 +4183,8 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 				res = -EBUSY;	/* have queued commands */
 			else {
 				sdebug_ndelay = ndelay;
-				sdebug_delay = ndelay ? DELAY_OVERRIDDEN
-							  : DEF_DELAY;
+				sdebug_jdelay = ndelay  ? JDELAY_OVERRIDDEN
+							: DEF_JDELAY;
 			}
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		}
@@ -4667,7 +4667,7 @@ static int __init scsi_debug_init(void)
 		pr_warn("ndelay must be less than 1 second, ignored\n");
 		sdebug_ndelay = 0;
 	} else if (sdebug_ndelay > 0)
-		sdebug_delay = DELAY_OVERRIDDEN;
+		sdebug_jdelay = JDELAY_OVERRIDDEN;
 
 	switch (sdebug_sector_size) {
 	case  512:
@@ -5137,7 +5137,7 @@ scsi_debug_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scp)
 
 fini:
 	return schedule_resp(scp, devip, errsts,
-			     ((F_DELAY_OVERR & flags) ? 0 : sdebug_delay));
+			     ((F_DELAY_OVERR & flags) ? 0 : sdebug_jdelay));
 check_cond:
 	return schedule_resp(scp, devip, check_condition_result, 0);
 }
-- 
2.7.4

