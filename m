Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D9DC761A6
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 07:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjC0H7L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 03:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbjC0H7G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 03:59:06 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7A149E2
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 00:59:04 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id eg48so32041436edb.13
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 00:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679903943;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YQKQzGOMARwoG57LLxeRnpM5fxI1Xzye0MM/44WhAFs=;
        b=H9T+KHI5mScbjXZM39U4rvF4EZJwf2VlsFbYg9jFeDzvxCrfXaWnuREo0bRRpCT5Pr
         Vi3lynoo+ImNMm3DtJL0sEYEN7NIenQ7HR/Xq/9RHy2xsA/AOgCa8Pd19GkXZM8jcaK6
         FTa2blSR5rLJkL61N4WPWAghb2b4bUqkxMG960dCC3dapL2AXrgzPktGXs/BvIELvIQz
         5h76LyQb+qmpcxJyyhXXNJ8chrHZ1+vpkb/L4R0fpnleHUGfSnHGXDnmb/CcWUL1ur9W
         rqi3XZ3uxTNe6GSLcVD125ahJ34Qk5o0BWPDHz/+kXgIhyN6O2QmW5JY5hoVkPAYxDia
         AMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679903943;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YQKQzGOMARwoG57LLxeRnpM5fxI1Xzye0MM/44WhAFs=;
        b=ZKoiTA/53sK113yvTOq7+LZcBky7a29fB5sbdguZy8hqSbnfAwvoq2NB79HOJxbIKg
         lIAqNW26VwSx6rpb+XiiCGV9nR4kYZZpxgoBnIh5BzrU161vIdQmwbj3faZKlZAyue40
         kTaMDULeMvGelIvfeRFNUARZ8VbLhRSQiVch0rkbt+qFJpHrAToXNgcyEb35CJ9E0bjG
         XKiTumt7OInFfh4kpEQhsDSa9eMuZGmvgC94SoOsURB/KzofGlfrewAL92Wsj3/VPNlj
         4K+Y8B7qfEE1IyuOjpTyNB9rfuJvavNpadTBwweFjCtuGg9NP0llbhKmGTfv1tFPM9wH
         tcrw==
X-Gm-Message-State: AAQBX9dhlJCK+R2CQ/YBOnQlSYO+6QlWhXA9Fn5zN3qZVrfAC8vqWTuG
        jIlkr8t0+8Lh7cD/7wI1gi34ihQOlHgEyK37nmQ=
X-Google-Smtp-Source: AKy350YO1pg1SW4DGaty/B43Uir5N+0/YScvp+JK1pk8Mp6Js5yKlyJ9IMJb9KGnKGG3fEXiLEjFRg==
X-Received: by 2002:a17:906:bcec:b0:926:8992:4310 with SMTP id op12-20020a170906bcec00b0092689924310mr11870849ejb.38.1679903943007;
        Mon, 27 Mar 2023 00:59:03 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:198e:c1a5:309b:d678? ([2a02:810d:15c0:828:198e:c1a5:309b:d678])
        by smtp.gmail.com with ESMTPSA id xo20-20020a170907bb9400b0093f0fbebfc2sm3296956ejc.144.2023.03.27.00.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 00:59:02 -0700 (PDT)
Message-ID: <6162759b-a9ab-5ce3-e216-8213501ab174@linaro.org>
Date:   Mon, 27 Mar 2023 09:59:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 06/12] scsi: ufs: dt-bindings: Add SC8180x binding
Content-Language: en-US
To:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230325122444.249507-1-vkoul@kernel.org>
 <20230325122444.249507-7-vkoul@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230325122444.249507-7-vkoul@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25/03/2023 13:24, Vinod Koul wrote:

Subject: drop second/last, redundant "binding". The "dt-bindings" prefix
is already stating that these are bindings.

Same in all other patches.

> Document the UFS HC for SC8180x SoC

Finish sentences with full stop. Same in all other patches.

> 
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

