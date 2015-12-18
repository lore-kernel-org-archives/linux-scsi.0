From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 13/15] megaraid_sas: Introduce module parameter for SCSI command-timeout
Date: Fri, 18 Dec 2015 18:57:06 +0530
Message-ID: <1450445228-26571-14-git-send-email-Sumit.Saxena@avagotech.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33233 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbbLRN2n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 08:28:43 -0500
Received: by mail-pf0-f173.google.com with SMTP id n128so31521527pfn.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 05:28:43 -0800 (PST)
In-Reply-To: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will introduce module-parameter for SCSI command timeout value and fix setting of resetwaitime beyond a value.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |   15 ++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index cc843d6..316d5a0 100644
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
@@ -1851,7 +1855,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	 * The RAID firmware may require extended timeouts.
 	 */
 	blk_queue_rq_timeout(sdev->request_queue,
-		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
+		scmd_timeout * HZ);
 
 	return 0;
 }
@@ -2651,7 +2655,7 @@ blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 	unsigned long flags;
 
 	if (time_after(jiffies, scmd->jiffies_at_alloc +
-				(MEGASAS_DEFAULT_CMD_TIMEOUT * 2) * HZ)) {
+				(scmd_timeout * 2) * HZ)) {
 		return BLK_EH_NOT_HANDLED;
 	}
 
@@ -5260,6 +5264,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
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
index 96e8d80..a973587 100644
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
1.7.1

