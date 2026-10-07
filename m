Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6663CFF77
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 08:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362364; cv=none; b=uwSNcmE9caWMi6fYP7XxFjgXlWouMReXQkb2leVaoc3HPKxBGFuvAFbEn3UOG58s3czj9DbUI2ulvlKpK+gmoAJy4T5zKwipu9Ye1CX5O/kT9Ji7HgHMs4+0Ym11Ndkfxe+yHf+AbbAdk7yFs7XTtDSlHPOLPPO5DCRYyqHbeGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362364; c=relaxed/simple;
	bh=W1DRe8r37nrFFyEjRf+A91zfrZKaN64E9JKLsIZQSXI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=s+FnWf7A/YXy6hrdGVnZL8NVRApltFkSOK0tCsmGIuOHA+NlFSBjBbu9/6ykumbZoNkeyxg2fKntG71pesVLGgd9G5aKzqmuRZC7vEA4PdkO+VH0hmWDyga8jx7hQX4J6cRKb8Kr8oJXaUgUl0wAVkHYQkikgwQoypvclHit/xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k69G+Lle; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k69G+Lle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC171F00903;
	Wed,  7 Oct 2026 08:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791362360;
	bh=xYVx0xZEC7Lijl/SntAFShmNwYjlgg6q0bm5wuz9YBE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k69G+Lley+4WSyNS9RvnptGpZupJYM0MUzFVGbrZqUb2Pe+tXTs131WyBas62WFth
	 wH2a68we/Nd5eVegxlbxXQEwjHy1zSS06D7C3uX6BuaM76wJGjc3DcGqi/f+F/vy8f
	 vkqw6aHmvlmhQsI32g/TJIny73+CPxPLxDrv+z3YUr6n5ejC9nktad5IxYnwO77TqV
	 msXdh9Uu3jzAVvCJirLqggBulUKEwhFaKSGi9TV2aNvNWVEvdr+Qag56kRB+uc9S5E
	 h8yyUwNI4APP14zMailkBBayDauDFMVUljMurKD1ruzeb86ur6+vevbylaXqVq7DNo
	 YwlZ1ZgstTBlg==
Message-ID: <sashiko-outbox-162752@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/7] block: add storage element management ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007082344.1049179-4-dlemoal@kernel.org>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 08:39:20 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] blk: missing partition check in device-wide storage element io=
ctls
- [High] blk: NULL pointer dereference if se_ops callbacks are not implemen=
ted
- [High] blk: TOCTOU race in blkdev_report_storage_elements_ioctl causes ou=
t-of-bounds read
- [High] blk: stale page cache due to premature filemap_invalidate_unlock
- [High] block: concurrent direct I/O bypasses inode_lock during storage el=
ement management
- [Medium] blk: kernel zone state desync on fatal signal interruption
--

commit a79f3f7a086e95bf1e025298308a290c19115ef1
Author: Damien Le Moal <dlemoal@kernel.org>

block: add storage element management ioctls

This commit introduces the BLKGETNRSTORELEMS, BLKREPORTSTORELEMS,
BLKREMOVESTORELEM, and BLKRESTORESTORELEMS ioctls. These allow user space
to interact with the block layer's storage element management operations
for zoned block devices.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 6a4c6a3f2060b..de22f876b9928 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -2813,6 +2814,73 @@ int bdev_report_storage_elements(struct block_devi=
ce *bdev,

[ ... ]

> +static int blkdev_report_storage_elements_ioctl(struct block_device *bde=
v,
> +						void __user *argp)
> +{
> +	struct blk_storage_elements_report rep;
> +	struct blk_storage_element *elements;
> +	unsigned int nr_elements =3D 0;
> +	unsigned long retc;
> +	int ret;
> +
> +	if (!argp)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&rep, argp,
> +			   sizeof(struct blk_storage_elements_report)))
> +		return -EFAULT;
> +
> +	ret =3D bdev_report_storage_elements(bdev, NULL, &nr_elements);
> +	if (ret)
> +		return ret;
> +
> +	nr_elements =3D min(rep.nr_elements, nr_elements);
> +	if (!nr_elements)
> +		return -EINVAL;
> +
> +	elements =3D kzalloc_objs(struct blk_storage_element, nr_elements);
> +	if (!elements)
> +		return -ENOMEM;
> +
> +	ret =3D bdev_report_storage_elements(bdev, elements, &nr_elements);
> +	if (ret)
> +		goto free_elements;
> +
> +	retc =3D copy_to_user(argp + sizeof(struct blk_storage_elements_report),
> +			    elements,
> +			    sizeof(struct blk_storage_element) * nr_elements);

[Severity: High]
Does this code have a TOCTOU race that could cause an out-of-bounds read?

In the second call to bdev_report_storage_elements(), the driver might
update nr_elements to a larger value if the hardware state has changed
and reports more elements.

If nr_elements is increased, the subsequent copy_to_user() will compute
a copy size larger than the allocated elements buffer, potentially
leaking kernel memory to userspace.

> +	if (retc) {
> +		ret =3D -EFAULT;
> +		goto free_elements;
> +	}

[ ... ]

> +static int blkdev_remove_storage_element_ioctl(struct block_device *bdev,
> +					blk_mode_t mode, void __user *argp)
> +{
> +	unsigned int element_id;
> +	int ret;
> +
> +	if (!(mode & BLK_OPEN_WRITE))
> +		return -EBADF;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
> +
> +	if (get_user(element_id, (unsigned int __user *)argp))
> +		return -EFAULT;
> +
> +	inode_lock(bdev->bd_mapping->host);

[Severity: High]
Does this incorrectly rely on inode_lock to serialize device access?

The request queue is explicitly unfrozen in bdev_remove_storage_element()
via blk_mq_unfreeze_queue() to allow polling. Concurrently, a thread could
issue an O_DIRECT write to the block device. In blkdev_write_iter(), the
IOCB_DIRECT path bypasses inode_lock and submits the BIO directly to the
unfrozen queue.

This allows hardware reconfiguration commands to execute concurrently with
regular I/O (reads, writes, zone resets), violating device requirements
during depopulation.

> +
> +	/*
> +	 * Flush the device volatile write cache and invalidate all cached data
> +	 * so that reads do not return old data for zones that went offline.
> +	 * Since a user can only write to zoned devices using direct IOs, we
> +	 * should never have any dirty page invalidated and so no data loss as
> +	 * long as the device cache flush succeeds, that is, as long as the
> +	 * flush does not use degraded storage elements.
> +	 */
> +	filemap_invalidate_lock(bdev->bd_mapping);
> +	ret =3D blkdev_issue_flush(bdev->bd_disk->part0);
> +	if (!ret)
> +		ret =3D truncate_bdev_range(bdev, mode, 0,
> +			(get_capacity(bdev->bd_disk) << SECTOR_SHIFT) - 1);
> +	filemap_invalidate_unlock(bdev->bd_mapping);
> +
> +	if (!ret)
> +		ret =3D bdev_remove_storage_element(bdev, element_id);

[Severity: High]
Can dropping the invalidation lock before the element removal cause the
page cache to become stale?

The invalidation lock is dropped before the actual long-running device
operation (bdev_remove_storage_element) executes.

Because the lock is dropped before the physical device operation completes,
a concurrent buffered read or memory-mapped page fault can fetch the
soon-to-be-removed data from the hardware and cache it. Once the hardware
operation finishes, the page cache will be left containing stale data.

[Severity: Medium]
What happens if the element removal is interrupted by a fatal signal?

The bdev_remove_storage_element() function polls for completion via
disk_wait_for_se_mgmt_completion(). If the polling loop is interrupted by a
fatal signal, it returns -EINTR and bypasses the call to
blk_revalidate_disk_zones(disk).

The hardware operation may still complete asynchronously, leaving the kerne=
l's
internal zone metadata permanently out of sync with the physical device sta=
te.

> +
> +	inode_unlock(bdev->bd_mapping->host);
> +
> +	return ret;
> +}

[ ... ]

> +static int blkdev_restore_storage_elements_ioctl(struct block_device *bd=
ev,
> +						 blk_mode_t mode)
> +{
> +	int ret;
> +
> +	if (!(mode & BLK_OPEN_WRITE))
> +		return -EBADF;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
> +
> +	inode_lock(bdev->bd_mapping->host);
> +
> +	/*
> +	 * Storage element restoration is a destructive operation that will
> +	 * reset all zones. So fflush the device volatile write cache and
> +	 * invalidate all cached data that we may have.
> +	 */
> +	filemap_invalidate_lock(bdev->bd_mapping);
> +	ret =3D blkdev_issue_flush(bdev->bd_disk->part0);
> +	if (!ret)
> +		ret =3D truncate_bdev_range(bdev, mode, 0,
> +			(get_capacity(bdev->bd_disk) << SECTOR_SHIFT) - 1);
> +	filemap_invalidate_unlock(bdev->bd_mapping);
> +
> +	if (!ret)
> +		ret =3D bdev_restore_storage_elements(bdev);

[Severity: High]
Similarly here, can dropping the invalidation lock before the element
restoration cause the page cache to become stale?

The invalidation lock is dropped before the physical device operation
(bdev_restore_storage_elements) executes, opening a race window for a
concurrent read to cache the soon-to-be-reset data.

> +
> +	inode_unlock(bdev->bd_mapping->host);
> +
> +	return ret;
> +}
> +
> +int blkdev_zone_storage_elements_ioctl(struct block_device *bdev,
> +				       blk_mode_t mode, unsigned int cmd,
> +				       void __user *argp)
> +{
> +	if (!bdev_is_zoned(bdev) || !bdev->bd_disk->fops->se_ops)
> +		return -ENOTTY;

[Severity: Critical]
Is a partition check missing for these device-wide operations?

BLKREMOVESTORELEM and BLKRESTORESTORELEMS execute whole-disk hardware
operations, but there is no bdev_is_partition(bdev) check in the ioctl
routing.

If executed on a partition:
- truncate_bdev_range() only truncates the page cache of that specific
  partition, leaving sibling partitions and the whole disk mapping with
  stale data.
- inode_lock() is taken only on the partition, meaning concurrent ioctls on
  different partitions can bypass serialization.

[Severity: High]
Can this result in a NULL pointer dereference if a driver omits some
callbacks in se_ops?

The functions bdev_report_storage_elements(), bdev_remove_storage_element(),
and bdev_restore_storage_elements() all check that disk->fops->se_ops is
non-NULL. However, they do not verify that the specific function pointers
(report_elements, remove_element, restore_elements) are actually implemented
before dereferencing them.

If a driver provides the se_ops structure but omits an optional callback,
invoking the corresponding ioctl will trigger a NULL pointer dereference.

> +
> +	switch (cmd) {
> +	case BLKGETNRSTORELEMS:
> +		return blkdev_get_nr_storage_elements_ioctl(bdev, argp);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007082344.1049=
179-1-dlemoal@kernel.org?part=3D3
