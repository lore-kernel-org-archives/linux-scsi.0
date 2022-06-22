Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25472C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 14:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358772AbiFVOut (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 10:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358746AbiFVOuh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 10:50:37 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC323ED21
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2022 07:50:06 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id v1so34716551ejg.13
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2022 07:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=4ruOCvOAEmoUdLQh3ey+6bqLOiu0xvMxMCbpqmFwoUs=;
        b=OeRxIzd9nZ8EWPSu2aJ+6lZbW+Xi4a9NtmKfcgCKy5B6154b1lDVK2X5LPN5OeHUmw
         tziY4sYx0rxsyzjYxrVVQGbqA9vvTXX+BuOm9rfpQ9IEC6o/SxhSMHIoYJ5zmBDDuUlt
         EIpobCAJzDoHRl3NFi3ruf2oBMBdE7Hcy0WMmCzem1tA8mQEoLQou/qNMoGJ2aSW9tZO
         Hu/Y5hDY52yHVscaQ11xjQBky2kKgJ+YNNhIEGnVJhdm/fA+rKHc/DY4Q8/SWJ1b27zp
         Ds9XgtQAa+fG9EqmkBiAI1QYJNfTB5Fv/XbTsMd6ftjpLGILbYFBukc33k+aN2NyrrJY
         4FTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4ruOCvOAEmoUdLQh3ey+6bqLOiu0xvMxMCbpqmFwoUs=;
        b=KPy9A0HrKGDHjJobHtBC0Nc5uRN6+rJcdKFTeCRyWK8059SB5/8aawBhd7lqrwmJx8
         kqs1dhY0IRcnSCkOF6gR16MYkPyMmHi7SETj+3t114J/15soJzrXFaGc7dhjb0WK2J0b
         bULuCj/LOHiPEEMDtxuexdcxnhQe5oZFz1cJ8gvAdA3XxQGiULJwuCYgdwqiLLSBBz75
         Fh6Ea4qAoHn1ZBPz/78DsFcu5SPcKWYd/wZ2uBo2M5T0wi5/FH0sbI6IMinHJQ9rJVry
         En0Xpg+lRygPtV4rhfQCM399XmDjTwrWkWDa6bOHSS9HFWCuwMwzye9lTEdebBRX83Y/
         2JkQ==
X-Gm-Message-State: AJIora8fDqDwPLhHq/7d+FMoxWYNq1MG5nm6LutAr8Rxu0KWfNn5WYEO
        0MU/rPvoe92nqbqPoFZdPzaaJoZAO1siqA==
X-Google-Smtp-Source: AGRyM1vteyKfwtr5E534VzKDwjdk2afkiq/TExdKehpSTsXQorJLF3v9ubUmlBNqNQXVQB2pHcH3SQ==
X-Received: by 2002:a17:906:3f09:b0:712:466:e04a with SMTP id c9-20020a1709063f0900b007120466e04amr3388409ejj.719.1655909405491;
        Wed, 22 Jun 2022 07:50:05 -0700 (PDT)
Received: from [192.168.0.226] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b0070abf371274sm9396702ejg.136.2022.06.22.07.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 07:50:05 -0700 (PDT)
Message-ID: <349ba57a-87c4-b49f-aca5-7d62d55068d5@linaro.org>
Date:   Wed, 22 Jun 2022 16:50:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 0/3] scsi: ufs: minor cleanups
Content-Language: en-US
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20220613100655.105301-1-krzysztof.kozlowski@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220613100655.105301-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/06/2022 12:06, Krzysztof Kozlowski wrote:
> Hi,
> 
> Changes since v2
> ================
> 1. More whitespace cleanups.
> 
> Changes since v1
> ================
> 1. Drop patch 1 (needs further work).
> 2. Rebase on current linux-next (including Bart Van Assche's work).
> 
> v1: https://lore.kernel.org/all/20220408103027.311624-1-krzysztof.kozlowski@linaro.org/
> 

Hi folks,

Any comments? Patches are BTW independent, so the UFS one can be applied
separately.

Best regards,
Krzysztof
