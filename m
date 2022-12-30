Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BEDC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Dec 2022 07:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbiL3Hyu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Dec 2022 02:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiL3Hyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Dec 2022 02:54:47 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D5F17E2E
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 23:54:46 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id b3so30802227lfv.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 23:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W/u2lHtYt55h9eLW2aJ8+8WfUAL34DdGK7BA4/nzMmE=;
        b=OopDNledczuyTzgtVFh2rmVJwXXPMsGu5yX/fyAnjBIIa87cnSEhCvBYBRXvL42x1a
         3i4xB94tUgIsqxkLksrKqYko0zEmGb2m/ZLDevg6ZYfIMaFSfhDyBwRCUQRA9FJloRL1
         F2GD8txY7GFpnaf3OrWLJKanpUrvG0ZSNhdmgs4Y651Ir5ELHPicOPj51pWYcWxTQ6j5
         V6vWW9b+DKkZKfGGEvcZFOYski2TFhH35YPlnoVEA8oi/tLY/leMVNuKVPoRtVKdpBNc
         nbY6HFnIc52C9OZ+4IpZE/Wdf8Zn46px6BZwiY0x9s0ls4P3anN1nWIIKXPkS7PtdqXP
         LaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/u2lHtYt55h9eLW2aJ8+8WfUAL34DdGK7BA4/nzMmE=;
        b=r5WhZnW6SpCkjMWwXPV21oxf2EHgFzra9BEJMlRUbCN55bXo6wp5J/JnH5SS9USlYf
         zJzlqnsx8JiJAxR2BWGWz6RHmSjmbno97V/EZb1AxILmG2jXArmTDOiBk5UKZduFppxI
         k1fEgCA7BVKF6rNJzwDkqwva8GPbZ3+fkhNvriL0pcSztrUUaZYYuaxSvh61t2taaoMv
         8Zs0IbVZ3P+voQiZzCqUTuXOG8nlZKpvENnOwhZzektYklcJLh0jwfbGDri7LHRAh+qz
         MHF8zh7cgLCW1VM2sPtqCUhvxiaV10EDw759xz5GsSA3VwrTFzCx7Fg1VO5jZC8rHwKb
         shnQ==
X-Gm-Message-State: AFqh2ko5/PV9NAWJCO9iFd3L1ko3sK1dCdame2ULqImycOb88ouDX8En
        RU3YDVkxgMNi5OjQKqxcbSq62w==
X-Google-Smtp-Source: AMrXdXs6UbI+YlGXHQdgRobkLgdafexKjyXND6gJW3NXNDJkoQVoneNf4yNrc33qh+lahEZxrBHZzA==
X-Received: by 2002:a05:6512:108f:b0:4a4:68b8:c2e4 with SMTP id j15-20020a056512108f00b004a468b8c2e4mr9867605lfg.59.1672386884508;
        Thu, 29 Dec 2022 23:54:44 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id bt17-20020a056512261100b00494942bec60sm3363337lfb.17.2022.12.29.23.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 23:54:43 -0800 (PST)
Message-ID: <115b649b-f0ff-1fc6-36c8-fae63e5c73f5@linaro.org>
Date:   Fri, 30 Dec 2022 08:54:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/3] dt-bindings: ufs: qcom: Add reg-names property for
 ICE
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
 <20221209-dt-binding-ufs-v2-2-dc7a04699579@fairphone.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221209-dt-binding-ufs-v2-2-dc7a04699579@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/12/2022 08:42, Luca Weiss wrote:
> The code in ufs-qcom-ice.c needs the ICE reg to be named "ice". Add this
> in the bindings so the existing dts can validate successfully.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

