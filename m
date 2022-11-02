Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB65C4321E
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 19:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiKBTKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 15:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiKBTJ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 15:09:58 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92138E08E
        for <linux-scsi@vger.kernel.org>; Wed,  2 Nov 2022 12:09:53 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id hh9so11943564qtb.13
        for <linux-scsi@vger.kernel.org>; Wed, 02 Nov 2022 12:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AIkEh7BXAQ8EfVcaCpQmqvlq6Pnzwaj79KpKIFXtqKk=;
        b=D5NqaoeFxXGLhUM1iiPWsSusfvacuFdAOm6V8ErMS9WTejX9G+7XNSYvAnzL10LFFp
         qE4b9Fd5IJns9Y169x8pYIfvEM0CEQ7UlfQ5ml7I2wQplpGk93Og//KQ6l66s2LeF7Ng
         0QIQG2YvDP8l4BXttaBxEtpb+R11qglLFfU3r0tAVplqVAE9m+N5E+WLMYpPROr6YABD
         dDv1ZnUkW2HQDoRNxvZRD8RCgvwZFB7bKffmiB6fpEfwy093n055DP70XMYf0MNtGMTY
         cM6o2zeIscCb5OKxFh15wUhs+A2kcnIS8JdGXqbvwB/gsnlxMWnSn/3rzYMoDI8YAYem
         JlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AIkEh7BXAQ8EfVcaCpQmqvlq6Pnzwaj79KpKIFXtqKk=;
        b=aLhM0JLevl5bbCy9bgTyqKOEZdtzhbMiKuBAifNZmpW1DDbujtxI4Cbg82NIy09N/6
         MvkuCquOq68pRTcA2s8fyAzuQ4khLm9AKSxvYCGQlxz5FyR+VxxTXWxenfjS7M48kljC
         S41A++3/+bZeT7bSW+SKhkPEueKyRWEqfdF8vWzMx9pyfBeunn2KhI42SAOutUDm4nbW
         CQtWFhL7rWKIfEnk49ESP3nQJygwbIQBb89HhQ9iYEVdcDbuVdgBnrlUn268svz+6UAi
         XwE82BTJ9oqRVQhg+TYgvaHSEqLZnHdn436dPjpfy6MEvqW6CRL0eDSnfnRKssv1K3pB
         FPUA==
X-Gm-Message-State: ACrzQf1GZy7u05spjrbosC5BtQGIiET+6REJQMQfY+zRD60puSk0vLtE
        D3QCmDFXoA7ySyCAY0Cp0y8tgg==
X-Google-Smtp-Source: AMsMyM5rtL01pS0TQ+i5UNqkH3/BIoMq0q2RjMMZmpCfyVX3jZh1yBtxA1LpksWIIs0gVwKIiDmLaA==
X-Received: by 2002:a05:622a:407:b0:39a:836:acfe with SMTP id n7-20020a05622a040700b0039a0836acfemr20925776qtx.133.1667416192736;
        Wed, 02 Nov 2022 12:09:52 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:28d9:4790:bc16:cc93? ([2601:586:5000:570:28d9:4790:bc16:cc93])
        by smtp.gmail.com with ESMTPSA id bk20-20020a05620a1a1400b006f3e6933bacsm9098388qkb.113.2022.11.02.12.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 12:09:52 -0700 (PDT)
Message-ID: <1fe8fd96-7770-0bda-c970-aa38d030ff3b@linaro.org>
Date:   Wed, 2 Nov 2022 15:09:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 06/15] dt-bindings: ufs: Add "max-device-gear" property
 for UFS device
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com
References: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
 <20221031180217.32512-7-manivannan.sadhasivam@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221031180217.32512-7-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/10/2022 14:02, Manivannan Sadhasivam wrote:
> The maximum gear supported by the UFS device can be specified using the
> "max-device-gear" property. This allows the UFS controller to configure the
> TX/RX gear before starting communication with the UFS device.

This is confusing. The UFS PHY provides gear capability, so what is the
"device" here? The attached memory? How could it report something else
than phy?

The last sentence also suggests that you statically encode gear to avoid
runtime negotiation.

Best regards,
Krzysztof

