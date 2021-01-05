Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C68C43381
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC1E225AC
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbhAENZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 08:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbhAENZD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 08:25:03 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F55C061795
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jan 2021 05:24:22 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id qw4so41135660ejb.12
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2021 05:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZwQU6OV9SFCgtdZNol+7lbF2J1v9/T9mNJtScwk46oA=;
        b=H7SjHtuXnjgoW1mKZAJ1MhB2FbZ1Vz+IEkA2qoQlE0raieVlzcXm7luKhNf2P0MVB4
         8dp4W67ESH6ViSQXCp6VnqUzh0OJIGLuviN59xz4ef8oRGhcK23qGl1NAvA2HPX1bhQC
         4zvjKvi1F7+F6H8KYOmi21n4UVAFS55U2+JKEic4JTVqZsonDv7wvTx2V1zKyXD4Xo/N
         uiy+D4mCx0Wvb+5fKWPasq+J8EQoOtGhR4j30dDsBr6+ojR0V5rJlOBAITv0rufbwcUM
         BmEGja2WcMwfvd15BLZGdciZn/xy0A2n1cC/FMIy0aWGXwSg2gyeuLH67RheupIMbR7G
         wFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZwQU6OV9SFCgtdZNol+7lbF2J1v9/T9mNJtScwk46oA=;
        b=O/psQrNoh0RwoVAkjXSl/XxIJoRsqImXJXqGj4iHUW4J/M4SpEAN000YtFnG2GD78c
         jP2uxKbPIeMZTIIRcTzF4AfmZEFtqczBjj56zOm8bZlKlRNJx8LZpM76CFN8+P5weExn
         GgwDMis7n1i6NE76O5HytHo9gBBAEl/aKyMo3cC4fVXH1NbSXTv0zHxwpwwCkmsjEul4
         kNcrgBtR36nYT7zuk+2JmEerB57iQjQ+nTlm//n/YmxxZoybdl6GouvDM0aP82EBMTN7
         uOsuOXRgaZfONwTQSwZi/CRen7zz5Sy3NOwIxkj7m8YjFzppQY53a22Yj71scPQ5VAyb
         +mmw==
X-Gm-Message-State: AOAM530SU++Rwa0itKmnP0FZUigtenw2EikZ4BPs4Ccsq6wTR8LqiCz/
        hOy5V3QOokrXmLUJsDobI3+9wleMhT4kOgG5pJMkow==
X-Google-Smtp-Source: ABdhPJxHq72hVcFhw5W8+onte02Ii1pjAAzeU7Om15FguG3db/FsSSAqaMlJ6PW6fSc9C8KNL1LsR1JvFYJ3v7b6MbE=
X-Received: by 2002:a17:906:3101:: with SMTP id 1mr59054303ejx.115.1609853061162;
 Tue, 05 Jan 2021 05:24:21 -0800 (PST)
MIME-Version: 1.0
References: <20201230045743.14694-1-Viswas.G@microchip.com.com> <20201230045743.14694-5-Viswas.G@microchip.com.com>
In-Reply-To: <20201230045743.14694-5-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 5 Jan 2021 14:24:10 +0100
Message-ID: <CAMGffE=jBAXxKj77QZ=jZQY5C_RBnbvgsR+cyRhDD0WBzLcARw@mail.gmail.com>
Subject: Re: [PATCH 4/8] pm80xx: fix missing tag_free in NVMD DATA req
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com,
        yuuzheng@google.com, vishakhavc@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com,
        bjashnani@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 30, 2020 at 5:47 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: akshatzen <akshatzen@google.com>
>
> Tag is not free'd in NVMD get/set data request failure scenario,
> which would have caused tag leak each time the request fails.
>
> Signed-off-by: akshatzen <akshatzen@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thx
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index f147193d67bd..9cd6a654f8b2 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3038,8 +3038,8 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         complete(pm8001_ha->nvmd_completion);
>         pm8001_dbg(pm8001_ha, MSG, "Set nvm data complete!\n");
>         if ((dlen_status & NVMD_STAT) != 0) {
> -               pm8001_dbg(pm8001_ha, FAIL, "Set nvm data error!\n");
> -               return;
> +               pm8001_dbg(pm8001_ha, FAIL, "Set nvm data error %x\n",
> +                               dlen_status);
>         }
>         ccb->task = NULL;
>         ccb->ccb_tag = 0xFFFFFFFF;
> @@ -3062,11 +3062,17 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>
>         pm8001_dbg(pm8001_ha, MSG, "Get nvm data complete!\n");
>         if ((dlen_status & NVMD_STAT) != 0) {
> -               pm8001_dbg(pm8001_ha, FAIL, "Get nvm data error!\n");
> +               pm8001_dbg(pm8001_ha, FAIL, "Get nvm data error %x\n",
> +                               dlen_status);
>                 complete(pm8001_ha->nvmd_completion);
> +               /* We should free tag during failure also, the tag is not being
> +                * free'd by requesting path anywhere.
> +                */
> +               ccb->task = NULL;
> +               ccb->ccb_tag = 0xFFFFFFFF;
> +               pm8001_tag_free(pm8001_ha, tag);
>                 return;
>         }
> -
>         if (ir_tds_bn_dps_das_nvm & IPMode) {
>                 /* indirect mode - IR bit set */
>                 pm8001_dbg(pm8001_ha, MSG, "Get NVMD success, IR=1\n");
> --
> 2.16.3
>
