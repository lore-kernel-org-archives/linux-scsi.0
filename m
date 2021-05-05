Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BC6C433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 19:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3429261185
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 19:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhEETmi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 15:42:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36670 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhEETmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2021 15:42:37 -0400
Received: from mail-qt1-f199.google.com ([209.85.160.199])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1leNOt-000391-3m
        for linux-scsi@vger.kernel.org; Wed, 05 May 2021 19:41:39 +0000
Received: by mail-qt1-f199.google.com with SMTP id e28-20020ac84b5c0000b02901cd9b2b2170so1788719qts.13
        for <linux-scsi@vger.kernel.org>; Wed, 05 May 2021 12:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KMfcNsjXlZ+tgGRkWqvnbenP9g4xeEBy1YBavjn3OpA=;
        b=UJ2JsHeOWMf0YdN8HxkWBIZq5Sl2wAPVF3gp1xgF6Z3DwC1FjkdcwWTta+PhyOzqD+
         gO2Jd0Jvtjna2thUrXAcwHDlm7xF1kHykB8CW/XMh2x5VzCA+OZivFYqi9jpirpLhpf3
         q7sMB3lIDUXD7pIdRAekJiayB/hUxWd/Hl0K6lqL12RtVdoPSiJ1l2IjYs3n+/j8GWSL
         d7cknG0CsNv29JaxZ+T/ZnoVJgCWxG84j7PwcLd70UBAaYHiiceE70HF4thVewVGPE9w
         QW4LC/9WnhW03wocwR9oWNmwOW5dxtlSGqwsFkXwv+aQneKvukoBncYEhiwqkgytJLv+
         MwTA==
X-Gm-Message-State: AOAM5306cceXZ9OmApWQY6LRhrcHsnOq8LORZpzc85n1grLLUMRJYhh+
        5dId8UYmJSab1JB3KhPrW7PP37PDO111RKFWS9BIocezqyM0rd97E+oZ6bR0h+G2iYQNCsXPb0p
        FbQnPkhNzTNgSdtcR3pYq5/37P4sCKy7diJEv/5k=
X-Received: by 2002:a05:620a:118a:: with SMTP id b10mr381188qkk.263.1620243698212;
        Wed, 05 May 2021 12:41:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjB1fkQLdzlaXKjnl6zTIgJDOAyEuudFSA92e4UuJZVegXPWitGuVebLofp0UL7pHqzFoZZg==
X-Received: by 2002:a05:620a:118a:: with SMTP id b10mr381174qkk.263.1620243698062;
        Wed, 05 May 2021 12:41:38 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.49.2])
        by smtp.gmail.com with ESMTPSA id e5sm172640qtg.96.2021.05.05.12.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 12:41:37 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: make a const array static, makes
 object smaller
To:     Colin King <colin.king@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210505190104.70112-1-colin.king@canonical.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <0e90b057-3a87-bec5-c0b2-46c49b191651@canonical.com>
Date:   Wed, 5 May 2021 15:41:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505190104.70112-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/05/2021 15:01, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the const array granularity_tbl on the stack but instead it
> static. Makes the object code smaller by 190 bytes:
> 
> Before:
>    text    data     bss     dec     hex filename
>   25563    6908       0   32471    7ed7 ./drivers/scsi/ufs/ufs-exynos.o
> 
> After:
>    text    data     bss     dec     hex filename
>   25213    7068       0   32281    7e19 ./drivers/scsi/ufs/ufs-exynos.o
> 
> (gcc version 10.3.0)

I am not sure what's the benefit here - you moved the code from text to
data. In total you decreased the size for this compilation settings
(e.g. compiler + optimizations) but that might not be always true, right?

This has effect on the code readability - line is longer and reader
would think "why this was made static since it is simple one-time const?".


Best regards,
Krzysztof
