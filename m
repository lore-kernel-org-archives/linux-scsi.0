Received: from mta1.migadu.com (out-72.mta1.migadu.com [95.215.58.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336964A64C7
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784509; cv=none; b=gQ8jY6Mkz1kFDqC5cjT8GuO/FRHHoKvmpk0DAESN+p5JmTsHaJFGva41ZgRWpl5fObmu7E9PPXOiCaI7lMmc8VyLHDzS9De/B7TUz5daAAu9Jqmtk8/ZpYTTZtxvYb+XuoZQNQigc/RBESAGR2bA3YSWhw0/e7FVefI3gTO8Z2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784509; c=relaxed/simple;
	bh=mu4BcnOWhmf2pfWXNByRLhFYDYLzBAz7cyEC2jz/pdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G+UFw2pmLxLjY+ivE02v6c33X3ziXTTwx9Z8nF12Sp7LT+vpCH2Xc+QtD35Sdz7Gp7E0zSh1BrWHSCB5BP4XH+M9umh/EHMocN0kY7GX6hNFbhlrO9yW+vrHPuxI21QhxjmoI2vXKmyite2jrV+FE4glS4K5JZYSafSSBAEFKWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NFRdjBet; arc=none smtp.client-ip=95.215.58.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NFRdjBet"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mu4BcnOWhmf2pfWXNByRLhFYDYLzBAz7cyEC2jz/pdE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788784506; v=1; x=1789389306;
 b=NFRdjBetoKM67dnB78GxUobPaXq9gwAyA5lAkwkrtKo5MIBAbmRSfZAhc2nKAGnD8fWcLUtj
 WVhL0c9snvATHk1pYCevW5/ItZHVu3dYle9tKPohDP5GyClIfd0tV4EaL4ssDc3XxPPRLB9lmJb
 mN/6SsO2dCVXxG7l3YIJw1yg=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 33cf694317f22d84;
	Mon, 07 Sep 2026 12:34:56 +0000
X-Mizu-Trace-ID: 33cf694317f22d84
X-Migadu-Flow: FLOW_OUT
Message-ID: <a7be8330-1678-44e2-8c1b-eb48cb205eeb@linux.dev>
Date: Mon, 7 Sep 2026 13:34:51 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 24/27] scsi: sd: support multipath disk
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-25-john.g.garry@oracle.com>
 <20260907122525.940BF1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907122525.940BF1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 13:25, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [High] Pending delayed removal work is not cancelled when `sd_mpath_fail_probe()` tears down a multipath disk, leading to use-after-free of `mpath_head`.
> 
> Pre-existing issues:
> - [Critical] Preexisting double put of `sdkp->disk_dev` when `sd_large_pool_create()` or `device_add_disk()` fails.
> --
> 
> commit 9972be7d4ae335cb741d2858144500af92bf6dc3
> Author: John Garry <john.garry@linux.dev>
> 
> scsi: sd: support multipath disk
> 
> This commit adds support to attach a multipath disk by allocating a hidden
> gendisk per path. A global list of multipath disks is kept for matching
> SCSI devices, and the multipath gendisk mimics a standard SCSI disk.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 60e071d23ddd0..27230ecc2337e 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> [ ... ]
>> @@ -4048,13 +4151,260 @@ static const struct attribute_group sd_mpath_disk_attr_group = {
> [ ... ]
>> +static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
>> +{
>> +	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
>> +	struct scsi_mpath_device *scsi_mpath_dev;
>> +	struct mpath_device *mpath_device;
>> +	struct scsi_device *sdp = sdkp->device;
>> +	struct scsi_mpath_head *scsi_mpath_head;
>> +	struct mpath_head *mpath_head;
>> +	bool remove = false;
>> +
>> +	if (!sd_mpath_disk)
>> +		return;
>> +
>> +	scsi_mpath_dev = sdp->scsi_mpath_dev;
>> +	mpath_device = &scsi_mpath_dev->mpath_device;
>> +	scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
>> +	mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +	mutex_lock(&sd_mpath_disks_lock);
>> +	sd_mpath_disk->disk_count--;
>> +	if (!sd_mpath_disk->disk_count) {
>> +		list_del_init(&sd_mpath_disk->entry);
>> +		remove = true;
>> +	}
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +	mpath_device->disk = NULL;
>> +
>> +	if (remove) {
>> +		device_del(&sd_mpath_disk->dev);
>> +		mpath_remove_disk(mpath_head);
>> +	}
>> +	sd_mpath_put_disk(sd_mpath_disk);
> 
> [Severity: High]
> Can this sequence leave pending delayed removal work uncancelled when tearing
> down a multipath disk?
> 
> If a multipath disk has its last path removed, it can enter delayed removal
> where disk_count drops to 0 and remove_work is scheduled via
> mpath_can_remove_head().
> 
> If a path is then re-probed, disk_count becomes 1.

The re-probe should fail early as mpath_head->disk is still set

> If that probe subsequently
> fails and sd_mpath_fail_probe() is called, the disk_count drops back to 0,
> which triggers the device deletion and frees the head.
> 
> However, since this path bypasses mpath_can_remove_head(), could the pending
> remove_work scheduled earlier go uncancelled, potentially leading to a
> use-after-free of mpath_head when the delayed work timer expires?
> 
>> +}
> [ ... ]
>> @@ -4171,6 +4529,7 @@ static int sd_probe(struct scsi_device *sdp)
>>   	sd_revalidate_disk(gd);
>>   	if (sdp->sector_size > PAGE_SIZE) {
>>   		if (sd_large_pool_create()) {
>> +			sd_mpath_fail_probe(sdkp);
>>   			error = -ENOMEM;
>>   			device_unregister(&sdkp->disk_dev);
>>   			put_disk(gd);
> 
> [Severity: Critical]
> This is a pre-existing issue, but could this error path result in a
> double-free of sdkp->disk_dev?
> 
> When sd_large_pool_create() fails, device_unregister() is called on
> sdkp->disk_dev, which drops the refcount to 0 and frees sdkp.
> 
> Immediately following this, put_disk(gd) is called. Because gd->fops is
> already set to &sd_fops, dropping the gendisk refcount invokes
> scsi_disk_free_disk(), which reads the already freed sdkp and attempts a
> second put_device() on sdkp->disk_dev.

I'll check it, but I doubt that there is a problem

> 
>>   			goto out;
>>   		}
>>   	}
>>   
>> +	if (sdp->scsi_mpath_dev) {
>> +		error = sd_mpath_revalidate_head(sdkp);
>> +		if (error)
>> +			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
>> +	}
>> +
>>   	if (sdp->removable) {
>>   		gd->flags |= GENHD_FL_REMOVABLE;
>>   		gd->events |= DISK_EVENT_MEDIA_CHANGE;
>> @@ -4192,6 +4557,7 @@ static int sd_probe(struct scsi_device *sdp)
>>   
>>   	error = device_add_disk(dev, gd, NULL);
>>   	if (error) {
>> +		sd_mpath_fail_probe(sdkp);
>>   		device_unregister(&sdkp->disk_dev);
>>   		put_disk(gd);
> 
> [Severity: Critical]
> This is a pre-existing issue, but might this error path also suffer from the
> same double-free of sdkp->disk_dev?
> 
> Just like the memory allocation failure path above, if device_add_disk()
> fails, device_unregister() frees sdkp, and the subsequent put_disk(gd)
> accesses the freed sdkp and performs a second put_device() on
> sdkp->disk_dev.

As with v7, this is fine

> 
>>   		if (sdp->sector_size > PAGE_SIZE)
> 

