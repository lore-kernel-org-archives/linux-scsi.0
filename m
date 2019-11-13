Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF2DC17440
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB3A521D7F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5zJXaoW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfKMCZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:25:07 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33206 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfKMCZG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 21:25:06 -0500
Received: by mail-io1-f67.google.com with SMTP id j13so810150ioe.0;
        Tue, 12 Nov 2019 18:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67vt+2/hcnur/stdYuxW6KOlEarE4FFpvwMXouje6z0=;
        b=C5zJXaoWqhirA5JCzRzQxV6NeESF2nnVYyWxW3GPmZgA3s9X0SjSG7oOgw7GKTeKd6
         4UMme8ZH+Z5d040MLiivvMDkk7mV7Y4M2lyRmLy02gcoA8HavuwI81OkKq19KHVvuISM
         hjpF56QT9rMyiN0DCZtYVVuUNz7msCut/xpm3zLFDL1WDZ8NFnvqwFVEoP9LDdYxl4HC
         7v0eBMSBZ7Vt111I1M9fKgU4pcE60ZmLtIm6VPz9tIT3zYHjysYcSRbFSGiowSFh5AN3
         CnyJ3cSirM+W+u0JslaNlQCyGu+b4dFHpV/7oHaHD036f2WdS3cVE3qnoFwCo7vW+1VH
         9Mrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67vt+2/hcnur/stdYuxW6KOlEarE4FFpvwMXouje6z0=;
        b=HQKMcBq0T/O/1gWQTv8tE8zmv0TB1gyNACAArdnVzqyESW4FsIFo44+g3+cJpBYRnN
         81pN8Ty5odZ/Xr65goevoQoRhXjMu9fVrY3YbuCqI/CZElwjJhXNMCLm7S6O6+K+SeP/
         FZjQuOfpZESsG0fGYsOisMJMnsgo89vvHXQJ1/qmKJVkIQm8kwcfdEjW8M48tCAfdJt5
         5MqBzgsR+NWHpNpSJb8nfCmp/R+QrF/oYKVR7jvyOVpgEXoWZaRgtrztM/CUHO85kz3Q
         31a5ROspV3P62kFaxUEO0/DRd83cidyxiQoYdP9N33djomPSw8UihuL0VTJIUgJ81CdD
         tWRA==
X-Gm-Message-State: APjAAAV4eijhwgggWfsz/fFGyej1/BNO7QjS6UVoMzAepWZuaT+daUKz
        9Gn2gn9EJ/h4pN6UxzA7H7lPipwdFPRk3R090iM=
X-Google-Smtp-Source: APXvYqwuo2tTbYTMNeWbnMR8FQ9nl/VAo3S2+IdE0xI195BER3D+h0bQM0h+rgl2KyG1yFAZxh1xzwjq174E8KUeDCI=
X-Received: by 2002:a6b:b987:: with SMTP id j129mr1093188iof.105.1573611904929;
 Tue, 12 Nov 2019 18:25:04 -0800 (PST)
MIME-Version: 1.0
References: <1573200932-384-1-git-send-email-cang@codeaurora.org> <1573200932-384-6-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573200932-384-6-git-send-email-cang@codeaurora.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 13 Nov 2019 07:54:28 +0530
Message-ID: <CAGOxZ502wp17UFEk67Qno9DQ0dFPfwMRTLNTCvOXibQDhOw4SA@mail.gmail.com>
Subject: Re: [PATCH v1 5/5] scsi: ufs: Complete pending requests in host reset
 and restore path
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can,

On Fri, Nov 8, 2019 at 1:50 PM Can Guo <cang@codeaurora.org> wrote:
>
> In UFS host reset and restore path, before probe, we stop and start the
> host controller once. After host controller is stopped, the pending
> requests, if any, are cleared from the doorbell, but no completion IRQ
> would be raised due to the hba is stopped.
> These pending requests shall be completed along with the first NOP_OUT
> command(as it is the first command which can raise a transfer completion
> IRQ) sent during probe.
> Since the OCSs of these pending requests are not SUCCESS(because they are
> not yet literally finished), their UPIUs shall be dumped. When there are
> multiple pending requests, the UPIU dump can be overwhelming and may lead
> to stability issues because it is in atomic context.
> Therefore, before probe, complete these pending requests right after host
> controller is stopped.
>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
Looks good, I hope this is tested on your platform.
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5950a7c..4df4136 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5404,8 +5404,8 @@ static void ufshcd_err_handler(struct work_struct *work)
>
>         /*
>          * if host reset is required then skip clearing the pending
> -        * transfers forcefully because they will automatically get
> -        * cleared after link startup.
> +        * transfers forcefully because they will get cleared during
> +        * host reset and restore
>          */
>         if (needs_reset)
>                 goto skip_pending_xfer_clear;
> @@ -6333,9 +6333,13 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>         int err;
>         unsigned long flags;
>
> -       /* Reset the host controller */
> +       /*
> +        * Stop the host controller and complete the requests
> +        * cleared by h/w
> +        */
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         ufshcd_hba_stop(hba, false);
> +       ufshcd_complete_requests(hba);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>
>         /* scale up clocks to max frequency before full reinitialization */
> @@ -6369,7 +6373,6 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>  static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>  {
>         int err = 0;
> -       unsigned long flags;
>         int retries = MAX_HOST_RESET_RETRIES;
>
>         do {
> @@ -6379,15 +6382,6 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>                 err = ufshcd_host_reset_and_restore(hba);
>         } while (err && --retries);
>
> -       /*
> -        * After reset the door-bell might be cleared, complete
> -        * outstanding requests in s/w here.
> -        */
> -       spin_lock_irqsave(hba->host->host_lock, flags);
> -       ufshcd_transfer_req_compl(hba);
> -       ufshcd_tmc_handler(hba);
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
> -
>         return err;
>  }
>
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>


-- 
Regards,
Alim
