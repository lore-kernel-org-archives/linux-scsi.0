From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 4/4] [SCSI] ufshcd: SCSI error handling
Date: Sat, 11 Feb 2012 23:09:24 +0530
Message-ID: <CADDb1s3+ysGCGubuKG9J3P3tBs8QZJHT5m=r6CnS88U9gXSPJg@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
	<1328158649-4137-5-git-send-email-vinholikatti@gmail.com>
	<CADDb1s3R1kg7gAbonHUaJtb-eTyxMG9kWFAwNx_h7XnWRz5ZYA@mail.gmail.com>
	<CALMYJDu4=1a8Damz-QLNdA4V9mj=NB77CcVThJWze2ZdaCx7WA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <CALMYJDu4=1a8Damz-QLNdA4V9mj=NB77CcVThJWze2ZdaCx7WA@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com
List-Id: linux-scsi@vger.kernel.org

Hi Santosh,
Below is the original function in your patch:
+static int ufshcd_abort(struct scsi_cmnd *cmd)
+{
+       struct Scsi_Host *host;
+       struct ufs_hba *hba;
+       unsigned long flags;
+       unsigned int tag;
+       unsigned int pos;
+       int err;
+
+       host = cmd->device->host;
+       hba = (struct ufs_hba *) host->hostdata;
+       tag = cmd->request->tag;
+
+       spin_lock_irqsave(host->host_lock, flags);
+       pos = (1 << tag);
+
+       /* check if command is still pending */
+       if (!(hba->outstanding_reqs & pos)) {
+               err = -1;
+               spin_unlock_irqrestore(host->host_lock, flags);
at this place, you are taking care of unlocking - irqrestore - in case
of error. which is ok.
+               goto out;
+       }
+
+       err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TASK);
+       if (!err) {
+               spin_lock_irqsave(host->host_lock, flags);
+               scsi_dma_unmap(cmd);
+
+               /* clear the respective UTRLCLR bit */
+               writel(~pos,
+                       (UFSHCD_MMIO_BASE +
+                        REG_UTP_TRANSFER_REQ_LIST_CLEAR));
+               hba->outstanding_reqs &= ~pos;
+               hba->lrb[tag].cmd = NULL;
+               spin_unlock_irqrestore(host->host_lock, flags);
this unlocking - irqrestore - will work for your irqsave inside this
'if' - there is no return inside this
+       }
+out:
+       return err;
At this point, there is no unlocking-restore for spin_lock_irqsave
done at the entry of this function
+}
So, the changes I suggested will take care of handling the error
condition as well as the conditions for 'ufshcd_issue_tm_cmd'.

Please let me know in case I am missing something.

Regards,
Amit Sahrawat

On 2/7/12, Santosh Y <santoshsy@gmail.com> wrote:
> On Mon, Feb 6, 2012 at 12:46 PM, Amit Sahrawat
> <amit.sahrawat83@gmail.com> wrote:
>> Hi,
>>
>> In function:
>> +static int ufshcd_abort(struct scsi_cmnd *cmd)
>> +{...
>> -       int err;
>> +       int err = -1;
>> ...
>> +       spin_lock_irqsave(host->host_lock, flags);
>> +       pos = (1 << tag);
>> +
>> +       /* check if command is still pending */
>> +       if (!(hba->outstanding_reqs & pos)) {
>> -               err = -1;
>> -               spin_unlock_irqrestore(host->host_lock, flags);
>> +               goto out;
>> +       }
>> ...
>> ...
>> +out:
>> +       spin_unlock_irqrestore(host->host_lock, flags);
>> +       return err;
>> +}
>> this will also take of matching out
>> spin_lock_irqsave()->spin_unlock_irqrestore() before exiting the
>> function.
>
> That will not work again.
> In case "if (!(hba->outstanding_reqs & pos))" is false,
> i.e if the command for which the abort is issued still exists,
>
> ufshcd_issue_tm_cmd() will be called and if no error returned
> by the function, the code after "out:" will be executed. Which will
> try to "spin_unlock_irqrestore",
> even though no lock has been acquired.
I think you are just trying to disable interrupts and disable
preemtion - with spin_lock_irqsave/spin_unlock_irqsave
if you are looking to acquire lock - then may be
spin_lock_irq/spin_unlock_irq - will work.
>
>>
>> In function:
>> +static int
>> +ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>> +                   struct ufshcd_lrb *lrbp,
>> +                   u8 tm_function)
>> ...
>> +       spin_lock_irqsave(host->host_lock, flags);
>> +
>> +       /* If task management queue is full */
>> +       if (!ufshcd_is_tmq_full(hba->outstanding_tasks)) {
>> +               dev_err(&hba->pdev->dev, "Task management queue full\n");
>> I think this will map to a Buffered printf - which can potentially
>> result in BUG: Schedule while atomic()...
>> +               spin_unlock_irqrestore(host->host_lock, flags);
>> +               return err;
>> +       }
>> So, it could be like this:
>
> ok, Thanks, I'll look into it.
>
>> +       spin_lock_irqsave(host->host_lock, flags);
>> +
>> +       /* If task management queue is full */
>> +       if (!ufshcd_is_tmq_full(hba->outstanding_tasks)) {
>> +               spin_unlock_irqrestore(host->host_lock, flags);
>> +               dev_err(&hba->pdev->dev, "Task management queue full\n");
>> +               return err;
>> +       }
>>
>> Thanks & Regards,
>> Amit Sahrawat
>>
>>
>> On Thu, Feb 2, 2012 at 10:27 AM, Vinayak Holikatti
>> <vinholikatti@gmail.com> wrote:
>>> From: Santosh Yaraganavi <santoshsy@gmail.com>
>>>
>>> UFSHCD SCSI error handling includes following implementations,
>>>  - Abort task
>>>  - Device reset
>>>  - Host reset
>>>
>>> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
>>> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
>>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>>> Reviewed-by: Saugata Das <saugata.das@linaro.org>
>>> Reviewed-by: Vishak G <vishak.g@samsung.com>
>>> Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
>>> ---
>>>  drivers/scsi/ufs/ufshcd.c |  312
>>> +++++++++++++++++++++++++++++++++++++++++++++
>>>  1 files changed, 312 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index 1bfae84..7589dd1 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -76,6 +76,8 @@
>>>  #define NULL 0
>>>  #endif  /* NULL */
>>>
>>> +#define UFSHCD_MAX_TM_SLOTS    0xFF
>>> +
>>>  #define BYTES_TO_DWORDS(p)     (p >> 2)
>>>  #define UFSHCD_MMIO_BASE       (hba->mmio_base)
>>>
>>> @@ -83,6 +85,7 @@ enum {
>>>        UFSHCD_MAX_CHANNEL      = 1,
>>>        UFSHCD_MAX_ID           = 1,
>>>        UFSHCD_MAX_LUNS         = 8,
>>> +       UFSHCD_MAX_TM_CMDS      = 8,
>>>        UFSHCD_CMD_PER_LUN      = 16,
>>>        UFSHCD_CAN_QUEUE        = 32,
>>>        BYTES_128               = 128,
>>> @@ -149,6 +152,7 @@ struct uic_command {
>>>  * @host: Scsi_Host instance of the driver
>>>  * @pdev: PCI device handle
>>>  * @lrb: local reference block
>>> + * @outstanding_tasks: Bits representing outstanding task requests
>>>  * @outstanding_reqs: Bits representing outstanding transfer requests
>>>  * @capabilities: UFS Controller Capabilities
>>>  * @nutrs: Transfer Request Queue depth supported by controller
>>> @@ -192,6 +196,7 @@ struct ufs_hba {
>>>
>>>        struct ufshcd_lrb *lrb;
>>>
>>> +       u32 outstanding_tasks;
>>>        u32 outstanding_reqs;
>>>
>>>        u32 capabilities;
>>> @@ -200,6 +205,8 @@ struct ufs_hba {
>>>        u32 ufs_version;
>>>
>>>        struct uic_command active_uic_cmd;
>>> +       wait_queue_head_t ufshcd_tm_wait_queue;
>>> +       u8 tm_condition[UFSHCD_MAX_TM_CMDS];
>>>
>>>        u32 ufshcd_state;
>>>        u32 int_enable_mask;
>>> @@ -278,6 +285,30 @@ static inline int ufshcd_get_tr_ocs(struct
>>> ufshcd_lrb *lrbp)
>>>  }
>>>
>>>  /**
>>> + * ufshcd_get_tmr_ocs - Get the UTMRD Overall Command Status
>>> + * @task_req_descp: pointer to utp_task_req_desc structure
>>> + *
>>> + * This function is used to get the OCS field from UTMRD
>>> + * Returns the OCS field in the UTMRD
>>> + */
>>> +static inline int
>>> +ufshcd_get_tmr_ocs(struct utp_task_req_desc *task_req_descp)
>>> +{
>>> +       return task_req_descp->header.dword_2 & MASK_OCS;
>>> +}
>>> +
>>> +/**
>>> + * ufshcd_is_tmq_full - checks if the task management slots are full
>>> + * @outstanding_tasks: contains the task management doorbell value
>>> + *
>>> + * Returns 1 if a free slot available, 0 if task slots are full
>>> + */
>>> +static inline int ufshcd_is_tmq_full(u32 outstanding_tasks)
>>> +{
>>> +       return (UFSHCD_MAX_TM_SLOTS == outstanding_tasks) ? 0 : 1;
>>> +}
>>> +
>>> +/**
>>>  * ufshcd_get_lists_status - Check UCRDY, UTRLRDY and UTMRLRDY
>>>  * @reg: Register value of host controller status
>>>  *
>>> @@ -1098,6 +1129,45 @@ static void ufshcd_slave_destroy(struct
>>> scsi_device *sdev)
>>>  }
>>>
>>>  /**
>>> + * ufshcd_task_req_compl - handle task management request completion
>>> + * @hba: per adapter instance
>>> + * @index: index of the completed request
>>> + *
>>> + * Returns 0 on success, non-zero value on failure
>>> + */
>>> +static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
>>> +{
>>> +       struct utp_upiu_task_rsp *task_rsp_upiup;
>>> +       struct utp_task_req_desc *task_req_descp;
>>> +       unsigned long flags;
>>> +       int ocs_value;
>>> +       int task_response = -1;
>>> +
>>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>>> +
>>> +       /* clear completed tasks from outstanding_tasks */
>>> +       hba->outstanding_tasks ^= index;
>>> +
>>> +       task_req_descp =
>>> +               (struct utp_task_req_desc
>>> *)hba->utmrdl_virt_addr_aligned;
>>> +       ocs_value = ufshcd_get_tmr_ocs(&task_req_descp[index]);
>>> +
>>> +       if (OCS_SUCCESS == ocs_value) {
>>> +
>>> +               task_rsp_upiup = (struct utp_upiu_task_rsp *)
>>> +                                task_req_descp[index].task_rsp_upiu;
>>> +               task_response =
>>> be32_to_cpu(task_rsp_upiup->header.dword_1);
>>> +               task_response = ((task_response & MASK_TASK_RESPONSE) >>
>>> 8);
>>> +
>>> +               /* clear task response */
>>> +               memset(task_rsp_upiup, 0, sizeof(struct
>>> utp_upiu_task_rsp));
>>> +       }
>>> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>>> +
>>> +       return task_response;
>>> +}
>>> +
>>> +/**
>>>  * ufshcd_scsi_cmd_status - Update SCSI command result based on scsi
>>> status
>>>  * @lrb: pointer to local reference block of completed command
>>>  * @scsi_status: SCSI command status
>>> @@ -1314,6 +1384,31 @@ fatal_eh:
>>>  }
>>>
>>>  /**
>>> + * ufshcd_tmc_handler - handle task management function completion
>>> + * @hba: per adapter instance
>>> + */
>>> +static void ufshcd_tmc_handler(struct ufs_hba *hba)
>>> +{
>>> +       u32 completed_reqs;
>>> +       u32 tm_doorbell;
>>> +       int i;
>>> +
>>> +       tm_doorbell = readl(hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL);
>>> +       completed_reqs = tm_doorbell ^ hba->outstanding_tasks;
>>> +       for (i = 0; i < hba->nutmrs; i++) {
>>> +               if (completed_reqs & (1 << i)) {
>>> +
>>> +                       /*
>>> +                        * Change the default value 0xFF to 0 to indicate
>>> +                        * completion of respective task management
>>> command
>>> +                        */
>>> +                       hba->tm_condition[i] = 0;
>>> +
>>> wake_up_interruptible(&hba->ufshcd_tm_wait_queue);
>>> +               }
>>> +       }
>>> +}
>>> +
>>> +/**
>>>  * ufshcd_sl_intr - Interrupt service routine
>>>  * @hba: per adapter instance
>>>  * @intr_status: contains interrupts generated by the controller
>>> @@ -1327,6 +1422,9 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32
>>> intr_status)
>>>        if (intr_status & UIC_COMMAND_COMPL)
>>>                schedule_work(&hba->uic_workq);
>>>
>>> +       if (intr_status & UTP_TASK_REQ_COMPL)
>>> +               ufshcd_tmc_handler(hba);
>>> +
>>>        if (intr_status & UTP_TRANSFER_REQ_COMPL)
>>>                ufshcd_transfer_req_compl(hba);
>>>  }
>>> @@ -1362,6 +1460,209 @@ static irqreturn_t ufshcd_intr(int irq, void
>>> *__hba)
>>>        return retval;
>>>  }
>>>
>>> +/**
>>> + * ufshcd_issue_tm_cmd - issues task management commands to controller
>>> + * @hba: per adapter instance
>>> + * @lrbp: pointer to local reference block
>>> + *
>>> + * Returns 0 on success, non-zero value on failure
>>> + */
>>> +static int
>>> +ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>>> +                   struct ufshcd_lrb *lrbp,
>>> +                   u8 tm_function)
>>> +{
>>> +       struct utp_task_req_desc *task_req_descp;
>>> +       struct utp_upiu_task_req *task_req_upiup;
>>> +       struct Scsi_Host *host;
>>> +       unsigned long flags;
>>> +       int i;
>>> +       int free_slot = 0;
>>> +       int err = -1;
>>> +
>>> +       host = hba->host;
>>> +
>>> +       spin_lock_irqsave(host->host_lock, flags);
>>> +
>>> +       /* If task management queue is full */
>>> +       if (!ufshcd_is_tmq_full(hba->outstanding_tasks)) {
>>> +               dev_err(&hba->pdev->dev, "Task management queue full\n");
>>> +               spin_unlock_irqrestore(host->host_lock, flags);
>>> +               return err;
>>> +       }
>>> +
>>> +       for (i = 0; i < hba->nutmrs; i++) {
>>> +               if (!(hba->outstanding_tasks & (1 << i))) {
>>> +                       free_slot = i;
>>> +                       break;
>>> +               }
>>> +       }
>>> +
>>> +       /* Configure task request descriptor */
>>> +       task_req_descp =
>>> +               (struct utp_task_req_desc *)
>>> hba->utmrdl_virt_addr_aligned;
>>> +       task_req_descp += free_slot;
>>> +
>>> +       memset(task_req_descp, 0, sizeof(struct utp_task_req_desc));
>>> +       task_req_descp->header.dword_0 =
>>> cpu_to_le32(UTP_REQ_DESC_INT_CMD);
>>> +       task_req_descp->header.dword_2 =
>>> +                       cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
>>> +
>>> +       /* Configure task request UPIU */
>>> +       task_req_upiup =
>>> +               (struct utp_upiu_task_req *)
>>> task_req_descp->task_req_upiu;
>>> +       task_req_upiup->header.dword_0 =
>>> +               cpu_to_be32(UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ,
>>> 0,
>>> +                                             lrbp->lun,
>>> lrbp->task_tag));
>>> +       task_req_upiup->header.dword_1 =
>>> +       cpu_to_be32(UPIU_HEADER_DWORD(0, tm_function, 0, 0));
>>> +
>>> +       task_req_upiup->input_param1 = lrbp->lun;
>>> +       task_req_upiup->input_param1 =
>>> +               cpu_to_be32(task_req_upiup->input_param1);
>>> +       task_req_upiup->input_param2 = lrbp->task_tag;
>>> +       task_req_upiup->input_param2 =
>>> +               cpu_to_be32(task_req_upiup->input_param2);
>>> +
>>> +       /* send command to the controller */
>>> +       hba->outstanding_tasks |= (1 << free_slot);
>>> +       writel((1 << free_slot),
>>> +              (UFSHCD_MMIO_BASE + REG_UTP_TASK_REQ_DOOR_BELL));
>>> +
>>> +       spin_unlock_irqrestore(host->host_lock, flags);
>>> +
>>> +       /* wait until the task management command is completed */
>>> +       err = wait_event_interruptible_timeout(hba->ufshcd_tm_wait_queue,
>>> +                                        (hba->tm_condition[free_slot] !=
>>> 0),
>>> +                                        60 * HZ);
>>> +       hba->tm_condition[free_slot] = 0xFF;
>>> +       if (!err) {
>>> +               dev_err(&hba->pdev->dev,
>>> +                       "Task management command timed-out\n");
>>> +               return err;
>>> +       }
>>> +       return ufshcd_task_req_compl(hba, free_slot);
>>> +}
>>> +
>>> +/**
>>> + * ufshcd_device_reset - reset device and abort all the pending commands
>>> + * @cmd: SCSI command pointer
>>> + *
>>> + * Returns 0 on success, non-zero value on failure
>>> + */
>>> +static int ufshcd_device_reset(struct scsi_cmnd *cmd)
>>> +{
>>> +       struct Scsi_Host *host;
>>> +       struct ufs_hba *hba;
>>> +       unsigned long flags;
>>> +       int reset_lun;
>>> +       unsigned int tag;
>>> +       u32 i;
>>> +       u32 pos; /* pos: represents a bit in a register */
>>> +       int err = -1;
>>> +
>>> +       host = cmd->device->host;
>>> +       hba = (struct ufs_hba *)host->hostdata;
>>> +       tag = cmd->request->tag;
>>> +
>>> +       if ((hba->lrb[tag].cmd == cmd))
>>> +               reset_lun = hba->lrb[tag].lun;
>>> +       else
>>> +               goto out;
>>> +
>>> +       err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag],
>>> UFS_LOGICAL_RESET);
>>> +       if (!err) {
>>> +               spin_lock_irqsave(host->host_lock, flags);
>>> +               for (i = 0; i < hba->nutrs; i++) {
>>> +                       pos = (1 << i);
>>> +                       if ((pos & hba->outstanding_reqs) &&
>>> +                           (reset_lun == hba->lrb[i].lun)) {
>>> +
>>> +                               /* clear the respective UTRLCLR bit */
>>> +                               writel(~pos, (UFSHCD_MMIO_BASE +
>>> +                               REG_UTP_TRANSFER_REQ_LIST_CLEAR));
>>> +
>>> +                               hba->outstanding_reqs ^= pos;
>>> +
>>> +                               if (hba->lrb[i].cmd) {
>>> +                                       scsi_dma_unmap(hba->lrb[i].cmd);
>>> +                                       hba->lrb[i].cmd->result =
>>> +                                                       DID_ABORT << 16;
>>> +                                       hba->lrb[i].cmd->scsi_done(cmd);
>>> +                                       hba->lrb[i].cmd = NULL;
>>> +                               }
>>> +                       }
>>> +               } /* end of for */
>>> +               spin_unlock_irqrestore(host->host_lock, flags);
>>> +       } /*end of if */
>>> +out:
>>> +       return err;
>>> +}
>>> +
>>> +/**
>>> + * ufshcd_host_reset - Main reset function registered with scsi layer
>>> + * @cmd: SCSI command pointer
>>> + *
>>> + * Returns 0 on success, non-zero value on failure
>>> + */
>>> +static int ufshcd_host_reset(struct scsi_cmnd *cmd)
>>> +{
>>> +       struct ufs_hba *hba = NULL;
>>> +
>>> +       hba = (struct ufs_hba *) &cmd->device->host->hostdata[0];
>>> +
>>> +       if (UFSHCD_STATE_RESET == hba->ufshcd_state)
>>> +               return 0;
>>> +
>>> +       return ufshcd_do_reset(hba) ? -1 : 0;
>>> +}
>>> +
>>> +/**
>>> + * ufshcd_abort - abort a specific command
>>> + * @cmd: SCSI command pointer
>>> + *
>>> + * Returns 0 on success, non-zero value on failure
>>> + */
>>> +static int ufshcd_abort(struct scsi_cmnd *cmd)
>>> +{
>>> +       struct Scsi_Host *host;
>>> +       struct ufs_hba *hba;
>>> +       unsigned long flags;
>>> +       unsigned int tag;
>>> +       unsigned int pos;
>>> +       int err;
>>> +
>>> +       host = cmd->device->host;
>>> +       hba = (struct ufs_hba *) host->hostdata;
>>> +       tag = cmd->request->tag;
>>> +
>>> +       spin_lock_irqsave(host->host_lock, flags);
>>> +       pos = (1 << tag);
>>> +
>>> +       /* check if command is still pending */
>>> +       if (!(hba->outstanding_reqs & pos)) {
>>> +               err = -1;
>>> +               spin_unlock_irqrestore(host->host_lock, flags);
>>> +               goto out;
>>> +       }
>>> +
>>> +       err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TASK);
>>> +       if (!err) {
>>> +               spin_lock_irqsave(host->host_lock, flags);
>>> +               scsi_dma_unmap(cmd);
>>> +
>>> +               /* clear the respective UTRLCLR bit */
>>> +               writel(~pos,
>>> +                       (UFSHCD_MMIO_BASE +
>>> +                        REG_UTP_TRANSFER_REQ_LIST_CLEAR));
>>> +               hba->outstanding_reqs &= ~pos;
>>> +               hba->lrb[tag].cmd = NULL;
>>> +               spin_unlock_irqrestore(host->host_lock, flags);
>>> +       }
>>> +out:
>>> +       return err;
>>> +}
>>> +
>>>  static struct scsi_host_template ufshcd_driver_template = {
>>>        .module                 = THIS_MODULE,
>>>        .name                   = UFSHCD,
>>> @@ -1369,6 +1670,9 @@ static struct scsi_host_template
>>> ufshcd_driver_template = {
>>>        .queuecommand           = ufshcd_queuecommand,
>>>        .slave_alloc            = ufshcd_slave_alloc,
>>>        .slave_destroy          = ufshcd_slave_destroy,
>>> +       .eh_abort_handler       = ufshcd_abort,
>>> +       .eh_device_reset_handler = ufshcd_device_reset,
>>> +       .eh_host_reset_handler  = ufshcd_host_reset,
>>>        .this_id                = -1,
>>>        .sg_tablesize           = SG_ALL,
>>>        .cmd_per_lun            = UFSHCD_CMD_PER_LUN,
>>> @@ -1483,6 +1787,7 @@ ufshcd_probe(struct pci_dev *pdev, const struct
>>> pci_device_id *id)
>>>        struct Scsi_Host *host;
>>>        struct ufs_hba *hba;
>>>        int ufs_hba_len;
>>> +       int index;
>>>        int err;
>>>
>>>        ufs_hba_len = sizeof(struct ufs_hba);
>>> @@ -1547,6 +1852,13 @@ ufshcd_probe(struct pci_dev *pdev, const struct
>>> pci_device_id *id)
>>>        host->unique_id = host->host_no;
>>>        host->max_cmd_len = MAX_CDB_SIZE;
>>>
>>> +       /* Initailze wait queue for task management */
>>> +       init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
>>> +
>>> +       /* Initially assign invalid value to tm_condition */
>>> +       for (index = 0; index < hba->nutmrs; index++)
>>> +               hba->tm_condition[index] = 0xFF;
>>> +
>>>        /* Initialize work queues */
>>>        INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
>>>        INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
>>> --
>>> 1.7.5.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> ~Santosh
>
