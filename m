From: brking@us.ibm.com
Subject: [PATCH 07/15] ipr: Fast failure module options
Date: Mon, 21 Feb 2005 15:09:10 -0600
Message-ID: <200502212109.j1LL9B6a011345@d01av03.pok.ibm.com>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32414 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262124AbVBUVJM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:09:12 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9CSb027457
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:12 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL9C0H247546
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:12 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9Bn1011379
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Since the ipr adapter initialization is performed by waiting for
an interrupt to occur and this is the first interrupt ever received
from the adapter, and the timeout for this interrupt is 5 minutes,
failed ipr adapters can halt the boot process for a long time.
In certain environments, it makes sense to not try as hard to get
the adapter working and just fail the adapter. This patch adds
two module parameters to modify the adapter initialization sequence.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |   47 ++++++++++++++++++++++--
 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h |   14 +++----
 2 files changed, 51 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_fastfail drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_fastfail	2005-02-21 13:13:31.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:13:31.000000000 -0600
@@ -89,6 +89,8 @@ static struct list_head ipr_ioa_head = L
 static unsigned int ipr_log_level = IPR_DEFAULT_LOG_LEVEL;
 static unsigned int ipr_max_speed = 1;
 static int ipr_testmode = 0;
+static unsigned int ipr_fastfail = 0;
+static unsigned int ipr_transop_timeout = IPR_OPERATIONAL_TIMEOUT;
 static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
@@ -144,6 +146,10 @@ module_param_named(log_level, ipr_log_le
 MODULE_PARM_DESC(log_level, "Set to 0 - 4 for increasing verbosity of device driver");
 module_param_named(testmode, ipr_testmode, int, 0);
 MODULE_PARM_DESC(testmode, "DANGEROUS!!! Allows unsupported configurations");
+module_param_named(fastfail, ipr_fastfail, int, 0);
+MODULE_PARM_DESC(fastfail, "Reduce timeouts and retries");
+module_param_named(transop_timeout, ipr_transop_timeout, int, 0);
+MODULE_PARM_DESC(transop_timeout, "Time in seconds to wait for adapter to come operational (default: 300)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
@@ -1258,6 +1264,41 @@ static void ipr_timeout(struct ipr_cmnd 
 }
 
 /**
+ * ipr_oper_timeout -  Adapter timed out transitioning to operational
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function blocks host requests and initiates an
+ * adapter reset.
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_oper_timeout(struct ipr_cmnd *ipr_cmd)
+{
+	unsigned long lock_flags = 0;
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
+	ENTER;
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+
+	ioa_cfg->errors_logged++;
+	dev_err(&ioa_cfg->pdev->dev,
+		"Adapter timed out transitioning to operational.\n");
+
+	if (WAIT_FOR_DUMP == ioa_cfg->sdt_state)
+		ioa_cfg->sdt_state = GET_DUMP;
+
+	if (!ioa_cfg->in_reset_reload || ioa_cfg->reset_cmd == ipr_cmd) {
+		if (ipr_fastfail)
+			ioa_cfg->reset_retries += IPR_NUM_RESET_RELOAD_RETRIES;
+		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+	}
+
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	LEAVE;
+}
+
+/**
  * ipr_reset_reload - Reset/Reload the IOA
  * @ioa_cfg:		ioa config struct
  * @shutdown_type:	shutdown type
@@ -4814,8 +4855,8 @@ static int ipr_reset_enable_ioa(struct i
 	dev_info(&ioa_cfg->pdev->dev, "Initializing IOA.\n");
 
 	ipr_cmd->timer.data = (unsigned long) ipr_cmd;
-	ipr_cmd->timer.expires = jiffies + IPR_OPERATIONAL_TIMEOUT;
-	ipr_cmd->timer.function = (void (*)(unsigned long))ipr_timeout;
+	ipr_cmd->timer.expires = jiffies + (ipr_transop_timeout * HZ);
+	ipr_cmd->timer.function = (void (*)(unsigned long))ipr_oper_timeout;
 	ipr_cmd->done = ipr_reset_ioa_job;
 	add_timer(&ipr_cmd->timer);
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);
@@ -5290,7 +5331,7 @@ static void ipr_initiate_ioa_reset(struc
 	if (ioa_cfg->in_reset_reload && ioa_cfg->sdt_state == GET_DUMP)
 		ioa_cfg->sdt_state = ABORT_DUMP;
 
-	if (ioa_cfg->reset_retries++ > IPR_NUM_RESET_RELOAD_RETRIES) {
+	if (ioa_cfg->reset_retries++ >= IPR_NUM_RESET_RELOAD_RETRIES) {
 		dev_err(&ioa_cfg->pdev->dev,
 			"IOA taken offline - error recovery failed\n");
 
diff -puN drivers/scsi/ipr.h~ipr_fastfail drivers/scsi/ipr.h
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.h~ipr_fastfail	2005-02-21 13:13:31.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h	2005-02-21 13:13:31.000000000 -0600
@@ -165,17 +165,17 @@
 /*
  * Timeouts
  */
-#define IPR_SHUTDOWN_TIMEOUT			(10 * 60 * HZ)
-#define IPR_VSET_RW_TIMEOUT			(2 * 60 * HZ)
+#define IPR_SHUTDOWN_TIMEOUT			(ipr_fastfail ? 60 * HZ : 10 * 60 * HZ)
+#define IPR_VSET_RW_TIMEOUT			(ipr_fastfail ? 30 * HZ : 2 * 60 * HZ)
 #define IPR_ABBREV_SHUTDOWN_TIMEOUT		(10 * HZ)
-#define IPR_DEVICE_RESET_TIMEOUT		(30 * HZ)
-#define IPR_CANCEL_ALL_TIMEOUT		(30 * HZ)
-#define IPR_ABORT_TASK_TIMEOUT		(30 * HZ)
-#define IPR_INTERNAL_TIMEOUT			(30 * HZ)
+#define IPR_DEVICE_RESET_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
+#define IPR_CANCEL_ALL_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
+#define IPR_ABORT_TASK_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
+#define IPR_INTERNAL_TIMEOUT			(ipr_fastfail ? 10 * HZ : 30 * HZ)
 #define IPR_WRITE_BUFFER_TIMEOUT		(10 * 60 * HZ)
 #define IPR_SET_SUP_DEVICE_TIMEOUT		(2 * 60 * HZ)
 #define IPR_REQUEST_SENSE_TIMEOUT		(10 * HZ)
-#define IPR_OPERATIONAL_TIMEOUT		(5 * 60 * HZ)
+#define IPR_OPERATIONAL_TIMEOUT		(5 * 60)
 #define IPR_WAIT_FOR_RESET_TIMEOUT		(2 * HZ)
 #define IPR_CHECK_FOR_RESET_TIMEOUT		(HZ / 10)
 #define IPR_WAIT_FOR_BIST_TIMEOUT		(2 * HZ)
_
