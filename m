From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 1/4] scsi: ufs: Fix broken task management command implementation
Date: Thu, 27 Jun 2013 16:49:10 +0530
Message-ID: <CALMYJDuRyovi3X_jmb0-PjZgRYgJfSi_ryg0YO48Cr2bRHLd+g@mail.gmail.com>
References: <1371133860-17574-1-git-send-email-sthumma@codeaurora.org> <1371133860-17574-2-git-send-email-sthumma@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1371133860-17574-2-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 13, 2013 at 8:00 PM, Sujit Reddy Thumma
<sthumma@codeaurora.org> wrote:
> Currently, sending Task Management (TM) command to the card might
> be broken in some scenarios as listed below:
>
> - If there are more than 8 TM commands the implementation returns
> error to the caller.
> Fix: Wait for one of the slots to be emptied and send the command.
>
> - Sometimes it is necessary for the caller to know the TM service
> response code to determine the task status.
> Fix: Propogate the service response to the caller.
>
> - If the TM command times out no proper error recovery is implemented.
> Fix: Clear the command in the controller door-bell register, so that
> further commands for the same slot don't fail.
>
> - While preparing the TM command descriptor the tag used should be the
> free slot of TM command and not the task tag of the command which
> the TM command is trying to manage.
> Fix: Use free slot tag instead of task tag of SCSI command
>
> - Since the TM command involves H/W communication, abruptly ending the
> request on kill interrupt signal might cause h/w malfunction.
> Fix: Wait for hardware completion interrupt with TASK_UNINTERRUPTIBLE set.
>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c |  174 +++++++++++++++++++++++++++++----------------
>  drivers/scsi/ufs/ufshcd.h |    6 +-
>  2 files changed, 117 insertions(+), 63 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index aa1f11e..7d043f4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -53,6 +53,9 @@
>  /* Query request timeout */
>  #define QUERY_REQ_TIMEOUT 30 /* msec */
>
> +/* Task management command timeout */
> +#define TM_CMD_TIMEOUT 100 /* msecs */
> +
>  #define SCSI_CMD_QUEUE_SIZE (hba->nutrs - 1)
>  /* Reserved tag for internal commands */
>  #define INTERNAL_CMD_TAG   (hba->nutrs - 1)
> @@ -188,13 +191,32 @@ ufshcd_get_tmr_ocs(struct utp_task_req_desc *task_req_descp)
>  /**
>   * ufshcd_get_tm_free_slot - get a free slot for task management request
>   * @hba: per adapter instance
> + * @free_slot: pointer to variable with available slot value
>   *
> - * Returns maximum number of task management request slots in case of
> - * task management queue full or returns the free slot number
> + * Get a free tag and lock it until ufshcd_put_tm_slot() is called.
> + * Returns 0 if free slot is not available, else return 1 with tag value
> + * in @free_slot.
>   */
> -static inline int ufshcd_get_tm_free_slot(struct ufs_hba *hba)
> +static bool ufshcd_get_tm_free_slot(struct ufs_hba *hba, int *free_slot)
> +{
> +       int tag;
> +
> +       do {
> +               tag = find_first_zero_bit(
> +                               &hba->outstanding_tasks, hba->nutmrs);
> +               if (tag >= hba->nutmrs)
> +                       return false;
> +       } while (test_and_set_bit_lock(tag, &hba->outstanding_tasks));
> +
> +       if (free_slot)
> +               *free_slot = tag;
> +
> +       return true;
> +}
> +
> +static inline void ufshcd_put_tm_slot(struct ufs_hba *hba, int slot)
>  {
> -       return find_first_zero_bit(&hba->outstanding_tasks, hba->nutmrs);
> +       clear_bit_unlock(slot, &hba->outstanding_tasks);
>  }
>
>  /**
> @@ -1745,10 +1767,11 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
>   * ufshcd_task_req_compl - handle task management request completion
>   * @hba: per adapter instance
>   * @index: index of the completed request
> + * @resp: task management service response
>   *
> - * Returns SUCCESS/FAILED
> + * Returns non-zero value on error, zero on success
>   */
> -static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
> +static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index, u8 *resp)
>  {
>         struct utp_task_req_desc *task_req_descp;
>         struct utp_upiu_task_rsp *task_rsp_upiup;
> @@ -1758,9 +1781,6 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
>
>         spin_lock_irqsave(hba->host->host_lock, flags);
>
> -       /* Clear completed tasks from outstanding_tasks */
> -       __clear_bit(index, &hba->outstanding_tasks);
> -
>         task_req_descp = hba->utmrdl_base_addr;
>         ocs_value = ufshcd_get_tmr_ocs(&task_req_descp[index]);
>
> @@ -1769,19 +1789,15 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
>                                 task_req_descp[index].task_rsp_upiu;
>                 task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
>                 task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
> -
> -               if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
> -                   task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
> -                       task_result = FAILED;
> -               else
> -                       task_result = SUCCESS;
> +               if (resp)
> +                       *resp = (u8)task_result;
>         } else {
> -               task_result = FAILED;
> -               dev_err(hba->dev,
> -                       "trc: Invalid ocs = %x\n", ocs_value);
> +               dev_err(hba->dev, "%s: failed, ocs = 0x%x\n",
> +                               __func__, ocs_value);
>         }
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
> -       return task_result;
> +
> +       return ocs_value;
>  }
>
>  /**
> @@ -2258,7 +2274,7 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
>
>         tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
>         hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
> -       wake_up_interruptible(&hba->ufshcd_tm_wait_queue);
> +       wake_up(&hba->tm_wq);
>  }
>
>  /**
> @@ -2308,17 +2324,42 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
>         return retval;
>  }
>
> +static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
> +{
> +       int err = 0;
> +       u32 reg;
> +       u32 mask = 1 << tag;
> +       unsigned long flags;
> +
> +       if (!test_bit(tag, &hba->outstanding_reqs))
> +               goto out;
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +       /* poll for max. 1 sec to clear door bell register by h/w */
> +       reg = ufshcd_wait_for_register(hba,
> +                       REG_UTP_TASK_REQ_DOOR_BELL,
> +                       mask, 0, 1000, 1000);
> +       if ((reg & mask) == mask)
> +               err = -ETIMEDOUT;
> +out:
> +       return err;
> +}
> +
>  /**
>   * ufshcd_issue_tm_cmd - issues task management commands to controller
>   * @hba: per adapter instance
> - * @lrbp: pointer to local reference block
> + * @lun_id: LUN ID to which TM command is sent
> + * @task_id: task ID to which the TM command is applicable
> + * @tm_function: task management function opcode
> + * @tm_response: task management service response return value
>   *
> - * Returns SUCCESS/FAILED
> + * Returns non-zero value on error, zero on success.
>   */
> -static int
> -ufshcd_issue_tm_cmd(struct ufs_hba *hba,
> -                   struct ufshcd_lrb *lrbp,
> -                   u8 tm_function)
> +static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
> +               u8 tm_function, u8 *tm_response)
>  {
>         struct utp_task_req_desc *task_req_descp;
>         struct utp_upiu_task_req *task_req_upiup;
> @@ -2329,17 +2370,10 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>
>         host = hba->host;
>
> -       spin_lock_irqsave(host->host_lock, flags);
> -
> -       /* If task management queue is full */
> -       free_slot = ufshcd_get_tm_free_slot(hba);
> -       if (free_slot >= hba->nutmrs) {
> -               spin_unlock_irqrestore(host->host_lock, flags);
> -               dev_err(hba->dev, "Task management queue full\n");
> -               err = FAILED;
> -               goto out;
> -       }
> +       /* Get free slot, sleep if slots are unavailable */
> +       wait_event(hba->tm_tag_wq, ufshcd_get_tm_free_slot(hba, &free_slot));
>
> +       spin_lock_irqsave(host->host_lock, flags);
>         task_req_descp = hba->utmrdl_base_addr;
>         task_req_descp += free_slot;
>
> @@ -2353,38 +2387,39 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>                 (struct utp_upiu_task_req *) task_req_descp->task_req_upiu;
>         task_req_upiup->header.dword_0 =
>                 UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
> -                                             lrbp->lun, lrbp->task_tag);
> +                               lun_id, free_slot);

Actually it still doesn't fix the problem. The *task tag* used here
should be unique across the SCSI/Query and Task Managment UPIUs.

>         task_req_upiup->header.dword_1 =
>                 UPIU_HEADER_DWORD(0, tm_function, 0, 0);
>
> -       task_req_upiup->input_param1 = lrbp->lun;
> -       task_req_upiup->input_param1 =
> -               cpu_to_be32(task_req_upiup->input_param1);
> -       task_req_upiup->input_param2 = lrbp->task_tag;
> -       task_req_upiup->input_param2 =
> -               cpu_to_be32(task_req_upiup->input_param2);
> +       task_req_upiup->input_param1 = cpu_to_be32(lun_id);
> +       task_req_upiup->input_param2 = cpu_to_be32(task_id);
>
> -       /* send command to the controller */
> -       __set_bit(free_slot, &hba->outstanding_tasks);
> +       /*
> +        * outstanding_tasks variable is already updated with corresponding
> +        * bit while acquiring free slot. Ring doorbell here.
> +        */
>         ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
>
>         spin_unlock_irqrestore(host->host_lock, flags);
>
>         /* wait until the task management command is completed */
> -       err =
> -       wait_event_interruptible_timeout(hba->ufshcd_tm_wait_queue,
> -                                        (test_bit(free_slot,
> -                                        &hba->tm_condition) != 0),
> -                                        60 * HZ);
> +       err = wait_event_timeout(hba->tm_wq,
> +                       test_bit(free_slot, &hba->tm_condition),
> +                       msecs_to_jiffies(TM_CMD_TIMEOUT));
>         if (!err) {
> -               dev_err(hba->dev,
> -                       "Task management command timed-out\n");
> -               err = FAILED;
> -               goto out;
> +               dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
> +                               __func__, tm_function);
> +               if (ufshcd_clear_tm_cmd(hba, free_slot))
> +                       dev_WARN(hba->dev, "%s: unable clear tm cmd (slot %d) after timeout\n",
> +                                       __func__, free_slot);
> +               err = -ETIMEDOUT;
> +       } else {
> +               err = ufshcd_task_req_compl(hba, free_slot, tm_response);
>         }
>         clear_bit(free_slot, &hba->tm_condition);
> -       err = ufshcd_task_req_compl(hba, free_slot);
> -out:
> +       ufshcd_put_tm_slot(hba, free_slot);
> +       wake_up(&hba->tm_tag_wq);
> +
>         return err;
>  }
>
> @@ -2401,14 +2436,22 @@ static int ufshcd_device_reset(struct scsi_cmnd *cmd)
>         unsigned int tag;
>         u32 pos;
>         int err;
> +       u8 resp;
> +       struct ufshcd_lrb *lrbp;
>
>         host = cmd->device->host;
>         hba = shost_priv(host);
>         tag = cmd->request->tag;
>
> -       err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_LOGICAL_RESET);
> -       if (err == FAILED)
> +       lrbp = &hba->lrb[tag];
> +       err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
> +                       UFS_LOGICAL_RESET, &resp);
> +       if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> +               err = FAILED;
>                 goto out;
> +       } else {
> +               err = SUCCESS;
> +       }
>
>         for (pos = 0; pos < SCSI_CMD_QUEUE_SIZE; pos++) {
>                 if (test_bit(pos, &hba->outstanding_reqs) &&
> @@ -2468,6 +2511,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>         unsigned long flags;
>         unsigned int tag;
>         int err;
> +       u8 resp;
> +       struct ufshcd_lrb *lrbp;
>
>         host = cmd->device->host;
>         hba = shost_priv(host);
> @@ -2483,9 +2528,15 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>         }
>         spin_unlock_irqrestore(host->host_lock, flags);
>
> -       err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TASK);
> -       if (err == FAILED)
> +       lrbp = &hba->lrb[tag];
> +       err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
> +                       UFS_ABORT_TASK, &resp);
> +       if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> +               err = FAILED;
>                 goto out;
> +       } else {
> +               err = SUCCESS;
> +       }
>
>         scsi_dma_unmap(cmd);
>
> @@ -2714,7 +2765,8 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
>         host->max_cmd_len = MAX_CDB_SIZE;
>
>         /* Initailize wait queue for task management */
> -       init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
> +       init_waitqueue_head(&hba->tm_wq);
> +       init_waitqueue_head(&hba->tm_tag_wq);
>
>         /* Initialize work queues */
>         INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 682c285..8ca08fe 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -172,7 +172,8 @@ struct ufs_internal_cmd {
>   * @irq: Irq number of the controller
>   * @active_uic_cmd: handle of active UIC command
>   * @uic_cmd_mutex: mutex for uic command
> - * @ufshcd_tm_wait_queue: wait queue for task management
> + * @tm_wq: wait queue for task management
> + * @tm_tag_wq: wait queue for free task management slots
>   * @tm_condition: condition variable for task management
>   * @ufshcd_state: UFSHCD states
>   * @intr_mask: Interrupt Mask Bits
> @@ -213,7 +214,8 @@ struct ufs_hba {
>         struct uic_command *active_uic_cmd;
>         struct mutex uic_cmd_mutex;
>
> -       wait_queue_head_t ufshcd_tm_wait_queue;
> +       wait_queue_head_t tm_wq;
> +       wait_queue_head_t tm_tag_wq;
>         unsigned long tm_condition;
>
>         u32 ufshcd_state;
> --
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation.
>



-- 
~Santosh
