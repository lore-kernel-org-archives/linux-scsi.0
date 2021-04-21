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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F37BC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0675261403
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbhDUUWn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbhDUUWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 16:22:42 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048AFC06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 13:22:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id p2so15570149pgh.4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 13:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K8TvJkWFWDCXQphHIQQLPiTFnIEaH0rpwqcjNq3czxw=;
        b=OBGh76NWVhQtiSvZptanhVhaq0q7xKd0lJpfn7czImKvVNuBsl5fE6dDbWMh8GbTV8
         3s85ypKxhhYlIJ2rqhITOBqG1zlhYAwfFY8u8n3V/whFbcYtsjFKSWsgeyuBSk00iE/u
         Myxh6Wc+NpLU/wM7sk8eqlm8V7o6MQp3B3J5c6Y5SQ8WxdZvpYbHl5Ywmr6q60RHGrwv
         Hu73dUQd/jeyedayKov5QVmjCJV4sr5qkrDh2xUp50owFaULhfW32zDP6Le2Jy0HBrcw
         0M7aXQiJUjqkxrHvR53L5gs9jXkl3QJz71nE06aeUyIosFdlu1+yUY1LnlYX7BWZuIVG
         uw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K8TvJkWFWDCXQphHIQQLPiTFnIEaH0rpwqcjNq3czxw=;
        b=jtA6nJSlOsKUEGZ/1k8cLQtw8xBOhpbYZ3SfbHuA15xGwWNNFapfcm/FLRd/i2QcGf
         iK5MmDCWq3n3ywvNWbou93HDwlJV/6+GOoz3S9jcyvp2pcuX23zJ4kvGvUCXmmkF6EGp
         CaqQqXK8G7ezc7VCjuhbtYXkaYcDi/VZhnBSXAYRlRJnJCuBoze37mfLR6EAEbezR+Mm
         EDUXFEyG7HCUvWhfVNZtMl/Ht9L06yJ62lqawPxoAYKwBZOPnTuXevDCVCTWeZKyrQQF
         C8t22oC4CrN/QTUA5GDlsRHrt8mYdgLn/WVfluKDUB7TTepbep/Mmo8R2yb67eg4LCql
         PEnw==
X-Gm-Message-State: AOAM5313mZSw2j2iY7Yeg+N4BOv65jC+3LlijhkVVOTAfb7zOUg42n2J
        vvXCIRftxyNhOCu8LNH4XE0=
X-Google-Smtp-Source: ABdhPJxVK+jN/iS1tceg+k+SMOwjv8kOXkBKJUsHNOD2vxqHabQ6zPLwTlNKC+bYO8Sf5yKozgtepg==
X-Received: by 2002:a63:da10:: with SMTP id c16mr13746530pgh.221.1619036527540;
        Wed, 21 Apr 2021 13:22:07 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o134sm149492pfd.66.2021.04.21.13.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 13:22:07 -0700 (PDT)
Subject: Re: [PATCH 007/117] lpfc: Reformat four comparisons
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        James Smart <james.smart@broadcom.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-8-bvanassche@acm.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <9d9b8727-b9fc-8c5d-d536-6d6360674180@gmail.com>
Date:   Wed, 21 Apr 2021 13:22:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210420000845.25873-8-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/2021 5:06 PM, Bart Van Assche wrote:
> Reformat four comparisons because otherwise Coccinelle would make the
> formatting of these comparisons look weird.
> 
> Cc: James Smart <james.smart@broadcom.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
> 


Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


