Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C40C33CB1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E465E2073A
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rYQjOwK7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgASO2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 09:28:24 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:33647 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASO2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 09:28:24 -0500
Received: by mail-vs1-f67.google.com with SMTP id n27so17517896vsa.0;
        Sun, 19 Jan 2020 06:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hXWYeX6AjtCDD1kv6pJLbNztbwW499IxeNUMgb5p23o=;
        b=rYQjOwK7eKiea9ZzsLJpVr/fXJw6Odp4y9oVfXjpZ5Ypqm1TDdcsTmyDgkF57qzaM3
         53Fh+Opzf06Zj7t1IOM3DK3rTYv90QhGYbmx6pPAwUP040ziVECm/V3YfHOFFy4DOd/4
         qE7Tbmq1b17DI1RiJ4bHccmrRBUIeGj9SxyczYA2s7+lAGcKi+CoS0iqHiwBbr6otv/w
         YAm7LuJDbwNjDxqdx/zCp3cfc4QdE1vwREHwUhvdoS+56RYx07QOtlwEKrdKRYdQvgSi
         8p1OGceTrELl9lJSaLNZzzPImLJu6d9xW2BoEAjSyh6yU1TivUsROh9Lz/Ck48TAEOox
         CNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hXWYeX6AjtCDD1kv6pJLbNztbwW499IxeNUMgb5p23o=;
        b=LxFKA01iMmwRBqTP+gx19Y/bOanDfJ0VBHRpFabFbeNok1eWELGpDw1lLeOCuNSfNT
         UXa74HAPcp+q/egP06kTksg3Mg7y2Giu5pQfGh+UOPgwE1UjeVbdp2pbQuhtpH8fuKaW
         OKXcSja5tB8tEIfPJ2rXdNbyVnuOcgCdm6jKcFn8UUWz9MLILeuSULktLg8hrhcPGIE3
         ZJk+OufdfHSSJadsEYsRT0TXgyzPCrd2LdZPY7WCnCvqNVe5FmA47USlMF7OhxIz1Lnb
         rNB2FsLosPbvA7OcMWry/TAXBeM+/1HoDfev85qy+8c8gDmWmwfEFP+DH2cgKu2NkQpl
         /7eQ==
X-Gm-Message-State: APjAAAVt0dZ8pbwgwaxl7XsvYovoxvYPwtfwYtz3CMVWCvQFaq+KpAWf
        3B0eI4jADI9WQKsFaC4vp8SI/2RKlxy1k/LpxyM=
X-Google-Smtp-Source: APXvYqzDPJ2ye9YaeF3DaCU8q4S+yDkAYV36sI64ueyCEDAUkMAT1qlcYKkyjVH8mMpwuJiwXy9m1uyuXVfhdKfKCds=
X-Received: by 2002:a05:6102:3102:: with SMTP id e2mr10235569vsh.179.1579444103046;
 Sun, 19 Jan 2020 06:28:23 -0800 (PST)
MIME-Version: 1.0
References: <20200117035108.19699-1-stanley.chu@mediatek.com> <20200117035108.19699-4-stanley.chu@mediatek.com>
In-Reply-To: <20200117035108.19699-4-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 19:57:47 +0530
Message-ID: <CAGOxZ51V6XmAuu4ki_X7kEkCoUHZguM1=peEHSktsuu1obyDFw@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] scsi: ufs-mediatek: enable low-power mode for
 hibern8 state
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>, asutoshd@codeaurora.org,
        Can Guo <cang@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2020 at 9:44 AM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> In MediaTek Chipsets, UniPro link and ufshci can enter proprietary
> low-power mode while link is in hibern8 state.
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs-mediatek.c | 53 +++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index d5194d0c4ef5..f32f3f34f6d0 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -382,11 +382,60 @@ static void ufs_mtk_device_reset(struct ufs_hba *hba)
>         dev_info(hba->dev, "device reset done\n");
>  }
>
> +static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
> +{
> +       int err;
> +
> +       err = ufshcd_hba_enable(hba);
> +       if (err)
> +               return err;
> +
> +       err = ufshcd_dme_set(hba,
> +                            UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
> +                            0);
> +       if (err)
> +               return err;
> +
> +       err = ufshcd_uic_hibern8_exit(hba);
> +       if (!err)
> +               ufshcd_set_link_active(hba);
> +       else
> +               return err;
> +
> +       err = ufshcd_make_hba_operational(hba);
> +       if (err)
> +               return err;
> +
> +       return 0;
> +}
> +
> +static int ufs_mtk_link_set_lpm(struct ufs_hba *hba)
> +{
> +       int err;
> +
> +       err = ufshcd_dme_set(hba,
> +                            UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
> +                            1);
> +       if (err) {
> +               /* Resume UniPro state for following error recovery */
> +               ufshcd_dme_set(hba,
> +                              UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
> +                              0);
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
>  static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  {
> +       int err;
>         struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>
>         if (ufshcd_is_link_hibern8(hba)) {
> +               err = ufs_mtk_link_set_lpm(hba);
> +               if (err)
> +                       return -EAGAIN;
>                 phy_power_off(host->mphy);
>                 ufs_mtk_setup_ref_clk(hba, false);
>         }
> @@ -397,10 +446,14 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  {
>         struct ufs_mtk_host *host = ufshcd_get_variant(hba);
> +       int err;
>
>         if (ufshcd_is_link_hibern8(hba)) {
>                 ufs_mtk_setup_ref_clk(hba, true);
>                 phy_power_on(host->mphy);
> +               err = ufs_mtk_link_set_hpm(hba);
> +               if (err)
> +                       return err;
>         }
>
>         return 0;
> --
> 2.18.0



-- 
Regards,
Alim
