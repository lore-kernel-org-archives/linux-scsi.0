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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB68DC49361
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7E64613C1
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhFRWyi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 18:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbhFRWyi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 18:54:38 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A545BC061574;
        Fri, 18 Jun 2021 15:52:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id x19so5464440pln.2;
        Fri, 18 Jun 2021 15:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QBEReQMrLJnmJ7k9QX7jY95T5VJ5V7GviHdKGKUsvvg=;
        b=tII83pBLIBi/2wESwabagm4ntRSICChI31q+bE5qSHQG5f7yiBn50dgPVAlj5aCKh1
         0jYbWVMv1YTdVCIX1p8RtnSpdyog/uMidDqhFQqy1qsfcQNfT6Umb0KP5r09Ssbiy9hi
         36UQU+RxnvDCvoR6e3u3ln6f5TT7HshoMTQMbQcshMnqPkc97sSDDbfKuE91jHn2BHE5
         U/G1dQJHpoEzoE+IdwtK6/DsfHSsR2XJKoUbXs+wgXsW/6OC3DyUIC1lhK1bhnARk4cI
         hO5B/Gn0qEFgn/aqwBT88zAL1ZuhfRQiX55hj5c8EZg/5U8iKgIz3O8fcbxw5Jen+Jgn
         XRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QBEReQMrLJnmJ7k9QX7jY95T5VJ5V7GviHdKGKUsvvg=;
        b=suJsmNyjxW1xPacrMGtEDvLuXpkadSjBNC/p2u0l0wdPMNbToKn1xG+Yg0DvFZjTFz
         xwxDJvmGBDx6zD5WYaiMeQ4DvPuXuoiF4xbwTwiqOi0tlb9NI4k5fofOg5Q70tAkFkZO
         rQ9h3moCWn7GNCEmznq5pNKJk0aAmiOOoLHawak9SyAjCOXJVXvcE9d13vRsjIh+L6Bp
         FeCWy+GI63LIFrCRcbeDj23mE2+cnymio05WHVN3bHju+88JoSFC19ACHjajCLnf3YOS
         lI84JkEz9edmWINxQcC6RGE7ByGfEzyHAaMfXFKU5/UD++IJU6T62gBBrhXkuOfQ8JYZ
         aqIA==
X-Gm-Message-State: AOAM532wh5JFbO2yZy384fhxwFTfhhkb57HMQ89FzQBJ5Itpm5DJA5DC
        nXLCcA3TcyllkWwBEzaV2HOAfjlYuBM=
X-Google-Smtp-Source: ABdhPJw4yiHQ2vg2xEf7tsb0sifRldVovSyqJZweszGMsk3g7d2ZVYr36o8e+BOQ5kl/B4QsuCyyvw==
X-Received: by 2002:a17:90a:ea0d:: with SMTP id w13mr16079475pjy.51.1624056747314;
        Fri, 18 Jun 2021 15:52:27 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g8sm10218823pgo.10.2021.06.18.15.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 15:52:26 -0700 (PDT)
Subject: Re: [PATCH] scsi: elx: efct: Do not use id uninitialized in
 efct_lio_setup_session()
To:     Nathan Chancellor <nathan@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210617061721.2405511-1-nathan@kernel.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <bd2d2be8-8ec9-601a-14d6-aa4edb92859c@gmail.com>
Date:   Fri, 18 Jun 2021 15:52:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210617061721.2405511-1-nathan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/2021 11:17 PM, Nathan Chancellor wrote:
> clang warns:
> 
> drivers/scsi/elx/efct/efct_lio.c:1216:24: warning: variable 'id' is
> uninitialized when used here [-Wuninitialized]
>                        se_sess, node, id);
>                                       ^~
> 
> Shuffle the debug print after id's initialization so that the actual
> value is printed.
> 
> Fixes: 692e5d73a811 ("scsi: elx: efct: LIO backend interface routines")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1397
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/scsi/elx/efct/efct_lio.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


