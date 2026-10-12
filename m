Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7210D370D47
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 13:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811429; cv=none; b=INr8yeL9AnXpkm1DcR1qZPtHei3Z8GF7/HJpqtb2YnTYXlnRWMMC06Dv8aNJf5IY/jqGtPZXfCFyAP/PifGVXNmWlpodSNO3EUTqMCTv75C+Fgr5Nsa8g8iY2M+1YiG20tM/mwjXcaaWK8Kd+71zvWXT1tc1r+AEP8D+KNM2K5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811429; c=relaxed/simple;
	bh=uMtJPJVgtva634MLlpYi9fb1QL18CiaPDNA6Gxj8CN8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=L9TMKXdm+NU5OKPJd7nlikpHyDZZWfbcjUGznjTWTTM1PKuySzk7AK/JKG9tkZXEf+hugL4G18mpvGBDM/x80jMU31+EYvgieTsOBd/FxBmWEsSVB9xX0qXjdd2p/zQf3J0wyUv3EqhyGN5VbkV5zEWsvBJ6aa/7LtOZAf9rSVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSKDaIfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSKDaIfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BFC1F0089B;
	Mon, 12 Oct 2026 13:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811428;
	bh=cH/BsYJEPM9MTu6LOUexfY29sRJ4XcC/VytTfQpuuzo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RSKDaIfLNwB1MIIDWmajl6SrPAvf/zDex1vttOxEnJGl2imxbSqXS4/ctMHrcb4hc
	 HHsotehJjJWXw3oQOJq7xlvZemMvrB5TCdIB3kx5RhNtrbPSx1oQ5S0znGRW06MHzW
	 O5P17ORyT22aS8g1+nuC6KBU9dSgndRc8p19RrUiDrGuP0IT4RZlVt9xU2YfxPgA8Q
	 fp1j39SqbDkTYOhhlmjpxLIlFGxB8AZLhRmzzBnxDeZi3X8WGoDAlHFcwAXbcluaWf
	 or4Dajoi6cPp4LySSbZr3Nm16LATkEkyfpyOVL9z18x0CO2pHH/v6O8R+3SxmwrtFc
	 YoJqnoOnbUtFw==
Message-ID: <sashiko-outbox-168172@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/9] block: introduce storage element management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012130121.1902634-4-dlemoal@kernel.org>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:23:47 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] block: missing queue freeze during zoned device revalidation after=
 element removal
--

commit b956da4759d697b5157b820cef7c5479dd817a3b
Author: Damien Le Moal <dlemoal@kernel.org>

block: introduce storage element management

This commit introduces storage element management operations for zoned block
devices. It adds functions to report, remove, and restore storage elements
to support features like element depopulation for defective heads.

> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index e7f48774ae17e..46822c7a05ecc 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c

[ ... ]

> +int bdev_remove_storage_element(struct block_device *bdev,
> +				unsigned int element_id)
> +{

[ ... ]

> +	/*
> +	 * Freeze and unfreeze the queue to flush any outstanding command.
> +	 * The caller is responsible for not queuing up more I/Os by higher
> +	 * level means.
> +	 */
> +	memflags =3D blk_mq_freeze_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	/* Initiate the storage element removal and wait for its completion. */
> +	ret =3D disk->fops->se_ops->remove_element(disk, element_id);
> +	if (!ret)
> +		ret =3D disk_wait_for_se_mgmt_completion(disk, elements,
> +						       element_id);
> +
> +	/*
> +	 * Always revalidate zones, even in the case of an error as we do not
> +	 * know what condition the drive zones are in.
> +	 */
> +	err =3D disk_revalidate_zones(disk);

[Severity: High]
Could this unfreeze the queue too early?

The queue is unfrozen before disk_revalidate_zones() is called, which means
the internal zone arrays and capacities can be modified while I/O is
potentially in flight. This might allow concurrent readers in the block
layer, who rely on blk_queue_enter() for protection, to experience torn
reads or use invalid zone states.

Would it be safer to hold the queue freeze until after the zone
revalidation is complete to prevent these concurrent access issues?

[ ... ]

> +int bdev_restore_storage_elements(struct block_device *bdev)
> +{

[ ... ]

> +	/*
> +	 * Freeze and unfreeze the queue to flush any outstanding commands.
> +	 * The caller is responsible for not queuing up more I/O by higher
> +	 * level means.
> +	 */
> +	memflags =3D blk_mq_freeze_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	/*
> +	 * Initiate the storage elements restoration and wait for its
> +	 * completion.
> +	 */
> +	ret =3D disk->fops->se_ops->restore_elements(disk);
> +	if (!ret)
> +		ret =3D disk_wait_for_se_mgmt_completion(disk, elements, 0);
> +
> +	/*
> +	 * Always revalidate zones, even in the case of an error as we do not
> +	 * know what condition the drive zones are in.
> +	 */
> +	err =3D disk_revalidate_zones(disk);

[Severity: High]
Does this share the same queue freeze vulnerability as the removal path?

Just like in bdev_remove_storage_element(), the queue is unfrozen prior
to calling disk_revalidate_zones(), leaving the internal state vulnerable
to concurrent I/O races during restoration.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012130121.1902=
634-1-dlemoal@kernel.org?part=3D3
