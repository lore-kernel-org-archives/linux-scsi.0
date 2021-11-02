Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67E6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C010961052
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 14:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhKBOoB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhKBOoB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 10:44:01 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C6BC061714
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 07:41:26 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id x9so14527755ilu.6
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 07:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/U1hxiNkFJx/rX8ebEMVcjsSUpOAIM0zNBm4rpYu4HM=;
        b=IljKTMzSgAJEYT1jyT98fBqHsBPcFKhwLtkUiv/LU0vLDrJg2oXJTxrto9kXJOaigc
         5ovN/u8TlaLGxIdx0vDI/8U1LNsakFfkAtSKGn5lw056gKFdHLZda26jHFY35OyITD8r
         qUx8RkOCLcNxbL5El4iDSov1/4VuX/rd4i2fSHA3KtiuwoFTCRngF73YM3aLI6pe62nL
         EM7yVjCMw/qHp9bdcL1SBtkbfADUE9q/kCetuYMpIhw/6j1pvlGCUCMFe1jMpGtO48MN
         iZT91iFNJs61B0PpBPj/VhGjjTdoUv649xYRSitXeBCp5xRKMGwQgFSJbUPdkrszHqGd
         Ix+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/U1hxiNkFJx/rX8ebEMVcjsSUpOAIM0zNBm4rpYu4HM=;
        b=etsLik9cO6mza2TJk0jkBLALwiRli0+UuLiiuyUzvGgtxzKIZJaDyqFrMMpXh2OKQC
         DX1bMYeTN4/wEhzuOlZwez+F9sdEP2negKS70V2qpXXUPGL/1XpwyFyaKup4rbamwtBI
         e9kcq/BEPIgchjVA2buTW5ChaPxPodNz39FGG+QuGwmP63kUMCgKTC0k5Qp0uG1ejMUL
         gocSYjOVqByQ+ey1PS00y39o9qRMCAiaHoqBJnD+IQLZL3dwB6/oGpxi0o+5aj24/TAQ
         X35k0upIjDdFe3KiVZhPAqT7/xVSP1OyUBtYrdMSTYW+BFJt+JYA5Pv0t/KmP8Bla6TW
         nVIg==
X-Gm-Message-State: AOAM53150X5pahdWP0dv9ZFEo3mhMapJ8dCAXxa0fMgldxwAN9INL9Kw
        d5dLP/ACJiF3lt4y7fIW01erRSyp8n9rsw==
X-Google-Smtp-Source: ABdhPJyE7d27RzQeHYy26nP1Rz61cbOHW9AcygMT2PQRDL+okwbxgWS+4oXgVErV4Jl+LmhbSUrbLQ==
X-Received: by 2002:a05:6e02:1bcb:: with SMTP id x11mr20970995ilv.94.1635864085483;
        Tue, 02 Nov 2021 07:41:25 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s3sm7147044ilv.61.2021.11.02.07.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 07:41:24 -0700 (PDT)
Subject: Re: [PATCH 2/3] scsi: make sure that request queue queiesce and
 unquiesce balanced
From:   Jens Axboe <axboe@kernel.dk>
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
 <1ab71603-0104-2071-02c9-d6c22e3aa275@kernel.dk>
Message-ID: <042056b5-6fea-1bcf-bfae-274f23e9e5c5@kernel.dk>
Date:   Tue, 2 Nov 2021 08:41:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1ab71603-0104-2071-02c9-d6c22e3aa275@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/21 8:36 AM, Jens Axboe wrote:
> On 11/2/21 8:33 AM, James Bottomley wrote:
>> On Tue, 2021-11-02 at 06:59 -0600, Jens Axboe wrote:
>>> On 11/1/21 7:43 PM, James Bottomley wrote:
>>>> On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
>>>>> For fixing queue quiesce race between driver and block
>>>>> layer(elevator switch, update nr_requests, ...), we need to
>>>>> support concurrent quiesce and unquiesce, which requires the two
>>>>> call balanced.
>>>>>
>>>>> It isn't easy to audit that in all scsi drivers, especially the
>>>>> two may be called from different contexts, so do it in scsi core
>>>>> with one per-device bit flag & global spinlock, basically zero
>>>>> cost since request queue quiesce is seldom triggered.
>>>>>
>>>>> Reported-by: Yi Zhang <yi.zhang@redhat.com>
>>>>> Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
>>>>> quiesce/unquiesce")
>>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>>>> ---
>>>>>  drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++
>>>>> ----
>>>>> ----
>>>>>  include/scsi/scsi_device.h |  1 +
>>>>>  2 files changed, 37 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>>> index 51fcd46be265..414f4daf8005 100644
>>>>> --- a/drivers/scsi/scsi_lib.c
>>>>> +++ b/drivers/scsi/scsi_lib.c
>>>>> @@ -2638,6 +2638,40 @@ static int
>>>>> __scsi_internal_device_block_nowait(struct scsi_device *sdev)
>>>>>  	return 0;
>>>>>  }
>>>>>  
>>>>> +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
>>>>> +
>>>>> +void scsi_start_queue(struct scsi_device *sdev)
>>>>> +{
>>>>> +	bool need_start;
>>>>> +	unsigned long flags;
>>>>> +
>>>>> +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
>>>>> +	need_start = sdev->queue_stopped;
>>>>> +	sdev->queue_stopped = 0;
>>>>> +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
>>>>> +
>>>>> +	if (need_start)
>>>>> +		blk_mq_unquiesce_queue(sdev->request_queue);
>>>>
>>>> Well, this is a classic atomic pattern:
>>>>
>>>> if (cmpxchg(&sdev->queue_stopped, 1, 0))
>>>> 	blk_mq_unquiesce_queue(sdev->request_queue);
>>>>
>>>> The reason to do it with atomics rather than spinlocks is
>>>>
>>>>    1. no need to disable interrupts: atomics are locked
>>>>    2. faster because a spinlock takes an exclusive line every time
>>>> but the
>>>>       read to check the value can be in shared mode in cmpxchg
>>>>    3. it's just shorter and better code.
>>>>
>>>> The only minor downside is queue_stopped now needs to be a u32.
>>>
>>> Are you fine with the change as-is, or do you want it redone? I
>>> can drop the SCSI parts and just queue up the dm fix. Personally
>>> I think it'd be better to get it fixed upfront.
>>
>> Well, given the path isn't hot, I don't really care.  However, what I
>> don't want is to have to continually bat back patches from the make
>> work code churners trying to update this code for being the wrong
>> pattern.  I think at the very least it needs a comment saying why we
>> chose a suboptimal pattern to try to forestall this.
> 
> Right, with a comment it's probably better. And as you said, since it's
> not a hot path, don't think we'd be revisiting it anyway.
> 
> I'll amend the patch with a comment.

I started adding the comment and took another look at this, and that
made me change my mind. We really should make this a cmpxcgh, it's not
even using a device lock here.

I've dropped the two SCSI patches for now, Ming can you resend? If James
agrees, I really think queue_stopped should just have the type changed
and the patch redone with that using cmpxcgh().

-- 
Jens Axboe

