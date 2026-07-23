Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45E743E9FB
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803657; cv=none; b=b0PsCpoxo3sgmdVQCEsiYi+14TKZpjGK3PHvtfrMRdYUAKEhq6rR5xBkHUQU1foHZUyKDJ7oWmb15ht9fkzxYewI2OSMfFgmH1uzBKMpAJPo0NL86R7vBbRjeExsi/k/He0oE6hRNRjs5opYTdhXrllovj2rwA2V0Qs1blGRDWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803657; c=relaxed/simple;
	bh=AJzrziz8lCHekJtJZhvfUXhG9q8HjxrlrSMN4fhehUM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ggFmEwl9IM9KcgLEkdYxuiNPoYUbLCYbv9lwaDAjWpk7P9013Bdnet5D9Gj64L7t0FPyqupkJwCBx0xElKOaSB1ykpxIOj0sXiPxIeGK/891KpIH5NFenYjn/CPv+cRMp1/kNNAHt8IMIwcYMC4f1C3b1Te+3XUeMI656+LfKr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WugVy6EY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WugVy6EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A5C1F000E9;
	Thu, 23 Jul 2026 10:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784803655;
	bh=ey2Ox+eKA86EqW5v/sgAH9Gzky5/TkWU+0mZoZyFJ/c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WugVy6EY0rdsQ0b/HDiasqzC0Wz3DA97LMXcVDiPxSuGN2PplhY/4NhZ2Vk4EEvvN
	 XFbvnyLWDCcRpfqwoPHBs1MDQe7BGCVb7oQXIi5IIg8RmvUUte5alQc1qBUd/sfA7C
	 CxcLSiZ+UGJu5R6vL0slJpWC4zOCSpgKgsKwzoiOd2BHQrfjnVbkU7QNMz+JXOEuXm
	 3Di9B/7WcESFXIMW9OAJvVahl7ngbFXLfa5O8E4dC6rTXs+oQ8iTQFusYzgNnSbfQJ
	 ZcZ2XhaBkvl5xLsELjn4Dhz4VV0BBthOjbboIpXBZ0wK1ViAYbunnBbOGZRLtRfkN5
	 b+jmJFb/jRFcA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 25/28] scsi: sd: support multipath disk
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-26-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-26-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:47:34 +0000
Message-Id: <20260723104735.40A5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Unconditional sd_mpath_put_disk() in sd_mpath_remove() destroys th=
e multipath disk structure while delayed removal is pending, causing a use-=
after-free.
- [High] Uncanceled delayed work accesses freed mpath_head after sd_mpath_f=
ail_probe unconditionally deletes the device.
- [High] Concurrent execution of sd_mpath_remove_head and sd_mpath_probe cr=
eates a race condition that incorrectly deletes a newly allocated gendisk.
- [Medium] Missing put_device() in sd_probe() error path for sd_mpath_add_d=
isk() failure leaks sdkp and its parent's reference.
- [Medium] Error paths in sd_mpath_probe() call kfree() on a device object =
after device_initialize(), leaking kobject internals.

Pre-existing issues:
- [High] If sd_large_pool_create() fails, sd_probe() jumps to out_free_inde=
x bypassing device unregistration and freeing active sysfs device memory (s=
dkp).
--

--- Patch [25]: [PATCH v4 25/28] scsi: sd: support multipath disk ---
commit 7776d470d97b7568b27daa7f4e53e7184172c0bc
Author: John Garry <john.garry@linux.dev>

scsi: sd: support multipath disk

This commit adds support to attach a multipath disk. It allocates a
gendisk per path and marks them as hidden while keeping a global list of
sd_mpath_disks for matching scsi_devices.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 36c745cbb2619..d5a37b1b312c3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4035,13 +4139,258 @@ static const struct attribute_group sd_mpath_dis=
k_attr_group =3D {
[ ... ]
> +static int sd_mpath_probe(struct scsi_disk *sdkp)
> +{
[ ... ]
> +	sd_mpath_disk->scsi_mpath_head =3D scsi_mpath_head;
> +	device_initialize(&sd_mpath_disk->dev);
> +	sd_mpath_disk->dev.class =3D &sd_mpath_disk_class;
[ ... ]
> +	error =3D mpath_alloc_head_disk(mpath_head, &lim,
> +				dev_to_node(dma_dev));
> +	if (error)
> +		goto out_free_disk;
[ ... ]
> +out_free_disk:
> +	kfree(sd_mpath_disk);

[Severity: Medium]
Is it safe to call kfree() directly on the device object here?
Since device_initialize() was already called on sd_mpath_disk->dev,
shouldn't we use put_device() to prevent leaking resources allocated by
the kobject core?

[ ... ]
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

[Severity: High]
Does this sequence risk a use-after-free if delayed removal is pending?
If mpath_can_remove_head() returns false, the object remains on the
global list and is not fully removed, but we unconditionally drop the
reference via sd_mpath_put_disk() at the end. This could free the object
while it is still globally accessible.

[ ... ]
> +static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
> +{
[ ... ]
> +	list_del_init(&sd_mpath_disk->entry);
> +	mutex_unlock(&sd_mpath_disks_lock);
> +
> +	device_del(&sd_mpath_disk->dev);
> +	mpath_remove_disk(mpath_head);
> +	sd_mpath_put_disk(sd_mpath_disk);
> +}

[Severity: High]
Could dropping the mutex here race with a concurrent sd_mpath_probe()?
We drop sd_mpath_disks_lock before calling mpath_remove_disk(mpath_head).
If a new probe allocates a new disk and overwrites mpath_head->disk
in that window, mpath_remove_disk() might delete the newly allocated
gendisk instead of the old one being removed.

[ ... ]
> +static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
> +{
[ ... ]
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
> +}

[Severity: High]
What happens if there is pending delayed work on mpath_head->remove_work
when we hit this error path? If a previous removal queued the work,
and a subsequent failed probe triggers this code, we delete and free the
head without canceling the delayed work. Will the workqueue then trigger
a use-after-free on the freed mpath_head?

[ ... ]
> @@ -4158,11 +4515,18 @@ static int sd_probe(struct scsi_device *sdp)
>  	sd_revalidate_disk(gd);
>  	if (sdp->sector_size > PAGE_SIZE) {
>  		if (sd_large_pool_create()) {
> +			sd_mpath_fail_probe(sdkp);
>  			error =3D -ENOMEM;
>  			goto out_free_index;
>  		}
>  	}

[Severity: High]
This is a pre-existing issue, but can this lead to a use-after-free in
sysfs? At this point, device_add() has already succeeded. Bypassing
device_del() or device_unregister() and jumping directly to
out_free_index (which frees sdkp) leaves the device linked in the sysfs
hierarchy.

[ ... ]
> @@ -4184,6 +4549,19 @@ static int sd_probe(struct scsi_device *sdp)
>  		goto out;
>  	}
> =20
> +	if (sdp->scsi_mpath_dev) {
> +		error =3D sd_mpath_add_disk(sdkp);
> +		if (error) {
> +			sd_mpath_fail_probe(sdkp);
> +			device_del(&sdkp->disk_dev);
> +			del_gendisk(sdkp->disk);
> +
> +			put_disk(sdkp->disk);
> +			if (sdp->sector_size > PAGE_SIZE)
> +				sd_large_pool_destroy();
> +			goto out;
> +		}
> +	}

[Severity: Medium]
Are we leaking the scsi_disk structure and its parent reference here?
We call device_del(&sdkp->disk_dev), but we don't call put_device()
to drop the base reference acquired during device_initialize().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D25
