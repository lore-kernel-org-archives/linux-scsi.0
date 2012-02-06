From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 4/4] [SCSI] ufshcd: SCSI error handling
Date: Mon, 6 Feb 2012 12:46:15 +0530
Message-ID: <CADDb1s3R1kg7gAbonHUaJtb-eTyxMG9kWFAwNx_h7XnWRz5ZYA@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
	<1328158649-4137-5-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1328158649-4137-5-git-send-email-vinholikatti@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

In function:
+static int ufshcd_abort(struct scsi_cmnd *cmd)
+{...
-       int err;
+       int err =3D -1;
=2E..
+       spin_lock_irqsave(host->host_lock, flags);
+       pos =3D (1 << tag);
+
+       /* check if command is still pending */
+       if (!(hba->outstanding_reqs & pos)) {
-               err =3D -1;
-               spin_unlock_irqrestore(host->host_lock, flags);
+               goto out;
+       }
=2E..
=2E..
+out:
+       spin_unlock_irqrestore(host->host_lock, flags);
+       return err;
+}
this will also take of matching out
spin_lock_irqsave()->spin_unlock_irqrestore() before exiting the
function.

In function:
+static int
+ufshcd_issue_tm_cmd(struct ufs_hba *hba,
+                   struct ufshcd_lrb *lrbp,
+                   u8 tm_function)
=2E..
+       spin_lock_irqsave(host->host_lock, flags);
+
+       /* If task management queue is full */
+       if (!ufshcd_is_tmq_full(hba->outstanding_tasks)) {
+               dev_err(&hba->pdev->dev, "Task management queue full\n"=
);
I think this will map to a Buffered printf - which can potentially
result in BUG: Schedule while atomic()...
+               spin_unlock_irqrestore(host->host_lock, flags);
+               return err;
+       }
So, it could be like this:
+       spin_lock_irqsave(host->host_lock, flags);
+
+       /* If task management queue is full */
+       if (!ufshcd_is_tmq_full(hba->outstanding_tasks)) {
+               spin_unlock_irqrestore(host->host_lock, flags);
+               dev_err(&hba->pdev->dev, "Task management queue full\n"=
);
+               return err;
+       }

Thanks & Regards,
Amit Sahrawat


On Thu, Feb 2, 2012 at 10:27 AM, Vinayak Holikatti
<vinholikatti@gmail.com> wrote:
> From: Santosh Yaraganavi <santoshsy@gmail.com>
>
> UFSHCD SCSI error handling includes following implementations,
> =A0- Abort task
> =A0- Device reset
> =A0- Host reset
>
> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Saugata Das <saugata.das@linaro.org>
> Reviewed-by: Vishak G <vishak.g@samsung.com>
> Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
> ---
> =A0drivers/scsi/ufs/ufshcd.c | =A0312 +++++++++++++++++++++++++++++++=
++++++++++++++
> =A01 files changed, 312 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1bfae84..7589dd1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -76,6 +76,8 @@
> =A0#define NULL 0
> =A0#endif =A0/* NULL */
>
> +#define UFSHCD_MAX_TM_SLOTS =A0 =A00xFF
> +
> =A0#define BYTES_TO_DWORDS(p) =A0 =A0 (p >> 2)
> =A0#define UFSHCD_MMIO_BASE =A0 =A0 =A0 (hba->mmio_base)
>
> @@ -83,6 +85,7 @@ enum {
> =A0 =A0 =A0 =A0UFSHCD_MAX_CHANNEL =A0 =A0 =A0=3D 1,
> =A0 =A0 =A0 =A0UFSHCD_MAX_ID =A0 =A0 =A0 =A0 =A0 =3D 1,
> =A0 =A0 =A0 =A0UFSHCD_MAX_LUNS =A0 =A0 =A0 =A0 =3D 8,
> + =A0 =A0 =A0 UFSHCD_MAX_TM_CMDS =A0 =A0 =A0=3D 8,
> =A0 =A0 =A0 =A0UFSHCD_CMD_PER_LUN =A0 =A0 =A0=3D 16,
> =A0 =A0 =A0 =A0UFSHCD_CAN_QUEUE =A0 =A0 =A0 =A0=3D 32,
> =A0 =A0 =A0 =A0BYTES_128 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 128,
> @@ -149,6 +152,7 @@ struct uic_command {
> =A0* @host: Scsi_Host instance of the driver
> =A0* @pdev: PCI device handle
> =A0* @lrb: local reference block
> + * @outstanding_tasks: Bits representing outstanding task requests
> =A0* @outstanding_reqs: Bits representing outstanding transfer reques=
ts
> =A0* @capabilities: UFS Controller Capabilities
> =A0* @nutrs: Transfer Request Queue depth supported by controller
> @@ -192,6 +196,7 @@ struct ufs_hba {
>
> =A0 =A0 =A0 =A0struct ufshcd_lrb *lrb;
>
> + =A0 =A0 =A0 u32 outstanding_tasks;
> =A0 =A0 =A0 =A0u32 outstanding_reqs;
>
> =A0 =A0 =A0 =A0u32 capabilities;
> @@ -200,6 +205,8 @@ struct ufs_hba {
> =A0 =A0 =A0 =A0u32 ufs_version;
>
> =A0 =A0 =A0 =A0struct uic_command active_uic_cmd;
> + =A0 =A0 =A0 wait_queue_head_t ufshcd_tm_wait_queue;
> + =A0 =A0 =A0 u8 tm_condition[UFSHCD_MAX_TM_CMDS];
>
> =A0 =A0 =A0 =A0u32 ufshcd_state;
> =A0 =A0 =A0 =A0u32 int_enable_mask;
> @@ -278,6 +285,30 @@ static inline int ufshcd_get_tr_ocs(struct ufshc=
d_lrb *lrbp)
> =A0}
>
> =A0/**
> + * ufshcd_get_tmr_ocs - Get the UTMRD Overall Command Status
> + * @task_req_descp: pointer to utp_task_req_desc structure
> + *
> + * This function is used to get the OCS field from UTMRD
> + * Returns the OCS field in the UTMRD
> + */
> +static inline int
> +ufshcd_get_tmr_ocs(struct utp_task_req_desc *task_req_descp)
> +{
> + =A0 =A0 =A0 return task_req_descp->header.dword_2 & MASK_OCS;
> +}
> +
> +/**
> + * ufshcd_is_tmq_full - checks if the task management slots are full
> + * @outstanding_tasks: contains the task management doorbell value
> + *
> + * Returns 1 if a free slot available, 0 if task slots are full
> + */
> +static inline int ufshcd_is_tmq_full(u32 outstanding_tasks)
> +{
> + =A0 =A0 =A0 return (UFSHCD_MAX_TM_SLOTS =3D=3D outstanding_tasks) ?=
 0 : 1;
> +}
> +
> +/**
> =A0* ufshcd_get_lists_status - Check UCRDY, UTRLRDY and UTMRLRDY
> =A0* @reg: Register value of host controller status
> =A0*
> @@ -1098,6 +1129,45 @@ static void ufshcd_slave_destroy(struct scsi_d=
evice *sdev)
> =A0}
>
> =A0/**
> + * ufshcd_task_req_compl - handle task management request completion
> + * @hba: per adapter instance
> + * @index: index of the completed request
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
> +{
> + =A0 =A0 =A0 struct utp_upiu_task_rsp *task_rsp_upiup;
> + =A0 =A0 =A0 struct utp_task_req_desc *task_req_descp;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 int ocs_value;
> + =A0 =A0 =A0 int task_response =3D -1;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(hba->host->host_lock, flags);
> +
> + =A0 =A0 =A0 /* clear completed tasks from outstanding_tasks */
> + =A0 =A0 =A0 hba->outstanding_tasks ^=3D index;
> +
> + =A0 =A0 =A0 task_req_descp =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct utp_task_req_desc *)hba->utmrdl=
_virt_addr_aligned;
> + =A0 =A0 =A0 ocs_value =3D ufshcd_get_tmr_ocs(&task_req_descp[index]=
);
> +
> + =A0 =A0 =A0 if (OCS_SUCCESS =3D=3D ocs_value) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_rsp_upiup =3D (struct utp_upiu_tas=
k_rsp *)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0task=
_req_descp[index].task_rsp_upiu;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_response =3D be32_to_cpu(task_rsp_=
upiup->header.dword_1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_response =3D ((task_response & MAS=
K_TASK_RESPONSE) >> 8);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* clear task response */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(task_rsp_upiup, 0, sizeof(struct=
 utp_upiu_task_rsp));
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> + =A0 =A0 =A0 return task_response;
> +}
> +
> +/**
> =A0* ufshcd_scsi_cmd_status - Update SCSI command result based on scs=
i status
> =A0* @lrb: pointer to local reference block of completed command
> =A0* @scsi_status: SCSI command status
> @@ -1314,6 +1384,31 @@ fatal_eh:
> =A0}
>
> =A0/**
> + * ufshcd_tmc_handler - handle task management function completion
> + * @hba: per adapter instance
> + */
> +static void ufshcd_tmc_handler(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 u32 completed_reqs;
> + =A0 =A0 =A0 u32 tm_doorbell;
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 tm_doorbell =3D readl(hba->mmio_base + REG_UTP_TASK_REQ=
_DOOR_BELL);
> + =A0 =A0 =A0 completed_reqs =3D tm_doorbell ^ hba->outstanding_tasks=
;
> + =A0 =A0 =A0 for (i =3D 0; i < hba->nutmrs; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (completed_reqs & (1 << i)) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Change the default=
 value 0xFF to 0 to indicate
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* completion of resp=
ective task management command
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->tm_condition[i] =3D=
 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up_interruptible(&=
hba->ufshcd_tm_wait_queue);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> =A0* ufshcd_sl_intr - Interrupt service routine
> =A0* @hba: per adapter instance
> =A0* @intr_status: contains interrupts generated by the controller
> @@ -1327,6 +1422,9 @@ static void ufshcd_sl_intr(struct ufs_hba *hba,=
 u32 intr_status)
> =A0 =A0 =A0 =A0if (intr_status & UIC_COMMAND_COMPL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0schedule_work(&hba->uic_workq);
>
> + =A0 =A0 =A0 if (intr_status & UTP_TASK_REQ_COMPL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ufshcd_tmc_handler(hba);
> +
> =A0 =A0 =A0 =A0if (intr_status & UTP_TRANSFER_REQ_COMPL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ufshcd_transfer_req_compl(hba);
> =A0}
> @@ -1362,6 +1460,209 @@ static irqreturn_t ufshcd_intr(int irq, void =
*__hba)
> =A0 =A0 =A0 =A0return retval;
> =A0}
>
> +/**
> + * ufshcd_issue_tm_cmd - issues task management commands to controll=
er
> + * @hba: per adapter instance
> + * @lrbp: pointer to local reference block
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int
> +ufshcd_issue_tm_cmd(struct ufs_hba *hba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ufshcd_lrb *lrbp,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u8 tm_function)
> +{
> + =A0 =A0 =A0 struct utp_task_req_desc *task_req_descp;
> + =A0 =A0 =A0 struct utp_upiu_task_req *task_req_upiup;
> + =A0 =A0 =A0 struct Scsi_Host *host;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 int free_slot =3D 0;
> + =A0 =A0 =A0 int err =3D -1;
> +
> + =A0 =A0 =A0 host =3D hba->host;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(host->host_lock, flags);
> +
> + =A0 =A0 =A0 /* If task management queue is full */
> + =A0 =A0 =A0 if (!ufshcd_is_tmq_full(hba->outstanding_tasks)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev, "Task manageme=
nt queue full\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(host->host_lock,=
 flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 for (i =3D 0; i < hba->nutmrs; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(hba->outstanding_tasks & (1 << i)=
)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 free_slot =3D i;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Configure task request descriptor */
> + =A0 =A0 =A0 task_req_descp =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct utp_task_req_desc *) hba->utmrd=
l_virt_addr_aligned;
> + =A0 =A0 =A0 task_req_descp +=3D free_slot;
> +
> + =A0 =A0 =A0 memset(task_req_descp, 0, sizeof(struct utp_task_req_de=
sc));
> + =A0 =A0 =A0 task_req_descp->header.dword_0 =3D cpu_to_le32(UTP_REQ_=
DESC_INT_CMD);
> + =A0 =A0 =A0 task_req_descp->header.dword_2 =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le32(OCS_INVALID=
_COMMAND_STATUS);
> +
> + =A0 =A0 =A0 /* Configure task request UPIU */
> + =A0 =A0 =A0 task_req_upiup =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct utp_upiu_task_req *) task_req_d=
escp->task_req_upiu;
> + =A0 =A0 =A0 task_req_upiup->header.dword_0 =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_be32(UPIU_HEADER_DWORD(UPIU_TRAN=
SACTION_TASK_REQ, 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 lrbp->lun, lrbp->task_tag));
> + =A0 =A0 =A0 task_req_upiup->header.dword_1 =3D
> + =A0 =A0 =A0 cpu_to_be32(UPIU_HEADER_DWORD(0, tm_function, 0, 0));
> +
> + =A0 =A0 =A0 task_req_upiup->input_param1 =3D lrbp->lun;
> + =A0 =A0 =A0 task_req_upiup->input_param1 =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_be32(task_req_upiup->input_param=
1);
> + =A0 =A0 =A0 task_req_upiup->input_param2 =3D lrbp->task_tag;
> + =A0 =A0 =A0 task_req_upiup->input_param2 =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_be32(task_req_upiup->input_param=
2);
> +
> + =A0 =A0 =A0 /* send command to the controller */
> + =A0 =A0 =A0 hba->outstanding_tasks |=3D (1 << free_slot);
> + =A0 =A0 =A0 writel((1 << free_slot),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE + REG_UTP_TASK_REQ_DOO=
R_BELL));
> +
> + =A0 =A0 =A0 spin_unlock_irqrestore(host->host_lock, flags);
> +
> + =A0 =A0 =A0 /* wait until the task management command is completed =
*/
> + =A0 =A0 =A0 err =3D wait_event_interruptible_timeout(hba->ufshcd_tm=
_wait_queue,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0(hba->tm_condition[free_slot] !=3D 0),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A060 * HZ);
> + =A0 =A0 =A0 hba->tm_condition[free_slot] =3D 0xFF;
> + =A0 =A0 =A0 if (!err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Task management comman=
d timed-out\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return ufshcd_task_req_compl(hba, free_slot);
> +}
> +
> +/**
> + * ufshcd_device_reset - reset device and abort all the pending comm=
ands
> + * @cmd: SCSI command pointer
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int ufshcd_device_reset(struct scsi_cmnd *cmd)
> +{
> + =A0 =A0 =A0 struct Scsi_Host *host;
> + =A0 =A0 =A0 struct ufs_hba *hba;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 int reset_lun;
> + =A0 =A0 =A0 unsigned int tag;
> + =A0 =A0 =A0 u32 i;
> + =A0 =A0 =A0 u32 pos; /* pos: represents a bit in a register */
> + =A0 =A0 =A0 int err =3D -1;
> +
> + =A0 =A0 =A0 host =3D cmd->device->host;
> + =A0 =A0 =A0 hba =3D (struct ufs_hba *)host->hostdata;
> + =A0 =A0 =A0 tag =3D cmd->request->tag;
> +
> + =A0 =A0 =A0 if ((hba->lrb[tag].cmd =3D=3D cmd))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 reset_lun =3D hba->lrb[tag].lun;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 err =3D ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_LO=
GICAL_RESET);
> + =A0 =A0 =A0 if (!err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(host->host_lock, flag=
s);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < hba->nutrs; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pos =3D (1 << i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((pos & hba->outstan=
ding_reqs) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (reset_lun =3D=3D=
 hba->lrb[i].lun)) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* clea=
r the respective UTRLCLR bit */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(=
~pos, (UFSHCD_MMIO_BASE +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 REG_UTP=
_TRANSFER_REQ_LIST_CLEAR));
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->ou=
tstanding_reqs ^=3D pos;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (hba=
->lrb[i].cmd) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 scsi_dma_unmap(hba->lrb[i].cmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 hba->lrb[i].cmd->result =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DID_ABORT << 16;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 hba->lrb[i].cmd->scsi_done(cmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 hba->lrb[i].cmd =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } /* end of for */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(host->host_lock,=
 flags);
> + =A0 =A0 =A0 } /*end of if */
> +out:
> + =A0 =A0 =A0 return err;
> +}
> +
> +/**
> + * ufshcd_host_reset - Main reset function registered with scsi laye=
r
> + * @cmd: SCSI command pointer
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int ufshcd_host_reset(struct scsi_cmnd *cmd)
> +{
> + =A0 =A0 =A0 struct ufs_hba *hba =3D NULL;
> +
> + =A0 =A0 =A0 hba =3D (struct ufs_hba *) &cmd->device->host->hostdata=
[0];
> +
> + =A0 =A0 =A0 if (UFSHCD_STATE_RESET =3D=3D hba->ufshcd_state)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 return ufshcd_do_reset(hba) ? -1 : 0;
> +}
> +
> +/**
> + * ufshcd_abort - abort a specific command
> + * @cmd: SCSI command pointer
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int ufshcd_abort(struct scsi_cmnd *cmd)
> +{
> + =A0 =A0 =A0 struct Scsi_Host *host;
> + =A0 =A0 =A0 struct ufs_hba *hba;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 unsigned int tag;
> + =A0 =A0 =A0 unsigned int pos;
> + =A0 =A0 =A0 int err;
> +
> + =A0 =A0 =A0 host =3D cmd->device->host;
> + =A0 =A0 =A0 hba =3D (struct ufs_hba *) host->hostdata;
> + =A0 =A0 =A0 tag =3D cmd->request->tag;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(host->host_lock, flags);
> + =A0 =A0 =A0 pos =3D (1 << tag);
> +
> + =A0 =A0 =A0 /* check if command is still pending */
> + =A0 =A0 =A0 if (!(hba->outstanding_reqs & pos)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(host->host_lock,=
 flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 err =3D ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_AB=
ORT_TASK);
> + =A0 =A0 =A0 if (!err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(host->host_lock, flag=
s);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_dma_unmap(cmd);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* clear the respective UTRLCLR bit */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(~pos,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (UFSHCD_MMIO_BASE +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0REG_UTP_TRANSFER_REQ=
_LIST_CLEAR));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->outstanding_reqs &=3D ~pos;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->lrb[tag].cmd =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(host->host_lock,=
 flags);
> + =A0 =A0 =A0 }
> +out:
> + =A0 =A0 =A0 return err;
> +}
> +
> =A0static struct scsi_host_template ufshcd_driver_template =3D {
> =A0 =A0 =A0 =A0.module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D THIS_MODUL=
E,
> =A0 =A0 =A0 =A0.name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D UFSHCD,
> @@ -1369,6 +1670,9 @@ static struct scsi_host_template ufshcd_driver_=
template =3D {
> =A0 =A0 =A0 =A0.queuecommand =A0 =A0 =A0 =A0 =A0 =3D ufshcd_queuecomm=
and,
> =A0 =A0 =A0 =A0.slave_alloc =A0 =A0 =A0 =A0 =A0 =A0=3D ufshcd_slave_a=
lloc,
> =A0 =A0 =A0 =A0.slave_destroy =A0 =A0 =A0 =A0 =A0=3D ufshcd_slave_des=
troy,
> + =A0 =A0 =A0 .eh_abort_handler =A0 =A0 =A0 =3D ufshcd_abort,
> + =A0 =A0 =A0 .eh_device_reset_handler =3D ufshcd_device_reset,
> + =A0 =A0 =A0 .eh_host_reset_handler =A0=3D ufshcd_host_reset,
> =A0 =A0 =A0 =A0.this_id =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D -1,
> =A0 =A0 =A0 =A0.sg_tablesize =A0 =A0 =A0 =A0 =A0 =3D SG_ALL,
> =A0 =A0 =A0 =A0.cmd_per_lun =A0 =A0 =A0 =A0 =A0 =A0=3D UFSHCD_CMD_PER=
_LUN,
> @@ -1483,6 +1787,7 @@ ufshcd_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
> =A0 =A0 =A0 =A0struct Scsi_Host *host;
> =A0 =A0 =A0 =A0struct ufs_hba *hba;
> =A0 =A0 =A0 =A0int ufs_hba_len;
> + =A0 =A0 =A0 int index;
> =A0 =A0 =A0 =A0int err;
>
> =A0 =A0 =A0 =A0ufs_hba_len =3D sizeof(struct ufs_hba);
> @@ -1547,6 +1852,13 @@ ufshcd_probe(struct pci_dev *pdev, const struc=
t pci_device_id *id)
> =A0 =A0 =A0 =A0host->unique_id =3D host->host_no;
> =A0 =A0 =A0 =A0host->max_cmd_len =3D MAX_CDB_SIZE;
>
> + =A0 =A0 =A0 /* Initailze wait queue for task management */
> + =A0 =A0 =A0 init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
> +
> + =A0 =A0 =A0 /* Initially assign invalid value to tm_condition */
> + =A0 =A0 =A0 for (index =3D 0; index < hba->nutmrs; index++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->tm_condition[index] =3D 0xFF;
> +
> =A0 =A0 =A0 =A0/* Initialize work queues */
> =A0 =A0 =A0 =A0INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
> =A0 =A0 =A0 =A0INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
