Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8817CCA47B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 09:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiF3JzX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 05:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiF3JzW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 05:55:22 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2523242EC4
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 02:55:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so2412356pjm.4
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 02:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u7LUrk2PQT0QuXB1ls6VgilrLt2bHgnHDE3d6QTzFn0=;
        b=c/DcgPgMH8qK2qxUIRsHd9NqftRr5oOqCKgNKsTYK9Ah3ft5fkyKKV4WRq6k/ioEnb
         FDGp4U9eidt4JRmGu66TBiGZELG4YTrTtM0AxUEKNv6seRbXzzmIF7xJw7VYLZbYBa2S
         crLMn6gMWb0pxVvN/I7kTzlOk3azNREd2eiIqUI1Y23twMHRptJwjDGpFApP1+kdXnsR
         rFsmc4gFxhPnYKP9ln61ppIgsi/8qIClZILFDJikmUlT9XroMVDP1vAoOT4/99YZgymY
         7imFj7AYTE6nyfF9DiIm8Erjf4uggZy1hwQT7TRjjiAlIQQ6cYDBsc8nBkDQS1zbU1TN
         8HUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u7LUrk2PQT0QuXB1ls6VgilrLt2bHgnHDE3d6QTzFn0=;
        b=F1hVy9KImNWs116zK+BjMp2qqi/oELskXOO1osI+BZkblIOR+M8lkK8PYwuxQJ18tg
         IO+K67dIhcfy/HylpGCyJ/o4hNqLJiZV1bi0OdVNOACTkP1jYmaBbSBy9P6Aer8huPWO
         yekDVQ/THNu7Ih4QWCnCgFvVfP1CsnTtLctHLdZw5JAAj2FIqb8ugJKNG5u9noO+FCJr
         5DOUK26U+EShuKmLPuPBTlaQ5oJMeMGPRY4gnTKb+yeU3RbafKy0w8X+Xi6CeGH4T94v
         l6aPhzIp3Nfr5wMoYbxVrQYpOcuWKaPs6TZxjq5qj4uGmz42YW1hK3tS+uiFn1LP08q3
         ruCw==
X-Gm-Message-State: AJIora9UKJ0sMe7F2VT0pUMp+4jlE0CPdcUKZhGr4jc1NoMvT75lx9e0
        lqozhjH8KVq+QDOS1F8lw1gn1Q==
X-Google-Smtp-Source: AGRyM1uvH6vnV3smGE+NjUvesmv27eoJ+j0uGzL/Bge/ktMXro/pYdvZBQiFwmnYgfr7zCKmlhbBdg==
X-Received: by 2002:a17:90b:4c4d:b0:1ec:bb28:9819 with SMTP id np13-20020a17090b4c4d00b001ecbb289819mr9106630pjb.140.1656582920705;
        Thu, 30 Jun 2022 02:55:20 -0700 (PDT)
Received: from localhost ([122.172.201.58])
        by smtp.gmail.com with ESMTPSA id f80-20020a623853000000b005252380a87bsm13040768pfa.59.2022.06.30.02.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 02:55:20 -0700 (PDT)
Date:   Thu, 30 Jun 2022 15:25:18 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Taniya Das <tdas@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH v3 2/7] dt-bindings: opp: accept array of frequencies
Message-ID: <20220630095518.zhvocdbupqqkyps7@vireshk-i7>
References: <20220513061347.46480-1-krzysztof.kozlowski@linaro.org>
 <20220513061347.46480-3-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513061347.46480-3-krzysztof.kozlowski@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13-05-22, 08:13, Krzysztof Kozlowski wrote:
> Devices might need to control several clocks when scaling the frequency
> and voltage.  Allow passing array of clock frequencies, similarly to the
> voltages.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Acked-by: Rob Herring <robh@kernel.org>
> 
> ---
> 
> Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  Documentation/devicetree/bindings/opp/opp-v2-base.yaml | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
> index 76c8acd981b3..66d0ec763f0b 100644
> --- a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
> +++ b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
> @@ -50,6 +50,16 @@ patternProperties:
>            property to uniquely identify the OPP nodes exists. Devices like power
>            domains must have another (implementation dependent) property.
>  
> +          Entries for multiple clocks shall be provided in the same field, as
> +          array of frequencies.  The OPP binding doesn't provide any provisions
> +          to relate the values to their clocks or the order in which the clocks
> +          need to be configured and that is left for the implementation
> +          specific binding.
> +        minItems: 1
> +        maxItems: 16
> +        items:
> +          maxItems: 1
> +
>        opp-microvolt:
>          description: |
>            Voltage for the OPP

Applied. Thanks.

-- 
viresh
