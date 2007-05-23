From: akpm@linux-foundation.org
Subject: [patch 23/25] scsi: megaraid_sas: intercept cmd timeout and throttle io
Date: Wed, 23 May 2007 14:41:54 -0700
Message-ID: <200705232141.l4NLfs4i001237@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756920AbXEWWD6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 18:03:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, sumant.patro@lsi.com

From: Sumant Patro <sumant.patro@lsi.com>

eh_timed_out call back (megasas_reset_timer) is used to throttle io to the
adapter when it is called the first time for a scmd.  The MEGASAS_FW_BUSY
flag is set and can_queue reduced to 16.  The can_queue is restored from
completion routine in following two conditions : 5 seconds has elapsed and
the # of outstanding cmds in FW is < 17.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   67 ++++++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas.h |   14 +++--
 2 files changed, 69 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-intercepts-cmd-timeout-and-throttle-io drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-intercepts-cmd-timeout-and-throttle-io
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.10-rc1
+ * Version	: v00.00.03.10-rc5
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
@@ -886,6 +886,7 @@ megasas_queue_command(struct scsi_cmnd *
 		goto out_return_cmd;
 
 	cmd->scmd = scmd;
+	scmd->SCp.ptr = (char *)cmd;
 
 	/*
 	 * Issue the command to the FW
@@ -919,7 +920,7 @@ static int megasas_slave_configure(struc
 	 * The RAID firmware may require extended timeouts.
 	 */
 	if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS)
-		sdev->timeout = 90 * HZ;
+		sdev->timeout = MEGASAS_DEFAULT_CMD_TIMEOUT * HZ;
 	return 0;
 }
 
@@ -981,8 +982,8 @@ static int megasas_generic_reset(struct 
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
-	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x\n",
-	       scmd->serial_number, scmd->cmnd[0]);
+	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x retries=%x\n",
+		 scmd->serial_number, scmd->cmnd[0], scmd->retries);
 
 	if (instance->hw_crit_error) {
 		printk(KERN_ERR "megasas: cannot recover from previous reset "
@@ -1000,6 +1001,39 @@ static int megasas_generic_reset(struct 
 }
 
 /**
+ * megasas_reset_timer - quiesce the adapter if required
+ * @scmd:		scsi cmnd
+ *
+ * Sets the FW busy flag and reduces the host->can_queue if the
+ * cmd has not been completed within the timeout period.
+ */
+static enum
+scsi_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
+{
+	struct megasas_cmd *cmd = (struct megasas_cmd *)scmd->SCp.ptr;
+	struct megasas_instance *instance;
+	unsigned long flags;
+
+	if (time_after(jiffies, scmd->jiffies_at_alloc +
+				(MEGASAS_DEFAULT_CMD_TIMEOUT * 2) * HZ)) {
+		return EH_NOT_HANDLED;
+	}
+
+	instance = cmd->instance;
+	if (!(instance->flag & MEGASAS_FW_BUSY)) {
+		/* FW is busy, throttle IO */
+		spin_lock_irqsave(instance->host->host_lock, flags);
+
+		instance->host->can_queue = 16;
+		instance->last_time = jiffies;
+		instance->flag |= MEGASAS_FW_BUSY;
+
+		spin_unlock_irqrestore(instance->host->host_lock, flags);
+	}
+	return EH_RESET_TIMER;
+}
+
+/**
  * megasas_reset_device -	Device reset handler entry point
  */
 static int megasas_reset_device(struct scsi_cmnd *scmd)
@@ -1112,6 +1146,7 @@ static struct scsi_host_template megasas
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
 	.eh_host_reset_handler = megasas_reset_bus_host,
+	.eh_timed_out = megasas_reset_timer,
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
 };
@@ -1215,9 +1250,8 @@ megasas_complete_cmd(struct megasas_inst
 	int exception = 0;
 	struct megasas_header *hdr = &cmd->frame->hdr;
 
-	if (cmd->scmd) {
-		cmd->scmd->SCp.ptr = (char *)0;
-	}
+	if (cmd->scmd)
+		cmd->scmd->SCp.ptr = NULL;
 
 	switch (hdr->cmd) {
 
@@ -1806,6 +1840,7 @@ static void megasas_complete_cmd_dpc(uns
 	u32 context;
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance = (struct megasas_instance *)instance_addr;
+	unsigned long flags;
 
 	/* If we have already declared adapter dead, donot complete cmds */
 	if (instance->hw_crit_error)
@@ -1828,6 +1863,22 @@ static void megasas_complete_cmd_dpc(uns
 	}
 
 	*instance->consumer = producer;
+
+	/*
+	 * Check if we can restore can_queue
+	 */
+	if (instance->flag & MEGASAS_FW_BUSY
+		&& time_after(jiffies, instance->last_time + 5 * HZ)
+		&& atomic_read(&instance->fw_outstanding) < 17) {
+
+		spin_lock_irqsave(instance->host->host_lock, flags);
+		instance->flag &= ~MEGASAS_FW_BUSY;
+		instance->host->can_queue =
+				instance->max_fw_cmds - MEGASAS_INT_CMDS;
+
+		spin_unlock_irqrestore(instance->host->host_lock, flags);
+	}
+
 }
 
 /**
@@ -2398,6 +2449,8 @@ megasas_probe_one(struct pci_dev *pdev, 
 	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
 
 	megasas_dbg_lvl = 0;
+	instance->flag = 0;
+	instance->last_time = 0;
 
 	/*
 	 * Initialize MFI Firmware
diff -puN drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-intercepts-cmd-timeout-and-throttle-io drivers/scsi/megaraid/megaraid_sas.h
--- a/drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-intercepts-cmd-timeout-and-throttle-io
+++ a/drivers/scsi/megaraid/megaraid_sas.h
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.10-rc1"
-#define MEGASAS_RELDATE				"Feb 14, 2007"
-#define MEGASAS_EXT_VERSION			"Wed Feb 14 10:14:25 PST 2007"
+#define MEGASAS_VERSION				"00.00.03.10-rc5"
+#define MEGASAS_RELDATE				"May 17, 2007"
+#define MEGASAS_EXT_VERSION			"Thu May 17 10:09:32 PDT 2007"
 
 /*
  * Device IDs
@@ -539,6 +539,8 @@ struct megasas_ctrl_info {
 
 #define MEGASAS_DBG_LVL				1
 
+#define MEGASAS_FW_BUSY				1
+
 /*
  * When SCSI mid-layer calls driver's reset routine, driver waits for
  * MEGASAS_RESET_WAIT_TIME seconds for all outstanding IO to complete. Note
@@ -549,8 +551,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_RESET_WAIT_TIME			180
 #define MEGASAS_INTERNAL_CMD_WAIT_TIME		180
 #define	MEGASAS_RESET_NOTICE_INTERVAL		5
-
 #define MEGASAS_IOCTL_CMD			0
+#define MEGASAS_DEFAULT_CMD_TIMEOUT		90
 
 /*
  * FW reports the maximum of number of commands that it can accept (maximum
@@ -1073,7 +1075,6 @@ struct megasas_instance {
 	struct megasas_register_set __iomem *reg_set;
 
 	s8 init_id;
-	u8 reserved[3];
 
 	u16 max_num_sge;
 	u16 max_fw_cmds;
@@ -1104,6 +1105,9 @@ struct megasas_instance {
 
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
+
+	u8 flag;
+	unsigned long last_time;
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\
_
