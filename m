Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F19C35249
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 14:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5AEE21655
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 14:37:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIVyqfkm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBBOhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 09:37:10 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:38939 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgBBOhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 09:37:09 -0500
Received: by mail-ua1-f68.google.com with SMTP id 73so4344549uac.6;
        Sun, 02 Feb 2020 06:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ih4Pj7LjGlqiueuD3OMdD/Ubng6cDHlRXAZYVnlfnn8=;
        b=CIVyqfkmn/pL+mv/Mec0ynNmwkLzpZOKb3nQ5xFudSemA+Gw5ekljtq6uQQ5siajF+
         nmC0DRQb6XGmv33YtbbsH4QzxWt9lXnMXAA6SRxK2WtydG4QxN0bzkrNGf2dKUWhT/rd
         jlWdKpKjuSiaeeeVpUj4fKrt88pUVVE06Msnf/BDPb1s3Av6VW4DDBKSAqnzwimwjvPP
         F7GhqRZXiCXpGOuYhW/0l8CY9xE36zvRsQtjviFByKEawdJvbdh25wxsnU7VyXJGwlxL
         SE2XUMmkq8IofSSfWsqsBWjs0LKJRxD+1VbVISBWFxNyme+y8CTiM/f6/tJICwfq9+y3
         a6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ih4Pj7LjGlqiueuD3OMdD/Ubng6cDHlRXAZYVnlfnn8=;
        b=Ui+qUmskjt+8aKgi7gO8788TRImNkWEmfWUd3/XaUOCrb5v+/DdM1bScY9il6NTpDm
         eVujdqTe16eyp3kOoFXUp37iCvwDa/jjsqo5nggATFdnc1ZlMdzIh4atdcCaaAowTqEI
         JMs6s/bK+DLSY+To/tiMolUcWl6ufBH7l7CNcvioOLA1YQqPrUrF0pOYfq6ktj59jeFf
         8/wr21vGE/2xG1Pli6zj8xL1UYyRpvumMkk0779Wje9KbUr/80S8C8GQcqh+XmdPiUsa
         gKVaaO9TdQ1qNVe5fE4piYTZnXrVzw2q0Xh8tJj6aal7EEF3uiaymIuEMbOy0Njknj80
         WSyw==
X-Gm-Message-State: APjAAAW/UngjpA5aZQdOjWPEB2ugGulvXst44bdBuBPBFiOi+p09qxEK
        i2TssTP9To0SUVGHS19DMlIUziLc0hUQUYFVOnE=
X-Google-Smtp-Source: APXvYqzRU5AR6Q1KzIz1EqIEz3VEXTxT65lb27mSl+ah6Nwo+0NacBNcvtSRyN8NMgiJb56Zi3AJ6vcKtpWkEZ0pmrU=
X-Received: by 2002:ab0:2881:: with SMTP id s1mr11115054uap.95.1580654228212;
 Sun, 02 Feb 2020 06:37:08 -0800 (PST)
MIME-Version: 1.0
References: <20200129073902.5786-1-stanley.chu@mediatek.com> <20200129073902.5786-5-stanley.chu@mediatek.com>
In-Reply-To: <20200129073902.5786-5-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 2 Feb 2020 20:06:32 +0530
Message-ID: <CAGOxZ51FwULV_XpZAWMOMd0Qn8dqv8Ea7koLmPrtn3HxU8fJuQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] scsi: ufs-mediatek: gate ref-clk during Auto-Hibern8
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

Hello Stanley

On Wed, Jan 29, 2020 at 1:10 PM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> In current UFS driver design, hba->uic_link_state will not
> be changed after link enters Hibern8 state by Auto-Hibern8 mechanism.
> In this case, reference clock gating will be skipped unless special
> handling is implemented in vendor's callbacks.
>
> Support reference clock gating during Auto-Hibern8 period in
> MediaTek Chipsets: If link state is already in Hibern8 while
> Auto-Hibern8 feature is enabled, gate reference clock in
> setup_clocks callback.
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 38 +++++++++++++++++++++++----------
>  drivers/scsi/ufs/ufs-mediatek.h | 12 +++++++++++
>  2 files changed, 39 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index d78897a14905..0ce08872d671 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -143,6 +143,17 @@ static int ufs_mtk_setup_ref_clk(struct ufs_hba *hba, bool on)
>         return 0;
>  }
>
> +static u32 ufs_mtk_link_get_state(struct ufs_hba *hba)
> +{
> +       u32 val;
> +
> +       ufshcd_writel(hba, 0x20, REG_UFS_DEBUG_SEL);
> +       val = ufshcd_readl(hba, REG_UFS_PROBE);
> +       val = val >> 28;
> +
> +       return val;
> +}
> +
>  /**
>   * ufs_mtk_setup_clocks - enables/disable clocks
>   * @hba: host controller instance
> @@ -155,7 +166,7 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
>                                 enum ufs_notify_change_status status)
>  {
>         struct ufs_mtk_host *host = ufshcd_get_variant(hba);
> -       int ret = -EINVAL;
> +       int ret = 0;
>
>         /*
>          * In case ufs_mtk_init() is not yet done, simply ignore.
> @@ -165,19 +176,24 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
>         if (!host)
>                 return 0;
>
> -       switch (status) {
> -       case PRE_CHANGE:
> -               if (!on && !ufshcd_is_link_active(hba)) {
> +       if (!on && status == PRE_CHANGE) {
> +               if (!ufshcd_is_link_active(hba)) {
>                         ufs_mtk_setup_ref_clk(hba, on);
>                         ret = phy_power_off(host->mphy);
> +               } else {
> +                       /*
> +                        * Gate ref-clk if link state is in Hibern8
> +                        * triggered by Auto-Hibern8.
> +                        */
> +                       if (!ufshcd_can_hibern8_during_gating(hba) &&
> +                           ufshcd_is_auto_hibern8_enabled(hba) &&
> +                           ufs_mtk_link_get_state(hba) ==
> +                           VS_LINK_HIBERN8)
> +                               ufs_mtk_setup_ref_clk(hba, on);
>                 }
> -               break;
> -       case POST_CHANGE:
> -               if (on) {
> -                       ret = phy_power_on(host->mphy);
> -                       ufs_mtk_setup_ref_clk(hba, on);
> -               }
> -               break;
> +       } else if (on && status == POST_CHANGE) {
> +               ret = phy_power_on(host->mphy);
> +               ufs_mtk_setup_ref_clk(hba, on);
>         }
>
>         return ret;
> diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
> index fccdd979d6fb..492414e5f481 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.h
> +++ b/drivers/scsi/ufs/ufs-mediatek.h
> @@ -53,6 +53,18 @@
>  #define VS_SAVEPOWERCONTROL         0xD0A6
>  #define VS_UNIPROPOWERDOWNCONTROL   0xD0A8
>
> +/*
> + * Vendor specific link state
> + */
> +enum {
> +       VS_LINK_DISABLED            = 0,
> +       VS_LINK_DOWN                = 1,
> +       VS_LINK_UP                  = 2,
> +       VS_LINK_HIBERN8             = 3,
> +       VS_LINK_LOST                = 4,
> +       VS_LINK_CFG                 = 5,
> +};
> +
>  /*
>   * SiP commands
>   */
> --
> 2.18.0



-- 
Regards,
Alim
