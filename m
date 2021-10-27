Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A662C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F6960EFF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242194AbhJ0PIk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 11:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbhJ0PIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2021 11:08:35 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9036CC061570
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 08:06:10 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id w15so3279778ilv.5
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 08:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y3PaPhrrv3Z2xSTRHzeezZmom3VD5EGJ3zccDcfH5Bs=;
        b=278d4Ix7ZACF1BO0JunHIKIkqvFivWBBMI0eo32xSy+ZlizEW3pDun+ZvWoy4i63dK
         9csBCcLL5ypE6BVLTtahT81/rPN+qbBitM/qXpGis5ykjhjLEeAfbU1H5k7BhQX4HQnf
         vpgH1rDcZ9fAvOdWtFQAwfzljDia0EL7KvRF+MwLMvL4p2ul+fS6dClnp9btAc2Nrypq
         scC5gPfarjUukWH/kADYvfMtYIQHmfssvSsD94qGVTueAL3eUpnTJNn3XLR0frr9uNQw
         8TrkWUHBebwP0i74heIoDsk7BDOBnQqrX8LlBNEIGYtuTt1N+NlOs70htDJ5aPfjBtgl
         yV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y3PaPhrrv3Z2xSTRHzeezZmom3VD5EGJ3zccDcfH5Bs=;
        b=G6rydrHyHvMkJv7WH5bmF2tNUweOcjKtvxVL3rKzzlHjSXmIl72VK7pGcs/M1i9YIp
         TCVaYu4fmlLkTN4LtF2uVklUcwZqI64Tyuu5rdoALKJ9DrrXXDCTLZ6ucV4cdwnHNZXp
         8xMUxoWlFwEPwx59ZsEoN0xlSqrONt5IO9rUHtw1uQkJnoJDwbdw7mhwzCW/pbHWaDhU
         nvMtJJu1TWufbLVDjIxIX0FcJDBzKhLcGkm2KhvqPJvSbX0aFkue6a6V/OItX4AZugIk
         5CvqjCGhnCzxqeSbQSKWjyhyRN01ufPDnh7Y1FG8Go/C0ZND0JgpLo53CuXUaoGhaWAI
         GR8w==
X-Gm-Message-State: AOAM530Nsgnn4c2uw2q7sLSoiJVqetphfxw0wJQ7vYql/e1LEmoKByy4
        mw8XZf8NpJltL4SJK7GTRpmuug==
X-Google-Smtp-Source: ABdhPJxIKRK+askXItE2OZwYriNwX7ACp46vbQLvkdwsqvRr7NoHiCc445mZ1TLvBluJdTjEr/YplA==
X-Received: by 2002:a05:6e02:2149:: with SMTP id d9mr12227833ilv.270.1635347169880;
        Wed, 27 Oct 2021 08:06:09 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f4sm94403ioc.15.2021.10.27.08.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 08:06:09 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org> <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
Date:   Wed, 27 Oct 2021 09:06:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YXlqSRLHuIFiMLY7@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/21 9:03 AM, Ming Lei wrote:
> On Wed, Oct 27, 2021 at 07:12:31AM -0700, Keith Busch wrote:
>> On Wed, Oct 27, 2021 at 06:16:19AM -0700, Bart Van Assche wrote:
>>> On 10/26/21 10:27 PM, Christoph Hellwig wrote:
>>>> On Tue, Oct 26, 2021 at 01:10:47PM -0700, Bart Van Assche wrote:
>>>>> If blk_insert_cloned_request() is moved into the device mapper then I
>>>>> think that blk_mq_request_issue_directly() will need to be exported.
>>>>
>>>> Which is even worse.
>>>>
>>>>> How
>>>>> about the (totally untested) patch below for removing the
>>>>> blk_insert_cloned_request() call from the UFS-HPB code?
>>>>
>>>> Which again doesn't fix anything.  The problem is that it fans out one
>>>> request into two on the same queue, not the specific interface used.
>>>
>>> That patch fixes the reported issue, namely removing the additional accounting
>>> caused by calling blk_insert_cloned_request(). Please explain why it is
>>> considered wrong to fan out one request into two. That code could be reworked
>>> such that the block layer is not involved as Adrian Hunter explained. However,
>>> before someone spends time on making these changes I think that someone should
>>> provide more information about why it is considered wrong to fan out one request
>>> into two.
>>
>> The original request consumes a tag from that queue's tagset. If the
>> lifetime of that tag depends on that same queue having another free tag,
>> you can deadlock.
> 
> Just take a quick look at the code, if the spawned request can't be allocated,
> scsi will return BLK_STS_RESOURCE for the original scsi request which will be
> retried later by blk-mq.
> 
> So if tag depth is > 1 and max allowed inflight write buffer command is limited
> as 1, there shouldn't be the deadlock.
> 
> Or is it possible to reuse the original scsi request's tag for the
> spawned request? Like the trick used in inserting flush request.

The flush approach did come to mind here as well, but honestly that one is
very ugly and would never have been permitted if it wasn't excluded to be
in the very core code already. But yes, reuse of the existing request is
probably another potentially viable approach. My worry there is that
inevitably you end up needing to stash a lot of data to restore the original,
and we're certainly not adding anything to struct request for that.

Hence I think being able to find a new request reliably would be better.

-- 
Jens Axboe

