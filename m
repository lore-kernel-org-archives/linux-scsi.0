From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 12/15] scsi: ufs: reduce the interrupts for power mode
 change requests
Date: Wed, 21 Oct 2015 23:57:01 +0900
Message-ID: <CAC5umyh+q1_zJTRp1euyqq-rnMUmSxBkdrq48XQLzmtduHf1gQ@mail.gmail.com>
References: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
	<1441188795-4600-13-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441188795-4600-13-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-09-02 19:13 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> DME commands such as Hibern8 enter/exit and gear switch generate 2
> completion interrupts, one for confirmation that command is received
> by local UniPro and 2nd one is the final confirmation after communication
> with remote UniPro. Currently both of these completions are registered
> as interrupt events which is not quite necessary and instead we can
> just wait for the interrupt of 2nd completion, this should reduce
> the number of interrupts and could reduce the unnecessary CPU wakeups
> to handle extra interrupts.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 41 +++++++++++++++++++++++++++--------------
>  1 file changed, 27 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f2d4301..fc2a52d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -986,13 +986,15 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
>   * __ufshcd_send_uic_cmd - Send UIC commands and retrieve the result
>   * @hba: per adapter instance
>   * @uic_cmd: UIC command
> + * @completion: initialize the completion only if this is set to true
>   *
>   * Identical to ufshcd_send_uic_cmd() expect mutex. Must be called
>   * with mutex held and host_lock locked.
>   * Returns 0 only if success.
>   */
>  static int
> -__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
> +__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
> +                     bool completion)
>  {
>         if (!ufshcd_ready_for_uic_cmd(hba)) {
>                 dev_err(hba->dev,
> @@ -1000,7 +1002,8 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
>                 return -EIO;
>         }
>
> -       init_completion(&uic_cmd->done);
> +       if (completion)
> +               init_completion(&uic_cmd->done);
>
>         ufshcd_dispatch_uic_cmd(hba, uic_cmd);
>
> @@ -1025,7 +1028,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
>         ufshcd_add_delay_before_dme_cmd(hba);
>
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
> +       ret = __ufshcd_send_uic_cmd(hba, uic_cmd, true);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>         if (!ret)
>                 ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
> @@ -2346,6 +2349,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>         unsigned long flags;
>         u8 status;
>         int ret;
> +       bool reenable_intr = false;
>
>         mutex_lock(&hba->uic_cmd_mutex);
>         init_completion(&uic_async_done);
> @@ -2353,15 +2357,17 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         hba->uic_async_done = &uic_async_done;
> -       ret = __ufshcd_send_uic_cmd(hba, cmd);
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
> -       if (ret) {
> -               dev_err(hba->dev,
> -                       "pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
> -                       cmd->command, cmd->argument3, ret);
> -               goto out;
> +       if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
> +               ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
> +               /*
> +                * Make sure UIC command completion interrupt is disabled before
> +                * issuing UIC command.
> +                */
> +               wmb();
> +               reenable_intr = true;
>         }
> -       ret = ufshcd_wait_for_uic_cmd(hba, cmd);
> +       ret = __ufshcd_send_uic_cmd(hba, cmd, false);
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>         if (ret) {
>                 dev_err(hba->dev,
>                         "pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
> @@ -2387,7 +2393,10 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>         }
>  out:
>         spin_lock_irqsave(hba->host->host_lock, flags);
> +       hba->active_uic_cmd = NULL;
>         hba->uic_async_done = NULL;
> +       if (reenable_intr)
> +               ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>         mutex_unlock(&hba->uic_cmd_mutex);
>
> @@ -3812,16 +3821,20 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>   */
>  static irqreturn_t ufshcd_intr(int irq, void *__hba)
>  {
> -       u32 intr_status;
> +       u32 intr_status, enabled_intr_status;
>         irqreturn_t retval = IRQ_NONE;
>         struct ufs_hba *hba = __hba;
>
>         spin_lock(hba->host->host_lock);
>         intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> +       enabled_intr_status =
> +               intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);

Is it better to store interrupt mask to new member field in ufs_hba
when ufshcd_{enable,disable}_intr() is called and avoid register
read every interrupt?  Because register read is much slower than
normal memory read and we don't want to slow high IOPS workload.

>
> -       if (intr_status) {
> +       if (intr_status)
>                 ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
> -               ufshcd_sl_intr(hba, intr_status);
> +
> +       if (enabled_intr_status) {
> +               ufshcd_sl_intr(hba, enabled_intr_status);
>                 retval = IRQ_HANDLED;
>         }
>         spin_unlock(hba->host->host_lock);
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
