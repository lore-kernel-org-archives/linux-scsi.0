Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47043C4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Jan 2023 15:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjAAPkO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Jan 2023 10:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjAAPkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jan 2023 10:40:12 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8102AE8
        for <linux-scsi@vger.kernel.org>; Sun,  1 Jan 2023 07:40:11 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id bq39so30611266lfb.0
        for <linux-scsi@vger.kernel.org>; Sun, 01 Jan 2023 07:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+pVoAe8bQDQU8ygNqgrsQtDq/4LXhpcuUhVS3IiT3ps=;
        b=X1cSZ8BdKum/BGWzz+RS9YB0SX1pWreF0BlzZxBQytsixQ508QjMbAd52nR3uXroak
         8fwsNligWrCarMkm0E0EtEeInqdOf6UZL2bFhqKHJA2XWLULkHVarGZ0PpFAMvyhGo3j
         KyJt3N5UfeenjeKKYHE4bsoX9Z08fUO7WUO816DH7L7u4y9aa+01LxZOWH7UvICf9nXR
         euMR0kFt2ywwTTDisHAM4LwiAqrsdzffzMbouypZD1liuqTf2ko24VinCGWp3gbYMsFQ
         l5aU/EHrhoCBtZVylPmiGTFphlLs81JAzYacei9DfwfgU7+yQomF56idRl1IKI4GaOW3
         fKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+pVoAe8bQDQU8ygNqgrsQtDq/4LXhpcuUhVS3IiT3ps=;
        b=hYjJya2cU1HKk72MjtJbmBaUlllJsYV1WmuPO9OZT7fQm23vvi4+dfe1FCNPTDCM2w
         bvHG/Da2M3pyRqP9b+elOwGnPLjP8q0fFBkA6X/D9G8lttNCkLAzv4y+ZrIrVGs3QTm8
         gmUrDr4tkN6G8YbFK0NjompOINyat6yKzSvlgo0zfmO+UEa5wCta4dV13JC61FOWazC+
         LDA2ItzLzZdDlWub1IyK7TvSdx43jJQZXCBilr1xzEex0IiRxJxGP0Mfres8ABX5YIZZ
         V/m26I0wnEE5ceb5wr6vpufOg1M1ec80u08s0iAKO9tT0dWZmFZiMZWYcCttDodg0PEN
         mz9g==
X-Gm-Message-State: AFqh2koAsiudyhpAwMV5l3q0cJbeLFvErUJyFbCxOxIBVkH+6Bb4FSGP
        Z3NTiWFnedZkGtuWUewc2Kzncw==
X-Google-Smtp-Source: AMrXdXvzKlCCuN1UVeapGWNHxfTvED0EGCsl7XmG6riyWSVPIzac849lCJ0t3ALG9CwZXk4OPKxIRg==
X-Received: by 2002:a05:6512:3e21:b0:4a4:68b7:deb7 with SMTP id i33-20020a0565123e2100b004a468b7deb7mr14384652lfv.19.1672587609601;
        Sun, 01 Jan 2023 07:40:09 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m4-20020a056512114400b004a764f9d653sm4198387lfg.242.2023.01.01.07.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Jan 2023 07:40:09 -0800 (PST)
Message-ID: <311f2e5e-24bf-9c52-8773-7a350e0fb3c7@linaro.org>
Date:   Sun, 1 Jan 2023 16:40:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 1/6] dt-bindings: ufs: qcom: Add SM6125 compatible
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
Cc:     ~postmarketos/upstreaming@lists.sr.ht, martin.botka@somainline.org,
        marijn.suijten@somainline.org, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221231222420.75233-1-they@mint.lgbt>
 <20221231222420.75233-2-they@mint.lgbt>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221231222420.75233-2-they@mint.lgbt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/12/2022 23:24, Lux Aliaga wrote:
> Document the compatible for UFS found on the SM6125.
> 
> Signed-off-by: Lux Aliaga <they@mint.lgbt>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

