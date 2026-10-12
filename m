Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034BA3B27DB;
	Mon, 12 Oct 2026 13:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812992; cv=none; b=mYD2H9KOFbHa3xViTUYGGXLXli0h5hhlRsyqRRCBe1yZhstOcCyJuny8dh4nSWAnaoVVuqMvBBbALaBsJJQy0Wm+m24ZGGJBvjQWJ71kWv5iShICG4sEbl3JoRprRykWl0D/qG5nZnA+mKXjX2xeDhfTIUGOsM591uzJrX8WOpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812992; c=relaxed/simple;
	bh=zbmY81G7qjIp1Hij4V9u/gQWsmvfoGZlkzKvvc6Lcec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WlyN2RBv2YiMoV+wxEYvRN7az6kzoRFJ+uieCklQPstEQz/W5FD3irKa8OvFmEgcfdgnMSfBOfCw/JiG12D4cojRdtGKW/vIaEY/c0PD5V+pe4g86DUIsD1Sryw4oxONST7T3WgOEPuX2nEY0BsMVBSnRiyfZ3dzL38MWhsDpt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhfPBtsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhfPBtsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213DD1F0089B;
	Mon, 12 Oct 2026 13:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791812990;
	bh=RZWTsyA2oBn/SGBI3f+VKt/e1OXYXKmRQQoU2yOitUk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mhfPBtsxTN5zL0iqWfBZjFjLNuu5+znSxjR2+JCsYFN6grEGX4kzLSORf3sxXOf0G
	 CsD1Q/PxLkAP9yXlluRFTdezAIXO7PazRvZ/3+al5Snb/CPkk2VwMdAdRNOkHc9/yQ
	 2uId/ZjmZCFqCqwKAo3ls62kebSNIWLWDiuFYzs7eqy398Fs/U57MtMxpWUOLVCnjA
	 FkvkHhf4Dpdhb8z7wu/xz0uaGAmewrnlQXRbVvnVyxjoRtYxzXTAwzf+jhRWTzxZoC
	 ALNnBYRcUWRUKmpGX6xgJfwXZiTNvr7K/NBkbW0useWD/O+M3D3H4UcFRsaeUHoZPB
	 fLuCw59qXC4IQ==
Message-ID: <61c9bd96-2d9f-4fc3-ac09-6c5b51f5bd97@kernel.org>
Date: Mon, 12 Oct 2026 15:49:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/9] block: add storage element management ioctls
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-5-dlemoal@kernel.org>
 <sashiko-outbox-168194@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <sashiko-outbox-168194@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/12 15:40, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] block: concurrent I/O race in storage element removal/restoration
> - [High] block: silent data loss in conventional zones on storage element ioctls
> - [High] block: cross-partition data destruction via storage element ioctls
> - [Medium] block: zone state permanently desynchronized if SE ioctl is interrupted
> --
> 
> commit 8f33e7baabedb5d2ad1cccf418448851e57fed71
> Author: Damien Le Moal <dlemoal@kernel.org>
> 
> block: add storage element management ioctls
> 
> This commit introduces new ioctl commands for storage element management on
> zoned block devices. The new commands allow userspace to query, report,
> remove, and restore storage elements.
> 
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index 46822c7a05ecc..8736e80b4080d 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
> 
> [ ... ]
> 
>> @@ -2917,6 +2968,52 @@ int bdev_remove_storage_element(struct block_device *bdev,
>>  }
>>  EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
>>  
>> +static int blkdev_flush_and_truncate(struct block_device *bdev,
>> +				     blk_mode_t mode)
>> +{
>> +	int ret;
>> +
>> +	inode_lock(bdev->bd_mapping->host);
>> +	filemap_invalidate_lock(bdev->bd_mapping);
>> +	ret = blkdev_issue_flush(bdev->bd_disk->part0);
>> +	if (!ret)
>> +		ret = truncate_bdev_range(bdev, mode, 0,
>> +					  bdev_nr_bytes(bdev) - 1);
> 
> [Severity: High]
> Will this discard unwritten buffered data in conventional zones?
> 
> While users might typically use direct I/O for zoned devices, zoned devices
> can contain conventional zones which fully support and commonly use buffered
> I/O. truncate_bdev_range() delegates to truncate_inode_pages_range() which
> forcefully drops all pages in the mapping. Could dirty pages be silently
> destroyed here? Should this code call filemap_write_and_wait() before
> truncating the cache?

Yes. It is the responsibility of the user to sync its dirty data before
initiating a depop.

> 
> [Severity: High]
> Does this only invalidate the page cache for the opened partition?
> 
> When a user invokes these ioctls on a partition (e.g., /dev/sda1),
> bdev->bd_mapping is the page cache for that partition. Since the underlying
> hardware operation modifies the entire physical device, the page caches for
> the whole disk and other partitions are not invalidated, which could lead to
> stale reads and silent data corruption across the system.
> 
>> +	filemap_invalidate_unlock(bdev->bd_mapping);
>> +	inode_unlock(bdev->bd_mapping->host);
>> +
>> +	return ret;
>> +}
> 
> [Severity: High]
> Are we safely dropping the VFS locks before the storage element removal
> starts?
> 
> The locks preventing concurrent I/O and page cache repopulation are released
> here. When the ioctl handler later delegates to
> bdev_remove_storage_element(), there is no barrier preventing concurrent
> processes from opening the device and issuing buffered or direct I/Os during
> a destructive hardware operation.

Yes. It is the reponsibility of the user to not issue IOs while depop in on-going.

> 
>> +
>> +static int blkdev_remove_storage_element_ioctl(struct block_device *bdev,
>> +					blk_mode_t mode, void __user *argp)
>> +{
>> +	unsigned int element_id;
>> +	int ret;
>> +
>> +	if (!(mode & BLK_OPEN_WRITE))
>> +		return -EBADF;
>> +	if (bdev_read_only(bdev))
>> +		return -EPERM;
> 
> [Severity: High]
> Is a user with write access to a single partition able to destroy data on
> other partitions?

Partitions on zoned block devices are *not* supported. There are no partitions,
only the entire bdev.

> The storage element ioctls issue a disk-wide destructive hardware command
> that can alter the physical geometry of the drive. Without checking if the
> block device is a partition (e.g., via bdev_is_partition()) or requiring
> capable(CAP_SYS_ADMIN), these operations might destroy zones belonging to
> other partitions.
> 
> [ ... ]
> 
>> +	/*
>> +	 * Flush the device volatile write cache and invalidate all cached data
>> +	 * so that reads do not return old data for zones that went offline.
>> +	 * Since a user can only write to zoned devices using direct IOs, we
>> +	 * should never have any dirty page invalidated and so no data loss as
>> +	 * long as the device cache flush succeeds, that is, as long as the
>> +	 * flush does not use degraded storage elements.
>> +	 */
>> +	ret = blkdev_flush_and_truncate(bdev, mode);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return bdev_remove_storage_element(bdev, element_id);
>> +}
> 
> [Severity: High]
> Is it safe to rely on the caller to prevent new I/Os here?
> 
> bdev_remove_storage_element() freezes the queue but immediately unfreezes
> it before executing the long-running remove_element callback. Since the VFS
> locks were already dropped in blkdev_flush_and_truncate(), the device is
> left unprotected from concurrent I/Os during a destructive hardware
> operation.

Yes it is safe. If the user still issues IOs while depop or restore is in
progress, IOs may/will fail and the zone write plugging code will handle that,
so will the final zone revalidation.

> 
> [Severity: Medium]
> Could the zone state become permanently desynchronized if this ioctl is
> interrupted?
> 
> When this ioctl is interrupted by a fatal signal, the underlying loop in
> disk_wait_for_se_mgmt_completion() returns -EINTR and
> bdev_remove_storage_element() immediately revalidates the zones while the
> hardware operation is still in progress.
> 
> Because the polling loop was the only tracking mechanism, the kernel's
> zones_state array is never updated to reflect the final state of the
> depopulated zones once the hardware finishes. This leaves the kernel
> permanently desynchronized, potentially leading to unexpected I/O errors.

Yes it will potentially desynchronize the state, but the user can initiate a
revalidation to re-synchronize everything. If the poll loop was interrupted, a
problem happened anyway.

-- 
Damien Le Moal
Western Digital Research
