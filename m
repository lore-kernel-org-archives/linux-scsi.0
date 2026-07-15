Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919BC31E84E
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784152826; cv=none; b=U7TmUcPE/r9S+DyX42fG1E4HJ9+2wY6FUIH3Bay2jZgQtl8uclImfU9y4eA2xkaVS/nzzAczkQq9h7Rm0yR5dGXMHAcHbhyvuqPHf37tn4l65CKZTZH7yM1rmk+BQ7BH+GphndHWCzgJB7+tAIKQBslSvusyDLbsE5ntgT+T4BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784152826; c=relaxed/simple;
	bh=1/LMf3LM7/t2q32O43jpu5Ipy2d1fNq+7hlNypZ6ulo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G6HvGTCj+E7JiSjuDB/MsqRA198aDEp59dG+iRg104pR9aWWopKnt94c6sjXMrwBItPy/PeTgAvEqnNiDTFf8FKhEh1KwOzjxWC5M8YD5vkrDxLKoxfgUmQ4/yTSNwUpOxrO8cg1U27OlLxT7tG4wPX60TkMaQyXoIdIi0LNzCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJzShHW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJzShHW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CBA1F000E9;
	Wed, 15 Jul 2026 22:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784152825;
	bh=GedwVckFpBo4zVBiGYV/DAJfklB0/lvvv4oRCWJBD4c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OJzShHW76LYXTxHGmP58VQ9baDF1dkIl5QdEC0oBVSjMJwzbqcZy30Z8A7DE/Jxog
	 z+PpL6H97a6ujt8jexYXN0rfS3/G+tthO6+ilq3k5eB+g2j8kIRv32uVJSBekjMLus
	 q0w8SfDUF+Al7qouPLDWadwGvj315NKef93QWMnFYkF3kXJSoz1w1/6hG/rvKakE+O
	 v9h33ntcGPtW6zpgqZDNxGdmmt1oG5cGfoyVe4q8GjGWghhk58L4M3FQuZebHObOQn
	 ylnaaE0G8xXA4Q/FhVYz/lB6S4EUiyMHJ0mS3A+/V4JjGOTUVdE4LVkiT21eoXGc1I
	 uGV6yA00sJ7yA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jorge Ramirez-Ortiz" <jorge.ramirez@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260715214327.1933560-3-jorge.ramirez@oss.qualcomm.com>
References: <20260715214327.1933560-1-jorge.ramirez@oss.qualcomm.com>
 <20260715214327.1933560-3-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 22:00:24 +0000
Message-Id: <20260715220024.E5CBA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Medium] Selecting a non-existent Kconfig symbol (`CRYPTO_LIB_BLAKE2S`).

Pre-existing issues:
- [High] Circular reference between the parent `ufs_rpmb->dev` and the chil=
d RPMB device `rdev` prevents proper unregistration and causes a memory lea=
k.
- [High] struct ufs_rpmb_dev is allocated with devm_kzalloc but contains a =
reference-counted struct device, leading to a Use-After-Free.
- [High] TOCTOU race: ufs_rpmb->region_id is initialized after rpmb_dev_reg=
ister() completes, allowing concurrent requests to use a zeroed region ID.
- [High] ufs_rpmb_bus_type is assigned to the device but never registered, =
causing device_register() to unconditionally fail.
--

--- Patch [2]: [PATCH 2/2] ufs: rpmb: use a fixed-length RPMB dev_id ---
commit 3594b8409e2ab8cc7cc016e7f74ba42ec3857db5
Author: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Subject: ufs: rpmb: use a fixed-length RPMB dev_id

This commit changes the UFS RPMB ID generation to use a fixed 16-byte
Blake2s hash instead of a variable-length string. This aligns the UFS RPMB
ID with the eMMC CID layout, ensuring compatibility with OP-TEE.

> diff --git a/drivers/ufs/Kconfig b/drivers/ufs/Kconfig
> index f662e7ce71f1b..0a050565872d2 100644
> --- a/drivers/ufs/Kconfig
> +++ b/drivers/ufs/Kconfig
> @@ -7,6 +7,7 @@ menuconfig SCSI_UFSHCD
>  	tristate "Universal Flash Storage Controller"
>  	depends on SCSI && SCSI_DMA
>  	depends on RPMB || !RPMB
> +	select CRYPTO_LIB_BLAKE2S if RPMB
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Medium]
Does the CRYPTO_LIB_BLAKE2S config symbol exist?

As documented in lib/crypto/Kconfig, BLAKE2s support is always built-in,
so this select statement appears to reference a non-existent symbol which
could cause unmet direct dependency warnings.

[ ... ]
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index adbec80cf3811..a7595be0884c6 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
[ ... ]
> @@ -156,6 +158,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  {
>  	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;

[Severity: High]
This isn't a bug introduced by this patch, but does devm_kzalloc() safely
manage the lifecycle of the reference-counted ufs_rpmb_dev structure?

In ufs_rpmb_probe():
    ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
    ...
    ret =3D device_register(&ufs_rpmb->dev);

Because devm_kzalloc() ties the memory to the host device's devres, the
devres subsystem will automatically free ufs_rpmb during driver unbind. If
the device reference count is still elevated at that time (e.g. via sysfs),
could the release callback ufs_rpmb_device_release() later dereference this
freed memory when the reference count finally drops to zero?


[Severity: High]
This isn't a bug introduced by this patch, but does the UFS RPMB bus
registration fail unconditionally?

In ufs_rpmb_probe(), the bus is assigned:
    ufs_rpmb->dev.bus =3D &ufs_rpmb_bus_type;

However, ufs_rpmb_bus_type appears to be statically defined and never
registered via bus_register(). When device_register(&ufs_rpmb->dev) is
called, will it fail with -EINVAL because the driver core cannot find the
bus subsystem?

[ ... ]
> @@ -230,6 +242,8 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> =20
>  		kfree(cid);
>  		cid =3D NULL;
> +		kfree(dev_id);
> +		dev_id =3D NULL;
> =20
>  		ufs_rpmb->rdev =3D rdev;

[Severity: High]
This is a pre-existing issue, but does this create a circular reference
that prevents the device from ever being unregistered?

ufs_rpmb_probe() registers a child device:
    rdev =3D rpmb_dev_register(&ufs_rpmb->dev, &descr);

The child holds a reference to the parent. In ufs_rpmb_remove(), the parent
is unregistered without explicitly unregistering the child:
    device_unregister(&ufs_rpmb->dev);

Since the release callback ufs_rpmb_device_release() contains the call to
rpmb_dev_unregister(ufs_rpmb->rdev), it will never be called because the
child keeps the parent's reference count elevated. Can this lead to a
permanent memory leak of the device?

>  		ufs_rpmb->region_id =3D region;

[Severity: High]
This is a pre-existing issue, but is there a race condition between
registering the RPMB device and setting the region_id?

In ufs_rpmb_probe():
    rdev =3D rpmb_dev_register(&ufs_rpmb->dev, &descr);
    ...
    ufs_rpmb->region_id =3D region;

When rpmb_dev_register() completes, the RPMB class interface's add_dev
callback could schedule a background worker to access the device. If this
worker issues requests before region_id is initialized, could
ufs_rpmb_route_frames() read a zero-initialized region_id and incorrectly
route requests?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715214327.1933=
560-1-jorge.ramirez@oss.qualcomm.com?part=3D2
