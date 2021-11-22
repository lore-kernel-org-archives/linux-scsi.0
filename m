Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F42FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 08:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhKVIDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 03:03:24 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:37595 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhKVIDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 03:03:23 -0500
Received: by mail-wr1-f42.google.com with SMTP id b12so30995715wrh.4;
        Mon, 22 Nov 2021 00:00:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2p0Anl/Hp40Z+kJU8iVohVkBOqdp10wLUJBBQgkwUxw=;
        b=FjNtMRPr2nP+6Xfn2YfkLZ/KkOGh/LmllUUhYP7nQHOh5Ja0jkzoDRFyJeDz/w1Bi7
         Yv1w8mGmkZNP9467GCiH6Br1e9DrqZmO2j5e3HcwLHdzeJ7ftR/fS+8gLX5GaLCskvYi
         y1O3Z2UX6KrZR0lgnM4DrG7Tm7ahvYZUK7uJ8AyC3arv80VSXN19AECHsqA2J3Ijp/9w
         HpqUxMRvZkGvD+3RcPVCgIQAbjE4FTS8Y9+X7mhJW1sdE57uIUiSoxRFx7WFC8nNtWRf
         qYcjPChUYeopkRCkAOtJtv0e5b+MKvHfpbLq3mYQBLyOQrYXM55fcK8+/bzgaEfG/Ezz
         vWoA==
X-Gm-Message-State: AOAM5304/rpFwcgwlfA5MygH7rcmylQnvZNy6YKWzgI4E8fk/tElyaua
        W5+BczyivN6zMMvtNcjTUCo=
X-Google-Smtp-Source: ABdhPJw7NiOcUuKogho041u6gxFJakYmXYz6ZpubZXkXzNXvTRi1noobcFgC7NR0ahrcqxS/2BuXZw==
X-Received: by 2002:adf:e7cf:: with SMTP id e15mr35553803wrn.287.1637568016730;
        Mon, 22 Nov 2021 00:00:16 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id g13sm10637911wrd.57.2021.11.22.00.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 00:00:16 -0800 (PST)
Subject: Re: [PATCH 3/5] blk-mq: add helper of blk_mq_global_quiesce_wait()
From:   Sagi Grimberg <sagi@grimberg.me>
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-4-ming.lei@redhat.com>
 <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me>
Message-ID: <b642d5bb-de39-905f-0e12-991ef50ec75d@grimberg.me>
Date:   Mon, 22 Nov 2021 10:00:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/22/21 9:56 AM, Sagi Grimberg wrote:
> 
>> Add helper of blk_mq_global_quiesce_wait() for supporting to quiesce
>> queues in parallel, then we can just wait once if global quiesce wait
>> is allowed.
> 
> blk_mq_global_quiesce_wait() is a poor name... global is scope-less and
> obviously it has a scope.
> 
> 
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>>   include/linux/blk-mq.h | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>> index 5cc7fc1ea863..a9fecda2507e 100644
>> --- a/include/linux/blk-mq.h
>> +++ b/include/linux/blk-mq.h
>> @@ -777,6 +777,19 @@ static inline bool blk_mq_add_to_batch(struct 
>> request *req,
>>       return true;
>>   }
>> +/*
>> + * If the queue has allocated & used srcu to quiesce queue, quiesce 
>> wait is
>> + * done via the synchronize_srcu(q->rcu), otherwise it is done via 
>> global
>> + * synchronize_rcu().
>> + *
>> + * This helper can help us to support quiescing queue in parallel, so 
>> just
>> + * one quiesce wait is enough if global quiesce wait is allowed.
>> + */
>> +static inline bool blk_mq_global_quiesce_wait(struct request_queue *q)
>> +{
>> +    return !q->alloc_srcu;

	return !q->srcu ?
