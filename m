Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F43309EE7
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164645; cv=none; b=AMvL2zzS4IGzUW1T2f2tFjyiGz20wY8Bd7QjqgFEoYLTdP3y2CP9Q/YgFB/nvkf5iBkC57rKvViRpFcGsHd57pssm1rN4+uZz0gFAmsmYrGtIdZNEYJdfO2XvZzIe5aJsZjD3XDJuk9SUMOxYcqAw29fUSSlLRUa7W9HJrA2ABQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164645; c=relaxed/simple;
	bh=XA21IdtUfmLuYv0UMpd23ZueZQS3wK89hy7DWcX4lJ8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k7xLGtN/3aURXNuX0jWcfY9cBR54HkyeBwA3z4NDdEu7Gyg8ZRXrWDkPR/e6EL/BIXhppVe8QewwaiN/fX/Bj8sIZ72ZSVwhoGTfLS/lJPQVCH6y/0Hu5kuL+BdRi8Ad4zrQ2hm7hwgmxjTCwOusPI7jZLT+I8r884KQ2P69PvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=du9kYnqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="du9kYnqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C261F000E9;
	Mon, 27 Jul 2026 15:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164644;
	bh=VmqwSVj1MAanX5DeyV/QRlk1jm3ounZkv+6WIKsu788=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=du9kYnqdlbG0v0LF87lXaQkxhv5jEVJuqrqEUvEIomn+B2xqGHIDoBymgW5MdedCR
	 OnbhLQrmX8b6XDKKWwHVy9y6xpGQ0OU6kBdy8HB/qQ66sOA+SYDuDxS+akcsFQoUV5
	 5TV7Ai0tPPFSM7VjxVjiFzuzd5S+oqe01KY037SUU42qXwpVpYTmNM0dT9cZqg2ZcV
	 XuYNDr87BCN92SZkdL7KmqzwTl/ic+jm1Q1dNcPnJxILXwB7cbzOVNt1kZxIBK7o1h
	 Ep/LhoYr7Tr+DVRak+9/VuUGkC1/Sqg6t5fPTQCtv0QdY7pFn2Rr7VkvwiOAVW58N3
	 0ajsf/gaWus5A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/27] libmultipath: Add basic gendisk support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-3-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:04:02 +0000
Message-Id: <20260727150403.42C261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mpath_alloc_head_disk() leaves mpath_head->disk as an ERR_PTR on f=
ailure, leading to a kernel panic during cleanup in mpath_put_disk().
- [High] The allocated multipath disk unconditionally uses mpath_ops, which=
 lacks a .submit_bio implementation, causing device_add_disk to fail and re=
ndering the device incapable of processing I/O.
--

--- Patch [2]: [PATCH v5 02/27] libmultipath: Add basic gendisk support ---
commit 15c7ca249b473955f186aec1f0490e8ccef64672
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add basic gendisk support
   =20
Add support to allocate and free a multipath gendisk.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 9cc398d266adf..d2e334259f3c1 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -35,6 +35,104 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
>  }
>  EXPORT_SYMBOL_GPL(mpath_head_uninit);
> =20
> +static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
> +{
> +	struct mpath_head *mpath_head =3D disk->private_data;
> +
> +	return mpath_get_head(mpath_head);
> +}
> +
> +static void mpath_bdev_release(struct gendisk *disk)
> +{
> +	struct mpath_head *mpath_head =3D disk->private_data;
> +
> +	mpath_put_head(mpath_head);
> +}
> +
> +const struct block_device_operations mpath_ops =3D {
> +	.owner          =3D THIS_MODULE,
> +	.open		=3D mpath_bdev_open,
> +	.release	=3D mpath_bdev_release,
> +};

[Severity: High]
Does this block device operations struct need a .submit_bio callback?

Since device_add_disk() in the block layer strictly enforces that bio-based
disks provide a .submit_bio callback, won't device_add_disk() unconditional=
ly
return -EINVAL when mpath_device_set_live() is called?

Also, the helper is_mpath_disk() strictly requires disk->fops =3D=3D &mpath=
_ops,
which prevents drivers from dynamically overriding the operations struct to
provide their own .submit_bio implementation.

> +EXPORT_SYMBOL_GPL(mpath_ops);

[ ... ]

> +void mpath_put_disk(struct mpath_head *mpath_head)
> +{
> +	if (!mpath_head->disk)
> +		return;
> +
> +	/* make sure all pending bios are cleaned up */
> +	flush_work(&mpath_head->partition_scan_work);
> +	put_disk(mpath_head->disk);
> +	mpath_head->disk =3D NULL;
> +}
> +EXPORT_SYMBOL_GPL(mpath_put_disk);
> +
> +int mpath_alloc_head_disk(struct mpath_head *mpath_head,
> +			struct queue_limits *lim, int numa_node)
> +{
> +	if (!mpath_head->disk_groups || !mpath_head->parent ||
> +	    mpath_head->disk)
> +		return -EINVAL;
> +
> +	mpath_head->disk =3D blk_alloc_disk(lim, numa_node);
> +	if (IS_ERR(mpath_head->disk))
> +		return PTR_ERR(mpath_head->disk);

[Severity: High]
If blk_alloc_disk() fails and returns an ERR_PTR, it is assigned to
mpath_head->disk. Does this cause a crash during cleanup?

If the caller handles this failure by tearing down the object via
mpath_put_disk():

void mpath_put_disk(struct mpath_head *mpath_head)
{
	if (!mpath_head->disk)
		return;
	...
	put_disk(mpath_head->disk);
}

The (!mpath_head->disk) check will evaluate to false for an ERR_PTR,
allowing the error pointer to be passed to put_disk(), which will dereferen=
ce
it. Should mpath_head->disk be cleared to NULL before returning the error?

> +
> +	mpath_head->disk->private_data =3D mpath_head;
> +	mpath_head->disk->fops =3D &mpath_ops;
> +
> +	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D2
