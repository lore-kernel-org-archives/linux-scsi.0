Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7681DC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 09:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbiKQJTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 04:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbiKQJTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 04:19:51 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EF6AF0B0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 01:19:50 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id a29so1802663lfj.9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 01:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PQQyKzEK6pbcrPSZDA9nhPPbff1SP+zOVrULy0x9XLY=;
        b=oAwLDzt6TSHz3Ex+qKXTZew/CXvHb2mx+XTWiIoSN0zYj3MasQJgm27lnxUqqkMD8z
         n5C+3Gz3XZ9lowekcTGTzTZxohxtvq7FkQmhP2YhOhUlXlMeXXOom7SvZhhZHcFhrFjG
         OuXgduSDsTU3JcmFNFMr1bcWcV22EiY/4DI7k6qdOMntmfMUcbjsKKOphd5EfZdQmLGB
         MMTmZbXONRPmVUq6C7OiBTYJF9jXfdnLAzxFZevZ72jNBSZFWQ9SwmR90HS5SFw8k+Qi
         GrHpkHYRq9/KiSuVbbOde0+xe0WjBq+NreY81YzxI7Sx6tpVV9Og3D01M+aKeHcJBzjb
         0phw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PQQyKzEK6pbcrPSZDA9nhPPbff1SP+zOVrULy0x9XLY=;
        b=owL5crNLbqNUDTxkD9riwH0RFhbrWYu+uPwWObkeuIxjZFoQQBXsQLBRn07b7eL+/N
         8QoeWtmPxAqPrjp9yaaY1Unt85mvdZUHeqFYjN2e8RYwCuuT793vThKgDwXEClE2GodI
         Ym1f8VzyVAKySJ64UsvpULHcTBvbrCrWlZ6ieFU5aF1cZG1N7RJaqLr0425Xe1ubwurE
         6dhIRS8lb2KuQgnrRZIYZWNbThXJJ3ulTmyU8riiy5ick368VhhcgX+rOrTBKgkt8FSh
         W18uQDFyLPf5rVYvR5FjFkXNIP7T6BZXK6Td4gu/vzJR4L+fjEIQat8o7Pjgmj4KZ8n/
         tkHA==
X-Gm-Message-State: ANoB5pksRavXizV/OOtDWeI6f3TTzB8/fXt1+1DBDA6UFOkDFRqXi4Pm
        dVNKkIHISOWc9YSx9rLGOBrkUg==
X-Google-Smtp-Source: AA0mqf5LZrCAZhUuSRm9lU1fBMgWwi7KDQKZzxhK50xwOs3Umx45mgzr5KEPHagIY+r4527NV83F6w==
X-Received: by 2002:ac2:4558:0:b0:494:6bb2:485f with SMTP id j24-20020ac24558000000b004946bb2485fmr655662lfm.451.1668676788691;
        Thu, 17 Nov 2022 01:19:48 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c26-20020ac2415a000000b0048a8c907fe9sm56977lfi.167.2022.11.17.01.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 01:19:48 -0800 (PST)
Message-ID: <2c9152a3-f113-093a-57a9-27154529f34a@linaro.org>
Date:   Thu, 17 Nov 2022 10:19:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Add document for Unisoc UFS host
 controller
Content-Language: en-US
To:     Zhe Wang <zhewang116@gmail.com>
Cc:     Zhe Wang <zhe.wang1@unisoc.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com, zhang.lyra@gmail.com
References: <20221116133131.6809-1-zhe.wang1@unisoc.com>
 <20221116133131.6809-2-zhe.wang1@unisoc.com>
 <87312b40-548d-dc60-588f-3583e496dcb3@linaro.org>
 <CAJxzgGoebXFxeWa7TXe5yD+xAme=6YxTC-E9emUw2kG2zpH6+A@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAJxzgGoebXFxeWa7TXe5yD+xAme=6YxTC-E9emUw2kG2zpH6+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/11/2022 09:45, Zhe Wang wrote:
> hi Krzysztof
> 
> On Thu, Nov 17, 2022 at 1:11 AM Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> On 16/11/2022 14:31, Zhe Wang wrote:
>>> Add Unisoc ums9620 ufs host controller devicetree document.
>>>
>>> Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
>>
>> Thank you for your patch. There is something to discuss/improve.
>>
>>> +
>>> +  clock-names:
>>> +    items:
>>> +      - const: ufs_eb
>>> +      - const: ufs_cfg_eb
>>> +      - const: ufsh
>>> +      - const: ufsh_source
>>> +
>>> +  resets:
>>> +    maxItems: 2
>>> +
>>> +  reset-names:
>>> +    items:
>>> +      - const: ufs
>>> +      - const: ufsdev
>>
>> Both clock names and resets are still not useful. "ufs" is the name of
>> the block, so reset name of "ufs" and "ufsdev" says nothing. This is the
>> dev right?
>>
> 
> Yes, this means reset on the device side. How about the modification below?
> 
> +  clock-names:
> +    items:
> +      - const: controller_eb
> +      - const: cfg_eb
> +      - const: core
> +      - const: core_source
> +
> +  resets:
> +    maxItems: 2
> +
> +  reset-names:
> +    items:
> +      - const: controller
> +      - const: device

That's very good, thanks.

> 

Best regards,
Krzysztof

