Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88159C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 16:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 710DD60F92
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 16:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238164AbhJ0QWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 12:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbhJ0QWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2021 12:22:08 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1147EC061570
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 09:19:43 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id d63so4382743iof.4
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 09:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pESxQ750e+D0v/lFWxEmJANBc6Y4stBpi6txxmc9/yQ=;
        b=XuSHaKWD7vZR4018ZFOu5rR/bgR1cVXXsljKJu79e8uLX21j/paNVT81PMGCV0il8p
         9bl2/9OxUyELBtxbDecHryzi3Rc1ujC6J/EIFeY+rAUDg+vIYqGyCDxP+ZUs4XAuP5/H
         z1Kk/dG93BUxP/FKwFfKRGCMduPTLI/E87t86IGjGut9SlrTWIo9TT5IkRRDpdvIYige
         /byTq2ViekKreg6fBsuSp4nECavfNMPFMtSPUbAcoKejkh/lkOUN0rXrr6A1fozMBGIx
         p5AUPs1cMjJTLSagigMgOeP7pBbVhqXQ4prsY2NnRF0Vl6acY8p/QHK+mDXo157fr2is
         fYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pESxQ750e+D0v/lFWxEmJANBc6Y4stBpi6txxmc9/yQ=;
        b=cDOJAZDYLSovZeKDb/56KbI4kv+zY9525idF6FejB4vpPfKQfE7kzDcEWwgevHHx/6
         7yEj1mN3A7YLBI9loOtl9uXIpNUjbOXzDTjiI8fBVqslwJkhB0TDyWjSggNyDRyZNF9b
         SxJUGugQDdrsWC7dYcw2AzpG6J0BTBPsA5oMRk7VLObs47BxbrmK/IZ3WxxGgYn24Qxk
         hKBx5O0bMpWKqyVoKC6Ky+HgKwuzcVpj6qOgiGsTXhhYIgyugjYop9FTkb6/Vr+incnE
         sf2QApt73brKcuhs44rZkHzl5rHpWKaVZ9LWXBFDl1te+D8mbML5XvA8OGWQJRwzNL/c
         4ApA==
X-Gm-Message-State: AOAM532YBblzAwaqQI3Udhwl/JHJB4lMXzWFeNOIuoLsG7e01K0aQ/4N
        aEyoiFBLvNx8SnjlCOxeiviH2g==
X-Google-Smtp-Source: ABdhPJwhozF1eh4I080aioyoSIOjmAJLmRSTyieuuQtm8replWivvR/lC9iKuh8VoGzLxnflohjWuA==
X-Received: by 2002:a5d:8785:: with SMTP id f5mr11175905ion.110.1635351582309;
        Wed, 27 Oct 2021 09:19:42 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j23sm186036iog.53.2021.10.27.09.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 09:19:41 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org> <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590> <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
 <YXltPgRTxe+Xn66i@T590> <yq1wnlyzday.fsf@ca-mkp.ca.oracle.com>
 <YXl3H39vHAj2+SSL@T590>
 <20211027161632.GB2338303@dhcp-10-100-145-180.wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <65ca1470-e3fd-f6e2-7da8-ce6c2259314b@kernel.dk>
Date:   Wed, 27 Oct 2021 10:19:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211027161632.GB2338303@dhcp-10-100-145-180.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/21 10:16 AM, Keith Busch wrote:
> On Wed, Oct 27, 2021 at 11:58:23PM +0800, Ming Lei wrote:
>> On Wed, Oct 27, 2021 at 11:44:04AM -0400, Martin K. Petersen wrote:
>>>
>>> Ming,
>>>
>>>> request with scsi_cmnd may be allocated by the ufshpb driver, even it
>>>> should be fine to call ufshcd_queuecommand() directly for this driver
>>>> private IO, if the tag can be reused. One example is scsi_ioctl_reset().
>>>
>>> scsi_ioctl_reset() allocates a new request, though, so that doesn't
>>> solve the forward progress guarantee. Whereas eh puts the saved request
>>> on the stack.
>>
>> What I meant is to use one totally ufshpb private command allocated from
>> private slab to replace the spawned request, which is sent to ufshcd_queuecommand()
>> directly, so forward progress is guaranteed if the blk-mq request's tag can be
>> reused for issuing this private command. This approach takes a bit effort,
>> but avoids tags reservation.
>>
>> Yeah, it is cleaner to use reserved tag for the spawned request, but we
>> need to know:
>>
>> 1) how many queue depth for the hba? If it is small, even 1 reservation
>> can affect performance.
>>
>> 2) how many inflight write buffer commands are to be supported? Or how many
>> is enough for obtaining expected performance? If the number is big, reserved
>> tags can't work.
> 
> The original and clone are not dispatched to hardware concurrently, so
> I don't think the reserved_tags need to subtract from the generic
> ones. The original request already accounts for the hardware resource,
> so the clone doesn't need to consume another one.

Maybe I didn't phrase it clearly enough, because that's not what I
meant. My point is that just one reserved tag is fine for the
correctness guarantee, you'd just only have one of these special
requests inflight at the time then and that may be a performance
concern. More reserved tags would allow more inflight at the same time.
This is totally independent of the normal tags available.

-- 
Jens Axboe

