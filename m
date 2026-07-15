Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69BC3C73D1;
	Wed, 15 Jul 2026 19:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784144260; cv=none; b=tkRNeUVkiLfRLLzHTpXTB28pGa6dnlHiEqNpzjdFcAPB5I8mwNHAZoLUnR7uqx62A6f58XVpsUgy7RqlFDstYITRk/CdfWsEmvBQIzmDFQybbe+w9T3hPKjoeXvZi4hQQ11yhcTudSgI86FqvP6Q72tdq2xpovXAVwIZry4yZjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784144260; c=relaxed/simple;
	bh=4BEtU4wiqU+aBvjn8s7nMdU7nqmEYCO63VdONWhijIo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JxbM5ZeqW0EzektwIaobDr5oABQ5XTjsLn2mHEttEEijxlLiV87R7Xbb0KS2SSJnFVbaokyX9+sPazHAPkJik4auS+mLvZhaDcHZVSdd4QolOjWhmCTHHYEOwqtS+0bMEijjvreCTJZZs5eNcqYyPzEC2YOfebprgiSSSrjsmP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDvkxjwR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDvkxjwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016F91F000E9;
	Wed, 15 Jul 2026 19:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784144258;
	bh=mXpaazYLNH34l2HdedoU6q3i0c0+Y5y5GzaslqvkYak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KDvkxjwR+7Qt2mvm2y9xgNoRjrjQA0VbibcXsH8eNR38C24zB3kRTiHjm9scKZta/
	 07FLIMc7SPUbV7J3wKD2sgl7b2lAe9bAMQprKubGekRKinCQGYE9K0QhCBx7IWfHH3
	 8PQDW4stpvBPKI/XzVH0/wevbCgnHYLwr4WV01P8xMzgI98yecJAoa+gL9hsJNmJTW
	 SNHGfNrmJm75yOVEGYSlf9m/+VCt5dygiIgm+4GmCZC69ZcP/zJxvfpLW2zm+rgbrT
	 JTd/Alz3Q4UuVtFzzMqZHq/OEcaQ7aPwBjuRX6DRZUASYcEg7PsUVKLippRUuQePGY
	 nJe9FEBeVDe4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] PCI: Move pci_dev->is_busmaster into priv_flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Maurice Hieronymus" <mhi@mailbox.org>
Cc: linux-scsi@vger.kernel.org, ojeda@kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260714-pci-dev-flags-v2-1-a1d7dc441cf3@mailbox.org>
References: <20260714-pci-dev-flags-v2-1-a1d7dc441cf3@mailbox.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 19:37:37 +0000
Message-Id: <20260715193738.016F91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprotected C bitfield read-modify-write via sysfs corrupts PCI de=
vice state flags.
- [High] Concurrent execution of `pci_disable_device()` and `pci_set_master=
()` causes hardware/software state desynchronization and hardware RMW races.
--

--- Patch [1]: [PATCH v2] PCI: Move pci_dev->is_busmaster into priv_flags -=
--
commit 4e686d57a3e3e72847de4f3f8c7555be3dc32c14
Author: Maurice Hieronymus <mhi@mailbox.org>

PCI: Move pci_dev->is_busmaster into priv_flags

This commit moves the is_busmaster bit from the C bitfield in struct
pci_dev to the atomic priv_flags bitmap to prevent concurrent update issues.
It exposes accessor functions for outside users and prepares for
the Rust device enabling API rework.

Link: https://lore.kernel.org/rust-for-linux/DJOEYVBS17MJ.1YD3TNGQBWHNK@ker=
nel.org/ [1]

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c

[ ... ]

> @@ -4120,7 +4147,7 @@ static void __pci_set_master(struct pci_dev *dev, b=
ool enable)
>  			enable ? "enabling" : "disabling");
>  		pci_write_config_word(dev, PCI_COMMAND, cmd);
>  	}
> -	dev->is_busmaster =3D enable;
> +	pci_dev_assign_busmaster(dev, enable);
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does this actually make
concurrent execution of pci_disable_device() and pci_set_master() safe?

While the software flag is now atomic, the hardware read-modify-write on
the PCI_COMMAND register appears to remain unsynchronized.

If Thread A calls do_pci_disable_device() in drivers/pci/pci.c and reads
PCI_COMMAND with MASTER=3D0, and concurrently Thread B calls=20
__pci_set_master(true), reads PCI_COMMAND with MASTER=3D0, writes MASTER=3D1
to hardware, and sets the software flag, would Thread A skip its hardware
write but still proceed to clear the software flag?

Could this desynchronization leave bus mastering enabled in hardware while
software considers it disabled, potentially risking rogue DMA?

> diff --git a/include/linux/pci.h b/include/linux/pci.h
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -461,7 +461,6 @@ struct pci_dev {
>  	unsigned int	pref_64_window:1;	/* Pref mem window is 64-bit */
>  	unsigned int	multifunction:1;	/* Multi-function device */
> =20
> -	unsigned int	is_busmaster:1;		/* Is busmaster */
>  	unsigned int	no_msi:1;		/* May not use MSI */
>  	unsigned int	block_cfg_access:1;	/* Config space access blocked */
>  	unsigned int	broken_parity_status:1;	/* Generates false positive parity=
 */

[Severity: High]
This is a pre-existing issue, but does leaving broken_parity_status in this=
 C
bitfield leave the remaining flags vulnerable to torn writes?

In drivers/pci/pci-sysfs.c, broken_parity_status_store() locklessly
modifies this bitfield when a privileged user writes to sysfs. If this
runs concurrently with kernel operations updating other flags in the
same memory word (like pci_cfg_access_lock() setting block_cfg_access),
could torn writes silently clear critical state flags such as
block_cfg_access or msi_enabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714-pci-dev-fl=
ags-v2-1-a1d7dc441cf3@mailbox.org?part=3D1
