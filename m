Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C190C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74DC964F20
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbhCDJiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbhCDJiA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:38:00 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1315C061574
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:37:19 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id d13so28852522edp.4
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MabAc3TbpzgKo8TjHCBXZLA8ucP54UZivVwP+Kf+Jrk=;
        b=ciDxc2YuYY8YVMkjOOxhH1tehOFNnRutE3l0o8ObLRN4KeGz/zu7fYyGJWN/0wb65/
         qbXKihy2HrWMRln7tYIhb/VkiphZ4dV0L5TldNQ2eZMd8IWnjRkGwXBsd4qXmSyJWzB5
         iS1SogrGss3LdtXNy9evWNnSxvgWezz3mYfkY28Di2CcZQkDLZLCUqvQgLlN+d0q80Lj
         eXmTy6dg8yk/FfyD8CAGGEIGDwtIPRdlpWW/ILOWHIEs16i5IFqzHyJGr2XfEE7vaXzp
         SnPwfV795GTPm8OXsy9/fA4QsAbuKo/4mQZeyRzmDEYS+2EHIaLWnOIkWcY78DjCWpyS
         ajfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MabAc3TbpzgKo8TjHCBXZLA8ucP54UZivVwP+Kf+Jrk=;
        b=H+zTUTw2bgoN8YDdqn8gbTM7/T06w7ejQ9xQkVjn8Rs1ZyNj7+30GYG+OorYfCmwWR
         WPw1Z7RAbGd3E/DczBAOCrL473ZSsb8ieJNC7Ye+lb7O7MlSdAyuBYqR+8+S5xb5yDJC
         nvYFP4jik8DANw5POtAA3e54s88nsnADQondVzq0xPsWf/U7f5RJX83Fz8NarOo0o0QE
         0TaBzEJYOmRs/LXOZWLt7d3Fw+FTaI0BU/kRzTGLVzROrW5F5Y5Z+hiGIWkhBYoe8CBI
         HrFmSH+eaArKJRqJSCo+F0juUhM0fRE84pS9BHt8VPSQu+jD5kEBH8KdSEBaPvzztgNl
         hEPg==
X-Gm-Message-State: AOAM530PYR7w/krzpS0bzFY3zghaOckpZhyj8x8yuA2YFrQoZAKIFj7L
        rT/S2GJTM/752uTWWAu6XOrcM1KrizIVhJkqXcxp9Q==
X-Google-Smtp-Source: ABdhPJx5fiJfSiU9d39nKxbvyBFzT1KgRLN+7/NYMO5fIcE0LmBRRTNwB0SoB3PTCy+HI+dyAEtrh+nzDjHRaobQFKM=
X-Received: by 2002:a05:6402:46:: with SMTP id f6mr3359107edu.252.1614850638690;
 Thu, 04 Mar 2021 01:37:18 -0800 (PST)
MIME-Version: 1.0
References: <20210224155802.13292-1-Viswas.G@microchip.com> <20210224155802.13292-7-Viswas.G@microchip.com>
In-Reply-To: <20210224155802.13292-7-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:37:08 +0100
Message-ID: <CAMGffEnmGcP9C3swBDugRAchzwdhrEt0QUz9m96d3SkVLQXR6g@mail.gmail.com>
Subject: Re: [PATCH 6/7] pm80xx: Reset PI and CI memory during re-initialize
To:     Viswas G <Viswas.G@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar.devadi@microchip.com,
        Vishakha Channapattan <vishakhavc@google.com>,
        Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 24, 2021 at 4:48 PM Viswas G <Viswas.G@microchip.com> wrote:
>
> Producer index(PI) outbound queue and consumer index(CI)
> for Outbound queue are in DMA memory. These values should
> be reset to 0 during driver reinitialization.

Why "reinitialization", the function  init_default_table_values is
called from chip init?
>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 2 ++
>  drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 4e0ce044ac69..783149b8b127 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -240,6 +240,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>                         pm8001_ha->memoryMap.region[ci_offset + i].phys_addr_lo;
>                 pm8001_ha->inbnd_q_tbl[i].ci_virt               =
>                         pm8001_ha->memoryMap.region[ci_offset + i].virt_ptr;
> +               pm8001_write_32(pm8001_ha->inbnd_q_tbl[i].ci_virt, 0, 0);
>                 offsetib = i * 0x20;
>                 pm8001_ha->inbnd_q_tbl[i].pi_pci_bar            =
>                         get_pci_bar_index(pm8001_mr32(addressib,
> @@ -268,6 +269,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>                         0 | (10 << 16) | (i << 24);
>                 pm8001_ha->outbnd_q_tbl[i].pi_virt              =
>                         pm8001_ha->memoryMap.region[pi_offset + i].virt_ptr;
> +               pm8001_write_32(pm8001_ha->outbnd_q_tbl[i].pi_virt, 0, 0);
>                 offsetob = i * 0x24;
>                 pm8001_ha->outbnd_q_tbl[i].ci_pci_bar           =
>                         get_pci_bar_index(pm8001_mr32(addressob,
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 1aa3a499c85a..0f2c57e054ac 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -787,6 +787,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>                         pm8001_ha->memoryMap.region[ci_offset + i].phys_addr_lo;
>                 pm8001_ha->inbnd_q_tbl[i].ci_virt               =
>                         pm8001_ha->memoryMap.region[ci_offset + i].virt_ptr;
> +               pm8001_write_32(pm8001_ha->inbnd_q_tbl[i].ci_virt, 0, 0);
>                 offsetib = i * 0x20;
>                 pm8001_ha->inbnd_q_tbl[i].pi_pci_bar            =
>                         get_pci_bar_index(pm8001_mr32(addressib,
> @@ -820,6 +821,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>                 pm8001_ha->outbnd_q_tbl[i].interrup_vec_cnt_delay = (i << 24);
>                 pm8001_ha->outbnd_q_tbl[i].pi_virt              =
>                         pm8001_ha->memoryMap.region[pi_offset + i].virt_ptr;
> +               pm8001_write_32(pm8001_ha->outbnd_q_tbl[i].pi_virt, 0, 0);
>                 offsetob = i * 0x24;
>                 pm8001_ha->outbnd_q_tbl[i].ci_pci_bar           =
>                         get_pci_bar_index(pm8001_mr32(addressob,
> --
> 2.16.3
>
