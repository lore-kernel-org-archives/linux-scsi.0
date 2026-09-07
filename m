Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E87E48C400
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783927; cv=none; b=lkyp8mEP5n1yqvtsSlrBJFcgr3mqnemIeq89CE1tJVR1kFJddXYDZXP+nLFDlCCRnKIdYalj/SZFqc5f0KgTKMiA18wojxA89V8zUWYf+HCsl0BmJChW5wawyy95Q4Ps9LiXi4m1wVwBxHdGwxat+ljBlRPeuv4sX4BcVDWdNyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783927; c=relaxed/simple;
	bh=nA5kU7bxTtQrOkOIL/3AtRtM4CIeRZcZHwGBsTHfnYg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AFNZnOH7PIeNz/Uwk3CuivQwkEyW3NnI0AI2lYeQNgo0zadSP3/+DVPkBpgGKJbbbusIpyPmTcuQfRCNlX+pgVB/1yTOZWSqTizK5lUcXyM071cfNKZDD/NXvd0t/VUBmoHuFECxfRVahczRj7DVH+5nZ7/1Y4m7HiqoEYfjsjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cyWBLrZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyWBLrZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940BF1F00A3A;
	Mon,  7 Sep 2026 12:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788783925;
	bh=55g2gT85y0Q963YhKAAu4Ug9NeWJFOaNZ3DulYZCY/A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cyWBLrZK/gnLpJ8/nn8tM8XDSi7ZLRT/w6HVY7rvDLJdwfVWu7lC8YcllamA1dvKS
	 6auWBMrmSDEFJun5Q2Pvc7iMhpsjXBdXBMfEJRuJrxcGIOVyqipqMbGITBeoCvnPaQ
	 X3jzOId9JKK2h+npyyflejX8haTu30tWH47HRySGUJOa33qXKifXK08L/kuZDeJHPp
	 ZzTlH+yDWSyQnSskNssz+5XWTx3GVcbE9qFIrL6lSlcOkW3MbfqlkAFoakTQRcjoRb
	 OubznqThCH+z74/th3OFHqFRH8dyERGPl93bZQ4HcJKCoCSciB8FXsOyH1ivaORepa
	 6VI9hrHmaSKmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 24/27] scsi: sd: support multipath disk
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-25-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-25-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 12:25:24 +0000
Message-Id: <20260907122525.940BF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Pending delayed removal work is not cancelled when `sd_mpath_fail_=
probe()` tears down a multipath disk, leading to use-after-free of `mpath_h=
ead`.

Pre-existing issues:
- [Critical] Preexisting double put of `sdkp->disk_dev` when `sd_large_pool=
_create()` or `device_add_disk()` fails.
--

commit 9972be7d4ae335cb741d2858144500af92bf6dc3
Author: John Garry <john.garry@linux.dev>

scsi: sd: support multipath disk

This commit adds support to attach a multipath disk by allocating a hidden
gendisk per path. A global list of multipath disks is kept for matching
SCSI devices, and the multipath gendisk mimics a standard SCSI disk.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 60e071d23ddd0..27230ecc2337e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[ ... ]
> @@ -4048,13 +4151,260 @@ static const struct attribute_group sd_mpath_dis=
k_attr_group =3D {
[ ... ]
> +static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
> +{
> +	struct sd_mpath_disk *sd_mpath_disk =3D sdkp->sd_mpath_disk;
> +	struct scsi_mpath_device *scsi_mpath_dev;
> +	struct mpath_device *mpath_device;
> +	struct scsi_device *sdp =3D sdkp->device;
> +	struct scsi_mpath_head *scsi_mpath_head;
> +	struct mpath_head *mpath_head;
> +	bool remove =3D false;
> +
> +	if (!sd_mpath_disk)
> +		return;
> +
> +	scsi_mpath_dev =3D sdp->scsi_mpath_dev;
> +	mpath_device =3D &scsi_mpath_dev->mpath_device;
> +	scsi_mpath_head =3D sd_mpath_disk->scsi_mpath_head;
> +	mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +	mutex_lock(&sd_mpath_disks_lock);
> +	sd_mpath_disk->disk_count--;
> +	if (!sd_mpath_disk->disk_count) {
> +		list_del_init(&sd_mpath_disk->entry);
> +		remove =3D true;
> +	}
> +	mutex_unlock(&sd_mpath_disks_lock);
> +	mpath_device->disk =3D NULL;
> +
> +	if (remove) {
> +		device_del(&sd_mpath_disk->dev);
> +		mpath_remove_disk(mpath_head);
> +	}
> +	sd_mpath_put_disk(sd_mpath_disk);

[Severity: High]
Can this sequence leave pending delayed removal work uncancelled when teari=
ng
down a multipath disk?

If a multipath disk has its last path removed, it can enter delayed removal
where disk_count drops to 0 and remove_work is scheduled via
mpath_can_remove_head().=20

If a path is then re-probed, disk_count becomes 1. If that probe subsequent=
ly
fails and sd_mpath_fail_probe() is called, the disk_count drops back to 0,
which triggers the device deletion and frees the head.

However, since this path bypasses mpath_can_remove_head(), could the pending
remove_work scheduled earlier go uncancelled, potentially leading to a
use-after-free of mpath_head when the delayed work timer expires?

> +}
[ ... ]
> @@ -4171,6 +4529,7 @@ static int sd_probe(struct scsi_device *sdp)
>  	sd_revalidate_disk(gd);
>  	if (sdp->sector_size > PAGE_SIZE) {
>  		if (sd_large_pool_create()) {
> +			sd_mpath_fail_probe(sdkp);
>  			error =3D -ENOMEM;
>  			device_unregister(&sdkp->disk_dev);
>  			put_disk(gd);

[Severity: Critical]
This is a pre-existing issue, but could this error path result in a
double-free of sdkp->disk_dev?

When sd_large_pool_create() fails, device_unregister() is called on
sdkp->disk_dev, which drops the refcount to 0 and frees sdkp.=20

Immediately following this, put_disk(gd) is called. Because gd->fops is
already set to &sd_fops, dropping the gendisk refcount invokes
scsi_disk_free_disk(), which reads the already freed sdkp and attempts a
second put_device() on sdkp->disk_dev.

>  			goto out;
>  		}
>  	}
> =20
> +	if (sdp->scsi_mpath_dev) {
> +		error =3D sd_mpath_revalidate_head(sdkp);
> +		if (error)
> +			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits=
\n");
> +	}
> +
>  	if (sdp->removable) {
>  		gd->flags |=3D GENHD_FL_REMOVABLE;
>  		gd->events |=3D DISK_EVENT_MEDIA_CHANGE;
> @@ -4192,6 +4557,7 @@ static int sd_probe(struct scsi_device *sdp)
> =20
>  	error =3D device_add_disk(dev, gd, NULL);
>  	if (error) {
> +		sd_mpath_fail_probe(sdkp);
>  		device_unregister(&sdkp->disk_dev);
>  		put_disk(gd);

[Severity: Critical]
This is a pre-existing issue, but might this error path also suffer from the
same double-free of sdkp->disk_dev?

Just like the memory allocation failure path above, if device_add_disk()
fails, device_unregister() frees sdkp, and the subsequent put_disk(gd)
accesses the freed sdkp and performs a second put_device() on
sdkp->disk_dev.

>  		if (sdp->sector_size > PAGE_SIZE)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D24
