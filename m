Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB61C3F2CF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 06:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A40112469C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 06:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MGFfkxsi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgB1Gqj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 01:46:39 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:40019 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgB1Gqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Feb 2020 01:46:38 -0500
Received: by mail-ua1-f65.google.com with SMTP id t20so602568uao.7
        for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2020 22:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sPJ2OvRxOCmEPKIxeEp6m+UO5YYbHEl1NGnXOdz3GOc=;
        b=MGFfkxsit/DPkZmPZOjFO6NBpVO57ycjoKQUSv7jQj14fcYOkrwzJha//tF5sJe2SV
         rF6/JutXvVt2AOglHZVx9Ai2EwW+iLiXVM732Q9nhPogw+H9zadQ4AIx3HXzrnYnYyCG
         GeT5N73h22uMiC9bkUxDGXcYQ1cLePWqdGJLaP7LKHsyT7ze61fSD0SKDxuQhR8E4RnX
         /RSJFJS1e91CvXGgeZORmjefHV7XvbOV+8hdgirz7uSZ0s2nH9AVFE8iBNRaouL0bthe
         Y5bIxyTZbHjwwgE+Tc+hOireM9WHpfbKxx+oh9YKw6gQSUvlA2Pf7Ou/l2YSMIR0P8l/
         ZKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sPJ2OvRxOCmEPKIxeEp6m+UO5YYbHEl1NGnXOdz3GOc=;
        b=sAQRLkGDVPfRlq6x5dYRwaleAUicDhfj3zJdOkviq94P+vmjQUgNaCKjKRefQUfC/f
         6cfs2pUYMDWT4fmtSpfzymvf3ELocVe8rKjNliXQB5p08cLwzYG2ib36a89QfE9+N4xz
         yXivW0df3ivc7X5MU20PUVDzJyxHhmjzcAkmpjRxsz6ykJF786cwP0LlLbu5XEYxTeVN
         sOPeFOo2af/hT1O5y1DgV4u+c58dkHdirP1NCDnBnQsumb/SNhgien1IGiygfa6BIdcc
         yvmI2X8l2wtI0efXx2pKbsUxk80iTRRJ6C5WgTHE8ilJXk3l0UFKIF/bN025YjaEeggT
         qqwQ==
X-Gm-Message-State: ANhLgQ1wvo6RTtboJY5YXRZx/bUyV5/WtO9KGhHSBdM4XCLuKBJlTqNT
        xESdXB8//wz2pXQZO+lWQKQe8kPd6PfObv6elmyCdAeB
X-Google-Smtp-Source: ADFU+vvpOsoBDpUk5r/gx8ycA0CjgosW3O8Yiua7BRgqnWzXr4ld+qyf42jXy3BVL1pBAmWF2tn0rIv6kueQhwavvmg=
X-Received: by 2002:a9f:3046:: with SMTP id i6mr1323024uab.15.1582872397671;
 Thu, 27 Feb 2020 22:46:37 -0800 (PST)
MIME-Version: 1.0
References: <cover.1582839544.git.nguyenb@codeaurora.org> <b328b981a785525b8424b4ab2197dc1ec54417d1.1582839544.git.nguyenb@codeaurora.org>
In-Reply-To: <b328b981a785525b8424b4ab2197dc1ec54417d1.1582839544.git.nguyenb@codeaurora.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 28 Feb 2020 07:46:01 +0100
Message-ID: <CAPDyKFrGmXj8HWNz2irUd7i8Cb77U8rLM=V91vcrWE+r7Pqeyg@mail.gmail.com>
Subject: Re: [<PATCH v1> 1/4] mmc: core: Add check for NULL pointer access
To:     "Bao D. Nguyen" <nguyenb@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>, cang@codeaurora.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 27 Feb 2020 at 23:06, Bao D. Nguyen <nguyenb@codeaurora.org> wrote:
>
> If the SD card is removed, the mmc_card pointer can be set to NULL
> by the mmc_sd_remove() function. Check mmc_card pointer to avoid NULL
> pointer access.
>
> Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/mmc/core/bus.c  | 5 +++++
>  drivers/mmc/core/core.c | 3 +++
>  2 files changed, 8 insertions(+)
>
> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
> index 74de3f2..4558f51 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -131,6 +131,11 @@ static void mmc_bus_shutdown(struct device *dev)
>         struct mmc_host *host = card->host;
>         int ret;

This obviously doesn't solve anything as we have already dereferenced
the card->host above. In other words we should hit a NULL pointer
dereference bug then.

More exactly, how do you trigger this problem?

>
> +       if (!card) {
> +               dev_dbg(dev, "%s: %s: card is NULL\n", dev_name(dev), __func__);
> +               return;
> +       }
> +
>         if (dev->driver && drv->shutdown)
>                 drv->shutdown(card);
>

[...]

Kind regards
Uffe
