Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4ECC678D6
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 12:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbjAIMTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 07:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbjAIMTi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 07:19:38 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A601B1AA08
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 04:19:36 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso6537421wms.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 04:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jitCQv0s/QU9TR/kvFCoOvVqsRo9aYoQJwCNC9DQgx0=;
        b=NrLnlZN5pilVg5pJ9hGkyj6hqNK1xfAudXGtGmFZ4juJPji17dzQOKB6+Hisohwmu4
         YDaL0jl1IKwv+VzdDMeGbGaqZrz2GayM7qxjVci1RqKixqbo55ipujxgqg7uHy8bEWTy
         gRP1MyEnDY4WngXQnWGrjvaQSnVEQAyOVlT79aZg67hQwUe/0N8sfXeAaARGQVev6Xxz
         C+Eauq3URw/RSGw+u3BXoerQUjxwweQZKwNO2hsFp50YNCFvRok3YOtITwbZQXZdMfdh
         LRiSgKYxvETeu8m/bQXDT33vzv0Z3nVyiVCwlFIkz34hVkipn/wtxDtk2g9Xok9slX3q
         7OlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jitCQv0s/QU9TR/kvFCoOvVqsRo9aYoQJwCNC9DQgx0=;
        b=TiOwpbgsWTlifRysuPDr5/1dy2tmATdcch6QsRqPws4aT4TsOf20zcPaDik/XZkHLq
         nSyQE45S3UBtDknm0VZvVrjwG8JKJSPSsZ2haRPz6a9IBSAJ/PV/+AfNLy+nDjKw1soX
         3GyQ/+Xbpewopv3Zartg0fUN2SygIzHm5+d2cr7AmGvEjhbzt9+Oj+/RU2flFXFyvsiR
         //dgHVRxcFBd1E4fTapEcAHFKR7utTqwNoexxbvOX/yPOGkcGjyAXHLF3eXpNJ/h658C
         CEZAklHEJcn2Byj120C7UlfCp5FOzn+77J5VVrvOqhtatp54omm/JNjuJepCLwN7dPLZ
         XYsw==
X-Gm-Message-State: AFqh2koH0n4P8MkWfWztauj7ip5O9ijQeiYFs0gVBLlQkZq2HGRAAoDx
        lpYDl3fGZlciZ/SPtThFfePGWg==
X-Google-Smtp-Source: AMrXdXsAyJ4lT+wvy3BcH9rELIN1iiZ36lxt2Jac4mrXesJxSQNBHvE03+2SPcfT+LWH9MtDPHmhVg==
X-Received: by 2002:a05:600c:4854:b0:3d3:5a4a:90ff with SMTP id j20-20020a05600c485400b003d35a4a90ffmr48472400wmo.23.1673266775279;
        Mon, 09 Jan 2023 04:19:35 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id x14-20020a1c7c0e000000b003d9f15efcd5sm2493331wmc.6.2023.01.09.04.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 04:19:34 -0800 (PST)
Message-ID: <0b32b198-09cc-803f-9ce4-8a516e784849@linaro.org>
Date:   Mon, 9 Jan 2023 13:19:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v6 2/6] dt-bindings: phy: Add QMP UFS PHY compatible for
 SM6125
Content-Language: en-US
To:     Lux Aliaga <they@mint.lgbt>, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        kishon@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, keescook@chromium.org, tony.luck@intel.com,
        gpiccoli@igalia.com
Cc:     ~postmarketos/upstreaming@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        phone-devel@vger.kernel.org, martin.botka@somainline.org,
        marijn.suijten@somainline.org, Dhruva Gole <d-gole@ti.com>
References: <20230108195336.388349-1-they@mint.lgbt>
 <20230108195336.388349-3-they@mint.lgbt>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230108195336.388349-3-they@mint.lgbt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/01/2023 20:53, Lux Aliaga wrote:
> Document the QMP UFS PHY compatible for SM6125.
> 
> Signed-off-by: Lux Aliaga <they@mint.lgbt>
> Reviewed-by: Martin Botka <martin.botka@somainline.org>
> Acked-by: Dhruva Gole <d-gole@ti.com>

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Krzysztof

