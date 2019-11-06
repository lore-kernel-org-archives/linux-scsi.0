Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8247C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 953A0217F4
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:25:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="VpANlrMt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbfKFKZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 05:25:02 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:32895 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfKFKZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 05:25:02 -0500
Received: by mail-io1-f66.google.com with SMTP id j13so9970852ioe.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 02:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yqc32dgmiK6CE5bA1T06nXklwtMik5Vn1y/CEhyZlI0=;
        b=VpANlrMtvnGf5aIUYk4baudZtFGQIBqC2HYvqB5F5dy85hwr4tsZy5eL6TPnxSHzUN
         r25ez1VOwDX7FrPSUhhjjIv0b9UEmuWxnsXXeq72cZMtCiRNP3cPHCqGLscPEkX6ZBRY
         37SYsdJP/HF7VPyHH7UP8IrbGyuxWOHFmDmm1BEM1/+zoHc+rPTZUKCZeW7u8HU/JUqh
         sn/n7IdNdRgOnu1L7yVfYFWrelusfNBu/0PEKx792lSNpqZN1byF4ja5zAJRwm8WJxoT
         3ukzCw+MB3HMIE1ysPNn69cxWmyBhTxFjCQ3fVXatb2UJYqpj+gagvXUtZ9V28amkz6y
         FI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yqc32dgmiK6CE5bA1T06nXklwtMik5Vn1y/CEhyZlI0=;
        b=iCztYpM+ny4mEMJcock1DLao8uhqLzRO++ujnxxd1Q/i75WlQnpduCvpOz3Il8DHBJ
         HWw+HVqbldNfKRgFaWE6E1sniUpR8sA2k40DN5ge+pu0AsLqmOuYLHEEogQ4gE3HL2wQ
         5XO5VZbnGJFyEc0CvGK+ofSuKcnOoivvjBDl8WWw7iSVjRaAyuFuehNNY9FKYXtjsY3b
         uRS+/WT6AaYqoC4lZbyaMdLq2D2F7GAD0BnkfafQdoPMu+S43UV+SUWzXKw7DJqYlbhR
         PdC60yyZx8oCfutQNnTmf3wEgaNLvkO1hDI8aZBYj5T6z1591EFSHG0NlrsSmucZuYkY
         JEnQ==
X-Gm-Message-State: APjAAAUp+yUWi3gfs7KUMGwDu6glpCtFi3JZarNyUZyEaJ6YivjnE773
        N6PF9J8sWLIuInvpONzIctE7gTIPLfl1loS4+5qErg==
X-Google-Smtp-Source: APXvYqwix3ECAKHjqepQKpOd6Qnl8MRL//0kU7udtKvZOVyROeHX4Ite6PQq5CLm4ny7VriNgpJ+TfJqitHlNr66pKU=
X-Received: by 2002:a02:a90b:: with SMTP id n11mr8830803jam.13.1573035901449;
 Wed, 06 Nov 2019 02:25:01 -0800 (PST)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com> <20191031051241.6762-6-deepak.ukey@microchip.com>
In-Reply-To: <20191031051241.6762-6-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 6 Nov 2019 11:24:50 +0100
Message-ID: <CAMGffEmNJs05_4JW5XVJTyquHNUEVvhwHiRxkKaGtUAz9XjxDg@mail.gmail.com>
Subject: Re: [PATCH 05/12] pm80xx : Increase timeout for pm80xx mpi_uninit_check.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2019 at 6:12 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: ianyar <ianyar@google.com>
>
> The function  mpi_uninit_check takes longer for inbound doorbell
> register to be cleared. Increased the timeout substantially so
> that the driver does not fail to load.
>
> Signed-off-by: ianyar <ianyar@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Looks fine.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
>  drivers/scsi/pm8001/pm80xx_hwi.h | 3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 6057610263c1..9d04e5cfffb4 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -735,9 +735,9 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>         pm8001_cw32(pm8001_ha, 0, MSGU_IBDB_SET, SPCv_MSGU_CFG_TABLE_UPDATE);
>         /* wait until Inbound DoorBell Clear Register toggled */
>         if (IS_SPCV_12G(pm8001_ha->pdev)) {
> -               max_wait_count = 4 * 1000 * 1000;/* 4 sec */
> +               max_wait_count = SPCV_DOORBELL_CLEAR_TIMEOUT;
>         } else {
> -               max_wait_count = 2 * 1000 * 1000;/* 2 sec */
> +               max_wait_count = SPC_DOORBELL_CLEAR_TIMEOUT;
>         }
>         do {
>                 udelay(1);
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index dc9ab7689060..701951a0f715 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -220,6 +220,9 @@
>  #define SAS_DOPNRJT_RTRY_TMO            128
>  #define SAS_COPNRJT_RTRY_TMO            128
>
> +#define SPCV_DOORBELL_CLEAR_TIMEOUT    (30 * 1000 * 1000) /* 30 sec */
> +#define SPC_DOORBELL_CLEAR_TIMEOUT     (15 * 1000 * 1000) /* 15 sec */
> +
>  /*
>    Making ORR bigger than IT NEXUS LOSS which is 2000000us = 2 second.
>    Assuming a bigger value 3 second, 3000000/128 = 23437.5 where 128
> --
> 2.16.3
>
