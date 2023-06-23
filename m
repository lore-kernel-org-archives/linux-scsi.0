Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38579EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 12:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjFWMaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 08:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjFWMaV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 08:30:21 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9A71FD2
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 05:30:19 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f9c0abc8b1so7323405e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 05:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687523418; x=1690115418;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fgCSN6z5W15lMDtsJXT1Gf4tJ7T/+vvkHu58nF2ZtfA=;
        b=fz/yWa52ZNikb6G5rufIPmOQlqWVs4rQs0Yy0p4zx7bxhn1DddSiNBsLYvrfKlDSj0
         5uZ1Z0M2SBdFDSUyYktgSd11Ut0WFLsbq1jnCNk3RBw4A7bt5ng2+vfpEi+BKFXHJYfR
         ZrZvmXIBRk6GLSwb/Vg+udLHY1bQyrWpZs1pULUHIy4uNH47p1CJWpuotM5I5Ixe3hJW
         RBq421wciLBrJoBouyyg1722SYCJDjjOjHJHQqqQbrhUTI57C0PxCkSTIau92ayjxNfA
         Vim7UqtoFrssEWXGce9LuNDaU/KSeY/e15B/DlOPkD3nj/RjTcSrQoI3Wguags8hwUBF
         eM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687523418; x=1690115418;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fgCSN6z5W15lMDtsJXT1Gf4tJ7T/+vvkHu58nF2ZtfA=;
        b=Cqo8WGyG0RzBK3HRDEWm5XPYIGujz6NnOIwdM2mVWz6VDSEjoTH8r0EJHfsB7dZdmR
         kwq7Y9n1QlxiTyk0huhRsJhqUs6N+b3zxfvQkW4F+a6p8mfa5BraNS6NIfO+NR3vdg9P
         kk3b43gj6axhGuuFZkRuLOp6aapZufdY94yy6dzc2Ul3bFjJvoTu5fh1qDi720+8RLjK
         kmttMLxJxm08X1dqK0VW7X5dYYOxFOyrMP9bklZrO/V5hskZsUJRT+z3EfrsOR6wXbaB
         eIYqFUZ0c3w76X9dxtszRbC5jU8YJkVD7qHinu4T8o5PZzP/6R84g1o2RgHR1SO5U/uD
         hXEA==
X-Gm-Message-State: AC+VfDwH3+L6mcE1XI5TD7gWCMut/JCImWmBeDOT5bWpFMXIVveDmR82
        m5DGVQcyxUJqDiBjXNJ0ptORpw==
X-Google-Smtp-Source: ACHHUZ7wt9RdVSy3OKCECoih6SD/+uvQDfgsS0bypu/tEx+4635YIzPFRnp0U7RG6QRoDRbhZ3h6pw==
X-Received: by 2002:a1c:e90d:0:b0:3f8:f663:921d with SMTP id q13-20020a1ce90d000000b003f8f663921dmr19543787wmc.41.1687523418379;
        Fri, 23 Jun 2023 05:30:18 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id r19-20020a05600c285300b003f8d85b481esm2249133wmb.21.2023.06.23.05.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 05:30:17 -0700 (PDT)
Message-ID: <5620079e-cea8-7244-cc34-440b32b9a580@linaro.org>
Date:   Fri, 23 Jun 2023 14:30:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 3/5] scsi: dt-bindings: ufs: qcom: Add compatible for
 sc8180x
Content-Language: en-US
To:     Abel Vesa <abel.vesa@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
 <20230623113009.2512206-4-abel.vesa@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623113009.2512206-4-abel.vesa@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/06/2023 13:30, Abel Vesa wrote:
> Add the compatible string for the UFS on sc8180x platforms.
> 
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

https://lore.kernel.org/r/20230530162454.51708-5-vkoul@kernel.org


Best regards,
Krzysztof

