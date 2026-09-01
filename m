Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17E847CA73
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260644; cv=none; b=bfWJurWLv0u3UAScAXP+eSyxksm6fTFTP5eVIOJgGCQeV8wJhWyGD1PeasvAKvV2YO8jZBvChAVQzw48jeAgG7wZD6FKIJuMWXkQKuyR3BVbyFc6CXS7KXhigMQ/B2YoeXXmc9CGacJHNuQRBhzLjyYs4WPiK8WPRe+vqbgoM/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260644; c=relaxed/simple;
	bh=ZQJZL0C2DqC5xR+NXqby20D0AfSxSk/mOJV5hXmFjgY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KkzknWbyFMF/L08tlOiomqbtimeXVXn3Oc94qS/sgx+/ZpsEszbViPmyMvEiCgFmxHt+6Xvr/uCCL5fEn3lkuYPqYjv8fnBD77q0vOjCtGqw8rMYn4ZfY+XGXQjBkt6vdtwxu5qpFBtSa0J8zD4ovdNTiYlSczNoCFrnECdj8pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLTTAAYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLTTAAYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390E61F000E9;
	Tue,  1 Sep 2026 11:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260642;
	bh=xoNasD5LwzoiHmPeNzZnpWZyFkNnDtgNYKZv4cxipOA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JLTTAAYDtPJ9pm6Z3IUQexr2BonCXMa86ZRVHe15hjV8FpsnzyiqEQc+3Pev9leBO
	 Sb48GeQ6R422Vgkt4ArC8MNYBJfNXVmt7A+PkQlrxYPLTSfIJAoXRlhsAtP8HgJAXc
	 KjWYWIMVmtTpGXorCVtBeOiq5Ja4n7vqE/1fgFCDJxrUsVdL6onptqmTpuCxpntnDR
	 i0hxsEBjamKLiV+0/Bvf42ms5747HKJH2MrA1oYAYziWMtmMcbwwR0iJvl+sq8j0D9
	 N3x4Q/liUcNnXprzaj/PLO80C/ShsZyq7F5ZXkg3jmZ3jCoFTE6Y9Rf7sp0qtYnkWk
	 d07cOdbZJ15AA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 08/27] libmultipath: Add support for block device
 IOCTL
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-9-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:04:01 +0000
Message-Id: <20260901110402.390E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] AB-BA deadlock in mpath_bdev_ioctl() due to holding SRCU read lock=
 across synchronous underlying ioctl operations.
--

commit 5e662d20d610c2b48599b805387034d536eb95fd
Author: John Garry <john.garry@linux.dev>

libmultipath: Add support for block device IOCTL

This commit adds mpath_bdev_ioctl() as a multipath block device IOCTL
handler. This handler forwards the call into the underlying mpath_device
bdev fops handler.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 58eb9be5bebbe..f1758d1e60a60 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -454,11 +454,53 @@ static void mpath_bdev_release(struct gendisk *disk)
>  	mpath_put_head(mpath_head);
>  }
> =20
> +static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
> +		    unsigned int cmd, unsigned long arg)
> +{

[ ... ]

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
> +out_unlock:
> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);

[Severity: High]
Can this cause an AB-BA deadlock during device removal?

If the underlying ioctl (e.g., a passthrough command via SG_IO) blocks
waiting for I/O completion, and a concurrent device removal is triggered
(e.g., via physical hot-unplug, sysfs deletion, or SCSI error recovery
offline), could we deadlock here?

A device removal path typically calls:
sd_mpath_remove() -> mpath_delete_device() -> synchronize_srcu(&mpath_head-=
>srcu).

That removal thread would block indefinitely waiting for this ioctl thread
to release the SRCU read lock. Because the device removal is stalled, it
cannot proceed to tear down the device and abort the pending I/O, leaving
this ioctl thread permanently stuck waiting for the I/O.

Would it be safer to acquire a reference to the underlying disk (e.g., via
get_disk()) and drop the SRCU lock before invoking the potentially unbounded
ioctl? This appears to be a known structural constraint in block multipathi=
ng,
similar to a fix previously applied in nvme-multipath.

> +	return err;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D8
