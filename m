Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E84C77B6F
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Apr 2023 13:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjDGNsD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Apr 2023 09:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjDGNrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2023 09:47:47 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58E8D317
        for <linux-scsi@vger.kernel.org>; Fri,  7 Apr 2023 06:46:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-946a769ae5cso166601266b.1
        for <linux-scsi@vger.kernel.org>; Fri, 07 Apr 2023 06:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680875150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yp5m0Gs2+7L1T7k0BOgEaesPaUmP03C3lD6UUC3EEfI=;
        b=Q8cKW1Y9yPr2fpOL+h62V4+4LKKzKurXsFkFP8HTS2ZsTk9QbnScMQLueaGMd7uxZX
         YyGeO6gYuhxM6rR/qSd0ky8WzO4rKTu9/9GfMP+ymDyx4DYYHEsSR7+F6n0q1DbLETJQ
         Jt2ABT8Dw/7A33eJt7UZSOdw35bxMH1hYkzCVFewZ53L5myO44Ju9OrNH6hfYM9UUF+T
         9m+/zQXxoXAPESyq24BEBOh2tjmnLglWDM1YkGWRwmpjFRRYMMY1GV28mQHARPO8UTTw
         bVg9Pf+cquhScTcOKyWUSiuTVy1i16oake/nYxX+a2qGw7/ytbvucNpn0uvrZMJT6jat
         xczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yp5m0Gs2+7L1T7k0BOgEaesPaUmP03C3lD6UUC3EEfI=;
        b=2JYb2PqX90hFhqvy51B+0nYfRetol6dldH/LKi4FyaN8T1RFauLQjWZNCONPyeOilL
         To0WNq7Q3nZOyawGHmwwPuCLC5r4HZgMbAvO57kYUuew7eJz2p0Uz8EtCSjzPsEkKcox
         gW9V9so/LiTfOJeHi+UnGo3JBxp7/4tK/uYPGSuuhns21/n/tgZM9U9Uw4ZPy4HxflLK
         DwpmvGoeWeDyRfDqqwSz4n2Sy6IBbiq0u6rH7l08/PT9Z7lMu1jpeBzB+WF1kdoIt8lV
         qIyE6xpRlKJBWQfJBGmdxYvpDfQoeZaKtLuST9IeGbLQRY1Qc4twIuiXiNL/t6Cp4NIw
         NrQA==
X-Gm-Message-State: AAQBX9fOU5eAfGmz97HKsEdA8e+/7D/lqM+6N2h+4A+qvVZsJkr/qEmH
        AeP/WzR35TW2o2v7Utpm8qDFOA==
X-Google-Smtp-Source: AKy350YfI24zrr3k/owoorldtK4j2Zc1yFlw5O+l6gy+yzp0dsAPQIPRc+pCkj0U+Y3iqphLdUBj2g==
X-Received: by 2002:a50:fb85:0:b0:502:3376:786d with SMTP id e5-20020a50fb85000000b005023376786dmr1810673edq.6.1680875150253;
        Fri, 07 Apr 2023 06:45:50 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:b20f:8824:c926:8299? ([2a02:810d:15c0:828:b20f:8824:c926:8299])
        by smtp.gmail.com with ESMTPSA id v7-20020a50a447000000b00504832f2489sm47159edb.78.2023.04.07.06.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 06:45:48 -0700 (PDT)
Message-ID: <9a4aa196-3110-9c62-6e30-a8bfa2a9327c@linaro.org>
Date:   Fri, 7 Apr 2023 15:45:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 2/6] dt-bindings: ufs: qcom: Add ICE phandle
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
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20230407105029.2274111-1-abel.vesa@linaro.org>
 <20230407105029.2274111-3-abel.vesa@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230407105029.2274111-3-abel.vesa@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/04/2023 12:50, Abel Vesa wrote:
> Starting with SM8550, the ICE will have its own devicetree node
> so add the qcom,ice property to reference it.
> 
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> ---
> 
> The v5 is here:
> https://lore.kernel.org/all/20230403200530.2103099-3-abel.vesa@linaro.org/
> 
> Changes since v5:
>  * dropped the sm8550 specific subschema and replaced it with one that
>    mutually excludes the qcom,ice vs both the ICE specific reg range
>    and the ICE clock
> 
> Changes since v4:
>  * Added check for sm8550 compatible w.r.t. qcom,ice in order to enforce
>    it while making sure none of the other platforms are allowed to use it
> 
> Changes since v3:
>  * dropped the "and drop core clock" part from subject line
> 
> Changes since v2:
>  * dropped all changes except the qcom,ice property
> 
> 
>  .../devicetree/bindings/ufs/qcom,ufs.yaml     | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index c5a06c048389..71aa79eac6b4 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -70,6 +70,10 @@ properties:
>    power-domains:
>      maxItems: 1
>  
> +  qcom,ice:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: phandle to the Inline Crypto Engine node
> +
>    reg:
>      minItems: 1
>      maxItems: 2
> @@ -187,6 +191,28 @@ allOf:
>  
>      # TODO: define clock bindings for qcom,msm8994-ufshc
>  
> +  - if:
> +      properties:
> +        qcom,ice:
> +          minItems: 1

Drop minItems

> +          maxItems: 1
> +    then:
> +      properties:
> +        reg:
> +          minItems: 1

Drop minItems

> +          maxItems: 1
> +        clocks:
> +          minItems: 8
> +          maxItems: 8
Best regards,
Krzysztof

