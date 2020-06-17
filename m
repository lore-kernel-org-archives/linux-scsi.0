Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4076C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2BC521527
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:59:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YootRK1o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgFQI7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgFQI7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 04:59:24 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD1EC061573;
        Wed, 17 Jun 2020 01:59:24 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id l10so918275vsr.10;
        Wed, 17 Jun 2020 01:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EYFdMqmIuxR/QD+dIztgN1OBOyAiHVdjdW3clKBfx9w=;
        b=YootRK1o/udIGpVTrSt0b6/K6VzGjZvz3cEm9RpKyz4BswP0wBqUjzOPoH4EOOVwkV
         oF3kdAtTnl80p5ZbZJ/N7DqKYe5Yk5NahvHD+h3uT2mTbIGqQ65VEmghjk0pGeVZ+BaD
         8i5mbNGeC7SdbeaAmjRzRHn1NX6qI0loVq032cnOmJzqQGRvw9T8IUEvt79+Q0B7auKD
         kF5/DwtVLoAPsxey47ySitNdVJVX2lZfo6GZam0zP52oF+ASGmXZ5VPE+IPPMrOkQbE1
         r+9cLNfNbeV9vOqp3Bm7aS0Bmynqc2JCDJszzJv0hSLEaQSe5+l5UwsAg18AO2ycumDh
         /v5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EYFdMqmIuxR/QD+dIztgN1OBOyAiHVdjdW3clKBfx9w=;
        b=L/XsoTGvivTLjGZoQcN+ssRgBzqC6D0EAmE8rpSrMkX9DO3+OCG/caLcee/GVGhKT0
         44ie1569J7LH+0d+kgENKkqt39wuZG4LFKYpyLF/tPxiJDCL1FHPcHrdFfIQLCQOYSF1
         Ei5xYB35cgXmN4pO/dvse8Ri1O+izJA4OnlEopw6mUe7P2SVVPlyYw7vvfa97dm8SdNr
         sQlvUVzpBs4eJ3LPv2+EAjxx61IG5HNma0wFeMTfZo4OF8Waeu6U9mYILtRRjKjqFSSz
         PtoOLJzAfRck7IMCngT0uZJlJ0sX2N5HhCjQwgEi/2c7UUcqS5zCifaIf4USEeuPJ/A/
         tRmQ==
X-Gm-Message-State: AOAM533V4SE4LJQY1MF3cT2wEcairbNYZ84lmI4B0BWUMW1Y8CKTPMOg
        uw42ufsA/oko+iXQdY35KwGMgO+hwz8eGYNF7dA=
X-Google-Smtp-Source: ABdhPJyc1vZfkYuSzIe3xUWojqAeNU1qlFHLUMD47fby93Le5wM33xkoWW/r8PFCmbr5olRG8c6+eESixM28o0UA/NA=
X-Received: by 2002:a67:fb8e:: with SMTP id n14mr4826303vsr.136.1592384363723;
 Wed, 17 Jun 2020 01:59:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200617084911.167359-1-colin.king@canonical.com>
In-Reply-To: <20200617084911.167359-1-colin.king@canonical.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 17 Jun 2020 14:28:48 +0530
Message-ID: <CAGOxZ52KM-DpPPv5qpKZCRoXzEH=YJvcHsNs=3t6rcrB8yX56Q@mail.gmail.com>
Subject: Re: [PATCH][next] scsi: ufs: ufs-exynos: fix spelling mistake
 "pa_granularty" -> "pa_granularity"
To:     Colin King <colin.king@canonical.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seungwon Jeon <essuuj@gmail.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2020 at 2:19 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a dev_warn message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
Thanks Colin,
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs-exynos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index 440f2af83d9c..0a9e99084f2a 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -883,7 +883,7 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
>                 if (attr->pa_granularity < 1 || attr->pa_granularity > 6) {
>                         /* Valid range for granularity: 1 ~ 6 */
>                         dev_warn(hba->dev,
> -                               "%s: pa_granularty %d is invalid, assuming backwards compatibility\n",
> +                               "%s: pa_granularity %d is invalid, assuming backwards compatibility\n",
>                                 __func__,
>                                 attr->pa_granularity);
>                         attr->pa_granularity = 6;
> --
> 2.27.0.rc0
>


-- 
Regards,
Alim
