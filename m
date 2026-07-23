Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6444A1D5174
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803953; cv=none; b=KcDPiAtBZoixzYBi+O4kZhWpBZGwXeuMmfsGrqCqrJYWWD8ckpe7dmAbl8YicRU5OUu14VjbmZfuSsevDe6CuS1Z7XTYq0h5ttWQWKehqg5jLzvu/2BD8SBSHWBB1v8ga2cinbblJIIiZEy6d2qp7W6zxrtRQHdEuHCDeVMm+f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803953; c=relaxed/simple;
	bh=3avj97pHPGzKpTgFTrDP1pIfFtrrnyYoNtYM0DGYfq4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h+KFYHq7HiN2I3jTo7Lu5oQRiR+zW/wMGVJyZqgTUiFrWEqgARuA1fGkJT6QJ/GVx2foyalHWXYPkVO7fyr4arIO0qSnnQtYqdcX8z1SELxH73cmOnAinv6uuYC2KXcY2kSoAb5pcRi7ho1nfAH70S837Nb0teeyb4j4ZoFXIVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2By7Rfa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2By7Rfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5040E1F000E9;
	Thu, 23 Jul 2026 10:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784803950;
	bh=IhJjaC+pF7hA5EZzXIkOjMok0Di5tfHtS2lOFrB3i0g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T2By7Rfa4koYuB+l5yb/qLVZY+BWcmvcrVOiTeBNwQJDWFbv8F4I8SwAgop1W0GWW
	 Adl2I9zUyGcYQbBd0xCahK2vY//ZHZSMKvK8SJy+WX5KcrTtQJJ4wUoAhM83s5ymuR
	 O/jGKz/6bDrHRvm8x4uRptuukTo+QijJf4cDvAiIEF/lVqOnwktBarYKAv9OouZjQX
	 TPv5LDXF0/vTeKMFgXfqRqL3p8O6bT7+RLh5Zukwv/oHY+9T0oxCDxb/Yodzt2YR3u
	 wFx3lPrSYtdwGLcmJe91F67o4n0Zn3Cq3ETFnV35Zw59ez+Ry728jh+4GUTx9y8BTY
	 vKysDKOlsZciQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 27/28] scsi: sd: add mpath_numa_nodes dev attribute
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-28-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-28-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:52:29 +0000
Message-Id: <20260723105230.5040E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Reading the `mpath_numa_nodes` sysfs attribute before the device i=
s fully initialized causes a guaranteed NULL pointer dereference on `mpath_=
device->mpath_head`.
--

--- Patch [27]: [PATCH v4 27/28] scsi: sd: add mpath_numa_nodes dev attribu=
te ---
commit cc5c94ceb8cbeeccd7a5678ef260c6bd21a0fd6b
Author: John Garry <john.g.garry@oracle.com>

scsi: sd: add mpath_numa_nodes dev attribute
   =20
Add an attribute to show multipath NUMA node per-path (scsi_disk).

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f8c9096e6c43c..7255df6e3e971 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4076,8 +4076,22 @@ static ssize_t sd_mpath_dev_show(struct device *de=
v,
>  }
>  static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
> =20
> +static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct gendisk *gd =3D dev_to_disk(dev);
> +	struct scsi_disk *sdkp =3D gd->private_data;
> +	struct scsi_device *sdev =3D sdkp->device;
> +	struct scsi_mpath_device *scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> +	struct mpath_device *mpath_device =3D &scsi_mpath_dev->mpath_device;
> +
> +	return mpath_numa_nodes_show(mpath_device, buf);

[Severity: High]
Does this code risk a NULL pointer dereference if the attribute is read ear=
ly?

When sd_probe() calls device_add_disk(), it exposes the mpath_numa_nodes
sysfs attribute to userspace and fires a uevent. If userspace (like udev)
reads this file before sd_mpath_add_disk() runs, mpath_device->mpath_head
will still be NULL.

When mpath_numa_nodes_show() receives this mpath_device, it passes the NULL
mpath_head to mpath_read_iopolicy(), which will dereference it:

lib/multipath.c:mpath_numa_nodes_show() {
	struct mpath_head *mpath_head =3D mpath_device->mpath_head;
	...
	if (mpath_read_iopolicy(mpath_head) !=3D MPATH_IOPOLICY_NUMA)
		...
}

include/linux/multipath.h:mpath_read_iopolicy() {
	return READ_ONCE(*mpath_head->iopolicy);
}

Should we check if mpath_device->mpath_head is valid before attempting to
dereference it?

> +}
> +static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NUL=
L);
> +
>  static struct attribute *sd_mpath_dev_attrs[] =3D {
>  	&dev_attr_mpath_dev.attr,
> +	&dev_attr_mpath_numa_nodes.attr,
>  	NULL
>  };

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D27
