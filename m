Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813EFC3DA7A
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Dec 2022 11:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiL1L6k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Dec 2022 06:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiL1L6g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2022 06:58:36 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B8A11457
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2022 03:58:33 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id y25so23321389lfa.9
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2022 03:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WnXYH4qLynXgTdL39MoHqXN5EMW38TQiUZiVR1DxEeQ=;
        b=JJVU3PTcvSE3KUUGIfvJBRh97Si8pN9Fapb4MGpR2amkOIBxz5I+yTHUpNOH0RpIgR
         6q8PQ5nwQOCVfGdeY3kZcX9NdSciVOjRc/iCixqoHqERLuNAeu2xCF4CXSiZEIXNU6AQ
         S78hOnlQKQGlpZ4LDmtPmh05YO34NuncA1fB4OHXsFSWmYcKISoOYEQ6kRVzF+ZkZRSG
         AswvNzlIZViD+b7bWrk+ps9a3jD6/MkeJDKR7hIeI7rkJ3yVmioOP3xlSW4rRdJdNIYn
         JA6h2U4GrJBAvpaFbRSYAplAcPsPDcW40+Pk4PsnXiyWYs5zEHiVAZjXwa4GwwgaD0wU
         YC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WnXYH4qLynXgTdL39MoHqXN5EMW38TQiUZiVR1DxEeQ=;
        b=zioAh/lk323MlrrzPifOJzTaRZgkJXXfZFrrRoB//Cm1+ELCIbrT6ELWtgQlfCuKEk
         4pRU7SKZ3qBX9pF/e4nNlFOlM2OioONMFOdXXUF7cHnDXZP3HZ/8vb19u58zaIzGW6O2
         JJeQ/8rBEpmbK53970Y1JVnMVhvNVeMt3m954HELUWp/NnYF/J3l2JE/4/aG2YKsreSv
         psxAilC5smrqYDq7cSB1xKiM7PgW7q4nm8NsOKVfTbtl/m8Q4QhzVQ/oH4xnmF6Ama7n
         ziclWOKfGGs22KMUFOCR4MTu0pocUWrKAvKL6TP43WgQqCb8RJoKngsleF3IXiThH0/V
         CDSg==
X-Gm-Message-State: AFqh2kqP4nI9Sh86f3ZqSvIm4H8MyKEY+Xp2b00PcJdgCaD/6uzLnGKc
        27eXzJOxv395L5aK4Ue+upjBlg==
X-Google-Smtp-Source: AMrXdXt4PV8yq8guZTESHWBuI7Pgb3yXXbymZcLJRNWE/tWew9Yf+0+pOCQKIAX0t7/max5UYbBgZQ==
X-Received: by 2002:ac2:46f8:0:b0:4b5:9ec5:dbed with SMTP id q24-20020ac246f8000000b004b59ec5dbedmr8003412lfo.40.1672228711451;
        Wed, 28 Dec 2022 03:58:31 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id d21-20020ac24c95000000b0049465afdd38sm2637727lfl.108.2022.12.28.03.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 03:58:30 -0800 (PST)
Message-ID: <5391e6e5-3773-a012-c396-b59b1f54ea51@linaro.org>
Date:   Wed, 28 Dec 2022 12:58:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
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
 <c4109766-22f1-7227-47bb-9273a027bb0c@linaro.org>
 <CPDFHXBPSP76.5CWNQK4N1KGI@otso>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CPDFHXBPSP76.5CWNQK4N1KGI@otso>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/12/2022 12:53, Luca Weiss wrote:
> Hi Krzysztof,
> 
> On Wed Dec 28, 2022 at 12:50 PM CET, Krzysztof Kozlowski wrote:
>> On 09/12/2022 15:29, Luca Weiss wrote:
>>> The code in ufs-qcom-ice.c needs the ICE reg to be named "ice". Add this
>>> in the bindings so the existing dts can validate successfully.
>>>
>>> Also sm8450 is using ICE since commit 276ee34a40c1 ("arm64: dts: qcom:
>>> sm8450: add Inline Crypto Engine registers and clock") so move the
>>> compatible to the correct if.
>>>
>>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>>> ---
>>> (no cover subject)
>>>
>>> The only remaining validation issues I see is the following on sc8280xp-crd.dtb
>>> and sa8540p-ride.dtb:
>>>
>>
>> Any plans on fixing the patch (after testing it) and resending?
> 
> I wasn't quite sure how to fix the comments, but re-reading them this
> comment from you is how you expect it to be in v2?

The patch fails testing, so I meant this.

> 
>> Just add it to top-level with minItems: 1 and per variant customize:
>> 1. maxItems: 1
>> 2. minItems: 2 + required
> 

Yes.

Best regards,
Krzysztof

