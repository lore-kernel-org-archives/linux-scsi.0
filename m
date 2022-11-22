Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE41C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 12:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiKVMuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 07:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbiKVMuW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 07:50:22 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CD56152F
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 04:50:21 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id k19so17837769lji.2
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 04:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EF2uYnatqQPCD9KmnDlcZfte2ZeEkOmq9HpXP2GGNr8=;
        b=bEnUtIDd8Riq7WG8b/zXqtKo6HOJy7yG08k2yu3NlQoD6av6JAOmnfx1bOTK0WkJwV
         eJT4TUUfGsKKDAtrr6moqbQEWDZAsxZBS8Jwtei6/R3nBNxjsuSEa2dSDm96/JMKS6gZ
         9cWpJ1XxRtOM9FwBBA54glhqS/UMXsaf+ZJVhHGegnt9eY+0qLe4KVg231sN2WwW0isq
         U9PaEgaMDHLa97vZEMxT34BkCD8bDk6WCSTjbus/c7pyvpxdhmGhaxUXfJwqnF0v15K3
         UG5ughwq+Mz/TUBUuvAYKHDBfs2WtkXwARejyqSIraDLcR1ZifN+6JcLZg+uM7MTI818
         myeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EF2uYnatqQPCD9KmnDlcZfte2ZeEkOmq9HpXP2GGNr8=;
        b=HNRVyb1hYzYodmQ6I17/Kfbo8Z6U4f8Vef/5/4RavsBM3UpPi+YB7O1daBJ03vaZWv
         JmOu6XxuAzXkKIG6qbki+gPCI8CzOF7EpM1GwCXabA50lvd5epObgG1o246cj5pc6eHL
         cmR1Jh8MPXf/naK2uL821UK1CYY4LP+kNIRhxzf0hcD0IJcN0rE00BgJMjJOL0OjXQ9m
         tS03gfWE3Qt8QG+myOJUml0/zkFkCZHcdbAqTOKqI2sedZ+Psj9ZX+zaVVhaDmpBcl/0
         Zw3PpugWvYLOG937alUjshdIHZFcDHonCX9bGLAKCAHrYDsyY4Hv/FW33N4XGenUg1na
         iqvg==
X-Gm-Message-State: ANoB5pk+l30NxDJGTJPaDVyYQzRVLLCPpPntej4FMLVpbo2B/3QWJpcy
        oZMEgaoy5HsyR+nj50Njo+tH4w==
X-Google-Smtp-Source: AA0mqf4tANoDNoeRDFkOLOWf5Hs2Zj97QXj110PJu1j+M7w93KQ8X8T9m0OMCzgLVsbLHrgT5HHjng==
X-Received: by 2002:a2e:a553:0:b0:277:665c:eb4c with SMTP id e19-20020a2ea553000000b00277665ceb4cmr1351204ljn.287.1669121420351;
        Tue, 22 Nov 2022 04:50:20 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id s4-20020a197704000000b004b1892aa5c8sm2496908lfc.56.2022.11.22.04.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 04:50:19 -0800 (PST)
Message-ID: <cd23a544-4a9c-70d2-759e-5d07a65e2c37@linaro.org>
Date:   Tue, 22 Nov 2022 13:50:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 1/2] dt-bindings: ufs: Add document for Unisoc UFS host
 controller
Content-Language: en-US
To:     Zhe Wang <zhe.wang1@unisoc.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com
Cc:     linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com, zhang.lyra@gmail.com,
        zhewang116@gmail.com
References: <20221122122030.7659-1-zhe.wang1@unisoc.com>
 <20221122122030.7659-2-zhe.wang1@unisoc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221122122030.7659-2-zhe.wang1@unisoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/11/2022 13:20, Zhe Wang wrote:
> Add Unisoc ums9620 ufs host controller devicetree document.
> 
> Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
> ---
>  .../bindings/ufs/sprd,ums9620-ufs.yaml        | 79 +++++++++++++++++++
>  1 file changed, 79 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

