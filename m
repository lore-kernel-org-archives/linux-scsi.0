Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EC3C001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 14:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbjHJOCE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 10:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjHJOCD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 10:02:03 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE373EA;
        Thu, 10 Aug 2023 07:02:02 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-56530cfee38so639116a12.2;
        Thu, 10 Aug 2023 07:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691676122; x=1692280922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=79gmeazvHAKk7515ds+nfk838n03+4+IxCe3JAS7JNM=;
        b=Qjr0XDtMDX9XkNL26tN1Q2m4PyW5HfZGmx6hQ94bG3+MjlQRPLWW/3zS9VtCePTH9z
         hWFiH8FBY8HLsSlYfaudjHS9mkIvw9YSi+7B2kWXmfPu/l78K0+sRLJqRFCmOVK1zSJ8
         3EFH7afBtO0YgahPbvTcqJqJXOW7IQnJ7oGvYpdjla6PPlP++6RwLtI23dO6+yWr0FPP
         jOmlTTHO0F2eK6TqCtH6whFIHvDJtvB9qBKyHZM6SdwS3HN1mJIi7RGBVpFC5vtg6qX9
         CqhvKU6VSrkQBDWMLNrYYfU5ymkO2q6uOj/ik6u3jgsqlyS91ozOQeajRao0tYyQY8qJ
         5iAg==
X-Gm-Message-State: AOJu0YzvwGetaLKO05oYfHmljUP59Z0UeiU/7SA/ZD08kgLp6msdM2BI
        5FZXhocSfhl+tBrLPwYiGGg=
X-Google-Smtp-Source: AGHT+IElLA0DuXeX2kI/4A01w+Zr2jYc3j3TJjS6w18oNjp3zAIKpjTqgkE5AMLM4oWFsnH2I7WFWQ==
X-Received: by 2002:a17:90b:2310:b0:262:df91:cdce with SMTP id mt16-20020a17090b231000b00262df91cdcemr1902786pjb.23.1691676121968;
        Thu, 10 Aug 2023 07:02:01 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f10-20020a170902ce8a00b001b7fd27144dsm1787088plg.40.2023.08.10.07.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 07:02:01 -0700 (PDT)
Message-ID: <3ebefe64-bb74-732e-68d1-faf9e3c5877b@acm.org>
Date:   Thu, 10 Aug 2023 07:02:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 1/7] block: Introduce the use_zone_write_lock member
 variable
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230809202355.1171455-1-bvanassche@acm.org>
 <20230809202355.1171455-2-bvanassche@acm.org>
 <8312a7c4-b3ef-873d-c4fa-825b7fce8be1@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8312a7c4-b3ef-873d-c4fa-825b7fce8be1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/23 18:33, Damien Le Moal wrote:
> On 8/10/23 05:23, Bart Van Assche wrote:
>> Writes in sequential write required zones must happen at the write
>> pointer. Even if the submitter of the write commands (e.g. a filesystem)
>> submits writes for sequential write required zones in order, the block
>> layer or the storage controller may reorder these write commands.
>>
>> The zone locking mechanism in the mq-deadline I/O scheduler serializes
>> write commands for sequential zones. Some but not all storage controllers
>> require this serialization. Introduce a new request queue limit member
>> variable to allow block drivers to indicate that they preserve the order
>> of write commands and thus do not require serialization of writes per
>> zone.
>>
>> Cc: Damien Le Moal <dlemoal@kernel.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   block/blk-settings.c   | 6 ++++++
>>   include/linux/blkdev.h | 1 +
>>   2 files changed, 7 insertions(+)
>>
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index 0046b447268f..b75c97971860 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -56,6 +56,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>>   	lim->alignment_offset = 0;
>>   	lim->io_opt = 0;
>>   	lim->misaligned = 0;
>> +	lim->use_zone_write_lock = true;
>>   	lim->zoned = BLK_ZONED_NONE;
> 
> Given that the default for zoned is BLK_ZONED_NONE, having use_zone_write_lock
> default to true is strange. It would be better to set the default to false and
> have disk_set_zoned() set it to true if needed, with an additional argument to
> specify if it should be the case or not. E.g., for SMR drives, sd.c would call
> something like:
> 
> disk_set_zoned(sdkp->disk, BLK_ZONED_HM, sdp->use_zone_write_lock);
> 
> sd.c would default to sdp->use_zone_write_lock == true and UFS driver can set
> it to false. That would be cleaner I think.

Hi Damien,

Thanks for the detailed feedback.

My concerns about the above proposal are as follows:
* The information about whether or not the zone write lock should be used comes
   from the block driver, e.g. a SCSI LLD.
* sdp, the SCSI disk pointer, is owned by the ULD.
* An ULD may be attached and detached multiple times during the lifetime of a
   logical unit without the LLD being informed about this. So how to set
   sdp->use_zone_write_lock without introducing a new callback or member variable
   in a data structure owned by the LLD?

Hence my preference to store use_zone_write_lock in a data structure that has the
same lifetime as the logical unit and not in any data structure controlled by the
ULD.

>>   	lim->zone_write_granularity = 0;
>>   	lim->dma_alignment = 511;
>> @@ -685,6 +686,11 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>   						   b->max_secure_erase_sectors);
>>   	t->zone_write_granularity = max(t->zone_write_granularity,
>>   					b->zone_write_granularity);
>> +	/*
>> +	 * Whether or not the zone write lock should be used depends on the
>> +	 * bottom driver only.
>> +	 */
>> +	t->use_zone_write_lock = b->use_zone_write_lock;
> 
> Given that DM bio targets do not have a scheduler and do not have a zone lock
> bitmap allocated, I do not think this is necessary at all. This can remain to
> false, thus in sync with the fact that there is no IO scheduler.

How about the request-based dm drivers (dm-mpath and dm-target)? Isn't the dm-mpath
driver request based because that allows the I/O scheduler to be configured on top
of the dm-mpath driver? From https://lwn.net/Articles/274292/: "The basic idea to
resolve the issue is to move multipathing layer down below the I/O scheduler, and it
was proposed from Mike Christie as the block layer (request-based) multipath".

Thanks,

Bart.

