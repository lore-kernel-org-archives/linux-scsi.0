Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0C7C6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 10:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjCIK2X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 05:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjCIK17 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 05:27:59 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F999EDB4E
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 02:27:33 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id a25so5148951edb.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 02:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678357652;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Ue1zOWQijm9xPkRtJ+/7K/ZGdSe/BpRmw+d4pMpBfY=;
        b=n4+1uH7MfEukiOD7pfOpj1R5Uu+tPOfpKvc/BTPCePaEXdNexYRS/l8iAYqaS84hrh
         5MqdanC79f7VLI4CvvxQjOyQwKXW0Paov9rsSxcd36sXWNUFdui5DxsR1Kls89hwFJZi
         nXn+WNQMM3iAZPnQMMemLXP19A9Rnhm6jlGKRQGfi7XP0TvwYPb1UszQpRxY5WVgDkMy
         XJB+8RnClaVSVAckiNapewDKJjaZo0PP/z3TZUedmXnZ3DJFRYPDyf6EFCCswtxCQosJ
         V5LhvHm4hCI+9Nbnmf3KayCQBCAphksGgQgYF2h9HMKI29D+ADb3wvDUdz5JD/Xc4cq0
         BuVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678357652;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Ue1zOWQijm9xPkRtJ+/7K/ZGdSe/BpRmw+d4pMpBfY=;
        b=CySU0UNKERfdj/0UpANSJwH7vVwBedcYVsxWoUoenwcwwlDvsHSwQI3wPDQN8WYt04
         eQeS5Oz1EbpRDO9oD0eFFplQv07ubFLH7WRG4kYyar5TeRQ3tu9CIdXVYl1jLE4SP+wT
         L+pnLKo0Ta1aRuMuItjf9Fy7FB39buGNf8ScK3wEBQoqf+gQOR3jK/y8S/e9km/NsW35
         T5sEqk+9tdNu7U2aZN6hXPqCSLLeySngopaV2LZQqYBcx23zrhMciYiyZcQrk7KMVdUg
         Ryau8bcYjATC36Sg4rOZZViwrngoRL0gMQ1vwVdWed6yHu0Tr4IEOpa1xT0twBoovceH
         h6Tg==
X-Gm-Message-State: AO0yUKUXOOxeZ95zguCqe69ds98PNtTsuxzhTq3BOR82Ao3c1JJ2uTG0
        agnw3H3JF+v+axEPIMu33pxIIA==
X-Google-Smtp-Source: AK7set8tW7PnzMeJ+C+RgT1Em5SLgV5Ou1OI1A7f6SIF5krFYdVjXLIAY2SG06B5EK6r15YdHPO98w==
X-Received: by 2002:a17:906:eb4c:b0:8aa:bea6:ce8b with SMTP id mc12-20020a170906eb4c00b008aabea6ce8bmr19801761ejb.53.1678357652007;
        Thu, 09 Mar 2023 02:27:32 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:7ee2:e73e:802e:45c1? ([2a02:810d:15c0:828:7ee2:e73e:802e:45c1])
        by smtp.gmail.com with ESMTPSA id u7-20020a50d507000000b004acc6cbc451sm9409885edi.36.2023.03.09.02.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 02:27:31 -0800 (PST)
Message-ID: <c8eea30f-5ea2-cfc9-273a-3c6e99a316b9@linaro.org>
Date:   Thu, 9 Mar 2023 11:27:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH v2 3/7] dt-bindings: mmc: sdhci-msm: Add ICE phandle
 and drop core clock
Content-Language: en-US
To:     Abel Vesa <abel.vesa@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20230308155838.1094920-1-abel.vesa@linaro.org>
 <20230308155838.1094920-4-abel.vesa@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230308155838.1094920-4-abel.vesa@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/03/2023 16:58, Abel Vesa wrote:
> The ICE will have its own devicetree node, so drop the ICE core clock
> and add the qcom,ice property instead.
> 
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> ---
> 
> This patch was not part of the v1.
> 
>  Documentation/devicetree/bindings/mmc/sdhci-msm.yaml | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
> index 64df6919abaf..92f6316c423f 100644
> --- a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
> +++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
> @@ -80,7 +80,6 @@ properties:
>        - const: iface
>        - const: core
>        - const: xo
> -      - const: ice

Same as for UFS - order is fixed, you cannot drop entries from the middle.

>        - const: bus
>        - const: cal
>        - const: sleep
> @@ -120,6 +119,10 @@ properties:


Best regards,
Krzysztof

