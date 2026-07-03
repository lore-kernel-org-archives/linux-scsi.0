Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7B335028C
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076091; cv=none; b=oqY8DhQU1DPf4r9YaRWyAp4yygvVkM5mZXw8N3P42Hl3gVSjuAjX/WVYTYM/lFo5J65iR+qaEOibsouWbO6RwYZhaaflIbxLPOwRIIaW4jclSZx6CA73wcz2sJWblgKIaJWND085KPu2W04AfZbMAe6mKu1adJWBcrcDifNkp2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076091; c=relaxed/simple;
	bh=xAL5ixnGcodeThGyombrIMoeCZRbTDx9Wr75LRZzLMM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EBkRktgT64f4wzT9dlIz+sa9Azwj6lI51fO5bSJX1FcKv69DMa4MVO9OdL2R6YO5LV9RDw9L+vPWTg75yrW9cvr+x6gJRUMrKKQb7Qdcxof8xoGpk11OJtXhZqR+pRBxEL2/39V+U+bPSU8VAoq2FLzlEyZJCCmOMVGJHGcNniI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLZ8ckFM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLZ8ckFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EE61F000E9;
	Fri,  3 Jul 2026 10:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783076090;
	bh=QFZPaNdy+BVfEJkmH+e6cMQUTy53Gecf/uZllNGrUmo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BLZ8ckFMqN37LXnTE068WMnB9by47wpl55oc6N4xpn9TtaAz0YLFzNkEZ0CflQhGw
	 6eGc1W6DIM4cZdIsJbBR0WZmV3jC8R7yFjaXSb8z9aPrv3aGYI3stve6r645BNcsjt
	 QxHB5XKzGRLCDZj5N9ve9aFSkPQKTei9Ra/WeAMQjVqwGyr8IBEWYVvN3oybEUG4Ch
	 KI3IlXFiRRwEtxjT2GCZIG+zrXkrHV/7N+X9jko0C0CMPINaClqcnE2MJgf79wamRf
	 afI2oaovldcFzyAQvSK4JnD6dUtmXYl6gNYAiQ/eRMe8aAwR1iwx2kYMauQPTGLqio
	 IYr4llnIE2ZcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/13] libmultipath: Add mpath_bdev_getgeo()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703102918.3723667-13-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-13-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:54:49 +0000
Message-Id: <20260703105450.57EE61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing NULL check for the optional fops->ioctl callback in mpath_=
bdev_ioctl
--

commit 5104b9e862d1fb81d42be96c9762fa0a9897083a
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add mpath_bdev_getgeo()

This patch adds mpath_bdev_getgeo() as a multipath block device .getgeo
handler. It redirects the call into the selected mpath_device disk's
fops->getgeo handler.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 4e4b347875500..26d9b17998d66 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -547,6 +547,26 @@ static int mpath_bdev_ioctl(struct block_device *bde=
v, blk_mode_t mode,
>  	return err;
>  }
> =20
> +static int mpath_bdev_getgeo(struct gendisk *disk, struct hd_geometry *g=
eo)
> +{
> +	struct mpath_head *mpath_head =3D mpath_gendisk_to_head(disk);
> +	int srcu_idx, ret =3D -EWOULDBLOCK;
> +	struct mpath_device *mpath_device;
> +
> +	srcu_idx =3D srcu_read_lock(&mpath_head->srcu);
> +	mpath_device =3D mpath_find_path(mpath_head);
> +	if (mpath_device) {
> +		if (mpath_device->disk->fops->getgeo)

[Severity: High]
This is a pre-existing issue, but while reviewing this patch I noticed that
the new mpath_bdev_getgeo() correctly checks if the callback is present
before executing it.

However, the pre-existing mpath_bdev_ioctl() function located just above
this code does an unconditional dereference of the ioctl callback:

lib/multipath.c:mpath_bdev_ioctl() {
    ...
    err =3D mpath_device->disk->fops->ioctl(
            mpath_device->disk->part0, mode, cmd, arg);
    ...
}

If a user-space program issues an ioctl to the multipath block device and
the underlying device driver does not implement the optional ioctl callback,
could this result in a NULL pointer dereference and system panic?

> +			ret =3D mpath_device->disk->fops->getgeo(
> +					mpath_device->disk, geo);
> +		else
> +			ret =3D -ENOTTY; /* See blkdev_getgeo */
> +	}
> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703102918.3723=
667-1-john.g.garry@oracle.com?part=3D12
