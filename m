Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B580E42BC38
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803198; cv=none; b=kceoMmKdmIH1E4Ucd8QRCKptl2W+qsxVmUMqkS4cpky5W05anMEmHWTX+fD/u5E4Nznd+b4votKi/pemEUEA/X5s2T3PSI3fs610BQ7Xy3cZ1PhNd3SeDXbvnM3WSq/ycQ3DzyAfAykeTIEtQxPx2LwWA5hSViSUocGyR1VgDUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803198; c=relaxed/simple;
	bh=dlMmiN/3DpipI6nbUAvHkd2lDq3A9+hN6RGpJ+CDRfw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l+R4Acn0srkZ+g/LEGShl4PNKDAa1KcDIwYBbt3wUtkTM3nWWHWwkgQ3Otb5hHeZ0PB4axvWLdIOloS+YoG7TbiCQWt0QXT+f0jA9Au4/BOOVYtgD4xhLePKWKQd0HXWu7j7FK5t10M1/xLtvZ8qL0eznMgvpjaRd5QltGVs5SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqOeL6sb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqOeL6sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480A31F000E9;
	Thu, 23 Jul 2026 10:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784803196;
	bh=ALbZflE6JwMbV7reJj7AtH84XSHWJ0WjaShwioD/KII=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XqOeL6sbkykcqlv4hCzwEDuhzZ1v1caKoU72qrqjDwSE0cgbJfcLY3xatM5BdStZn
	 whCbpgniBqvLEqg/CFSG6m8fd02A9mU4UI8Tgj034FpwlcJz0UC3fZDC7vypN7/HG5
	 LzP1KBEaxtBUKKLaHsb1bkefH5ywQeZwTjtt58tLeg9ekqfK5exrQLZcFMl5Pkr08j
	 lWd1DLA6gs3p6pTrmKF6M46qNB26D0qKxWIDBEjZJ6OjXTKU4/+YDxn4O4viOnBkj+
	 4lFMV8ycXBhtfbt/jlQ4wAjJJwZeRt4xgGFJ/hRPRId4jHQRMLHibgvOOMJZRLbYn+
	 99g5/UeoVQnsA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 22/28] scsi-multipath: add delayed disk removal
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-23-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-23-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:39:55 +0000
Message-Id: <20260723103956.480A31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Broadcasting `scsi_mpath_head` to all SCSI drivers without halting=
 iteration causes a Use-After-Free and Type Confusion risk if the callback =
drops the final reference and frees the structure.
- [High] Missing module reference pinning allows `scsi_mod` to be unloaded =
while delayed removal work is pending, leading to code-execution UAF.
--

--- Patch [22]: [PATCH v4 22/28] scsi-multipath: add delayed disk removal s=
upport ---
commit e75160848c3c93c7fdb328d5ebd94850baa881c8
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: add delayed disk removal support

This commit adds delayed disk removal support to the SCSI multipath core.=20
It introduces a new mpath_remove_head callback in the scsi_driver structure=
=20
and implements scsi_mpath_remove_head_work to execute this callback by=20
iterating over available SCSI drivers.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 6c50fdde70d65..056b9c35d1144 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -362,7 +362,25 @@ static bool scsi_mpath_available_path(struct mpath_d=
evice *mpath_device)
>  	return false;
>  }
> =20
> +static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *d=
ata)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =3D data;
> +	struct scsi_driver *scsi_driver =3D to_scsi_driver(drv);
> +
> +	if (scsi_driver->mpath_remove_head)
> +		scsi_driver->mpath_remove_head(scsi_mpath_head);
> +
> +	return 0;
> +}
> +
> +static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
> +{
> +	bus_for_each_drv(&scsi_bus_type, NULL, to_scsi_mpath_head(mpath_head),
> +		scsi_mpath_remove_head_drv);
> +}

[Severity: High]
Does this code risk a use-after-free and type confusion regression during b=
us
iteration?

Looking at scsi_mpath_remove_head_work() in drivers/scsi/scsi_multipath.c, =
it
unconditionally iterates over all SCSI drivers via bus_for_each_drv(). If t=
he
target driver implements mpath_remove_head and drops the final reference to
scsi_mpath_head freeing the structure, scsi_mpath_remove_head_drv() still
returns 0.

Could the iteration continue and pass the freed scsi_mpath_head pointer to
subsequent drivers on the bus, causing other drivers that implement
mpath_remove_head to dereference a dangling pointer?=20

Should the iteration halt by returning a non-zero value once the callback h=
as
been successfully executed?

>  static struct mpath_head_template smpdt =3D {
> +	.remove_head =3D scsi_mpath_remove_head_work,

[Severity: High]
Does this delayed work introduction expose a use-after-free regression due =
to
a missing module reference?

When delayed removal is queued, it relies on mpath_head->drv_module being s=
et
to pin the module. However, looking at scsi_mpath_alloc_head() where smpdt =
is
assigned:

drivers/scsi/scsi_multipath.c:scsi_mpath_alloc_head() {
    ...
	scsi_mpath_head =3D kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
	if (!scsi_mpath_head)
		return NULL;
    ...
	if (mpath_head_init(&scsi_mpath_head->mpath_head))
		goto out_free;
	scsi_mpath_head->mpath_head.mpdt =3D &smpdt;
    ...
}

Since mpath_head->drv_module is never initialized to THIS_MODULE,
try_module_get(mpath_head->drv_module) will return true without taking a
reference.=20

Could scsi_mod be unloaded while the delayed remove_work is still pending in
the workqueue, causing the remove_head callback execution to jump to unmapp=
ed
memory?

>  	.is_disabled =3D scsi_mpath_is_disabled,
>  	.is_optimized =3D scsi_mpath_is_optimized,
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D22
