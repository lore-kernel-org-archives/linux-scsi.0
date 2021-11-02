Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6375C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974A6610FD
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhKBOi6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhKBOi5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 10:38:57 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10750C061767
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 07:36:23 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 62so18353754iou.2
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 07:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7ipZ4yH5O9nKju/+y1oUK8kyA92olAJu1Ygd7eQQeUk=;
        b=2R4nUoenjFOWux1IxXeHzMJfCA6kdPs35eiJpxYPgkpa5RUxM8FVbzirYYcEkllbFq
         +INQxDzjsMdCc2L3ywp0uZcAu4LYr/kgVLNXobCinzAaOQVIsEyqtQHErYVRqndmBHGQ
         Ven846LX4PIDAdOi+ukhDy6NH3kwk1Md2Re9Q2xAs+wb+rlcUvQ9yTkedLFxFILdePkK
         N41UoNizBh/JksPngkB11/gE6WCtGTma/eqVuOIMiyBOKZUBoysDQD4O69pk2iHp0CL4
         mNsdJ+BLjAterd9ZA5wVzU9c2v+DtUohFZ+EQBLFjXMouQx9S0kjG/5/W4Ekcj++i97r
         s2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ipZ4yH5O9nKju/+y1oUK8kyA92olAJu1Ygd7eQQeUk=;
        b=ZqOhJl8hT3zPc3T9lBGFlERfyzgA6MV984YBK0IkUWjYCDR4a0M9I88ik8od8lshAs
         mfAABCoW0b3WXcmuxRcjAv1Ap2faZYLQHIyS9owgfclkutrprf3fHpJ73oYPQdbKlUHs
         kNOOd6EAqZBd2DjHThmCn14463kQxL1etuYIcd9Hq7gKPLgIDO23NA5xtYxcuTXxc6vW
         7IJXMidRT34RCIlqXAewHtlb7wZwvkdYMbRLQSuedaqgPbAe9tzETivkOLIi4fSMxZDu
         MaJvoIb9E1sxW+3p/nyj2veJ65hBTsnIAltnys4T2FDJj8WIW89637RAYbKramI9CYF8
         eexg==
X-Gm-Message-State: AOAM533K4oLJlrNviazbpeapj8EAOlpc4tJI2P2/zuGPAG4+rXXw3tNS
        c/ysKmnBqIo2M+Yi84R+8EJCTg==
X-Google-Smtp-Source: ABdhPJynSTmOQ6QLnKPuhL+PHE/RobnaTTXg3kAxi4LdCHOOyK2yQZYurAf0Oq9pmuUhzLtjsH/5sw==
X-Received: by 2002:a05:6602:2f04:: with SMTP id q4mr10537728iow.123.1635863782405;
        Tue, 02 Nov 2021 07:36:22 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a1sm9415082ilt.60.2021.11.02.07.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 07:36:22 -0700 (PDT)
Subject: Re: [PATCH 2/3] scsi: make sure that request queue queiesce and
 unquiesce balanced
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com
References: <20211021145918.2691762-1-ming.lei@redhat.com>
 <20211021145918.2691762-3-ming.lei@redhat.com>
 <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
 <8cbc1be6-15a5-ed34-53f1-081a05025d34@kernel.dk>
 <a7bae1c4c3d6b08487b96cb3aa86d4fab1a0abcc.camel@HansenPartnership.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1ab71603-0104-2071-02c9-d6c22e3aa275@kernel.dk>
Date:   Tue, 2 Nov 2021 08:36:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a7bae1c4c3d6b08487b96cb3aa86d4fab1a0abcc.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/21 8:33 AM, James Bottomley wrote:
> On Tue, 2021-11-02 at 06:59 -0600, Jens Axboe wrote:
>> On 11/1/21 7:43 PM, James Bottomley wrote:
>>> On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
>>>> For fixing queue quiesce race between driver and block
>>>> layer(elevator switch, update nr_requests, ...), we need to
>>>> support concurrent quiesce and unquiesce, which requires the two
>>>> call balanced.
>>>>
>>>> It isn't easy to audit that in all scsi drivers, especially the
>>>> two may be called from different contexts, so do it in scsi core
>>>> with one per-device bit flag & global spinlock, basically zero
>>>> cost since request queue quiesce is seldom triggered.
>>>>
>>>> Reported-by: Yi Zhang <yi.zhang@redhat.com>
>>>> Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
>>>> quiesce/unquiesce")
>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>>> ---
>>>>  drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++
>>>> ----
>>>> ----
>>>>  include/scsi/scsi_device.h |  1 +
>>>>  2 files changed, 37 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>> index 51fcd46be265..414f4daf8005 100644
>>>> --- a/drivers/scsi/scsi_lib.c
>>>> +++ b/drivers/scsi/scsi_lib.c
>>>> @@ -2638,6 +2638,40 @@ static int
>>>> __scsi_internal_device_block_nowait(struct scsi_device *sdev)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
>>>> +
>>>> +void scsi_start_queue(struct scsi_device *sdev)
>>>> +{
>>>> +	bool need_start;
>>>> +	unsigned long flags;
>>>> +
>>>> +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
>>>> +	need_start = sdev->queue_stopped;
>>>> +	sdev->queue_stopped = 0;
>>>> +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
>>>> +
>>>> +	if (need_start)
>>>> +		blk_mq_unquiesce_queue(sdev->request_queue);
>>>
>>> Well, this is a classic atomic pattern:
>>>
>>> if (cmpxchg(&sdev->queue_stopped, 1, 0))
>>> 	blk_mq_unquiesce_queue(sdev->request_queue);
>>>
>>> The reason to do it with atomics rather than spinlocks is
>>>
>>>    1. no need to disable interrupts: atomics are locked
>>>    2. faster because a spinlock takes an exclusive line every time
>>> but the
>>>       read to check the value can be in shared mode in cmpxchg
>>>    3. it's just shorter and better code.
>>>
>>> The only minor downside is queue_stopped now needs to be a u32.
>>
>> Are you fine with the change as-is, or do you want it redone? I
>> can drop the SCSI parts and just queue up the dm fix. Personally
>> I think it'd be better to get it fixed upfront.
> 
> Well, given the path isn't hot, I don't really care.  However, what I
> don't want is to have to continually bat back patches from the make
> work code churners trying to update this code for being the wrong
> pattern.  I think at the very least it needs a comment saying why we
> chose a suboptimal pattern to try to forestall this.

Right, with a comment it's probably better. And as you said, since it's
not a hot path, don't think we'd be revisiting it anyway.

I'll amend the patch with a comment.

-- 
Jens Axboe

