Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8BAC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 15:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiLIPHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 10:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiLIPGb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 10:06:31 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DE389AC2
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 07:05:53 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id z4so5190980ljq.6
        for <linux-scsi@vger.kernel.org>; Fri, 09 Dec 2022 07:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eb+dzXKfFxLhKYjaGwUiIKvSA18uKRx27pJ/FmHwtEU=;
        b=UaqEE2V7XWYGetw5n3TULGb3MoulZySHOYQ45kKm+9Eji+t1wo6MYUsW1LCCKdPiPY
         Vu266DfbJXMo4NoR0PIPAf0q2mOUQQ0RzXKII/DP5rY/X7uagyLXuOCAZ/LIRCbMWkVD
         KHE0DkBTFDkR9uIFeVYbEl7pJzQazF6EKMmuQyiP9Ktjxd+KxzAKbUj3M8Ha/IIGvVP/
         UqHY/ruIR5qS9yi2gb/bpnCK86jZmpJhHENjwoSGG+GYN4OVQB8kPmFdHoLVIk5xwRNB
         YH1m3qyByyMey0nxj7P+MukceClfttKeE3lSNC9BfGc+JFoXsYmUIrS4/89ZAatwcjmY
         3CMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eb+dzXKfFxLhKYjaGwUiIKvSA18uKRx27pJ/FmHwtEU=;
        b=v3JcU81JjQdNfrKQBMuKsPaamu9VPuJnr/xRIWJxyBuRNWKMb/2u6+vRc51T8G4M7M
         vdMYLOpHvigBaf4aqVqvdauOYienBIxK9BaLXoObDy1cztspw95P3KtjxA/k1/HvstEL
         tbZDejl3wiGw3ldzjTedww/YbpwwOkBs8lTC5TtIvTClHVl/T8JWGkDVnUYNTSQS/vtb
         vd/VWNQhOu2yooXJTzHdUqELFEUprLotKWFT6VcH41Y5YxddYGIk8ZpI0+bgw0n32ybI
         HsJnVJob782nvXwlLIVYvmQF8WX1uvdSiH+en08NfofZvYdO7l2Ne//3hDa83Kc/WIA8
         6oKg==
X-Gm-Message-State: ANoB5pnTywllpV5Tlbq7tQW+YXprDAKKI3x1Ibrp6nAyc7hZNn5oPuX3
        V1IE+Q3a65t2VeiwKzxaMpuPeQ==
X-Google-Smtp-Source: AA0mqf7t6HyCvjQbRm6lmUFP6R5mKqPRb4U9dlf9l9mifKdgF30nTCo9XZGo4dm2k9UFBPiA/WTurQ==
X-Received: by 2002:a05:651c:94:b0:27a:7a8:c54b with SMTP id 20-20020a05651c009400b0027a07a8c54bmr1902929ljq.45.1670598351535;
        Fri, 09 Dec 2022 07:05:51 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id r23-20020a2eb617000000b00279cbcfd7dbsm245033ljn.30.2022.12.09.07.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 07:05:50 -0800 (PST)
Message-ID: <24fa41d2-87d1-be19-af44-337784b0f0a4@linaro.org>
Date:   Fri, 9 Dec 2022 16:05:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] dt-bindings: ufs: qcom: Add reg-names property for ICE
Content-Language: en-US
To:     Luca Weiss <luca.weiss@fairphone.com>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221209-dt-binding-ufs-v1-0-8d502f0e18d5@fairphone.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221209-dt-binding-ufs-v1-0-8d502f0e18d5@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 15:29, Luca Weiss wrote:
> The code in ufs-qcom-ice.c needs the ICE reg to be named "ice". Add this
> in the bindings so the existing dts can validate successfully.
> 
> Also sm8450 is using ICE since commit 276ee34a40c1 ("arm64: dts: qcom:
> sm8450: add Inline Crypto Engine registers and clock") so move the
> compatible to the correct if.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
> (no cover subject)
> 
> The only remaining validation issues I see is the following on sc8280xp-crd.dtb
> and sa8540p-ride.dtb:
> 
>   Unevaluated properties are not allowed ('required-opps', 'dma-coherent' were unexpected)
> 
> Maybe someone who knows something about this can handle this?
> 
> And the patch adding qcom,sm6115-ufshc hasn't been applied yet.
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index f2d6298d926c..58a2fb2c83c3 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -102,7 +102,6 @@ allOf:
>                - qcom,sc8280xp-ufshc
>                - qcom,sm8250-ufshc
>                - qcom,sm8350-ufshc
> -              - qcom,sm8450-ufshc
>      then:
>        properties:
>          clocks:
> @@ -130,6 +129,7 @@ allOf:
>                - qcom,sdm845-ufshc
>                - qcom,sm6350-ufshc
>                - qcom,sm8150-ufshc
> +              - qcom,sm8450-ufshc
>      then:
>        properties:
>          clocks:
> @@ -149,6 +149,12 @@ allOf:
>          reg:
>            minItems: 2
>            maxItems: 2
> +        reg-names:

There are no reg-names in top-level, so it's surprising to see its
customized here. It seems no one ever documented that usage...

> +          items:
> +            - const: std
> +            - const: ice
> +      required:
> +        - reg-names
>  
>    - if:
>        properties:
> 
> ---
> base-commit: f925116b24c0c42dc6d5ab5111c55fd7f74e8dc7
> change-id: 20221209-dt-binding-ufs-2d7f64797ff2
> 
> Best regards,

Best regards,
Krzysztof

