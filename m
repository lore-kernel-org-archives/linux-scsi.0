From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH 1/1] scsi: ufs: Generalize UFS Interconnect Layer (UIC) command support
Date: Tue, 23 Apr 2013 22:27:14 +0530
Message-ID: <1366736234-8964-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, only DME_LINKSTARTUP UIC command is fully supported,
generalize this to send any UIC command. A new uic_cmd_mutex
is introduced and the callers are expected to hold this mutex
lock before preparing and sending UIC command as the specification
doesn't allow more than one UIC command at a time.

Further, the command completion for DME_LINKSTARTUP is modified
and the command completes in the context of the caller instead
of a separate work.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |  257 +++++++++++++++++++++++++++++++++------------
 drivers/scsi/ufs/ufshcd.h |    7 +-
 2 files changed, 194 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3f67225..ced421a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -35,6 +35,11 @@
 
 #include "ufshcd.h"
 
+/* Timeout after 10 secs if UIC command hangs */
+#define UIC_COMMAND_TIMEOUT	(10 * HZ)
+/* Retry for 3 times in case of UIC failures */
+#define UIC_COMMAND_RETRIES	3
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -51,7 +56,7 @@ enum {
 };
 
 /* Interrupt configuration options */
-enum {
+enum ufshcd_int_cfg {
 	UFSHCD_INT_DISABLE,
 	UFSHCD_INT_ENABLE,
 	UFSHCD_INT_CLEAR,
@@ -63,6 +68,8 @@ enum {
 	INT_AGGR_CONFIG,
 };
 
+static void ufshcd_int_config(struct ufs_hba *hba, enum ufshcd_int_cfg option);
+
 /**
  * ufshcd_get_ufs_version - Get the UFS version supported by the HBA
  * @hba - Pointer to adapter instance
@@ -157,19 +164,6 @@ static inline int ufshcd_get_lists_status(u32 reg)
 }
 
 /**
- * ufshcd_get_uic_cmd_result - Get the UIC command result
- * @hba: Pointer to adapter instance
- *
- * This function gets the result of UIC command completion
- * Returns 0 on success, non zero value on error
- */
-static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
-{
-	return readl(hba->mmio_base + REG_UIC_COMMAND_ARG_2) &
-	       MASK_UIC_COMMAND_RESULT;
-}
-
-/**
  * ufshcd_free_hba_memory - Free allocated memory for LRB, request
  *			    and task lists
  * @hba: Pointer to adapter instance
@@ -397,13 +391,95 @@ static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_prepare_uic_command_lck() - prepare UIC command
+ * @hba: per-adapter instance
+ * @uic_cmd: pointer to UIC command structure
+ * @cmd: UIC command
+ * @arg1: argument 1
+ * @arg2: argument 2
+ * @arg3: argument 3
+ *
+ * Hold UIC command mutex and prepare UIC command structure.
+ * Proper sequence for sending UIC command is:
+ *	1) ufshcd_prepare_uic_command_lck()
+ *	2) ufshcd_send_uic_command()
+ *	3) check argument 2 and argument 3 for results
+ *	4) ufshcd_unprepare_uic_command_unlck()
+ *
+ * Note: Step 3 is optional. But when it is required it should be
+ * with mutex lock held.
+ */
+static void ufshcd_prepare_uic_command_lck(struct ufs_hba *hba,
+		struct uic_command *uic_cmd, u32 cmd,
+		u32 arg1, u32 arg2, u32 arg3)
+{
+	mutex_lock(&hba->uic_cmd_mutex);
+	WARN_ON(hba->active_uic_cmd);
+
+	/* form UIC command */
+	uic_cmd->command = cmd;
+	uic_cmd->argument1 = arg1;
+	uic_cmd->argument2 = arg2;
+	uic_cmd->argument3 = arg3;
+
+	hba->active_uic_cmd = uic_cmd;
+}
+
+/**
+ * ufshcd_unprepare_uic_command_unlck() - unprepare UIC command
+ * @hba: per-adapter instance
+ *
+ * Release UIC mutex and point active uic command to NULL.
+ *
+ * See comments in ufshcd_prepare_uic_command_lck().
+ */
+static void ufshcd_unprepare_uic_command_unlck(struct ufs_hba *hba)
+{
+	hba->active_uic_cmd = NULL;
+	mutex_unlock(&hba->uic_cmd_mutex);
+}
+
+/**
  * ufshcd_send_uic_command - Send UIC commands to unipro layers
  * @hba: per adapter instance
  * @uic_command: UIC command
+ * @retries: number of retries in case of failure.
+ *
+ * See comments in ufshcd_prepare_uic_command_lck().
+ * Returns 0 on success, negative value on failure.
  */
-static inline void
-ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
+static int ufshcd_send_uic_command(struct ufs_hba *hba,
+		struct uic_command *uic_cmnd, int retries)
 {
+	int err = 0;
+	unsigned long flags;
+
+	if (unlikely(mutex_trylock(&hba->uic_cmd_mutex))) {
+		mutex_unlock(&hba->uic_cmd_mutex);
+		dev_err(hba->dev, "%s: called without prepare command\n",
+				__func__);
+		BUG();
+	}
+
+retry:
+	/* check if controller is ready to accept UIC commands */
+	if (!(readl(hba->mmio_base + REG_CONTROLLER_STATUS) &
+				UIC_COMMAND_READY)) {
+		dev_err(hba->dev, "Controller not ready to accept UIC commands\n");
+		err = -EIO;
+		goto out;
+	}
+
+	init_completion(&uic_cmnd->completion);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	/* enable UIC related interrupts */
+	if (!(hba->int_enable_mask & UIC_COMMAND_COMPL)) {
+		hba->int_enable_mask |= UIC_COMMAND_COMPL;
+		ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
+	}
+
 	/* Write Args */
 	writel(uic_cmnd->argument1,
 	      (hba->mmio_base + REG_UIC_COMMAND_ARG_1));
@@ -415,6 +491,45 @@ ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
 	/* Write UIC Cmd */
 	writel((uic_cmnd->command & COMMAND_OPCODE_MASK),
 	       (hba->mmio_base + REG_UIC_COMMAND));
+
+	/* flush to make sure h/w sees the write */
+	readl(hba->mmio_base + REG_UIC_COMMAND);
+
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	err = wait_for_completion_timeout(
+			&uic_cmnd->completion, UIC_COMMAND_TIMEOUT);
+	if (!err) {
+		err = -ETIMEDOUT;
+	} else if (uic_cmnd->argument2 & MASK_UIC_COMMAND_RESULT) {
+		/* something bad with h/w or arguments, try again */
+		if (--retries)
+			goto retry;
+
+		switch (uic_cmnd->argument2 & MASK_UIC_COMMAND_RESULT) {
+		case 0x09: /* BUSY */
+			err = -EBUSY;
+			break;
+		case 0x08: /* PEER_COMMUNICATION_FAILURE*/
+		case 0x0A: /* DME_FAILURE */
+			err = -EIO;
+			break;
+		default: /* Invalid arguments */
+			err = -EINVAL;
+			break;
+		}
+	} else {
+		err = 0;
+	}
+
+	if (err)
+		dev_err(hba->dev, "%s: UIC command failed %d\n CMD: 0x%.8x ARG1: 0x%.8x ARG2: 0x%.8x ARG3: 0x%.8x\n",
+				__func__, err, uic_cmnd->command,
+				uic_cmnd->argument1, uic_cmnd->argument2,
+				uic_cmnd->argument3);
+
+out:
+	return err;
 }
 
 /**
@@ -462,7 +577,7 @@ static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
  * @hba: per adapter instance
  * @option: interrupt option
  */
-static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
+static void ufshcd_int_config(struct ufs_hba *hba, enum ufshcd_int_cfg option)
 {
 	switch (option) {
 	case UFSHCD_INT_ENABLE:
@@ -477,6 +592,8 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
 			writel(INTERRUPT_DISABLE_MASK_11,
 			       (hba->mmio_base + REG_INTERRUPT_ENABLE));
 		break;
+	default:
+		break;
 	}
 }
 
@@ -962,35 +1079,37 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
  */
 static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 {
-	struct uic_command *uic_cmd;
-	unsigned long flags;
+	int err;
+	struct uic_command uic_cmd;
+	int retries = 5;
+	u32 status;
+	u32 hcs;
 
-	/* check if controller is ready to accept UIC commands */
-	if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
-	    UIC_COMMAND_READY) == 0x0) {
-		dev_err(hba->dev,
-			"Controller not ready"
-			" to accept UIC commands\n");
-		return -EIO;
-	}
+	do {
+		ufshcd_prepare_uic_command_lck(hba, &uic_cmd,
+				UIC_CMD_DME_LINK_STARTUP, 0, 0, 0);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+		err = ufshcd_send_uic_command(hba,
+				&uic_cmd, UIC_COMMAND_RETRIES);
 
-	/* form UIC command */
-	uic_cmd = &hba->active_uic_cmd;
-	uic_cmd->command = UIC_CMD_DME_LINK_STARTUP;
-	uic_cmd->argument1 = 0;
-	uic_cmd->argument2 = 0;
-	uic_cmd->argument3 = 0;
+		ufshcd_unprepare_uic_command_unlck(hba);
 
-	/* enable UIC related interrupts */
-	hba->int_enable_mask |= UIC_COMMAND_COMPL;
-	ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
+		if (!err) {
+			hcs = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
+			if (ufshcd_is_device_present(hcs))
+				break;
+		}
 
-	/* sending UIC commands to controller */
-	ufshcd_send_uic_command(hba, uic_cmd);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	return 0;
+		/*
+		 * Give 1ms delay and retry in case device is not
+		 * ready for a link startup.
+		 */
+		status = readl(hba->mmio_base + REG_INTERRUPT_STATUS);
+		if (!(status & UIC_LINK_LOST))
+			usleep_range(1000, 2000);
+	} while (--retries);
+
+	return err;
 }
 
 /**
@@ -1129,8 +1248,11 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
  */
 static int ufshcd_initialize_hba(struct ufs_hba *hba)
 {
-	if (ufshcd_hba_enable(hba))
-		return -EIO;
+	int err;
+
+	err = ufshcd_hba_enable(hba);
+	if (err)
+		goto out;
 
 	/* Configure UTRL and UTMRL base address registers */
 	writel(lower_32_bits(hba->utrdl_dma_addr),
@@ -1143,7 +1265,16 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
 	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_H));
 
 	/* Initialize unipro link startup procedure */
-	return ufshcd_dme_link_startup(hba);
+	err = ufshcd_dme_link_startup(hba);
+	if (err)
+		goto out;
+
+	err = ufshcd_make_hba_operational(hba);
+out:
+	if (err)
+		dev_err(hba->dev, "%s: hba initialization failed, err %d\n",
+				__func__, err);
+	return err;
 }
 
 /**
@@ -1477,28 +1608,6 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_uic_cc_handler - handle UIC command completion
- * @work: pointer to a work queue structure
- *
- * Returns 0 on success, non-zero value on failure
- */
-static void ufshcd_uic_cc_handler (struct work_struct *work)
-{
-	struct ufs_hba *hba;
-
-	hba = container_of(work, struct ufs_hba, uic_workq);
-
-	if ((hba->active_uic_cmd.command == UIC_CMD_DME_LINK_STARTUP) &&
-	    !(ufshcd_get_uic_cmd_result(hba))) {
-
-		if (ufshcd_make_hba_operational(hba))
-			dev_err(hba->dev,
-				"cc: hba not operational state\n");
-		return;
-	}
-}
-
-/**
  * ufshcd_fatal_err_handler - handle fatal errors
  * @hba: per adapter instance
  */
@@ -1560,8 +1669,16 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 	if (hba->errors)
 		ufshcd_err_handler(hba);
 
-	if (intr_status & UIC_COMMAND_COMPL)
-		schedule_work(&hba->uic_workq);
+	if (intr_status & UIC_COMMAND_COMPL) {
+		struct uic_command *uic_cmd = hba->active_uic_cmd;
+
+		/* update ARG2 and ARG3 registers */
+		uic_cmd->argument2 =
+			readl(hba->mmio_base + REG_UIC_COMMAND_ARG_2);
+		uic_cmd->argument3 =
+			readl(hba->mmio_base + REG_UIC_COMMAND_ARG_3);
+		complete(&uic_cmd->completion);
+	}
 
 	if (intr_status & UTP_TASK_REQ_COMPL)
 		ufshcd_tmc_handler(hba);
@@ -1947,12 +2064,14 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
 
 	/* Initialize work queues */
-	INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
 	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
 
 	/* Initialize mutex for query requests */
 	mutex_init(&hba->query.mutex);
 
+	/* Initialize UIC command mutex */
+	mutex_init(&hba->uic_cmd_mutex);
+
 	/* IRQ registration */
 	err = request_irq(irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e6ca79f..13378f3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -76,6 +76,7 @@
  * @argument3: UIC command argument 3
  * @cmd_active: Indicate if UIC command is outstanding
  * @result: UIC command result
+ * @completion: holds the state of completion
  */
 struct uic_command {
 	u32 command;
@@ -84,6 +85,7 @@ struct uic_command {
 	u32 argument3;
 	int cmd_active;
 	int result;
+	struct completion completion;
 };
 
 /**
@@ -150,6 +152,7 @@ struct ufs_query {
  * @ufs_version: UFS Version to which controller complies
  * @irq: Irq number of the controller
  * @active_uic_cmd: handle of active UIC command
+ * @uic_cmd_mutex: lock for uic command exclusion
  * @ufshcd_tm_wait_queue: wait queue for task management
  * @tm_condition: condition variable for task management
  * @ufshcd_state: UFSHCD states
@@ -186,7 +189,9 @@ struct ufs_hba {
 	u32 ufs_version;
 	unsigned int irq;
 
-	struct uic_command active_uic_cmd;
+	struct uic_command *active_uic_cmd;
+	struct mutex uic_cmd_mutex;
+
 	wait_queue_head_t ufshcd_tm_wait_queue;
 	unsigned long tm_condition;
 
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
