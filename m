Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03A534041E
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 12:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783082644; cv=none; b=WvfUi4TpbkKlqebxQuCmY8VQrw6g9MXLTk5lggpmESF0iVixOxYmwv/mRjZgEVdzupA6XekDYjRYtBgE2WfZviqgQiezLmPT4jn/OXG2Db/FIsnjxzD5KjOlpmHrBa5yEYTYrT41ncQstNyPyVYqnv5rjfVHzHRUbCtERHEKd4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783082644; c=relaxed/simple;
	bh=GMSr2CQgRvCfEGrkKrlq+u7r8J8nt81I4/5PV8usons=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FCcZELeyndeoywVGoKB7WPXl4gmcR9MmmGu3J05G29b2Th+5DOxvyk5H+wIC59QzMkElXI2F8se+1v7RazdXWWtkTlj1tNwn4i/OvcUNfVorgrCvDINWimHlD8CrfihD1mROaan5q1HZ1iLJxkwdUrIcrCpUzTE7V0pIh0NdfZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYgg9vxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYgg9vxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6251F000E9;
	Fri,  3 Jul 2026 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783082642;
	bh=jiD6HCpZ3/f3Y2PeWuoFm/Ttpo2vjJbmsFOz0JDeRRk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eYgg9vxUC4JHkjWSpJ1et7Vcti2gQdL3FO58KsjbvIY05kAkRNOsWVD5GlnKRncFt
	 0IxS/w4FkXw+//RPRgNeRfr0e35lgGarRa51s8Kg0kl3y1m+ydGUQvTuJ+/Tnfvugq
	 HdNfSy9wcJ+RphRPixyolk/r6wN65SPx33k9kOFAmucIS6CGPr0rQqlI8M4sCl+p80
	 7H9jaM0sZgHG1787Rq18DTr2KfYIsVPdJ+GtoXMggnvI72ZJdlqnxhyMac5ZRWwgW0
	 lIzPADqt4Oj6gKyRBk7XAyZs5Hiclp+2f2X8Bs0DcrrTNA0bnyy93gd/dkYbDoA1Hq
	 jHtshzvZa6tjg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 16/17] scsi: sd: add mpath_numa_nodes dev attribute
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-17-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-17-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 12:44:01 +0000
Message-Id: <20260703124402.6C6251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] Build failure due to undefined function `mpath_numa_nodes_show`.

Pre-existing issues:
- [Critical] Race condition during device removal leads to a Use-After-Free=
 of `sd_mpath_disk`.
--

commit 90ab5069ccf099a5f4cd42027fac637f7869d718
Author: John Garry <john.g.garry@oracle.com>

scsi: sd: add mpath_numa_nodes dev attribute

Add an attribute to show multipath NUMA node per-path (scsi_disk).

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 0c77466f8291a..5e0514304d81f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4075,8 +4075,22 @@ static ssize_t sd_mpath_dev_show(struct device *de=
v,
>  }
>  static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);

[Severity: Critical]
This is a pre-existing issue, but does device removal race with sysfs reads
and cause a Use-After-Free?

Looking at sd_remove(), sd_mpath_remove(sdkp) is called before del_gendisk(=
),
which frees sd_mpath_disk but leaves the sysfs attributes active:

	if (sdp->scsi_mpath_dev)
		sd_mpath_remove(sdkp);

	scsi_autopm_get_device(sdkp->device);

	device_del(&sdkp->disk_dev);
	del_gendisk(sdkp->disk);

If a local user concurrently reads the mpath_dev sysfs attribute, won't
sd_mpath_dev_show() blindly dereference the freed sd_mpath_disk? Will the
newly added attribute suffer from a similar lifecycle problem?

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

[Severity: Low]
Will this compile correctly? I couldn't find a declaration or definition for
mpath_numa_nodes_show() anywhere. Could this lead to an implicit function
declaration and a subsequent linker error?

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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D16
