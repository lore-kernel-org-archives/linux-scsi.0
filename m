Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2ECC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF02C6144D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243691AbhDUU1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbhDUU1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 16:27:04 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA861C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 13:26:29 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id j7so21618303pgi.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 13:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XAVOIDIT29gEq9A8bJHVUX1zMMWy1o1cbTnum6jZOIQ=;
        b=r99thQw38hxWd30rahsiZ29yZotcHz5M0gbkkj+tCNcn0dk0YqCvU634nb08R43DWq
         TLa7OLDaeagcDCVd4TDFIAsdOhIDy/7cCwX0RFETPDOLmr+NxebNBezDUkGVARfoqvvf
         3+EFVjQcSv7DwEEFyFco4ZBiWaH81/LMi5S1xNirSNLoJ+HsuZ8ioX7BRhGldtJ3oxWy
         6DkAaND6ZCIpJZu17OQnYb4kTvjyvJ4aRf/QhcI1zlpQxhPIk70u0042EnUSK67uaV55
         FBMzARfMK+Tg7D2HgYMS6mIpIBejrhumruRb0tKm1pEQ/fTDoX4/rt4s6zeW4LgKIpQ5
         Owbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XAVOIDIT29gEq9A8bJHVUX1zMMWy1o1cbTnum6jZOIQ=;
        b=JHVtsdfO6V//b3wblLhghZ8IUghqew6HVcV+1Fcf5acvXugLdL+GPM4vmSw/quulfS
         S7T1Ibc60uiMVomYvhFEGoB1flFQPindoeMpPN6hbwOTr752ySEIG+wt/vBNZNT+TT05
         nl3dy8crlwEwHggR2rjdkHqVpr+NWT/Kx05iuMuDwuMr0jep1CiG0REHseUPlTNrQko7
         47LpXHGuCJlQ/Qprp8VyA98cL1/jsLRlnRNqg3bvZ/QFKtMtTTv3vI50VL1SLsmgnKEB
         18JNJKUhLAGEE3yFHD8JUSnuvPONHD3USohK66VSRT4aDszSCNH/L9FtLml+b3jPjFKZ
         rdog==
X-Gm-Message-State: AOAM533lwHhatGsTqPFgFc139rQFzvfxcNUU1At4JUj0TvbmCkzqbAEF
        TaScQOIV23gfZJpiMPplO2Lgqv6u/b0=
X-Google-Smtp-Source: ABdhPJzYDeLPa/8H+o377obJHwdDA9Lac9a8jYDu3OfTaXLUupYnZukrrLa7XWX3uTHJGrIZx2aAZw==
X-Received: by 2002:a65:4c8e:: with SMTP id m14mr22717100pgt.377.1619036789368;
        Wed, 21 Apr 2021 13:26:29 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mj13sm207644pjb.9.2021.04.21.13.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 13:26:29 -0700 (PDT)
Subject: Re: [PATCH 065/117] lpfc: Convert to the scsi_status union
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        James Smart <james.smart@broadcom.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-66-bvanassche@acm.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <7bcff7b4-2b43-f286-8e76-10e1127f3acc@gmail.com>
Date:   Wed, 21 Apr 2021 13:26:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210420000845.25873-66-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/2021 5:07 PM, Bart Van Assche wrote:
> An explanation of the purpose of this patch is available in the patch
> "scsi: Introduce the scsi_status union".
> 
> Cc: James Smart <james.smart@broadcom.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/lpfc/lpfc_bsg.c  | 114 +++++++++++++++++-----------------
>   drivers/scsi/lpfc/lpfc_scsi.c |  66 ++++++++++----------
>   2 files changed, 90 insertions(+), 90 deletions(-)
> 


Looks good

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


