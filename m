From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH v2 13/15] megaraid_sas: Introduce module parameter for SCSI command-timeout
Date: Thu, 28 Jan 2016 21:04:34 +0530
Message-ID: <1453995276-24955-14-git-send-email-sumit.saxena@avagotech.com>
References: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36683 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967059AbcA1PgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:36:00 -0500
Received: by mail-pa0-f41.google.com with SMTP id yy13so24767815pab.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:36:00 -0800 (PST)
In-Reply-To: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will introduce module-parameter for SCSI command timeout value and fix setting of resetwaitime beyond a value.

There was some comment from Tomas on last time sent patch regarding why should driver provided scmd_timeout module parameter.
This is done for special cases where user wants to tune scmd_timeout value during driver load time. Default value is same as before-90 secs.
There are no changes in this patch on top of last time sent patch.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 15 ++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 +-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d2ea977..54922e5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -83,7 +83,7 @@ module_param(throttlequeuedepth, int, S_IRUGO);
 MODULE_PARM_DESC(throttlequeuedepth,
 	"Adapter queue depth when throttled due to I/O timeout. Default: 16");
 
-int resetwaittime = MEGASAS_RESET_WAIT_TIME;
+unsigned int resetwaittime = MEGASAS_RESET_WAIT_TIME;
 module_param(resetwaittime, int, S_IRUGO);
 MODULE_PARM_DESC(resetwaittime, "Wait time in seconds after I/O timeout "
 		 "before resetting adapter. Default: 180");
@@ -100,6 +100,10 @@ unsigned int dual_qdepth_disable;
 module_param(dual_qdepth_disable, int, S_IRUGO);
 MODULE_PARM_DESC(dual_qdepth_disable, "Disable dual queue depth feature. Default: 0");
 
+unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
+module_param(scmd_timeout, int, S_IRUGO);
+MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), default 90s. See megasas_reset_timer.");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux.pdl@avagotech.com");
@@ -1850,7 +1854,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	 * The RAID firmware may require extended timeouts.
 	 */
 	blk_queue_rq_timeout(sdev->request_queue,
-		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
+		scmd_timeout * HZ);
 
 	return 0;
 }
@@ -2645,7 +2649,7 @@ blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 	unsigned long flags;
 
 	if (time_after(jiffies, scmd->jiffies_at_alloc +
-				(MEGASAS_DEFAULT_CMD_TIMEOUT * 2) * HZ)) {
+				(scmd_timeout * 2) * HZ)) {
 		return BLK_EH_NOT_HANDLED;
 	}
 
@@ -5254,6 +5258,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		instance->throttlequeuedepth =
 				MEGASAS_THROTTLE_QUEUE_DEPTH;
 
+	if (resetwaittime > MEGASAS_RESET_WAIT_TIME)
+		resetwaittime = MEGASAS_RESET_WAIT_TIME;
+
+	if ((scmd_timeout < 10) || (scmd_timeout > MEGASAS_DEFAULT_CMD_TIMEOUT))
+		scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
 
 	/* Launch SR-IOV heartbeat timer */
 	if (instance->requestorId) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 64926f7..e740e26 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -91,7 +91,7 @@ void megasas_start_timer(struct megasas_instance *instance,
 			struct timer_list *timer,
 			 void *fn, unsigned long interval);
 extern struct megasas_mgmt_info megasas_mgmt_info;
-extern int resetwaittime;
+extern unsigned int resetwaittime;
 extern unsigned int dual_qdepth_disable;
 static void megasas_free_rdpq_fusion(struct megasas_instance *instance);
 static void megasas_free_reply_fusion(struct megasas_instance *instance);
-- 
1.8.3.1

