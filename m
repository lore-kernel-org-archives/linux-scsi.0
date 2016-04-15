From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 3/4] megaraid_sas: task management code optimizations
Date: Fri, 15 Apr 2016 00:23:32 -0700
Message-ID: <1460705013-6482-4-git-send-email-sumit.saxena@broadcom.com>
References: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33232 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbcDOHYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 03:24:06 -0400
Received: by mail-pa0-f52.google.com with SMTP id zm5so52911237pac.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2016 00:24:06 -0700 (PDT)
In-Reply-To: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, hch@infradead.org, thenzl@redhat.com
Cc: kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com

This patch will do code optmization for task management functions.
Below are key changes-
1. Remove reset_device hook as it was not being used and driver was setting this to NULL.
2. Create wrapper functions for task abort and target reset and inside these functions
   adapter specific calls be made. e.g. fusion adapters support task abort and target reset
   so task abort and target reset should be issued to fusion adapters only and for MFI adapters,
   print a message saying feature not supported.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 67 +++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8588202..b84756c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2670,17 +2670,6 @@ blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 }
 
 /**
- * megasas_reset_device -	Device reset handler entry point
- */
-static int megasas_reset_device(struct scsi_cmnd *scmd)
-{
-	/*
-	 * First wait for all commands to complete
-	 */
-	return megasas_generic_reset(scmd);
-}
-
-/**
  * megasas_reset_bus_host -	Bus & host reset handler entry point
  */
 static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
@@ -2702,6 +2691,50 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 }
 
 /**
+ * megasas_task_abort - Issues task abort request to firmware
+ *			(supported only for fusion adapters)
+ * @scmd:		SCSI command pointer
+ */
+static int megasas_task_abort(struct scsi_cmnd *scmd)
+{
+	int ret;
+	struct megasas_instance *instance;
+
+	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+
+	if (instance->ctrl_context)
+		ret = megasas_task_abort_fusion(scmd);
+	else {
+		sdev_printk(KERN_NOTICE, scmd->device, "TASK ABORT not supported\n");
+		ret = FAILED;
+	}
+
+	return ret;
+}
+
+/**
+ * megasas_reset_target:  Issues target reset request to firmware
+ *                        (supported only for fusion adapters)
+ * @scmd:                 SCSI command pointer
+ */
+static int megasas_reset_target(struct scsi_cmnd *scmd)
+{
+	int ret;
+	struct megasas_instance *instance;
+
+	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+
+	if (instance->ctrl_context)
+		ret = megasas_reset_target_fusion(scmd);
+	else {
+		sdev_printk(KERN_NOTICE, scmd->device, "TARGET RESET not supported\n");
+		ret = FAILED;
+	}
+
+	return ret;
+}
+
+/**
  * megasas_bios_param - Returns disk geometry for a disk
  * @sdev:		device handle
  * @bdev:		block device
@@ -2969,8 +3002,8 @@ static struct scsi_host_template megasas_template = {
 	.slave_alloc = megasas_slave_alloc,
 	.slave_destroy = megasas_slave_destroy,
 	.queuecommand = megasas_queue_command,
-	.eh_device_reset_handler = megasas_reset_device,
-	.eh_bus_reset_handler = megasas_reset_bus_host,
+	.eh_target_reset_handler = megasas_reset_target,
+	.eh_abort_handler = megasas_task_abort,
 	.eh_host_reset_handler = megasas_reset_bus_host,
 	.eh_timed_out = megasas_reset_timer,
 	.shost_attrs = megaraid_host_attrs,
@@ -5598,14 +5631,6 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	host->max_lun = MEGASAS_MAX_LUN;
 	host->max_cmd_len = 16;
 
-	/* Fusion only supports host reset */
-	if (instance->ctrl_context) {
-		host->hostt->eh_device_reset_handler = NULL;
-		host->hostt->eh_bus_reset_handler = NULL;
-		host->hostt->eh_target_reset_handler = megasas_reset_target_fusion;
-		host->hostt->eh_abort_handler = megasas_task_abort_fusion;
-	}
-
 	/*
 	 * Notify the mid-layer about the new controller
 	 */
-- 
2.4.11

