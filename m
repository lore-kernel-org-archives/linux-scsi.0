From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH v3 4/5] [SCSI] ufshcd: SCSI error handling
Date: Wed, 29 Feb 2012 12:11:53 +0530
Message-ID: <1330497714-26504-5-git-send-email-santoshsy@gmail.com>
References: <1330497714-26504-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1330497714-26504-1-git-send-email-santoshsy@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org, stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com, michaelc@cs.wisc.edu, Santosh Yaraganavi <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Santosh Yaraganavi <santoshsy@gmail.com>

UFSHCD SCSI error handling includes following implementations,
 - Abort task
 - Device reset
 - Host reset

Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@linaro.org>
Reviewed-by: Vishak G <vishak.g@samsung.com>
Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
---
v2 -> v3:
	- use shost_priv() instead of accessing hostdata directly.
	- change ufshcd_is_tmq_full() to ufshcd_get_tm_free_slot() to
	  provide correct meaning, according to its functionality.
v1 -> v2:
	- Change task management function return value to SUCCESS/FAILED,
	  SCSI midlayer expects SUCCESS/FAILED return value for
	  error handling routines.
	  Ex: .eh_host_reset_handler, eh_abort_handler...
	- ufshcd_tmc_handler(): use wake_up_interruptible() outside for loop
	  to wake up all the waiting threads at once.
	  Change hba->tm_condition[] to hba->tm_condition bitmask.
	- ufshcd_abort(): add missing spin_unlock_irqrestore().

 drivers/scsi/ufs/ufshcd.c |  298 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 297 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fa2fa96..07ec973 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -65,6 +65,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
 
 #include "ufs.h"
 #include "ufshci.h"
@@ -130,11 +131,14 @@ struct uic_command {
  * @host: Scsi_Host instance of the driver
  * @pdev: PCI device handle
  * @lrb: local reference block
+ * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_reqs: Bits representing outstanding transfer requests
  * @capabilities: UFS Controller Capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
  * @active_uic_cmd: handle of active UIC command
+ * @ufshcd_tm_wait_queue: wait queue for task management
+ * @tm_condition: condition variable for task management
  * @ufshcd_state: UFSHCD states
  * @int_enable_mask: Interrupt Mask Bits
  * @uic_workq: Work queue for UIC completion handling
@@ -159,6 +163,7 @@ struct ufs_hba {
 
 	struct ufshcd_lrb *lrb;
 
+	unsigned long outstanding_tasks;
 	unsigned long outstanding_reqs;
 
 	u32 capabilities;
@@ -167,6 +172,8 @@ struct ufs_hba {
 	u32 ufs_version;
 
 	struct uic_command active_uic_cmd;
+	wait_queue_head_t ufshcd_tm_wait_queue;
+	unsigned long tm_condition;
 
 	u32 ufshcd_state;
 	u32 int_enable_mask;
@@ -245,6 +252,42 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 }
 
 /**
+ * ufshcd_get_tmr_ocs - Get the UTMRD Overall Command Status
+ * @task_req_descp: pointer to utp_task_req_desc structure
+ *
+ * This function is used to get the OCS field from UTMRD
+ * Returns the OCS field in the UTMRD
+ */
+static inline int
+ufshcd_get_tmr_ocs(struct utp_task_req_desc *task_req_descp)
+{
+	return task_req_descp->header.dword_2 & MASK_OCS;
+}
+
+/**
+ * ufshcd_get_tm_free_slot - get a free slot for task management request
+ * @hba: per adapter instance
+ *
+ * Returns maximum number of task management request slots in case of
+ * task management queue full or returns the free slot number
+ */
+static inline int ufshcd_get_tm_free_slot(struct ufs_hba *hba)
+{
+	return find_first_zero_bit(&hba->outstanding_tasks, hba->nutmrs);
+}
+
+/**
+ * ufshcd_utrl_clear - Clear a bit in UTRLCLR register
+ * @hba: per adapter instance
+ * @pos: position of the bit to be cleared
+ */
+static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
+{
+	writel(~(1 << pos),
+		(hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_CLEAR));
+}
+
+/**
  * ufshcd_get_lists_status - Check UCRDY, UTRLRDY and UTMRLRDY
  * @reg: Register value of host controller status
  *
@@ -1035,8 +1078,9 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
 		}
 	}
 
-	/* clear outstanding request bit maps */
+	/* clear outstanding request/task bit maps */
 	hba->outstanding_reqs = 0;
+	hba->outstanding_tasks = 0;
 
 	/* start the initialization process */
 	if (ufshcd_initialize_hba(hba)) {
@@ -1088,6 +1132,47 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 }
 
 /**
+ * ufshcd_task_req_compl - handle task management request completion
+ * @hba: per adapter instance
+ * @index: index of the completed request
+ *
+ * Returns SUCCESS/FAILED
+ */
+static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
+{
+	struct utp_task_req_desc *task_req_descp;
+	struct utp_upiu_task_rsp *task_rsp_upiup;
+	unsigned long flags;
+	int ocs_value;
+	int task_result;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	/* Clear completed tasks from outstanding_tasks */
+	__clear_bit(index, &hba->outstanding_tasks);
+
+	task_req_descp = hba->utmrdl_base_addr;
+	ocs_value = ufshcd_get_tmr_ocs(&task_req_descp[index]);
+
+	if (ocs_value == OCS_SUCCESS) {
+		task_rsp_upiup = (struct utp_upiu_task_rsp *)
+				task_req_descp[index].task_rsp_upiu;
+		task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
+		task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
+
+		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
+		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
+			task_result = FAILED;
+	} else {
+		task_result = FAILED;
+		dev_err(&hba->pdev->dev,
+			"trc: Invalid ocs = %x\n", ocs_value);
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return task_result;
+}
+
+/**
  * ufshcd_adjust_lun_qdepth - Update LUN queue depth if device responds with
  *			      SAM_STAT_TASK_SET_FULL SCSI command status.
  * @cmd: pointer to SCSI command
@@ -1332,6 +1417,19 @@ fatal_eh:
 }
 
 /**
+ * ufshcd_tmc_handler - handle task management function completion
+ * @hba: per adapter instance
+ */
+static void ufshcd_tmc_handler(struct ufs_hba *hba)
+{
+	u32 tm_doorbell;
+
+	tm_doorbell = readl(hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL);
+	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
+	wake_up_interruptible(&hba->ufshcd_tm_wait_queue);
+}
+
+/**
  * ufshcd_sl_intr - Interrupt service routine
  * @hba: per adapter instance
  * @intr_status: contains interrupts generated by the controller
@@ -1345,6 +1443,9 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 	if (intr_status & UIC_COMMAND_COMPL)
 		schedule_work(&hba->uic_workq);
 
+	if (intr_status & UTP_TASK_REQ_COMPL)
+		ufshcd_tmc_handler(hba);
+
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
 		ufshcd_transfer_req_compl(hba);
 }
@@ -1379,6 +1480,195 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	return retval;
 }
 
+/**
+ * ufshcd_issue_tm_cmd - issues task management commands to controller
+ * @hba: per adapter instance
+ * @lrbp: pointer to local reference block
+ *
+ * Returns SUCCESS/FAILED
+ */
+static int
+ufshcd_issue_tm_cmd(struct ufs_hba *hba,
+		    struct ufshcd_lrb *lrbp,
+		    u8 tm_function)
+{
+	struct utp_task_req_desc *task_req_descp;
+	struct utp_upiu_task_req *task_req_upiup;
+	struct Scsi_Host *host;
+	unsigned long flags;
+	int free_slot = 0;
+	int err;
+
+	host = hba->host;
+
+	spin_lock_irqsave(host->host_lock, flags);
+
+	/* If task management queue is full */
+	free_slot = ufshcd_get_tm_free_slot(hba);
+	if (free_slot >= hba->nutmrs) {
+		spin_unlock_irqrestore(host->host_lock, flags);
+		dev_err(&hba->pdev->dev, "Task management queue full\n");
+		err = FAILED;
+		goto out;
+	}
+
+	task_req_descp = hba->utmrdl_base_addr;
+	task_req_descp += free_slot;
+
+	/* Configure task request descriptor */
+	task_req_descp->header.dword_0 = cpu_to_le32(UTP_REQ_DESC_INT_CMD);
+	task_req_descp->header.dword_2 =
+			cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+
+	/* Configure task request UPIU */
+	task_req_upiup =
+		(struct utp_upiu_task_req *) task_req_descp->task_req_upiu;
+	task_req_upiup->header.dword_0 =
+		cpu_to_be32(UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
+					      lrbp->lun, lrbp->task_tag));
+	task_req_upiup->header.dword_1 =
+	cpu_to_be32(UPIU_HEADER_DWORD(0, tm_function, 0, 0));
+
+	task_req_upiup->input_param1 = lrbp->lun;
+	task_req_upiup->input_param1 =
+		cpu_to_be32(task_req_upiup->input_param1);
+	task_req_upiup->input_param2 = lrbp->task_tag;
+	task_req_upiup->input_param2 =
+		cpu_to_be32(task_req_upiup->input_param2);
+
+	/* send command to the controller */
+	__set_bit(free_slot, &hba->outstanding_tasks);
+	writel((1 << free_slot),
+	       (hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL));
+
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	/* wait until the task management command is completed */
+	err =
+	wait_event_interruptible_timeout(hba->ufshcd_tm_wait_queue,
+					 (test_bit(free_slot,
+					 &hba->tm_condition) != 0),
+					 60 * HZ);
+	if (!err) {
+		dev_err(&hba->pdev->dev,
+			"Task management command timed-out\n");
+		err = FAILED;
+		goto out;
+	}
+	clear_bit(free_slot, &hba->tm_condition);
+	return ufshcd_task_req_compl(hba, free_slot);
+out:
+	return err;
+}
+
+/**
+ * ufshcd_device_reset - reset device and abort all the pending commands
+ * @cmd: SCSI command pointer
+ *
+ * Returns SUCCESS/FAILED
+ */
+static int ufshcd_device_reset(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *host;
+	struct ufs_hba *hba;
+	unsigned int tag;
+	u32 pos;
+	int err;
+
+	host = cmd->device->host;
+	hba = shost_priv(host);
+	tag = cmd->request->tag;
+
+	err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_LOGICAL_RESET);
+	if (err)
+		goto out;
+
+	for (pos = 0; pos < hba->nutrs; pos++) {
+		if (test_bit(pos, &hba->outstanding_reqs) &&
+		    (hba->lrb[tag].lun == hba->lrb[pos].lun)) {
+
+			/* clear the respective UTRLCLR register bit */
+			ufshcd_utrl_clear(hba, pos);
+
+			clear_bit(pos, &hba->outstanding_reqs);
+
+			if (hba->lrb[pos].cmd) {
+				scsi_dma_unmap(hba->lrb[pos].cmd);
+				hba->lrb[pos].cmd->result =
+						DID_ABORT << 16;
+				hba->lrb[pos].cmd->scsi_done(cmd);
+				hba->lrb[pos].cmd = NULL;
+			}
+		}
+	} /* end of for */
+out:
+	return err;
+}
+
+/**
+ * ufshcd_host_reset - Main reset function registered with scsi layer
+ * @cmd: SCSI command pointer
+ *
+ * Returns SUCCESS/FAILED
+ */
+static int ufshcd_host_reset(struct scsi_cmnd *cmd)
+{
+	struct ufs_hba *hba;
+
+	hba = shost_priv(cmd->device->host);
+
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
+		return SUCCESS;
+
+	return (ufshcd_do_reset(hba) == SUCCESS) ? SUCCESS : FAILED;
+}
+
+/**
+ * ufshcd_abort - abort a specific command
+ * @cmd: SCSI command pointer
+ *
+ * Returns SUCCESS/FAILED
+ */
+static int ufshcd_abort(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *host;
+	struct ufs_hba *hba;
+	unsigned long flags;
+	unsigned int tag;
+	int err;
+
+	host = cmd->device->host;
+	hba = shost_priv(host);
+	tag = cmd->request->tag;
+
+	spin_lock_irqsave(host->host_lock, flags);
+
+	/* check if command is still pending */
+	if (!(test_bit(tag, &hba->outstanding_reqs))) {
+		err = FAILED;
+		spin_unlock_irqrestore(host->host_lock, flags);
+		goto out;
+	}
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TASK);
+	if (err)
+		goto out;
+
+	scsi_dma_unmap(cmd);
+
+	spin_lock_irqsave(host->host_lock, flags);
+
+	/* clear the respective UTRLCLR register bit */
+	ufshcd_utrl_clear(hba, tag);
+
+	__clear_bit(tag, &hba->outstanding_reqs);
+	hba->lrb[tag].cmd = NULL;
+	spin_unlock_irqrestore(host->host_lock, flags);
+out:
+	return err;
+}
+
 static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
@@ -1386,6 +1676,9 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.queuecommand		= ufshcd_queuecommand,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_destroy		= ufshcd_slave_destroy,
+	.eh_abort_handler	= ufshcd_abort,
+	.eh_device_reset_handler = ufshcd_device_reset,
+	.eh_host_reset_handler	= ufshcd_host_reset,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
@@ -1586,6 +1879,9 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->unique_id = host->host_no;
 	host->max_cmd_len = MAX_CDB_SIZE;
 
+	/* Initailize wait queue for task management */
+	init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
+
 	/* Initialize work queues */
 	INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
 	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
-- 
1.7.5.4
