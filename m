Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A21CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 09:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237916AbiC1Jlv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 05:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbiC1Jln (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 05:41:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D059B167C1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 02:40:02 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b15so16198320edn.4
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 02:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XphdotEuNLAFjkaipQvPkZG3v4Qii60zfDxF4XNNly8=;
        b=OuUqLE6Fx10BUn6/wQVfv4szFqF8GaFTDEN2rkaamoPZJG/LA7PexZvB5LCaFsv/S1
         32OfnydxlrKFGScLMYPOm0DPS5H7XGDMBwtS0xcihfYlY56yYW8+wHGDncluarOHmiWJ
         Zo2QsyH/qcFRI3Gz6/cuoZsmLiCU35stpaVFLsbErKwNgIxbYiZaFVZz7IOHsk7rmIkb
         elHDFVCOsf3+bzdPguxQ8wg4w1OGTn5CbWrc9DrHpIvKooqRACOzMO9KsK9syhMfQjQ1
         lU/iURV9rQ5V6X2vbT/ldn4pu+re3X7H01aPFd87nxCx0Z4VLzQqsdsDBJvm7RtsBR39
         ZJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XphdotEuNLAFjkaipQvPkZG3v4Qii60zfDxF4XNNly8=;
        b=PB8uFE4IO9Ll8687+Y22SMap2naA6kfB6pzZg+jJdkm5NRNuUvT/tpEugxEgL9ek8p
         RobUIofghO7+gsQiLmuP4cn2BR9DFd4905LA0E5TDlb78/nGjuyrbjKVBbGEPr8lWUsu
         qf73L+BhFJUCp+acAgoep6HsOg/QAKFkM6VADdx0svv2k6Y2PqW+YIDN5f7Q5pru5tBZ
         78wCx6asdU+NPYIt/Fmv+obZN5lU3NspsH6bxjuws1sDxpRU5mjyGzD1UrGOB2Y/kQaw
         MQIdPsjJt7P+lYch+rQWLsP9I6SO7i4WDinAeXMNyQvf0eK+qZmUwMyHCcGwYvbQFjgM
         yXrg==
X-Gm-Message-State: AOAM5329W8711TB8sS/8o3+4dcY95+bQQ4JpojEjeyoEpUxF4W1ISqPc
        XhG+1zcD6WNYxI+q3S+kUYyKZrv7zz8y5w/qkraW5A==
X-Google-Smtp-Source: ABdhPJzgwmxPFIqXecmmLBiM9tfsOg1o3cwwv6yOWk823aXwHxLxHPkMvgeJatFTRXq7t1h8hC5ydLvK9mtS/ep8Tho=
X-Received: by 2002:a05:6402:26c3:b0:419:2e13:27fd with SMTP id
 x3-20020a05640226c300b004192e1327fdmr15111691edd.210.1648460401338; Mon, 28
 Mar 2022 02:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com> <20220328084243.301493-2-Ajish.Koshy@microchip.com>
In-Reply-To: <20220328084243.301493-2-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 28 Mar 2022 11:39:50 +0200
Message-ID: <CAMGffEnQr0cQSwJ2ionZrFwLPb7Uvr8zby+y76+BDAX5E9jzbg@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: pm80xx: mask and unmask upper interrupt vectors 32-63
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        damien.lemoal@opensource.wdc.com, john.garry@huawei.com,
        Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 28, 2022 at 10:42 AM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
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
same as patch2, the fixes commit should be add here.
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 35 +++++++++++++++++++++++++++-----
>  1 file changed, 30 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 9bb31f66db85..b92e82a576e3 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1728,9 +1728,20 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  {
>  #ifdef PM8001_USE_MSIX
>         u32 mask;
> -       mask = (u32)(1 << vec);
> +       u32 vec_u;
>
> -       pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
> +       if (vec < 32) {
> +               mask = (u32)(1 << vec);
> +               /*vectors 0 - 31*/
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR,
> +                           (u32)(mask & 0xFFFFFFFF));
> +       } else {
> +               vec_u = vec - 32;
> +               mask = (u32)(1 << vec_u);
> +               /*vectors 32 - 63*/
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
> +                           (u32)(mask & 0xFFFFFFFF));
> +       }
>         return;
>  #endif
>         pm80xx_chip_intx_interrupt_enable(pm8001_ha);
> @@ -1747,11 +1758,25 @@ pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  {
>  #ifdef PM8001_USE_MSIX
>         u32 mask;
> -       if (vec == 0xFF)
> +       u32 vec_u;
> +
> +       if (vec == 0xFF) {
>                 mask = 0xFFFFFFFF;
> -       else
> +               /* disable all vectors 0-31, 32-63*/
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, mask);
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, mask);
> +       } else if (vec < 32) {
>                 mask = (u32)(1 << vec);
> -       pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
> +               /*vectors 0 - 31*/
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR,
> +                           (u32)(mask & 0xFFFFFFFF));
> +       } else {
> +               vec_u = vec - 32;
> +               mask = (u32)(1 << vec_u);
> +               /*vectors 32 - 63*/
> +               pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
> +                           (u32)(mask & 0xFFFFFFFF));
> +       }
>         return;
>  #endif
>         pm80xx_chip_intx_interrupt_disable(pm8001_ha);
> --
> 2.31.1
>
