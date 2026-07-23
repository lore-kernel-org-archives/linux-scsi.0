Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355B6415F3A
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801371; cv=none; b=Tuwp5DH0abLg5GFp1tSgMU0S/qQujeMFpg9FK4Lfrjdhw5OI/A8tr6vewNhpQaHeTbLhZR75hgrVp/j8wPBkMOVUV/Apdz0vDszNzxb86quiUpTThMxtmKsfmbh2+JyZKljGbi3I6rNh9EbfvIDeN1uQHoj9PQaFWj3mDjiJML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801371; c=relaxed/simple;
	bh=bsiAddIHlmlP+9ymxrG8PBtXlaJ1zSEhkBJywr4GsCM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lTU8gOnvlPELazxsPUEx1AfQXaPk4d/eO9nWwEhlvF/j/gAusd0nOhccugupOs55dJCz7ZIt4FJobLB98rcPjLfXPhORj4UR18rOqed/E2eQjHFl9SCR6OCymj1E1hZBtNDYa2faUtmorNH/tNzDez2IpTeY+iuNk7pb5D0Vp5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewhg7+tL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewhg7+tL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A000D1F00A3A;
	Thu, 23 Jul 2026 10:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784801369;
	bh=4/cDP2RHEeqUDiwWo1rBNbH0C1zAi31czGVttV1PC+I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ewhg7+tLhXCFRwb66YLB9u5bF97p45SrqIjSY5yKbO7llif0oSd5fcn7QDbWUU4f9
	 xKPFQo2e1vpbyv0aE3I7sfPsJfMTx2uVFbwzEbyU0FOilsLxoTIoPIArCtqCnoBq2z
	 DMFfGMarEV3tH3G7XzW8EYhjZgQcBJhuCNjYNjPP2Ph+BSFtW2gjI0VUdvS4tmrnmY
	 W4OISC9rn+L5kSq91QjHu3CRqSzQNq0AZvujXtzaDp49lAA4zaFVLYv1qZftxzJfOZ
	 /+CWkj7NlPussFKWszxtaaO2OUsl9bMYhwJJ5rvGW8fc/X5eBmVaOVnuxDJdS1qg6W
	 8YZqiAP0mSbaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/28] libmultipath: Add support for block device
 IOCTL
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-10-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-10-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:09:29 +0000
Message-Id: <20260723100929.A000D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Bypass of partition-based security restrictions for block ioct=
ls by passing the underlying whole-disk block device (part0) to the lower d=
river's ioctl.
- [High] Holding the SRCU read lock around the underlying block device IOCT=
L causes an ABBA deadlock if the IOCTL triggers or blocks on path removal.
--

--- Patch [9]: [PATCH v4 09/28] libmultipath: Add support for block device =
IOCTL ---
commit 8ca4b41fee0b6082cd169ad8577365e7f205461d
Author: John Garry <john.garry@linux.dev>
Subject: libmultipath: Add support for block device IOCTL

This commit adds mpath_bdev_ioctl() as a multipath block device ioctl
handler. It delegates the ioctls to the underlying path's block device
operations.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 0232f51f64742..fc8ba8fc501f1 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -478,11 +478,44 @@ static void mpath_bdev_release(struct gendisk *disk)
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
> +
> +	err =3D mpath_device->disk->fops->ioctl(
> +			mpath_device->disk->part0, mode, cmd, arg);

[Severity: Critical]
Does passing part0 bypass partition-based security restrictions in the
underlying driver?

When an unprivileged user issues an ioctl on a multipath partition, this
code delegates it but passes the whole-disk block device (part0) instead of
the partition's block device.

Underlying drivers, such as NVMe via nvme_ioctl(), rely on
bdev_is_partition() to detect partition-level access and deny unprivileged
passthrough commands. Since part0 is passed, bdev_is_partition() evaluates
to false, tricking the lower driver into skipping containment checks.

Could this allow unprivileged users with access to a multipath partition to
execute passthrough commands on the entire underlying physical device?

[Severity: High]
Can holding the SRCU read lock across the underlying ioctl cause a deadlock?

If the underlying ioctl initiates a path removal, such as a passthrough
command that deletes an NVMe namespace or resets a controller, the teardown
code path will synchronously wait for SRCU readers to exit via
synchronize_srcu().

Since the ioctl thread still holds the SRCU read lock while waiting for the
command or removal to complete, synchronize_srcu() will block forever.

> +out_unlock:
> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	return err;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D9
