Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C90C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 09:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245387AbiEaJ67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 05:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244889AbiEaJ65 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 05:58:57 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B9A5DE4C
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 02:58:56 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x62so4955566ede.10
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 02:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1Lh//yTGUbJi03monU+zFrkUN9l3qrNWeiv0qwPR1KM=;
        b=MVVRYI0ZN7SgTFaz8M/u06YGulvbFi62zDDqveL16HifTZgFBWaOwnMhkuxfYn8P+j
         WL52gYI9/y2DnkaFxlP8h9zAg37ru7axcu6UoM/ppAFX8L6/lWuCtYx+alWRh28Zn1r7
         dz54UR3QvN0NY3hkYETDMWeeWOhyhd19AENImdywvWb/Ie3thjvBTvm3EJPH9FhWpLCq
         dLZedltAZfb6lOoh+5BJZZZKdY3W5dKwBIiNGa55u4xLFNyGBTVpeK54TRKAYJ9Jvrt8
         QRWzktIT7LePgIAbsAvL6NGXISMzoBFmUsnrVz8uPk8IjcqjESaezNpttB0KjgY5NGqq
         XXqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1Lh//yTGUbJi03monU+zFrkUN9l3qrNWeiv0qwPR1KM=;
        b=GiK7dbqrCqEY3DG0MqYCbld403xBi2JodcKyIpAsKz5BWpjm9ZzqKBj+ehuxu4Z9Hq
         6vNlzaMo2VBP9l5V0Z+PKHdXEcxue+D+qpq8KU3tnaLaUCU6TyjsXpZTdJ0NmcvhCTsQ
         EeR3+6zFBfoEpPrdeaW2vDYO4lBj6N/++jv4VkVNSVIHpDHthWcB2Wz48fCksSfUBsyO
         eL5TV6aA9NvYFVsiN7S5PkoKECEHWu8WsHq89fN2VY5dmNHlDxCdJNAet5vtK7Oa2aQc
         jyPNLifPOPBne5aUJfC20/af2jvoOsJFimQrUQ4s3clAXud5QRWF4z01x2pVp7uuCfYv
         0w0Q==
X-Gm-Message-State: AOAM530AgEZJBR9SMXuY0HnFX7l3x/wVlzCkfS0TQKeLp5pXc4IhEID+
        WhjORzQgns8QSoMRAMbq+V1gLQ==
X-Google-Smtp-Source: ABdhPJy69vdQQFHMyE72a/U4IgyhyOR2N6lSQOXZujz+0wS6/e2q5DrHOVp8H/lzBSwKc7yAEfijLw==
X-Received: by 2002:a05:6402:3705:b0:42a:ba63:18b7 with SMTP id ek5-20020a056402370500b0042aba6318b7mr62888334edb.296.1653991134894;
        Tue, 31 May 2022 02:58:54 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id 24-20020a170906309800b006ff99e400f9sm1161939ejv.96.2022.05.31.02.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 02:58:54 -0700 (PDT)
Message-ID: <d0904cb9-e765-f0f3-737e-bf365c1cf444@linaro.org>
Date:   Tue, 31 May 2022 11:58:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4/6] dt-bindings: ufs: exynos-ufs: add fsd compatible
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
Cc:     devicetree@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, chanho61.park@samsung.com,
        pankaj.dubey@samsung.com, linux-fsd@tesla.com,
        Bharat Uppal <bharat.uppal@samsung.com>
References: <20220531012220.80563-1-alim.akhtar@samsung.com>
 <CGME20220531012351epcas5p389e28e28a48f9bb14a52fc81c417296d@epcas5p3.samsung.com>
 <20220531012220.80563-5-alim.akhtar@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220531012220.80563-5-alim.akhtar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/05/2022 03:22, Alim Akhtar wrote:
> Adds tesla,fsd-ufs compatible for Tesla FSD SoC.
> 
> Cc: linux-fsd@tesla.com
> Signed-off-by: Bharat Uppal <bharat.uppal@samsung.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
