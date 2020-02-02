Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8323C3F68F
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 14:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF36C2080D
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 14:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcWFcyry"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgBBOfd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 09:35:33 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:43148 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgBBOfc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 09:35:32 -0500
Received: by mail-vs1-f68.google.com with SMTP id 7so7291040vsr.10;
        Sun, 02 Feb 2020 06:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LZE+Xo98zuPfEJJYc3IqeQRPxedI7zj+vekRKI0XAyw=;
        b=mcWFcyryu3pb908p8t2ntneOZGWX637x+66nF8J6woHFUe8Nfw26wsxiSbrLieqQZf
         u/B7Bv73fme8G/rf4KYLbrJdYkXrq2F1DFiOQciq9P+SRlDN6F4Ry/ySeWMERU3Di0v5
         BYEXlSRbilubviP4KoXvTS4c8ImwmqWC9iYOk9dMsGuAieWURS09EtY8wnhgxXJnwrqq
         HNbQgKsucidqfbOEY+4aseWUiC1tCiurI3vguTqqAGHLRIdAPkBHUUpFDD+FlWH0UiU9
         1IYJywc/l7rmVPf5EyMcK4xM+GfQZl2ru89QJc12JfJJDGo3ZClbJl2OBviUKn1Z9pKG
         jdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LZE+Xo98zuPfEJJYc3IqeQRPxedI7zj+vekRKI0XAyw=;
        b=LsgnU8bZ9JIEk2xc/37jNEyYs25uJPCvJw+pYSIz4nHFVyrenJxTMjpliVm9UytzjA
         ugi+B+oMSl06T2ru2EBdz29qthQW+B+AqHMmKzeJX8W/jvjSaift8keVfbvhxk5BYsB7
         0D5z5bZidlNbwLHVV9bYJMSdjfOr43o2+fRGRFWj4GR1bX+JVWzC+dxpT1GjsTprlU/T
         xR2GWXHEBZAcU4kNXTaXRM9kBCN8ecqZzJAsUD8PmUlbsyL7EGBnoQfETV+7AVbkhCCU
         Z13X43NauAJ+BoyJYaqV9EIEid9QVZPc50f6YAMZuQSALi7uIS71UXqubfR38WAs81+T
         yrqg==
X-Gm-Message-State: APjAAAWWwAGCapkUEqkUnFMDsm45iK4Zzvior7ItjgbvTyHPgcso2nER
        9N3eyz6xleQhzqFZE3406Mwxv3J/WT4C10KLOrw=
X-Google-Smtp-Source: APXvYqxZNyOg7XGNhoutzokbnVc5nQbhtV3AlWk76sEbJJ8d09qRGIpzB/q7iLwEM4Rkk0nO84vGVSnjlYvqgh9b+S8=
X-Received: by 2002:a67:fb14:: with SMTP id d20mr11886738vsr.136.1580654131573;
 Sun, 02 Feb 2020 06:35:31 -0800 (PST)
MIME-Version: 1.0
References: <20200129073902.5786-1-stanley.chu@mediatek.com> <20200129073902.5786-2-stanley.chu@mediatek.com>
In-Reply-To: <20200129073902.5786-2-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 2 Feb 2020 20:04:55 +0530
Message-ID: <CAGOxZ521Vz4EcmWApZLqcDwkwa-XHLFLDx2n1HRht0Pf0fFkmw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] scsi: ufs-mediatek: ensure UniPro is not powered
 down before linkup
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

HI Stanley

On Wed, Jan 29, 2020 at 1:09 PM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> MediaTek Chipsets can enter proprietary UniPro low-power mode during
> suspend while link is in hibern8 state. Make sure leaving low-power
> mode before every link startup to prevent lockup in any possible error recovery
> path.
>
> In the same time, re-factor related funcitons to improve code readability.
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 53eae5fe2ade..7ac838cc15d1 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -30,6 +30,11 @@
>  #define ufs_mtk_device_reset_ctrl(high, res) \
>         ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, high, res)
>
> +#define ufs_mtk_unipro_powerdown(hba, powerdown) \
> +       ufshcd_dme_set(hba, \
> +                      UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0), \
> +                      powerdown)
> +
>  static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
>  {
>         u32 tmp;
> @@ -290,6 +295,8 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
>         int ret;
>         u32 tmp;
>
> +       ufs_mtk_unipro_powerdown(hba, 0);
> +
>         /* disable deep stall */
>         ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_SAVEPOWERCONTROL), &tmp);
>         if (ret)
> @@ -390,9 +397,7 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
>         if (err)
>                 return err;
>
> -       err = ufshcd_dme_set(hba,
> -                            UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
> -                            0);
> +       err = ufs_mtk_unipro_powerdown(hba, 0);
>         if (err)
>                 return err;
>
> @@ -413,14 +418,10 @@ static int ufs_mtk_link_set_lpm(struct ufs_hba *hba)
>  {
>         int err;
>
> -       err = ufshcd_dme_set(hba,
> -                            UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
> -                            1);
> +       err = ufs_mtk_unipro_powerdown(hba, 1);
>         if (err) {
>                 /* Resume UniPro state for following error recovery */
> -               ufshcd_dme_set(hba,
> -                              UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
> -                              0);
> +               ufs_mtk_unipro_powerdown(hba, 0);
>                 return err;
>         }
>
> --
> 2.18.0



-- 
Regards,
Alim
