Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12538C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 18:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE4C060F24
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 18:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbhJZSIB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 14:08:01 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:54799 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbhJZSIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 14:08:00 -0400
Received: by mail-pj1-f44.google.com with SMTP id np13so93597pjb.4;
        Tue, 26 Oct 2021 11:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h85s4mwR2peA/1YD6n/4WZbvdA07VtiLmpGYZKCjGNU=;
        b=qT2ts74vfxzs7Hw38R0sVXCHz/4eAcDWRdoI5ZJNx2FYzXNpuVu4CBg4/FSUS40Ok8
         lUbiabbfTZohtczR/9xNKaHnEl6ZPWh7ssbTMGdeEwtdo/foW2z+IY9tMXujj+kX0QtF
         aDJkbzgiphXL6oXLkckDz3dGFykOWaXeoHetM4qAtfCdg23mJzpwDR5aZeirYURMGp3y
         JwPy3zJfKgLUySgV6sv7orB6GDUd4uCb/5qht6lBW8rhZkcvmUu5Xmlvs9EibLDXOsA/
         LQIsw+Me2g6gcO4bd4nPL+UTnovxgfvV83le4Sr0jGbdWuLw8YT9q6laEFn2cmC1ONvW
         jm3w==
X-Gm-Message-State: AOAM53334KVsArlZMBykJArLtrZj5M87XvZPMAId+H2nA/wUBdj/2/h/
        V+cJHioHPI3nGgJ5dpU8hc10Xlb6YZKslw==
X-Google-Smtp-Source: ABdhPJxNdleVYcFLkR3Su+yVSdO8nuxyUkcDDMPuF93tVWpDh+b5rpsqCLjIwrqjNErqEbz3blHfZw==
X-Received: by 2002:a17:90a:bd08:: with SMTP id y8mr238273pjr.123.1635271535696;
        Tue, 26 Oct 2021 11:05:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:26a4:3b5f:3c4f:53f5])
        by smtp.gmail.com with ESMTPSA id q10sm20259057pgn.31.2021.10.26.11.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 11:05:35 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20211026071204.1709318-1-hch@lst.de>
 <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
 <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
Date:   Tue, 26 Oct 2021 11:05:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/21 10:25 AM, Jens Axboe wrote:
> On 10/26/21 11:19 AM, James Bottomley wrote:
>> On Tue, 2021-10-26 at 09:36 -0700, Bart Van Assche wrote:
>>> On 10/26/21 12:12 AM, Christoph Hellwig wrote:
>>>> The HPB support added this merge window is fundanetally flawed as
>>>> it
>>>                                                ^^^^^^^^^^^^
>>>                                                fundanetally ->
>>> fundamentally
>>>
>>> Since the implementation can be reworked not to use
>>> blk_insert_cloned_request() I'm not sure using the word
>>> "fundamentally" is appropriate.
>>
>> I'm not so sure about that.  The READ BUFFER implementation runs from a
>> work queue and looks fine.  The WRITE BUFFER implementation is trying
>> to spawn a second command to precede the queued command which is a
>> fundamental problem for the block API.  It's not clear to me that the
>> WRITE BUFFER can be fixed because of the tying to the sent command ...
>> but like I said, the standard is proprietary so I can't look at it to
>> see if there are alternative ways of achieving the same effect.
> 
> Is there a model in which this can actually work? If not, or if we
> aren't sure, I think we'd be better off just reverting the parts
> involved with that block layer misuse. Simply marking it broken is a
> half measure that doesn't really solve anything (except send a message).
> 
> IMHO, it should be reverted and the clone usage we currently export be
> moved into dm for now. That'll prevent further abuse of this in the
> future.

Hi Jens and James,

This is what I found in the HPB 2.0 specification (the spec is
copyrighted but I assume that I have the right to quote small parts of
that spec):

<quote>
6.3 HPB WRITE BUFFER Command

HPB WRITE BUFFER command have following 3 different function depending
on the value of BUFFER_ID field.
1) Inactivating an HPB Region (supported in host control mode only)
2) prefetching HPB Entries from the host to the device (supported in any
    control mode)
3) Inactivating all HPB Regions, except for Provisioning Pinned Region
    in the host (supported in device control mode only)
</quote>

Reverting only the problematic code (HPB 2.0) sounds reasonable to me
because reworking the HPB 2.0 code will be nontrivial. Using
BLK_MQ_F_BLOCKING might be a viable approach. However, I don't want to
see that flag enabled in the UFS driver if HPB is not used because of
the negative performance effects of that flag.

Thanks,

Bart.
