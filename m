Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478891D54FA;
	Tue,  6 Oct 2026 23:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330827; cv=none; b=QSVQzvcJcejBmFdSLi7oenxDaq9o4i+KIg03k8O5TMoZls0Qvd853R+CelLijtjKmVjLwL/dBo3FyZCxBNCnF2PnOzIKbKCL2/TGp5hsWwpatZaSNsI6dNEGilUwCz93xMsgAjqNrThJDxEq0CwPgeenqgzSuTD441yz1YviGuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330827; c=relaxed/simple;
	bh=zuvn9k4hxJ+Tngo984R4MXiS9HaZbEndRoIl2tUOybY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aJNGMwAySVjWMNnCnUbtgGbUC/gs5QhHpv/noKBpRaTWakZQeNfPdKodeQqWzf3qY4jXTefrlIFMRTxk8D4poGXrnVSCFPfLPWqM3AUy5YaH0EV/WhGjvji92wrDQceLmpWtcVfoqsE1WfFFbbwo/4gtIfUlQT4wp1R52CRq86o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRgJvHst; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRgJvHst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E2A1F0089B;
	Tue,  6 Oct 2026 23:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330825;
	bh=rRKc3JZ3jGbu//7T0wnFkJzhj7nF53QvzvwgHLTH0ZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DRgJvHstuSTIA06fqzD8vYEMd5PV33qWxS+8Lms0pgGFNiMvhbVyQDvAa/Id7DGLi
	 v3dzGL8hqY7xbrieJD6SolTyjDekmZfqKzlBlo9//mTneqEF3zAZDfRhKmo0N9pjyA
	 QOIokgsh+cyY4ddwdkXR+dXZ1y0qWS4DiOuwR8DJm4ySPUhIg9Ru8R/JBcxXDE80jr
	 Xna6uvy5gmKdOJpH/J6O/35qafiToE065ic49HIKffzNYpJi3hRLVsJn7aI5XenopY
	 zgiLR/D145b8YshDoNIuuvyPTK5x8DKVPBDTYJVP2VeMOz2krA1oEBU4gHn79eelGA
	 VvuLo8cJwDGkw==
Message-ID: <sashiko-outbox-162536@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 04/11] scsi: sr: initialize logical block size before
 registering the disk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20261006234202.1139018-5-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
 <20261006234202.1139018-5-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:53:45 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: sr: physical_block_size permanently stuck at 2048 after hot-=
plugging 512-byte media
--

commit e4bcc9c7bb99e2ad5359e3deb3e003674d2e6c22
Author: Phil Pemberton <philpem@philpem.me.uk>

scsi: sr: initialize logical block size before registering the disk

This commit updates the logical block size of the request queue to match
the driver's default sector size (2048 bytes) if the drive is empty during
probe. This attempts to prevent mismatched block sizes when reading from
media inserted later.

> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index c36c54ecd354b..268f15a4fdb88 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c

[ ... ]

> @@ -701,6 +702,16 @@ static int sr_probe(struct scsi_device *sdev)
>  	if (error)
>  		goto unregister_cdrom;
> =20
> +	/* If no medium was ready, match the queue to the driver's guess. */
> +	if (queue_logical_block_size(sdev->request_queue) !=3D sdev->sector_siz=
e) {
> +		lim =3D queue_limits_start_update(sdev->request_queue);
> +		lim.logical_block_size =3D sdev->sector_size;
> +		error =3D queue_limits_commit_update_frozen(sdev->request_queue,
> +							  &lim);
> +		if (error)
> +			goto unregister_cdrom;
> +	}
> +

[Severity: High]
Does this logic introduce a regression where physical_block_size becomes
permanently stuck at 2048 when a 512-byte medium is inserted later?

If a drive is empty during sr_probe(), this code promotes the
logical_block_size to 2048. Because the block layer one-way promotes
physical_block_size to match logical_block_size, blk_validate_limits()
will automatically latch physical_block_size to 2048:

block/blk-settings.c:blk_validate_limits() {
        ...
        if (lim->physical_block_size < lim->logical_block_size) {
                lim->physical_block_size =3D lim->logical_block_size;
        ...
}

When a 512-byte medium is later hot-plugged, sr_revalidate_disk() shrinks
logical_block_size back to 512:

drivers/scsi/sr.c:sr_revalidate_disk() {
        ...
        lim =3D queue_limits_start_update(q);
        lim.logical_block_size =3D sector_size;
        lim.features |=3D BLK_FEAT_ROTATIONAL;
        return queue_limits_commit_update_frozen(q, &lim);
        ...
}

However, blk_validate_limits() never automatically shrinks
physical_block_size. Could this leave physical_block_size and io_min
permanently at 2048, continuing to cause mismatched block size issues?

>  	error =3D device_add_disk(&sdev->sdev_gendev, disk, NULL);
>  	if (error)
>  		goto unregister_cdrom;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006234202.1139=
018-1-philpem@philpem.me.uk?part=3D4
