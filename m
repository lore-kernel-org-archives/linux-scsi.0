Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51094477984
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 12:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523574; cv=none; b=lMqKoqqLWwEn2Sg6K+TB803rLVcwce9HO2Xrq9kxDjq+vJGIqZ/sLHWiEN7gsJcsXnV5fSDc3LID374SdH2ELDtUfP4Ua3zBYeEBvLUlhDArSAh06Cv2Bx8i+GT7CSn5n4FSsLN+C8L/vBFpdA4PoFxkMe4gh0QPDTGj0vOU9W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523574; c=relaxed/simple;
	bh=hIO1NsaBhYS/1pRYN673ZQYYz7ahk2y92ZqW93xWR74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NlzuwTGzJgg02eR/3igtsUDbZS4g2OdQUYVuucV3WGd/RZ7TgEL/raC/iVjgeY7CX/Nw6GGW4V1F00ycH4/uppX1zX9KBktSxeQGpqyOfLGHxddPEaU9qdsg4zD3lVHJCVXavCdVFNt/gQ+PgxxmgcisoYtfr14lrPG5+dk7YB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XJ3Wg+pZ; arc=none smtp.client-ip=91.218.175.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XJ3Wg+pZ"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hIO1NsaBhYS/1pRYN673ZQYYz7ahk2y92ZqW93xWR74=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788523568; v=1; x=1789128368;
 b=XJ3Wg+pZJUbHAvRrLPYWiSDxQerIRYj/lOdSZwk/BtWuG2JqJkI3h63nZFd1l+oQLMO6dvXQ
 6tumlq/HrCcHKXxZ0z5QQxZqlMDRcb01BEuaytPW2FnNZaN7E3wCQnSOdbmc3n6aoc5zBDf2V/S
 u8MIi2QmraBK3Myzu6YtN3BM=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 690ac3f9b1370a38;
	Fri, 04 Sep 2026 12:05:58 +0000
X-Mizu-Trace-ID: 690ac3f9b1370a38
X-Migadu-Flow: FLOW_OUT
Message-ID: <b49af456-2c7c-4ab6-a142-c17015362a5b@linux.dev>
Date: Fri, 4 Sep 2026 13:05:58 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 24/27] scsi: sd: support multipath disk
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-25-john.g.garry@oracle.com>
 <20260901111904.288951F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901111904.288951F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:19, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [High] Unprotected overwrite of mpath_head->parent before validation causes Use-After-Free during concurrent I/O when probe fails.
> - [High] Queue limits are explicitly overwritten before stacking, breaking multipath limits aggregation.
> - [Medium] Circular reference between sd_mpath_disk and its child multipath gendisk prevents both structures from ever being freed.
> - [Medium] Missing put_device() in sd_probe() error path leaks the scsi_disk structure and device references.
> - [Medium] TOCTOU race in disk removal paths allows a concurrent probe to fail with a duplicate sysfs name error.
> --
> 
> commit 7a8d9795d762973e091f3a0357c1112c3afc4c60
> Author: John Garry <john.garry@linux.dev>
> Subject: scsi: sd: support multipath disk
> 
> Add support to attach a multipath disk, allocating gendisks per path but
> marking them as hidden, and maintaining a global list of multipath disks
> for scsi_device matching.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 60e071d23ddd0..28304a497d8c6 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> [ ... ]
>> @@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
>>   static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
>>   static struct lock_class_key sd_bio_compl_lkclass;
>>   #ifdef CONFIG_SCSI_MULTIPATH
>> +static LIST_HEAD(sd_mpath_disks_list);
>> +static DEFINE_MUTEX(sd_mpath_disks_lock);
>> +
>>   struct sd_mpath_disk {
>> +	struct device			dev;
>> +	int				disk_index;
>> +	int				disk_count;
>> +	struct list_head		entry;
>>   	struct scsi_mpath_head		*scsi_mpath_head;
>>   };
>>   
>>   static void sd_mpath_disk_release(struct device *dev)
>>   {
>> +	struct sd_mpath_disk *sd_mpath_disk =
>> +		container_of(dev, struct sd_mpath_disk, dev);
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +		sd_mpath_disk->scsi_mpath_head;
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +	mpath_put_disk(mpath_head);
> 
> [Severity: Medium]
> In sd_mpath_probe(), the child multipath gendisk takes a reference on this
> device via mpath_head->parent = &sd_mpath_disk->dev. Since the child holds
> a strong reference to the parent, the parent's refcount cannot reach zero
> while the child exists.
> 
> Does dropping the child reference here in the parent's release function create
> an unbreakable circular dependency that leaks both structures during removal?

No, I think that mpath_remove_disk() -> del_gendisk() drops that dependency

> 
>> +	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
>> +	scsi_mpath_put_head(scsi_mpath_head);
>> +
>> +	kfree(sd_mpath_disk);
>>   }
> [ ... ]
>> @@ -4019,6 +4038,90 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
>>   	return 0;
>>   }
>>   
>> +#ifdef CONFIG_SCSI_MULTIPATH
>> +static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
>> +{
>> +	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
>> +	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +	struct gendisk *disk = mpath_head->disk;
>> +	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
>> +	struct queue_limits lim;
>> +	unsigned int memflags;
>> +	int ret;
>> +
>> +	lim = queue_limits_start_update(disk->queue);
>> +	memflags = blk_mq_freeze_queue(disk->queue);
>> +
>> +	lim.logical_block_size = sdkp_lim->logical_block_size;
>> +	lim.physical_block_size = sdkp_lim->physical_block_size;
>> +	lim.io_min = sdkp_lim->io_min;
>> +	lim.io_opt = sdkp_lim->io_opt;
>> +
>> +	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
>> +					disk->disk_name);
> 
> [Severity: High]
> Does overwriting the multipath limits with sdkp_lim before calling
> queue_limits_stack_bdev() erase the previously stacked limits?
> 
> If an older path required stricter limits (e.g. larger block size or
> alignment), would this downgrade the multipath limits to match only the newly
> probed path, potentially causing I/O errors on the older paths?

We work on the principle that things like logical block size should not 
change

> 
>> +
>> +	/* TODO: setup integrity and zoned limits */
> [ ... ]
>> +static int sd_mpath_probe(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
>> +	if (!sd_mpath_disk) {
>> +		error = -ENOMEM;
>> +		goto out_unlock;
>> +	}
>> +
>> +	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
>> +
>> +	blk_set_stacking_limits(&lim);
>> +	lim.dma_alignment = 3;
>> +	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
>> +		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
>> +
>> +	mpath_head->parent = &sd_mpath_disk->dev;
>> +	mpath_head->drv_module = THIS_MODULE;
>> +	mpath_head->disk_groups = sd_mpath_disk_attr_groups;
>> +	error = mpath_alloc_head_disk(mpath_head, &lim,
>> +				dev_to_node(dma_dev));
>> +	if (error)
>> +		goto out_free_disk;
> 
> [Severity: High]
> If mpath_alloc_head_disk() fails here, the error path jumps to out_free_disk
> and calls kfree(sd_mpath_disk). However, mpath_head->parent was
> unconditionally set to &sd_mpath_disk->dev just before the call.
> 
> If the multipath disk is still active from a prior failed removal, 

I don't understand what this means.

> will it
> dereference the freed parent pointer during subsequent I/O or workqueue
> processing?

See below.

> 
>> +	disk = mpath_head->disk;
> [ ... ]
>> +static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
>> +{
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +	struct sd_mpath_disk *sd_mpath_disk;
>> +	struct device *dev = &scsi_mpath_head->dev;
>> +
>> +	mutex_lock(&sd_mpath_disks_lock);
>> +	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
>> +	if (!sd_mpath_disk) {
>> +		dev_warn(dev, "could not find mpath disk\n");
>> +		mutex_unlock(&sd_mpath_disks_lock);
>> +		return;
>> +	}
>> +
>> +	if (sd_mpath_disk->disk_count) {
>> +		dev_dbg(dev, "non-zero multipath disk count in removal\n");
>> +		sd_mpath_put_disk(sd_mpath_disk);
>> +		mutex_unlock(&sd_mpath_disks_lock);
>> +		return;
>> +	}
>> +
>> +	list_del_init(&sd_mpath_disk->entry);
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +
>> +	device_del(&sd_mpath_disk->dev);
> 
> [Severity: Medium]
> Could a time-of-check to time-of-use race happen here during device removal?
> The disk is removed from sd_mpath_disks_list inside the lock, but device_del()
> is called after dropping the lock.
> 
> Would a concurrent sd_mpath_probe() acquire the lock, fail to find the disk,
> allocate a new one with the same index, and call device_add() before this
> device_del() completes, causing a sysfs naming collision and -EEXIST failure?

We only set mpath_head->disk = NULL in sd_mpath_disk_release() -> 
mpath_put_disk(), so earlier calls to mpath_alloc_head_disk() would fail 
in the mpath_head->disk check.

But we do still leave mpath_head->parent = &sd_mpath_disk->dev set (for 
sd_mpath_disk, which will be free'd), so this needs to be fixed.
> 
>> +	mpath_remove_disk(mpath_head);
>> +	sd_mpath_put_disk(sd_mpath_disk);
>> +}
> [ ... ]
>> @@ -4192,6 +4556,7 @@ static int sd_probe(struct scsi_device *sdp)
>>   
>>   	error = device_add_disk(dev, gd, NULL);
>>   	if (error) {
>> +		sd_mpath_fail_probe(sdkp);
>>   		device_unregister(&sdkp->disk_dev);
>>   		put_disk(gd);
>>   		if (sdp->sector_size > PAGE_SIZE)
>> @@ -4199,6 +4564,19 @@ static int sd_probe(struct scsi_device *sdp)
>>   		goto out;
>>   	}
>>   
>> +	if (sdp->scsi_mpath_dev) {
>> +		error = sd_mpath_add_disk(sdkp);
>> +		if (error) {
>> +			sd_mpath_fail_probe(sdkp);
>> +			device_del(&sdkp->disk_dev);
>> +			del_gendisk(sdkp->disk);
>> +
>> +			put_disk(sdkp->disk);
>> +			if (sdp->sector_size > PAGE_SIZE)
>> +				sd_large_pool_destroy();
>> +			goto out;
> 
> [Severity: Medium]
> Does this error path leak the scsi_disk structure and its device reference?
> 
> device_del() removes the device from the system, but since sdkp->disk_dev was
> initialized with device_initialize() (giving it a refcount of 1), shouldn't
> there be a matching put_device(&sdkp->disk_dev) to drop the base reference and
> eventually call scsi_disk_release()?

Current code is ok. The put_disk() releases the reference on 
&sdkp->disk_dev.

> 
>> +		}
>> +	}
>>   	if (sdkp->security) {
>>   		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
>>   		if (sdkp->opal_dev)
> 

