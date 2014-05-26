From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [RESEND PATCH V7 3/6] scsi: ufs: Fix broken task management command implementation
Date: Mon, 26 May 2014 10:59:12 +0530
Message-ID: <1401082155-23184-4-git-send-email-sthumma@codeaurora.org>
References: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: vinholikatti@gmail.com, santoshsy@gmail.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, sending Task Management (TM) command to the card might
be broken in some scenarios as listed below:

Problem: If there are more than 8 TM commands the implementation
         returns error to the caller.
Fix:     Wait for one of the slots to be emptied and send the command.

Problem: Sometimes it is necessary for the caller to know the TM service
         response code to determine the task status.
Fix:     Propogate the service response to the caller.

Problem: If the TM command times out no proper error recovery is
         implemented.
Fix:     Clear the command in the controller door-bell register, so that
         further commands for the same slot don't fail.

Problem: While preparing the TM command descriptor, the task tag used
         should be unique across SCSI/NOP/QUERY/TM commands and not the
	 task tag of the command which the TM command is trying to manage.
Fix:     Use a unique task tag instead of task tag of SCSI command.

Problem: Since the TM command involves H/W communication, abruptly ending
         the request on kill interrupt signal might cause h/w malfunction.
Fix:     Wait for hardware completion interrupt with TASK_UNINTERRUPTIBLE
         set.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
Tested-by: Dolev Raviv <draviv@codeaurora.org>
Acked-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c | 169 +++++++++++++++++++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.h |   8 ++-
 2 files changed, 122 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d476cc3..c3acadc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -55,6 +55,9 @@
 /* Query request timeout */
 #define QUERY_REQ_TIMEOUT 30 /* msec */
 
+/* Task management command timeout */
+#define TM_CMD_TIMEOUT	100 /* msecs */
+
 /* Expose the flag value from utp_upiu_query.value */
 #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
 
@@ -182,13 +185,35 @@ ufshcd_get_tmr_ocs(struct utp_task_req_desc *task_req_descp)
 /**
  * ufshcd_get_tm_free_slot - get a free slot for task management request
  * @hba: per adapter instance
+ * @free_slot: pointer to variable with available slot value
  *
- * Returns maximum number of task management request slots in case of
- * task management queue full or returns the free slot number
+ * Get a free tag and lock it until ufshcd_put_tm_slot() is called.
+ * Returns 0 if free slot is not available, else return 1 with tag value
+ * in @free_slot.
  */
-static inline int ufshcd_get_tm_free_slot(struct ufs_hba *hba)
+static bool ufshcd_get_tm_free_slot(struct ufs_hba *hba, int *free_slot)
 {
-	return find_first_zero_bit(&hba->outstanding_tasks, hba->nutmrs);
+	int tag;
+	bool ret = false;
+
+	if (!free_slot)
+		goto out;
+
+	do {
+		tag = find_first_zero_bit(&hba->tm_slots_in_use, hba->nutmrs);
+		if (tag >= hba->nutmrs)
+			goto out;
+	} while (test_and_set_bit_lock(tag, &hba->tm_slots_in_use));
+
+	*free_slot = tag;
+	ret = true;
+out:
+	return ret;
+}
+
+static inline void ufshcd_put_tm_slot(struct ufs_hba *hba, int slot)
+{
+	clear_bit_unlock(slot, &hba->tm_slots_in_use);
 }
 
 /**
@@ -1912,10 +1937,11 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
  * ufshcd_task_req_compl - handle task management request completion
  * @hba: per adapter instance
  * @index: index of the completed request
+ * @resp: task management service response
  *
- * Returns SUCCESS/FAILED
+ * Returns non-zero value on error, zero on success
  */
-static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
+static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index, u8 *resp)
 {
 	struct utp_task_req_desc *task_req_descp;
 	struct utp_upiu_task_rsp *task_rsp_upiup;
@@ -1936,19 +1962,15 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
 				task_req_descp[index].task_rsp_upiu;
 		task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
 		task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
-
-		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
-		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
-			task_result = FAILED;
-		else
-			task_result = SUCCESS;
+		if (resp)
+			*resp = (u8)task_result;
 	} else {
-		task_result = FAILED;
-		dev_err(hba->dev,
-			"trc: Invalid ocs = %x\n", ocs_value);
+		dev_err(hba->dev, "%s: failed, ocs = 0x%x\n",
+				__func__, ocs_value);
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	return task_result;
+
+	return ocs_value;
 }
 
 /**
@@ -2447,7 +2469,7 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
 
 	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
-	wake_up_interruptible(&hba->ufshcd_tm_wait_queue);
+	wake_up(&hba->tm_wq);
 }
 
 /**
@@ -2497,38 +2519,58 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	return retval;
 }
 
+static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
+{
+	int err = 0;
+	u32 mask = 1 << tag;
+	unsigned long flags;
+
+	if (!test_bit(tag, &hba->outstanding_tasks))
+		goto out;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* poll for max. 1 sec to clear door bell register by h/w */
+	err = ufshcd_wait_for_register(hba,
+			REG_UTP_TASK_REQ_DOOR_BELL,
+			mask, 0, 1000, 1000);
+out:
+	return err;
+}
+
 /**
  * ufshcd_issue_tm_cmd - issues task management commands to controller
  * @hba: per adapter instance
- * @lrbp: pointer to local reference block
+ * @lun_id: LUN ID to which TM command is sent
+ * @task_id: task ID to which the TM command is applicable
+ * @tm_function: task management function opcode
+ * @tm_response: task management service response return value
  *
- * Returns SUCCESS/FAILED
+ * Returns non-zero value on error, zero on success.
  */
-static int
-ufshcd_issue_tm_cmd(struct ufs_hba *hba,
-		    struct ufshcd_lrb *lrbp,
-		    u8 tm_function)
+static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
+		u8 tm_function, u8 *tm_response)
 {
 	struct utp_task_req_desc *task_req_descp;
 	struct utp_upiu_task_req *task_req_upiup;
 	struct Scsi_Host *host;
 	unsigned long flags;
-	int free_slot = 0;
+	int free_slot;
 	int err;
+	int task_tag;
 
 	host = hba->host;
 
-	spin_lock_irqsave(host->host_lock, flags);
-
-	/* If task management queue is full */
-	free_slot = ufshcd_get_tm_free_slot(hba);
-	if (free_slot >= hba->nutmrs) {
-		spin_unlock_irqrestore(host->host_lock, flags);
-		dev_err(hba->dev, "Task management queue full\n");
-		err = FAILED;
-		goto out;
-	}
+	/*
+	 * Get free slot, sleep if slots are unavailable.
+	 * Even though we use wait_event() which sleeps indefinitely,
+	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
+	 */
+	wait_event(hba->tm_tag_wq, ufshcd_get_tm_free_slot(hba, &free_slot));
 
+	spin_lock_irqsave(host->host_lock, flags);
 	task_req_descp = hba->utmrdl_base_addr;
 	task_req_descp += free_slot;
 
@@ -2540,14 +2582,15 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	/* Configure task request UPIU */
 	task_req_upiup =
 		(struct utp_upiu_task_req *) task_req_descp->task_req_upiu;
+	task_tag = hba->nutrs + free_slot;
 	task_req_upiup->header.dword_0 =
 		UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
-					      lrbp->lun, lrbp->task_tag);
+					      lun_id, task_tag);
 	task_req_upiup->header.dword_1 =
 		UPIU_HEADER_DWORD(0, tm_function, 0, 0);
 
-	task_req_upiup->input_param1 = cpu_to_be32(lrbp->lun);
-	task_req_upiup->input_param2 = cpu_to_be32(lrbp->task_tag);
+	task_req_upiup->input_param1 = cpu_to_be32(lun_id);
+	task_req_upiup->input_param2 = cpu_to_be32(task_id);
 
 	/* send command to the controller */
 	__set_bit(free_slot, &hba->outstanding_tasks);
@@ -2556,20 +2599,24 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_unlock_irqrestore(host->host_lock, flags);
 
 	/* wait until the task management command is completed */
-	err =
-	wait_event_interruptible_timeout(hba->ufshcd_tm_wait_queue,
-					 (test_bit(free_slot,
-					 &hba->tm_condition) != 0),
-					 60 * HZ);
+	err = wait_event_timeout(hba->tm_wq,
+			test_bit(free_slot, &hba->tm_condition),
+			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
-		dev_err(hba->dev,
-			"Task management command timed-out\n");
-		err = FAILED;
-		goto out;
+		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
+				__func__, tm_function);
+		if (ufshcd_clear_tm_cmd(hba, free_slot))
+			dev_WARN(hba->dev, "%s: unable clear tm cmd (slot %d) after timeout\n",
+					__func__, free_slot);
+		err = -ETIMEDOUT;
+	} else {
+		err = ufshcd_task_req_compl(hba, free_slot, tm_response);
 	}
+
 	clear_bit(free_slot, &hba->tm_condition);
-	err = ufshcd_task_req_compl(hba, free_slot);
-out:
+	ufshcd_put_tm_slot(hba, free_slot);
+	wake_up(&hba->tm_tag_wq);
+
 	return err;
 }
 
@@ -2586,14 +2633,21 @@ static int ufshcd_device_reset(struct scsi_cmnd *cmd)
 	unsigned int tag;
 	u32 pos;
 	int err;
+	u8 resp = 0xF;
+	struct ufshcd_lrb *lrbp;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
 
-	err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_LOGICAL_RESET);
-	if (err == FAILED)
+	lrbp = &hba->lrb[tag];
+	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET, &resp);
+	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
+		err = FAILED;
 		goto out;
+	} else {
+		err = SUCCESS;
+	}
 
 	for (pos = 0; pos < hba->nutrs; pos++) {
 		if (test_bit(pos, &hba->outstanding_reqs) &&
@@ -2650,6 +2704,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	unsigned int tag;
 	int err;
+	u8 resp = 0xF;
+	struct ufshcd_lrb *lrbp;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
@@ -2665,9 +2721,15 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 	spin_unlock_irqrestore(host->host_lock, flags);
 
-	err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TASK);
-	if (err == FAILED)
+	lrbp = &hba->lrb[tag];
+	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
+			UFS_ABORT_TASK, &resp);
+	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
+		err = FAILED;
 		goto out;
+	} else {
+		err = SUCCESS;
+	}
 
 	scsi_dma_unmap(cmd);
 
@@ -2890,7 +2952,8 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	host->max_cmd_len = MAX_CDB_SIZE;
 
 	/* Initailize wait queue for task management */
-	init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
+	init_waitqueue_head(&hba->tm_wq);
+	init_waitqueue_head(&hba->tm_tag_wq);
 
 	/* Initialize work queues */
 	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 767ee9e..84d09d1 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -174,7 +174,9 @@ struct ufs_dev_cmd {
  * @irq: Irq number of the controller
  * @active_uic_cmd: handle of active UIC command
  * @uic_cmd_mutex: mutex for uic command
- * @ufshcd_tm_wait_queue: wait queue for task management
+ * @tm_wq: wait queue for task management
+ * @tm_tag_wq: wait queue for free task management slots
+ * @tm_slots_in_use: bit map of task management request slots in use
  * @pwr_done: completion for power mode change
  * @tm_condition: condition variable for task management
  * @ufshcd_state: UFSHCD states
@@ -217,8 +219,10 @@ struct ufs_hba {
 	struct uic_command *active_uic_cmd;
 	struct mutex uic_cmd_mutex;
 
-	wait_queue_head_t ufshcd_tm_wait_queue;
+	wait_queue_head_t tm_wq;
+	wait_queue_head_t tm_tag_wq;
 	unsigned long tm_condition;
+	unsigned long tm_slots_in_use;
 
 	struct completion *pwr_done;
 
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
