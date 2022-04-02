Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7389CC433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 09:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353940AbiDBJLc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 05:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbiDBJLb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 05:11:31 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E85532D5
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 02:09:40 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ot30so490080ejb.12
        for <linux-scsi@vger.kernel.org>; Sat, 02 Apr 2022 02:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=kd0NXB1Zpr99nwzhwykwjlZXPnel4cWxpQfKUpkCMHk=;
        b=IPrXv9vJtuIqqczOLMSmbtbpxKLQMRqoHRQqRTjVRFt4XO+cn+jGv3A0ddYp/tq7gY
         Zg7teYhVeEfjJ8csVKtGys1Y6/lrBvrxsdVaGEio7GpsGA26NvKIok57F6Ww8nbIHQye
         rXmxl63yx1oW+DKpT22urlehfD/nbAMpo9LvOn1G6icNPf2NIzuPi1KPPEaHk5bXYQ2L
         yfj9ZgvUPumDQ7S7kDptsISup59+tDCEC99Hw/VHbN6fEhZp+NoZ6CIxy1fjYa9XekPR
         serYvl4TidGxyJu9quyVUhjNX3aQyNJjetX9Z2KkDWVzjwvoeVb0n+VdPnbOPkm+mK4A
         0aQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kd0NXB1Zpr99nwzhwykwjlZXPnel4cWxpQfKUpkCMHk=;
        b=POHQkG/SrZ2te5V00xGf1ywTGFSLkAdX+/oYns6Q3L64IBDGV27tH6nfApFUHsGQJE
         MeXk7ryPx3K8DeotIXi9oHU5V0oFY6ryZxmkvbz1F1zIB5e6BflXP9JcMeRYL5z/plRk
         XmCV8XrB4pL4ourz1UnnWJGgMD8wivr0SW0BXn0SMynTbie7z10VPqUAFwSqU7onuISe
         Qsul1Ajj4jLVJcBbgSh9zMM9C51E/Viepf7RK/2weXNDdhYk1Bw0TN+eAgwgBcq6oepU
         5QKYsAVQwNvmWrgahIIIRXM7DJmTC0//jG0ut9Ql6IiudFscc86m2lO7yrjdeZht3Hr0
         Q9Bg==
X-Gm-Message-State: AOAM533f2RMIgiTbdNJec5A3kibxX4P5nB4mXrhkaeT/YqB4iId4NnsN
        6AmlQf/YD+QC+4HphRG1y8OiYA==
X-Google-Smtp-Source: ABdhPJwqleeVWzZcqz6QlP7/awNnzIZNAP/RE/+/3JTo9Oc/kx/lPCi9SIvYHyQ5AoA0h5pDpTMV4w==
X-Received: by 2002:a17:907:3e16:b0:6df:b4f0:5cc2 with SMTP id hp22-20020a1709073e1600b006dfb4f05cc2mr3180696ejc.285.1648890579004;
        Sat, 02 Apr 2022 02:09:39 -0700 (PDT)
Received: from [192.168.0.170] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id o12-20020a50c90c000000b0041907e62024sm2192677edh.85.2022.04.02.02.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 02:09:38 -0700 (PDT)
Message-ID: <c93bdf12-bf53-9277-0394-5eaeea081183@linaro.org>
Date:   Sat, 2 Apr 2022 11:09:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 1/4] dt-bindings: clock: qcom,gcc-sdm845: add parent
 power domain
Content-Language: en-US
To:     Stephen Boyd <sboyd@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Taniya Das <tdas@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20220401145820.1003826-1-krzysztof.kozlowski@linaro.org>
 <20220401145820.1003826-2-krzysztof.kozlowski@linaro.org>
 <20220401232451.1B7A9C340F3@smtp.kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220401232451.1B7A9C340F3@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/04/2022 01:24, Stephen Boyd wrote:
> Quoting Krzysztof Kozlowski (2022-04-01 07:58:17)
>> Allow Qualcomm GCC to register its parent power domain (e.g. RPMHPD) to
>> properly pass performance state from children.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> ---
>>  Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml
>> index d902f137ab17..5fe1b2c42d5a 100644
>> --- a/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml
>> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml
>> @@ -43,6 +43,9 @@ properties:
>>    '#reset-cells':
>>      const: 1
>>  
>> +  powert-domains:
> 
> s/powert/power/

Thanks. This actually points to the fact I did not test this bindings
change :(

Best regards,
Krzysztof
