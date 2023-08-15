Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFF2C001B0
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 02:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbjHOCBn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 22:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbjHOCBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 22:01:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BB4DD;
        Mon, 14 Aug 2023 19:01:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C9BE62BF9;
        Tue, 15 Aug 2023 02:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4810C433C7;
        Tue, 15 Aug 2023 02:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692064870;
        bh=Vjc4rhFXLW7GsoK55D+2oukOvsa3PehjWIrhqNx3I40=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oNn9zhVCfqYnvKLshaJ8KZQLEdiFuwejlIoG2Y1HKV8zI10pWQE4A3fEpZbmEYoD7
         Kc2UOolywm/c+vKwCDH/RdzcKYwuBUUYvxp78dLFrEUan4WjSIt3o+YlHeQ4R51Ywo
         RTC9yEQ5WG5getgsfixYE71c+VMqo9hgA1j+yf+exRUb83BJ2vGobK5NpplByV6mHv
         Qjjl0z5UR7EGtyqoieUdWxCCqYoSQuANkzoh/DIV4SS1PSNf5hacijhv9Nsl5wDOcL
         sLqUk5M8bTyl8ZoXhMkqs5gKYFIo6S1trizATs5RVLWCG+UU1rMQyMoQf1WeWGAUDC
         KdfIksGAoMmKw==
Message-ID: <66fa32a0-1c0d-1346-a77f-42b99058a1c3@kernel.org>
Date:   Tue, 15 Aug 2023 11:01:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v8 1/9] block: Introduce more member variables related to
 zone write locking
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-2-bvanassche@acm.org>
 <3188f400-b387-7be8-0f21-cf5089fe1411@kernel.org>
 <5a2b24c5-14c5-57a6-8af0-6ebdee2371de@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <5a2b24c5-14c5-57a6-8af0-6ebdee2371de@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/15/23 01:57, Bart Van Assche wrote:
> On 8/14/23 05:32, Damien Le Moal wrote:
>> On 8/12/23 06:35, Bart Van Assche wrote:
>>> --- a/block/blk-settings.c
>>> +++ b/block/blk-settings.c
>>> @@ -56,6 +56,8 @@ void blk_set_default_limits(struct queue_limits *lim)
>>>   	lim->alignment_offset = 0;
>>>   	lim->io_opt = 0;
>>>   	lim->misaligned = 0;
>>> +	lim->driver_preserves_write_order = false;
>>> +	lim->use_zone_write_lock = false;
>>>   	lim->zoned = BLK_ZONED_NONE;
>>>   	lim->zone_write_granularity = 0;
>>>   	lim->dma_alignment = 511;
>>> @@ -685,6 +687,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>>   						   b->max_secure_erase_sectors);
>>>   	t->zone_write_granularity = max(t->zone_write_granularity,
>>>   					b->zone_write_granularity);
>>> +	/* Request-based stacking drivers do not reorder requests. */
>>> +	t->driver_preserves_write_order = b->driver_preserves_write_order;
>>> +	t->use_zone_write_lock = b->use_zone_write_lock;
>>
>> I do not think this is correct as the last target of a multi target device will
>> dictate the result, regardless of the other targets. So this should be something
>> like:
>>
>> 	t->driver_preserves_write_order = t->driver_preserves_write_order &&
>> 		b->driver_preserves_write_order;
>> 	t->use_zone_write_lock =
>> 		t->use_zone_write_lock || b->use_zone_write_lock;
>>
>> However, given that driver_preserves_write_order is initialized as false, this
>> would always be false. Not sure how to handle that...
> 
> How about integrating the (untested) change below into this patch? It keeps
> the default value for driver_preserves_write_order to false for regular block
> drivers and changes the default value to true for stacking drivers:
> 
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -84,6 +84,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>   	lim->max_dev_sectors = UINT_MAX;
>   	lim->max_write_zeroes_sectors = UINT_MAX;
>   	lim->max_zone_append_sectors = UINT_MAX;
> +	lim->driver_preserves_write_order = true;
>   }
>   EXPORT_SYMBOL(blk_set_stacking_limits);
> 
> @@ -688,8 +689,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>   	t->zone_write_granularity = max(t->zone_write_granularity,
>   					b->zone_write_granularity);
>   	/* Request-based stacking drivers do not reorder requests. */
> -	t->driver_preserves_write_order = b->driver_preserves_write_order;
> -	t->use_zone_write_lock = b->use_zone_write_lock;
> +	t->driver_preserves_write_order = t->driver_preserves_write_order &&
> +		b->driver_preserves_write_order;
> +	t->use_zone_write_lock = t->use_zone_write_lock ||
> +		b->use_zone_write_lock;
>   	t->zoned = max(t->zoned, b->zoned);
>   	return ret;
>   }

I think that should work. Testing/checking this with dm-linear by combining
different null-blk devices with different configs should be easy enough.

> 
> 
>>>   	t->zoned = max(t->zoned, b->zoned);
>>>   	return ret;
>>>   }
>>> @@ -949,6 +954,8 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
>>>   	}
>>>   
>>>   	q->limits.zoned = model;
>>> +	q->limits.use_zone_write_lock = model != BLK_ZONED_NONE &&
>>> +		!q->limits.driver_preserves_write_order;
>>
>> I think this needs a comment to explain the condition as it takes a while to
>> understand it.
> 
> Something like this?
> 
> 	/*
> 	 * Use the zone write lock only for zoned block devices and only if
> 	 * the block driver does not preserve the order of write commands.
> 	 */

That works for me.

> 
>>>   	if (model != BLK_ZONED_NONE) {
>>>   		/*
>>>   		 * Set the zone write granularity to the device logical block
>>
>> You also should set use_zone_write_lock to false in disk_clear_zone_settings().
> 
> I will do this.
> 
>> In patch 9, ufshcd_auto_hibern8_update() changes the value of
>> driver_preserves_write_order, which will change the value of use_zone_write_lock
>> only if disk_set_zoned() is called again after ufshcd_auto_hibern8_update(). Is
>> that the case ? Is the drive revalidated always after
>> ufshcd_auto_hibern8_update() is executed ?
> 
> I will start with testing this change on top of this patch series:
> 
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4350,6 +4350,7 @@ static void ufshcd_update_preserves_write_order(struct ufs_hba *hba,
>   		blk_mq_freeze_queue_wait(q);
>   		q->limits.driver_preserves_write_order = preserves_write_order;
>   		blk_mq_unfreeze_queue(q);
> +		scsi_rescan_device(&sdev->sdev_gendev);

Maybe calling disk_set_zoned() before blk_mq_unfreeze_queue() should be enough ?
rescan/revalidate will be done in case you get a topology change event (or
equivalent), which I think is not the case here.

>   	}
>   }
> 
> Thanks,
> 
> Bart.
> 
> 

-- 
Damien Le Moal
Western Digital Research

