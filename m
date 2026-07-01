Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D423B6BE3;
	Wed,  1 Jul 2026 11:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782904254; cv=none; b=YU2QnEDoa5lPB2afti17MGuQyJA1921iskZpxO9nd97lFy/IYkzWyq9W0qICBvRky2+e32S8kl78eMRh1YLsy7UlQwAdCeAmWPPz0RF36ye18HZ1bv4mlxxiL4kqGcHBIYpxxT/xfSLI1GZxvri2apgRmRUVNcOdbXy8t8Kil5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782904254; c=relaxed/simple;
	bh=/JszStEefe+59OzMpCh3/UdR9ik2m4NjOqjsHGz0OrQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MUYWAOWgOqCJpXN8UGTG++gIRZWCpEJTGKIrurmIi89Qu9wUJU0+WAs3Mjmv0M+SwFpoigXSeSTRifJal7e3SVa3uZ2A0zSyU2/OpLHTHBA+tZdDtBU18n5b0r8irPOdnW2XHf9+pULORRzfjH8Y7b/xfXC6L9Wdvpkj4wxPAZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctC0KpN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctC0KpN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E04E1F00A3A;
	Wed,  1 Jul 2026 11:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782904252;
	bh=+QFqAxv8syvMpFMYuAM1dG2hrLQEDLrQnncPdAO3mjY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ctC0KpN84JxpWcpZNzDaaso8ut2K24+TNpvnNl1nvgRC4QMXQ7Kxvv/OiBfDJgB2x
	 VYOQeNYM1NXKeJUNVtGKkpiEtBLykrx2J/FHb2pOKgySuRr6SQSJ7PsnzK04IVX1Vg
	 GtUMq0CD80R/FDKmTi0L8mv7+sxUp5BQ0BCuvw7o9GVqi1y4HiuAZcmVmlKdepYph3
	 xUKap+r0eGkcYxm0dC9qEtPG/UnLlujXcoJKUKlBV3SIXmswk3u/TUOVP7dTcxNj2p
	 zuwJp6ohg+eP3kHzN4RkZsaXhfoBwEpaDD6m5LZE2HXmO/dljOCUEebRiMqMx/6qNT
	 8UbKiHKP2R8Hg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/7] pci: fix UAF when probe runs concurrent to dyn
 ID removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-scsi@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260630-pci_id_fix-v2-7-b834a98c0af2@garyguo.net>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-7-b834a98c0af2@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 11:10:51 +0000
Message-Id: <20260701111052.3E04E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The `id` parameter passed to PCI driver probe functions is now a p=
ointer to a stack-allocated variable, breaking drivers that rely on pointer=
 arithmetic to calculate indices or that cache the pointer.
--

commit 0cf7c75b08e81435f8eec9e2453a6dda8624a99b
Author: Gary Guo <gary@garyguo.net>
Subject: pci: fix UAF when probe runs concurrent to dyn ID removal

This commit modifies the PCI matching logic to copy the matched device ID
instead of returning a pointer to it. This ensures dynamic IDs are safely
handled without requiring the lock to be held during probe.

Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.o=
rg/

> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c

[ ... ]

> @@ -465,15 +470,14 @@ void pci_probe_flush_workqueue(void)
>   */
>  static int __pci_device_probe(struct pci_driver *drv, struct pci_dev *pc=
i_dev)
>  {
> -	const struct pci_device_id *id;
> +	struct pci_device_id id;
>  	int error =3D 0;
> =20
>  	if (drv->probe) {
>  		error =3D -ENODEV;
> =20
> -		id =3D pci_match_device(drv, pci_dev);
> -		if (id)
> -			error =3D pci_call_probe(drv, pci_dev, id);
> +		if (pci_match_device(drv, pci_dev, &id))
> +			error =3D pci_call_probe(drv, pci_dev, &id);

[Severity: High]
Does passing a pointer to the stack-allocated id variable here break drivers
that rely on the pointer belonging to their static id_table?

Some drivers compute an array index using pointer arithmetic against the
provided id pointer. For example, in drivers/char/agp/amd-k7-agp.c:

agp_amdk7_probe() {
    ...
    j =3D ent - agp_amdk7_pci_table;
    dev_info(&pdev->dev, "AMD %s chipset\n",
             amd_agp_device_ids[j].chipset_name);
    ...
}

Since the pointer now points to the stack frame in __pci_device_probe()
rather than the static table, won't this pointer subtraction yield a
wildly out-of-bounds index and cause a memory read fault during device
probing?

>  	}
>  	return error;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630-pci_id_fix=
-v2-0-b834a98c0af2@garyguo.net?part=3D7
