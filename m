Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59A431B833;
	Sun, 12 Jul 2026 15:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783869715; cv=none; b=hNtTgW0ZPtLaxLMhJ0C+Y2lFtqYmd6sJNgYHw41sKnGpw0n3/lfX1by51Ru6Dlkx39Gt6gq3mP/C9jTzXZjvTkytYPLumroBoGTWpYTRR/FpNqRPZfCRZcDeZIL/BXYNHXUQWzW4IGkjHY6bLFY1I25f3hgpHdJs4QP+ZmORYmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783869715; c=relaxed/simple;
	bh=Wm/bHExqwt1VMbL9+4z9VSyjwuMuIZ7z6Im4hl2j1+0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E4Q8dZOL6wR2j0c5HGVf66YWGZUuaJaP/Q2FFHNtZNXbCOtnmYiSRyTlPsykFgc6PyfwoWP6sM1eXwAdIfjEBnypjqpHZezP1ShOCjku4CnNZGqhpDVdJhYkdi2X8VtctXWogl6xiV4Z/yvP/AeATOxVsKZto3kB9gjoXjlw4UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNduJ6vf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNduJ6vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A531F00A3D;
	Sun, 12 Jul 2026 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783869714;
	bh=RTcyfWxMVXuc4zI8ECGHPeEhb8FuUVVIHmsboUSAx4c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cNduJ6vf5HNrlZuikX0WG5Mw77oW2Kf7Wk5NBwRFoYdoeE59xwgZ6DFRWc4oO6Pe1
	 OaLsPEzftFZE7RT/apigLhUC52/m4Tyc1GviEdiW7aHS00LmMEN0ejq740J0HyhKk1
	 5aGaMPmnZ6/iHIe79ENOnguvDErsYjriKft4i42QbJuEPHbof2E/C7H7ATdhwItHY2
	 ymwDnEp8M725t2nLZ2/LdFkwHPWwLndni+KkiU/+eC5MQr9Pj4IbiyTVOqVAgjI2tC
	 pn+LtPHVR1CH0pA6rUA6IppAPQbENN7nHhER/cfNdtpc8ydabHMMqidBQ1S7Dik4ID
	 NLNWPHLUPKAEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] PCI: Replace pci_dev->broken_parity_status with
 accessors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Maurice Hieronymus" <mhi@mailbox.org>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, ojeda@kernel.org
In-Reply-To: <20260711-pci-dev-flags-v1-2-2fcf2811138c@mailbox.org>
References: <20260711-pci-dev-flags-v1-0-2fcf2811138c@mailbox.org>
 <20260711-pci-dev-flags-v1-2-2fcf2811138c@mailbox.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 12 Jul 2026 15:21:53 +0000
Message-Id: <20260712152154.24A531F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete fix: other sysfs store methods modify C bitfields witho=
ut locks, leaving identical read-modify-write (RMW) tearing races unaddress=
ed.
--

--- Patch [2]: [PATCH 2/2] PCI: Replace pci_dev->broken_parity_status with =
accessors ---
commit 0e6499959d43880d6cf73511e1681afc56300aa3
Author: Maurice Hieronymus <mhi@mailbox.org>

PCI: Replace pci_dev->broken_parity_status with accessors

This patch moves the broken_parity_status bit into a flags bitmap
modified with atomic bitops. This prevents read-modify-write tearing races
when sysfs writers race with other kernel updates to the same machine word.

> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 5ec0b245a69bd..5e094d1e23e3e 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c

[ ... ]

> @@ -93,7 +93,7 @@ static ssize_t broken_parity_status_store(struct device=
 *dev,
>  	if (kstrtoul(buf, 0, &val) < 0)
>  		return -EINVAL;
> =20
> -	pdev->broken_parity_status =3D !!val;
> +	pci_dev_assign_broken_parity_status(pdev, val);

[Severity: High]
This is a pre-existing issue, but does this leave other identical
read-modify-write tearing races unaddressed in this same file?

For example, in d3cold_allowed_store(), there is a lockless assignment:

drivers/pci/pci-sysfs.c:d3cold_allowed_store() {
    ...
    pdev->d3cold_allowed =3D !!val;
    ...
}

This bitfield shares a machine word with ignore_hotplug. If a sysfs write
races with a GPU driver calling pci_ignore_hotplug() during runtime PM,
could the kernel's update be lost? If the ignore_hotplug bit is torn, the
PCI hotplug controller might unexpectedly remove the GPU when it enters
D3cold, causing a kernel panic upon resume.

Similarly, msi_bus_store() locklessly assigns:

drivers/pci/pci-sysfs.c:msi_bus_store() {
    ...
    pdev->no_msi =3D !val;
    ...
}

This shares a word with msi_enabled. If this tears msi_enabled, could it
cause IRQ leaks when freeing vectors?

Another instance is pci_write_rom() locklessly assigning:

drivers/pci/pci-sysfs.c:pci_write_rom() {
    ...
    pdev->rom_attr_enabled =3D enable;
    ...
}

Would it make sense to also migrate d3cold_allowed, no_msi, and
rom_attr_enabled to this new atomic flags bitmap?

> =20
>  	return count;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260711-pci-dev-fl=
ags-v1-0-2fcf2811138c@mailbox.org?part=3D2
