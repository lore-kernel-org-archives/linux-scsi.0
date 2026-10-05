Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB8F44A40F
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 10:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194508; cv=none; b=n7rbbgXX12CJCJmbtDQpzkvuhKO87QgV+tlq89yzuJ1+bR9aHriy+Tg8YZJA1/xjquVsdJB4aBs7T7TFZu6fqJpKEIvE2ueHc+R8enGxcJ1x2vIGJKIx/35w55kOoAaSzCuIfE7dNfYfXu5Ehin0r/l3sipbGmUUETLJ2luOZ/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194508; c=relaxed/simple;
	bh=8D8WTuOU9czgLBzjdJBhxTa9AEClAWxwgm2GPAaJpYA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P5vtBYYVBBMRXcJ1lOLmVNqmk/AnCTwOlPcWMP2y4yI+JaKv0+DBvOzfJBLf8SZGZMuHA9qwFhb5s27yt7dape9LJryBAEmwt0ieY+mRHj5g47yNH7wXs5a0TosBJ+/RgNErAtXK3gfAeLhdaSy1luA5V1owP5PuLQbiAu157zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGBcaauk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGBcaauk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F2D1F000FF;
	Mon,  5 Oct 2026 10:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194506;
	bh=1lBYbHbzEtc2HW/3u3Rnhp8fo4q3f63EQxJ4pPnOUnY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fGBcaaukKaRZxAnMPIRIXFFt/2oOCVJKAYkC8amxaeKmzVsVxLeKrK2H+y2wFHPbE
	 mnE7bBx5JNszMz/u2c4cr2LOyriGepLSRn+JkbF0nT+OR2Yt5QgKfYwo04TGPFS6HC
	 dgdRxuT5G9n5+yZMB7Xk+3mbBihHqQaUPdmnRfdNXnEbtExPYusdbSAcTa/vsp5Y3c
	 9yeJfL4xk/pfxdGSwizMfyUJIDA2V0RHuKImg27UYRRpbx8JQPunZblad9uG5YMdQm
	 I1rTmzIjpoXJWE/qHiFjkSYMdA/eJwFISAoDTKv68HpVkJJGxEa8xEGjbz5w0NXpx8
	 b8VmaT/Kdh1CQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/7] block: introduce storage element management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261005094632.580753-3-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 10:01:46 +0000
Message-Id: <20261005100146.B2F2D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] block: page index vs byte count mismatch in invalidate_inode_pages=
2_range
- [High] block: heap buffer overflow in disk_wait_for_se_mgmt_completion ar=
ray reuse
- [High] block: dirty page writeback omission before storage element removal
- [Medium] block: silent error abort in disk_wait_for_se_mgmt_completion ca=
uses premature zone revalidation
- [Low] block: blk_storage_element_status typos and duplicate fields in UAP=
I header
--

commit 71418115a91f7676078cbe8877b24a7405924eb7
Author: Damien Le Moal <dlemoal@kernel.org>

block: introduce storage element management

This patch introduces storage element management features for managing hard
disk heads. It defines generic block device driver operations for reporting,
removing, and restoring storage elements, allowing file systems to use the
data-preserving flavor of the depopulation feature.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 131c9f50b3da5..b713512f7d48f 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
[ ... ]
> +static void disk_wait_for_se_mgmt_completion(struct gendisk *disk)
> +{
> +	struct blk_storage_element *elements, *e;
> +	unsigned int i, nr_se, nr_elements =3D 0;
> +	int ret;
> +
> +	ret =3D (disk->fops->se_ops->report_elements)(disk, &nr_elements, NULL);
> +	if (ret) {
> +		pr_err("Failed to get number of storage elements\n");
> +		return;
> +	}
> +
> +	elements =3D kzalloc_objs(struct blk_storage_element, nr_elements);
> +	if (!elements)
> +		return;

[Severity: Medium]
Will this silently abort on failure instead of returning an error or retryi=
ng?

If report_elements() or the memory allocation fails, the function simply
returns. This means callers like bdev_remove_storage_element() will
immediately proceed to invoke blk_revalidate_disk_zones() while the hardware
is potentially still actively removing or restoring an element.

> +
> +	while (1) {
> +		/*
> +		 * Check if we have storage elements being removed or restored.
> +		 */
> +		nr_se =3D nr_elements;
> +		ret =3D (disk->fops->se_ops->report_elements)(disk,
> +						&nr_elements, elements);

[Severity: High]
Does this code risk a heap buffer overflow if the hardware dynamically
changes the number of reported elements?

The driver's report_elements() callback modifies nr_elements to the actual
number of descriptors returned. In the next iteration, nr_se is set to this
updated count and passed back as the buffer capacity. If the hardware repor=
ts
a higher count during polling, nr_elements is treated as a larger capacity
than what was originally allocated via kzalloc_objs().

> +		if (ret) {
> +			pr_err("Failed to get storage elements\n");
> +			break;
> +		}
> +
> +		e =3D elements;
> +		for (i =3D 0; i < nr_se; i++, e++) {
> +			if (e->status =3D=3D BLK_SE_STS_REMOVE_IN_PROGRESS ||
> +			    e->status =3D=3D BLK_SE_STS_RESTORE_IN_PROGRESS)
> +				break;
> +		}

[Severity: High]
Could this read uninitialized or stale memory if the driver returns fewer
elements than nr_se?

The loop iterates up to the pre-call capacity nr_se instead of the actual
returned count nr_elements.

[ ... ]
> +int bdev_remove_storage_element(struct block_device *bdev,
> +				unsigned int element_id)
> +{
[ ... ]
> +	/*
> +	 * Flush the volatile write cache if there is any. Note that this may
> +	 * lead to errors if degraded storage elements are used. So ignore
> +	 * errors here.
> +	 */
> +	blkdev_issue_flush(disk->part0);
> +
> +	/* Invalidate all cached data. */
> +	invalidate_inode_pages2_range(bdev->bd_mapping, 0,
> +				      get_capacity(disk) << SECTOR_SHIFT);

[Severity: High]
Does this miss dirty pages in the block device's page cache?

invalidate_inode_pages2_range() skips dirty pages and returns -EBUSY when it
encounters them. Since sync_blockdev() or filemap_write_and_wait() is not
called before this invalidation, dirty pages remain in memory and will
eventually be written back by background threads to obsolete or offline zon=
es
after the storage element is removed.

[Severity: High]
Does this pass a byte size instead of a page index, leading to incomplete
cache invalidation?

The invalidate_inode_pages2_range() function expects a page index. The
code here passes get_capacity(disk) << SECTOR_SHIFT, which is the capacity
in bytes. On 32-bit platforms where pgoff_t is a 32-bit unsigned integer,
passing a large byte count causes the value to be silently truncated modulo
2^32. For example, a 1TB disk truncates to 0, meaning only page 0 is
invalidated.

> +
> +	ret =3D (disk->fops->se_ops->remove_element)(disk, element_id);
> +	if (ret)
> +		return ret;
[ ... ]
> +int bdev_restore_storage_elements(struct block_device *bdev)
> +{
[ ... ]
> +	/* Invalidate all cached data. */
> +	invalidate_inode_pages2_range(bdev->bd_mapping, 0,
> +				      get_capacity(disk) << SECTOR_SHIFT);

[Severity: High]
Does this suffer from the same page index vs byte count mismatch as above,
causing truncation on 32-bit systems?

> +
> +	ret =3D (disk->fops->se_ops->restore_elements)(disk);
> +	if (ret)
> +		return ret;
[ ... ]
> diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
> index 6638361209667..3a4bacfe79797 100644
> --- a/include/uapi/linux/blkzoned.h
> +++ b/include/uapi/linux/blkzoned.h
> @@ -208,4 +208,71 @@ struct blk_zone_range {
>  #define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
>  #define BLKREPORTZONEV2	_IOWR(0x12, 142, struct blk_zone_report)
> =20
> +/**
> + * enum blk_storage_element_status - Statuc of a zoned device storage el=
ements.
> + *
> + * @BLK_SE_RDWR: The storage element handles both reads and writes.
> + * @BLK_SE_READ: The storage element handles reads only.
> + * @BLK_SE_WRITE: The storage element handles writes only.
> + * @BLK_SE_WRITE: The storage element type is unknown.
> + */
> +enum blk_storage_element_type {

[Severity: Low]
This isn't a bug, but there are some typos in this UAPI header.

The documentation has a typo in "Statuc" and names the wrong enum in the
description. Additionally, @BLK_SE_WRITE is duplicated in the docstring
instead of documenting @BLK_SE_TYPE_UNKNOWN.

[ ... ]
> +enum blk_storage_element_status {
> +	BLK_SE_STS_OK			=3D 0x01,
> +	BLK_SE_STS_DEGRADED		=3D 0x02,
> +	BLK_SE_STS_REMOVE_IN_PROGRESS	=3D 0x03,
> +	BLK_SE_STS_REMOVE_ERROR		=3D 0x04,
> +	BLK_SE_STS_RESTORE_IN_PROGRESS	=3D 0x05,
> +	BLK_SE_STS_RESTORE_ERROR	=3D 0x06,
> +	BLK_SE_STS_REMOVED		=3D 0x07,
> +	BLK_SE_STS_UNKOWN		=3D 0xFF,
> +};

[Severity: Low]
This isn't a bug, but the UAPI constant for the unknown state is misspelled
as BLK_SE_STS_UNKOWN. Correcting this before the UAPI freezes could prevent
compatibility issues later.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005094632.5807=
53-1-dlemoal@kernel.org?part=3D2
