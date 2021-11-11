Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC41C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 16:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CEF661284
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 16:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhKKQvL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 11:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbhKKQvK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 11:51:10 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C4CC061766
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2021 08:48:21 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id x9so6418325ilu.6
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2021 08:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ob/QVLXBDhzGYDXxAt2wfAttuwbLzhCEFFsUxy3dWN0=;
        b=BDgK9ORUst4rmEmDv+VOdL4wH9vpiz/rD76MvSr/DNiSa6mqFV1qjWSZItlcdrAcmU
         Jvb6K/LV3X50Bs802WZBqZP9qEgapL8pEVafm/SVaXw9ZCj/itvdJR/2FmYDbtGyMVFd
         0jT5spGFfcrlC9eRjNkY9v/tLmrOiT8EN27IyyE0K4gmeH7Y0Deca0BuTsPpmwibwiBP
         BpUJubp1w/qSo11iyoViQatr4/7XJEIiOwwIXELlvcT5T/vY7xqtsZ/iGXCAolawdM/s
         4O0YxE1Uk8xdxkVioN5PSmeTYSOAkwi6lCPXGqWPMOKAC0a3SE9USI/vYVB8ksgy7oJP
         Duhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ob/QVLXBDhzGYDXxAt2wfAttuwbLzhCEFFsUxy3dWN0=;
        b=AbKnK15g4/+r52imbd/Lb2vRj1XLL3FFX4i6Omj9U+2EeNrGMZJNw2eSHWHXhhlJrc
         2R9iFPOWVHVWPcQFjwtc7nmKb9oExx78/XGXHCnsyNG7NcI2MozlSMwzwPpVuXoLEB9d
         /7vuXAbCRwC0wQztJ2BCwDC4GY6pzoWtkoTsddqPJoXy5Qt+vyJbTcZEoozXz6yK0+6B
         TgFzCzvdD0lhXaXrqnOhai7L2ruw2Khpoe8AB1U4OGVfEoiFd5AuACWTZ1sxrB6ZvZBN
         lUCJE0Aih7VlNtB2lGyLR0I6DWSXf2TmFI445fJd1TEuvYEfOM1gVnizDUi7imvG06tf
         lyOg==
X-Gm-Message-State: AOAM53000xyeohtg0zLMpceTKC1Gu4pJ2BQDK0wEbo05eeGYEM5g6Sb8
        oLNOCRHHYvK3JCF8HAv3eko/Wf+lLopq5I+9+VA=
X-Google-Smtp-Source: ABdhPJw5Nm4vJyyQrkGc7euJAiJGZFw4AmveKiwmKu1tYG/YUkCRQOXTl7T2tKoOWelkIjS64R+SRFw/P+wtPcr5lV4=
X-Received: by 2002:a92:c80e:: with SMTP id v14mr4849687iln.128.1636649300369;
 Thu, 11 Nov 2021 08:48:20 -0800 (PST)
MIME-Version: 1.0
References: <20211110004440.3389311-1-bvanassche@acm.org> <20211110004440.3389311-4-bvanassche@acm.org>
In-Reply-To: <20211110004440.3389311-4-bvanassche@acm.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Thu, 11 Nov 2021 22:17:44 +0530
Message-ID: <CAGOxZ52hPBFW4+0NnvB8cJnEJygCjmE-Pi2b=RTxA=wf99WR-Q@mail.gmail.com>
Subject: Re: [PATCH 03/11] scsi: ufs: Remove the sdev_rpmb member
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

On Wed, Nov 10, 2021 at 6:21 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Since the sdev_rpmb member of struct ufs_hba is only used inside
> ufshcd_scsi_add_wlus(), convert it into a local variable.
>
> Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
Thanks
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  drivers/scsi/ufs/ufshcd.h |  1 -
>  2 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d18685d080d7..dff76b1a0d5d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7407,7 +7407,7 @@ static inline void ufshcd_blk_pm_runtime_init(struct scsi_device *sdev)
>  static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
>  {
>         int ret = 0;
> -       struct scsi_device *sdev_boot;
> +       struct scsi_device *sdev_boot, *sdev_rpmb;
>
>         hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
>                 ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
> @@ -7418,14 +7418,14 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
>         }
>         scsi_device_put(hba->sdev_ufs_device);
>
> -       hba->sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
> +       sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
>                 ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
> -       if (IS_ERR(hba->sdev_rpmb)) {
> -               ret = PTR_ERR(hba->sdev_rpmb);
> +       if (IS_ERR(sdev_rpmb)) {
> +               ret = PTR_ERR(sdev_rpmb);
>                 goto remove_sdev_ufs_device;
>         }
> -       ufshcd_blk_pm_runtime_init(hba->sdev_rpmb);
> -       scsi_device_put(hba->sdev_rpmb);
> +       ufshcd_blk_pm_runtime_init(sdev_rpmb);
> +       scsi_device_put(sdev_rpmb);
>
>         sdev_boot = __scsi_add_device(hba->host, 0, 0,
>                 ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index a911ad72de7a..65178487adf3 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -809,7 +809,6 @@ struct ufs_hba {
>          * "UFS device" W-LU.
>          */
>         struct scsi_device *sdev_ufs_device;
> -       struct scsi_device *sdev_rpmb;
>
>  #ifdef CONFIG_SCSI_UFS_HWMON
>         struct device *hwmon_device;



-- 
Regards,
Alim
