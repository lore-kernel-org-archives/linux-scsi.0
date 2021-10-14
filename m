Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780C7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 16:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5844461108
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 16:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhJNQti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 12:49:38 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:36430 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhJNQth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 12:49:37 -0400
Received: by mail-pl1-f175.google.com with SMTP id f21so4578977plb.3
        for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2021 09:47:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SnT1bDgVWQThUZIz7cIhy4mGNISUU2pngNrwF1Nwvy8=;
        b=JWzoSANhHlARbkXv5Ik5fr8PFWXzJA+W+3W3EgGfy/Czzkt8wSfSujxEdbYoE9cMJ6
         LPxHPEdtR9AtMYglrlhv9HWi0MzINzp9pfzERzcZ99Q6kcsJqz5TtRu4D/by5STcD5LJ
         hRnpU2zhPmamQzMYdXq0wlDQIj8t6N4W7tFkGax/iaF7S6LXYpRgJHKjjMkCShucMFBd
         PDEBGhXcv38InBxGZ7gnQvWRzhpdVf41SxdNIK/Oa/XJGtgTvBORelMazdvntZzfVg3k
         PYCqa4f+6dCpGxAZ28n6CYT3RcNJDVMRukRAU3sf4daFVGlX5EeYdFM09u7U39rD3UTd
         kU7Q==
X-Gm-Message-State: AOAM530oTwIqZ1MqHKLfYMLQ8NILguKjcFFKKywxkd7jQyi22MAC/wT9
        M4ORv7dK0fvHUILiUtKNTaN3/ICkeXE=
X-Google-Smtp-Source: ABdhPJwOwj1EdUudT4WzOJfhO/RR6GrsFW6Ta8I9N3J7Vgel4wR2pUquhXZdySlmZGJ3PLzNaAj5RA==
X-Received: by 2002:a17:902:f691:b0:13f:2034:7613 with SMTP id l17-20020a170902f69100b0013f20347613mr6047412plg.81.1634230051544;
        Thu, 14 Oct 2021 09:47:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:689a:4b1f:cd10:549b])
        by smtp.gmail.com with ESMTPSA id v20sm3125136pff.171.2021.10.14.09.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 09:47:31 -0700 (PDT)
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix task management completion
 timeout race
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20211013150116.31158-1-adrian.hunter@intel.com>
 <20211013150116.31158-2-adrian.hunter@intel.com>
 <40259621-aac4-e69f-c230-6376bf4d3e36@acm.org>
 <235af725-5346-d830-b62b-21b729aa8703@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <58b1d411-cb88-468b-e1a7-f7c2f04c8333@acm.org>
Date:   Thu, 14 Oct 2021 09:47:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <235af725-5346-d830-b62b-21b729aa8703@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/21 11:02 PM, Adrian Hunter wrote:
> On 14/10/2021 07:14, Bart Van Assche wrote:
>> Wouldn't it be better to keep the code that clears req->end_io_data
>> and to change complete(c) into if(c) complete(c) in
>> ufshcd_tmc_handler()?
> 
> If that were needed, it would imply the synchronization was broken
> i.e. why are we referencing a request that has already been through
> blk_put_request()?

The scenario I'm worried about is as follows:
* __ufshcd_issue_tm_cmd() issues a task management function.
* No completion is received before TM_CMD_TIMEOUT has expired (100 ms).
* ufshcd_clear_tm_cmd() fails.
* The TMF completes, ufshcd_tmc_handler() is called and that function 
calls complete(req->end_io_data).

Can this happen?

I agree that this scenario involves completion of a request that has 
already been through blk_put_request().

Thanks,

Bart.
