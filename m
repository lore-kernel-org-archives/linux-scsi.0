Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8B73B0AEA
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166396; cv=none; b=DKNROZrai8hk3u7NrG/uIHqQmkbqd5qQ2WAa8x/CXUqfXbXES6XPpVG4Yv3kFQe1VPf1EAHp55bDIOFNhG3XY0ELAOU99mqUtesMd2XDTltLrFu6c3WvpN25kjsIZID6oC60yV/ZoLEHI/AaBgOAzjTzsUCDIhow/FtzIhKrFmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166396; c=relaxed/simple;
	bh=OZ8TP2POqh9M7sEzQcLaQ2TD/Y6ltXLTwME5oXCf2Jc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kvxFv4L7y+6lxKqre98KSyQPJfK/qpVyEkBhUljtrhTkEDcWfom5BdG3GUIf8PqhJoOP4gFOx6ef4JvQFHw8sOjItqOB0RioQvnCF+VHSEjWKPs/Rpmfdn2UHAC7U03aoRs23OZ9GbvuAj/qOKOLEBIMr5OmFgU3P5JBkCrc92E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZjwFHIBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZjwFHIBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D191F000E9;
	Mon, 27 Jul 2026 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785166394;
	bh=v9xB9dnbIKggeQKlGsFuTkeKXt4l0l50D8m5qn+D+Co=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZjwFHIBeHlx3F6JUHJmMxO5eg1o7kgYe1kp7wBERDRMughOPGvCFcfNuiPyb6B0uz
	 J8jT60fnribmjNBbUKH5kYapYf281rN5Mq+mCp+nqsD3dYzcEogosvRDqpWVtdR7bY
	 YuXfJL+kE003NGq8GvlbsJb5dTTvkQmqy0ClPqdpkFkV6M/CCUFURGZiqUBWMKUO7n
	 xIUxEQTIZXJvdHVtT7RlpEXYock99mTPQ0ODoDl0ohxDPBF5t65pBkyUWFiG1glO5L
	 h6D2kKpfal+e84Omcwli6RmKS82AkBdPwFW3fFhP/1jJPWZ5h9jMqoDQUBvqni8b09
	 GU25gw8YcBmUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 25/27] scsi: sd: add mpath_dev file
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-26-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-26-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:33:14 +0000
Message-Id: <20260727153314.90D191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `mpath_dev` sysfs attribute is exposed to userspace before t=
he multipath disk's device number is initialized, leading to reads returnin=
g `0:0`.
--

--- Patch [25]: [PATCH v5 25/27] scsi: sd: add mpath_dev file ---
commit 947fd6f1a6cab1fe0824d619f628abe9ed07adac
Author: John Garry <john.g.garry@oracle.com>

scsi: sd: add mpath_dev file

Add a mpath_dev file so that the multipath disk can be looked up from
per-path scsi_disk directory.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f044b2dfaa9fd..0d73b03a3daee 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4109,6 +4109,73 @@ static int sd_mpath_add_disk(struct scsi_disk *sdk=
p)
[ ... ]
> +static ssize_t sd_mpath_dev_show(struct device *dev,
> +			struct device_attribute *attr, char *page)
> +{
[ ... ]
> +	disk =3D mpath_head->disk;
> +	disk_dev =3D disk_to_dev(disk);
> +	format_dev_t(devt_str, disk_dev->devt);

[Severity: Medium]
Will this return 0:0 if userspace reads the attribute before the multipath
disk's device number is fully initialized?

Since device_add_disk() on the underlying path exposes these sysfs attribut=
es
before the multipath disk is fully live, disk_dev->devt might not yet be set
by the block core.

Would it be safer to calculate this from disk->major and disk->first_minor,
which are already initialized?

> +out_put_disk:
> +	sd_mpath_put_disk(sd_mpath_disk);
[ ... ]
> @@ -4539,7 +4608,7 @@ static int sd_probe(struct scsi_device *sdp)
>  			sdp->host->rpm_autosuspend_delay);
>  	}
> =20
> -	error =3D device_add_disk(dev, gd, NULL);
> +	error =3D device_add_disk(dev, gd, sd_mpath_dev_groups);

[Severity: Medium]
Does exposing the mpath_dev sysfs attribute here allow userspace tools like
udev to read it before the multipath disk is fully initialized?

If read immediately, before the multipath disk's devt is set, it may return
an invalid 0:0 device number and cause userspace misbehavior.

>  	if (error) {
>  		sd_mpath_fail_probe(sdkp);
>  		device_unregister(&sdkp->disk_dev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D25
