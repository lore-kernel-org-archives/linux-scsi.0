Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8EDC46467
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Dec 2022 11:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiLPLZz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Dec 2022 06:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiLPLZw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2022 06:25:52 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640CD165B9
        for <linux-scsi@vger.kernel.org>; Fri, 16 Dec 2022 03:25:50 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id q6so2987517lfm.10
        for <linux-scsi@vger.kernel.org>; Fri, 16 Dec 2022 03:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jq34xZSUT8QsMyztxfKEALtkriwch3PoCGhlEfPa3GQ=;
        b=LkAyUjpNX35mihFXiQlkEnMc5deO2cakn0tU3MPYR6UVfWffBFoOVMIS4jj337q+BJ
         mL17jgD7gMi9Eyqy+aoyL85bb6V2Y2vUsgWl+LG6D9+k7s6VigssHH1J0kkKHu/yB+Or
         uzuaKVAx5CrGLggEo7ndLKznDfyUA87rPaMTPaekDXnZj0szgrdMyFz9Q44Q9/CnfZZ9
         J8SnrsSphkexeZxxUfkBfIpsEpXrwocaNLN/74+hzhti7GfV34By+v4SkxhGBwWVN9P3
         nvbVNEbhdwgGt/KuzMFJy8XuYeY2ISZn4eR4SWTgHmGkP4Bq6yhyqjuB31tj1MwR6UbH
         neew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jq34xZSUT8QsMyztxfKEALtkriwch3PoCGhlEfPa3GQ=;
        b=z+NFxouImvZz8KYhme5S6VCANHx8z+ZKjr/g2R3qdQfkCKAgAnuHnalNeWhri2EIT1
         mXHPvEMDkBsmJxxd7YKXnmIG8AeJJCk/uds68eMwcBOh7rlcATd8qRxElc7xgqYyn4Vj
         nEEmYED/O/u7nULiB1k0qLC8VbV3vfgFurJ6YZRXObYYrE0CfvMJ+miWWJ1hF33XoU7X
         eFPXdk54Jz+ctv232OrvTPho4uMv70IXYLl/j8vwEbNuze2lJRbKMpE6dV8whpfBzmar
         pYzCg4uDHFqkYe5cl5FZz+V/Ll1VaM0KV6sRl1IFLSOwhBfxuC8k2AZt3Xfz1slAiG9s
         kqvg==
X-Gm-Message-State: ANoB5pllO0y/XE7sH637IA+DHy5RsezYePr5lftXsM2sZpOtKxEwnhV6
        gH/rP3eA1xn2EDRNnRzrJE/wSQ==
X-Google-Smtp-Source: AA0mqf6vfu4R9gsLSvdGIsOl2P+MeUnboQi0ZGy6b1tPRuGfMFVAhR0T9oajRy8PIo8lDi00UT7rQg==
X-Received: by 2002:a05:6512:114e:b0:4b5:a4ef:fca3 with SMTP id m14-20020a056512114e00b004b5a4effca3mr10534762lfg.38.1671189948800;
        Fri, 16 Dec 2022 03:25:48 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id s10-20020a056512214a00b004b52f4ea0d3sm192459lfr.192.2022.12.16.03.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 03:25:48 -0800 (PST)
Message-ID: <2f31c3a0-572d-41c4-4724-85d64394aa66@linaro.org>
Date:   Fri, 16 Dec 2022 12:25:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v4 1/4] dt-bindings: ufs: qcom: Add SM6125 compatible
 string
Content-Language: en-US
To:     Lux Aliaga <they@mint.lgbt>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221215190404.398788-1-they@mint.lgbt>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221215190404.398788-1-they@mint.lgbt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/12/2022 20:04, Lux Aliaga wrote:
> Document the compatible for UFS found on the SM6125.
> 
> Signed-off-by: Lux Aliaga <they@mint.lgbt>
> ---

Three versions the same day? It's too much.

Where is the changelog? What happened here?

>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Best regards,
Krzysztof

