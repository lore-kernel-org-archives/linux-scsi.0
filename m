Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A95C0032E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 19:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjJTTRp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 15:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjJTTRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 15:17:44 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE130D46;
        Fri, 20 Oct 2023 12:17:42 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-27d1fa1c787so884637a91.3;
        Fri, 20 Oct 2023 12:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697829462; x=1698434262;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9hiPPrSpNBkqXqYkPu5wVhLiFXAxi+CpbUDcdhSazI=;
        b=K8BuwZLlQVe1+6K1E7+RVFk4pSr400SK0Mv81Yy/2rFtmcr7KYYqf0dRM86h7jmoW0
         SJzcCKzOWugBNUBvQbxJrmF+c7pVWcI3L7W6lCsYvv6UmBwv2IjHdpfs49xtWUFgxgZb
         FLUtYCT8gfm/VxgA8isk5L2LFCssLZnzUPL32gnJ3aH9D0j2AZyGjkfFZQ5Ov+YgFvMn
         eP0Y6ca3ys6eNUa33cDO4cc0gr2M5I3is3MD7lRw4gQ7YdZ1GBrTomtAa1TSmou6aRVf
         KADJn3l4WwNVGx8R8o56+TUURd5kYVUIbjmfp3NH7RMmQAah8Gh628Zi/tVHyjQknT1t
         mN5w==
X-Gm-Message-State: AOJu0YxmqXIQR0/jP4VfWmn3bVexQMoQraWAmpuoQXum69oZdMubWQVV
        YWqWqhZ/eVp6dcL9vjy8vpE=
X-Google-Smtp-Source: AGHT+IGMzGUAfpbblyaUJ/kjuHhSd/fa16OIoLNBP1M8Yus3+tmEjO0McJ5sjqSo3H8DOoFzeDnbkQ==
X-Received: by 2002:a17:90b:4e8f:b0:26d:2b86:dbe1 with SMTP id sr15-20020a17090b4e8f00b0026d2b86dbe1mr2779509pjb.25.1697829462170;
        Fri, 20 Oct 2023 12:17:42 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:72ba:c99b:d191:901c? ([2620:15c:211:201:72ba:c99b:d191:901c])
        by smtp.gmail.com with ESMTPSA id gd22-20020a17090b0fd600b0027d0c3507fcsm3599528pjb.9.2023.10.20.12.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Oct 2023 12:17:41 -0700 (PDT)
Message-ID: <f394372f-0538-4d2b-9ee1-a3e19020b535@acm.org>
Date:   Fri, 20 Oct 2023 12:17:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 03/18] block: Preserve the order of requeued zoned
 writes
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
References: <20231018175602.2148415-1-bvanassche@acm.org>
 <20231018175602.2148415-4-bvanassche@acm.org>
 <5a58c56f-5558-43d5-adc4-bc379f87ddbf@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5a58c56f-5558-43d5-adc4-bc379f87ddbf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/23 17:15, Damien Le Moal wrote:
> On 10/19/23 02:54, Bart Van Assche wrote:
>> blk_mq_requeue_work() inserts requeued requests in front of other
>> requests. This is fine for all request types except for sequential zoned
>> writes. Hence this patch.
>>
>> Note: moving this functionality into the mq-deadline I/O scheduler is
>> not an option because we want to be able to use zoned storage without
>> I/O scheduler.
>>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Damien Le Moal <dlemoal@kernel.org>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   block/blk-mq.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 502dafa76716..ce6ddb249959 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -1485,7 +1485,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
>>   			blk_mq_request_bypass_insert(rq, 0);
>>   		} else {
>>   			list_del_init(&rq->queuelist);
>> -			blk_mq_insert_request(rq, BLK_MQ_INSERT_AT_HEAD);
>> +			blk_mq_insert_request(rq,
>> +					      !blk_rq_is_seq_zoned_write(rq) ?
>> +					      BLK_MQ_INSERT_AT_HEAD : 0);
> 
> Something like:
> 
> 		} else {
> 			blk_insert_t flags = BLK_MQ_INSERT_AT_HEAD;
> 
> 			if (blk_rq_is_seq_zoned_write(rq))
> 				flags = 0;
> 			blk_mq_insert_request(rq, flags);
> 		}
> 
> would be a lot easier to read in my opinion.

Hi Damien,

I will make this change.

Thanks,

Bart.


