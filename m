Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C448E0D5
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 09:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791537864; cv=none; b=OWhCwsmUQvnd9G3kurCCOkt+5UU1yXQZ/FCLSMDPTYyYaQGYoO63hVIeoSmG836G/533bqhyiWIFz1NyktMqAD+lajSpJyzySnotBOdRHXrcXaSLrrVjmYdqfTvFqvgmOv2nqhH2qchh5yAazfQ71sxy4mOzXHCivfLQO/DtV/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791537864; c=relaxed/simple;
	bh=+Kevdm3M+E1J4DGLLyJv6EwBqDVzgGZb3AiF58tgNlU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BpmqAITrwT6+K07x3i7AH36B4PQ/xmcAdV9kZ2FSyqA6gNPZSttvlfQLzSKCT5YGqv57CfVfz0wRCsEtG0vpkOwAP11AV+QXZb5+ELFE05Y9AvjE6Lr3BVDSu98a9RtYSDVo2hnK2powcncBD7dUic1t5UzFJPccQ06PMUsdvrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GgSojUIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgSojUIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7FE1F000FF;
	Fri,  9 Oct 2026 09:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791537858;
	bh=SfnU3Mqx24Xww/KltPPu381ZRvYFCqDjWFM6gD0AEjE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GgSojUIzBRJhgpPJm5tNdUmnE9O35ff4nabig8nKAFgs1/ti6K+sn0R5+v5vjstQM
	 xugnaDfIHajTaTyoVVHEzu420rwElPVnEyv7E/6al/cPH2v4Ob+lgw1dlygDrtYZHd
	 jMC13XmSn/OOgFhxYtRYZD1HQnROAWG11CPsHcU3EqvasT8T6bYSB+XXz8w0kZUrFq
	 8YFGpyX7sfoBJ2qTgdPdVAAXZvu4FiiX2TIH0H+N8c3vdKcpGT2ymPEyZBcr7sX6JA
	 UYYjxLxBvdc0CNe8Mkmjssd/xTKQV11vJSEAHuFG0q3khjWI06ZAQHRiJH9bApwT3l
	 BMf5b1bsgwoCg==
Message-ID: <sashiko-outbox-165159@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/9] block: introduce storage element management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009090945.1504194-4-dlemoal@kernel.org>
References: <20261009090945.1504194-1-dlemoal@kernel.org>
 <20261009090945.1504194-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 09:24:18 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] block: permanent zone state desync on signal or memory allocation =
failure
- [Medium] block: ignored storage element management error status
--

commit 47105e9f6e8f70ce8710089fec4d093f5ff51fde
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: block: introduce storage element management

This commit introduces storage element management for zoned block devices. =
It
defines generic operations to report, remove, and restore storage elements
so that disks with defective heads can remain in production by depopulating
the defective elements.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
[ ... ]
> +static int disk_se_mgmt_in_progress(struct gendisk *disk,
> +				     struct blk_se *elements,
> +				     bool *in_progress)
> +{
[ ... ]
> +	for (i =3D 0; i < nr_se; i++) {
> +		switch (elements[i].status) {
> +		case BLK_SE_STS_REMOVE_IN_PROGRESS:
> +		case BLK_SE_STS_RESTORE_IN_PROGRESS:
> +			*in_progress =3D true;
> +			return 0;
> +		default:
> +			break;

[Severity: Medium]
Do error statuses like BLK_SE_STS_REMOVE_ERROR fall through to the default=
=20
case here?

If the device encounters an error during the removal, it changes the elemen=
t's=20
status to an error state. The polling loop then sees no elements are in=20
progress, sets in_progress to false, and returns 0 instead of bubbling up=20
the error.

> +		}
> +	}
> +
> +	*in_progress =3D false;
> +
> +	return 0;
> +}
> +
> +static int disk_wait_for_se_mgmt_completion(struct gendisk *disk)
> +{
> +	struct blk_se *elements;
> +	unsigned int noio_flag;
> +	bool in_progress;
> +	int ret;
> +
> +	noio_flag =3D memalloc_noio_save();
> +	elements =3D kzalloc_objs(struct blk_se, disk->nr_storage_elements);
> +	memalloc_noio_restore(noio_flag);
> +	if (!elements)
> +		return -ENOMEM;

[Severity: High]
Does attempting to allocate the polling buffer after the hardware operation=
=20
has already been initiated introduce a memory failure path that aborts=20
synchronization?

If kzalloc_objs fails and returns -ENOMEM, the wait loop is skipped, which=
=20
later bypasses the critical disk_revalidate_zones step in=20
bdev_remove_storage_element. Could this leave the kernel's zone state=20
permanently out of sync with the physical device conditions?

> +
> +	/*
> +	 * Poll the storage elements heath state to detect the end of a
> +	 * removal or restoration operation. Since we do not know how long the
> +	 * operation may take, we cannot have a timeout on this loop. So check
> +	 * for fatal signals so that the user can terminate this retry loop if
> +	 * the device misbehaves.
> +	 */
> +	while (1) {
> +		ret =3D disk_se_mgmt_in_progress(disk, elements, &in_progress);
> +		if (ret || !in_progress)
> +			break;
> +
> +		if (fatal_signal_pending(current)) {
> +			ret =3D -EINTR;
> +			break;

[Severity: High]
Does permitting fatal signals to abandon the wait loop leave the hardware=20
executing in the background with no mechanism to trigger a revalidation=20
upon actual completion?

This error path propagates the aborted wait and also skips the vital zone=20
revalidation step that keeps the kernel's view consistent with the device.

> +		}
> +
> +		/* Not done yet: wait and retry. */
> +		msleep(1000);
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
[ ... ]
> +	ret =3D disk->fops->se_ops->remove_element(disk, element_id);
> +	if (ret)
> +		goto unlock;
> +
> +	/* Revalidate the device zones once the opration completes. */
> +	ret =3D disk_wait_for_se_mgmt_completion(disk);
> +	if (ret)
> +		goto unlock;
> +
> +	ret =3D disk_revalidate_zones(disk);
> +
> +unlock:
> +	mutex_unlock(&disk->zone_revalidate_mutex);
> +
> +	return ret;

[Severity: Medium]
Because disk_se_mgmt_in_progress returns 0 on error states, does this=20
unconditionally return 0 without verifying if the target element actually=20
achieved the BLK_SE_STS_REMOVED status?

The caller might be incorrectly informed that the removal succeeded when it=
=20
actually failed. Should the status of the specific element_id be explicitly=
=20
verified for success after the polling wait completes?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009090945.1504=
194-1-dlemoal@kernel.org?part=3D3
