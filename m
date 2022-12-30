Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DDAC53210
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Dec 2022 07:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbiL3HzB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Dec 2022 02:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbiL3Hy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Dec 2022 02:54:58 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DAE18397
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 23:54:57 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id cf42so30797843lfb.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 23:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7y9/9dqJRPgZvL3rwpxNc7byREOsvmcfrCiAJsoPaaY=;
        b=mOLozdir8QpzzKqdRCjek6mwVKVeE1bQZlxTVvBwFq7laAT8Doge7fy5R+Du/JuyAP
         s2JdpA60y3e7KAOo9kiMQZGCTENqjt8a4LzODcj/bPFQi8qetYOrF6jOSqI9DxGTvTLj
         /mibjuxy57lmczyGuNMucB4a/KviIreDtJKXYqikMAnUYSw9mGl2usI9TYk2PsAyeS+S
         Ne7DfQzn4caFqyINKmdziskFK1ozhLl/ux6CK3IzQ/bt4PmpORJ0bUj+y7fDpyu49cwW
         u/W+v/vhgr+976SDapmNwsn+lg79fzulRBVuqDVb+gPW0BkE26vhn/ucTMcxziPAS4kI
         nSSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7y9/9dqJRPgZvL3rwpxNc7byREOsvmcfrCiAJsoPaaY=;
        b=PmSkP3daB41BGhXIuKFhOxHakBD201k12VdV8/BAX6phdyMiWKkD4+K7lTpORiKfQJ
         TCOQ/43ucZGEX8wo7Da/p80EtVMesnc5knJUBe6KsqY76IUgKs+TyGk3X8wAUW3FPE2O
         zz9S5LxmjOWo6FIzAVQnE1V53uEDg+PUcIqbewBM9LLlJWTCSaU4wwWX+3PI+M6anuPX
         +SMyJsVWXewPOXk9TPXqJnoGxoHTh/cRhJOlel7EEp3EGa8v7GjTye0lt/OOEEcmv6wr
         sT5Losdr/qUYkWX1XtI5DBzNNFLF/9sisZE4DWUcWvw+Xkip4I8S4hxj8KsWtISs5n8c
         +yIw==
X-Gm-Message-State: AFqh2kr8Cl2H8f+N4bctjnUK3+SzW60oh7zoP6lPLJc0D1c0urci8twK
        X7WGyKGNhVD9K/gv6sdSg9aKxA==
X-Google-Smtp-Source: AMrXdXt2Xdw3MQFjEugmriAxPXpE2ODwiNibR/Qgt36bOws4pf3FJ9f+luPYT6LlzaLrqbnk5JNTsg==
X-Received: by 2002:a05:6512:3601:b0:4b7:13b:259d with SMTP id f1-20020a056512360100b004b7013b259dmr7853811lfs.48.1672386896122;
        Thu, 29 Dec 2022 23:54:56 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id i22-20020a056512319600b004947984b385sm3353055lfe.87.2022.12.29.23.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 23:54:55 -0800 (PST)
Message-ID: <f04570e1-b8aa-be21-b0d6-9f56440c4158@linaro.org>
Date:   Fri, 30 Dec 2022 08:54:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 3/3] dt-bindings: ufs: qcom: Fix sm8450 bindings
Content-Language: en-US
To:     Luca Weiss <luca.weiss@fairphone.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Iskren Chernev <me@iskren.info>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org
References: <20221209-dt-binding-ufs-v2-0-dc7a04699579@fairphone.com>
 <20221209-dt-binding-ufs-v2-3-dc7a04699579@fairphone.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221209-dt-binding-ufs-v2-3-dc7a04699579@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/12/2022 08:42, Luca Weiss wrote:
> SM8450 actually supports ICE (Inline Crypto Engine) so adjust the
> bindings and the example to match.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

