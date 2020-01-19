Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47DEC32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93EBF246AF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:47:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CWXTz14M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgASBrp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 20:47:45 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:41454 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgASBrp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 20:47:45 -0500
Received: by mail-ua1-f67.google.com with SMTP id f7so10312444uaa.8;
        Sat, 18 Jan 2020 17:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3v0B8Le5lxMadkMRa3e2JgX6hIzD2hcV6YftiYMITR8=;
        b=CWXTz14MldaQ8NFRuPUDqtUwKNQEeAOc2ejaQcpc53fJW++zwkB2samiCA9ICBASEh
         XS8IeiYwSOxpmGFI6r77dezGAGgCdbdWujJZH4rQid80ZFdJbN3H49+lxC1eymoJ8J7O
         jnClshx2OdBSDvp+m1P0tnKOemgYDDJSlDQ93lUKbpAfUIIoH2A7bMeexQXzH2LkgZl+
         B9KBE4AIglQhynZZgCAQEgJODjTFR2Lm6PHeslefFoGYJB45ODaqogzF0tlCwQnritdG
         oYWCYD8X4yctaHUW9kHH8tUZM+Zajd0E0lzDMWDj6H+xWSZkCgLSmsXuQ1tp71pnO+4b
         Y6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3v0B8Le5lxMadkMRa3e2JgX6hIzD2hcV6YftiYMITR8=;
        b=jtTcGUMD7BBwHElcAil5aBsY6wkFgUNdcNcgpI/d2FbtWV3sjNENZGmCbxrWG8Qv/G
         vA8EK9BriW/b/A/VK5qRC6Ti7ib+U19zoiWxazd3ldzkvZ6zKynQ7UV1OBVc+KZQW9zV
         tkUyHn4d4vpcUAeqL0Vj7yR9hdL05z4oGcpvL1PIyiIwcl5v1E0mC8/S29tUmsrOXx4C
         qn172C2RepmwkSnXELsalkxaSQIjVYd7MC2DLfaLx1rZbFMVHVnL53dyoFVXTHweq0Wf
         rUIbpZtFpWkClcbChzxX8slILUJ1MWjYIw47fRUR/SwBK8yu7yCou88rOeKZ/aih1e3R
         C6bw==
X-Gm-Message-State: APjAAAUGe5JVxnNxIwLAegoBk4RbZHpgg8KWD/cwAHQ3e2CpJJwxuVfS
        qJEuSfo0CsNrTKhSSoXBfwDOK4rkAs0yrRtRgMQ=
X-Google-Smtp-Source: APXvYqz8Y6RDVFKTH8+87vk5uh1ux/7QB+HMPJ4pxp13es61+35X7Ern3WIU70Yx54M4Lfo1BR/hxLAkveUJyqf1RVY=
X-Received: by 2002:ab0:7049:: with SMTP id v9mr6173663ual.95.1579398463653;
 Sat, 18 Jan 2020 17:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com> <20200119001327.29155-5-huobean@gmail.com>
In-Reply-To: <20200119001327.29155-5-huobean@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 07:17:07 +0530
Message-ID: <CAGOxZ53F8mE-b2X5FS792ZFWtZE-V=RECf82EvR6_iDh8qFKZw@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] scsi: ufs: move ufshcd_get_max_pwr_mode() to ufs_init_params()
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

On Sun, Jan 19, 2020 at 5:44 AM Bean Huo <huobean@gmail.com> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> ufshcd_get_max_pwr_mode() only need to be called once while booting,
> take it out from ufshcd_probe_hba() and inline into ufshcd_init_params().
>
This can be safely squash with the previous patch which introduce
ufshcd_init_params.

> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 54c127ef360b..925b31dc3110 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6959,6 +6959,11 @@ static int ufshcd_init_params(struct ufs_hba *hba)
>                         QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
>                 hba->dev_info.f_power_on_wp_en = flag;
>
> +       /* Probe maximum power mode co-supported by both UFS host and device */
> +       if (ufshcd_get_max_pwr_mode(hba))
> +               dev_err(hba->dev,
> +                       "%s: Failed getting max supported power mode\n",
> +                       __func__);
>  out:
>         return ret;
>  }
> @@ -7057,11 +7062,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
>         ufshcd_force_reset_auto_bkops(hba);
>         hba->wlun_dev_clr_ua = true;
>
> -       if (ufshcd_get_max_pwr_mode(hba)) {
> -               dev_err(hba->dev,
> -                       "%s: Failed getting max supported power mode\n",
> -                       __func__);
> -       } else {
> +       /* Gear up to HS gear if supported */
> +       if (hba->max_pwr_info.is_valid) {
>                 /*
>                  * Set the right value to bRefClkFreq before attempting to
>                  * switch to HS gears.
> --
> 2.17.1
>


-- 
Regards,
Alim
