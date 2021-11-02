Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF168C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 967E060F56
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhKBHHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 03:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhKBHHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 03:07:21 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C02C061714
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 00:04:47 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j21so49573242edt.11
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 00:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1gKULX42gh4AgQYBnVofLsoMPKRW06pmlpZ9uawfQk=;
        b=AHJ0CwlEOPZthNaJ+srO/Mp3r/6HGjLP/vgqBRgUTgZ0jES4LRZrikDX9U9MKwLUsN
         8IEP8R+IfkOwmDQ6hktLh0dZjMBCiY8z5S62GmIQwtfVKMbbJ5YGySgtPhWbKVGbsZxV
         ZWdSoY8vnSJmZJpPfzddFBP0Vw9B2xhx+55X188NDA+1QJpste5gviBTA2uy6KzupZ9+
         iDGRfU4PB7j6liXnFi59zjVr3zURuS1jd6KrqB9i6tZZwi4eMdWWOZQfhuOgeRSWQTPS
         TSQVmm12POo4N2jRnNhuFbVK4Hs7UFyJ9Z3P5WTnemJqFMqco9oI6BUxUGIRpm8Llu6C
         +mzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1gKULX42gh4AgQYBnVofLsoMPKRW06pmlpZ9uawfQk=;
        b=WpSiRTTlQFuFpWA1J5sqjnNuhleDOsMr5ERjT9/9r0CkQcXFV2bUT+ixSwyGCjmCIJ
         Pazvw8BT/bbgYhuBz0Tuxlgb3g7WoC+UFIeG0TjiAFvqE+h9mgAOlWQU+Ae3+7WW80eJ
         ltGBZOm8tTJtyXPWoB1qw6e9PQWMHFq8+sNoPv5SofeX4DXmg5zeiAxU0hN8Qzi2G7vD
         WpvL7Dv1pIKdT/ulDrjQS4AiOHybqs0/v/ao8k8rIoaRXvKcsJ4qLQXcrquGfaEVJhF0
         bxyP3mhfFBWnVLv6u1a1bjsKfxnByhJBJu8XQcpRvPFra57Isq0G+9ndxm2qSNWbU0Tu
         3oNw==
X-Gm-Message-State: AOAM53240ZVvk5lstVxa5ZPrXr7X2JMy4aRGrx0FLIvfRxl+BWVnPL4u
        KBAYRKVaOzvGZ4L9vbPVC+2kdqHVnI6jJ+ewmdddcQ==
X-Google-Smtp-Source: ABdhPJykl8P7Cey1k3V0MIovVlvfFLzLvZsjv9Ybni2EvaNeMC6jEVuOwSb5gV4RUpR7l3YUGlBUniY+yf+0L/cJ2WY=
X-Received: by 2002:a17:906:a1da:: with SMTP id bx26mr43498916ejb.558.1635836685621;
 Tue, 02 Nov 2021 00:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211101232825.2350233-1-ipylypiv@google.com> <20211101232825.2350233-2-ipylypiv@google.com>
In-Reply-To: <20211101232825.2350233-2-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 2 Nov 2021 08:04:34 +0100
Message-ID: <CAMGffEkK4QqX93X7VKyqrNTOxtcBfHgSEV_+tjNgDSLxC95cMA@mail.gmail.com>
Subject: Re: [PATCH 1/4] scsi: pm80xx: Apply byte mask for phy id in mpi_phy_start_resp()
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 2, 2021 at 12:28 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> Phy id is located in the least significant byte of the 4-byte field.
> mpi_phy_stop_resp() already applies such mask.
>
> Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 6ffe17b849ae..4f887925c9d2 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3481,7 +3481,7 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         u32 status =
>                 le32_to_cpu(pPayload->status);
>         u32 phy_id =
> -               le32_to_cpu(pPayload->phyid);
> +               le32_to_cpu(pPayload->phyid) & 0xFF;
>         struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
>
>         pm8001_dbg(pm8001_ha, INIT,
> --
> 2.33.1.1089.g2158813163f-goog
>
