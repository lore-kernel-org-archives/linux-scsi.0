Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB609C33CB6
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 813B420684
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:05:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4HYewrw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgASOFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 09:05:50 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:40474 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASOFu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 09:05:50 -0500
Received: by mail-vk1-f194.google.com with SMTP id c129so7874428vkh.7;
        Sun, 19 Jan 2020 06:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQ9s6aXRXnoAgbGD22gB4cMgUN7RxJiXOnF2aQocl4w=;
        b=D4HYewrwAwcrLYakl62CNJiFBQ21pi4ZSSvdtblf5pnIkzSU7vQ+QY6eS6wSb8soGu
         tWXzPn5F/se0Rt6m2pey0k3xdLx/CPVJvnLKhitOq7+owIV1+R5iZeE5z4pSsJNCkf8w
         9cApU/2Bw8FkyDzMqpEWX1fm7IyJ5SQEn57J5Qk85uadJEJsl5oX8erdX/F+tAUnEiLI
         ooIHwdS/TjwcABk0pNszo9xzH0Tfl3ocK7J89gLrm95DRPpMbOH2bo5WXnN2Ez8myrue
         G2GYZx1QKuIkjbZyo+WNcvLRqhBtqXcAVgmIJZ18tFRm1rwxDn2FtSvje/bPn2pnzNAZ
         L/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQ9s6aXRXnoAgbGD22gB4cMgUN7RxJiXOnF2aQocl4w=;
        b=dpeMcGSimXEUIxpd9g7u21AwwwOEdegYzuJYXRYeHwtf/eUguYuzFhU0lliujKpceM
         7ZPsmhrSw4dXtTxWjXwVVF8pVGfQRWw/2JrzO+21MRN+//KNKgyt/InRFQTE3fKcjw3u
         Mtjs/221ZD8gTYgH23wCLWXSzCjMeQ9O1IR5C06YUQtyGrT0Htn7JFDwfOy8b3BpQbHA
         2qJ51/QeKilwhcmZl5t/0tNR7OCxt13vtdavnOTkBT2dxb13uOTlxiRYrQ0J7uIv0PMw
         2oxglKmUOrHvx4373AzxnbCKKKE42HJ8+bnhw9wGtV43Cu7sz4jOu1wNV57zPVTXTEe3
         V2sg==
X-Gm-Message-State: APjAAAUb9RyanqRz2zUW6XEWW0yfkAvx7mAEnUz4rrQXJnesvF8CJE05
        LwTcD5keTT0Gkfg8I+ibYYaCvbuBkuncWvcDwHI=
X-Google-Smtp-Source: APXvYqw9nG6xAj+S2gKKCAQ+BbMHU9VAljMkDzXB0Wf9p2t4X/nPF33r/AvPVp0cjllf4FH2e95K5MuKmSvD66pWLFI=
X-Received: by 2002:a1f:8f44:: with SMTP id r65mr7356012vkd.8.1579442749175;
 Sun, 19 Jan 2020 06:05:49 -0800 (PST)
MIME-Version: 1.0
References: <20200117035108.19699-1-stanley.chu@mediatek.com> <20200117035108.19699-2-stanley.chu@mediatek.com>
In-Reply-To: <20200117035108.19699-2-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 19:35:12 +0530
Message-ID: <CAGOxZ51ju5sKxtVzXQAFBKz_4Pc9YEZ0i4o4iHkutGx2d+H2QQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] scsi: ufs-mediatek: add dbg_register_dump implementation
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

On Fri, Jan 17, 2020 at 9:44 AM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> Add dbg_register_dump variant vendor implementation in MediaTek
> UFS driver.
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs-mediatek.c | 16 ++++++++++++++++
>  drivers/scsi/ufs/ufs-mediatek.h |  5 +++++
>  2 files changed, 21 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 8d999c0e60fe..d5194d0c4ef5 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -406,6 +406,21 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>         return 0;
>  }
>
> +static void ufs_mtk_dbg_register_dump(struct ufs_hba *hba)
> +{
> +       ufshcd_dump_regs(hba, REG_UFS_REFCLK_CTRL, 0x4, "Ref-Clk Ctrl ");
> +
> +       ufshcd_dump_regs(hba, REG_UFS_EXTREG, 0x4, "Ext Reg ");
> +
> +       ufshcd_dump_regs(hba, REG_UFS_MPHYCTRL,
> +                        REG_UFS_REJECT_MON - REG_UFS_MPHYCTRL + 4,
> +                        "MPHY Ctrl ");
> +
> +       /* Direct debugging information to REG_MTK_PROBE */
> +       ufshcd_writel(hba, 0x20, REG_UFS_DEBUG_SEL);
> +       ufshcd_dump_regs(hba, REG_UFS_PROBE, 0x4, "Debug Probe ");
> +}
> +
>  static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba,
>                                     struct ufs_dev_desc *card)
>  {
> @@ -430,6 +445,7 @@ static struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
>         .apply_dev_quirks    = ufs_mtk_apply_dev_quirks,
>         .suspend             = ufs_mtk_suspend,
>         .resume              = ufs_mtk_resume,
> +       .dbg_register_dump   = ufs_mtk_dbg_register_dump,
>         .device_reset        = ufs_mtk_device_reset,
>  };
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
> index 31b7fead19eb..fccdd979d6fb 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.h
> +++ b/drivers/scsi/ufs/ufs-mediatek.h
> @@ -13,6 +13,11 @@
>   * Vendor specific UFSHCI Registers
>   */
>  #define REG_UFS_REFCLK_CTRL         0x144
> +#define REG_UFS_EXTREG              0x2100
> +#define REG_UFS_MPHYCTRL            0x2200
> +#define REG_UFS_REJECT_MON          0x22AC
> +#define REG_UFS_DEBUG_SEL           0x22C0
> +#define REG_UFS_PROBE               0x22C8
>
>  /*
>   * Ref-clk control
> --
> 2.18.0



-- 
Regards,
Alim
