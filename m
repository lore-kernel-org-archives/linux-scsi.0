From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH V5 11/17] scsi: ufs: add UFS power management support
Date: Thu, 25 Sep 2014 08:11:57 +0900
Message-ID: <CAC5umyidmPpq4r3J5yj3K1jTZdxoM_BO=ZxrLbA7Y2YoXpbHfw@mail.gmail.com>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
	<1411571653-22729-12-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1411571653-22729-12-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

2014-09-25 0:14 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:
> +int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>  {
> -       struct uic_command uic_cmd = {0};
> -       struct completion pwr_done;
> +       struct completion uic_async_done;
>         unsigned long flags;
>         u8 status;
>         int ret;
>
> -       uic_cmd.command = UIC_CMD_DME_SET;
> -       uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
> -       uic_cmd.argument3 = mode;
> -       init_completion(&pwr_done);
> -
>         mutex_lock(&hba->uic_cmd_mutex);
> +       init_completion(&uic_async_done);
>
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       hba->pwr_done = &pwr_done;
> +       hba->uic_async_done = &uic_async_done;
> +       ret = __ufshcd_send_uic_cmd(hba, cmd);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);

__ufshcd_send_uic_cmd() is called with host_lock held here, but
host_lock is acquired again in __ufshcd_send_uic_cmd().  So it causes
recursive deadlock.

> -       ret = __ufshcd_send_uic_cmd(hba, &uic_cmd);
>         if (ret) {
>                 dev_err(hba->dev,
> -                       "pwr mode change with mode 0x%x uic error %d\n",
> -                       mode, ret);
> +                       "pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
> +                       cmd->command, cmd->argument3, ret);
> +               goto out;
> +       }
> +       ret = ufshcd_wait_for_uic_cmd(hba, cmd);

ufshcd_wait_for_uic_cmd() is already called in the previous
__ufshcd_send_uic_cmd() call.

These two issues don't exist in v3.

> +static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
> +                                        struct ufs_vreg *vreg)
> +{
> +       return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
> +}
> +
> +static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
> +                                        struct ufs_vreg *vreg)
> +{
> +       return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
> +}

I was still seeing null pointer derefence with v4 which I was reported
(http://marc.info/?l=linux-scsi&m=141087506802548) and nothing
changed in v5.  Could you check if the fix is needed?
