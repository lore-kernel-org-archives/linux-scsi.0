Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22CC5C3F68F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDB042467B
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FkJK2kMX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLSSdo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 13:33:44 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:37962 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfLSSdo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 13:33:44 -0500
Received: by mail-vk1-f194.google.com with SMTP id d17so1907638vke.5;
        Thu, 19 Dec 2019 10:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ml4mAJAjd+UzALjuvInIbq2ljDjbxyxCZlmTfZ9UxCk=;
        b=FkJK2kMXU/9fnYvBIr1pmuDBc/Q4Sb9TKnfUaJQ1oGe4RNu9T/nhYd4+rUNAmtJyvv
         8Q2KMCV8W5KOW3EqmHVLyLsU2HGFdKykwecFg/lDk4PIhR+U0jWK61TeH0Fh5w4S+UTl
         vZcLbPi306O1yUfb/1DudDZsFoHN7K9Ad6Jivgm5IjuxpJNLGsMUokzNv2e1gNtmORX3
         w1HfECY+fFGnurtud2eXIApj668AfEunCX9Ulm/vVb59FhI5uYFQnvtn+5fgZrJNICwP
         104Vfo66LHfLmpTygUCT0XLGtVbGeds4qm27YjzLyEA41/YL2LrmwuctfqITBeB7jRWK
         U9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ml4mAJAjd+UzALjuvInIbq2ljDjbxyxCZlmTfZ9UxCk=;
        b=d8XhkVTrHBZjcRu5JUmAo/edBE6t9PGwoJB3qvXOui63GUAfVYqzxipFEu9ru8YfwP
         Db4ftfIHdXMUIfILzpT//Ime2LL1qxDLpV+Ie0R7iIj+SCyQ95SkMnQBv5yOfMhW0LHN
         gt4MaWbpqCXsmjbb/v6s6jIIUmUKNVlpi0JfnFoq0WAA279dpPG5TAwMAHze0HkoDzYh
         P799FwkC2uNJFZIkvKypskzZ4oitPTTm4XL0eX4QxqIcsABbFo8So+BWbjYih33CGfK8
         xZn6shqlVAqqy/I6RpRnq+7UtH8yQTwyys01TET/1fV4lDlvF24OHQPARoCRb7NKxuNC
         F+4g==
X-Gm-Message-State: APjAAAWfXAolkweTnz6hLTjROsBPCzueR3bYmqIiw8UM98APcL7u38vZ
        MijCe6dXtEVpo7sRzLhjwZ31yayqsyxS2tfoXW4=
X-Google-Smtp-Source: APXvYqzIKnrV2MFDOoxVD8lAQN7aW5bueKopZBhGbsA12grhFVgxAF32grZKsQMBuFY1Kl4E16Tfj31nxPSxsQzBbPE=
X-Received: by 2002:a1f:db81:: with SMTP id s123mr7008579vkg.45.1576780423321;
 Thu, 19 Dec 2019 10:33:43 -0800 (PST)
MIME-Version: 1.0
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com> <1576224695-22657-5-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1576224695-22657-5-git-send-email-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Fri, 20 Dec 2019 00:03:07 +0530
Message-ID: <CAGOxZ524P=fDR3Y7+EH381xex8RHWT0Qgw3GvVaAMJsdJZFtgQ@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] scsi: ufs-mediatek: configure and enable clk-gating
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 13, 2019 at 2:42 PM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> Enable clk-gating with customized delayed timer value in
> MediaTek Chipsets.
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 71e2e0e4ea11..282ad06ec846 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -205,6 +205,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>         /* Enable runtime autosuspend */
>         hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
>
> +       /* Enable clock-gating */
> +       hba->caps |= UFSHCD_CAP_CLK_GATING;
> +
>         /*
>          * ufshcd_vops_init() is invoked after
>          * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
> @@ -293,6 +296,23 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
>         return ret;
>  }
>
> +static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
> +{
> +       unsigned long flags;
> +       u32 ah_ms;
> +
> +       if (ufshcd_is_clkgating_allowed(hba)) {
> +               if (ufshcd_is_auto_hibern8_supported(hba) && hba->ahit)
> +                       ah_ms = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK,
> +                                         hba->ahit);
> +               else
> +                       ah_ms = 10;
> +               spin_lock_irqsave(hba->host->host_lock, flags);
> +               hba->clk_gating.delay_ms = ah_ms + 5;
> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
> +       }
> +}
> +
>  static int ufs_mtk_post_link(struct ufs_hba *hba)
>  {
>         /* disable device LCC */
> @@ -308,6 +328,8 @@ static int ufs_mtk_post_link(struct ufs_hba *hba)
>                         FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3));
>         }
>
> +       ufs_mtk_setup_clk_gating(hba);
> +
>         return 0;
>  }
>
> --
> 2.18.0



-- 
Regards,
Alim
