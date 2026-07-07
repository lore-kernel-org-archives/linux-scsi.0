Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B1F42314A;
	Tue,  7 Jul 2026 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433542; cv=none; b=DlLLJYWKaOfiG4G4/KhRGLcpHG+ZI+T+S5olMm3D+AiJFg/hQhEQl2FntV2szOSPFZHAGIgJ5JsMqXElxKst8UlItLIlI+DKTBTx/cgUELjGjvbuxW1eXmfUfQfkkl0vvDGMUaVU8+vVarzuvePzC9Y6ym2XchGz+AjCLg+Vkyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433542; c=relaxed/simple;
	bh=8KGxQUIYijneXejQU1xUh12K1iXtl/B/4fmXY/wY4W4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FjlFwNJNcBLPQBFixGS2icYOSAZPl2xpGMgf1toBqg1XXU93GHxTPymyghFDExy211ENjoywMLPJEstog81EcDD9xRtmX+NPkF8L70kiL8b3pogu5jwxrwsT1wA/BVdQzabSMo4wFqyOhgTUqW2WXhWZlrKmeCVvOnOi0bm/Kb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGBb9ons; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGBb9ons"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81461F00A3F;
	Tue,  7 Jul 2026 14:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433537;
	bh=gXo2I8WWUUzgL/fzewhPwv7C4pNjWmnVuQkBdkwQytA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cGBb9onsGAIZPitkRw5XzB8sdi9TzT0+mWgJ88+xKSfVaNXwiE0MVxJhjmyL7aFSR
	 60jEXj5mO7CSyk7oYCICfNtfvbRzrEJoOOi7p6hkCS5+kBSHK9ZhYF6WIQ6cZLcZXa
	 d9I4iW9Zo1IViScC7COKbeB6iTQAOKIeC0gogTVm4zeXXbp/ot8iHgU+TRgDGWSkyf
	 m2rU/FeDgdWcFSPfnT6nuZzqtAanQpVRKtoO3ZGZ5FcLUJKBkA+N+A+X9pXQ1G0zAK
	 VHxJsNUyNq2/x68A6mOD9sHCTjXJipculoBeJoKOy1eLMkMiKtvRJr4KSIxTm69fA7
	 LO7WUZcPL3DrQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/9] agp/via: don't rely on address of pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, cassel@kernel.org, dri-devel@lists.freedesktop.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260706-pci_id_fix-v3-5-2d48fc025acc@garyguo.net>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
 <20260706-pci_id_fix-v3-5-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 14:12:16 +0000
Message-Id: <20260707141216.A81461F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] When a device binds via `driver_override`, the PCI core passes a ge=
neric `pci_device_id_any` struct with `driver_data` set to 0. Passing this =
NULL pointer to the `%s` format specifier results in an unhandled `(null)` =
log output.
--

commit cefd4bbcd02b1f8d8a6df6f9aa562b23cee64272
Author: Gary Guo <gary@garyguo.net>

agp/via: don't rely on address of pci_device_id
   =20
Address of pci_device_id cannot be relied on due to presence of dynamic ID
and driver_override. Use driver_data instead.

> diff --git a/drivers/char/agp/via-agp.c b/drivers/char/agp/via-agp.c
> index 8b19a5d1a09b4..ab3b73dd080af 100644
> --- a/drivers/char/agp/via-agp.c
> +++ b/drivers/char/agp/via-agp.c
[ ... ]
> @@ -437,17 +239,14 @@ static void check_via_agp3 (struct agp_bridge_data =
*bridge)
> =20
>  static int agp_via_probe(struct pci_dev *pdev, const struct pci_device_i=
d *ent)
>  {
> -	struct agp_device_ids *devs =3D via_agp_device_ids;
>  	struct agp_bridge_data *bridge;
> -	int j =3D 0;
>  	u8 cap_ptr;
> =20
>  	cap_ptr =3D pci_find_capability(pdev, PCI_CAP_ID_AGP);
>  	if (!cap_ptr)
>  		return -ENODEV;
> =20
> -	j =3D ent - agp_via_pci_table;
> -	printk (KERN_INFO PFX "Detected VIA %s chipset\n", devs[j].chipset_name=
);
> +	dev_info(&pdev->dev, "Detected VIA %s chipset\n", (const char *)ent->dr=
iver_data);

[Severity: Low]
Could this result in printing a (null) value to the kernel log?

If an administrator forces binding of the driver to a device using the sysfs
driver_override feature, the PCI core passes a generic pci_device_id_any st=
ruct
with driver_data set to 0.

Passing this NULL pointer to the %s format specifier in dev_info() would
print (null) in the kernel logs instead of a valid string. Is it possible
to check ent->driver_data for NULL before attempting to print it, or fall b=
ack
to a default string?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-pci_id_fix=
-v3-0-2d48fc025acc@garyguo.net?part=3D5
