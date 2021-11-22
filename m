Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204B2C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbhKVNvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:51:04 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:36509 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhKVNvD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:51:03 -0500
Received: by mail-wr1-f47.google.com with SMTP id s13so32881279wrb.3;
        Mon, 22 Nov 2021 05:47:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Imk/V33SwSPvNX4UDYJXYsrRhdLzxlG8Sz/XQR/TnCA=;
        b=ADJwqaC6PSlwQ1G7Q6EcNw3uJkHC5UzNeU0dnt/JpizUTXwze+jd2AWiY90sLs4rCN
         nnxbn2LyN1vpClves4FHaUycaS906TI+jZ8EGiM71chb3smJwZzVN74+L2N/d0BzC9EC
         8SbkIZRvFtIyag6xPNZwJHCr+mZUW2O/sSykgJpghtY6+sWKsITLeBPEljLSqW8jgElR
         q9NfDYDMqt4VTWKfC2Vc3nf5J/xAtU4p84gn+JPO+g8x6vk4neGmqDubEsUCgV7Zsu6v
         7Q/9hR86tXv8u4u1zN0CafS+CzwNZf119ZqjX5RK6AHYvyQWlE4wXb0lGm1YK7z1Qnan
         VCAQ==
X-Gm-Message-State: AOAM530I3yEBvIjCKrzQiMvv12Pu4lSUiYtMwzey889/pBx0L2pJyGtu
        CsDQvIuMlc+niUMiy6yNKIb4F3CBa0g=
X-Google-Smtp-Source: ABdhPJxiHyrUIwRt8vpxxsPWXhLnobYfvfdWMkSUaMv+U+fD3azX0W76K6BKV6m4cRwW4M/6FmyXbw==
X-Received: by 2002:a5d:47c9:: with SMTP id o9mr22821974wrc.348.1637588876022;
        Mon, 22 Nov 2021 05:47:56 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id f8sm21156737wmf.2.2021.11.22.05.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 05:47:55 -0800 (PST)
Subject: Re: [PATCH 1/5] blk-mq: move srcu from blk_mq_hw_ctx to request_queue
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-2-ming.lei@redhat.com>
 <a3192b20-fa76-0b64-a2a9-c0c337741156@acm.org> <YZdb2/XoJVJOa1r+@T590>
 <a219fff8-8f2d-adb1-eb8c-3e5712cea5bd@grimberg.me> <YZuWVlakjrzICKc1@T590>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <dddc4694-080f-701b-1802-17661ee31017@grimberg.me>
Date:   Mon, 22 Nov 2021 15:47:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZuWVlakjrzICKc1@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>>>> +	bool			alloc_srcu;
>>>>
>>>> I found the following statement multiple times in this patch:
>>>>
>>>> WARN_ON_ONCE(q->alloc_srcu != !!(q->tag_set->flags & BLK_MQ_F_BLOCKING));
>>>>
>>>> Does this mean that the new q->alloc_srcu member variable can be left out
>>>> and that it can be replaced with the following test?
>>>>
>>>> q->tag_set->flags & BLK_MQ_F_BLOCKING
>>>
>>> q->tag_set can't be used anymore after blk_cleanup_queue() returns,
>>> and we need the flag for freeing request_queue instance.
>>
>> Why not just look at the queue->srcu pointer? it is allocated only
>> for BLK_MQ_F_BLOCKING no?
> 
> Yeah, we can add one extra srcu pointer to request queue, but this way
> needs one extra fetch to q->srcu in fast path compared with current
> code base, so io_uring workload may be affected a bit.

Yea you're right. We should at some point make has_srcu and
mq_sysfs_init_done bits in a flags member, but we have like 6 more
before we need to do it...
