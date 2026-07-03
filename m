Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E39C3BC696
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075697; cv=none; b=EX1GMtuMbxcSCTftSUrwgJikGP6MQAuvA47R4zHhKgo4ccTp2qOnOpnUy2O/EBL3U0zdvlS31d4utmRN0wxetpP2IedmjSVus9Wy2IGyFZHcCjNMXccToo2hKy0JcpPhRZrH1avgfj9mN6orV3iwaDYwOy7/jNDn6mSV0GW6FBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075697; c=relaxed/simple;
	bh=UM797vPYw084XECOkbiiQ3oLyQyBPHPK7zNnIDIQInk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lYjx7xvZghaQVG1bVjt+4rsYTKlIwQgI0vxyd7hHbLQ2dqKMAEmZTyNxmTSA+zAs9zKlMRvCaU/XJfhNkOSkcx0wA2cMvf1TyyROD//mFXqs/V+hJy9jkywi15RZUS+tFAx0gt/gI8R/139/+F0vHs4NWLbDSxxKxKe7IzRaMkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUuSCxPJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUuSCxPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E011F000E9;
	Fri,  3 Jul 2026 10:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075695;
	bh=xJ7pc0X4mfN0WpHWBXCzeis+Vpt7Cy51L7dmzj9tNZ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hUuSCxPJpAN2GVbAntK+sNzkWQY7KGb812AWX7ACHz8XpJoSNJwgy3T8M3N6sVH5R
	 OIrK5RiF5BfEDjpT6T7jm/mpBRxE5nPolujaMi/9lv4hT8HW2lcQ1Y+QJ8G6KltVh1
	 UpLtqWXTVOQKC+ZSmES3qSvBgvl6MhXNDvj465P+jrV3GYo3AenG0hnM6Zd+Z+Ux0P
	 wD7flhLQ7DHkCs01oHk3CIz7MkPrxHjoYLEgqVO6nGDQ8HBhS2gLwzHxS7tyU9Lx92
	 TbRRauuwa1TVu2PKPi5aun/gz16FJh+XVylUtHQbSE1j3zomtN3E/VoNMKMUnf/jEU
	 qJPiiilGRyFZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/13] libmultipath: Add PR support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703102918.3723667-10-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-10-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:48:14 +0000
Message-Id: <20260703104815.96E011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Calling Persistent Reservation (PR) operations on a multipath =
partition causes a NULL pointer dereference.
--

commit ed0ad48ae1e1adac4c8ee8809fa3bba6ef9f4ac5
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add PR support

Add support for persistent reservations.

Effectively all that is done here is that a multipath version of pr_ops is
created which calls into the bdev fops callback for the mpath_device
selected.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 4945f2d847fbf..cec7047ce7b9b 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -491,11 +491,193 @@ static void mpath_bdev_release(struct gendisk *dis=
k)
>  	mpath_put_head(mpath_head);
>  }
> =20
> +static int mpath_pr_register(struct block_device *bdev, u64 old_key,
> +			u64 new_key, unsigned int flags)
> +{
> +	struct mpath_head *mpath_head =3D dev_get_drvdata(&bdev->bd_device);
> +	struct mpath_device *mpath_device;
> +	int srcu_idx, ret =3D -EWOULDBLOCK;
> +
> +	srcu_idx =3D srcu_read_lock(&mpath_head->srcu);

[Severity: Critical]
Will this cause a NULL pointer dereference if the persistent reservation
operation is called on a partition?

If the target_core_iblock backend is configured for PR passthrough on a
partition of a multipath device, bdev will be the partition's block_device.
Because dev_set_drvdata() is only called for the base disk's device,
dev_get_drvdata(&bdev->bd_device) will return NULL for partition devices.

Other functions in this file, like mpath_bdev_ioctl(), seem to handle this =
by
resolving the disk first using mpath_gendisk_to_head(bdev->bd_disk). Should
the PR callbacks do the same?

[ ... ]

> +static int mpath_pr_reserve(struct block_device *bdev, u64 key,
> +		enum pr_type type, unsigned flags)
> +{
> +	struct mpath_head *mpath_head =3D dev_get_drvdata(&bdev->bd_device);
> +	struct mpath_device *mpath_device;
> +	int srcu_idx, ret =3D -EWOULDBLOCK;
> +
> +	srcu_idx =3D srcu_read_lock(&mpath_head->srcu);

[Severity: Critical]
The same NULL pointer dereference risk applies here for partition devices, =
as
well as to mpath_pr_release(), mpath_pr_preempt(), mpath_pr_clear(),
mpath_pr_read_keys(), and mpath_pr_read_reservation() introduced below.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703102918.3723=
667-1-john.g.garry@oracle.com?part=3D9
