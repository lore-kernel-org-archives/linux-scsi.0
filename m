Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5A7C3DA78
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 11:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiLOL6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 06:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiLOL6J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 06:58:09 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF222ED58
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 03:58:07 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 79so3987502pgf.11
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 03:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pZOfOCT1uqUyQOZ3Q6ejDEihZSzQYrZucgCadknyvEo=;
        b=TaTybFJOhH5EPK/eBhO184gTI9rZ6NpPjNfPTGQmv+4pde+ovnS4o3OcSTPB07hU3j
         u8Gyneh47OfOatEVMn3wPktBWSiEx17Hm2qO/9QkhlOpPHF4cESHo62ysUOcZjFY1UgW
         46qjT3Wvo4pE17HeOcATjOBvTJdy3LzoYMors5zHe7mX7B3BLz3LEP6fnNuGiKxaXZZY
         KsH/VLtse+zcMYOJ2Mwrbu4HzaTUx12stdo25n1fyi4kfyjqVV/KGeFtufPgS4e4ZoQu
         94kCq1g/b7CCX8aW/1AaQk1I6DccFrnHOdxDBPOTDmYJi1rAlE3T2tMbtlW2BhxhuP21
         4Zcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZOfOCT1uqUyQOZ3Q6ejDEihZSzQYrZucgCadknyvEo=;
        b=iFlKrEt92c4cqjWmwe4UtzE6XS3HuriIn7GNlSEafSdyZCf5pkDZqWy/doJwHTH/go
         zpqX034AKz+hXDs2RGLkoxhIkKT3/RiSXPP0ef2JiSMG+jGPuxKMJxTK3wr2QiLMPK1G
         NfXpZdiMAB1nC7lEcPQ1iE0LC4EYvkDJzxkPVSmtMr8HXDv0rMKJLiqVDL1qqNBQO/+V
         /zniMl+GBw6IyG5rWCArCU9XYAfTQ/7Bza2ZCTIKCCfHqD/d4Y/gyBFPzibuPRRqtR/o
         OPVrDZQUoBwXlD5hnaLy+yCAI0JULtYQco995x5HNHumZv0vYqX6e/NYyddrr2ez/V60
         gFEw==
X-Gm-Message-State: ANoB5pkE6hnExpKpC2jtIJo69GemHEJzayHBuKvc1p9V2u14vUmsRzUb
        tNAmaAqn4x3KPdM1iEKrpOm4jQ==
X-Google-Smtp-Source: AA0mqf6zAOBI8FNjjz3fd3sqz5D+xV3IlJL7UUHXxCKfMPTOyHmWW9qt9YBU98dbCUcKtQgdAWvb4g==
X-Received: by 2002:a62:e814:0:b0:577:271e:e66f with SMTP id c20-20020a62e814000000b00577271ee66fmr28704053pfi.27.1671105487018;
        Thu, 15 Dec 2022 03:58:07 -0800 (PST)
Received: from ?IPV6:2401:4900:1c5f:4e45:ae49:8018:6d22:e5b4? ([2401:4900:1c5f:4e45:ae49:8018:6d22:e5b4])
        by smtp.gmail.com with ESMTPSA id h66-20020a62de45000000b00576145a9bd0sm1554392pfg.127.2022.12.15.03.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 03:58:06 -0800 (PST)
Message-ID: <1d3d8169-1011-cdfd-f9f7-b7828acdc1ac@linaro.org>
Date:   Thu, 15 Dec 2022 17:27:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v5 1/8] dt-bindings: ufs: qcom: Add sm6115 binding
Content-Language: en-US
To:     Iskren Chernev <iskren.chernev@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221030094258.486428-1-iskren.chernev@gmail.com>
 <20221030094258.486428-2-iskren.chernev@gmail.com>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <20221030094258.486428-2-iskren.chernev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 10/30/22 3:12 PM, Iskren Chernev wrote:
> Add SM6115 UFS to DT schema.
> 
> Signed-off-by: Iskren Chernev <iskren.chernev@gmail.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>   .../devicetree/bindings/ufs/qcom,ufs.yaml     | 26 +++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index f2d6298d926c..b517d76215e3 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -28,6 +28,7 @@ properties:
>             - qcom,msm8998-ufshc
>             - qcom,sc8280xp-ufshc
>             - qcom,sdm845-ufshc
> +          - qcom,sm6115-ufshc
>             - qcom,sm6350-ufshc
>             - qcom,sm8150-ufshc
>             - qcom,sm8250-ufshc
> @@ -178,6 +179,31 @@ allOf:
>             minItems: 1
>             maxItems: 1
>   
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sm6115-ufshc
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 8
> +          maxItems: 8
> +        clock-names:
> +          items:
> +            - const: core_clk
> +            - const: bus_aggr_clk
> +            - const: iface_clk
> +            - const: core_clk_unipro
> +            - const: ref_clk
> +            - const: tx_lane0_sync_clk
> +            - const: rx_lane0_sync_clk
> +            - const: ice_core_clk
> +        reg:
> +          minItems: 2
> +          maxItems: 2
> +
>       # TODO: define clock bindings for qcom,msm8994-ufshc
>   
>   unevaluatedProperties: false

Seems this hasn't made way to linux-next yet. Hence we get the following 
error with $ make dtbs_check:

arch/arm64/boot/dts/qcom/sm4250-oneplus-billie2.dtb: ufs@4804000: 
compatible:0: 'qcom,sm6115-ufshc' is not one of ['qcom,msm8994-ufshc', 
'qcom,msm8996-ufshc', 'qcom,msm8998-ufshc', 'qcom,sc8280xp-ufshc', 
'qcom,sdm845-ufshc', 'qcom,sm6350-ufshc', 'qcom,sm8150-ufshc', 
'qcom,sm8250-ufshc', 'qcom,sm8350-ufshc', 'qcom,sm8450-ufshc']
	From schema: Documentation/devicetree/bindings/ufs/qcom,ufs.yaml

arch/arm64/boot/dts/qcom/sm4250-oneplus-billie2.dtb: ufs@4804000: 
Unevaluated properties are not allowed ('compatible' was unexpected)
	From schema: Documentation/devicetree/bindings/ufs/qcom,ufs.yaml

If, it helps to get the review / merge happen:

Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>

@Rob, @Krzysztof: Please help merge this.

Thanks.
