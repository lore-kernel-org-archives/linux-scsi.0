Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219D247D954
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785328801; cv=none; b=oE6I/MJkZot27ikBiaFiH/YxmfjOyCDVk6oHpD8m7QxoLWrPwuY7GW3lll5R5BBkmOKFlAxzRv2muLNOI2jfLKywQTPUVe2JIPIzDqnKIKy1BH1Rs2XLOJEoP6EfCybbwHw+zJOPiZMLUIOWaBspEs2aO29SqdKZE6XTJh+35pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785328801; c=relaxed/simple;
	bh=lULNTLpUMEgDvNuZS/hBqyhIJ5O0Z65kgOXejNslLGc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FOvZd3AEHrShB071yBBkcI3puRoSmBqw0xwbfA14AtUq6QF/WiTgVqk6cgJq9VbLkYSsSGvApIUeKHfzqqLKpOd6kXWwCk4gsQyX6/TN3Ec5DIH/+QygPGbGPRCaZNQtUWvAmbGhTQXvcs9pDxKPoFsyaHKwI1s6I1KxfV5P23Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7ieK9GW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7ieK9GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95981F000E9;
	Wed, 29 Jul 2026 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328792;
	bh=H/mEitDW0DXrsgZSZn0IJvvqrxsS64WOZBCrTj3tets=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N7ieK9GW4o77Gf3G5Sfe5k7JfhEuDazuoBoZ603Ceeazbnc3zAt1r+CxDJP1DkqZi
	 OAyA4PoqrbF9eh5YZpLzU+BWLHtZRDS334LFkipszBlf9NkXOid6duXRhyAumVPwRw
	 iyz5M42+pweuCnOtvA/LPQcOkh1o9DvumpsHyLVHrqm3a+2htr8rsneAaZAzHYgYpP
	 cp3ujgslHfAC3pLkR7b4BvhCSM6Z7BbeSsqMYr0xRBQK6e9e0Ikn43tP9fEFvRaBh7
	 M9+52/O57u6BA1yjdG/kVUnU2plyHemgBSXxeKiWYZYnZ45BYEOPgEgioKBH00lMQF
	 9GrFu1QXOAaGA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/27] libmultipath: Add support for block device
 IOCTL
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-9-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 12:39:51 +0000
Message-Id: <20260729123951.D95981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Deadlock in `mpath_bdev_ioctl` due to holding `srcu_read_lock` whi=
le forwarding ioctls that can trigger synchronous path removal.
- [High] Bypass of underlying partition-specific IOCTL security policies be=
cause `mpath_bdev_ioctl` unconditionally passes `part0`.
--

--- Patch [8]: [PATCH v6 08/27] libmultipath: Add support for block device =
IOCTL ---
commit d2e45114ccfb93fccdccc60ed75e05084f9b9173
Author: John Garry <john.garry@linux.dev>

libmultipath: Add support for block device IOCTL

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 58eb9be5bebbe..f1758d1e60a60 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -454,11 +454,53 @@ static void mpath_bdev_release(struct gendisk *disk)
>  	mpath_put_head(mpath_head);
>  }
> =20
> +static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
> +		    unsigned int cmd, unsigned long arg)
> +{
> +	struct gendisk *disk =3D bdev->bd_disk;
> +	struct mpath_head *mpath_head =3D mpath_gendisk_to_head(disk);
> +	struct mpath_device *mpath_device;
> +	int srcu_idx, err;
> +
> +	/*
> +	 * This check is duplicated from sd_ioctl() as we don't pass the
> +	 * partition bdev to fops->ioctl. That is not yet possible as the
> +	 * per-path disk is hidden and, as such, does not have partitions
> +	 * scanned.
> +	 */
> +	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
> +		return -ENOIOCTLCMD;
> +
> +	srcu_idx =3D srcu_read_lock(&mpath_head->srcu);
> +	mpath_device =3D mpath_find_path(mpath_head);
> +	if (!mpath_device) {
> +		err =3D -EWOULDBLOCK;
> +		goto out_unlock;
> +	}
> +
> +	if (!mpath_device->disk->fops->ioctl) {
> +		err =3D -ENOTTY;
> +		goto out_unlock;
> +	}
> +
> +	err =3D mpath_device->disk->fops->ioctl(
> +			mpath_device->disk->part0, mode, cmd, arg);

[Severity: High]
Does unconditionally passing part0 bypass partition-specific IOCTL security
policies in the underlying driver?

By passing the whole-disk block device (mpath_device->disk->part0),
bdev_is_partition() will evaluate to false in the underlying driver. For
drivers like NVMe, this strips the partition context and could bypass
requirements like CAP_SYS_ADMIN for passthrough commands on partitions,
allowing a user with only CAP_SYS_RAWIO to execute whole-disk commands.

[Severity: High]
Can holding the SRCU read lock across the underlying ioctl cause a deadlock?

If the underlying ioctl triggers a controller reset or device removal, the
teardown path could eventually wait on synchronize_srcu() for this exact
srcu instance. Since the ioctl is waiting for the operation to complete
while holding srcu_read_lock(), synchronize_srcu() would block forever.

> +out_unlock:
> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	return err;
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D8
