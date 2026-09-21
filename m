Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F3723ED6A;
	Mon, 21 Sep 2026 12:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994814; cv=none; b=Pq//mmanIYFvfKXaW3fNyR7soaoCDxPitNflK+dl2Q3iBN3yGezA2+HELZhPhfTtHJtbJZslaAYm+B87XYG9KRk5xao7idceBkQgFixlDg448gdx3LGfJsml4hv4xsp9L3Rjt4Usp55ukNqq/ZS7k0eMFQsNuFAJQGSKy7b5uQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994814; c=relaxed/simple;
	bh=VWROF5rMnLxIv6yaV5I/hcyJrirDn5lUDNS1ZbnLRtA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iP/OJXkcPu4TYQGRPGUAptuf7TM5xLgKVfsRJcdhYEBjajP3hZjKF2QYqchAA6Gp6un1cmWxcht0gAkneALkiA7JjYku4KnKyHBSXoS7mdCslVG8Qvet8epG4zXvgshmjnxAZZuV3JJL1HnK149qiTNh65B/rxZ9kfGKt/uMd6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YC3g74Wn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YC3g74Wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2201F000FF;
	Mon, 21 Sep 2026 12:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789994813;
	bh=4AbSvDBRyOAgWltLVD3lVukwVwcxMqCkrKQxO0z5+G4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YC3g74Wna2dbJ+LtEfOFQiYw1+kbL0YM/1Qwi5M5uYQb1FxDTPqZ5E49JZ4h0yioP
	 5uUI0WvBmsKS2qyAhXd0VM2wPCilF1R914jMQ2DSFrW/IIXtmoTZ/WcjATrY4TZ647
	 kL9a0Vem8PFMsyuAerUuh2p+OmJgyEt11Jacv2gt7Zn0dnHzOPwRLGwOIqlCi2lSm7
	 suqeSvVHUXpcE1z0rgAw7k4Vdkp2S192M3WsfHVErJ02HOvzXYhC8FOzsL5Ar5xBAJ
	 mHC+rvyArQ2ju2Mgl31Ig9ng5ZK4fHwbnvbPM7WqAdFjumrqyfUEe2Ci2AC2lIm0p/
	 QLKOGl5+WlUIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: conor+dt@kernel.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org
In-Reply-To: <20260921-08-k3-ufs-support-v6-2-3479768a2299@kernel.org>
References: <20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org>
 <20260921-08-k3-ufs-support-v6-2-3479768a2299@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 12:46:52 +0000
Message-Id: <20260921124652.AF2201F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] scsi: ufs: spacemit: missing M-PHY TX EQ configuration for lane 1
- [Medium] scsi: ufs: spacemit: unchecked return value from quirk configura=
tion
--

commit 16f84e82c7f6101530a90dc4cc7509a53d6ac1b4
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: k3: Add UFS Host Controller driver

This commit introduces the UFS host controller driver for the SpacemiT K3
SoC. It implements the vendor-specific configurations and initialization
sequences required to interact with the M-PHY and UniPro hardware.

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 0000000000000..941506cc5ab68
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c

[ ... ]

> @@ -211,6 +211,9 @@ static int ufs_spacemit_uniprov1p6_init(struct ufs_hb=
a *hba)
> +		/* RX HB8_TIME CAP */
> +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x64 },
> +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x64 },
> +		/* TX EQ 3DB */
> +		{ UIC_ARG_MIB_SEL(0x00CD, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),  0x5 },

[Severity: Medium]
The TX EQ 3DB attribute is explicitly configured for lane 0, but the
corresponding configuration for lane 1 (UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1))
is missing in ufs_spacemit_uniprov1p6_init(), unlike other dual-lane
attributes in this array.

Can this missing equalization on lane 1 cause signal integrity issues and a
high error rate on the second TX lane, potentially degrading performance or
causing transmission failures unconditionally during the UniPro initializat=
ion
sequence when the device operates in 2-lane mode?

> +		/* RX garbage cnt =3D 32 SI */
> +		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x9F },
> +		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x9F },
> +	};

[ ... ]

> @@ -401,6 +401,9 @@ static int ufs_spacemit_apply_dev_quirks(struct ufs_h=
ba *hba)
> +	int err;
> +
> +	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
> +		ufs_spacemit_quirk_host_pa_saveconfigtime(hba);

[Severity: Medium]
The return value of ufs_spacemit_quirk_host_pa_saveconfigtime() is neither
assigned nor checked in ufs_spacemit_apply_dev_quirks(), ignoring potential
DME access errors.

If the PA_SaveConfigTime quirk configuration fails, could the error be
silently ignored, causing the device to operate with an invalid timing
configuration and leading to link instability or failure when a device
requiring UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME is initialized?

> +
> +	if (hba->dev_info.wmanufacturerid =3D=3D UFS_VENDOR_WDC)
> +		hba->dev_quirks |=3D UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921-08-k3-ufs-=
support-v6-0-3479768a2299@kernel.org?part=3D2
