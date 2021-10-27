Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE04C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 13:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 138CA61052
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 13:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbhJ0NSs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 09:18:48 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:45642 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236464AbhJ0NSs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2021 09:18:48 -0400
Received: by mail-pf1-f177.google.com with SMTP id f11so2681383pfc.12;
        Wed, 27 Oct 2021 06:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RxGdKvpK4OULd8cS2o0dRz2hnuGIH9NxZACigE+2c3o=;
        b=0hJU7OYJ57SKm6TwWg4o2uMAwYWTRHCwQSnuTi0wm+q8s7W4ISGRbtFrTdGnao6/MF
         5NLbmDusZsIolJaSmyIEJTR4fuiP78zt0r6JE5ptppO8yRbGIPqnNJGDb+oS8wqqtNKW
         ElQu8ZdMJjyUHqreYagz1pA2VXTL0e1a26Hnp703fLgIqnIFVTBeTC7svX1eeMOC5kjF
         +mDnfpo8Er2QpSI+AI00KSvriZfKMpyLyohnW2WXivC5oI9uvkK6Twzh7tw8YznkMRm7
         q2uQX9Dm1yWRKYa4NdgXB7rZihrQA0MUKQOAALVPExwrmW/j8lka025VzliWzF9CE0nX
         XF5Q==
X-Gm-Message-State: AOAM532vmPS+bUvm9uZI7FzBNASr0o6hP9GrSIYeQwXl/U1i1MUen0nS
        fn9uwab6qx/vygDr7b583J9gBeML1eo=
X-Google-Smtp-Source: ABdhPJwQuj8Y+OK3dVAEU+H0eFs40hz4YLj2tBsARNnGsRdeT2i6wXcAZBZ2XmC0rwYKEQ5bCsuDKg==
X-Received: by 2002:aa7:8246:0:b0:44b:4870:1b09 with SMTP id e6-20020aa78246000000b0044b48701b09mr33249471pfn.82.1635340581882;
        Wed, 27 Oct 2021 06:16:21 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id t22sm7404113pfg.63.2021.10.27.06.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 06:16:20 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk@kernel.org>,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20211026071204.1709318-1-hch@lst.de>
 <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
 <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org> <20211027052724.GA8946@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
Date:   Wed, 27 Oct 2021 06:16:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211027052724.GA8946@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/21 10:27 PM, Christoph Hellwig wrote:
> On Tue, Oct 26, 2021 at 01:10:47PM -0700, Bart Van Assche wrote:
>> If blk_insert_cloned_request() is moved into the device mapper then I
>> think that blk_mq_request_issue_directly() will need to be exported.
> 
> Which is even worse.
> 
>> How
>> about the (totally untested) patch below for removing the
>> blk_insert_cloned_request() call from the UFS-HPB code?
> 
> Which again doesn't fix anything.  The problem is that it fans out one
> request into two on the same queue, not the specific interface used.

That patch fixes the reported issue, namely removing the additional accounting
caused by calling blk_insert_cloned_request(). Please explain why it is
considered wrong to fan out one request into two. That code could be reworked
such that the block layer is not involved as Adrian Hunter explained. However,
before someone spends time on making these changes I think that someone should
provide more information about why it is considered wrong to fan out one request
into two.

Thanks,

Bart.
