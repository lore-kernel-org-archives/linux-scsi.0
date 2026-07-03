Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8483093CF
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783081448; cv=none; b=XwMs3PYaA/g8M1n1frcQdgZvvUebbu8jITviO551Z3n0eRySUpGQH9A1ruR+0ugo3drFmAGqashf8J0O+j+khXbnjjxJvkCzAp+Thb6hpGirJEhj697m4s6nDn2wW6BKbBDphU6Lm8YiLP70XDI4tll89HCTcyOLYl5Ued0dBzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783081448; c=relaxed/simple;
	bh=9mXbDvaUJfQyHBAMr5qgRf1CzWU2IPA5MEm0HMTL2WM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BIbLPyrD6N1spVbeSQUOSSnAEP2ov2cXYbeTyzYBbEMf1C+CZR1qW9Z7znmjdX23kniTD5Uyjwkh6VKk0ka+fQ54ZGjJ0NUN0nf4wBHo6OpMYSXU+Kwa0WKFugciDYMNNPeIIkiJEqwky4tSG/HTE5WWTqVg4Zki29ULepcXX0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V1CswsWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1CswsWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E0E1F000E9;
	Fri,  3 Jul 2026 12:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783081446;
	bh=C4PyroWng8zUA9d5jlZvb/31b6VSvCDNrt43oa4LWxE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V1CswsWDgR/xgWFYW9zUYc7hVtdPur57Se2umMFoYdSCNECbfAViQFcP59nwc6mYd
	 N/uUZpYaKqxHSf4IqCkURpHUygCXywZP7M83ZUzw7hp+rbJownWnf5L2+CWyDf2hML
	 7J/xn7UvCKvcEYrtpfNiWtAvGi+mPPggHEuvYQ0sO4VcaRg4jfT1uLN/hEZmeq6G1V
	 1FP0ZKv7mhGEigPI6z6lqJT+DqlW64cORl9e+icO6eiLu51xmDVWBQdvYZ0lCGnptW
	 C7pAuvh2kqBzhlL7V8wQi1y+C9wcsQYngtALgzA3GDekgnu6e0IfnWJMylG1jTKwWQ
	 R9Zc+HRGuV9GQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/17] scsi: sd: support multipath disk
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-14-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-14-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 12:24:06 +0000
Message-Id: <20260703122406.84E0E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] The local variable `index` is left uninitialized when probing a mu=
ltipath disk in `sd_probe()`, which can lead to IDA corruption if an error =
occurs.
- [High] Error paths in `sd_mpath_probe()` call `kfree()` on a device objec=
t after `device_initialize()` has been called, leaking kobject resources an=
d violating the driver core API.
- [High] Concurrent execution of `sd_mpath_remove_head()` and path removal =
(`sd_mpath_remove()` or `sd_mpath_fail_probe()`) causes `device_del()` and =
`mpath_remove_disk()` to be called twice on the same device.
- [High] A time-of-check to time-of-use (TOCTOU) race condition exists betw=
een `sd_probe()` and `sd_mpath_remove_head()`, leading to a Use-After-Free =
on the multipath gendisk.
- [Medium] The `sd_mpath_disk` reference is permanently leaked when `sd_lar=
ge_pool_create()` fails for a multipath disk.

Pre-existing issues:
- [High] In `sd_probe()`, failing `sd_large_pool_create()` jumps to `out_fr=
ee_index` which frees the `scsi_disk` object without unregistering its devi=
ce from sysfs.
--

commit 1b5b9df2120152290853f43f41a0b4fe936be00b
Author: John Garry <john.g.garry@oracle.com>

scsi: sd: support multipath disk

Add support to attach a multipath disk. A global list of sd_mpath_disks
is kept for matching scsi_device's, and gendisks are allocated per-path
and marked as hidden.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4006,6 +4025,321 @@ static int sd_format_disk_name(char *prefix, int =
index, char *buf, int buflen)

[ ... ]

> +static int sd_mpath_probe(struct scsi_disk *sdkp)
> +{

[ ... ]

> +	sd_mpath_disk->scsi_mpath_head =3D scsi_mpath_head;
> +	device_initialize(&sd_mpath_disk->dev);
> +	sd_mpath_disk->dev.class =3D &sd_mpath_disk_class;
> +
> +	blk_set_stacking_limits(&lim);
> +	lim.dma_alignment =3D 3;
> +	lim.features |=3D BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
> +		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
> +
> +	mpath_head->parent =3D &sd_mpath_disk->dev;
> +	mpath_head->drv_module =3D THIS_MODULE;
> +	error =3D mpath_alloc_head_disk(mpath_head, &lim,
> +				dev_to_node(dma_dev));
> +	if (error)
> +		goto out_free_disk;

[ ... ]

> +out_free_disk:
> +	kfree(sd_mpath_disk);

[Severity: High]
Does this error path leak kobject resources?

Since device_initialize() has already been called on sd_mpath_disk->dev in
sd_mpath_probe(), shouldn't we use put_device() here instead of directly
calling kfree()?=20

It looks like sd_mpath_disk_release() currently assumes full initialization
(like unconditionally freeing disk_index), so a simple swap to put_device()
might also require updating the release function to handle partial
initialization safely.

> +out_unlock:
> +	mutex_unlock(&sd_mpath_disks_lock);
> +	return error;
> +}
> +
> +static void sd_mpath_remove(struct scsi_disk *sdkp)
> +{

[ ... ]

> +	mutex_lock(&sd_mpath_disks_lock);
> +	sd_mpath_disk->disk_count--;
> +	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
> +		list_del_init(&sd_mpath_disk->entry);
> +		remove =3D true;
> +	}
> +	mutex_unlock(&sd_mpath_disks_lock);
> +	mpath_remove_sysfs_link(mpath_device);
> +	mpath_device->disk =3D NULL;
> +
> +	if (remove) {
> +		device_del(&sd_mpath_disk->dev);
> +		mpath_remove_disk(mpath_head);
> +	}
> +	sd_mpath_put_disk(sd_mpath_disk);
> +}
> +
> +static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
> +{
> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +	struct sd_mpath_disk *sd_mpath_disk;
> +	struct device *dev =3D &scsi_mpath_head->dev;
> +
> +	mutex_lock(&sd_mpath_disks_lock);
> +	sd_mpath_disk =3D sd_mpath_find_disk(scsi_mpath_head);
> +	if (!sd_mpath_disk) {
> +		dev_warn(dev, "could not find mpath disk\n");
> +		mutex_unlock(&sd_mpath_disks_lock);
> +		return;
> +	}
> +
> +	list_del_init(&sd_mpath_disk->entry);
> +	mutex_unlock(&sd_mpath_disks_lock);
> +
> +	device_del(&sd_mpath_disk->dev);
> +	mpath_remove_disk(mpath_head);

[Severity: High]
Can this lead to a double-free or sysfs splat if sd_mpath_remove() and
sd_mpath_remove_head() run concurrently?

If disk_count drops to 0 inside sd_mpath_remove(), it sets remove =3D true,
drops the lock, and unconditionally calls device_del() and
mpath_remove_disk().

Concurrently, sd_mpath_remove_head() could acquire the lock, remove the ent=
ry,
drop the lock, and also unconditionally call device_del() and
mpath_remove_disk() on the same device without mutual exclusion.

[ ... ]

> @@ -4058,22 +4392,33 @@ static int sd_probe(struct scsi_device *sdp)
>  					 &sd_bio_compl_lkclass);
>  	if (!gd)
>  		goto out_free;
> +	sdkp->disk =3D gd;
> +	sdkp->device =3D sdp;
> =20
> -	index =3D ida_alloc(&sd_index_ida, GFP_KERNEL);
> -	if (index < 0) {
> -		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
> -		goto out_put;
> -	}
> +	if (sdp->scsi_mpath_dev) {
> +		error =3D sd_mpath_probe(sdkp);
> +		if (error)
> +			goto out_put;
> +	} else {
> +		index =3D ida_alloc(&sd_index_ida, GFP_KERNEL);

[Severity: High]
Does this leave the local variable index uninitialized when probing a
multipath disk?

If sdp->scsi_mpath_dev is true, index is bypassed and not initialized. If a
subsequent initialization step fails (like sd_large_pool_create()), the err=
or
path jumps to out_free_index:

out_free_index:
    if (index >=3D 0)
        ida_free(&sd_index_ida, index);

Could this evaluate uninitialized stack garbage and corrupt the global
sd_index_ida allocator?

[Severity: Medium]
In this same scenario, if sd_large_pool_create() fails, we jump straight to
out_free_index. Doesn't this skip calling sd_mpath_fail_probe(sdkp) to clean
up the successfully allocated sd_mpath_disk?

This appears to permanently leak the sd_mpath_disk reference while freeing
the underlying scsi_disk object.

[Severity: High]
This is a pre-existing issue, but if sd_large_pool_create() fails and jumps
to out_free_index, wouldn't we free the scsi_disk (via out_free: kfree(sdkp=
))
while its embedded disk_dev is still actively linked into sysfs?

Earlier in the function, device_add(&sdkp->disk_dev) successfully registers
it, but this error path never calls device_del() or device_unregister(),
which leaves dangling pointers in driver core lists.

[ ... ]

> @@ -4127,6 +4469,12 @@ static int sd_probe(struct scsi_device *sdp)
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

[Severity: High]
Is there a race condition between sd_probe() and a concurrent head removal?

Between the successful setup in sd_mpath_probe() and this call to
sd_mpath_revalidate_head(), an external event could trigger
sd_mpath_remove_head(). This would invoke mpath_remove_disk(mpath_head)
to delete and free the multipath gendisk.

If sd_probe() continues without locks and calls sd_mpath_revalidate_head(),
it dereferences mpath_head->disk and blindly calls
blk_mq_freeze_queue(disk->queue) inside sd_mpath_revalidate_head(), which
appears to be a use-after-free on the disk and its request queue.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D13
