Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD7BC77B6F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Apr 2023 17:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjDJRWU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Apr 2023 13:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjDJRWS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2023 13:22:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D702691
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2023 10:22:16 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-504a37baf98so755177a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2023 10:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681147335;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aF4gu0RaNrTTFCvcYQcWRArSpPeebO9/4yLFj3PI3mY=;
        b=fWCOpX7/SwjuHyqJLAqClg3voZ5jnOfmERlA2t3+Wdt9T0LUdPTYVjAYkiEPr99UP2
         Nx8wnItxxh0CdR0zx6rkW0veQhlk7VxWS5zTmRO0dzt7ojT1RYshEkgPSquRabUVM+Ya
         dHJ7o4zREoGZ/ccqzPge9HqhFAOi/MIsI4QoXEWtHuUxBiKXcnhN3unjMjlv356KPCEu
         PJii2cjj5EbSPOeVYME5nVy2k0DoyEcMbWlniNuwM5+ttHHgciawikdWbFw3uZUd1vlZ
         w8rE6Ep82LRdkZkdxQRb5K/92nPikFsWfYi41qGwZC1PTvf0dWBevYf8xjGNnFTdhEXo
         3q4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681147335;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aF4gu0RaNrTTFCvcYQcWRArSpPeebO9/4yLFj3PI3mY=;
        b=Bioe1hLflKAOiE7bW6flxrBi2RjTrNYAPatFypPut/WoOzvnYnp7tkNCYvu/0J+oTz
         sC6QXW16UFyb8DuJ2M5zKnxmIVGeAtN85l8MS3YxPib+zawUbDa85LZmHKVvwNH4QwMY
         o4AGiwN52KVGhokZgyq675sduaC3b2x1PUKVwiHQ8VJi8ps69Jeu6FxxNOXtbf1R+hP2
         JgeQt95AutcUQ0jciRC3xXGWYhzJIDfxICZov/eUFtvnVjplk+Mlolm59VfIKK+kPU0K
         tsdDy8imniJT2HmsXRaIilFt81LfNVIcbRDBza0eNh23watSTv4D//e3pjzM8G0f1vY6
         rCEw==
X-Gm-Message-State: AAQBX9ejfFEBKdyPYUsvbcHxurRJvYMriM3uCZceAOo6QODxsYuS30Xj
        bbCOukca2p0e98YCWdqyrSOjQQ==
X-Google-Smtp-Source: AKy350aNsSC8fqZ/yvuVJrmsoq1jKWAOxaKpue1KeRo5d69Vg7dnLJrE0uJOHhunMzUrshZGuWOHOQ==
X-Received: by 2002:aa7:d14f:0:b0:4be:b39b:ea8f with SMTP id r15-20020aa7d14f000000b004beb39bea8fmr6554535edo.2.1681147335445;
        Mon, 10 Apr 2023 10:22:15 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:1a6c:6968:e633:48df? ([2a02:810d:15c0:828:1a6c:6968:e633:48df])
        by smtp.gmail.com with ESMTPSA id h10-20020aa7de0a000000b005023ddb37eesm4875429edv.8.2023.04.10.10.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 10:22:14 -0700 (PDT)
Message-ID: <5d5e5030-7db7-447e-e5a4-2157171d7575@linaro.org>
Date:   Mon, 10 Apr 2023 19:22:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 1/3] dt-bindings: ufs: qcom: Add ICE phandle
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
References: <20230408214041.533749-1-abel.vesa@linaro.org>
 <20230408214041.533749-2-abel.vesa@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230408214041.533749-2-abel.vesa@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/04/2023 23:40, Abel Vesa wrote:
> Starting with SM8550, the ICE will have its own devicetree node
> so add the qcom,ice property to reference it.
> 
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

