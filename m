Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47ADAC77B60
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Apr 2023 19:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjDATZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Apr 2023 15:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDATZU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Apr 2023 15:25:20 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5A12708
        for <linux-scsi@vger.kernel.org>; Sat,  1 Apr 2023 12:25:17 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y4so102600821edo.2
        for <linux-scsi@vger.kernel.org>; Sat, 01 Apr 2023 12:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680377116;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=77FWYvL8qBVi4MJtC3pgtw0jIHuLIUI8wtQ8Jr492jU=;
        b=k1KTXGbkEZ9gAB9ri2VFq9SAsme/0wjVnDetam6LLitGx/1Lqccru62N/ORR3BtrUO
         Ejfjlt8D3aALROwI96uQvQpPNbIbUNB+NKC0GwQIw23ohOf2Ltf2cnpCvwIf4TnvNRqx
         Jqibd0TUuLr7Ur//lGgVrTWirKhdVpcIM5hsJ1fS6NGsQQyu61F2EfojfvRjFAtNpGwK
         salx3C7rjfUISLZvaYQ8UPd1XOJL/YzSeycQ8Og7heIhK7kHVwfp1Z8j9ZWR9KXT96np
         Nvs6T3K6cNzQ3Yv5rcJBr6N4XAsGZWBhnmSpGQH09NND2/frUXA3rxmcmv5qsBpS29uu
         Srww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680377116;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=77FWYvL8qBVi4MJtC3pgtw0jIHuLIUI8wtQ8Jr492jU=;
        b=CXn7daLtxlUguJNaxluthlLeuoXxQsRaL5ugE02sXCY0xAYovM3/OSGXV+eMFzIZXf
         fqanDX2jDZ71Tv/S+3f9iTmrbHLumVpz2FGNFHtWUACDoqb7qPpOPJeuPCu1FCnftU8i
         DwCfPcs9tfXyqybBnnwPw87U0BSykqWaf/5cqr3xIcYpFFG+diUjMe0eHJiDj7AJJXY+
         hDK+NHyeLOeSlKaBQuiqNSepdyyS0mfBPe37VUY4AV+gfbaXSJFJU/TYLrtmdj0COkc/
         3ltZlG1xll2OgzMx85xKTs5cOeWWPUoBcWdErsiy1IZObzr7CdqtJocgSZtJXKJRzDnm
         x35A==
X-Gm-Message-State: AAQBX9e3ZPSCDmnNZAtDouhjoAdE9gZupcl/r869afYVC4kkXJDo/vEx
        9QELNzpabkOYg+Bl3qI7WNSoJg==
X-Google-Smtp-Source: AKy350Y218oME6QsL2EkWtrjn84dOsXVTk1jUQBJaccGJZPDZrKKwrErNagP2pIgjZfI052yGWMdGg==
X-Received: by 2002:aa7:ccce:0:b0:501:cf67:97f3 with SMTP id y14-20020aa7ccce000000b00501cf6797f3mr29074550edt.25.1680377115959;
        Sat, 01 Apr 2023 12:25:15 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:ec00:3acd:519:c7c2? ([2a02:810d:15c0:828:ec00:3acd:519:c7c2])
        by smtp.gmail.com with ESMTPSA id g29-20020a50d0dd000000b004c0239e41d8sm2444639edf.81.2023.04.01.12.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Apr 2023 12:25:15 -0700 (PDT)
Message-ID: <e1b6f8bc-0bbb-f403-9126-22a89e813de8@linaro.org>
Date:   Sat, 1 Apr 2023 21:25:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 2/5] dt-bindings: phy: qmp-ufs: describe the UFS PHY for
 sa8775p
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230331195920.582620-1-brgl@bgdev.pl>
 <20230331195920.582620-3-brgl@bgdev.pl>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230331195920.582620-3-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/03/2023 21:59, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add a new compatible for the QMP UFS PHY found on sa8775p platforms and
> update the clocks property to accommodate three clocks.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        | 34 ++++++++++++++++---
>  1 file changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
> index 64ed331880f6..a414b2c2d9cc 100644
> --- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
> @@ -16,6 +16,7 @@ description:
>  properties:
>    compatible:
>      enum:
> +      - qcom,sa8775p-qmp-ufs-phy
>        - qcom,sc8280xp-qmp-ufs-phy
>        - qcom,sm6125-qmp-ufs-phy
>        - qcom,sm8550-qmp-ufs-phy
> @@ -24,12 +25,12 @@ properties:
>      maxItems: 1
>  
>    clocks:
> -    maxItems: 2
> +    minItems: 2
> +    maxItems: 3
>  
>    clock-names:
> -    items:
> -      - const: ref
> -      - const: ref_aux

Keep it here and add qref. We want to encourage the same clocks
everywhere it is possible. Otherwise people will add soon 'q_ref' or
'ref_q' for their variants as third clock.

> +    minItems: 2

With this.

> +    maxItems: 3

But without this.

>  
>    power-domains:
>      maxItems: 1
> @@ -51,6 +52,31 @@ properties:
>    "#phy-cells":
>      const: 0
>  
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sa8775p-qmp-ufs-phy
> +    then:
> +      properties:
> +        clocks:
> +          maxItems: 3
> +        clock-names:
> +          items:

Instead maxItems: 3


> +            - const: ref
> +            - const: ref_aux
> +            - const: qref
> +    else:
> +      properties:
> +        clocks:
> +          maxItems: 2
> +        clock-names:
> +          items:

Instead maxItems: 2

> +            - const: ref
> +            - const: ref_aux
> +
>  required:
>    - compatible
>    - reg

Best regards,
Krzysztof

