From: Raviv Shvili <rshvili@codeaurora.org>
Subject: [RFC/PATCH 2/2] scsi: ufs: requests completion handling
Date: Thu, 29 Aug 2013 11:54:47 +0300
Message-ID: <1377766493-5269-1-git-send-email-rshvili@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: scsi-misc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Raviv Shvili <rshvili@codeaurora.org>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The patch solves the request completion report order. At the current
implementation, when multiple requests end at the same interrupt call,
the requests reported as completed according to a bitmap scan from the
lowest tags to the highest, regardless the requests priority. That cause
to a priority unfairness and starvation of requests with a high tags.

SCSI Architecture Model 5 defines 3 task-attributes that are part of each
SCSI command, and integrated into each Command UPIU. The task-attribute is
for the device usage, it determines the order in which the device
prioritizes the requests.
The task-attributes according to their priority are (from high to low):
HEAD OF QUEUE, ORDERED and SIMPLE. There is a queue per task-attribute.
Each request is assigned to one of the above sw queues
according to its task attribute field.
Requests which are not SCSI commands (native UFS) will be assigned to
the lowest priority queue, since there is no much difference between
completing it first or last..

When request is completed, we go over the queues (from
the queue's highest priority to the lowest) and report
the completion.

Requests are removed from the queue in case of command completion
or when aborting pending command.

Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index bce09a6..1ee4be2 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -91,7 +91,7 @@ enum {
 };
 
 /* UPIU Task Attributes */
-enum {
+enum upiu_task_attr {
 	UPIU_TASK_ATTR_SIMPLE	= 0x00,
 	UPIU_TASK_ATTR_ORDERED	= 0x01,
 	UPIU_TASK_ATTR_HEADQ	= 0x02,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 648ecb0..6f9f875 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -417,6 +417,39 @@ static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_assign_lrbp_to_task_attr_queue - assign lrbp to queue according
+ * to command's attribute
+ * @hba: driver private handle
+ * @tag: tag of the command
+ * no return value
+ */
+static void ufshcd_assign_lrbp_to_task_attr_queue(struct ufs_hba *hba,
+						unsigned int tag)
+{
+	enum upiu_task_attr task_attr = UPIU_TASK_ATTR_SIMPLE;
+	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+
+	if (lrbp->cmd)
+		task_attr = lrbp->task_attr;
+
+	/* add lrb to privileged queue */
+	switch (task_attr) {
+	case UPIU_TASK_ATTR_ORDERED:
+		list_add_tail(&lrbp->list,
+			&hba->reqs_list[REQS_QUEUE_TASK_ATTR_ORDERED]);
+		break;
+	case UPIU_TASK_ATTR_HEADQ:
+		list_add_tail(&lrbp->list,
+			&hba->reqs_list[REQS_QUEUE_TASK_ATTR_HEADQ]);
+		break;
+	case UPIU_TASK_ATTR_SIMPLE:
+	default:
+		list_add_tail(&lrbp->list,
+			&hba->reqs_list[REQS_QUEUE_TASK_ATTR_SIMPLE]);
+	}
+}
+
+/**
  * ufshcd_send_command - Send SCSI or device management commands
  * @hba: per adapter instance
  * @task_tag: Task tag of the command
@@ -424,6 +457,7 @@ static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
 static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
+	ufshcd_assign_lrbp_to_task_attr_queue(hba, task_tag);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	UFSHCD_UPDATE_TAG_STATS(hba, task_tag)
@@ -1430,6 +1464,8 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 			(struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
 		hba->lrb[i].ucd_prdt_ptr =
 			(struct ufshcd_sg_entry *)cmd_descp[i].prd_table;
+		INIT_LIST_HEAD(&hba->lrb[i].list);
+		hba->lrb[i].task_attr = UPIU_TASK_ATTR_SIMPLE;
 	}
 }
 
@@ -1959,17 +1995,58 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_handle_single_req_completion - handle SCSI commands
+ * and native UFS commands completion.
+ * @hba: driver private handle
+ * @lrbp: holds command's data
+ * @completed_reqs_left: remaining requests bitmap
+ * no return value
+ */
+static void ufshcd_handle_single_req_completion(struct ufs_hba *hba,
+		 struct ufshcd_lrb *lrbp,
+		 unsigned long *completed_reqs_left)
+{
+	struct scsi_cmnd *cmd;
+	int result;
+	int task_tag;
+
+	BUG_ON(!lrbp);
+	task_tag = lrbp->task_tag;
+
+	if (test_bit(task_tag, completed_reqs_left)) {
+		/* clear completed bit and remove form list */
+		clear_bit(task_tag, completed_reqs_left);
+		list_del_init(&lrbp->list);
+		cmd = lrbp->cmd;
+
+		if (cmd) {
+			result = ufshcd_transfer_rsp_status(hba, lrbp);
+			scsi_dma_unmap(cmd);
+			cmd->result = result;
+			/* Mark completed command as NULL in LRB */
+			lrbp->cmd = NULL;
+			clear_bit_unlock(task_tag, &hba->lrb_in_use);
+			/* Do not touch lrbp after scsi done */
+			cmd->scsi_done(cmd);
+		} else if (lrbp->command_type ==
+				UTP_CMD_TYPE_DEV_MANAGE) {
+			if (hba->dev_cmd.complete)
+				complete(hba->dev_cmd.complete);
+		}
+	}
+}
+
+/**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
  */
 static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
 	struct ufshcd_lrb *lrbp;
-	struct scsi_cmnd *cmd;
-	unsigned long completed_reqs;
+	unsigned long completed_reqs, completed_reqs_left;
 	u32 tr_doorbell;
-	int result;
-	int index;
+	struct list_head *curr_req, *temp;
+	int queue_num;
 
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
@@ -1982,25 +2059,25 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
+	completed_reqs_left = completed_reqs;
+	for (queue_num = 0; queue_num < NUM_OF_REQ_QUEUE; queue_num++) {
 
-	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
-		lrbp = &hba->lrb[index];
-		cmd = lrbp->cmd;
-		if (cmd) {
-			result = ufshcd_transfer_rsp_status(hba, lrbp);
-			scsi_dma_unmap(cmd);
-			cmd->result = result;
-			/* Mark completed command as NULL in LRB */
-			lrbp->cmd = NULL;
-			clear_bit_unlock(index, &hba->lrb_in_use);
-			/* Do not touch lrbp after scsi done */
-			cmd->scsi_done(cmd);
-		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
-			if (hba->dev_cmd.complete)
-				complete(hba->dev_cmd.complete);
-		}
+		list_for_each_safe(curr_req, temp, &hba->reqs_list[queue_num]) {
+
+			if (!completed_reqs_left)
+				break;
+
+			lrbp = list_entry(curr_req, struct ufshcd_lrb, list);
+			ufshcd_handle_single_req_completion(hba, lrbp,
+							&completed_reqs_left);
+		} /* end of for each */
 	}
 
+	if (unlikely(completed_reqs_left))
+		dev_WARN(hba->dev,
+			"%s: Following tasks could not be complete 0x%x",
+				__func__, (u32)completed_reqs_left);
+
 	/* clear corresponding bits of completed commands */
 	hba->outstanding_reqs ^= completed_reqs;
 
@@ -2675,6 +2752,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	spin_lock_irqsave(host->host_lock, flags);
 	__clear_bit(tag, &hba->outstanding_reqs);
+	list_del_init(&hba->lrb[tag].list);
 	hba->lrb[tag].cmd = NULL;
 	spin_unlock_irqrestore(host->host_lock, flags);
 
@@ -3002,6 +3080,21 @@ void ufshcd_remove(struct ufs_hba *hba)
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
 /**
+ * ufshcd_init_outstanding_req_lists - initialization routine of request
+ * completion bookkeeping structures
+ * @hba: driver private handle
+ * No return value
+ */
+static void ufshcd_init_outstanding_req_lists(struct ufs_hba *hba)
+{
+	int queue_num;
+
+	for (queue_num = 0; queue_num < NUM_OF_REQ_QUEUE; queue_num++)
+		INIT_LIST_HEAD(&hba->reqs_list[queue_num]);
+}
+
+
+/**
  * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
@@ -3064,6 +3157,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	if (err)
 		goto out_error;
 
+	/* Init request outstanding bookkeeping structures */
+	ufshcd_init_outstanding_req_lists(hba);
+
 	/* Read capabilities registers */
 	ufshcd_hba_capabilities(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0da2b79..5b8f80f3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -75,6 +75,13 @@ enum dev_cmd_type {
 	DEV_CMD_TYPE_QUERY		= 0x1,
 };
 
+enum req_queue_index {
+	REQS_QUEUE_TASK_ATTR_HEADQ	= 0,
+	REQS_QUEUE_TASK_ATTR_ORDERED	= 1,
+	REQS_QUEUE_TASK_ATTR_SIMPLE	= 2,
+	NUM_OF_REQ_QUEUE,
+};
+
 /**
  * struct uic_command - UIC command structure
  * @command: UIC command
@@ -115,7 +122,7 @@ struct ufshcd_lrb {
 	struct utp_upiu_req *ucd_req_ptr;
 	struct utp_upiu_rsp *ucd_rsp_ptr;
 	struct ufshcd_sg_entry *ucd_prdt_ptr;
-
+	struct list_head list;
 	struct scsi_cmnd *cmd;
 	u8 *sense_buffer;
 	unsigned int sense_bufflen;
@@ -123,6 +130,7 @@ struct ufshcd_lrb {
 
 	int command_type;
 	int task_tag;
+	enum upiu_task_attr task_attr;
 	unsigned int lun;
 	bool intr_cmd;
 };
@@ -292,6 +300,8 @@ struct ufs_hba {
 
 	bool auto_bkops_enabled;
 
+	struct list_head reqs_list[NUM_OF_REQ_QUEUE];
+
 #ifdef CONFIG_DEBUG_FS
 	struct ufs_stats ufs_stats;
 	struct debugfs_files debugfs_files;
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
