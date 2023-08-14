Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FA6C04A94
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 16:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjHNQ6L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjHNQ54 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 12:57:56 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ABE199E;
        Mon, 14 Aug 2023 09:57:45 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-564b6276941so3487567a12.3;
        Mon, 14 Aug 2023 09:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692032235; x=1692637035;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRgSn8an5DVvRtNVf2VnUiHGPuAOy7TT2Z0PrD/nMUg=;
        b=j8lTjpZ0Q5Q4rGY3EC+NLXw8zNzNYk/JdsRaHrjn7lrbjI2Vgr4a1KU8rvtUU/NHkF
         SvVx3O8wl55Iw/uPOK0HcGeGVtOuTaFkeTcFrgaU9kUGzDNmCZXe14GsEgSqgFgVkyQz
         QVyb37MLmzmGQnIucrv/QkSTLQtqjejF0wiPOF4c9OEeOdrrM7TvRFHECh0ICMp277RC
         MlJo5I7mui9Ys1/Pxfpcg5FxF5dtNxFw5Qybez031rn0rF0n0fFIlHND59aTZTBEVwPx
         Hy411x2/w+SPd1MBYMzSRQjchf5L7fV5pdi20ceHHRbnkeQqWQ4yLa+S1nxtEvOUL5YA
         td+g==
X-Gm-Message-State: AOJu0Yy0SCVLLxKIwTbhRh6nKofdqEh0kKeMeHDbrXLwDox2SzVGCqFP
        RmSE3Ghvwb2BXfkgFvpFWj5QTLg7ohQ=
X-Google-Smtp-Source: AGHT+IFhJlE2HySFdnhRntgMYp29KtQcC19NOtV61Jis3RToMdbn/La/7zjyodfdGfjBsTjKSuaSAQ==
X-Received: by 2002:a05:6a21:47c6:b0:140:2805:6cc9 with SMTP id as6-20020a056a2147c600b0014028056cc9mr11697459pzc.57.1692032234689;
        Mon, 14 Aug 2023 09:57:14 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e105:59a6:229c:65de? ([2620:15c:211:201:e105:59a6:229c:65de])
        by smtp.gmail.com with ESMTPSA id l20-20020a637014000000b00563c1aa277asm8954826pgc.6.2023.08.14.09.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 09:57:14 -0700 (PDT)
Message-ID: <5a2b24c5-14c5-57a6-8af0-6ebdee2371de@acm.org>
Date:   Mon, 14 Aug 2023 09:57:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v8 1/9] block: Introduce more member variables related to
 zone write locking
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-2-bvanassche@acm.org>
 <3188f400-b387-7be8-0f21-cf5089fe1411@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3188f400-b387-7be8-0f21-cf5089fe1411@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 05:32, Damien Le Moal wrote:
> On 8/12/23 06:35, Bart Van Assche wrote:
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -56,6 +56,8 @@ void blk_set_default_limits(struct queue_limits *lim)
>>   	lim->alignment_offset = 0;
>>   	lim->io_opt = 0;
>>   	lim->misaligned = 0;
>> +	lim->driver_preserves_write_order = false;
>> +	lim->use_zone_write_lock = false;
>>   	lim->zoned = BLK_ZONED_NONE;
>>   	lim->zone_write_granularity = 0;
>>   	lim->dma_alignment = 511;
>> @@ -685,6 +687,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>   						   b->max_secure_erase_sectors);
>>   	t->zone_write_granularity = max(t->zone_write_granularity,
>>   					b->zone_write_granularity);
>> +	/* Request-based stacking drivers do not reorder requests. */
>> +	t->driver_preserves_write_order = b->driver_preserves_write_order;
>> +	t->use_zone_write_lock = b->use_zone_write_lock;
> 
> I do not think this is correct as the last target of a multi target device will
> dictate the result, regardless of the other targets. So this should be something
> like:
> 
> 	t->driver_preserves_write_order = t->driver_preserves_write_order &&
> 		b->driver_preserves_write_order;
> 	t->use_zone_write_lock =
> 		t->use_zone_write_lock || b->use_zone_write_lock;
> 
> However, given that driver_preserves_write_order is initialized as false, this
> would always be false. Not sure how to handle that...

How about integrating the (untested) change below into this patch? It keeps
the default value for driver_preserves_write_order to false for regular block
drivers and changes the default value to true for stacking drivers:

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -84,6 +84,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
  	lim->max_dev_sectors = UINT_MAX;
  	lim->max_write_zeroes_sectors = UINT_MAX;
  	lim->max_zone_append_sectors = UINT_MAX;
+	lim->driver_preserves_write_order = true;
  }
  EXPORT_SYMBOL(blk_set_stacking_limits);

@@ -688,8 +689,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
  	t->zone_write_granularity = max(t->zone_write_granularity,
  					b->zone_write_granularity);
  	/* Request-based stacking drivers do not reorder requests. */
-	t->driver_preserves_write_order = b->driver_preserves_write_order;
-	t->use_zone_write_lock = b->use_zone_write_lock;
+	t->driver_preserves_write_order = t->driver_preserves_write_order &&
+		b->driver_preserves_write_order;
+	t->use_zone_write_lock = t->use_zone_write_lock ||
+		b->use_zone_write_lock;
  	t->zoned = max(t->zoned, b->zoned);
  	return ret;
  }


>>   	t->zoned = max(t->zoned, b->zoned);
>>   	return ret;
>>   }
>> @@ -949,6 +954,8 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
>>   	}
>>   
>>   	q->limits.zoned = model;
>> +	q->limits.use_zone_write_lock = model != BLK_ZONED_NONE &&
>> +		!q->limits.driver_preserves_write_order;
> 
> I think this needs a comment to explain the condition as it takes a while to
> understand it.

Something like this?

	/*
	 * Use the zone write lock only for zoned block devices and only if
	 * the block driver does not preserve the order of write commands.
	 */

>>   	if (model != BLK_ZONED_NONE) {
>>   		/*
>>   		 * Set the zone write granularity to the device logical block
> 
> You also should set use_zone_write_lock to false in disk_clear_zone_settings().

I will do this.

> In patch 9, ufshcd_auto_hibern8_update() changes the value of
> driver_preserves_write_order, which will change the value of use_zone_write_lock
> only if disk_set_zoned() is called again after ufshcd_auto_hibern8_update(). Is
> that the case ? Is the drive revalidated always after
> ufshcd_auto_hibern8_update() is executed ?

I will start with testing this change on top of this patch series:

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4350,6 +4350,7 @@ static void ufshcd_update_preserves_write_order(struct ufs_hba *hba,
  		blk_mq_freeze_queue_wait(q);
  		q->limits.driver_preserves_write_order = preserves_write_order;
  		blk_mq_unfreeze_queue(q);
+		scsi_rescan_device(&sdev->sdev_gendev);
  	}
  }

Thanks,

Bart.


