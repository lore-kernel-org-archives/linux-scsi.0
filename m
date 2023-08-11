Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F87C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 00:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjHKAkA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 20:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjHKAj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 20:39:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A632D4F;
        Thu, 10 Aug 2023 17:39:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 286CC65562;
        Fri, 11 Aug 2023 00:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F4FC433C7;
        Fri, 11 Aug 2023 00:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691714397;
        bh=Uxg5A8RaCsTkq4FHfVHE3qK+2g4hsNfeftZ97Jf7uSk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Xs510ngZKU+JeALd2O9RnO+99l80wOp6c1gNDxIb5GruNi5gcZCM5LTueiTyQUY2I
         SQXcaMhmzSIMBRtuzWv9CBBe/IhY/UehpON0Cko5Gt/GqywtxiTFALH13D6p+yAHNX
         7o2WqWQFb5qephB5N9A0qK1DLL54QGyQYcRQOn1/FfX6T/qCWTH/vu1eettQE8Pfkt
         haub/Han2+HGVQXLmTsX7cZ2/ANJj6wSYOkvi8E0EzarT9fJnzaiDkS/kFvjdXPxw2
         bJDoFpLcmkJKXR3oa/MhnEGRRZyWTzEFtG+vT8e8t4CBu5kjqROKP9EfXwVh7jiu/P
         HdU7XW/xJIW8g==
Message-ID: <554dd42f-ab73-9120-1a9c-0a12b5d7981b@kernel.org>
Date:   Fri, 11 Aug 2023 09:39:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 1/7] block: Introduce the use_zone_write_lock member
 variable
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230809202355.1171455-1-bvanassche@acm.org>
 <20230809202355.1171455-2-bvanassche@acm.org>
 <8312a7c4-b3ef-873d-c4fa-825b7fce8be1@kernel.org>
 <3ebefe64-bb74-732e-68d1-faf9e3c5877b@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <3ebefe64-bb74-732e-68d1-faf9e3c5877b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/23 23:02, Bart Van Assche wrote:
> On 8/9/23 18:33, Damien Le Moal wrote:
>> On 8/10/23 05:23, Bart Van Assche wrote:
>>> Writes in sequential write required zones must happen at the write
>>> pointer. Even if the submitter of the write commands (e.g. a filesystem)
>>> submits writes for sequential write required zones in order, the block
>>> layer or the storage controller may reorder these write commands.
>>>
>>> The zone locking mechanism in the mq-deadline I/O scheduler serializes
>>> write commands for sequential zones. Some but not all storage controllers
>>> require this serialization. Introduce a new request queue limit member
>>> variable to allow block drivers to indicate that they preserve the order
>>> of write commands and thus do not require serialization of writes per
>>> zone.
>>>
>>> Cc: Damien Le Moal <dlemoal@kernel.org>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Ming Lei <ming.lei@redhat.com>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>>   block/blk-settings.c   | 6 ++++++
>>>   include/linux/blkdev.h | 1 +
>>>   2 files changed, 7 insertions(+)
>>>
>>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>>> index 0046b447268f..b75c97971860 100644
>>> --- a/block/blk-settings.c
>>> +++ b/block/blk-settings.c
>>> @@ -56,6 +56,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>>>   	lim->alignment_offset = 0;
>>>   	lim->io_opt = 0;
>>>   	lim->misaligned = 0;
>>> +	lim->use_zone_write_lock = true;
>>>   	lim->zoned = BLK_ZONED_NONE;
>>
>> Given that the default for zoned is BLK_ZONED_NONE, having use_zone_write_lock
>> default to true is strange. It would be better to set the default to false and
>> have disk_set_zoned() set it to true if needed, with an additional argument to
>> specify if it should be the case or not. E.g., for SMR drives, sd.c would call
>> something like:
>>
>> disk_set_zoned(sdkp->disk, BLK_ZONED_HM, sdp->use_zone_write_lock);
>>
>> sd.c would default to sdp->use_zone_write_lock == true and UFS driver can set
>> it to false. That would be cleaner I think.
> 
> Hi Damien,
> 
> Thanks for the detailed feedback.
> 
> My concerns about the above proposal are as follows:
> * The information about whether or not the zone write lock should be used comes
>    from the block driver, e.g. a SCSI LLD.

Yes.

> * sdp, the SCSI disk pointer, is owned by the ULD.
> * An ULD may be attached and detached multiple times during the lifetime of a
>    logical unit without the LLD being informed about this. So how to set
>    sdp->use_zone_write_lock without introducing a new callback or member variable
>    in a data structure owned by the LLD?

That would be set during device scan and device revalidate. And if the value
changes, then disk_set_zoned() should be called again to update the queue limit.
That is already what is done for the zoned limit indicating the type of the
drive. My point is that the zoned limit should dictate if use_zone_write_lock
can be true. The default should be be:

	q->limits.use_zone_write_lock = q->limits.zoned != BLK_ZONED_NONE.

And as proposed, if the UFS driver wants to disable zone write locking, all it
needs to do is call "disk_set_zoned(disk, BLK_ZONED_HM, false)". I did not try
to actually code that, and the scsi disk driver may be in the way and that may
need to be done there, hence the suggestion of having a use_zone_write_lock flag
in the scsi device structure so that the UFS driver can set it as needed as well
(and detect changes when revalidating). That should work, but I may be missing
something.

> Hence my preference to store use_zone_write_lock in a data structure that has the
> same lifetime as the logical unit and not in any data structure controlled by the
> ULD.

See above. The actual storage would still be in q->limits so that the block
layer can see it.

> 
>>>   	lim->zone_write_granularity = 0;
>>>   	lim->dma_alignment = 511;
>>> @@ -685,6 +686,11 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>>   						   b->max_secure_erase_sectors);
>>>   	t->zone_write_granularity = max(t->zone_write_granularity,
>>>   					b->zone_write_granularity);
>>> +	/*
>>> +	 * Whether or not the zone write lock should be used depends on the
>>> +	 * bottom driver only.
>>> +	 */
>>> +	t->use_zone_write_lock = b->use_zone_write_lock;
>>
>> Given that DM bio targets do not have a scheduler and do not have a zone lock
>> bitmap allocated, I do not think this is necessary at all. This can remain to
>> false, thus in sync with the fact that there is no IO scheduler.
> 
> How about the request-based dm drivers (dm-mpath and dm-target)? Isn't the dm-mpath
> driver request based because that allows the I/O scheduler to be configured on top
> of the dm-mpath driver? From https://lwn.net/Articles/274292/: "The basic idea to
> resolve the issue is to move multipathing layer down below the I/O scheduler, and it
> was proposed from Mike Christie as the block layer (request-based) multipath".

These DM targets do not support zoned devices, so I do not think it is an issue.

That said, you can still keep the parameter stacking, but at the very least, I
think it should be:

t->use_zone_write_lock = t->use_zone_write_lock || b->use_zone_write_lock;

so that for a target composed of multiple devices, if one needs zone write
locking, the DM device request that as well. Otherwise, problems may occur I think.

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

