Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D13EC77B6E
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 05:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbjDDFmB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 01:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjDDFmA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 01:42:00 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9352E1FCB
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2023 22:41:58 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b20so125911004edd.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Apr 2023 22:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680586917;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vkLggO8KDDtQGSO4O++zqyqlroGLRt9bsTLK9+jSmi4=;
        b=PeMTuTOEu4F6ccICdsCs1oZoXTmsSvgH4YGAk/wgwuHsIb6xd112MpRWI2IvOINQ28
         zqVwSxy2xnNtWBZ8mhTaSe8fsSWVm8g2tnDCY1PAsgCHj15PSiCx/9iu+ssXAhpm9aXq
         KBgsTq/OQARkYgvmvMn9P9xol46hFYOkJgjzqfusG3L6Atztgmhqw0fzxQQtX+3wIm4g
         bkvaFkzgNQGpjUs5Z2UPeKQVzpPrB476NmKvVmpLK2k3vvJ5VcgOCc57RqyX+jIxhKTF
         4N0+a+5P/aDUNB1c9y7FANMFybV/7xw8QTZvM2STYwxluSKFXZP8OU4ju7PdFoz8n5U5
         ZsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680586917;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vkLggO8KDDtQGSO4O++zqyqlroGLRt9bsTLK9+jSmi4=;
        b=UiME72qk2dw1U5McyXBe1yZKYHqflUEvk5PDlcusmIlFWEM/MMT6aTCcOXRX3V6MPi
         r6gkzgwC8D3t43X5ZwMvDKF40fUf1mnvxaapNqq/MKtO7FSwi/S0GuOWdmb+bwdxOhPm
         83idT2uc+M0VwwXP2srhMMrKwWqf0j11PM4iO3XaYAyQai+Dr22bpVxwvxSGLbwxX3js
         IG7jQ9mrr8uNFgc3SVLuLYHjsZLEVnfx/otsc7jbFQ3N5FctpoUDqcQPZ2iLeqa0Pvxg
         o9IxqzQr07Pk42lv3Zs3jr6RRmFluwubclCmznxBd68BF7DFoMSyhJAuEPBI/YQ3W4Af
         HmCg==
X-Gm-Message-State: AAQBX9e8dzQGMQ8HuFoCkpbINQQUQtjIsMWhc6Dx1UicaHqHIOJ5zg+N
        aRsbRVgcsuUwxej/4urIE/NJXg==
X-Google-Smtp-Source: AKy350alQEuK+jaEwiAUarG9JUGGPd9TSw6AtgvsRBzfuLEAJRvSOasjLJIY0F94lySGnxGRn2gWtg==
X-Received: by 2002:a17:906:33c9:b0:92b:f118:ef32 with SMTP id w9-20020a17090633c900b0092bf118ef32mr1177803eja.48.1680586917048;
        Mon, 03 Apr 2023 22:41:57 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:233a:5c18:b527:381e? ([2a02:810d:15c0:828:233a:5c18:b527:381e])
        by smtp.gmail.com with ESMTPSA id ga3-20020a170906b84300b0092595899cfcsm5442421ejb.53.2023.04.03.22.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 22:41:56 -0700 (PDT)
Message-ID: <9fc90c8b-9234-84fa-7dab-fee9de2b9813@linaro.org>
Date:   Tue, 4 Apr 2023 07:41:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v5 2/6] dt-bindings: ufs: qcom: Add ICE phandle
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
References: <20230403200530.2103099-1-abel.vesa@linaro.org>
 <20230403200530.2103099-3-abel.vesa@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230403200530.2103099-3-abel.vesa@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/04/2023 22:05, Abel Vesa wrote:
> Starting with SM8550, the ICE will have its own devicetree node
> so add the qcom,ice property to reference it.
> 
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> ---
> 
> The v4 is here:
> https://lore.kernel.org/all/20230327134734.3256974-4-abel.vesa@linaro.org/
> 
> Changes since v4:
>  * Added check for sm8550 compatible w.r.t. qcom,ice in order to enforce
>    it while making sure none of the other platforms are allowed to use it

Why?

Also, this does not solve my previous question still.

Best regards,
Krzysztof

