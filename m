Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A4E1C5D5E;
	Fri,  2 Oct 2026 03:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790910376; cv=none; b=pCAEuQWb+QOWhda2OjZIXbK0r2kYjhSFb/t39UWCQMZktjc5L8uoTlmoR5iDSza7QFt3GL83cf7R5bqGu8/Pn12Q050z6K1Og02UElLQe6d0L8OVpjm+elNUP4rKJQ4Iq7rHUIauICJLR4RzJJk5CmRiPiDOUQzrzJe8Qy47T6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790910376; c=relaxed/simple;
	bh=oAwuRKh00IONPA+rvwAu8qtOhpyvxCrtbPvNTzsGGls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nfr3Us3WMMPlO1mSlb/ft/kQ01RTKyATee88ApgJeJ3csheekUS1kFT/PHI7kxEBdqyIwEbKGW4Kbp5nI5pyeBGhLR+W9AycR1B419NG+K+pbcqOLUp4KO1gFZ7vuvI+Kh0gh3mkBexAnbkpZPOxCrgJBgv2hRkfdwyc1HPDrpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFNBLgcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFNBLgcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8026B1F00893;
	Fri,  2 Oct 2026 03:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790910374;
	bh=RDka1zA21dVd1416/IcxvzoMzp3YA9EEJUMJC3MFjhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QFNBLgcq5wKOo9AZs3TZFPld5HYa60SIMUSoUqZ1JYyxwysCTiwsaF46UOZFaioYT
	 PgGpmCfPOdDnf4cCQDJ/hNprbBsl4j3Vq8YNbBiRRdlrB7cd10ys8ZVJep4C01cgfX
	 ajJ/sQL2LAMHemGUrKLhYkFQQbHxNgAhGtwPkbXHykDqDHrJPnuoVGNXCdgM79WT0M
	 YqWpdJphUj5CRVxHn2eJcn55Kt5T4MzPXydBYRQohVg0cx/v1T+dMRrk20/yxCdJj6
	 szayJ4nfsXJPecZfz3jfgaNX8iAHCN/oKHZmbJSxVvbMlco7hUcCaA5lkaK5xcVrG8
	 Ag2Ik2p3eu46Q==
Date: Fri, 2 Oct 2026 03:06:12 +0000
From: Yixun Lan <dlan@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: conor+dt@kernel.org, devicetree@vger.kernel.org,
	linux-scsi@vger.kernel.org, robh@kernel.org
Subject: Re: [PATCH v6 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20261002030612-GKC51329@kernel.org>
References: <20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org>
 <20260921-08-k3-ufs-support-v6-2-3479768a2299@kernel.org>
 <20260921124652.AF2201F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260921124652.AF2201F000FF@smtp.kernel.org>

Hi ALL,

On 12:46 Mon 21 Sep     , sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] scsi: ufs: spacemit: missing M-PHY TX EQ configuration for lane 1
> - [Medium] scsi: ufs: spacemit: unchecked return value from quirk configuration
> --
> 
> commit 16f84e82c7f6101530a90dc4cc7509a53d6ac1b4
> Author: Yixun Lan <dlan@kernel.org>
> 
> scsi: ufs: spacemit: k3: Add UFS Host Controller driver
> 
> This commit introduces the UFS host controller driver for the SpacemiT K3
> SoC. It implements the vendor-specific configurations and initialization
> sequences required to interact with the M-PHY and UniPro hardware.
> 
> > diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
> > new file mode 100644
> > index 0000000000000..941506cc5ab68
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-spacemit.c
> 
> [ ... ]
> 
> > @@ -211,6 +211,9 @@ static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
> > +		/* RX HB8_TIME CAP */
> > +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x64 },
> > +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x64 },
> > +		/* TX EQ 3DB */
> > +		{ UIC_ARG_MIB_SEL(0x00CD, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),  0x5 },
> 
> [Severity: Medium]
> The TX EQ 3DB attribute is explicitly configured for lane 0, but the
> corresponding configuration for lane 1 (UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1))
> is missing in ufs_spacemit_uniprov1p6_init(), unlike other dual-lane
> attributes in this array.
> 
> Can this missing equalization on lane 1 cause signal integrity issues and a
> high error rate on the second TX lane, potentially degrading performance or
> causing transmission failures unconditionally during the UniPro initialization
> sequence when the device operates in 2-lane mode?
ignore this comment, the configuration will also apply to lane 1

> 
> > +		/* RX garbage cnt = 32 SI */
> > +		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x9F },
> > +		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x9F },
> > +	};
> 
> [ ... ]
> 
> > @@ -401,6 +401,9 @@ static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
> > +	int err;
> > +
> > +	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
> > +		ufs_spacemit_quirk_host_pa_saveconfigtime(hba);
> 
> [Severity: Medium]
> The return value of ufs_spacemit_quirk_host_pa_saveconfigtime() is neither
> assigned nor checked in ufs_spacemit_apply_dev_quirks(), ignoring potential
> DME access errors.
> 
I will add a check and abort if it fails

> If the PA_SaveConfigTime quirk configuration fails, could the error be
> silently ignored, causing the device to operate with an invalid timing
> configuration and leading to link instability or failure when a device
> requiring UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME is initialized?
> 
> > +
> > +	if (hba->dev_info.wmanufacturerid == UFS_VENDOR_WDC)
> > +		hba->dev_quirks |= UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE;
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org?part=2

-- 
Yixun Lan (dlan)
