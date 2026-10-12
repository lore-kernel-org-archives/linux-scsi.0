Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152B637F30B
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812411; cv=none; b=KVu4Ofq7v8io4aGup60gOSY15hWH48uBjNplI8j/tWJwIClmjQZ3byrOcGblaC4yHp+jPo2mJnTTVf6OKv6v6U2+6McXXkRI65ao04S2ool+pP2eTX5J0F3X7S2o9A5mDsf/LXzXHTRGp/4BE0az2nNSDqxMXpDkJLfaNKSD6M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812411; c=relaxed/simple;
	bh=RciLskYjEAgE9PNK7dVwZrEIEjtpnUwfbry1Z1YzNDw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=r8e4XL6huVhSYA4uQ1FJtrjGd7Kn/Wa1xqhuHK+YdIjfqjO4l2xNsOViN/jJwv0+pZURV/+uctnx5+hBgR2oXIt5Nxuhy/aK9Zoms4rzVzsJ6RGuNLPrdukcOmowfLEeWXo+u6pkLPwiCu1efCxXQRX7NKsLjrcQs9ZEEZGi9dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kv8fXA+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kv8fXA+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FBD1F0089B;
	Mon, 12 Oct 2026 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791812409;
	bh=PCiq87ASEqqtbxx6gKSrORXlymAyrMe+dwGVVNpLHlw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kv8fXA+xVZDM9j+EBhB1R9Ik5F/Arl2GYLb4YpTYQAEurln0fv9bz8TH8yHu5cK8l
	 diY0w56VY4L10iFmreUEUnZMPX8oBz0xREfgN3XKgoYiHaB8b/BpzGTwmYhDKUzZ0f
	 G+g11nPR6QZJda0iqeVszvzMNSSOMjiYVhpuz+nN4ZqibreJLQOuPcH7LYJf9OfpoT
	 hhzYu7clmOrsS2N1tL3jOHCNS0Bn3nAKvn/diSQnmCYamGNcUSIXaJOi2ic3qrSMne
	 GHvtym3KwvrQUlkWNyXGxh6JV/aKtWGjPUrMRlDgcixnoFupHBHL1zebgOJFmobPt6
	 ZKO6VWyssHnJQ==
Message-ID: <sashiko-outbox-168194@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/9] block: add storage element management ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012130121.1902634-5-dlemoal@kernel.org>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:40:08 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] block: concurrent I/O race in storage element removal/restoration
- [High] block: silent data loss in conventional zones on storage element i=
octls
- [High] block: cross-partition data destruction via storage element ioctls
- [Medium] block: zone state permanently desynchronized if SE ioctl is inte=
rrupted
--

commit 8f33e7baabedb5d2ad1cccf418448851e57fed71
Author: Damien Le Moal <dlemoal@kernel.org>

block: add storage element management ioctls

This commit introduces new ioctl commands for storage element management on
zoned block devices. The new commands allow userspace to query, report,
remove, and restore storage elements.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 46822c7a05ecc..8736e80b4080d 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c

[ ... ]

> @@ -2917,6 +2968,52 @@ int bdev_remove_storage_element(struct block_devic=
e *bdev,
>  }
>  EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
> =20
> +static int blkdev_flush_and_truncate(struct block_device *bdev,
> +				     blk_mode_t mode)
> +{
> +	int ret;
> +
> +	inode_lock(bdev->bd_mapping->host);
> +	filemap_invalidate_lock(bdev->bd_mapping);
> +	ret =3D blkdev_issue_flush(bdev->bd_disk->part0);
> +	if (!ret)
> +		ret =3D truncate_bdev_range(bdev, mode, 0,
> +					  bdev_nr_bytes(bdev) - 1);

[Severity: High]
Will this discard unwritten buffered data in conventional zones?

While users might typically use direct I/O for zoned devices, zoned devices
can contain conventional zones which fully support and commonly use buffered
I/O. truncate_bdev_range() delegates to truncate_inode_pages_range() which
forcefully drops all pages in the mapping. Could dirty pages be silently
destroyed here? Should this code call filemap_write_and_wait() before
truncating the cache?

[Severity: High]
Does this only invalidate the page cache for the opened partition?

When a user invokes these ioctls on a partition (e.g., /dev/sda1),
bdev->bd_mapping is the page cache for that partition. Since the underlying
hardware operation modifies the entire physical device, the page caches for
the whole disk and other partitions are not invalidated, which could lead to
stale reads and silent data corruption across the system.

> +	filemap_invalidate_unlock(bdev->bd_mapping);
> +	inode_unlock(bdev->bd_mapping->host);
> +
> +	return ret;
> +}

[Severity: High]
Are we safely dropping the VFS locks before the storage element removal
starts?

The locks preventing concurrent I/O and page cache repopulation are released
here. When the ioctl handler later delegates to
bdev_remove_storage_element(), there is no barrier preventing concurrent
processes from opening the device and issuing buffered or direct I/Os during
a destructive hardware operation.

> +
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

[Severity: High]
Is a user with write access to a single partition able to destroy data on
other partitions?

The storage element ioctls issue a disk-wide destructive hardware command
that can alter the physical geometry of the drive. Without checking if the
block device is a partition (e.g., via bdev_is_partition()) or requiring
capable(CAP_SYS_ADMIN), these operations might destroy zones belonging to
other partitions.

[ ... ]

> +	/*
> +	 * Flush the device volatile write cache and invalidate all cached data
> +	 * so that reads do not return old data for zones that went offline.
> +	 * Since a user can only write to zoned devices using direct IOs, we
> +	 * should never have any dirty page invalidated and so no data loss as
> +	 * long as the device cache flush succeeds, that is, as long as the
> +	 * flush does not use degraded storage elements.
> +	 */
> +	ret =3D blkdev_flush_and_truncate(bdev, mode);
> +	if (ret)
> +		return ret;
> +
> +	return bdev_remove_storage_element(bdev, element_id);
> +}

[Severity: High]
Is it safe to rely on the caller to prevent new I/Os here?

bdev_remove_storage_element() freezes the queue but immediately unfreezes
it before executing the long-running remove_element callback. Since the VFS
locks were already dropped in blkdev_flush_and_truncate(), the device is
left unprotected from concurrent I/Os during a destructive hardware
operation.

[Severity: Medium]
Could the zone state become permanently desynchronized if this ioctl is
interrupted?

When this ioctl is interrupted by a fatal signal, the underlying loop in
disk_wait_for_se_mgmt_completion() returns -EINTR and
bdev_remove_storage_element() immediately revalidates the zones while the
hardware operation is still in progress.

Because the polling loop was the only tracking mechanism, the kernel's
zones_state array is never updated to reflect the final state of the
depopulated zones once the hardware finishes. This leaves the kernel
permanently desynchronized, potentially leading to unexpected I/O errors.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012130121.1902=
634-1-dlemoal@kernel.org?part=3D4
