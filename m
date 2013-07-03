From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH V2 4/4] scsi: ufs: Improve UFS fatal error handling
Date: Wed, 3 Jul 2013 22:22:24 +0530
Message-ID: <CALMYJDszHtT53BHDgepw5D2Sk_Zz+vWedY_Bucd4-FBCWcaYeA@mail.gmail.com>
References: <1372444531-24340-1-git-send-email-sthumma@codeaurora.org> <1372444531-24340-5-git-send-email-sthumma@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:50423 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841Ab3GCQwq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 12:52:46 -0400
In-Reply-To: <1372444531-24340-5-git-send-email-sthumma@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

> +
> +/**
> + * ufshcd_fatal_err_handler - handle fatal errors
> + * @work: pointer to work structure
>   */
>  static void ufshcd_fatal_err_handler(struct work_struct *work)
>  {
>         struct ufs_hba *hba;
> +       unsigned long flags;
> +       u32 err_xfer = 0;
> +       u32 err_tm = 0;
> +       int err;
> +
>         hba = container_of(work, struct ufs_hba, feh_workq);
>
> -       /* check if reset is already in progress */
> -       if (hba->ufshcd_state != UFSHCD_STATE_RESET)
> -               ufshcd_do_reset(hba);
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> +               /* complete processed requests and exit */
> +               ufshcd_transfer_req_compl(hba);
> +               ufshcd_tmc_handler(hba);
> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
> +               return;

I could not go through this patch yet, please check if it needs to
wait here until the state is 'operational' or 'error'.
The 'reset' state might be due to the device reset also.

> +       }
> +
> +       hba->ufshcd_state = UFSHCD_STATE_RESET;
> +       ufshcd_error_autopsy_transfer_req(hba, &err_xfer);
> +       ufshcd_error_autopsy_task_req(hba, &err_tm);
> +


-- 
~Santosh
