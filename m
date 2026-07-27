Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41109369225
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165635; cv=none; b=Lu/2tUTqVlyKdA1LCsEr2FpL7ig9zqyMuOBj3vjNHiTxIn4sbkiR5WYgSK0MjASTceQHjKF435qMxqJAB61qSwjNXQNVcNk3duWuoZDV47tH35fuhQXvsiHOLDWZvRUQBfFaq6e6C4GIAy7sfH2AHMKc7TRW+t81NrB39Th6E+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165635; c=relaxed/simple;
	bh=anbMWrTf+w7NmfmpVDoIuYD04vJ/HQwEJVoIQPY7wnM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qmh2El+04vBF9IkazUlSfxmrXxTwou3/KvHs4+9dUDPqz8UQEVoHjKqoMXNPhN7Gv8s19gtF7ZzXup6bSB49WA2Z3weW2ZDp1jzUFbQ7Z9+gxCUUj0DsozobvqOiiK2DCzA1eer7t47k27lruoZs9Z7FbCls8XTdvWIRzklLwa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m69wmiBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m69wmiBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E5B1F000E9;
	Mon, 27 Jul 2026 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165633;
	bh=boKoZz5mXVZjZ9fO+7C36f0bRYub4ywai7gRI0OfG48=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m69wmiBnvMgtTFx6IfuXdiqbmf4yoAfQUN39rUwgyrDj1M4FzNPl4kUiZ/pn3sMBo
	 HDfY67oFYhgTLog3UTTk8gY2uylJgGdWS3mtRz1ne+Ad5+ZNgTYVwSs61Zv8e7DKDk
	 7owirQgh0US1vUqBtyFsNgW6glvOoeJNF7zbEUiOm96oe1QyNiw8gIVhtgEK7g0xWD
	 YnJsCFkGbIruMO9fCB29+YYAcCgOAJGr4HM5YP0Lz4QaoBkKDeyjvVN52N0R3pr4DK
	 NPH8GjpMHMfuYpmggyMiLhU9ltEzguOeyPibQgQwuu8jMOEOpNDMUxRIdoKlGJuEuf
	 Mv4jJy+UxQHZw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 24/27] scsi: sd: support multipath disk
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-25-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-25-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:20:33 +0000
Message-Id: <20260727152033.A7E5B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Concurrent path removal and addition causes a TOCTOU race that ove=
rwrites and frees the shared `mpath_head->disk`.
- [High] Uncancelled `remove_work` triggers a Use-After-Free if a re-attach=
ed multipath disk fails probing.
- [Medium] Missing `put_device()` on the `sd_mpath_add_disk()` error path p=
ermanently leaks `struct scsi_disk`.

Pre-existing issues:
- [High] Direct `kfree(sdkp)` in the `sd_large_pool_create()` error path ca=
uses a use-after-free because the device is already registered in sysfs.
--

--- Patch [24]: [PATCH v5 24/27] scsi: sd: support multipath disk ---
commit 6b75fe218921318a27f170eca853c70058afe60d
Author: John Garry <john.garry@linux.dev>
Subject: scsi: sd: support multipath disk

Add support to attach a multipath disk.

We still allocate the gendisk per path, and this is required for the
per-path submission. However, those gendisks are marked as hidden. Those
disks are named sdX:Y, where X is the multipath disk index and Y is the
per-path index.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 36c745cbb2619..f044b2dfaa9fd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c

[ ... ]

> @@ -4035,13 +4138,259 @@ static const struct attribute_group sd_mpath_dis=
k_attr_group =3D {
> +static int sd_mpath_probe(struct scsi_disk *sdkp)
> +{
[ ... ]
> +	mpath_head->parent =3D &sd_mpath_disk->dev;
> +	mpath_head->drv_module =3D THIS_MODULE;
> +	mpath_head->disk_groups =3D sd_mpath_disk_attr_groups;
> +	error =3D mpath_alloc_head_disk(mpath_head, &lim,
> +				dev_to_node(dma_dev));
> +	if (error)
> +		goto out_free_disk;
> +	disk =3D mpath_head->disk;

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

[Severity: High]
Does this create a TOCTOU race that overwrites and frees the shared
mpath_head->disk?

If sd_mpath_remove() and sd_mpath_probe() run concurrently for the same
scsi_mpath_head (e.g., during hotplug/hot-unplug events):

The removal path drops the sd_mpath_disks_lock before tearing down
mpath_head->disk here. A concurrent probe can then allocate and assign a new
disk to mpath_head->disk in sd_mpath_probe().

When the removal thread resumes, it deletes and frees the new disk while the
probe thread proceeds to use it, causing a use-after-free.

> +	}
> +	sd_mpath_put_disk(sd_mpath_disk);
> +}

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

[Severity: High]
Can an uncancelled remove_work trigger a use-after-free here if a re-attach=
ed
multipath disk fails probing?

A delayed removal is scheduled when the last path is removed. A new path is
then rapidly probed, incrementing the disk count, but fails midway through
sd_probe().

This cleanup function decrements the count back to 0 and frees sd_mpath_disk
and scsi_mpath_head, but it does NOT cancel the pending remove_work (which
would normally be cancelled later in sd_mpath_add_disk()). The scheduled wo=
rk
will subsequently execute on freed memory.

> +}

[ ... ]

> @@ -4158,11 +4515,18 @@ static int sd_probe(struct scsi_device *sdp)
>  	sd_revalidate_disk(gd);
>  	if (sdp->sector_size > PAGE_SIZE) {
>  		if (sd_large_pool_create()) {
> +			sd_mpath_fail_probe(sdkp);
>  			error =3D -ENOMEM;
>  			goto out_free_index;

[Severity: High]
This isn't a bug introduced by this patch, but does the direct kfree(sdkp) =
in
the sd_large_pool_create() error path cause a use-after-free because the
device is already registered in sysfs?

After device_add(&sdkp->disk_dev) succeeds earlier in sd_probe(), the device
is exposed to sysfs. If sd_large_pool_create() fails, the code branches to
out_free_index which directly calls kfree(sdkp) without unregistering the
sysfs device, leaving dangling pointers in the sysfs tree.

>  		}
>  	}

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

[Severity: Medium]
Will this error path leak the struct scsi_disk?

A failure in sd_mpath_add_disk() triggers the error handling path which cal=
ls
device_del() but misses the corresponding put_device().

Because the kobject reference is never dropped, scsi_disk_release() is never
invoked, permanently leaking the memory.

> +		}
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D24
