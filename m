Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8C2C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD12613BD
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhFRWwl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 18:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbhFRWwk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 18:52:40 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB526C061574;
        Fri, 18 Jun 2021 15:50:29 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id i34so3430364pgl.9;
        Fri, 18 Jun 2021 15:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SNyDGkX9Ukd5scsSsx1mRm+k+4LOQgsMRHMLkmzl73k=;
        b=Tzl4zMuYNWzbP5/C6fLlIy37r5yYy0/qQCJCG6LbJWYTkgQFXGdAWQlMod5SMbhoKb
         Ph+JZ0jL0x1J1Lah+wDUSX7/cEPctjDHKjIfmiNWyvrflA3eU+bimC6Bsai3/HlCDXBk
         H+y9VvWTA0ZwtipohajMg6FNsHedLmALsJJ0z9QRoaqQvVMrZ5gL0SsRAKLzFvNGqqzv
         wLPELf5p6kLY5nEv6Yvzx0LLLgscWXhHK6XrNSe6QvegmynBmWon+xesskooq6SKwiGf
         iPXVfCUpHcjDZTCU7/tgj2Gus2Isb3ckF3mLVsNBdTU8qHgt3rbxCsWAGDihjI5IZxQD
         7oXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SNyDGkX9Ukd5scsSsx1mRm+k+4LOQgsMRHMLkmzl73k=;
        b=D4dcQbC9zstPPrIZIyb9UsHefWUnkKS1XuSVYxCKxgXt4RKB2LJhAPS2iLjTRW207R
         4VThEb/IRi/Nw9GqeT52G6b2plDIa2zUOe0XuR/fKL/iaYRfENeCPRLCs8o85UZNUhUO
         huUYIl6Qu9IlsbwitnRBd2sQDHsrtgerlWb0SJGdl7xxz5kTYjKIl6ktR4GmkoVqz6Nj
         OIjbi2wzaWGyhpTxfhM8LDOnYIRYvsNllqGkGw0+2GUaeTu0wjGCh6MBS3hfZPfs44kU
         0fxr7aNIMEwnZGDwvXvsJm3JnaRB9Gr1tuh5SzvJp4JzBJAOTIuLZWrEucpRi1lvrrQU
         tXmw==
X-Gm-Message-State: AOAM532euQLFaT9UV46Pz5KFOGvM9dE626dMEGN/TihZLZuhNfmwN3U3
        kIyb+X69pR8qOGfMF+cn9ZIESD+L9nc=
X-Google-Smtp-Source: ABdhPJzXDtxt0EPBs1yBhC5rZmwo4WwV7vOF2JNkyC+v/CKUxbK5agTtt73wTl77N3/3peKNoAYzrw==
X-Received: by 2002:aa7:9901:0:b029:2ff:17ed:feaf with SMTP id z1-20020aa799010000b02902ff17edfeafmr7145045pff.34.1624056629409;
        Fri, 18 Jun 2021 15:50:29 -0700 (PDT)
Received: from [192.168.1.27] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id 11sm8892018pfh.182.2021.06.18.15.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 15:50:29 -0700 (PDT)
Subject: Re: [PATCH][next] scsi: elx: efct: remove redundant initialization of
 variable lun
To:     Colin King <colin.king@canonical.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210616171621.16176-1-colin.king@canonical.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <3be6287a-9ac3-2837-11b2-a0270522a607@gmail.com>
Date:   Fri, 18 Jun 2021 15:50:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210616171621.16176-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/2021 10:16 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable lun is being initialized with a value that is never
> read, it is being updated later on. The assignment is redundant and
> can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/elx/efct/efct_unsol.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

