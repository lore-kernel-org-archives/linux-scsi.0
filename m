Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B5BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhKVNxX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:53:23 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:37551 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhKVNxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:53:23 -0500
Received: by mail-wm1-f48.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso16827920wms.2;
        Mon, 22 Nov 2021 05:50:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MrHnau3LEddNI1bV6JCGxIjrRrcua3o14M7tJs01tw8=;
        b=KrX2EGdwA+KwvYI3a2dU5SHMjmP6v9eEVTgRgbygbF3KEOI0MJ1VV5btYt13RqV80j
         jxtiShBLhl8Nl8cPGzRPVCQIbBifck8Nwcd5K3/TVL/yVhJRXLWKoQgU1Jx9xXegoB9h
         eufGgaZNeZyVP3MOBEgS2Y8hsRzCuKiX97tora3OJq/rIDXJq0t6enUjX8S2/i/wApy/
         o1lIDIOvmyCURsBMXCQbqBWUdMj/7YKyMY7DU0B57bPaRr+ZQOC7A7g5GqpP3KkOKmxL
         Qnc5HcKmr5PTe8m8Fd0ATa5KJ2Nu1g+HlRHVFp58p/1tMmbLD0ogYuUts5ByglfIv++V
         HrvA==
X-Gm-Message-State: AOAM530kOeU2jDNtxQP22/p8eyD1P1iaV+yTkpKVUCv+5TA30qPKfn0Y
        mLLoqInE7U95yIisAP+bsYo=
X-Google-Smtp-Source: ABdhPJyhzFR9ruJ/dWiNkF/ZZWcGkiaPHGcgbHbwYvKc3dozJihH3f0Mc6vX7BiMbzxY+QKoaRV9tg==
X-Received: by 2002:a7b:c2a1:: with SMTP id c1mr29455274wmk.112.1637589015897;
        Mon, 22 Nov 2021 05:50:15 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id m2sm21401765wml.15.2021.11.22.05.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 05:50:15 -0800 (PST)
Subject: Re: [PATCH 2/5] blk-mq: rename hctx_lock & hctx_unlock
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-3-ming.lei@redhat.com>
 <ed13ee7f-a017-874a-cd28-e40b3aa6b4a7@grimberg.me> <YZuZCsCIyQrc+539@T590>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <737e0543-9b7b-4872-082c-9ea51069d57f@grimberg.me>
Date:   Mon, 22 Nov 2021 15:50:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZuZCsCIyQrc+539@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/22/21 3:20 PM, Ming Lei wrote:
> On Mon, Nov 22, 2021 at 09:53:53AM +0200, Sagi Grimberg wrote:
>>
>>> -static inline void hctx_unlock(struct blk_mq_hw_ctx *hctx, int srcu_idx)
>>> -	__releases(hctx->srcu)
>>> +static inline void queue_unlock(struct request_queue *q, bool blocking,
>>> +		int srcu_idx)
>>> +	__releases(q->srcu)
>>>    {
>>> -	if (!(hctx->flags & BLK_MQ_F_BLOCKING))
>>> +	if (!blocking)
>>>    		rcu_read_unlock();
>>>    	else
>>> -		srcu_read_unlock(hctx->queue->srcu, srcu_idx);
>>> +		srcu_read_unlock(q->srcu, srcu_idx);
>>
>> Maybe instead of passing blocking bool just look at srcu_idx?
>>
>> 	if (srcu_idx < 0)
>> 		rcu_read_unlock();
>> 	else
>> 		srcu_read_unlock(q->srcu, srcu_idx);
> 
> This way needs to initialize srcu_idx in each callers.

Then look at q->has_srcu that Bart suggested?

> 
>>
>> Or look if the queue has srcu allocated?
>>
>> 	if (!q->srcu)
>> 		rcu_read_unlock();
>> 	else
>> 		srcu_read_unlock(q->srcu, srcu_idx);
> 
> This way is worse since q->srcu may involve one new cacheline fetch.
> 
> hctx->flags is always hot, so it is basically zero cost to check it.

Yea, but the interface is awkward that the caller tells the
routine how it should lock/unlock...
