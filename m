Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43684368D71;
	Fri, 24 Jul 2026 22:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930524; cv=none; b=Jq4WEc/dmce+t/0OUeWqDri681141MIV6gTUPqO4tboz+Z+E3W8lY0QA4J2FPi7o2bVU+9c0Y0/hme6Efb26mdUIyq5YbQWj7f49p+I0XghnhryUjWm2ID1LwoPrTGqiYjhzuPUKCGIXYCwmat0O1Bl4uyRtdcMJZJaAk9MlTFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930524; c=relaxed/simple;
	bh=ywah8ER0vLY+C1/cK6YU1x2kevhPGJj1cJWLrEnreFI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eM4GMCOkF63vYPmiHDiAYOvqJM8dJcZA8L6A25TuthWVDZHY499+oJuOGwuBHfbHBY2on5PKQNzoAdH84Br7l7DSP0C7I0jux3YMLrIPkPwwGKVV44MoQDNCny/dSzgjekrNMK+R1JzRc/ZR65/Wk7KUzogmWxLz478lK1sWI9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuwhY2zI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuwhY2zI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731C51F000E9;
	Fri, 24 Jul 2026 22:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930522;
	bh=19neDo4MQirpVjO0C6b65qm1NaBdKqFZ57sG6uJUNus=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BuwhY2zIWODQmYcPMT8oZOiyLSlKJbI820rZB1d/2wT4fAkJJorHMu/eyqO/iyPj1
	 hHAsbFIaCB5vrAHyMcYDcCfh0BlD0LFh/X3rO0arC25oGm6G5lJRqp96oKxm305oGc
	 QKsNESB+n7uEQ2Qn300X1fR9do4Iw7MdhgtiZ3LCc5bZz7pq0qAKctcdknUBzU9bhN
	 Lg4vlz9VC+1Lzqr+vcL9KDA+Jl7wG8C7ACpxV6wGYO0EIao/alKqbmy2GKw5eC51Ei
	 SxgSpTlqeG+H9EMDOGoIsuH/oL0CIk+S0fa1mZ/pjG6kvAcDJ/CGaXM9un1LFRTTmi
	 FfXzeEX1S9d3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/9] ipack: tpci200: don't store pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: dri-devel@lists.freedesktop.org, dlemoal@kernel.org, linux-pci@vger.kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260723-pci_id_fix-v4-3-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
 <20260723-pci_id_fix-v4-3-3580726844e1@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 22:02:02 +0000
Message-Id: <20260724220202.731C51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] MMIO configuration registers are mapped and accessed before callin=
g pci_enable_device(), which can lead to dropped writes or master aborts.
--

--- Patch [3]: [PATCH v4 3/9] ipack: tpci200: don't store pci_device_id ---
commit eed0a798b7390c20259769af7ca3dfe410d112f0
Author: Gary Guo <gary@garyguo.net>
Subject: ipack: tpci200: don't store pci_device_id

This commit removes the stored pci_device_id from the tpci200_infos structu=
re.
Since dynamic IDs are not guaranteed to outlive the probe function, and the
stored ID is unused, removing it prevents potential issues.

> diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tp=
ci200.c
> index 05dcb6675cd66..1cf51f7632932 100644
> --- a/drivers/ipack/carriers/tpci200.c
> +++ b/drivers/ipack/carriers/tpci200.c
> @@ -562,7 +562,6 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
> =20
>  	/* Save struct pci_dev pointer */
>  	tpci200->info->pdev =3D pdev;
> -	tpci200->info->id_table =3D (struct pci_device_id *)id;
> =20
>  	/* register the device and initialize it */
>  	ret =3D tpci200_install(tpci200);

[Severity: High]
This is a pre-existing issue, but I noticed that MMIO configuration registe=
rs
are mapped and accessed before pci_enable_device() is called.

Earlier in tpci200_pci_probe(), the driver maps the configuration memory bar
and immediately accesses the registers to configure byte swapping:

    reg32 =3D ioread32(tpci200->info->cfg_regs + LAS1_DESC);
    reg32 |=3D 1 << LAS_BIT_BIGENDIAN;
    iowrite32(reg32, tpci200->info->cfg_regs + LAS1_DESC);

However, pci_enable_device() doesn't seem to be called until later in the
probe sequence, when tpci200_install() eventually calls tpci200_register():

    if (pci_enable_device(tpci200->info->pdev) < 0)
        return -ENODEV;

Since the memory enable bit in the PCI command register is not guaranteed to
be set by the firmware before probe, accessing MMIO regions before
pci_enable_device() can result in reads returning 0xFFFFFFFF and writes bei=
ng
dropped. On some architectures, this might even trigger a system-crashing
PCI master abort.

Should pci_enable_device() be called earlier in tpci200_pci_probe() before
any MMIO access occurs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723-pci_id_fix=
-v4-0-3580726844e1@garyguo.net?part=3D3
