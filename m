Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184B1C28E83
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 10:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4CE72084D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 10:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgIDKAB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:00:01 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40534 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbgIDJ77 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 05:59:59 -0400
Received: by mail-lj1-f196.google.com with SMTP id s205so7234636lja.7;
        Fri, 04 Sep 2020 02:59:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BzveIHNoi88qKdyFZB6KJTU9/KV7yTa345gIr/LCGBg=;
        b=rLwiiSxGdb9XCa8WTYhWz7SeQiYkqD65Rm+qcBHAB6xDJZUOXalgLCaJExwhBWHS1X
         OdM111A+npJcfIrI0p8Ws+5f7En9Ig9VZyWXWTJHTsng+5NjuJRyW61/eME7sLoexeEC
         73slqNQsg+fShsqAB99FkU6IHk1PH0PVOdSUEESG/rgWidijDPq2mrG9kQFTskTOzWGW
         xZZcUwi4B7SzSOhaM5b7wgMUXQOLqCMBgzvsne8xhRex4VHMxugAHnm6wVZPEgDlIgrk
         BiwJAtoim4Pq3yJlzaWo3FAtqS1N0yn+cwjXX7YBoYO4wl2/G5I36At04V4xxwkdhUg+
         Z2BQ==
X-Gm-Message-State: AOAM531y9IbcUUMQwG3UJZUmXnMEOGhDMsOE/A9ZLO4Z/mKf5V2E70pQ
        JbvlwaFnAQ5Hodxt1JCJUAM=
X-Google-Smtp-Source: ABdhPJz4HH2NujcvYdPNRgQS5ulHHmgMAX1EghA57nCGJD/ItPTV/HZZqn26nda6nkHpqs+D8yofTQ==
X-Received: by 2002:a2e:86d3:: with SMTP id n19mr3711447ljj.368.1599213594283;
        Fri, 04 Sep 2020 02:59:54 -0700 (PDT)
Received: from [10.68.32.147] (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.gmail.com with ESMTPSA id y196sm1233565lfa.0.2020.09.04.02.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 02:59:53 -0700 (PDT)
Reply-To: efremov@linux.com
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
References: <20200903080119.441674-1-hch@lst.de>
 <20200903080119.441674-15-hch@lst.de>
From:   Denis Efremov <efremov@linux.com>
Autocrypt: addr=efremov@linux.com; keydata=
 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
Subject: Re: [PATCH 14/19] floppy: use a separate gendisk for each media
 format
Message-ID: <c8b63637-3cc0-8571-1c5d-fdb2dbd8ea18@linux.com>
Date:   Fri, 4 Sep 2020 12:59:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200903080119.441674-15-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 9/3/20 11:01 AM, Christoph Hellwig wrote:
> The floppy driver usually autodetects the media when used with the
> normal /dev/fd? devices, which also are the only nodes created by udev.
> But it also supports various aliases that force a given media format.
> That is currently supported using the blk_register_region framework
> which finds the floppy gendisk even for a 'mismatched' dev_t.  The
> problem with this (besides the code complexity) is that it creates
> multiple struct block_device instances for the whole device of a
> single gendisk, which can lead to interesting issues in code not
> aware of that fact.
> 
> To fix this just create a separate gendisk for each of the aliases
> if they are accessed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Tested-by: Denis Efremov <efremov@linux.com>

The patch looks ok as it is. Two nitpicks below if you will send next revision.

> ---
>  drivers/block/floppy.c | 154 ++++++++++++++++++++++++++---------------
>  1 file changed, 97 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index a563b023458a8b..f07d97558cb698 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -402,7 +402,6 @@ static struct floppy_drive_params drive_params[N_DRIVE];
>  static struct floppy_drive_struct drive_state[N_DRIVE];
>  static struct floppy_write_errors write_errors[N_DRIVE];
>  static struct timer_list motor_off_timer[N_DRIVE];
> -static struct gendisk *disks[N_DRIVE];
>  static struct blk_mq_tag_set tag_sets[N_DRIVE];
>  static struct block_device *opened_bdev[N_DRIVE];
>  static DEFINE_MUTEX(open_lock);
> @@ -477,6 +476,8 @@ static struct floppy_struct floppy_type[32] = {
>  	{ 3200,20,2,80,0,0x1C,0x00,0xCF,0x2C,"H1600" }, /* 31 1.6MB 3.5"    */
>  };
>  
> +static struct gendisk *disks[N_DRIVE][ARRAY_SIZE(floppy_type)];
> +
>  #define SECTSIZE (_FD_SECTSIZE(*floppy))
>  
>  /* Auto-detection: Disk type used until the next media change occurs. */
> @@ -4109,7 +4110,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
>  
>  	new_dev = MINOR(bdev->bd_dev);
>  	drive_state[drive].fd_device = new_dev;
> -	set_capacity(disks[drive], floppy_sizes[new_dev]);
> +	set_capacity(disks[drive][ITYPE(new_dev)], floppy_sizes[new_dev]);
>  	if (old_dev != -1 && old_dev != new_dev) {
>  		if (buffer_drive == drive)
>  			buffer_track = -1;
> @@ -4577,15 +4578,58 @@ static bool floppy_available(int drive)
>  	return true;
>  }
>  
> -static struct kobject *floppy_find(dev_t dev, int *part, void *data)
> +static int floppy_alloc_disk(unsigned int drive, unsigned int type)
>  {
> -	int drive = (*part & 3) | ((*part & 0x80) >> 5);
> -	if (drive >= N_DRIVE || !floppy_available(drive))
> -		return NULL;
> -	if (((*part >> 2) & 0x1f) >= ARRAY_SIZE(floppy_type))
> -		return NULL;
> -	*part = 0;
> -	return get_disk_and_module(disks[drive]);
> +	struct gendisk *disk;
> +	int err;
> +
> +	disk = alloc_disk(1);
> +	if (!disk)
> +		return -ENOMEM;
> +
> +	disk->queue = blk_mq_init_queue(&tag_sets[drive]);
> +	if (IS_ERR(disk->queue)) {
> +		err = PTR_ERR(disk->queue);
> +		disk->queue = NULL;
> +		put_disk(disk);
> +		return err;
> +	}
> +
> +	blk_queue_bounce_limit(disk->queue, BLK_BOUNCE_HIGH);
> +	blk_queue_max_hw_sectors(disk->queue, 64);
> +	disk->major = FLOPPY_MAJOR;
> +	disk->first_minor = TOMINOR(drive) | (type << 2);
> +	disk->fops = &floppy_fops;
> +	disk->events = DISK_EVENT_MEDIA_CHANGE;
> +	if (type)
> +		sprintf(disk->disk_name, "fd%d_type%d", drive, type);
> +	else
> +		sprintf(disk->disk_name, "fd%d", drive);
> +	/* to be cleaned up... */
> +	disk->private_data = (void *)(long)drive;
> +	disk->flags |= GENHD_FL_REMOVABLE;
> +
> +	disks[drive][type] = disk;
> +	return 0;
> +}
> +
> +static DEFINE_MUTEX(floppy_probe_lock);
> +
> +static void floppy_probe(dev_t dev)
> +{
> +	unsigned int drive = (MINOR(dev) & 3) | ((MINOR(dev) & 0x80) >> 5);
> +	unsigned int type = (MINOR(dev) >> 2) & 0x1f;

	ITYPE(MINOR(dev))?

> +
> +	if (drive >= N_DRIVE || !floppy_available(drive) ||
> +	    type >= ARRAY_SIZE(floppy_type))
> +		return;
> +
> +	mutex_lock(&floppy_probe_lock);
> +	if (!disks[drive][type]) {
> +		if (floppy_alloc_disk(drive, type) == 0)
> +			add_disk(disks[drive][type]);
> +	}
> +	mutex_unlock(&floppy_probe_lock);
>  }
>  
>  static int __init do_floppy_init(void)
> @@ -4607,33 +4651,25 @@ static int __init do_floppy_init(void)
>  		return -ENOMEM;
>  
>  	for (drive = 0; drive < N_DRIVE; drive++) {
> -		disks[drive] = alloc_disk(1);
> -		if (!disks[drive]) {
> -			err = -ENOMEM;
> +		memset(&tag_sets[drive], 0, sizeof(tag_sets[drive]));
> +		tag_sets[drive].ops = &floppy_mq_ops;
> +		tag_sets[drive].nr_hw_queues = 1;
> +		tag_sets[drive].nr_maps = 1;
> +		tag_sets[drive].queue_depth = 2;
> +		tag_sets[drive].numa_node = NUMA_NO_NODE;
> +		tag_sets[drive].flags = BLK_MQ_F_SHOULD_MERGE;
> +		err = blk_mq_alloc_tag_set(&tag_sets[drive]);
> +		if (err)
>  			goto out_put_disk;
> -		}
>  
> -		disks[drive]->queue = blk_mq_init_sq_queue(&tag_sets[drive],
> -							   &floppy_mq_ops, 2,
> -							   BLK_MQ_F_SHOULD_MERGE);
> -		if (IS_ERR(disks[drive]->queue)) {
> -			err = PTR_ERR(disks[drive]->queue);
> -			disks[drive]->queue = NULL;
> +		err = floppy_alloc_disk(drive, 0);
> +		if (err)
>  			goto out_put_disk;
> -		}
> -
> -		blk_queue_bounce_limit(disks[drive]->queue, BLK_BOUNCE_HIGH);
> -		blk_queue_max_hw_sectors(disks[drive]->queue, 64);
> -		disks[drive]->major = FLOPPY_MAJOR;
> -		disks[drive]->first_minor = TOMINOR(drive);
> -		disks[drive]->fops = &floppy_fops;
> -		disks[drive]->events = DISK_EVENT_MEDIA_CHANGE;
> -		sprintf(disks[drive]->disk_name, "fd%d", drive);
>  
>  		timer_setup(&motor_off_timer[drive], motor_off_callback, 0);
>  	}
>  
> -	err = register_blkdev(FLOPPY_MAJOR, "fd");
> +	err = __register_blkdev(FLOPPY_MAJOR, "fd", floppy_probe);
>  	if (err)
>  		goto out_put_disk;
>  
> @@ -4641,9 +4677,6 @@ static int __init do_floppy_init(void)
>  	if (err)
>  		goto out_unreg_blkdev;
>  
> -	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
> -			    floppy_find, NULL, NULL);
> -
>  	for (i = 0; i < 256; i++)
>  		if (ITYPE(i))
>  			floppy_sizes[i] = floppy_type[ITYPE(i)].size;
> @@ -4671,7 +4704,7 @@ static int __init do_floppy_init(void)
>  	if (fdc_state[0].address == -1) {
>  		cancel_delayed_work(&fd_timeout);
>  		err = -ENODEV;
> -		goto out_unreg_region;
> +		goto out_unreg_driver;
>  	}
>  #if N_FDC > 1
>  	fdc_state[1].address = FDC2;
> @@ -4682,7 +4715,7 @@ static int __init do_floppy_init(void)
>  	if (err) {
>  		cancel_delayed_work(&fd_timeout);
>  		err = -EBUSY;
> -		goto out_unreg_region;
> +		goto out_unreg_driver;
>  	}
>  
>  	/* initialise drive state */
> @@ -4759,10 +4792,8 @@ static int __init do_floppy_init(void)
>  		if (err)
>  			goto out_remove_drives;
>  
> -		/* to be cleaned up... */
> -		disks[drive]->private_data = (void *)(long)drive;
> -		disks[drive]->flags |= GENHD_FL_REMOVABLE;
> -		device_add_disk(&floppy_device[drive].dev, disks[drive], NULL);
> +		device_add_disk(&floppy_device[drive].dev, disks[drive][0],
> +				NULL);
>  	}
>  
>  	return 0;
> @@ -4770,30 +4801,27 @@ static int __init do_floppy_init(void)
>  out_remove_drives:
>  	while (drive--) {
>  		if (floppy_available(drive)) {
> -			del_gendisk(disks[drive]);
> +			del_gendisk(disks[drive][0]);
>  			platform_device_unregister(&floppy_device[drive]);
>  		}
>  	}
>  out_release_dma:
>  	if (atomic_read(&usage_count))
>  		floppy_release_irq_and_dma();
> -out_unreg_region:
> -	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
> +out_unreg_driver:
>  	platform_driver_unregister(&floppy_driver);
>  out_unreg_blkdev:
>  	unregister_blkdev(FLOPPY_MAJOR, "fd");
>  out_put_disk:
>  	destroy_workqueue(floppy_wq);
>  	for (drive = 0; drive < N_DRIVE; drive++) {
> -		if (!disks[drive])
> +		if (!disks[drive][0])
>  			break;
> -		if (disks[drive]->queue) {
> -			del_timer_sync(&motor_off_timer[drive]);
> -			blk_cleanup_queue(disks[drive]->queue);
> -			disks[drive]->queue = NULL;
> -			blk_mq_free_tag_set(&tag_sets[drive]);
> -		}
> -		put_disk(disks[drive]);
> +		del_timer_sync(&motor_off_timer[drive]);
> +		blk_cleanup_queue(disks[drive][0]->queue);
> +		disks[drive][0]->queue = NULL;
> +		blk_mq_free_tag_set(&tag_sets[drive]);
> +		put_disk(disks[drive][0]);
>  	}
>  	return err;
>  }
> @@ -5004,9 +5032,8 @@ module_init(floppy_module_init);
>  
>  static void __exit floppy_module_exit(void)
>  {
> -	int drive;
> +	int drive, i;
>  
> -	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
>  	unregister_blkdev(FLOPPY_MAJOR, "fd");
>  	platform_driver_unregister(&floppy_driver);
>  
> @@ -5016,10 +5043,16 @@ static void __exit floppy_module_exit(void)
>  		del_timer_sync(&motor_off_timer[drive]);
>  
>  		if (floppy_available(drive)) {
> -			del_gendisk(disks[drive]);
> +			for (i = 0; i < ARRAY_SIZE(floppy_type); i++) {
> +				if (disks[drive][i])
> +					del_gendisk(disks[drive][i]);
> +			}>  			platform_device_unregister(&floppy_device[drive]);
>  		}
> -		blk_cleanup_queue(disks[drive]->queue);
> +		for (i = 0; i < ARRAY_SIZE(floppy_type); i++) {
> +			if (disks[drive][i])
> +				blk_cleanup_queue(disks[drive][i]->queue);
> +		}
>  		blk_mq_free_tag_set(&tag_sets[drive]);
>  
>  		/*
> @@ -5027,10 +5060,17 @@ static void __exit floppy_module_exit(void)
>  		 * queue reference in put_disk().
>  		 */
>  		if (!(allowed_drive_mask & (1 << drive)) ||
> -		    fdc_state[FDC(drive)].version == FDC_NONE)
> -			disks[drive]->queue = NULL;
> +		    fdc_state[FDC(drive)].version == FDC_NONE) {
> +			for (i = 0; i < ARRAY_SIZE(floppy_type); i++) {
> +				if (disks[drive][i])
> +					disks[drive][i]->queue = NULL;
> +			}
> +		}
>  
> -		put_disk(disks[drive]);
> +		for (i = 0; i < ARRAY_SIZE(floppy_type); i++) {
> +			if (disks[drive][i])

We can omit NULL check for put_disk().

> +				put_disk(disks[drive][i]);
> +		}


Regards,
Denis
