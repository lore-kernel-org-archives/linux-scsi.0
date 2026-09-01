Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD54230ACFB
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788261546; cv=none; b=rDOLqaZq06XoOoJNjeyV2ebZaXz6MGBSqNXCizjEm4D0bK0eydZuDS3cI4Z27r8ivJd2RVGMYXsDU0AePU0ASML3mA+kTVVkTjVjq2vjz33cYGC4eKwmQRHDgohwgqf69wF8S4RdK/MZKGVn9jzYAOO2Z/x635ObIziJkloq/pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788261546; c=relaxed/simple;
	bh=pNqCHaqxwYfdyaZnO/iauZLhkCeS5I4eeaBefHYRojo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Sd/Ok8qZHJeoo/ga+DUZ1mYoGXj/sjMP2SSqQI0VWsa/4sD/jiaAE28OklAVjnh64jSqj2V+82gGLgLSt9NPh4sj17wP7J+h1Dr+QyvKEuGYZexTtnZdzS9xkdloG2UOUvLC+ZEHj+TKsf/Po75JTQNQHp3uebo4weW39jpzByk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=om5h0GDN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="om5h0GDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288951F000E9;
	Tue,  1 Sep 2026 11:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788261544;
	bh=grAzq6Yd5R6BFhY6eBD8vDxMhUQgF6wX1sIcFsq4UIY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=om5h0GDNo8+cEsiyhArLo+4GTiIByVk3i8EB2gdktaiZli0tZpQFu4LI+ZG3FO+8P
	 RKWWaVG7RyUBqPtlCL9ogl0hO74ynaRPZMGB7Q+oZgT9efZGKjJ6BCcUGVH+xzkv8x
	 Iu6JsDjAlJV6QAxjTjKisITdXbHTZVi4Z4OEKL+IMU1+WzGXPCouBjzoi0Nv4PJiq4
	 bOjjolWL5aYsQdi9jFAua8e3iVq7t7ulQA0tRxT6+HSfOedpJ9K+eFugKrFw/XfWYM
	 hr/wjrmRFPODFGKKULRJNiY8eWiW3YmaG9rgvRY6BbVrOubVtzedkWK5bhaqPN5o02
	 mVFyNEMCscrIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 24/27] scsi: sd: support multipath disk
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-25-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-25-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:19:03 +0000
Message-Id: <20260901111904.288951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Unprotected overwrite of mpath_head->parent before validation caus=
es Use-After-Free during concurrent I/O when probe fails.
- [High] Queue limits are explicitly overwritten before stacking, breaking =
multipath limits aggregation.
- [Medium] Circular reference between sd_mpath_disk and its child multipath=
 gendisk prevents both structures from ever being freed.
- [Medium] Missing put_device() in sd_probe() error path leaks the scsi_dis=
k structure and device references.
- [Medium] TOCTOU race in disk removal paths allows a concurrent probe to f=
ail with a duplicate sysfs name error.
--

commit 7a8d9795d762973e091f3a0357c1112c3afc4c60
Author: John Garry <john.garry@linux.dev>
Subject: scsi: sd: support multipath disk

Add support to attach a multipath disk, allocating gendisks per path but
marking them as hidden, and maintaining a global list of multipath disks
for scsi_device matching.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 60e071d23ddd0..28304a497d8c6 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[ ... ]
> @@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
>  static atomic_t sd_large_page_pool_users =3D ATOMIC_INIT(0);
>  static struct lock_class_key sd_bio_compl_lkclass;
>  #ifdef CONFIG_SCSI_MULTIPATH
> +static LIST_HEAD(sd_mpath_disks_list);
> +static DEFINE_MUTEX(sd_mpath_disks_lock);
> +
>  struct sd_mpath_disk {
> +	struct device			dev;
> +	int				disk_index;
> +	int				disk_count;
> +	struct list_head		entry;
>  	struct scsi_mpath_head		*scsi_mpath_head;
>  };
> =20
>  static void sd_mpath_disk_release(struct device *dev)
>  {
> +	struct sd_mpath_disk *sd_mpath_disk =3D
> +		container_of(dev, struct sd_mpath_disk, dev);
> +	struct scsi_mpath_head *scsi_mpath_head =3D
> +		sd_mpath_disk->scsi_mpath_head;
> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +	mpath_put_disk(mpath_head);

[Severity: Medium]
In sd_mpath_probe(), the child multipath gendisk takes a reference on this
device via mpath_head->parent =3D &sd_mpath_disk->dev. Since the child holds
a strong reference to the parent, the parent's refcount cannot reach zero
while the child exists.

Does dropping the child reference here in the parent's release function cre=
ate
an unbreakable circular dependency that leaks both structures during remova=
l?

> +	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
> +	scsi_mpath_put_head(scsi_mpath_head);
> +
> +	kfree(sd_mpath_disk);
>  }
[ ... ]
> @@ -4019,6 +4038,90 @@ static int sd_format_disk_name(char *prefix, int i=
ndex, char *buf, int buflen)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_SCSI_MULTIPATH
> +static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
> +{
> +	struct sd_mpath_disk *sd_mpath_disk =3D sdkp->sd_mpath_disk;
> +	struct scsi_mpath_head *scsi_mpath_head =3D sd_mpath_disk->scsi_mpath_h=
ead;
> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +	struct gendisk *disk =3D mpath_head->disk;
> +	struct queue_limits *sdkp_lim =3D &sdkp->disk->queue->limits;
> +	struct queue_limits lim;
> +	unsigned int memflags;
> +	int ret;
> +
> +	lim =3D queue_limits_start_update(disk->queue);
> +	memflags =3D blk_mq_freeze_queue(disk->queue);
> +
> +	lim.logical_block_size =3D sdkp_lim->logical_block_size;
> +	lim.physical_block_size =3D sdkp_lim->physical_block_size;
> +	lim.io_min =3D sdkp_lim->io_min;
> +	lim.io_opt =3D sdkp_lim->io_opt;
> +
> +	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
> +					disk->disk_name);

[Severity: High]
Does overwriting the multipath limits with sdkp_lim before calling
queue_limits_stack_bdev() erase the previously stacked limits?

If an older path required stricter limits (e.g. larger block size or
alignment), would this downgrade the multipath limits to match only the new=
ly
probed path, potentially causing I/O errors on the older paths?

> +
> +	/* TODO: setup integrity and zoned limits */
[ ... ]
> +static int sd_mpath_probe(struct scsi_disk *sdkp)
> +{
[ ... ]
> +	sd_mpath_disk =3D kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
> +	if (!sd_mpath_disk) {
> +		error =3D -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	sd_mpath_disk->scsi_mpath_head =3D scsi_mpath_head;
> +
> +	blk_set_stacking_limits(&lim);
> +	lim.dma_alignment =3D 3;
> +	lim.features |=3D BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
> +		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
> +
> +	mpath_head->parent =3D &sd_mpath_disk->dev;
> +	mpath_head->drv_module =3D THIS_MODULE;
> +	mpath_head->disk_groups =3D sd_mpath_disk_attr_groups;
> +	error =3D mpath_alloc_head_disk(mpath_head, &lim,
> +				dev_to_node(dma_dev));
> +	if (error)
> +		goto out_free_disk;

[Severity: High]
If mpath_alloc_head_disk() fails here, the error path jumps to out_free_disk
and calls kfree(sd_mpath_disk). However, mpath_head->parent was
unconditionally set to &sd_mpath_disk->dev just before the call.

If the multipath disk is still active from a prior failed removal, will it
dereference the freed parent pointer during subsequent I/O or workqueue
processing?

> +	disk =3D mpath_head->disk;
[ ... ]
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
> +	if (sd_mpath_disk->disk_count) {
> +		dev_dbg(dev, "non-zero multipath disk count in removal\n");
> +		sd_mpath_put_disk(sd_mpath_disk);
> +		mutex_unlock(&sd_mpath_disks_lock);
> +		return;
> +	}
> +
> +	list_del_init(&sd_mpath_disk->entry);
> +	mutex_unlock(&sd_mpath_disks_lock);
> +
> +	device_del(&sd_mpath_disk->dev);

[Severity: Medium]
Could a time-of-check to time-of-use race happen here during device removal?
The disk is removed from sd_mpath_disks_list inside the lock, but device_de=
l()
is called after dropping the lock.

Would a concurrent sd_mpath_probe() acquire the lock, fail to find the disk,
allocate a new one with the same index, and call device_add() before this
device_del() completes, causing a sysfs naming collision and -EEXIST failur=
e?

> +	mpath_remove_disk(mpath_head);
> +	sd_mpath_put_disk(sd_mpath_disk);
> +}
[ ... ]
> @@ -4192,6 +4556,7 @@ static int sd_probe(struct scsi_device *sdp)
> =20
>  	error =3D device_add_disk(dev, gd, NULL);
>  	if (error) {
> +		sd_mpath_fail_probe(sdkp);
>  		device_unregister(&sdkp->disk_dev);
>  		put_disk(gd);
>  		if (sdp->sector_size > PAGE_SIZE)
> @@ -4199,6 +4564,19 @@ static int sd_probe(struct scsi_device *sdp)
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
Does this error path leak the scsi_disk structure and its device reference?

device_del() removes the device from the system, but since sdkp->disk_dev w=
as
initialized with device_initialize() (giving it a refcount of 1), shouldn't
there be a matching put_device(&sdkp->disk_dev) to drop the base reference =
and
eventually call scsi_disk_release()?

> +		}
> +	}
>  	if (sdkp->security) {
>  		sdkp->opal_dev =3D init_opal_dev(sdkp, &sd_sec_submit);
>  		if (sdkp->opal_dev)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D24
