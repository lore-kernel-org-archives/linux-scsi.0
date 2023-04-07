Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9100C76196
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Apr 2023 08:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbjDGIpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Apr 2023 04:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbjDGIpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2023 04:45:40 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7BC4EED
        for <linux-scsi@vger.kernel.org>; Fri,  7 Apr 2023 01:45:38 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g18so6978518ejj.5
        for <linux-scsi@vger.kernel.org>; Fri, 07 Apr 2023 01:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680857137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EkzZhTvOzLRcCGpfrge05I6LlNCd0VLnVsi76p0/Q9Y=;
        b=tidL1h228tOzQTBOUqn76zpPuR/cmWNKWhR2GufNT0+O1y7j3oF2OSRoqiUVqkC5qI
         vY2BAyE2ubUgiRQ2Y/O6RRY9teFunLs7RVjucHn5es55NYCvw3LpQtTL9VsogpVwPWq4
         xXrUU3p05SPEeWazhXCGVXFC5Q2AmP7aABD7xTd/FRcPSVoY904UT6oYaJHBglQaqG0K
         5WBajTPFS/M+EtIoWUjcbVLVQpRJev7tEJwrrmHuJT0nmhKdJ+QVgMJ9TUDx1/yF9iVx
         R/nDMN+yvJtQHUv0nltGy5t/JpoOdTa1RdJaAjbPTGZXVsiNlDx916SCzNqMW7Wzfqbp
         bMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680857137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EkzZhTvOzLRcCGpfrge05I6LlNCd0VLnVsi76p0/Q9Y=;
        b=w2SjCvnhmdmSxYMGwys5rTelKvTeY3ZV+JkV0yalkAWnbSTswGmfQg8iRp65PygfAh
         HGSQmodOuUMsv5wFsYRCUAGrCdDy95c2UECet3z+Mzjg7WkOa1aTe9NvxtOprcCVL6BN
         WtSr2TLJIWvmF1HCZQd14gOzIBrvif5kdemAH20c02mbbKkEH8JIr+lxyW4uGo7A9knB
         me6a05Ywr0WxaVKyc3H8Z/eEGOAkvjosH/9j1x94JvhRgu5ByRufFBXKV/xHyG7jyXGu
         xHTHXpzfc+isVK3cUrjo8Vp9MalZHXBgRY0ARN5sOwBIpMK2MZ12w3XEK3agdcmJYnBO
         ZrGQ==
X-Gm-Message-State: AAQBX9dyakoaRE0vMn8ybMTavFZs6OhrXNswczdBzKWbNyo1hzO1Xxs7
        26fErPLM0LIznD6g8wqS2hyFMA==
X-Google-Smtp-Source: AKy350brdfe8nxr1JYdpIW6N0eS4YwtysVwTUFW03OaK40Lq1FF//oAXxsoNoLZ77c3KBnpLWspb/g==
X-Received: by 2002:a17:907:7608:b0:8b1:7ae9:647 with SMTP id jx8-20020a170907760800b008b17ae90647mr1063441ejc.76.1680857136910;
        Fri, 07 Apr 2023 01:45:36 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:14a3:366:3172:3c37? ([2a02:810d:15c0:828:14a3:366:3172:3c37])
        by smtp.gmail.com with ESMTPSA id r13-20020a170906a20d00b008d044ede804sm1802700ejy.163.2023.04.07.01.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 01:45:36 -0700 (PDT)
Message-ID: <0762cb76-a1cb-d25d-2a8f-8f9eda21cc81@linaro.org>
Date:   Fri, 7 Apr 2023 10:45:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 1/5] dt-bindings: ufs: qcom: add compatible for sa8775p
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230406194703.495836-1-brgl@bgdev.pl>
 <20230406194703.495836-2-brgl@bgdev.pl>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230406194703.495836-2-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/04/2023 21:46, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add the compatible string for the UFS on sa8775p platforms.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

