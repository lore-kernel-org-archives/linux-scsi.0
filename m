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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75D8C3524C
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 14:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD1F02082E
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 14:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nkGIcVJU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgBBOgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 09:36:09 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:40237 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgBBOgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 09:36:08 -0500
Received: by mail-vk1-f196.google.com with SMTP id c129so3414685vkh.7;
        Sun, 02 Feb 2020 06:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+7SXwisOz3MJdWhABlsmYfw2UinRaMfqXmyYRTMi5bI=;
        b=nkGIcVJUjrMDSCgg9dnvxyApE+KcfK1JRDvG9M7U69uj4lu4YeheYaqQ2B2zYSHejF
         HtyDT9986T1/59nJv7gUpX4p3b04B4cUUJ38raYyX5kaGSuNmDDQX2tuz7BF4FG5J4ri
         /o0xrbv1G0wkzFupwOvxgiHxTfde5/sY89NBglGhIQ9zKDqPrbcmikAM/SO9aD9VMLJ7
         DENW0BEgzEZ8NGFO7Dbz6loV1SAF3rKSJvkB029la8q0b0d9qxwf/hzaM5N6Z84EQVRT
         HyaLMek17KZSxzfbyj84G5GprKqrNJeuXLNuFuM2RlKt4ERX0B6YGiY+K7wXz1SHYocf
         5ukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+7SXwisOz3MJdWhABlsmYfw2UinRaMfqXmyYRTMi5bI=;
        b=PbKHXtIS7ZaPTnR3tzTnf19efAYlIF6hsoRZP2B9CbnL/MPBcJPI1hOBm+8ZV4uewA
         wzSU0/WB41XBNGDBZOFCj2DVnIM0itmUuKxObUXpbE00mdrpjIaheL0Dr8wHuCne8gPP
         fj1kHKY214Y8xVg3Z1ImFJ2gOC1Sw3kFA86H4Mm9/PSy7Mo88k/Vts3D+0LVMlvTTefp
         ptWr0sJWncnEr4ljRNQSB5boHlGFJ5Rf2E6owJtZPr54pI3O3/P0FsVyx0u8Qb/toTEa
         E22bEkhnSlyWmY8FoFFzkuFrxPWkdM5mlWrMQSfChmuKWnLCgGLkkR+tiR4riNOH83q9
         /ytg==
X-Gm-Message-State: APjAAAVtFFY8IULbBATFtBeKoKoIMOnIc+ma5AQC1FHrlFLQ7Hx0pfLO
        07rDeWE/wrF7UDfOaaqP62ysu09/ObPtTpzr500=
X-Google-Smtp-Source: APXvYqxUF/vzSYFVDONbzX5O+4sOxZwqpd7IDmHOLLBnyBb6Su9xFaTefRJE+qFipRJfPxVP+N294T442JccyQNgqDc=
X-Received: by 2002:a1f:4541:: with SMTP id s62mr11624924vka.59.1580654167536;
 Sun, 02 Feb 2020 06:36:07 -0800 (PST)
MIME-Version: 1.0
References: <20200129073902.5786-1-stanley.chu@mediatek.com> <20200129073902.5786-3-stanley.chu@mediatek.com>
In-Reply-To: <20200129073902.5786-3-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 2 Feb 2020 20:05:31 +0530
Message-ID: <CAGOxZ51Up7xQm0MXFhy3_oDOVy69NM2e4MKjoZvzK8-0SFyKWg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] scsi: ufs-mediatek: support linkoff state during suspend
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

Hi Stanley

On Wed, Jan 29, 2020 at 1:11 PM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> If system suspend or runtime suspend mode is configured as
> linkoff state, phy can be powered off and reference clock
> can be gated in MediaTek Chipsets.
>
> In the same time, remove redundant reference clock control
> in suspend and resume callbacks because such control can be
> well-handled in setup_clocks callback..
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 7ac838cc15d1..d78897a14905 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -167,7 +167,7 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
>
>         switch (status) {
>         case PRE_CHANGE:
> -               if (!on) {
> +               if (!on && !ufshcd_is_link_active(hba)) {
>                         ufs_mtk_setup_ref_clk(hba, on);
>                         ret = phy_power_off(host->mphy);
>                 }
> @@ -437,10 +437,11 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>                 err = ufs_mtk_link_set_lpm(hba);
>                 if (err)
>                         return -EAGAIN;
> -               phy_power_off(host->mphy);
> -               ufs_mtk_setup_ref_clk(hba, false);
>         }
>
> +       if (!ufshcd_is_link_active(hba))
> +               phy_power_off(host->mphy);
> +
>         return 0;
>  }
>
> @@ -449,9 +450,10 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>         struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>         int err;
>
> -       if (ufshcd_is_link_hibern8(hba)) {
> -               ufs_mtk_setup_ref_clk(hba, true);
> +       if (!ufshcd_is_link_active(hba))
>                 phy_power_on(host->mphy);
> +
> +       if (ufshcd_is_link_hibern8(hba)) {
>                 err = ufs_mtk_link_set_hpm(hba);
>                 if (err)
>                         return err;
> --
> 2.18.0



-- 
Regards,
Alim
