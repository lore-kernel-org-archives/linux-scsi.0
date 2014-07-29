From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [RFD] brd.ko Never supported partitions should we remove the
 dead code ?
Date: Tue, 29 Jul 2014 20:13:47 +0300
Message-ID: <53D7D64B.5080504@gmail.com>
References: <53D7CDDD.1000302@gmail.com> <20140729165603.GN6754@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55464 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaG2RNv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2014 13:13:51 -0400
Received: by mail-pd0-f171.google.com with SMTP id z10so12003386pdj.30
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 10:13:51 -0700 (PDT)
In-Reply-To: <20140729165603.GN6754@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>

On 07/29/2014 07:56 PM, Matthew Wilcox wrote:
> On Tue, Jul 29, 2014 at 07:37:49PM +0300, Boaz Harrosh wrote:
>> But before we are running to fix this bug. Could we please do better and just remove the support for partitions
>> all together.
>> 	Since it *never* worked anyway, so probably no one needs it! Surly no one used it
> 
> I fixed this in patch 4/22 of the v8 series.  The correct place to
> handle partitioning is in the block layer, not the individual drivers
> (nor the filesystems).
> 

Sir Mathew hi

> @@ -378,10 +378,12 @@ static int brd_direct_access(struct block_device *bdev, sector_t sector,
>  
>  	if (!brd)
>  		return -ENODEV;
> +	sector += get_start_sect(bdev);
>  	if (sector & (PAGE_SECTORS-1))
>  		return -EINVAL;
> +/* Check is wrong here we need to check against bdev->bd_part->nr_sects */
>  	if (sector + PAGE_SECTORS > get_capacity(bdev->bd_disk))
>  		return -ERANGE;
>  	page = brd_insert_page(brd, sector);
>  	if (!page)
>  		return -ENOSPC;

you mean you fixed the brd_direct_access() hunk by pointing all users to a wrapper
that does the proper offsetting, sure.

But that is not the main bug I was talking about, the main BUG is that partitions are
not supported at all because of the clubber of *part in brd_probe()

> @@ -558,7 +564,8 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
>  	kobj = brd ? get_disk(brd->brd_disk) : NULL;
>  	mutex_unlock(&brd_devices_mutex);
>  
> -	*part = 0;
> +//	Fix the partition BUG *part comes in correctly must not need to touch it
> +// 	*part = 0;
>  	return kobj;
>  }

And my point is that: No one uses partitions with brd, why should we not remove it
all together, why fix it and keep it?

Cheers
Boaz

