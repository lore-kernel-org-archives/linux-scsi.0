Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95495C001B2
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 09:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbiLNJuK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 04:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbiLNJuH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 04:50:07 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB4BAE66
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 01:50:06 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id b13so9510312lfo.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 01:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6FFmcD51ezj3o5LArcwRpZL3dKHNUEgb+0z4MfXTfq4=;
        b=SrsMIWLnZ2e6dc6WjP29rF3goK6Oi7KHTo5Ppr3cYCvz+pvDmiQW2Qzrue1wNWAoXM
         caJNYe7onWKVS739Q+tE7eyfCy5PFWmY8j0194eoE83MxT5RteG2t03i4rTlzlBikFaD
         eaxthxz+mZOelmAfyVkjmM3Tqq99hf3zRus2n+t7OcR0A2Bdj/TdgjUCeC9lPRvOQNYI
         faxibn3JYwdd9CpWJ7ODBKBMk270Xa/23xMLNSRWn8Fy1k7IG76oXNubS2HeGkGXMVBk
         aIsalme/c9b0Ccy1nrOe+NVO+T5x/4TdJhYXRgvjJDnL/Nm3ErS0EQ9HHRUCZy8DcjQg
         3tOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6FFmcD51ezj3o5LArcwRpZL3dKHNUEgb+0z4MfXTfq4=;
        b=epFrmfwjeIdAGSIz9S93ghuwiXOVpeV1zFA0Boo+Nz+/qx9Gv/Zi9AC2idXERnJmBj
         n/72KLB9OzT91GkxQ3otL/szjHmA19ffmYJyxLIkCgpNdRsm7FeG3gvNA2BPFzzYTN2z
         N218KKqG62+j2Q0dEURiK8870HyJWAK1BMWDxSwnGjNReKVjJh/7HnnLbAIHq1YLYZW1
         73qjwW9Daa/Xuzsb4HIChqM9RpCMi34B/USOKZQ60yUokp177dMuk7rWkN0fh9K+JVO2
         IA+uHp61xA78VYOImbfXxxQKHwldf1BksSe4qmOHoCPezZenllgNSfGfOwPae0L1FVXA
         bQCQ==
X-Gm-Message-State: ANoB5pmZhBwWWNTJQ8NhSCV9GvO0XDBkB117MwUDBynBqJjQpK57uDJZ
        r7pBB0G4VCNyiHXA+KHB8IGvkg==
X-Google-Smtp-Source: AA0mqf4SavdtlFRgcw48pbLo6Dl14dBz5Gqm4lHo+/bQ+6ShOHcif1m01CggfXPrdDxkIq1cQzF74g==
X-Received: by 2002:a05:6512:340f:b0:4b6:f0ea:4f42 with SMTP id i15-20020a056512340f00b004b6f0ea4f42mr2326922lfr.59.1671011405009;
        Wed, 14 Dec 2022 01:50:05 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id e12-20020ac25cac000000b004b5480edf67sm746645lfq.36.2022.12.14.01.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 01:50:04 -0800 (PST)
Message-ID: <1975245f-93e5-358c-4488-692fefe4285d@linaro.org>
Date:   Wed, 14 Dec 2022 10:50:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/4] dt-bindings: ufs: qcom: Add SM6125 compatible string
Content-Language: en-US
To:     Lux Aliaga <they@mint.lgbt>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221214093053.152713-1-they@mint.lgbt>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221214093053.152713-1-they@mint.lgbt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/12/2022 10:30, Lux Aliaga wrote:
> Document the compatible for UFS found on the SM6125.
> 
> Signed-off-by: Lux Aliaga <they@mint.lgbt>

Please rebase on top of:
https://lore.kernel.org/all/20221030094258.486428-2-iskren.chernev@gmail.com/

so the change will be much smaller.

Best regards,
Krzysztof

