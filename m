Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0935C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 16:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94023610A3
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 16:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345277AbhIGQ41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 12:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbhIGQ41 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 12:56:27 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E1CC061575;
        Tue,  7 Sep 2021 09:55:20 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j16so8646709pfc.2;
        Tue, 07 Sep 2021 09:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fo01n+oht3lwEJyeQrCoe6KGpWuXH6sm5NGKluVcVIg=;
        b=LFIdP+U7Iy++SMozkDbn1A+ei8rDjByZWsek36sc+DPewZshw3o11baFsUXh8NxHD2
         1SCt+C6R1JVqpf+i0FwudI+7/TxKXjMfNIOOxvVXjtGz5F4x7jsC5VLaNV69fi8oFuZv
         cbn1mZz4bNPQEjz/rOldefzEBxFq2TyX7GKuT6B5qNiXHyMeY515Prcz77pQrPs/oKaw
         UsH9r6D4ptR1fpeS0MCTOy+0yqyLQjDc/zwTK4+tZgjVCKNTFLyeRa2K6udHvq1vE5m9
         yl3L2Lfs8PLKc8tO7pdhHYp9qkuNAtRzZpqerJP2zNFKhzghKl7eN07W2c9VYdAwq/+L
         mxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fo01n+oht3lwEJyeQrCoe6KGpWuXH6sm5NGKluVcVIg=;
        b=Nsb4pTsDLD0VQXkg8KrqWpob0enCXR9sbjlv3oAJWsPsh3nieLcxl9sBjINbu6zktb
         PTgtVwdJjrNKUDKciSFEqPO9YF0LFf0rN3iqmXOtBIc9unzNps+G2kqB5qjnua91lmC6
         wQSuv3/LwRlwMDfthL1TpwnSQtzghuwVVWJ4DDs9zgkusED8efNJoqgZAvgEjaQCaZ2G
         nBCwadl/WchtCBRwdSr3OZ8ypPdzL4XYR6pDB3eeR5Lyg/lr27bSCA4TsKN9o+cVQrcl
         Dgz3zYHbDA8Bx390cqvMf3sR3GUIeBSUUK2tdBfSJIRPDAhtG8vrOfeUd2Lq28hoUMWq
         cKPg==
X-Gm-Message-State: AOAM532nMF8ezxryhfEOupe8jHE1u22aCjEWp596C1q444gBcIf7bhgv
        CY55AT2iX5iR29uHyuMeJbs=
X-Google-Smtp-Source: ABdhPJyA7g73nobmCRmNnC9ZtQDCq9alkwEM3kPNXBGC/NCYT3AXahvI7A8NdPr/2dFr9GzsFtVfWA==
X-Received: by 2002:a63:704f:: with SMTP id a15mr18037290pgn.120.1631033720601;
        Tue, 07 Sep 2021 09:55:20 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gw21sm2865041pjb.36.2021.09.07.09.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 09:55:20 -0700 (PDT)
Message-ID: <8edb44da-87e3-7e81-c9a8-54b27dde2fc1@gmail.com>
Date:   Tue, 7 Sep 2021 09:55:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] scsi: elx: libefc: Prefer kcalloc over open coded
 arithmetic
Content-Language: en-US
To:     Len Baker <len.baker@gmx.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210905062448.6587-1-len.baker@gmx.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20210905062448.6587-1-len.baker@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/4/2021 11:24 PM, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> So, use the purpose specific kcalloc() function instead of the argument
> count * size in the kzalloc() function.
> 
> [1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>

Looks good.  Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
