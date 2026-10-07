Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B7E41442C
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362081; cv=none; b=Kp0yxhiuFWKGNdwDS9GbXe9Rgz0i0Fu0n031jxTo05cAsYDZS3TT4EdPW9TwBGOv9NdIMJDkN55V+jTBUh/neFQL40kkNPbSMV/djVlm8Upz9BFKZYjrTujBiootq9loNAH+fWwj9RzA/FHczhsA4+7FMdgQSgKDvKV3k3ZphPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362081; c=relaxed/simple;
	bh=ZdOhpXZ0haq4Aq0rNdn+EZDXNWSiDdjpJgBvgNP/HSA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Whh8qXcrTWVSwwMVjv9Y9WaTmrg5cQJxaPa4bQRCesCfKXrCmu3KQl1rnR7cqTPSfRFxyuJVgR2YdlJVleom1jwUJwc6JHXy5O6sieKV2XWMmNiUp12Ee0jdi/4rkIBpODSRyu+xikHRDu+vimZH1Cyt75OE2V0MGQvwjedPhxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0gxUAbp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0gxUAbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C341F0089E;
	Wed,  7 Oct 2026 08:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791362078;
	bh=sujJAq7rl/hrG7Io8ETunTOQsuEZ+bLGRQz8eIorM6Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b0gxUAbp/PXQUXMJFJJd/p0Zr0mFF9yPYBSO7ov2BDcx8R06OgsdcKOPQr0jmV6af
	 WavID7mkAsjbtWBkrn3iM7aVLT3QQzK2E+SKhgsUbinDB4aZlMm4284ISHXL44xF82
	 Sof85tvo6hTxlwtK+awwMlOkAei9+bNrcUuFp4A2LJsqp0kEOVxyCsOA/LLpghGhCF
	 yiMF07zSfQtlp77vT3VdjR6tsZqq4JDs3XoXS3bNAOjx4uykhnhxcSpVj7ZQvJIz/A
	 tRGiFF26e1bH6gx3Iff2G4azUGOCMudiHzuQcZAGGpZh0qKvmhdAt6p53MKf8Lr63L
	 1id+1hMRk92Ow==
Message-ID: <sashiko-outbox-162749@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/7] block: introduce storage element management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007082344.1049179-3-dlemoal@kernel.org>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 08:34:37 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] block: NULL pointer dereference if optional se_ops methods are not=
 implemented
- [Medium] block: disk_wait_for_se_mgmt_completion() ignores hardware error=
s and falsely reports success
- [Medium] block: disk_wait_for_se_mgmt_completion() overwrites successful =
completion with -EINTR
--

commit d3d300e29a3d6ef944841ecbfddc83f5a8fabe94
Author: Damien Le Moal <dlemoal@kernel.org>

block: introduce storage element management

Recent SCSI (SBC) and ATA (ACS) standards define the storage element
depopulation feature. This feature is intended for managing hard-disks
heads, either combined read-write heads or pairs of read and write heads.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 131c9f50b3da5..6a4c6a3f2060b 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c

[ ... ]

> +static int disk_wait_for_se_mgmt_completion(struct gendisk *disk)
> +{
> +	struct blk_storage_element *elements, *e;
> +	unsigned int i, nr_se, nr_elements =3D 0;
> +	unsigned int noio_flag;
> +	int ret;
> +
> +	/* The callers already checked that disk->fops->se_ops is set. */
> +	ret =3D disk->fops->se_ops->report_elements(disk, NULL, &nr_elements);

[Severity: High]
Does this cause a NULL pointer dereference if the device driver provides
se_ops but leaves the optional report_elements method as NULL?

[ ... ]

> +		e =3D elements;
> +		for (i =3D 0; i < nr_se; i++, e++) {
> +			if (e->status =3D=3D BLK_SE_STS_REMOVE_IN_PROGRESS ||
> +			    e->status =3D=3D BLK_SE_STS_RESTORE_IN_PROGRESS)
> +				break;
> +		}
> +		if (i >=3D nr_se)
> +			break;

[Severity: Medium]
Will this loop falsely report success if a hardware operation fails?

If the hardware encounters an error and updates the element's status to
BLK_SE_STS_REMOVE_ERROR or BLK_SE_STS_RESTORE_ERROR, the status is no
longer IN_PROGRESS. As a result, the loop terminates successfully
(i >=3D nr_se) and the function returns 0. Will the caller then assume the
element was successfully depopulated or restored, masking the hardware
failure?

> +
> +		/* Not done yet: wait and retry. */
> +		msleep(1000);
> +	}
> +
> +	if (!ret && fatal_signal_pending(current))
> +		ret =3D -EINTR;

[Severity: Medium]
Does this logic mistakenly overwrite a successful completion with an
error if a signal arrives concurrently?

If the polling loop detects the operation finished successfully and breaks
out, but a fatal signal is delivered at the exact same time, this will set
ret =3D -EINTR.

Since the callers bdev_remove_storage_element() and
bdev_restore_storage_elements() abort on an error return, won't this
cause them to skip the mandatory blk_revalidate_disk_zones() step, leaving
the kernel's zone state permanently out-of-sync with the physical hardware
geometry?

[ ... ]

> +int bdev_report_storage_elements(struct block_device *bdev,
> +				 struct blk_storage_element *elements,
> +				 unsigned int *nr_elements)
> +{
> +	struct gendisk *disk =3D bdev->bd_disk;
> +
> +	if (!bdev_is_zoned(bdev) || !disk->fops->se_ops)
> +		return -EOPNOTSUPP;
> +
> +	if (!nr_elements)
> +		return -EINVAL;
> +
> +	if (*nr_elements && !elements)
> +		return -EINVAL;
> +
> +	return disk->fops->se_ops->report_elements(disk, elements, nr_elements);

[Severity: High]
Can this code cause a NULL pointer dereference if report_elements is not
implemented by the driver?

> +}
> +EXPORT_SYMBOL_GPL(bdev_report_storage_elements);

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
Can this trigger a NULL pointer dereference if the driver provides se_ops
but omits the remove_element method?

[ ... ]

> +int bdev_restore_storage_elements(struct block_device *bdev)
> +{
> +	struct gendisk *disk =3D bdev->bd_disk;
> +	unsigned int memflags;
> +	int ret;
> +
> +	if (!bdev_is_zoned(bdev) || !disk->fops->se_ops)
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Freeze and unfreeze the queue to flush any outstanding commands.
> +	 * The caller is responsible for not queuing up more I/O by higher
> +	 * level means.
> +	 */
> +	memflags =3D blk_mq_freeze_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	ret =3D disk->fops->se_ops->restore_elements(disk);

[Severity: High]
Does this code trigger a NULL pointer dereference if the driver provides
se_ops but leaves restore_elements as NULL?

The commit message notes that "Repopulating defective storage elements
is generally not allowed by devices", suggesting drivers will commonly
omit restore_elements.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007082344.1049=
179-1-dlemoal@kernel.org?part=3D2
