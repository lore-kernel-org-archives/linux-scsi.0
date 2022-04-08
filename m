Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B32C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 08:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiDHIJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiDHIJC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 04:09:02 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9422B271
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 01:06:59 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id k23so15733813ejd.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2022 01:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0FdkUX3FV17/fOANG6TbLyFEtvcje/dPC+u2lCmDhk0=;
        b=Wf47Nf5ajnIQFzWFT7lMhBcGUeCBtt+wSUR8WnREk7uDYAUNCa8Gs3p+pO+RQCoNpp
         U3KapHV2pE9aZGoLenKKR46yQRZex8z5QVK+aN70EvAUIcw9eI3Xr6RQMt715Uq/QooP
         knNXKIMu0ZZuPjBZ1aBz2LYrbvk8o7z17I58blS4Ivwt7cYlTBINw5s8+Kff4iyVM8Wm
         5zTIrDzXxF5fMvifEEpUGuguCBF5IvZrYFUpHpua7wS3VnXI7gZnMd9mupFshg2jWz42
         NM6KEx0mQXYhdT/1rpoYSLXC9Xd/KJw8NqLABMmEOi6Yp6/gvEGguNIHxb2ci8euDhre
         OfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FdkUX3FV17/fOANG6TbLyFEtvcje/dPC+u2lCmDhk0=;
        b=0cpK/K7Mbk8rS1zEWtQJwSOXh2SZXnD48eTl0sHiStymaxK75MwWqe/o2pDCIIIWEG
         wWnnFBr5bvG0c6gNRgbAm1hHtThAeHOdTs2VT/syxxhVlePFyKnjG5p6i18ZT4bfKJwj
         DbkYuYJ/u8L90EGJ95Q97rqE8PTJ0DlUCxVIvQeHaLm6kbzh0n6JpAVqKUJUK9Iea+m2
         uL66xTelEMMUhA3uy1poBetpxdoJI9uT6R0g2kZ4zdjI/Eq37BvT57JkrqzmKknnjRwS
         r4uQgbb85jUMERw9y/L+w9rgFMiv1Sc94rY7F7Z23/xDC8qdDDaI3zCsW7HI/tjvAgSj
         +d9A==
X-Gm-Message-State: AOAM530HMKkuHr2iAYnZ8B0vGUU4D5OcCs3G8GJEVZsap31CH4J4oZFf
        a3Ip96QipYTeVfyhoWYmQL8IaN5TimVJY/mtfKWlGA==
X-Google-Smtp-Source: ABdhPJxTxQr5lx4/a7hzE4Cgx2PvwsVdEDJ1KnIwMP6RkAYhVtzPd0ttOSjiBC2paJUKCB5KiLUNGmqZCMh9kcXkMlg=
X-Received: by 2002:a17:906:6a05:b0:6e7:f5c8:1d55 with SMTP id
 qw5-20020a1709066a0500b006e7f5c81d55mr17148307ejc.443.1649405217992; Fri, 08
 Apr 2022 01:06:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220408080538.278707-1-Ajish.Koshy@microchip.com> <20220408080538.278707-2-Ajish.Koshy@microchip.com>
In-Reply-To: <20220408080538.278707-2-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 8 Apr 2022 10:06:47 +0200
Message-ID: <CAMGffEkwrULi71P7D4PnUf2C1t5u5OGX9TjcbGUcK_nVTzkiSA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: pm80xx: mask and unmask upper interrupt
 vectors 32-63
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        damien.lemoal@opensource.wdc.com, john.garry@huawei.com,
        Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 8, 2022 at 10:05 AM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
>
> When upper inbound and outbound queues 32-63 are enabled, we see upper
> vectors 32-63 in interrupt service routine. We need corresponding
> registers to handle masking and unmasking of these upper interrupts.
>
> To achieve this, we use registers MSGU_ODMR_U(0x34) to mask and
> MSGU_ODMR_CLR_U(0x3C) to unmask the interrupts. In these registers bit
> 0-31 represents interrupt vectors 32-63.
>
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 9bb31f66db85..cdb31679f419 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1727,10 +1727,14 @@ static void
>  pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  {
>  #ifdef PM8001_USE_MSIX
> -       u32 mask;
> -       mask = (u32)(1 << vec);
> -
> -       pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
> +       if (vec < 32) {
> +               /* vectors 0 - 31 */
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, 1U << vec);
> +       } else {
> +               /* vectors 32 - 63 */
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
> +                           1U << (vec - 32));
> +       }
>         return;
>  #endif
>         pm80xx_chip_intx_interrupt_enable(pm8001_ha);
> @@ -1746,12 +1750,18 @@ static void
>  pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  {
>  #ifdef PM8001_USE_MSIX
> -       u32 mask;
> -       if (vec == 0xFF)
> -               mask = 0xFFFFFFFF;
> -       else
> -               mask = (u32)(1 << vec);
> -       pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
> +       if (vec == 0xFF) {
> +               /* disable all vectors 0-31, 32-63 */
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 0xFFFFFFFF);
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, 0xFFFFFFFF);
> +       } else if (vec < 32) {
> +               /* vectors 0 - 31 */
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 1U << vec);
> +       } else {
> +               /* vectors 32 - 63 */
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
> +                           1U << (vec - 32));
> +       }
>         return;
>  #endif
>         pm80xx_chip_intx_interrupt_disable(pm8001_ha);
> --
> 2.31.1
>
