Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A901455185
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 13:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791291628; cv=none; b=M3B/OUNHvGAjLUXtsUuc7eT9f4PaC4EQ/6WvFvBCaq/3K7o1c5i6zu8t+x3ARpy5lU5Y671KMYPF7IlkwdloPyYhmSv8nO/sy+Y/XcuOTIMBMrt/OsJjewIcsz7SCHCFwfTFsHRNtS8vIku2iBoCLmCp4hVW9Mt9uz+F3CYoTXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791291628; c=relaxed/simple;
	bh=SOMfz5iexYhUptOtI3o/L/Lr+ZcmGdkrdMhDrltBgbE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qc6Ri/4snMu0Kw4GW3aSjTUJ5hJa684OBbn2AnuVBIEScdhhwdgtFGcjE6NrATyTw8Gmu+2H59NcUgMtV/2fN6QcU7xUwLq/k7KBk0Y0Uw9qygA7z2YBU5vuPckE2UdP5HvjTnKQmUctshbbwsFjebih1cy7H6ES3L9s8cCVt4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkEDEAd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkEDEAd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F711F00893;
	Tue,  6 Oct 2026 13:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791291627;
	bh=zencFiasbxZu4pBT6h+UEJiQy5jkDIaIqPx2ZF6/8No=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dkEDEAd+SWW6R8KLTnzdsf7l+C2MDZzWEIkSDxVNMi+P4sWNDZ9WsWCByNF/Mi05K
	 Xos6rTH3NN0AiRm5bBU0kTNdq6lor8Di5FrFyzGAGkBNIu/kHihGbjHCue/zf2hDKL
	 zKW/DfnRZzdUbYaEoZ7l7rbzx9MSLy2aExU1Jd/AZ92CwPXiS7gqjb0bTaCUXG+Nd8
	 2gFtr0GdgXj/chpfxvf9PiyJ8MGuFOdQv0PqadXcHcEw2jFg9h90G2pCCbb+aA+xol
	 WsMpqwJ0la86Puc1yHJZNx4T3Iv5dB5yYKsQCfngArBU6TBCAXFa3eCCP74mTaQUu6
	 sZ5B++x9yRWHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/7] block: introduce storage element management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261006124510.882017-3-dlemoal@kernel.org>
References: <20261006124510.882017-1-dlemoal@kernel.org>
 <20261006124510.882017-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 13:00:26 +0000
Message-Id: <20261006130027.06F711F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] block: memory allocation deadlock in disk_wait_for_se_mgmt_complet=
ion()
- [High] block: NULL pointer dereference on missing se_ops callbacks
- [High] block: ignored asynchronous hardware error statuses in disk_wait_f=
or_se_mgmt_completion()
- [High] block: unkillable task hang due to unbounded hardware polling loop
- [High] block: TOCTOU data race from unfrozen queue during blk_revalidate_=
disk_zones()
- [Low] block: UAPI copy-paste error in blk_storage_element_type docstring
--

commit eb5c21d5182da32571bd17948ff3d25e0ac2e46c
Author: Damien Le Moal <dlemoal@kernel.org>

block: introduce storage element management

Recent SCSI (SBC) and ATA (ACS) standards define the storage element
depopulation feature, which allows keeping disks with defective heads
longer in production by removing them. This introduces generic operations
and functions to block device drivers for managing storage elements.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 131c9f50b3da5..be57644ee2663 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c

[ ... ]

> @@ -2718,5 +2719,162 @@ int queue_zone_wplugs_show(void *data, struct seq=
_file *m)
> =20
>  	return 0;
>  }
> -
>  #endif
> +
> +static int disk_wait_for_se_mgmt_completion(struct gendisk *disk)
> +{
> +	struct blk_storage_element *elements, *e;
> +	unsigned int i, nr_se, nr_elements =3D 0;
> +	int ret;
> +
> +	ret =3D disk->fops->se_ops->report_elements(disk, NULL, &nr_elements);

[Severity: High]
Should there be a NULL check for the specific se_ops function pointers
(report_elements, remove_element, and restore_elements) before invoking them
to prevent a kernel panic?

The commit message notes that some operations like repopulating defective
elements are generally not allowed by devices, which suggests drivers might
legitimately leave restore_elements or other operations as NULL.

> +	if (ret) {
> +		pr_err("Failed to get number of storage elements\n");
> +		return ret;
> +	}
> +
> +	elements =3D kzalloc_objs(struct blk_storage_element, nr_elements);

[Severity: High]
Should this allocation be protected by memalloc_noio_save()?

This function is called by storage element management APIs like
bdev_remove_storage_element() where I/O might be paused or frozen. An
allocation using the default GFP_KERNEL could enter direct reclaim.=20

If the reclaim attempts to write back dirty pages to the frozen filesystem,
could this cause an indefinite block and deadlock?

> +	if (!elements)
> +		return -ENOMEM;
> +
> +	while (1) {

[Severity: High]
Does this unbounded loop risk an unkillable task hang?

If a device malfunctions, firmware stalls, or the completion event drops, t=
he
task will block indefinitely in the D state because msleep() below uses
TASK_UNINTERRUPTIBLE.

There are no bounds, timeout limits, or checks for fatal_signal_pending().

> +		/*
> +		 * Check if we have storage elements being removed or restored.
> +		 */
> +		nr_se =3D nr_elements;
> +		ret =3D disk->fops->se_ops->report_elements(disk, elements,
> +							  &nr_se);
> +		if (ret) {
> +			pr_err("Failed to get storage elements\n");
> +			break;
> +		}
> +
> +		e =3D elements;
> +		for (i =3D 0; i < nr_se; i++, e++) {
> +			if (e->status =3D=3D BLK_SE_STS_REMOVE_IN_PROGRESS ||
> +			    e->status =3D=3D BLK_SE_STS_RESTORE_IN_PROGRESS)
> +				break;
> +		}
> +		if (i >=3D nr_se)
> +			break;

[Severity: High]
This polling loop treats ERROR states like BLK_SE_STS_REMOVE_ERROR and
BLK_SE_STS_RESTORE_ERROR as not in progress, causing the loop to break
normally and falsely return success (0).

Could this mislead a caller into assuming offlined zones are safe to format=
 or
ignore, potentially leading to data corruption?

> +
> +		/* Not done yet: wait and retry. */
> +		msleep(500);
> +	}
> +
> +	kfree(elements);
> +
> +	return ret;
> +}

[ ... ]

> +int bdev_remove_storage_element(struct block_device *bdev,
> +				unsigned int element_id)
> +{
> +	struct gendisk *disk =3D bdev->bd_disk;
> +	unsigned int memflags;
> +	int ret;
> +
> +	if (!bdev_is_zoned(bdev) || !disk->fops->se_ops)
> +		return -EOPNOTSUPP;
> +
> +	/* Zero is not a valid storage element ID. */
> +	if (!element_id)
> +		return -EINVAL;
> +
> +	/*
> +	 * Freeze and unfreeze the queue to flush any outstanding command.
> +	 * The caller is responsible for not queuing up more I/Os by higher
> +	 * level means.
> +	 */
> +	memflags =3D blk_mq_freeze_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	ret =3D disk->fops->se_ops->remove_element(disk, element_id);

[Severity: High]
By deliberately unfreezing the queue before the hardware removal command and
the subsequent call to blk_revalidate_disk_zones(), does this introduce a
TOCTOU race?

The queue remains unfrozen during the first half of
blk_revalidate_disk_zones(), which could allow concurrent write I/Os to byp=
ass
validation and allocate new blk_zone_wplug entries based on stale state.

When the queue is finally frozen to install the new zone array, these fresh=
ly
created stale write plugs aren't purged, and bios might proceed to write to
the offlined device zones.

> +	if (ret)
> +		return ret;
> +
> +	/* Revalidate the device zones once the opration completes. */
> +	ret =3D disk_wait_for_se_mgmt_completion(disk);
> +	if (ret)
> +		return ret;
> +
> +	return blk_revalidate_disk_zones(disk);
> +}

[ ... ]

> diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
> index 6638361209667..f8f2c2651dffa 100644
> --- a/include/uapi/linux/blkzoned.h
> +++ b/include/uapi/linux/blkzoned.h

[ ... ]

> +/**
> + * enum blk_storage_element_status - Status of a zoned device storage el=
ements.
> + *
> + * @BLK_SE_TYPE_RDWR: The storage element handles both reads and writes.
> + * @BLK_SE_TYPE_READ: The storage element handles reads only.
> + * @BLK_SE_TYPE_WRITE: The storage element handles writes only.
> + * @BLK_SE_TYPE_UNKNOWN: The storage element type is not known.
> + */
> +enum blk_storage_element_type {

[Severity: Low]
this isn't a bug, but the docstring incorrectly identifies the enum as
enum blk_storage_element_status.

Could this copy-paste error be fixed to enum blk_storage_element_type to av=
oid
confusion in userspace?

> +	BLK_SE_TYPE_RDWR		=3D 0x01,
> +	BLK_SE_TYPE_READ		=3D 0x02,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006124510.8820=
17-1-dlemoal@kernel.org?part=3D2
