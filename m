Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AAC3C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 22:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E3722B43
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 22:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="ez6goNBZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgGaWdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 18:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgGaWdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 18:33:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC96AC061756
        for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2020 15:33:23 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j20so15144162pfe.5
        for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2020 15:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0KKrv5DoyuQz15M0mZ1eRrECoI3/UELjFCR2+4/Uoj4=;
        b=ez6goNBZnHXsAdVT2aUcbdkkfK4487XFGRwcv7VcdTKiB4wkzk8RMT2Sgja4BEYOyH
         XIwFE9n5KuEZABTKXVdGUG5xaNKJGljQpjmDAJC4RdG95NyEBbX9hNIyZ2F7NNywx93N
         EdxYLSUca+V3G5mvDeihhVhQSyU5hFNCRmQckarahGCSIM03ZBEk+iPlL9AGE5QY0+yo
         bd/vMIyp1fUTATQkf8uKSjVMgtRZWl9vIMBoUk6lbfKGV8cPvcAfLwObWNLMqjjjDZFW
         XhhCV8Qqjs1LpsqdpgePG0x56hEJpCpwuy9ohvJafib10WlXNmT8lfAX0azhaKW3l0oG
         Fcmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0KKrv5DoyuQz15M0mZ1eRrECoI3/UELjFCR2+4/Uoj4=;
        b=rpukr6Zw+pnA0BxbxTMlPG4AhVR/K0oIVAEwEaMrdbQ8r/tqlOTRWKjaw6wKVMP3iw
         POXhpujTaYi3TJrRmVN8I5juYPUIIgZsOnpte2AdeRPQ2bKZAZ9Bd+vQVYny2ycpfhpp
         rYxb3b3wc/s0Zb1e12pNjE5curAVvEJ8YLicxjxfyr0L+Nb1JZRT8QNbE+vVop2yK9Mi
         eTPWGRePaQSMw9OWVikjLOCZ9mZuNHO7vuRznIubRUyKjh+gVxMpxeE9h6W/iR6od+qb
         IQv131L5GVTcZRZrhXxZKZuoRyJHDwE0YMKSW1nryCE/Nniw/d5uB/VpIBxUVnEtnHQR
         pW7A==
X-Gm-Message-State: AOAM533Pv8RU/U3MyOi73GNcL74JWxpuQcmWmRfLsepSSRwRqZoLtPu1
        tEFkxrChFX7PZmtp+x5MSrcz4oFBxb8=
X-Google-Smtp-Source: ABdhPJxAMbc9nRmDjHh8cVd6RORwwCPUYDSOufHkMzYCn8KrKzHu52NoaLuTA2vmCnbmdxpOnPaoqA==
X-Received: by 2002:aa7:8a0d:: with SMTP id m13mr5431313pfa.13.1596234803107;
        Fri, 31 Jul 2020 15:33:23 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c1::1a3a? ([2620:10d:c090:400::5:f6ff])
        by smtp.gmail.com with ESMTPSA id g12sm4111785pjd.6.2020.07.31.15.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 15:33:22 -0700 (PDT)
Subject: Re: [PATCH] block: don't do revalidate zones on invalid devices
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20200730112517.12816-1-johannes.thumshirn@wdc.com>
 <CY4PR04MB3751A56EDE1C372CB7531EE0E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
 <SN4PR0401MB3598C060632877CA0C46918A9B4E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a3ad1a03-d279-b57f-152d-ee41ad8883a5@kernel.dk>
Date:   Fri, 31 Jul 2020 16:33:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <SN4PR0401MB3598C060632877CA0C46918A9B4E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/31/20 1:43 AM, Johannes Thumshirn wrote:
> On 30/07/2020 14:33, Damien Le Moal wrote:
>> On 2020/07/30 20:25, Johannes Thumshirn wrote:
>>> When we loose a device for whatever reason while (re)scanning zones, we
>>> trip over a NULL pointer in blk_revalidate_zone_cb, like in the following
>>> log:
>>>
>>> sd 0:0:0:0: [sda] 3418095616 4096-byte logical blocks: (14.0 TB/12.7 TiB)
>>> sd 0:0:0:0: [sda] 52156 zones of 65536 logical blocks
>>> sd 0:0:0:0: [sda] Write Protect is off
>>> sd 0:0:0:0: [sda] Mode Sense: 37 00 00 08
>>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>>> sd 0:0:0:0: [sda] REPORT ZONES start lba 1065287680 failed
>>> sd 0:0:0:0: [sda] REPORT ZONES: Result: hostbyte=0x00 driverbyte=0x08
>>> sd 0:0:0:0: [sda] Sense Key : 0xb [current]
>>> sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x6
>>> sda: failed to revalidate zones
>>> sd 0:0:0:0: [sda] 0 4096-byte logical blocks: (0 B/0 B)
>>> sda: detected capacity change from 14000519643136 to 0
>>> ==================================================================
>>> BUG: KASAN: null-ptr-deref in blk_revalidate_zone_cb+0x1b7/0x550
>>> Write of size 8 at addr 0000000000000010 by task kworker/u4:1/58
>>>
>>> CPU: 1 PID: 58 Comm: kworker/u4:1 Not tainted 5.8.0-rc1 #692
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4-rebuilt.opensuse.org 04/01/2014
>>> Workqueue: events_unbound async_run_entry_fn
>>> Call Trace:
>>>  dump_stack+0x7d/0xb0
>>>  ? blk_revalidate_zone_cb+0x1b7/0x550
>>>  kasan_report.cold+0x5/0x37
>>>  ? blk_revalidate_zone_cb+0x1b7/0x550
>>>  check_memory_region+0x145/0x1a0
>>>  blk_revalidate_zone_cb+0x1b7/0x550
>>>  sd_zbc_parse_report+0x1f1/0x370
>>>  ? blk_req_zone_write_trylock+0x200/0x200
>>>  ? sectors_to_logical+0x60/0x60
>>>  ? blk_req_zone_write_trylock+0x200/0x200
>>>  ? blk_req_zone_write_trylock+0x200/0x200
>>>  sd_zbc_report_zones+0x3c4/0x5e0
>>>  ? sd_dif_config_host+0x500/0x500
>>>  blk_revalidate_disk_zones+0x231/0x44d
>>>  ? _raw_write_lock_irqsave+0xb0/0xb0
>>>  ? blk_queue_free_zone_bitmaps+0xd0/0xd0
>>>  sd_zbc_read_zones+0x8cf/0x11a0
>>>  sd_revalidate_disk+0x305c/0x64e0
>>>  ? __device_add_disk+0x776/0xf20
>>>  ? read_capacity_16.part.0+0x1080/0x1080
>>>  ? blk_alloc_devt+0x250/0x250
>>>  ? create_object.isra.0+0x595/0xa20
>>>  ? kasan_unpoison_shadow+0x33/0x40
>>>  sd_probe+0x8dc/0xcd2
>>>  really_probe+0x20e/0xaf0
>>>  __driver_attach_async_helper+0x249/0x2d0
>>>  async_run_entry_fn+0xbe/0x560
>>>  process_one_work+0x764/0x1290
>>>  ? _raw_read_unlock_irqrestore+0x30/0x30
>>>  worker_thread+0x598/0x12f0
>>>  ? __kthread_parkme+0xc6/0x1b0
>>>  ? schedule+0xed/0x2c0
>>>  ? process_one_work+0x1290/0x1290
>>>  kthread+0x36b/0x440
>>>  ? kthread_create_worker_on_cpu+0xa0/0xa0
>>>  ret_from_fork+0x22/0x30
>>> ==================================================================
>>>
>>> When the device is already gone we end up with the following scenario:
>>> The device's capacity is 0 and thus the number of zones will be 0 as well. When
>>> allocating the bitmap for the conventional zones, we then trip over a NULL
>>> pointer.
>>>
>>> So if we encounter a zoned block device with a 0 capacity, don't dare to
>>> revalidate the zones sizes.
>>>
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>> ---
>>>
>>> Note: This is a hot-fix for 5.8, we're working on something to make a
>>> recoverable error recoverable.
>>>
>>>
>>>  block/blk-zoned.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>>> index 23831fa8701d..480dfff69a00 100644
>>> --- a/block/blk-zoned.c
>>> +++ b/block/blk-zoned.c
>>> @@ -497,6 +497,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>>>  	if (WARN_ON_ONCE(!queue_is_mq(q)))
>>>  		return -EIO;
>>>  
>>> +	if (!get_capacity(disk))
>>> +		return -EIO;
>>> +
>>>  	/*
>>>  	 * Ensure that all memory allocations in this context are done as if
>>>  	 * GFP_NOIO was specified.
>>>
>>
>> I reworked sd_zbc_read_zones() and sd_zbc_revalidate_zones() to allow recovering
>> from simple temporary errors and avoid this problem. Will send the patch
>> tomorrow or so after some more testing.
>>
>> But even with that patch applied, I think this patch makes the generic block
>> code more solid. So:
>>
>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
>>
>>
> 
> Jens any chance we can still get this into 5.8?

I'm not going to push this out now, if 5.8 is being cut on Sunday. If we
happen to get an -rc8, then it's not impossible.

But this isn't a regression in this merge window as far as I can tell,
so really shouldn't be critical to get in. Marking it for stable etc and
queueing for 5.9 may be the saner approach, imho.

-- 
Jens Axboe

