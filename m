Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24CE427A1F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803161; cv=none; b=sTCyMXwqEH2Dm+vlXn0Ow3clD/KRI2gR8BIvPcz0z0zCJ1YZvS713hUxjrWDV0nkTJ8Bbq798Xur21yFrQjcR/3/JboI10Yyi+ecbK7j+Q4R1C0QNnygcm14pc9POnblfNzh1OoV35AcscAN407+goseI7Qyomz/dMVw5ODmXNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803161; c=relaxed/simple;
	bh=9oXZI+ljqV8PATk1CgSLYtwKBJ7wola/+/mlIfF2RCA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FuSjwudo0870D9Aht1zMkHWIme7G+SggLAx6k39UdF4sDjj4dEgx05+3J/okDnsXh9/leaQyvZRYRLH+/nFSHAc9KLmiM/jMY2BGh+oLoE4i2aWyacR5ZvFcO+geYufFCOmyToLoeuM92dXLczgTWBwwYyzlme+5CMj0FfNaes8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4TM2oo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4TM2oo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250931F00A3A;
	Thu, 23 Jul 2026 10:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784803160;
	bh=n0+lhtXjdEtCZ4LmzwnM4sDzriLtwRUPkTpjf9u5++o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G4TM2oo+p8l2GcfIBHy9X7D/9LSI5b/rIg1GIK3le+DGWlo4lqGX91goIN71G+jsS
	 tNahVKCXSNOIvSdGw14f8vziqxox4E+VyrERABV83wxRsnMwAN4EZ1hypmcpHELC11
	 kxHLilu7JNUMtMuyIwxPnjzsncBDggNuuQHWNrZrCLTsCxwSEOFzLo+vwJ9mt9MVvi
	 HOjtI/l/wizBgbgLim9bsvTmrUWwqhjFz9Icj2PzhR8xtjHdKFYvzJmQtwwxYFHUWL
	 of5AWo4htKWfOqWi+2l+ZdlW6+6pLy3Sly9nhFy1+gsWjbe9r8KM9ceeOYXFCjs4iW
	 83XqDD9cVa3QA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 23/28] scsi: sd: add multipath disk class
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-24-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-24-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:39:19 +0000
Message-Id: <20260723103920.250931F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] Empty device release callback `sd_mpath_disk_release` bypasses driv=
er core checks and is a known anti-pattern.
- [Low] Indentation of `#ifdef` preprocessor directives inside a struct def=
inition.
--

--- Patch [23]: [PATCH v4 23/28] scsi: sd: add multipath disk class ---
commit 99b2103695f69e8e73bd9a9db23c590d7c822e26
Author: John Garry <john.g.garry@oracle.com>

scsi: sd: add multipath disk class
   =20
This commit introduces sd_mpath_disk_class, a new multipath version of the
scsi_disk class, and the sd_mpath_disk structure to manage multipath
gendisks.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 599e75f333343..242a15bc2c5bb 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[ ... ]
> @@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
>  static mempool_t *sd_large_page_pool;
>  static atomic_t sd_large_page_pool_users =3D ATOMIC_INIT(0);
>  static struct lock_class_key sd_bio_compl_lkclass;
> +#ifdef CONFIG_SCSI_MULTIPATH
> +struct sd_mpath_disk {
> +	struct scsi_mpath_head		*scsi_mpath_head;
> +};
> +
> +static void sd_mpath_disk_release(struct device *dev)
> +{
> +}

[Severity: Low]
Does this empty release callback intentionally bypass the driver core check=
s?

While this is currently unreachable as no devices are registered to this
class yet, providing an empty release function just to silence the driver
core's missing-release warning is a known anti-pattern. This will cause a
permanent memory leak when devices are eventually assigned to this class and
need to be freed.

> +
> +static const struct class sd_mpath_disk_class =3D {
> +	.name =3D "scsi_mpath_disk",
> +	.dev_release =3D sd_mpath_disk_release,
> +};
[ ... ]
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 574af82430169..304b24644d942 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -83,6 +83,9 @@ struct zoned_disk_info {
> =20
>  struct scsi_disk {
>  	struct scsi_device *device;
> +	#ifdef CONFIG_SCSI_MULTIPATH
> +	struct sd_mpath_disk *sd_mpath_disk;
> +	#endif

[Severity: Low]
This isn't a bug, but should these preprocessor directives start at column =
0?

Indenting preprocessor directives inside the struct definition doesn't align
with the standard kernel coding style guidelines.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D23
