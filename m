Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C853F39F6
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 12:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782475417; cv=none; b=sflXid5TupOzkp4sjcDbao21gcLJbVLn8MDe6pfpdh2irrUNrSGv9jLYQPK+kuH3DjpAuiJchTdmNnSw2MNTCHpTC6z7VdCBvcrRSmEInpoPEeD+DllDY0xt2KrFUhDjujO1NfWbrMGzyrZm9HSfwoErZbf0IXHmBkxyVNdrx1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782475417; c=relaxed/simple;
	bh=Bxyr54bWpMc2G/nMHIppiD1C5Dn4uWxyg7ayksu0iPc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aIaWgwXOkFF6puZejxIB1+e0p/SA2xis+40bYLxOdM/z9ObNnKx1wMxL+SSmqy8ZvM+3OLox0wJ6/4Au2n4AvyVfr8zHfdf1UTugyh85IxiwDKFYPuAsQ8NVTpead7slsuF2bAnMxUVTwVyFlQ5Zg85gIPXxVOY2JOQmD0exR4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9YkM6gB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9YkM6gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77A91F00A3A;
	Fri, 26 Jun 2026 12:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782475415;
	bh=ZT4eBrrZfKZ7PkGXbN5KQEAS3oXsxJR80iDIwrlz32k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D9YkM6gBKUs6oGwmGzP8Hkf4O/nbQm4I5GI8MkcMzsBLWI849IdWkpyVo2q5YEBzu
	 68KylqJl7sgRoPx7gcNOau5/kBnsYAzGwZqQ10LUz0WzuvAzWs8abQk6kvVvMLuj+N
	 FiWL4r4jQ/21PYrcmMOhppBmGoqX1sQoVnVNCdYblMnUjZlBnItxs83lreomwL3X4b
	 xHSWNtC2ZzJlolKTO6mALRWlyy/FVtOwE3XehuPA1BMhKL3eo7Wb7yW2r4+EBuUC1J
	 bS5LbPQVG0yRIy9lWyM1A3p0CBk+3ksgNpybVYkvnpVbvi6WK0MpVSDe9+J85XLtGR
	 7xpXv2pM+46Qg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 01/10] mpi3mr: Skip device shutdown during unload per
 controller configuration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260626114109.43685-2-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
 <20260626114109.43685-2-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 12:03:35 +0000
Message-Id: <20260626120335.A77A91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing `le32_to_cpu()` conversion when reading the little-endia=
n `flags` field from `driver_pg1`.
--

commit d356c9ee9428175d4bc2bdb0dd4aaf2c6a81d8bd
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Skip device shutdown during unload per controller configuration

This commit updates the driver to cache the Driver Page 1 configuration
and skip device shutdown requests during driver unload when the controller
requests it.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 31b19ed1528e5..eb730318db474 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
[ ... ]
>  static void
> -mpi3mr_read_tsu_interval(struct mpi3mr_ioc *mrioc)
> +mpi3mr_read_driver_page1(struct mpi3mr_ioc *mrioc)
>  {
>  	struct mpi3_driver_page1 driver_pg1;
>  	u16 pg_sz =3D sizeof(driver_pg1);
>  	int retval =3D 0;
> =20
>  	mrioc->ts_update_interval =3D MPI3MR_TSUPDATE_INTERVAL;
> +	mrioc->skip_dev_shutdown_on_unload =3D 0;
> =20
>  	retval =3D mpi3mr_cfg_get_driver_pg1(mrioc, &driver_pg1, pg_sz);
> -	if (!retval && driver_pg1.time_stamp_update)
> +
> +	if (retval)
> +		return;
> +
> +	if (driver_pg1.time_stamp_update)
>  		mrioc->ts_update_interval =3D (driver_pg1.time_stamp_update * 60);
> +
> +	mrioc->skip_dev_shutdown_on_unload =3D
> +		(driver_pg1.flags &
> +		 MPI3_DRIVER1_FLAGS_DEVICE_SHUTDOWN_ON_UNLOAD_DISABLE) ? 1 : 0;

[Severity: Medium]
Does this bitwise operation need an endian conversion?

Since driver_pg1.flags is an __le32, evaluating it with a bitwise AND
without conversion on a big-endian system will check the wrong byte.
This might cause the feature to silently fail to activate.

Could this use le32_to_cpu(driver_pg1.flags) before the bitwise AND?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626114109.4368=
5-1-ranjan.kumar@broadcom.com?part=3D1
