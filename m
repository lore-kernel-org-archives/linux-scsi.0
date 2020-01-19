Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D756C33CB6
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54738206E6
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:30:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VoYQA00n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgASBar (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 20:30:47 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:33696 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgASBaq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 20:30:46 -0500
Received: by mail-vk1-f194.google.com with SMTP id i78so7679139vke.0;
        Sat, 18 Jan 2020 17:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EKad1adTTU4LVcn/Blwx2NeGsTOd9VlC38Ni39+5y5g=;
        b=VoYQA00nMU6iafBZElAvTk7u4kdsK3nkqBTFpeEWQA3G0CRzU/Fo50Z4s44+xQw/6Q
         bY/vtKy/ThWinD+crPf2g8zipZ0I28j7P6189VxAFaRa5u73KaLT4tH0BHMpyUyemwXb
         bEkt6Cg1U9pCEmKNlMBZnZBY8dbsOL3Zmy0FehfE95esgmk9D044ZZKDZkXUDqWaEWlo
         qzS1AbEj2dr2QHxIT8h4Xqh39mN1FHjomVH0/FXGythuoaD779OpoF8xEVSJcI7rioe8
         6t+nWL+PgJMyOYxH0crI51qUNQBgj/an3VQZBmnSQ3VdwTapy7bjc11L4gx15YXMU365
         F4og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EKad1adTTU4LVcn/Blwx2NeGsTOd9VlC38Ni39+5y5g=;
        b=EfcgHK4m2r1iX9pt34ekiA3BAsEe+lLxWpiX/5Kfmqq04GgXouRv2NqyxICA/cdxco
         tMGaixQ+cHp5WfzmCSfjHW4Med15kRQXfAqkGYBF4lOITeDuzsVTqsq4QrPqZHDQ7eIr
         eMsBpixGv5Rr0MErrsAXBHdELhJEDZwWsli+7oM5D8GMMTyc9N/ut/U9lkuEfD9Z2tPw
         AqITqjj/v8Yphqg4CFotSXz+ULsCgRx5O6ZNSZ3S2pXhXdJKftuF+lcQ/UU3N8/iUrS0
         T1DYjk6ZJeNTyIvOQf9MlIeGCDGmDq9mMg7+JW+J3RrD3L+SOelgA5rpNKiQEeMBz7hJ
         KLYg==
X-Gm-Message-State: APjAAAWJ8iSPaNvmWFNxyF6nsS/+JDZx6IatlFmgPzJ732K9nmv4LOA+
        U277YzHdwiwhl7S94WAt+BeclWJlg2CXheLeKCM=
X-Google-Smtp-Source: APXvYqwhEGUz+GdZpwKSakwZaVqcrDLa+iMqVqkgjm8E2FCXw/k/lY+872TsN+c6kIJGmQRH7Ex2ef3BVz0VsHLxUe4=
X-Received: by 2002:a1f:4541:: with SMTP id s62mr13717538vka.59.1579397445597;
 Sat, 18 Jan 2020 17:30:45 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com> <20200119001327.29155-2-huobean@gmail.com>
In-Reply-To: <20200119001327.29155-2-huobean@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 07:00:09 +0530
Message-ID: <CAGOxZ52QU-W-MKd05cqXVRO82QMpG1Y9+AzPx4zHsZsioGS1Og@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] scsi: ufs: Fix ufshcd_probe_hba() reture value in
 case ufshcd_scsi_add_wlus() fails
To:     Bean Huo <huobean@gmail.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, asutoshd@codeaurora.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean

On Sun, Jan 19, 2020 at 5:44 AM Bean Huo <huobean@gmail.com> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> A non-zero error value likely being returned by ufshcd_scsi_add_wlus()
> in case of failure of adding the WLs, but ufshcd_probe_hba() doesn't
> use this value, and doesn't report this failure to upper caller.
> This patch is to fix this issue.
>
> Fixes: 2a8fa600445c ("ufs: manually add well known logical units")
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bea036ab189a..9a9085a7bcc5 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7032,7 +7032,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>                         ufshcd_init_icc_levels(hba);
>
>                 /* Add required well known logical units to scsi mid layer */
> -               if (ufshcd_scsi_add_wlus(hba))
> +               ret = ufshcd_scsi_add_wlus(hba);
> +               if (ret)
>                         goto out;
>
>                 /* Initialize devfreq after UFS device is detected */
> --
> 2.17.1
>


-- 
Regards,
Alim
