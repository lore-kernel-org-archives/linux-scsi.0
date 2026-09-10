Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66023B440F;
	Thu, 10 Sep 2026 04:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789015199; cv=none; b=kIBV0ELMr6/HMY/XLemsKk/C2ZCOtAcjz4BIhd5lVx2oTKbF5TPxZG3rsFxMjFrnSgFVeY0KIL4CKVP/pbC241knmdyLYpb/aJWUbfoFOtV/Ago9+KEEAKXJ6FLMyI/2Tckrh3R/epf6Q5y+bq3lbPKiBCtvDz7qDla7ogXdyAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789015199; c=relaxed/simple;
	bh=8D89MCB3nHjpJBF1DLju8b/djUsu+oX+IoBY4ZQa/4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cy08ky4p4+JTpbWj8+21uNx1mIxCK5Pam3eO5teSBf2+eo+Lu1wOzi2jINih5pEX6dQWMtW9OVYeuOlsAdjU7kxuAmBF5krUrHIok1aNma0QmzLWoqlcHA353IjNzlzSw/jtjJG6HkSHR7KGHGYQW312f9Cx25RMe76f5jldRAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wsaslq0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wsaslq0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348021F000FF;
	Thu, 10 Sep 2026 04:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789015187;
	bh=XbQt5KEJfhTVay40KfNhYe40zxdff0NGqKw1M8aYbxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wsaslq0E1rAItoKCteGqEaVs4cAm6Zd/OPrXsNPsXoEUOn16KWR1srQoMKGI7NU+Q
	 5eN9Z54O6IthLY3Gwcuecq2cq/NMVtkudvnMNOHqfWKtGDbewU/MHZehRXT4nAF/lV
	 Vphj8rKMrvNmbzknnqicIZ1agEEiPvY0R01YZ/1iTb48inYQako69hwS6GIzSuvo5S
	 bpnL/m35Souy6UDTSO+ZF5KMemGW3ztW8TsF9XVurapjOJZnLcjcZCqQgHLCH5MwJ4
	 1CNBpN08eY8IuW9nPiCe7/S7XGQivH8Fefud3tUUzlckSg2HyHhYihoVJ5RWfJCKpt
	 Nq4uABvwgnIgA==
Date: Thu, 10 Sep 2026 04:39:44 +0000
From: Yixun Lan <dlan@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org,
	linux-scsi@vger.kernel.org, spacemit@lists.linux.dev
Subject: Re: [PATCH v4 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20260910043944-GKH2330@kernel.org>
References: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
 <20260908-08-k3-ufs-support-v4-2-22aa2bd97d3b@kernel.org>
 <20260908075501.66A4A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260908075501.66A4A1F00A3A@smtp.kernel.org>

Hi All,

On 07:55 Tue 08 Sep     , sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Missing lane 1 configuration for M-PHY tuning attribute 0xe8.
> - [High] The SpacemiT UFS platform driver fails to configure PM (Power Management) operations, breaking system suspend/resume.
> --
> 
> commit e432cf6faf83c7fe0612ce4cb8a3f5d0731598d9
> Author: Yixun Lan <dlan@kernel.org>
> 
> scsi: ufs: spacemit: k3: Add UFS Host Controller driver
>     
> SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> M-PHY v3.0 standard.
> 
> > diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
> > new file mode 100644
> > index 0000000000000..9d037d90ac5e3
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-spacemit.c
> [ ... ]
> > +static int ufs_spacemit_link_startup_post_change(struct ufs_hba *hba)
> > +{
> > +	/* Add 0xe8 make UFS2.1 run GEAR3 + 2Lane@409M */
> > +	static const struct ufshcd_dme_attr_val setup_attrs[] = {
> > +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x97 },
> > +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0xd7 },
> > +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x17 },
> > +		{ UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), UFS_DL_AFC0REQTIMEOUTVAL_MAX },
> > +	};
> 
> [Severity: High]
> Is Lane 1 tuning intentionally omitted here?
> 
> The driver declares support for 2 TX lanes, and the comment mentions
> configuring "2Lane@409M". However, the M-PHY tuning attribute 0xe8 is
> only configured for Lane 0 via UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0).
> 
> Operating in 2-lane mode without applying the same PHY tuning to the
> second lane can cause link instability or negotiation failures. Should
> this also configure Lane 1?
> 
No need, this is false report, the configuration will apply to Lane 1

or anyone has idea to silence this when sending next version?

> [ ... ]
> > +static struct platform_driver ufs_spacemit_pltform = {
> > +	.probe	= ufs_spacemit_probe,
> > +	.remove	= ufs_spacemit_remove,
> > +	.driver	= {
> > +		.name	= "ufshcd-spacemit",
> > +		.of_match_table = of_match_ptr(ufs_spacemit_of_match),
> > +	},
> > +};
> > +module_platform_driver(ufs_spacemit_pltform);
> 
> [Severity: High]
> Does this driver correctly configure power management?
> 
> The platform driver structure does not initialize the pm field in its
> driver sub-structure. Without a valid dev_pm_ops structure, the platform
> bus will not invoke any PM callbacks for this device.
> 
> This means the UFS host controller will not participate in system
> suspend/resume or runtime power management, which can lead to power

The K3 mainline platform lacks low level support for system suspend/resume,
while for runtime power management, I think it's a valid point, and
should be feasible to implement, so will take a look in next version.

> drain or system crashes on resume if the power domain was gated by
> firmware. Should this assign standard UFS PM callbacks to the pm field?
> 

Thanks

-- 
Yixun Lan (dlan)
