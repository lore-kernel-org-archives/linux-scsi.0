Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905A4C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 12:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbiKPMtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 07:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239031AbiKPMsu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 07:48:50 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ADCB852
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 04:48:46 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id be13so29350078lfb.4
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 04:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jKTXv3W+aVVrG7M+pevbCvwAQjTJkck5FLwc5nQCkkQ=;
        b=KuBg0PdH3A4pnA7c9PaC5TTDHb3iw7rEugZB2T11VX4xjA8rPiUzhctQR2NVll5+7I
         QRIznVLfZ5EacZ/UbgjnAmazKCNgKwl1eFIEvVcoP/NopMhDbl7xqlzOHelCx41eKK3r
         ScKmaAOyuRKRgbS0JsOE2knYK8zVjFB5RNN/gfaW6JKJMybxcLoGGIm5DWReXub8JtEB
         RFjFDDci7gs2tH5QTc8ePF61aG7/G9LyvlTGLyk0VhTHLyc3U+79wkZQ7YSbqQDU0hIj
         vBc8Rb4kw9sQc4Af6Z1yF5TkTG8cNhIUPxE+3YGgFpqruwnfH1gg8zi4JhBOrc5hrVXu
         6htg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jKTXv3W+aVVrG7M+pevbCvwAQjTJkck5FLwc5nQCkkQ=;
        b=TaybQ27p6HFxUMd7qKKcPATheSpFeRecdOZzZ794eZkAYdC147adqy+kaDcdHA3nBr
         lMFOBKiKCfQxbHORCiC1tz859zITkWMirVBUQXeFj9IAf2o+2NMLhh0jsa+DGKO30JF7
         GFTw/uFUAoNZeTxCYdFdAZS0zASnOoZqpT4cuzwpjqB+9lQEr1XQBOX9tGvimEFRDmxG
         iPa2/34OdA0DVI2Z9O+PfS2/oFqY9KGTF8uJTEkl6PsbtJfQAebes8i82znnocp7RQ2g
         HILBwjUAY2rZ6v9QxLMlhRRbg0bq6CZSSNHBVjdtQ9Cz+wrL4R5xoeF4KUs4ESyY7ltq
         4rVg==
X-Gm-Message-State: ANoB5pmh+wDN17ng7lNfjdYa5WkLA90Ug0z8f1sMi+8izKBCjX0Rfr/r
        SEZ+hVRZlatCfPTNaTYDPNWyVw==
X-Google-Smtp-Source: AA0mqf7/5F66e1Pt6JlCU8Ah87lxd0DJlaAsqswlnj6wFWJZb1wN+pQUnFCD0yMYLrIc4RaYiZ07iA==
X-Received: by 2002:a19:4f4e:0:b0:499:fd39:b1e3 with SMTP id a14-20020a194f4e000000b00499fd39b1e3mr6909937lfk.348.1668602924742;
        Wed, 16 Nov 2022 04:48:44 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id b13-20020ac25e8d000000b004b1892aa5c8sm2594135lfq.56.2022.11.16.04.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 04:48:44 -0800 (PST)
Message-ID: <d9ee3801-d5a8-ecdd-96c0-ec2fbd6d43e2@linaro.org>
Date:   Wed, 16 Nov 2022 13:48:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] dt-bindings: ufs: qcom: Add SM8550 compatible string
Content-Language: en-US
To:     Abel Vesa <abel.vesa@linaro.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20221116121732.2731448-1-abel.vesa@linaro.org>
 <20221116121732.2731448-3-abel.vesa@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221116121732.2731448-3-abel.vesa@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/11/2022 13:17, Abel Vesa wrote:
> Document the compatible for the UFS found on SM8550.
> 
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

