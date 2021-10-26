Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182BDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 18:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F104D61040
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 18:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhJZSNE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 14:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbhJZSND (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 14:13:03 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ACFC061745
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 11:10:39 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id h196so480913iof.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 11:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jn7tEn4sPoL4tO4+RQEVYBZFQZcRwvcZcrpNUBWHvZw=;
        b=rk4KFYrcRqLpibJ5km4HhiZOGQOTEHV0PwfD8eMi29olLJK0mHGasZ10EPMryNBfoa
         7OH1yzUY7FjV3e7Pg/CEW/0KgB7yv3lnNvgH6IDnN5O1AxbG9B1/o/jkYSQuAx6zYFK6
         tD3Pej2j4O7nW4eYnmswSxJKcKwX4O41/dJYnVEP5bVdMbXI03a5HhgCqvk2ClB4hBlK
         cibvjo5efWW294CALIzg4N0wcCwGVg1lWwG0xYV/9NqLOT5300cPsSWAdTxFDWkUq3S5
         vzLo3h7oCI83m6nnWy2I54sebUOH1wZzmx4gnhsR+OIwwR9AbOSOFxgj7FQyjjJcmUCK
         3dQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jn7tEn4sPoL4tO4+RQEVYBZFQZcRwvcZcrpNUBWHvZw=;
        b=TQtgMbAl6uQ/BNLoc4wY+PdtwiRtzG51tMPfCqlw1j2m+YOK6ritDIC3/HVFzMJkgQ
         6nTIUaNuiCujoWDh7D/3UNZwW2DfN+O0MgY1xX+RlmvQkjFA5r5nWs7vhz57Ym9O0Nv/
         72B0eL2mGyXTqGkRC9mP4fHCzt9rSE4Jngs+Z1KTytY5wcmCVrKH2UnFh0kvRnTEKSiW
         0H5qW7Lr81mNGSxymYJUIRw+EcCrA1rgl4iM4hTLkVRyWYMP+RG0XhcXDOV7yE2ezOu8
         9A37vEtR7yhG0G382CRZ4QQwvHgxWFKPnHM5tlT8Tu81TQSOr26gOZ94JHTnlQw6VThU
         DRVw==
X-Gm-Message-State: AOAM532U94GAmYZJXwvybvl8OxIamLwLyVBNHVVTwYKUt6A2DfSue4Uz
        91rEn6B75TiMIpVRtAJUur/aQw==
X-Google-Smtp-Source: ABdhPJyOp3ynYSRz/PHznb8HvzWkjhb1EeLjud/oLlSQqeCHqXa4d7CU5F+0gENe25ZLwjaient47Q==
X-Received: by 2002:a5d:8ad5:: with SMTP id e21mr10169803iot.195.1635271838718;
        Tue, 26 Oct 2021 11:10:38 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z26sm10305862ioe.9.2021.10.26.11.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 11:10:38 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20211026071204.1709318-1-hch@lst.de>
 <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
 <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
Date:   Tue, 26 Oct 2021 12:10:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/21 12:05 PM, Bart Van Assche wrote:
> On 10/26/21 10:25 AM, Jens Axboe wrote:
>> On 10/26/21 11:19 AM, James Bottomley wrote:
>>> On Tue, 2021-10-26 at 09:36 -0700, Bart Van Assche wrote:
>>>> On 10/26/21 12:12 AM, Christoph Hellwig wrote:
>>>>> The HPB support added this merge window is fundanetally flawed as
>>>>> it
>>>>                                                ^^^^^^^^^^^^
>>>>                                                fundanetally ->
>>>> fundamentally
>>>>
>>>> Since the implementation can be reworked not to use
>>>> blk_insert_cloned_request() I'm not sure using the word
>>>> "fundamentally" is appropriate.
>>>
>>> I'm not so sure about that.  The READ BUFFER implementation runs from a
>>> work queue and looks fine.  The WRITE BUFFER implementation is trying
>>> to spawn a second command to precede the queued command which is a
>>> fundamental problem for the block API.  It's not clear to me that the
>>> WRITE BUFFER can be fixed because of the tying to the sent command ...
>>> but like I said, the standard is proprietary so I can't look at it to
>>> see if there are alternative ways of achieving the same effect.
>>
>> Is there a model in which this can actually work? If not, or if we
>> aren't sure, I think we'd be better off just reverting the parts
>> involved with that block layer misuse. Simply marking it broken is a
>> half measure that doesn't really solve anything (except send a message).
>>
>> IMHO, it should be reverted and the clone usage we currently export be
>> moved into dm for now. That'll prevent further abuse of this in the
>> future.
> 
> Hi Jens and James,
> 
> This is what I found in the HPB 2.0 specification (the spec is
> copyrighted but I assume that I have the right to quote small parts of
> that spec):
> 
> <quote>
> 6.3 HPB WRITE BUFFER Command
> 
> HPB WRITE BUFFER command have following 3 different function depending
> on the value of BUFFER_ID field.
> 1) Inactivating an HPB Region (supported in host control mode only)
> 2) prefetching HPB Entries from the host to the device (supported in any
>     control mode)
> 3) Inactivating all HPB Regions, except for Provisioning Pinned Region
>     in the host (supported in device control mode only)
> </quote>
> 
> Reverting only the problematic code (HPB 2.0) sounds reasonable to me
> because reworking the HPB 2.0 code will be nontrivial.

Then let's please go ahead and do that. I'm assuming this is a smaller
set than what Christoph originally posted, who's taking on the job of
lining it up?

> Using BLK_MQ_F_BLOCKING might be a viable approach. However, I don't
> want to see that flag enabled in the UFS driver if HPB is not used
> because of the negative performance effects of that flag.

Agree, and if we do just the problematic revert, then the decision on
whether BLK_MQ_F_BLOCKING is useful or not belongs to whoever reworks
the WRITE BUFFER code and reposts that support.

-- 
Jens Axboe

