Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01B63806C4
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164890; cv=none; b=Qz6fdKigRBrbdIp9ceUlA8Aet8zy7H42inRpxx1MyexR4xiEYWnT3w14I1YOADNDSaVlavLSRfbgPuj9sne36JSBzyOL87BnjUyd4ASB11icVLU+yDRWHIUCmn7JFEA7tRuooB88iyInSsnMUn+AssFX/hHDIUSxqaRGBNJHwX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164890; c=relaxed/simple;
	bh=1U5d94ejKXxMRXFm9gznVDq+RW7ilXR1UpkwaDMfA8c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FCsIfXcluPapHvLcWHQzlSErx0wlzsGmRwQQ0vJS2tgyI6/GYbA4GpLfJQmC/vumHpJI6paE3T18t5Q6qUeZ5TyCFUNWZgd/JyXhADbFfALIUVJWudkdUOLzdl8ZkjvStAv3ogmgd8C5RZwRVQXcVenpzWNOiiMOngp+MmF3Jq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSozdpyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSozdpyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2F41F00A3E;
	Mon, 27 Jul 2026 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164888;
	bh=dJzGGR3S7VFSFYfiB1soToWEmW8UvczFc72cTHJ0VGI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iSozdpyrz+AhnR3zLcKmdTdZFeCP+Z6RNIpXZYN2uWgTX8nwjqpEs7Zo3jg1Sei5W
	 7/IE8i4d4eXDBiCcO2McmL/e4LcUdK9e5HFs/CrbNSUJq8SEdcqcNyneIBX+tGyYtq
	 8xgKIu6yGYLeAra35mNJHG1StCtqNPatBdEaoS8nJ3t5hG1CePUuDCC6EZOhHMV3ko
	 Cq7SsuKiamIq5mHWuAQe/OZE9qIxrZBH8CAKVxXAOyISRJjmfKwXDEqggEBs2V9dN8
	 ot88abkcJSnq+dz7dynYjc9RqNR9njj3uW4UJZPx9pfAEwjFSG2QKeTMVhoQwSzAvp
	 7lyqnj2RLnwgQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/27] libmultipath: Add support for block device
 IOCTL
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-9-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:08:07 +0000
Message-Id: <20260727150808.6E2F41F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Holding the SRCU read lock across the underlying ioctl call causes=
 an AB-BA deadlock if the ioctl triggers a synchronous path removal.
- [High] Forwarding ioctls via part0 strips partition context, bypassing pa=
rtition-specific capability checks in underlying drivers.
- [Medium] Returning -EOPNOTSUPP instead of -ENOTTY for unimplemented under=
lying ioctls breaks userspace fallback mechanics.
--

--- Patch [8]: [PATCH v5 08/27] libmultipath: Add support for block device =
IOCTL ---
commit c97bc7070dfdd2d761dd1464c23d043908adfc68
Author: John Garry <john.garry@linux.dev>

libmultipath: Add support for block device IOCTL
   =20
Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler. The .compat_ioctl
handler is given the standard handler.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index c78d46a446cf3..af90cf38a79d6 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -454,11 +454,47 @@ static void mpath_bdev_release(struct gendisk *disk)
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
> +		err =3D -EOPNOTSUPP;
> +		goto out_unlock;
> +	}

[Severity: Medium]
Should this return -ENOTTY instead?

Returning -EOPNOTSUPP for unimplemented ioctls in mpath_bdev_ioctl() can br=
eak
userspace fallback mechanisms in tools like smartctl or nvme-cli that
explicitly check for -ENOTTY to determine if an ioctl is supported on the
block device.

> +
> +	err =3D mpath_device->disk->fops->ioctl(
> +			mpath_device->disk->part0, mode, cmd, arg);

[Severity: High]
Does forwarding ioctls to part0 in mpath_bdev_ioctl() bypass
partition-specific security checks?

If an ioctl is invoked on a multipath partition, passing
mpath_device->disk->part0 strips the partition context. Underlying drivers
like nvme rely on bdev_is_partition() to enforce stricter security on
partitions (e.g. requiring CAP_SYS_ADMIN). Because part0 represents the who=
le
disk, this could allow users with CAP_SYS_RAWIO to issue unrestricted
passthrough commands.

[Severity: High]
Could holding the srcu read lock during the underlying ioctl cause a deadlo=
ck?

In mpath_bdev_ioctl(), if the ioctl triggers a synchronous path removal
(like an nvme namespace management command), the underlying driver might
attempt to remove the namespace. If mpath_delete_device() calls
synchronize_srcu(&mpath_head->srcu) during removal, the removal thread will
block waiting for the srcu read lock to be released, while the ioctl thread
holds the lock and waits for the removal to complete.

> +out_unlock:
> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	return err;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D8
