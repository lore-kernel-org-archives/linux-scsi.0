Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE1030DECE
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 10:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194436; cv=none; b=Jc+BvMANWZPWpLAjTT+yS6dSLIBCHTQvX5krO/o1H8ZRb7GzdBG2Wfb8FkDVSjVcXKL2z4y183oqirduixKsciuRmOXjO/cUnxlBJRfL6YRMzbj7XTOM2IoLvi3Fp+7oaESHzHqiq+VswqTqPdDYwczNGn6WmvCcOACXXbjOamM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194436; c=relaxed/simple;
	bh=UcfOMa88rFRmCwGQckxSfUIsuL3CD9kNUF59JXPjDTI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=epXpYej4gAPvSCUTvGZJr3luwU7vmYcp70/Nsh9JVYJZZgGrpgcCdcYrmSIPqvNEc5a4TIy0HQLr816a90LJugq9f0/orwXwNkWkahVcUyMRjgM1kScG+0uJL2zRS18FDIFHgv25MdLF93ftPYq9qHPfryEzdycPfRYwx/vygeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UXV7qsfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXV7qsfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BC41F000FF;
	Mon,  5 Oct 2026 10:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194434;
	bh=12qZsogKHcbriLMZ0BQ5QQK5pelYcOC/v2kKpntmQNc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UXV7qsfxrytXLugS3/M7Jc4/xplzYtjnHxQHO9RrdSbTci+1cWiPX0Wep7uR6zmEL
	 15NjwBgX3fRZVw9NLjHNahE7VQz2FKb2vTF3220RZb6zJkqGqDKfntqaGER8xnOQ9o
	 sQOI9E1egjM/61BGQVwbKYBZILWzNvw5993WUKICdsCMPHPcI7yvghkLblCDVwRw9g
	 aiYEduT8EeDQ6Mwt8c1AC9soROROBRZcuID54psGJAJwsBKkZefGpGW8vMaLguuEx0
	 3s/UFy6nt+d24GCFvRNROuPgxDY7ZvM3Bh6cSVYd5JVihry+flA/eiF52ar30dk3Oi
	 cgMuSi6RPmk/w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/7] block: add storage element management ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261005094632.580753-4-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 10:00:34 +0000
Message-Id: <20261005100034.85BC41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] block: missing queue freeze during storage element reconfiguration
- [High] block: integer truncation in invalidate_inode_pages2_range() skips=
 cache invalidation
- [High] block: heap out-of-bounds read and info leak in blkdev_report_stor=
age_elements_ioctl()
- [High] block: loop-carried dependency in disk_wait_for_se_mgmt_completion=
() causes heap overflow
- [Medium] block: unbounded memory allocation in blkdev_report_storage_elem=
ents_ioctl()
- [Medium] block: silent OOM failure in disk_wait_for_se_mgmt_completion() =
bypasses wait
--

commit c30fd4a3def1740a027fbbe35b4c863893b60362
Author: Damien Le Moal <dlemoal@kernel.org>

block: add storage element management ioctls

This commit introduces new ioctl commands for zoned block devices to allow
userspace management of storage elements. It provides interfaces for getting
the number of elements, reporting their status, and removing or restoring
degraded elements.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index b713512f7d48f..62b9cf21e9adf 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
[ ... ]
> @@ -2794,6 +2795,69 @@ int bdev_report_storage_elements(struct block_devi=
ce *bdev,
[ ... ]
> +static int blkdev_report_storage_elements_ioctl(struct block_device *bde=
v,
> +						void __user *argp)
> +{
> +	struct blk_storage_elements_report rep;
> +	struct blk_storage_element *elements;
> +	unsigned int nr_elements;
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
> +	if (!rep.nr_elements)
> +		return -EINVAL;
> +
> +	nr_elements =3D rep.nr_elements;
> +	elements =3D kzalloc_objs(struct blk_storage_element, nr_elements);
> +	if (!elements)
> +		return -ENOMEM;

[Severity: Medium]
Is it safe to use kzalloc_objs() here with an unbounded user-provided count?

A maliciously crafted ioctl call with a huge rep.nr_elements will request an
allocation exceeding KMALLOC_MAX_SIZE. This will trigger a kernel
WARN_ON_ONCE stack trace and fail with -ENOMEM. Repeated calls by an
unprivileged user with read access can spam dmesg and degrade system
performance.

> +
> +	ret =3D bdev_report_storage_elements(bdev, &nr_elements, elements);
> +	if (ret)
> +		goto free_elements;
> +
> +	retc =3D copy_to_user(argp + sizeof(struct blk_storage_elements_report),
> +			    elements,
> +			    sizeof(struct blk_storage_element) * nr_elements);

[Severity: High]
Can this copy_to_user() read out of bounds and leak kernel heap memory?

If the hardware reports more elements than the user originally requested,
bdev_report_storage_elements() updates nr_elements to the larger count.
This larger nr_elements is then used to determine the copy byte length,
which copies past the end of the elements allocation and leaks uninitialized
adjacent kernel heap memory to userspace.

[ ... ]
> @@ -2847,6 +2911,22 @@ int bdev_remove_storage_element(struct block_devic=
e *bdev,
>  }
>  EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
> =20
> +static int blkdev_remove_storage_element_ioctl(struct block_device *bdev,
> +					blk_mode_t mode, void __user *argp)
> +{
> +	unsigned int element_id;
> +
> +	if (!(mode & BLK_OPEN_WRITE))
> +		return -EBADF;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
> +
> +	if (get_user(element_id, (unsigned int __user *)argp))
> +		return -EFAULT;
> +
> +	return bdev_remove_storage_element(bdev, element_id);
> +}

[Severity: High]
Does bdev_remove_storage_element() fail to hold the queue freeze?

In bdev_remove_storage_element(), the queue is unfrozen prematurely:

	memflags =3D blk_mq_freeze_queue(disk->queue);
	blk_mq_unfreeze_queue(disk->queue, memflags);

The block layer subsystem guide requires maintaining a queue freeze across
reconfiguration or teardown. blk_revalidate_disk_zones() assumes the queue
is actively frozen when called from a reconfiguration context.

Since the ioctl does not implicitly serialize I/O, concurrent userspace I/O
can be submitted while the zone structure is being invalidated and rewritte=
n.
This allows in-flight BIOs to read torn configuration state or cause
use-after-free.


[Severity: High]
Does bdev_remove_storage_element() pass bytes instead of a page index to
invalidate_inode_pages2_range()?

	invalidate_inode_pages2_range(bdev->bd_mapping, 0,
				      get_capacity(disk) << SECTOR_SHIFT);

The end parameter expects a page index (pgoff_t). On 32-bit systems where
pgoff_t is a 32-bit unsigned long, passing a byte capacity for any disk
exceeding 4GB overflows the parameter.

For example, exactly 4GB evaluates to 0, invalidating only the 0th page.
This leaves the rest of the page cache entirely stale, causing silent data
corruption when userspace later reads from the modified block device.


[Severity: High]
Does disk_wait_for_se_mgmt_completion() have a loop-carried dependency that
causes a heap overflow?

When called by bdev_remove_storage_element(), the elements buffer is
allocated once before entering the polling loop. Inside the loop:

	while (1) {
		/*
		 * Check if we have storage elements being removed or restored.
		 */
		nr_se =3D nr_elements;
		ret =3D (disk->fops->se_ops->report_elements)(disk,
						&nr_elements, elements);

If the device dynamically increases the number of reported elements,
report_elements updates nr_elements to the higher value.

In the next loop iteration, this larger nr_elements is passed back into
report_elements, which will write the larger number of elements into the
originally sized elements heap buffer, causing an out-of-bounds heap
overwrite.


[Severity: Medium]
Does disk_wait_for_se_mgmt_completion() bypass the wait on OOM?

	elements =3D kzalloc_objs(struct blk_storage_element, nr_elements);
	if (!elements)
		return;

If kzalloc_objs() fails, the function silently returns without completing i=
ts
waiting loop.

Under memory pressure, this allows the caller to immediately proceed and
invoke blk_revalidate_disk_zones() while the device is actively busy
mutating its zone configuration in the background. This leads to I/O timeou=
ts,
torn reads of zone statuses, or hardware errors.

[ ... ]
> @@ -2886,3 +2966,37 @@ int bdev_restore_storage_elements(struct block_dev=
ice *bdev)
>  	return blk_revalidate_disk_zones(disk);
>  }
>  EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
> +
> +static int blkdev_restore_storage_elements_ioctl(struct block_device *bd=
ev,
> +						 blk_mode_t mode)
> +{
> +	if (!(mode & BLK_OPEN_WRITE))
> +		return -EBADF;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
> +
> +	return bdev_restore_storage_elements(bdev);
> +}

[Severity: High]
Does bdev_restore_storage_elements() also fail to hold the queue freeze?

Similar to the removal path, the queue is unfrozen prematurely:

	memflags =3D blk_mq_freeze_queue(disk->queue);
	blk_mq_unfreeze_queue(disk->queue, memflags);

This opens a window for concurrent I/Os during restoration.


[Severity: High]
Does bdev_restore_storage_elements() also skip cache invalidation due to
integer truncation?

Similar to the removal path, it passes a byte capacity instead of a page
index:

	invalidate_inode_pages2_range(bdev->bd_mapping, 0,
				      get_capacity(disk) << SECTOR_SHIFT);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005094632.5807=
53-1-dlemoal@kernel.org?part=3D3
