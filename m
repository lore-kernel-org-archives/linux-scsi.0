Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C09FC56201
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 07:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4800221E2
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 07:35:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="XZeBPFXC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJ3Hfg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 03:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3Hfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 03:35:36 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75962C0613CF
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2020 00:35:34 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id v4so5642352edi.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2020 00:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jnsvAxOH3Sr03uSu7rxaJmFqGXC3ktZx4qFLIjIHHq8=;
        b=XZeBPFXCzCs6nawu090Wro/9VjzDQmN5o+yQNiSXqkJFctxn7s1TVA3Cj9xR2NB2N8
         9ZZKpNhr0WdS4aXrxrsNuitBc0NNQzhqSABnICZCcZU2SoBMWfj1iteDzezyEwb7iefX
         jHlhzbFhVHF8DSieiuEwfejGhStgkGgYjJv6Vqfcp7LXotEesiapnwKPC6xJk3f6Hg88
         Hsy2oRteVmcTreFxVaDIvOTEaRYeQnprQ6lNap9wt9xThWBzvYWIwEZ1DTJF78hRsWQJ
         jAYzjcQgv9UZ7UNngF0iv1owNPpe7V/tkFMusanS1UNNtOvWh9yZz/QjrUyTnE+YqyGm
         XOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jnsvAxOH3Sr03uSu7rxaJmFqGXC3ktZx4qFLIjIHHq8=;
        b=ARl8KZhWweUbLU5jwKMnp1Q57WNJW7OyrtLGP7bTQTTUwBgEQdDc06CjIwu2YjPEAw
         wJwr+nTE9252ulsAcrtKh+go1oHTUSjN2X1Ve+5nLt4wyUV4KrlYjJIOg7HCkgC+ZMlA
         SC9sHCBzGn3yx25Kv6hmBUHwe+eGzatWKRxSi/AXzVhHjSHFIdVi1QIffeezgv1yO75E
         6nack/Um36E53VemM0dsHl3oOOKjqJuZgAP7nIMKg9rm36TsDTxE8IwZdScMVkgo4dUj
         1hXNyyJBGHKsV8m4oRyvIwvix3Mgq8acFd+FZG9fpOWca9BRCdvgXEx6wjTpn7gU+34E
         CDZA==
X-Gm-Message-State: AOAM5338Xe9WEUQcV4TDIMYJHBmoFiDydformX0tymBshdoJ/wIn1TiX
        6vfBi+IJwQHj7trsjfej0JJ8nAlqp3u0Vjq9228LrA==
X-Google-Smtp-Source: ABdhPJz7sb1+Qj6AoHKZPk8hrxW8jQbSuBUFgphGDbLUL1m9Ie4FihopyLHOJ7HMZLARBnE7tPrDGrzMSFf3vDv5Jqs=
X-Received: by 2002:aa7:cb58:: with SMTP id w24mr893010edt.35.1604043333192;
 Fri, 30 Oct 2020 00:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201030060913.14886-1-Viswas.G@microchip.com.com> <20201030060913.14886-4-Viswas.G@microchip.com.com>
In-Reply-To: <20201030060913.14886-4-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 30 Oct 2020 08:35:22 +0100
Message-ID: <CAMGffE=ABnjJgpC3jkvet7zk7jE_7EzZQ8FcwPYXbLsbfSoT4w@mail.gmail.com>
Subject: Re: [PATCH V2 3/4] pm80xx: Avoid busywait in FW ready check
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, vishakhavc@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 30, 2020 at 6:59 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: akshatzen <akshatzen@google.com>
>
> Today in function check_fw_ready we do busy wait using udelay. Due to
> which CPU is not released and we see CPU need_resched failures.
>
> Here busy waiting is not necessary since we are in process context and
> we should sleep instead. So to avoid busy waiting we are replacing
> udelay with msleep of 20 ms intervals to check for FW to become ready.
>
> It's verified that check_fw_ready today is not being used in interrupt
> context anywhere, hence it is safe to make this change.
>
> Tested:
> Installed the kernel and looked at dmesg for failures pertaining to
> need_resched and did not find them.
>
> Signed-off-by: akshatzen <akshatzen@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 21 +++++++++++----------
>  drivers/scsi/pm8001/pm80xx_hwi.h |  6 ++++++
>  2 files changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 1ba93fb76093..24a4f6b9e79d 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1042,6 +1042,7 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>
>  /**
>   * check_fw_ready - The LLDD check if the FW is ready, if not, return error.
> + * This function sleeps hence it must not be used in atomic context.
>   * @pm8001_ha: our hba card information
>   */
>  static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
> @@ -1052,16 +1053,16 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
>         int ret = 0;
>
>         /* reset / PCIe ready */
> -       max_wait_time = max_wait_count = 100 * 1000;    /* 100 milli sec */
> +       max_wait_time = max_wait_count = 5;     /* 100 milli sec */
>         do {
> -               udelay(1);
> +               msleep(FW_READY_INTERVAL);
>                 value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
>         } while ((value == 0xFFFFFFFF) && (--max_wait_count));
>
>         /* check ila status */
> -       max_wait_time = max_wait_count = 1000 * 1000;   /* 1000 milli sec */
> +       max_wait_time = max_wait_count = 50;    /* 1000 milli sec */
>         do {
> -               udelay(1);
> +               msleep(FW_READY_INTERVAL);
>                 value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
>         } while (((value & SCRATCH_PAD_ILA_READY) !=
>                         SCRATCH_PAD_ILA_READY) && (--max_wait_count));
> @@ -1074,9 +1075,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
>         }
>
>         /* check RAAE status */
> -       max_wait_time = max_wait_count = 1800 * 1000;   /* 1800 milli sec */
> +       max_wait_time = max_wait_count = 90;    /* 1800 milli sec */
>         do {
> -               udelay(1);
> +               msleep(FW_READY_INTERVAL);
>                 value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
>         } while (((value & SCRATCH_PAD_RAAE_READY) !=
>                                 SCRATCH_PAD_RAAE_READY) && (--max_wait_count));
> @@ -1089,9 +1090,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
>         }
>
>         /* check iop0 status */
> -       max_wait_time = max_wait_count = 600 * 1000;    /* 600 milli sec */
> +       max_wait_time = max_wait_count = 30;    /* 600 milli sec */
>         do {
> -               udelay(1);
> +               msleep(FW_READY_INTERVAL);
>                 value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
>         } while (((value & SCRATCH_PAD_IOP0_READY) != SCRATCH_PAD_IOP0_READY) &&
>                         (--max_wait_count));
> @@ -1107,9 +1108,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
>         if ((pm8001_ha->chip_id != chip_8008) &&
>                         (pm8001_ha->chip_id != chip_8009)) {
>                 /* 200 milli sec */
> -               max_wait_time = max_wait_count = 200 * 1000;
> +               max_wait_time = max_wait_count = 10;
>                 do {
> -                       udelay(1);
> +                       msleep(FW_READY_INTERVAL);
>                         value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
>                 } while (((value & SCRATCH_PAD_IOP1_READY) !=
>                                 SCRATCH_PAD_IOP1_READY) && (--max_wait_count));
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index 701951a0f715..ec48bc276de6 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -1639,3 +1639,9 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
>
>  #define MEMBASE_II_SHIFT_REGISTER       0x1010
>  #endif
> +
> +/**
> + * As we know sleep (1~20) ms may result in sleep longer than ~20 ms, hence we
> + * choose 20 ms interval.
> + */
> +#define FW_READY_INTERVAL      20
> --
> 2.16.3
>
