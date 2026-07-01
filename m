Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4A643CEF7;
	Wed,  1 Jul 2026 11:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782904246; cv=none; b=hUNcgFcYgb7igTwJhG8ETFheDf9E/3zohnxNMC4dKfRv/gRUKQhwtnNFc4Ce82nwBa1rvMbYV6IHoRkBk4X5y0ToEJKvGayiul7bouB0Y+mk7D/DvJZqWcGfhHYOwoTFutww0xjUhLUjMMEWOm+dQBLhUlqdrpFEwQx9zGj8/jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782904246; c=relaxed/simple;
	bh=QWAVi50WMZwXz0yhGj1fsiaAPcfcpJRAC5VrTxEk+Fc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HY6PqFbcth5mi9gbcnt2WM4qEDCLBHUasy21m9SpiXZMorUArrcTrG2NLTS1HrtDL45TQLe/PGlmsFvME1sAkC8K+ys9VEesG5G3b933AcSsGTnSYjSfcAwAN4Fxt+WfU8mKt3KKEAk9aRUuUGYjckvj6jMlXIb+nHBpcMG74vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fFzgP/wV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fFzgP/wV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD291F000E9;
	Wed,  1 Jul 2026 11:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782904244;
	bh=jv82hzrEsRwzOLA2fjJoHxWoif9iXecsWbOjfNcGyjw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fFzgP/wV3KS8RByguiShkKTTC5ojIsNoOfD1II9hSXxi3A9uFLz8aim9HnxlmMx1Q
	 YKK6ZDoWLyXpmpDu4AjM2efn1AbUIwOnKqF81stf0F5yW3O90ZQF8lkdjGoW+jhyza
	 3Gs7jKSxEH2JfNhKlxeZs+sBvYr9eTweZMHWZ1ODof3UkXO0rw9DLNAUU4cJ1a0NkI
	 6mJbbIAKwwW150Td+M+mXm7fvIryMRdeNd6VpOB4mHXq1qGa1o2lJiECHHOrgt/ajE
	 dYY5is2CsVpj8rlDE84QWnLLLoFpBkxTZ/DfO4FLRldI5cDamc5P+AxpOzimoVdFZx
	 Z5H1TDwZSUhKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/7] ipack: tpci200: don't keep pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-scsi@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260630-pci_id_fix-v2-3-b834a98c0af2@garyguo.net>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-3-b834a98c0af2@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 11:10:43 +0000
Message-Id: <20260701111044.3DD291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] MMIO registers are accessed before the PCI device is enabled.
--

commit 30f524f5c4f44d8d3fe4dc97ba1c44684c0fe834
Author: Gary Guo <gary@garyguo.net>

ipack: tpci200: don't keep pci_device_id

This commit removes the unused pci_device_id table from the tpci200_infos
structure. The stored ID is unnecessary as dynamic IDs may not outlive
the probe function.

> diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tp=
ci200.c
> index 05dcb6675cd66..1cf51f7632932 100644
> --- a/drivers/ipack/carriers/tpci200.c
> +++ b/drivers/ipack/carriers/tpci200.c
> @@ -562,7 +562,6 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
> =20
>  	/* Save struct pci_dev pointer */

[Severity: High]
This is a pre-existing issue, but does this probe function access
memory-mapped configuration registers before the PCI device is enabled?

Looking at tpci200_pci_probe() in drivers/ipack/carriers/tpci200.c,
we can see MMIO accesses happening just before this block:

drivers/ipack/carriers/tpci200.c:tpci200_pci_probe() {
	...
	reg32 =3D ioread32(tpci200->info->cfg_regs + LAS1_DESC);
	reg32 |=3D 1 << LAS_BIT_BIGENDIAN;
	iowrite32(reg32, tpci200->info->cfg_regs + LAS1_DESC);
	...
}

Since pci_enable_device() is not called until later down the call chain
in tpci200_register() (called via tpci200_install()), PCI_COMMAND_MEMORY
may not be set.

This can result in ignored writes, reading junk data (all 1s), and on
many architectures, it triggers a machine check exception, SError, or
kernel panic due to an Unsupported Request (UR) on the PCIe bus.

>  	tpci200->info->pdev =3D pdev;
> -	tpci200->info->id_table =3D (struct pci_device_id *)id;
> =20
>  	/* register the device and initialize it */
>  	ret =3D tpci200_install(tpci200);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630-pci_id_fix=
-v2-0-b834a98c0af2@garyguo.net?part=3D3
