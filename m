Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0285BC00A89
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 11:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C90320782
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 11:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Z5CEJd6Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgKELDg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 06:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgKELDf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 06:03:35 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C5DC0613CF
        for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2020 03:03:33 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id a15so1085551edy.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2020 03:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gFW34ISbbjpK0fqy3+IQHhn2bPetDdgnarABFbypYiI=;
        b=Z5CEJd6QhvLvzbh7fRz3DA/U0ElntEjFkQWw5fvjLGvV9CI1p2Sa6YfAUvVpn9P4Gi
         9uWFdnLtXNIBEc9RWb/1UIpw+Fmlp3OMQfdMFGPmj5Keih6lNOb1vd0BvM88ih7AsHvU
         JJk5msLtN3jXLhNoJJakFYnSH7+ceoTd+Js8vy3/xViXFDTgRm+w8JD+8DWpS18fJiE4
         bTO/SxW+SpBmu9yDO+s4nXN8UD3eLbtUop/iAgYbGs6Z2jj0tLi5Cq5cSayyi13eLcE9
         F/w6dPgF07WXqfUN2tAwXKqgleYAfWmw3wF9nOPOaUlKiCjRjcS7d3xxV8LbLx5MKFHD
         IDYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gFW34ISbbjpK0fqy3+IQHhn2bPetDdgnarABFbypYiI=;
        b=H86SjLXlXuvt9JeF15MLU3TCAZJoRHukE3MVR3ENB0CDPGvgvGa2yBfgzX8BovFPmP
         9K67jRmdjZDyHSahAIVH6JH4nIt+ETic1EjkOY8PbHJtV16NJ5IbvjEXpRenWThsgcIs
         4TONVzMT1S7QeCm0xnYSx8BYuOGj0ZBI2BU+63mCP/uEbuVQ6Hz6gmw3ERhIXCort/dK
         PYwivLY35WPXsLtgzn3JKuhZZ75fYq5zDJRlXaUhy+L+rrCmpfc/W8nJ+SocDpTrs4HJ
         wgfIOZ0l2P1nKy0VQSWw0u0En/x1+zcqfoDMtTz7W3I7mdZpK5c+TfEzVA3XiZdBVhkw
         5GUg==
X-Gm-Message-State: AOAM53395tNbvInp0fJAYjFyluPizGwLRAi28/yptwhYCxJ/BBx0hXiI
        1g/je7kaGfslARyhFpZZanc2Wy/AATuL4f9QHfYA7g==
X-Google-Smtp-Source: ABdhPJzBNxC68jEW+G0/ZLcSLdw+coy3OUHo0bOzhZJztI1GVuId80D6zKcBl1GOEmWi1+cfSQ8TeKScoK+bM9B2QBM=
X-Received: by 2002:aa7:cb58:: with SMTP id w24mr1894535edt.35.1604574212059;
 Thu, 05 Nov 2020 03:03:32 -0800 (PST)
MIME-Version: 1.0
References: <20201102102544.1018706-1-lee.jones@linaro.org> <20201102102544.1018706-2-lee.jones@linaro.org>
In-Reply-To: <20201102102544.1018706-2-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 5 Nov 2020 12:03:20 +0100
Message-ID: <CAMGffEmqdu1a1uccafufjMxkrJf8O11EmfDNXyThVbQOHkAieA@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: pm8001: pm8001_sas: Fix strncpy() warning when
 space is not left for NUL
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 2, 2020 at 11:25 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> This string is not NUL terminated.
>
> Fixes the following W=3D1 kernel build warning(s):
>
>  from drivers/scsi/pm8001/pm8001_sas.c:41:
>  In function =E2=80=98strncpy=E2=80=99,
>  inlined from =E2=80=98pm8001_issue_ssp_tmf=E2=80=99 at drivers/scsi/pm80=
01/pm8001_sas.c:919:2:
>  include/linux/string.h:297:30: warning: =E2=80=98__builtin_strncpy=E2=80=
=99 specified bound 8 equals destination size [-Wstringop-truncation]
>  297 | #define __underlying_strncpy __builtin_strncpy
>  | ^
>  include/linux/string.h:307:9: note: in expansion of macro =E2=80=98__und=
erlying_strncpy=E2=80=99
>  307 | return __underlying_strncpy(p, q, size);
>  | ^~~~~~~~~~~~~~~~~~~~
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Thanks, Lee!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
> index 9889bab7d31c1..5edfba3c622b4 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -916,7 +916,7 @@ static int pm8001_issue_ssp_tmf(struct domain_device =
*dev,
>         if (!(dev->tproto & SAS_PROTOCOL_SSP))
>                 return TMF_RESP_FUNC_ESUPP;
>
> -       strncpy((u8 *)&ssp_task.LUN, lun, 8);
> +       memcpy((u8 *)&ssp_task.LUN, lun, 8);
>         return pm8001_exec_internal_tmf_task(dev, &ssp_task, sizeof(ssp_t=
ask),
>                 tmf);
>  }
> --
> 2.25.1
>
