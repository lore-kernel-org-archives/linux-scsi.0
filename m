Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA00235028C
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076220; cv=none; b=tEl2GgyISYnEsP6uJ0WjQ9ZVVD1Or52xUIcFhrn8xnbgDP8QkA4vixpMPtrqItS0CqpyuVjQYRITXFYfZ8ez08uqqfITAmbFmQsT4XOzwX2dk5gsKhdfb+v73AM0rKQCIctMSTZD1fq5/KJ8BpzALIp/ThqAWEAMVqdDjtPcaB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076220; c=relaxed/simple;
	bh=x4s0H2qpDoPCoCubYUzapUnROMPT3hIU03HsnHVmPaQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=icT4hSAIAczHL6yLrJaNKcZKihTD6x35xhIaMnIzWZ+bvwsE64XeBdINHuca1jCdgqOinx3oMsttGoj8lCfdlqkBJpOUddU4WswzJV1ZeqLjxfOZ5AJn8UCS2VTFPAZi9AG2af9O84MxIMQNCXxPGUOn3RaYJY+pb29ZRdhZqVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9Edn9yi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9Edn9yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FE71F000E9;
	Fri,  3 Jul 2026 10:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783076219;
	bh=AhRTUDp9WygVIEntgjeGiWyam4zeP8RvbtR/3J/5MhU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c9Edn9yilL07rwG+rh47xB88fKGBA8J78n8eC+PU363SCOvup8g8IlsDjZMm/fj2I
	 KF3uzPD12PLi1fjFY+XZ4pbkj3PHCrHgs7yYqemWBuGyVkS9g03QZRxc/TqWfQYOpB
	 O7RhgO36L/UCF/hnzGk7ZjXmBWIWUkOOxtQjx9xJ4Dlu7aC9QS5850TE7fCqeS29ce
	 iO84jqY00+kWM9NdHTUPLvD6oVTdaVskgw7vN3eQF58eMnxnkIzxRRBKkZaLAHToHT
	 IazEU9YALaDaDYqMhoHJcSHGX5bQLBoHjZyEV2iuJJgldEyvCs+SPcHmk1d+3T5V1m
	 2adHpbwFv5GPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/13] libmultipath: Add support for block device
 IOCTL
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703102918.3723667-12-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-12-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:56:58 +0000
Message-Id: <20260703105659.31FE71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Unconditional dereference of optional `fops->ioctl` leads to NULL =
pointer dereference.
- [High] Bypass of the underlying block device's custom `.compat_ioctl` han=
dler.
--

commit 3f49637890144f68bc3af4119c61a0b330200c0e
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add support for block device IOCTL

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler. Like what is done
for cdev IOCTL handler, use .ioctl_begin and .ioctl_finish methods.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index d335074eb5bcd..4e4b347875500 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -515,6 +515,38 @@ static void mpath_bdev_release(struct gendisk *disk)
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
> +	void *unlocked_ioctl_data =3D NULL;
> +
> +	srcu_idx =3D srcu_read_lock(&mpath_head->srcu);
> +	mpath_device =3D mpath_find_path(mpath_head);
> +	if (!mpath_device) {
> +		err =3D -EWOULDBLOCK;
> +		goto out_unlock;
> +	}
> +
> +	if (mpath_head->mpdt->ioctl_begin)
> +		mpath_head->mpdt->ioctl_begin(mpath_device, cmd,
> +					&unlocked_ioctl_data);
> +	if (unlocked_ioctl_data)
> +		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	err =3D mpath_device->disk->fops->ioctl(
> +			mpath_device->disk->part0, mode, cmd, arg);

[Severity: High]
Does this code dereference the underlying device's ioctl function pointer
without checking if it's NULL?

If the active path's block device does not implement the optional .ioctl me=
thod
in its block_device_operations, won't this cause a NULL pointer dereference
when user-space issues an ioctl on the multipath device node?

> +	if (unlocked_ioctl_data) {
> +		mpath_head->mpdt->ioctl_finish(unlocked_ioctl_data);
> +		return err;
> +	}
> +out_unlock:
> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	return err;
> +}
> +

[ ... ]

> @@ -701,6 +733,8 @@ const struct block_device_operations mpath_ops =3D {
>  	.open		=3D mpath_bdev_open,
>  	.release	=3D mpath_bdev_release,
>  	.submit_bio	=3D mpath_bdev_submit_bio,
> +	.ioctl		=3D mpath_bdev_ioctl,
> +	.compat_ioctl	=3D blkdev_compat_ptr_ioctl,

[Severity: High]
Does using the generic blkdev_compat_ptr_ioctl wrapper here bypass the
underlying block device's custom .compat_ioctl handler?

If a 32-bit user space task invokes a compat ioctl, the core block layer wi=
ll
delegate to this generic wrapper, which routes the call to the native
mpath_bdev_ioctl().

That native handler then unconditionally forwards the call to the underlying
path device's native .ioctl method, entirely skipping the underlying device=
's
.compat_ioctl handler.

Could this lead to 32-bit struct layouts being passed directly into a 64-bit
native .ioctl handler, potentially causing memory corruption or out-of-boun=
ds
reads if the underlying driver requires custom struct repacking?

> +	.report_zones	=3D mpath_bdev_report_zones,
>  	.pr_ops		=3D &mpath_pr_ops,
>  };

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703102918.3723=
667-1-john.g.garry@oracle.com?part=3D11
