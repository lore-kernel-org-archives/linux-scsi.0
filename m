From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 1/1] scsi: ufs: Add support for sending NOP OUT UPIU
Date: Thu, 2 May 2013 12:57:07 +0530
Message-ID: <CALMYJDut2=gwVsNxfeEM5mR2K9uJ0nMiV2y=xu3WZEUpfN-z7w@mail.gmail.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +
> +/**
> + * ufshcd_validate_dev_connection() - Check device connection status
> + * @hba: per-adapter instance
> + *
> + * Send NOP OUT UPIU and wait for NOP IN response to check whether the
> + * device Transport Protocol (UTP) layer is ready after a reset.
> + * If the UTP layer at the device side is not initialized, it may
> + * not respond with NOP IN UPIU within timeout of %NOP_OUT_TIMEOUT
> + * and we retry sending NOP OUT for %NOP_OUT_RETRIES iterations.
> + */
> +static int ufshcd_validate_dev_connection(struct ufs_hba *hba)
> +{
> +       int err;
> +       struct ufshcd_lrb *lrbp;
> +       unsigned long timeout;
> +       unsigned long flags;
> +       struct completion wait;
> +       int retries = NOP_OUT_RETRIES;
> +
> +retry:
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       lrbp = &hba->lrb[INTERNAL_CMD_TAG];
> +       init_completion(&wait);
> +
> +       err = ufshcd_compose_nop_out_upiu(hba, lrbp);
> +       if (err)
> +               goto may_retry;
> +
> +       lrbp->completion = &wait;
> +       ufshcd_send_command(hba, INTERNAL_CMD_TAG);
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +       timeout = wait_for_completion_timeout(
> +                       &wait, msecs_to_jiffies(NOP_OUT_TIMEOUT));
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       if (timeout > 0) {
> +               int ocs;
> +
> +               ocs = ufshcd_get_tr_ocs(lrbp);
> +               switch (ocs) {
> +               case OCS_SUCCESS:
> +                       goto out;
> +               default:
> +                       dev_dbg(hba->dev, "%s: OCS error %d\n", __func__, ocs);
> +                       err = -EIO;
> +                       goto may_retry;
> +               }
> +       } else {
> +               u32 reg;
> +
> +               err = -ETIMEDOUT;
> +
> +               /* clear outstanding transaction before retry */
> +               ufshcd_utrl_clear(hba, INTERNAL_CMD_TAG);
> +               __clear_bit(INTERNAL_CMD_TAG, &hba->outstanding_reqs);
> +
> +               /* poll for max. 1 sec to clear door bell register by h/w */
> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
> +               if (readl_poll_timeout(
> +                               hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL,
> +                               reg, !(reg & INTERNAL_CMD_TAG), 1000, 1000))

Condition is always true here, change it to !(reg & (1 << INTERNAL_CMD_TAG)).

> +                       retries = 0;
> +               spin_lock_irqsave(hba->host->host_lock, flags);
> +               goto may_retry;
> +       }
> +



-- 
~Santosh
