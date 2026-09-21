Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C8147CC71;
	Mon, 21 Sep 2026 09:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983698; cv=none; b=eeuoDW+sS6N8ccgRCjXkFnF9oJxEFBr6noJR4fUxpp4e8aA0W5hRAZ4yNUg+bKTKpO20dlNvyZf/HvtZMnFWS1uHfwzaEEhWe2VH174NeicmGRHhRUhY4kUMna8ON1xfvu0MDLoQ9Wr+aq/kzN3jBegm5IsA8M3qyzxRg40Lz4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983698; c=relaxed/simple;
	bh=MJ+xEW52TjywRhwxyFDVIBqFTTQfEIN7C8X1wWow78M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TlUZxUeNg7nmbybJy9DUyzas6naB7uWLWECuux6qYTtnsSBUl90KHfqWPlU1STmYzvGErZB8U4raa/JiDHCANn/VPPeUliiXTGEiaMD8h1jrna9gcOPCZcphPjxl3U5EXGN5iXRTSFdHeWhf6zVOdy03/snqAe5zPGIACtF5PR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4eLRehz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4eLRehz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600441F00893;
	Mon, 21 Sep 2026 09:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789983696;
	bh=QHZ7RZbtDUTSVET/tmRibcujY6+y4hUCkc+X3EXjmpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z4eLRehzEveBRSIUWvxhkJcFhB8j26avtsaeKTp70gepwopW+7LJYdxscWWFaBYPs
	 P0VRkLypOQxlrEVFCcerntaJnTe5JOpMYnsRbyfJNaVjyY0TRXiWW5MCVK+2R1KUN+
	 VWESH0A/IWIZehS8jrSyLxIY5bOGaDnl58gJGmQWEtPrOKSn0+VTP4MYMlb/mtAKz0
	 grH0T/no3PHZMJ4tbgODSxDVSYan9VD4+0cTNguWF3x4eProe2PvKyJ/vRkuEZUtPN
	 7as4Y6z5TFzLZ/b5V9axILY5wtaoE0ahp9Gg49ljjO64zLJG9kJdTwRe6BvmVYzR1F
	 5nRNdcPvYk57A==
Date: Mon, 21 Sep 2026 09:41:34 +0000
From: Yixun Lan <dlan@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: conor+dt@kernel.org, devicetree@vger.kernel.org, robh@kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20260921094134-GKB292047@kernel.org>
References: <20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org>
 <20260916-08-k3-ufs-support-v5-2-1f5d71f1027d@kernel.org>
 <20260916031008.5C1911F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260916031008.5C1911F000FF@smtp.kernel.org>

Hi ALL,

On 03:10 Wed 16 Sep     , sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] scsi: ufs: missing M-PHY attributes configuration for lane 1
> - [Low] scsi: ufs: dead code via unused struct ufs_spacemit_host
> - [Low] scsi: ufs: unused macros and magic numbers in M-PHY config
> --
> 
> commit 82db4e922a94ed053811c2ea8440617bd6a94d08
> Author: Yixun Lan <dlan@kernel.org>
> Subject: scsi: ufs: spacemit: k3: Add UFS Host Controller driver
> 
> This commit adds the UFS Host Controller driver for the SpacemiT K3 SoC.
> The hardware features are compatible with JEDEC UFS 2.2, MIPI UniPro v1.61, 
> and M-PHY v3.0 standards.
> 
> > diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
> > index 0000000000000..179e6edb2ac25
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-spacemit.c
> 
> [ ... ]
> 
> > +static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
> > +{
> > +	static const struct ufshcd_dme_attr_val setup_attrs[] = {
> > +		{ UIC_ARG_MIB(0x1552), 0x4f }, /* PA_TXHSG1SYNCLENGTH */
> > +		{ UIC_ARG_MIB(0x1553), 0xf }, /* PA_TXHSG1PREPARELENGTH */
> > +		{ UIC_ARG_MIB(0x1554), 0x4f }, /* PA_TXHSG2SYNCLENGTH */
> > +		{ UIC_ARG_MIB(0x1555), 0xf }, /* PA_TXHSG2PREPARELENGTH */
> 
> [Severity: Low]
> Is there a reason the raw hex literals are used here instead of the
> macros like PA_TXHSG1SYNCLENGTH and PA_TXHSG1PREPARELENGTH that were
> explicitly defined at the top of the file?
> 
I found there are some macros defined in incude/ufs/unipro.h already
I will use them while leave others unchanged which not defined in global

I will also drop local macros from this drivers for now, it's probably
better to promote them into global header, but I'd prefer to do it in
a separate patch

> [ ... ]
> 
> > +		/* TX HB8_TIME CAP */
> > +		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x64 },
> > +		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0x64 },
> > +		/* RX HB8_TIME CAP */
> > +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x64 },
> > +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x64 },
> > +		/* TX EQ 3DB */
> > +		{ UIC_ARG_MIB_SEL(0x00CD, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),  0x5 },
> > +		/* RX garbage cnt = 32 SI */
> 
> [Severity: High]
> Should the TX EQ 3DB attribute also be configured for lane 1 here? The
> surrounding attributes (like TX/RX HB8_TIME CAP and RX garbage cnt) properly
> target both lanes 0 and 1. 
> 
> If lane 1 is left asymmetrically configured, could this lead to PHY link
> instability, CRC errors, or failure to maintain high-speed gears in a 2-lane
> setup?
> 
false report, the configuration will actually apply to lane 1 too, so ignore

> > +		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x9F },
> > +		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x9F },
> > +	};
> > +
> > +	return ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> > +}
> 
> [ ... ]
> 
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
> Does this workaround need to be applied to lane 1 as well? The inline comment
> explicitly documents this as a "2Lane" workaround, but the configuration is
> only applied to lane 0 via UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0).
> 
ditto, wil ignore 

> [ ... ]
> 
> > +static int ufs_spacemit_pwr_change_notify(struct ufs_hba *hba,
> > +					  enum ufs_notify_change_status status,
> > +					  struct ufs_pa_layer_attr *dev_req_params)
> > +{
> > +	struct ufs_spacemit_host *host = ufshcd_get_variant(hba);
> > +	int ret = 0;
> > +
> > +	if (!dev_req_params) {
> > +		dev_err(hba->dev, "Invalid Parameters\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	switch (status) {
> > +	case PRE_CHANGE:
> > +		break;
> > +	case POST_CHANGE:
> > +		/* Cache the power mode parameters to use internally */
> > +		memcpy(&host->dev_req_params, dev_req_params, sizeof(*dev_req_params));
> 
> [Severity: Low]
> Are the cached power mode parameters used elsewhere in the driver? We are
> copying dev_req_params into host->dev_req_params here, but the structure
> field doesn't appear to be read anywhere else.
> 
it's true, I will drop this cache parameters ..

> [ ... ]
> 
> > +static int ufs_spacemit_init(struct ufs_hba *hba)
> > +{
> > +	struct device *dev = hba->dev;
> > +	struct ufs_spacemit_host *host;
> > +	struct reset_control *rst;
> > +
> > +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> > +	if (!host)
> > +		return -ENOMEM;
> 
> [Severity: Low]
> Since the ufs_spacemit_host structure is only written to and never read, do
> we need to allocate this memory during initialization, or is there some
> planned functionality missing that was supposed to consume it?
>
I think this due to massive cleanup from vendor driver, but I would keep
it as is for now, for easy to implement vendor specific feature.

> > +
> > +	rst = devm_reset_control_get_exclusive_deasserted(dev, NULL);
> 
> [ ... ]
> 
> > diff --git a/drivers/ufs/host/ufs-spacemit.h b/drivers/ufs/host/ufs-spacemit.h
> > index 0000000000000..5e459f6ba243c
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-spacemit.h
> 
> [ ... ]
> 
> > +/* ATOP base*/
> > +#define UFS_ATOP_BASE			0x1C00
> > +
> > +#define UFS_SYSCLK			499
> 
> [Severity: Low]
> Is this UFS_SYSCLK macro intended to be used? It doesn't appear to be
> referenced anywhere in the implementation.
> 
will drop it

> > +#define UFS_TX_SYMBO_CLK		0x800
> > +#define UFS_MAX_LINKSTARTUP_TIMER	0xFFFFFFFF
> > +#define UFS_DL_AFC0REQTIMEOUTVAL_MAX	0xFFFF
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org?part=2

-- 
Yixun Lan (dlan)
