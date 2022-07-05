Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D615C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 09:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiGEJdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 05:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGEJdV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 05:33:21 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F67B199
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 02:33:18 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t19so18925283lfl.5
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jul 2022 02:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yzfP/lbnZ03H0j9vVtb9A0tPicYwAQrUmnwfp/loKHw=;
        b=ZOIMt23f6Ag/+weSlpQFCEQcsu2IFtieWj3iKBkDh1rPGdNLQvdvdutGW5RHTRhDIB
         LwnzP7O64wgm+ITODYjdvsDzOqa/Ol42WVzWloMSvoKOaUNZhSCZcMfrF5Dvs8x+bcgN
         OkKOn117XIFKF2TmmvLDccTeGH3VYfZ49vqwtvpsREbccTdt+e4aRajVdIzIapj71fcW
         m9fZ2pr1axyzjOo5Qfjv1mC14GCh3WXYNP0pxrEdr6jautoFW785zp5hc3xnGX2isPXw
         RfElRpgCpWu1pfl6sKQhIyrNW1lrW4zZUdtfO9vBeXgusfGFlIFG1SesMypypsDvl8xf
         CQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yzfP/lbnZ03H0j9vVtb9A0tPicYwAQrUmnwfp/loKHw=;
        b=pvCa2BpYKHpGOHnVL4d/DXQUKdXce7tu79TqC/5WDz+Ob2uk3NnkIqGv4YuFkzxIQV
         G+KbRTVFzQfcjsvCezT27kd73xGtMH0UaPQtqCTWGnwXLdIlur0dyM+zwCJu5a1DcUbT
         sWJkS2PRW95yww4IYI4VbAFQur8dZQ8c4Rg6v4LWEHW0lvE4BZiPLEWuvtdRQDymvICX
         yLrOMR2VvIznmr8uGG29COuscJterKjNDsKupyyyg3WFCQML0dBbN5Lh5iDRXtunHnPa
         0TPYs9P9VOxdriCJVXu8/iWHLg6hFhy4kRyM3AX6j3UYQDsTzuVX4EflqXnkxeIfOIKB
         tmhg==
X-Gm-Message-State: AJIora/rcayFR79ANAuvM1r0zfTpyD/8X8WO9PdvYUd3spJgSz8rbXva
        jEO6xcWo3Z8wlbzBkcXRbEM8WA==
X-Google-Smtp-Source: AGRyM1vxnkUSDiWxBI+uKP8agxowY1mJtD6LNtIkhsrjovzczkpcL/6rBXczfAQWWPAnn59xwqEgVw==
X-Received: by 2002:a05:6512:529:b0:483:535b:dc28 with SMTP id o9-20020a056512052900b00483535bdc28mr1946916lfc.540.1657013596716;
        Tue, 05 Jul 2022 02:33:16 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id z7-20020a2e3507000000b0025a7f1065fdsm5250994ljz.107.2022.07.05.02.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 02:33:16 -0700 (PDT)
Message-ID: <f025408a-822d-328b-2c45-206729ebbd91@linaro.org>
Date:   Tue, 5 Jul 2022 11:33:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/3] phy: samsung-ufs: ufs: change phy on/off control
Content-Language: en-US
To:     Chanho Park <chanho61.park@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <20220705065440.117864-1-chanho61.park@samsung.com>
 <CGME20220705065722epcas2p1e93a8511b906d5e111bff48a312d0603@epcas2p1.samsung.com>
 <20220705065440.117864-3-chanho61.park@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220705065440.117864-3-chanho61.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/07/2022 08:54, Chanho Park wrote:
> The sequence of controlling ufs phy block should be below:
> 
> 1) Power On
>  - Turn off pmu isolation
>  - Clock enable
> 2) Power Off
>  - Clock disable
>  - Turn on pmu isolation
> 

Makes sense.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
