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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1315AC49EA2
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED3DB613DA
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhFRWyM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 18:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbhFRWyL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 18:54:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CC1C061574;
        Fri, 18 Jun 2021 15:52:00 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e1so5446527plh.8;
        Fri, 18 Jun 2021 15:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XtAc2iaBkh0MFJ/RgpxyhZJCSEFtZcKmjlCYhnF0xx0=;
        b=UIOKBya2RsUCpO2S1EO7jzLDOCzwlPBYbeSQhhUmL4069BYYO90k9KekFJOEVrLAXT
         kXnNcQbcTYD/iaY9+m5mXHFkhpUN+JYLV2ffGtqHZHmI9DMB71jB0QhCqoZKemOPRvVq
         lGhbhsL9icbOMRcfST4OpvCLAXtBKudaI/2msrkmkEm6HIcEFqEFOk/6WtzfNgWSTS4l
         vIvqT4xyO14qVMLYgbRxhDpj0IzqOJluiAjGz/fauiBjOMwqp0GyycUGh0JrUBPAgXGX
         eVHD+CkrbYoAGcFSD4IF6Mh/6+rd6yeUClhkP9fndP9EKHNbvi9jG2B8PSISvlQGSPj4
         BDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XtAc2iaBkh0MFJ/RgpxyhZJCSEFtZcKmjlCYhnF0xx0=;
        b=ljPksrNtT+QJp4TOl/IX54br6agdRkWZKEQQUUOeAH9ZRUkymFtMRyM4SQdsbnOLXb
         dt02I7QMj6fvxgqKKh6G7GfnQTagtbKJZ+FMcQF3GbVpPZdYgd6mymxAEO7ymFycIcmU
         X8LFD7PIIUiWSBr93u2KWDaP7mhNORGs85GtvcKuYmm2pcJ9t2X+IPxib+DHd4O4u0kX
         H3JdE/sT7QEdu1l597xb9OYWmDD6Q9IQprGwyJup0xQgDYyrFaz2/gk8TSt1FrOZxdet
         KxgdNndKTwb1TY6+eCtSnAO8IJ4WGewOAQ9Evy/7w9E7qXOuMjbNL8Ro7koGgLKxGbP/
         KFMw==
X-Gm-Message-State: AOAM533/UnJAzu/8PSVXrkOxz/HY5sNu3/ZddzLyxEhrOxa5Qx1Eb9EG
        zpHCN/GEXEHOzivB+6aizQE=
X-Google-Smtp-Source: ABdhPJy/2yIgoXuUaErLDWg8/Oh8XI6N6cxRKxTTgj3pSXmC1M+byn6Zv0hSYgDZCkooQcres6OCpw==
X-Received: by 2002:a17:903:2482:b029:fd:696c:1d2b with SMTP id p2-20020a1709032482b02900fd696c1d2bmr6822745plw.24.1624056720360;
        Fri, 18 Jun 2021 15:52:00 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h8sm8924337pfn.0.2021.06.18.15.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 15:51:59 -0700 (PDT)
Subject: Re: [PATCH -next] scsi: elx: efct: Fix error handling in
 efct_hw_init()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
References: <20210617024837.1023069-1-weiyongjun1@huawei.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <2f8e9da0-fbb3-ecb8-5342-77ceb11183b2@gmail.com>
Date:   Fri, 18 Jun 2021 15:51:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210617024837.1023069-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/2021 7:48 PM, Wei Yongjun wrote:
> Fix to return negative error code -ENOMEM from the error handling
> case instead of 0, also fix typo in error message.
> 
> Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   drivers/scsi/elx/efct/efct_hw.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 

Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james



