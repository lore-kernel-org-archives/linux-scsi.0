Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7389FC48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C1261284
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhFRW4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 18:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhFRW4p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 18:56:45 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE9CC061574;
        Fri, 18 Jun 2021 15:54:34 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o88-20020a17090a0a61b029016eeb2adf66so8853756pjo.4;
        Fri, 18 Jun 2021 15:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rzOxWgOfLVUoE/zhN+Hv/nujRU8lGHYED4ijbZLx+m4=;
        b=jgQ1L91cfMQM/qQBtomKGL3/CMrlamfrL+mybW0Oq5EoVtn1/rf2owYr0EW6eusISX
         Keeti/dkr07avw8/GK0HD2BAY14QF9/HdKR5r14+RYFzS5TEH/cKxQdpE2frMxNILm6h
         7+E782vXfI0pR0TjTZ3nSx5Hif2vlYqeRqfMubKLpICBzJB9kqQ3WGn6It0l8c7fRKSe
         lvtHemBK0xjasQh/nlBD+7+5l6UK0woqoX1kSvU7atcnFsNumIBQOihghj+gVNoG6/nb
         4WyNvVup2Hi6TxRk9E3XzfqRcMCoz6JLXpni15kT5amtWLCmpHTZVNXF4BuFhgIQh/cA
         Xrsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rzOxWgOfLVUoE/zhN+Hv/nujRU8lGHYED4ijbZLx+m4=;
        b=fwFMar0ISr+6do9P/1DxUcbz5trNNATc++k7xU3UQpLKllKupDa9Z94XV0DoyHXxJ7
         SdBzfxpapsg7FBF9k7ptlwnfoisGb9T4n1fYAGPYYOf6ZV5EPGTWFdzMawB8Tl0wgF0x
         MtozZn9P0QzEjn+quaCGKoFL3l/RXxFHwfQWIyRt/u+8lJiMBTUYvhYKWLojnx4TFtLi
         ow04/2DBCqzaQ/Av3htHiemmpKIkV8oHmaMBaBL7/edhoeJgiIwmGWBGsDxYfLMCdskA
         0f3J4uoEHm8sJot7An/jwM4boLRqctabwCVSb2Zecl0UJhp1bG8gEpeWbX/isYC0nbBe
         COCg==
X-Gm-Message-State: AOAM533JxK8amev5CxyEvBrWK3xMvjkTowbXkdIxJU+883roYp2BZbxd
        mYuu5lwfhl5UFCrzjAXkkQM=
X-Google-Smtp-Source: ABdhPJxgGabDW4kArlQJfK1SpOkSAWjiRe51TdEqINac9PPVSlB7NeY5Vf1fWnU0L/+pD/QFyPdNIw==
X-Received: by 2002:a17:90a:d3d2:: with SMTP id d18mr24467610pjw.102.1624056873737;
        Fri, 18 Jun 2021 15:54:33 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 1sm2893856pfo.92.2021.06.18.15.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 15:54:33 -0700 (PDT)
Subject: Re: [PATCH] scsi: elx: efct: Eliminate unnecessary boolean check in
 efct_hw_command_cancel()
To:     Nathan Chancellor <nathan@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210617063123.21239-1-nathan@kernel.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <7afb1139-79d8-57b6-b629-bc0a0d142687@gmail.com>
Date:   Fri, 18 Jun 2021 15:54:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210617063123.21239-1-nathan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/2021 11:31 PM, Nathan Chancellor wrote:
> clang warns:
> 
> drivers/scsi/elx/efct/efct_hw.c:1523:17: warning: address of array
> 'ctx->buf' will always evaluate to 'true' [-Wpointer-bool-conversion]
>                                (!ctx->buf ? U32_MAX : *((u32 *)ctx->buf)));
>                                 ~~~~~~^~~
> 
> buf is an array in the middle of a struct so deferencing it is not a
> problem as long as ctx is not NULL. Eliminate the check, which fixes the
> warning.
> 
> Fixes: 580c0255e4ef ("scsi: elx: efct: RQ buffer, memory pool allocation and deallocation APIs")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1398
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/scsi/elx/efct/efct_hw.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

Thanks!

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


