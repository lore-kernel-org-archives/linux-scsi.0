Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD35C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 09:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245346AbiEaJ4Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 05:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbiEaJ4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 05:56:24 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67DD488A7
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 02:56:22 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l19so7679567ejr.8
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 02:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IjUcMygO4GTAkhw44QoQ4UMULc/veIYWgYx1C+Vi5DI=;
        b=DrO53+KoaAbpjvnulJ4LTgaRPx/eeEbBZXLaOoN2g5+l9BDpVsZsXr/R2ddAmikqpp
         l2GtpHPLgkG7swp63Ht0PeK5wwPj2mg+o+W5LKEizccre+g6h9zzkscRUqJa8hNuWZVJ
         U+GBvers5NHvax767zsSt1O1Vacx7rkQ7znGZXrjB3vuTPa4h5A9VvKkb25f/SvxlklE
         LoQtSII7rAllU0bWi66hlmw+xYOqF1WJRS5pbC/f7/qyGx10Mi4CSKaRUxco5qaZ8r6p
         /F20RUaKv2ZafTD57+WfBP3EA3felTPvkpHjczoHvPNL3HdFAXzm549kjdpUm8cfye9S
         pBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IjUcMygO4GTAkhw44QoQ4UMULc/veIYWgYx1C+Vi5DI=;
        b=SCZgxQ9C0j1DVo/17cfSnTYdXVBKFfTw7KqAN2NZfa2oxCuZFoqAuOY6QTppsV4m6R
         4kTedl9UTkcbzkN+KpRiVGDt/bUeRqGOtd6WN6w4e7nEZtaDXQxEGSi5Y3a2aWPnfDyY
         KbfFqwVvxWYeEbYSUgd7WTvqjA2r3mQyCuMUUrQhgwiqly4QgU1TsI2ChDAfj9WrrUI/
         41JnBtxC7uBdZ3WuWNKZLVKD1XQfnWRexYuw70Q0WfZttkDoFS5neEFWe6uq4u06K/QM
         vrKcz5bGRTxDCpGHv2QkOUt373S+hTiShc8XHcq1TYlPi4IocRnhmowZvrcX1CCYnMVR
         wdXQ==
X-Gm-Message-State: AOAM5308vW6zp563O7RS6i8zHSD97K1bPU00mhex2tVcfc5kY8Fj8VT3
        AxRRa6J5xnA84/06zjs+o6Moqg==
X-Google-Smtp-Source: ABdhPJwByf9S4EVKSk87YILqPFVu3WlNurAiBi0GrfnAmMVvKxUAQqaXetU6Xqd1cWv6fejDbS9ddA==
X-Received: by 2002:a17:906:6bd3:b0:6fe:8c20:f218 with SMTP id t19-20020a1709066bd300b006fe8c20f218mr52262411ejs.32.1653990981278;
        Tue, 31 May 2022 02:56:21 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id ay21-20020a170906d29500b006feba4ef020sm4728945ejb.180.2022.05.31.02.56.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 02:56:20 -0700 (PDT)
Message-ID: <e92618c0-056c-5854-9bb3-5fba90a82d96@linaro.org>
Date:   Tue, 31 May 2022 11:56:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/6] phy: samsung-ufs: move cdr offset to drvdata
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
Cc:     devicetree@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, chanho61.park@samsung.com,
        pankaj.dubey@samsung.com, linux-fsd@tesla.com,
        Bharat Uppal <bharat.uppal@samsung.com>
References: <20220531012220.80563-1-alim.akhtar@samsung.com>
 <CGME20220531012341epcas5p19b15b4916b210687ab6b46d6da0b2273@epcas5p1.samsung.com>
 <20220531012220.80563-3-alim.akhtar@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220531012220.80563-3-alim.akhtar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/05/2022 03:22, Alim Akhtar wrote:
> Move CDR lock offset to drv data so that it can
> be extended for other SoCs which are having CDR
> lock at different register offset.
> 
> Cc: linux-fsd@tesla.com
> Signed-off-by: Bharat Uppal <bharat.uppal@samsung.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/phy/samsung/phy-exynos7-ufs.c      | 3 +++
>  drivers/phy/samsung/phy-exynosautov9-ufs.c | 2 ++
>  drivers/phy/samsung/phy-samsung-ufs.c      | 3 ++-
>  drivers/phy/samsung/phy-samsung-ufs.h      | 2 +-
>  4 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/phy/samsung/phy-exynos7-ufs.c b/drivers/phy/samsung/phy-exynos7-ufs.c
> index 7c9008e163db..d1a37273cb1f 100644
> --- a/drivers/phy/samsung/phy-exynos7-ufs.c
> +++ b/drivers/phy/samsung/phy-exynos7-ufs.c
> @@ -11,6 +11,8 @@
>  #define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK	0x1
>  #define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN	BIT(0)
>  
> +#define PHY_CDR_LOCK_STATUS    0x5e

This should be now renamed to match other defines here, so
EXYNOS7_EMBEDDED_COMBO_PHY_CDR_LOCK_STATUS


Best regards,
Krzysztof
