Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD825C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Dec 2021 12:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhLHMxB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Dec 2021 07:53:01 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:38639 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhLHMxA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2021 07:53:00 -0500
Received: by mail-wr1-f52.google.com with SMTP id q3so3915651wru.5;
        Wed, 08 Dec 2021 04:49:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FYH/sRLBPleRFcKivJ4eo0TXpFe+PUcyhNxulaKbV2g=;
        b=aGC5AT9vTr7cdWqyniU1CQx2d2KgkaHudtaF7UD/8oU2aZTlBKZh8uvPM8F1bmmYqG
         CHelqYWrNqbd5mMONDs5/x71oIy/qBRcnZ8vKfhV+z7C6Oel6VOiwLqQEt+Z6Rb6NdVQ
         X0MRtbZ9BgjqvYgzRRoqGMnoHSA/IOMMqv0OTVqpe8XjfnBxRTr6YJbH6IYjNoAxdePX
         OgdMGD6xEOoSVz/XcgepgxEgNKb7sy+q3b6Zj/A6Nq3ZtZhrNG8M/hTiZEBRTwmKWvlN
         66zaVxRqz04m+rt3JZfq7H4qfKR/vHqNBXKHdAHFXJgONtUiUNWbtfXPHUR/lhAhk0HK
         fIIg==
X-Gm-Message-State: AOAM533TsuUc2Tbqs8JM64VwZl0F7WoEk/yR6kww5XzvCRAkKBLhH/zO
        QkD2Fj4NSHa8OBoPl/NMDQw=
X-Google-Smtp-Source: ABdhPJwqgeHzS+IbEYPxPRtwHZ6X78/4f9whMBS/JU960T1maZxl3zWma4xGqPiC4FUDcCF7ARBw4Q==
X-Received: by 2002:a5d:6244:: with SMTP id m4mr60754430wrv.186.1638967767449;
        Wed, 08 Dec 2021 04:49:27 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id j40sm5699863wms.19.2021.12.08.04.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 04:49:26 -0800 (PST)
Subject: Re: [PATCH 3/5] blk-mq: add helper of blk_mq_global_quiesce_wait()
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-4-ming.lei@redhat.com>
 <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me> <YZuagPbZJ6CjiUNi@T590>
 <38b9661e-c5b8-ae18-f2ab-b30f9d3e7115@grimberg.me> <YZwzEBtFug6JEmMZ@T590>
 <a3ea006a-738b-af69-4dd5-f33444e3559d@grimberg.me> <YaWNZF3ZYWPQBSbk@T590>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <4394200f-782b-5d75-4570-79a1f63110b1@grimberg.me>
Date:   Wed, 8 Dec 2021 14:49:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YaWNZF3ZYWPQBSbk@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/30/21 4:33 AM, Ming Lei wrote:
> On Tue, Nov 23, 2021 at 11:00:45AM +0200, Sagi Grimberg wrote:
>>
>>>>>>> Add helper of blk_mq_global_quiesce_wait() for supporting to quiesce
>>>>>>> queues in parallel, then we can just wait once if global quiesce wait
>>>>>>> is allowed.
>>>>>>
>>>>>> blk_mq_global_quiesce_wait() is a poor name... global is scope-less and
>>>>>> obviously it has a scope.
>>>>>
>>>>> How about blk_mq_shared_quiesce_wait()? or any suggestion?
>>>>
>>>> Shared between what?
>>>
>>> All request queues in one host-wide, both scsi and nvme has such
>>> requirement.
>>>
>>>>
>>>> Maybe if the queue has a non-blocking tagset, it can have a "quiesced"
>>>> flag that is cleared in unquiesce? then the callers can just continue
>>>> to iterate but will only wait the rcu grace period once.
>>>
>>> Yeah, that is what these patches try to implement.
>>
>> I was suggesting to "hide" it in the interface.
>> Maybe something like:
>> --
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 8799fa73ef34..627b631db1f9 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -263,14 +263,18 @@ void blk_mq_wait_quiesce_done(struct request_queue *q)
>>          unsigned int i;
>>          bool rcu = false;
>>
>> +       if (!q->has_srcu && q->quiesced)
>> +               return;
>>          queue_for_each_hw_ctx(q, hctx, i) {
>>                  if (hctx->flags & BLK_MQ_F_BLOCKING)
>>                          synchronize_srcu(hctx->srcu);
>>                  else
>>                          rcu = true;
>>          }
>> -       if (rcu)
>> +       if (rcu) {
>>                  synchronize_rcu();
>> +               q->quiesced = true;
>> +       }
>>   }
>>   EXPORT_SYMBOL_GPL(blk_mq_wait_quiesce_done);
>>
>> @@ -308,6 +312,7 @@ void blk_mq_unquiesce_queue(struct request_queue *q)
>>          } else if (!--q->quiesce_depth) {
>>                  blk_queue_flag_clear(QUEUE_FLAG_QUIESCED, q);
>>                  run_queue = true;
>> +               q->quiesced = false;
> 
> Different request queues are passed to blk_mq_wait_quiesce_done() during
> the iteration, so marking 'quiesced' doesn't make any difference here.

I actually meant q->tag_set->quiesced, such that the flag will be
used in the tag_set reference. This way this sharing will be kept
hidden from the callers.
