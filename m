Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D891C3EE1DB;
	Fri, 24 Jul 2026 22:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930525; cv=none; b=YqvghXjqKSnJ01268Wxce0+Rs2TnRs7J9SLMB2NgHVX/UcBwdpCkAZPKdq15ERL0JMrAvnvreMb3eMlUA3NPR4tV+raDL8LVP8u0HGIQXbBifdrp73Itos5evWlDHNriEtzxw84qkSA968ydy6ZN0bxcjYTizU32ZJg0u+ugX3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930525; c=relaxed/simple;
	bh=k5bssaprm9udZzsS5m9s+ERHL/72zwdW4vbxjs8jY5A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ndvLM88apKi0KYRQCbR036drCs4Wmi7Sp2kIT1Jvku6Osg82h/tP6aKAzAfiXjNm62Bwd6Yvh97TKRgJxNeOGW+IkufIHZUSsATFKJ6Sx35nZ7WtdAHdgaJyAqsbX+LJ3Ps8X5jxaMf6LNkccl3kMXgzAwIT5aNvaWTj5c4EACc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mb6Q+HWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mb6Q+HWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650461F00A3A;
	Fri, 24 Jul 2026 22:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930523;
	bh=cYMEyouyBfQzCuTIahKBhshfk/yBTp5R9vQ8JJQX1aY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mb6Q+HWyebIShFnA+ZTfpunoRLu+6rI2HLmpVhBp4IIlEL9xiqWHuxOFytylGvpQU
	 CYMJ6CeZ2c7PDVr0l0AeD4U6eqCjlRklgbXsk8itwfFm88JmSKNG0e+lKv5hcUPZpo
	 LI95/76ZSNOLxzHz0Dpr+yDJKMvFNnlHcXYRw4l5Utqgth2Cx7RuiC7ZbqqJWTC9U8
	 UKFpkLnxC90sXVDIrZNtYTnLFNiopZIqVKsMK22blIQSsZrBTNESZWkbyQ8XMrWJf9
	 NXudNTdmMHwqX88lsx+qzTZVDO89lddUkw2lWhZ1Kpeacck2qQLPu341xfRvZg2TOr
	 aUM47DvOgxAkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 6/9] agp/amd-k7: Don't rely on address of
 pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: dri-devel@lists.freedesktop.org, cassel@kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260723-pci_id_fix-v4-6-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
 <20260723-pci_id_fix-v4-6-3580726844e1@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 22:02:03 +0000
Message-Id: <20260724220203.650461F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Storing kernel string pointers in driver_data prevents adding dy=
namic IDs via sysfs (new_id).
- [Low] Binding the driver via driver_override passes a NULL pointer to a %=
s format specifier.
--

--- Patch [6]: [PATCH v4 6/9] agp/amd-k7: Don't rely on address of pci_devi=
ce_id ---
commit 6e944a8c8b19b7d71cd09452e813daa32931ee55
Author: Gary Guo <gary@garyguo.net>

agp/amd-k7: Don't rely on address of pci_device_id
   =20
Address of pci_device_id cannot be relied on due to presence of dynamic ID
and driver_override. Use driver_data instead.

> diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
> index 898ff30ffd46b..4d201e71c5177 100644
> --- a/drivers/char/agp/amd-k7-agp.c
> +++ b/drivers/char/agp/amd-k7-agp.c

[ ... ]

> @@ -387,37 +387,17 @@ static const struct agp_bridge_driver amd_irongate_=
driver =3D {
>  	.agp_type_to_mask_type  =3D agp_generic_type_to_mask_type,
>  };
> =20
> -static struct agp_device_ids amd_agp_device_ids[] =3D
> -{
> -	{
> -		.device_id	=3D PCI_DEVICE_ID_AMD_FE_GATE_7006,
> -		.chipset_name	=3D "Irongate",
> -	},
> -	{
> -		.device_id	=3D PCI_DEVICE_ID_AMD_FE_GATE_700E,
> -		.chipset_name	=3D "761",
> -	},
> -	{
> -		.device_id	=3D PCI_DEVICE_ID_AMD_FE_GATE_700C,
> -		.chipset_name	=3D "760MP",
> -	},
> -	{ }, /* dummy final entry, always present */
> -};
> -
>  static int agp_amdk7_probe(struct pci_dev *pdev,
>  			   const struct pci_device_id *ent)
>  {
>  	struct agp_bridge_data *bridge;
>  	u8 cap_ptr;
> -	int j;
> =20
>  	cap_ptr =3D pci_find_capability(pdev, PCI_CAP_ID_AGP);
>  	if (!cap_ptr)
>  		return -ENODEV;
> =20
> -	j =3D ent - agp_amdk7_pci_table;
> -	dev_info(&pdev->dev, "AMD %s chipset\n",
> -		 amd_agp_device_ids[j].chipset_name);
> +	dev_info(&pdev->dev, "AMD %s chipset\n", (const char *)ent->driver_data=
);

[Severity: Low]
Does this pass a NULL pointer to a %s format specifier when the driver is b=
ound
via driver_override?

When a device is bound using the sysfs driver_override interface, the PCI c=
ore
passes a dummy pci_device_id_any structure where driver_data is 0 (NULL). T=
his
would result in an ungraceful log message like "AMD (null) chipset".

Should we add a fallback check for NULL and print a string like "Unknown"
instead?

> =20
>  	bridge =3D agp_alloc_bridge();
>  	if (!bridge)

[ ... ]

> @@ -492,7 +472,6 @@ static int agp_amdk7_resume(struct device *dev)
>  	return amd_irongate_driver.configure();
>  }
> =20
> -/* must be the same order as name table above */
>  static const struct pci_device_id agp_amdk7_pci_table[] =3D {
>  	{
>  	.class		=3D (PCI_CLASS_BRIDGE_HOST << 8),
> @@ -501,6 +480,7 @@ static const struct pci_device_id agp_amdk7_pci_table=
[] =3D {
>  	.device		=3D PCI_DEVICE_ID_AMD_FE_GATE_7006,
>  	.subvendor	=3D PCI_ANY_ID,
>  	.subdevice	=3D PCI_ANY_ID,
> +	.driver_data	=3D (kernel_ulong_t)"Irongate",

[Severity: Medium]
Will storing kernel memory addresses (string literals) in driver_data preve=
nt
users from adding dynamic IDs via sysfs?

The PCI core's new_id_store validates the provided driver_data (which defau=
lts
to 0) against the driver_data in the driver's static id_table. Since this p=
atch
assigns string pointers to driver_data, users cannot supply a matching value
via the new_id sysfs interface, causing new_id_store to always reject the i=
nput
with -EINVAL.

Could the driver store an enum or integer index in driver_data and use it to
look up the string array instead?

>  	},
>  	{
>  	.class		=3D (PCI_CLASS_BRIDGE_HOST << 8),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723-pci_id_fix=
-v4-0-3580726844e1@garyguo.net?part=3D6
