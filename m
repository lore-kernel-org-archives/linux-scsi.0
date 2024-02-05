Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E87828F5;
	Mon,  5 Feb 2024 00:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707091817; cv=none; b=Zl5Lki5Ho/lhql10xE+ouJWcT95JS8iPU8W+U7TJf3AacnMfOaOWyP+pLj75a1AKF+VSazA0ffuO1Dn2Mm7uhAgxKQy3xGkQWvfVRmkHoLqdjTsBkLvpB54QaCKFGEGRV340agjF5dlvXUbh6c+Y7XQUYkjD+OfmWE0f002mUrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707091817; c=relaxed/simple;
	bh=3pdylHyP+bKJ75pMNZmMy9J6ynEAHnmL2EleudoNtjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PsnRYXHksWu5NeM4wRNobWzy59fmBOvfnCtUlKxVsNcJiAU5wEoI7Zm0ud3TclMcNJv4k67EPG0z9XG+qNF5ZpLmsvJIbL9ltOhV9aDmosksz5f3CsjFBz4J2wg0a3CD3ZOSwesdA4qyXqBR2muY2IZgJV8Snh+7D4Oy9U0Wjsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HyOLabSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HyOLabSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA67C43390;
	Mon,  5 Feb 2024 00:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707091816;
	bh=3pdylHyP+bKJ75pMNZmMy9J6ynEAHnmL2EleudoNtjs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HyOLabSqoHsBT4xj41SL1+bUnxtnhG2xRHcv5gQTKXpgP+Dos361XrBfWJPfDnu3R
	 QmGQI0Rw+c0dd7k8amQuD7VeGJg/lh9IvFKk7et07o5jgLzMBk9e0O7mLmdHgS9Iqb
	 ofciCrDquvhVPhx28hCiVgGSRW85MrPaxywR1jr0VK0LtCF0xv2SkeC3mmOss1YOKk
	 p1KS7lWD0nsSk5bN6SAk715ArPSNobYTlR5UFzBU0h+qh4nXjEMR/IWLZtE/MlqDlZ
	 2wZwDBffXS2l7IXt5JnZeHg5M02gV0JvYjj/WHUQ8VB+GTe7FPsaJFz8PLL54X4uyt
	 EcGI+VmnR3kgQ==
Message-ID: <ff4018f0-7a51-4cec-82de-f105483dfde2@kernel.org>
Date: Mon, 5 Feb 2024 09:10:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/26] block: Implement zone append emulation
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-9-dlemoal@kernel.org>
 <9026cc14-b107-41de-994f-6b46858b6601@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <9026cc14-b107-41de-994f-6b46858b6601@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/24 21:24, Hannes Reinecke wrote:
> On 2/2/24 15:30, Damien Le Moal wrote:
>> +/*
>> + * Set a zone write plug write pointer offset to either 0 (zone reset case)
>> + * or to the zone size (zone finish case). This aborts all plugged BIOs, which
>> + * is fine to do as doing a zone reset or zone finish while writes are in-flight
>> + * is a mistake from the user which will most likely cause all plugged BIOs to
>> + * fail anyway.
>> + */
>> +static void blk_zone_wplug_set_wp_offset(struct gendisk *disk,
>> +					 struct blk_zone_wplug *zwplug,
>> +					 unsigned int wp_offset)
>> +{
>> +	/*
>> +	 * Updating the write pointer offset puts back the zone
>> +	 * in a good state. So clear the error flag and decrement the
>> +	 * error count if we were in error state.
>> +	 */
>> +	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
>> +		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
>> +		atomic_dec(&disk->zone_nr_wplugs_with_error);
>> +	}
>> +
>> +	/* Update the zone write pointer and abort all plugged BIOs. */
>> +	zwplug->wp_offset = wp_offset;
>> +	blk_zone_wplug_abort(disk, zwplug);
>> +}

[...]

>> +static void blk_zone_wplug_handle_error(struct gendisk *disk,
>> +					struct blk_zone_wplug *zwplug)
>> +{
>> +	unsigned int zno = zwplug - disk->zone_wplugs;
>> +	sector_t zone_start_sector = bdev_zone_sectors(disk->part0) * zno;
>> +	unsigned int noio_flag;
>> +	struct blk_zone zone;
>> +	unsigned long flags;
>> +	int ret;
>> +
>> +	/* Check if we have an error and clear it if we do. */
>> +	blk_zone_wplug_lock(zwplug, flags);
>> +	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR))
>> +		goto unlock;
>> +	zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
>> +	atomic_dec(&disk->zone_nr_wplugs_with_error);
>> +	blk_zone_wplug_unlock(zwplug, flags);
>> +
> 
> Don't you need to quiesce the drive here?
> After all, I/O (or a reset zone) might be executed after the call to 
> report zones, but before we lock the zone, no?

Indeed, this is racy with reset zone. But there is no race with IOs because when
the error flag is set, we always plug incoming BIOs.
But the race with reset (and finish) is actually easy to fix. All I need to do
is not clear the error flag above and check for it after the report zones and
locking the zone plug. Given that blk_zone_wplug_set_wp_offset() clears the
error flag, we end up restoring a known good wp either from the reset or from
the report zones.

>>   struct blk_revalidate_zone_args {
>> @@ -890,6 +1292,8 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
>>   			if (!args->seq_zones_wlock)
>>   				return -ENOMEM;
>>   		}
>> +		args->zone_wplugs[idx].capacity = zone->capacity;
>> +		args->zone_wplugs[idx].wp_offset = blk_zone_wp_offset(zone);
>>   		break;
>>   	case BLK_ZONE_TYPE_SEQWRITE_PREF:
>>   	default:
>> @@ -964,6 +1368,13 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>>   	if (!args.zone_wplugs)
>>   		goto out_restore_noio;
>>   
>> +	if (!disk->zone_wplugs) {
>> +		mutex_init(&disk->zone_wplugs_mutex);
>> +		atomic_set(&disk->zone_nr_wplugs_with_error, 0);
>> +		INIT_DELAYED_WORK(&disk->zone_wplugs_work,
>> +				  disk_zone_wplugs_work);
>> +	}
>> +
> 
> Same question here about device quiesce ...

Yes, I need to check this, together with revisiting the queue usage counter
handling.

>>   	ret = disk->fops->report_zones(disk, 0, UINT_MAX,
>>   				       blk_revalidate_zone_cb, &args);
>>   	if (!ret) {
>> @@ -989,12 +1400,14 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>>   	 */
>>   	blk_mq_freeze_queue(q);
> 
> And this, I guess, comes to late.
> We've already read the zone list, so any write I/O submitted after the 
> report zone but befor here will cause things to be iffy.

Yes, but the driver is supposed to guarantee that this function is being called
while there are no writes in flight. DM is OK with that. I think scsi is too,
but need to check again. Not sure about NVMe and null_blk. But Ming had a good
point about the usage ref coming from the device being open. So a quiesce may be
enough here. Need to revisit this.

-- 
Damien Le Moal
Western Digital Research

