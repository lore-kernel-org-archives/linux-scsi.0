Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C909E368D71;
	Fri, 24 Jul 2026 22:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930527; cv=none; b=HB8r6Tgav+r01o3e5Zn0vcvS0XMt4hPbQhne/cApwhpbUQ+TfpW5wVxrxdPpfJSBH4o/t9KV/eUUAH7n16HX2XEK77umFUKYBpMGN4K9A9BotBM/y78SFE8ygYdSyeBBguWF8OtKPkV4Euj67nNdFVCmJrFioUTsABp9JpbVoPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930527; c=relaxed/simple;
	bh=0QVn4llDw3HG/DohLIcs5unJxrEJhwIBclmciOQ6Fko=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z21oDTkkUj/34aeXxpS9uB3X3+lKDfej6KtdRbiouPopnovI4/ddUyF6qiZBHNgcFGhoSOuWGrxk0pJcMVzV+gtyDg1/gz3BvcS0LBwP7qKoy1cxaU35MylVI62Tq9ALvOH+f5c7YmJKdsbttvKWvwjOg/QskMvr7mdRPr9PN8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/+E9H8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/+E9H8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FBE1F00A3A;
	Fri, 24 Jul 2026 22:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930526;
	bh=mkoWK4tRjBvEhyBebMpk+L+0ro2wC3/xR9gBiiFgnrs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l/+E9H8It5/NME0ZVqwaG2HQG7Zk48SmzOnNmOcmpVptL1g/KOUnDe4ZoyUknrm2G
	 6PhgzPOadfuMLUbeuFFRQEUsfa/gQSOUOtd8M0pkJ8mPy9WVM4/Qv6kvw6POuaFy86
	 H0EBjnVkJEIBuaqwAQRsSba2RXVWnHxCRbrP78eA2MnLRbJBaJ1yKP9aM1Gn+efgGY
	 vMARMW1tks+PC104w346Y3aEHcYGWphB6u6xw1g3sgT7pqsRHUssbD3HqWDgcOfL8A
	 oP1dLd14js3QcVLUkgw5NYsRpHrINsarxRtUslFPdTk6Y6fTaXcXk6dVi+NNT7dgZb
	 5PnAw43Fl76FQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/9] agp/via: Don't rely on address of pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: dri-devel@lists.freedesktop.org, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260723-pci_id_fix-v4-5-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
 <20260723-pci_id_fix-v4-5-3580726844e1@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 22:02:05 +0000
Message-Id: <20260724220206.56FBE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The exact same out-of-bounds array access vulnerability triggered =
by dynamic IDs is fixed in via-agp but left unpatched in the adjacent amd-k=
7-agp driver.
--

--- Patch [5]: [PATCH v4 5/9] agp/via: Don't rely on address of pci_device_=
id ---
commit 2a62b6ae1ca2d9be48b681d606a5d3d5afef208c
Author: Gary Guo <gary@garyguo.net>

agp/via: Don't rely on address of pci_device_id

Address of pci_device_id cannot be relied on due to presence of dynamic ID
and driver_override. Use driver_data instead.

> diff --git a/drivers/char/agp/via-agp.c b/drivers/char/agp/via-agp.c
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

[Severity: High]
This is a pre-existing issue, but the exact same out-of-bounds array access=
=20
vulnerability triggered by dynamic IDs is left unpatched in the adjacent=20
drivers/char/agp/amd-k7-agp.c driver.

Looking at agp_amdk7_probe() in amd-k7-agp.c:

    j =3D ent - agp_amdk7_pci_table;
    dev_info(&pdev->dev, "AMD %s chipset\n",
             amd_agp_device_ids[j].chipset_name);

Should a similar fix be applied there as well, since userspace could trigge=
r=20
a kernel oops via sysfs driver_override or new_id entries?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723-pci_id_fix=
-v4-0-3580726844e1@garyguo.net?part=3D5
