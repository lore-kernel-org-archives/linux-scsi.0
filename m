From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH V2 3/4] scsi: ufs: Fix device and host reset methods
Date: Wed, 3 Jul 2013 11:19:56 +0530
Message-ID: <CALMYJDuq17Q6WBSy6BkFnbXwSRc3no4wopK0eToQ2=y2DCqM-g@mail.gmail.com>
References: <1372444531-24340-1-git-send-email-sthumma@codeaurora.org> <1372444531-24340-4-git-send-email-sthumma@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1372444531-24340-4-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +
> +/**
> + * ufshcd_eh_device_reset_handler - device reset handler registered to
> + *                                    scsi layer.
> + * @cmd - SCSI command pointer
> + *
> + * Returns SUCCESS/FAILED
> + */
> +static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
> +{
> +       struct ufs_hba *hba;
> +       int err;
> +       unsigned long flags;
> +
> +       hba = shost_priv(cmd->device->host);
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> +               dev_warn(hba->dev, "%s: reset in progress\n", __func__);
> +               err = SUCCESS;
> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
> +               goto out;

It is better to wait here until the state changes to 'operational' or
'error' before returning success.

> +       }
> +
> +       hba->ufshcd_state = UFSHCD_STATE_RESET;
> +       ufshcd_set_device_reset_pending(hba);
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +       err = ufshcd_reset_and_restore(hba);
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       if (!err) {
> +               err = SUCCESS;
> +               hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> +       } else {
> +               err = FAILED;
> +               hba->ufshcd_state = UFSHCD_STATE_ERROR;
> +       }
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +out:
> +       return err;
> +}
> +
> +/**
> + * ufshcd_eh_host_reset_handler - host reset handler registered to scsi layer
> + * @cmd - SCSI command pointer
> + *
> + * Returns SUCCESS/FAILED
> + */
> +static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
> +{
> +       struct ufs_hba *hba;
> +       int err;
> +       unsigned long flags;
> +
> +       hba = shost_priv(cmd->device->host);
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> +               dev_warn(hba->dev, "%s: reset in progress\n", __func__);
> +               err = SUCCESS;
> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
> +               goto out;

same in this case also.

> +       }
> +
> +       hba->ufshcd_state = UFSHCD_STATE_RESET;
> +       ufshcd_set_host_reset_pending(hba);
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +       err = ufshcd_reset_and_restore(hba);
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       if (!err) {
> +               err = SUCCESS;
> +               hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> +       } else {
> +               err = FAILED;
> +               hba->ufshcd_state = UFSHCD_STATE_ERROR;
> +       }
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +out:
> +       return err;
> +}
> +
> +/**

-- 
~Santosh
