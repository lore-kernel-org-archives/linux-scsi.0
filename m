Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831906FBF;
	Fri,  3 Jul 2026 01:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783042084; cv=none; b=R5nlfY8ImthLqCLSNSnCcaHlS6Eeue+X9IWEWI1/CWWtnHOCFWViLgN+X0gnLCsvqOXi6hGT8WT7mu3HF3zGK4eMgEIFyH7Zer83C0kn1Oed1D6Z2yl2x46+4nAI4+Gc/NCAO8e06jZ4nAgFUnY3KRT3XDf3374l3S8BrJpfc1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783042084; c=relaxed/simple;
	bh=MUBvwv5+qEDS6F9yzR9TIwGgOKaDH1YKncy/OHf2mP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CjFu88AX/wGeXOJ9RIkukWe7i8p7bPTWLXDxS+qzGDwEnY0Lz7MtoAx9ihsfZK5JAXuQf01E71/rvVhuW9PnuPrpIm52YWAV2wItkmE6vdC0z5rjJ+4N9ZSyUPY/y3q8aclP0/s43Bw6YBeIdzMw5ZabG+8N+GP4ulcS4tfsbn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TT0sywZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TT0sywZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDDE1F000E9;
	Fri,  3 Jul 2026 01:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783042083;
	bh=0eXGKOcKQVdU/sbnJjxGRITWvo+67g14j4Em8TkDCvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TT0sywZD2HYWh3962wb2Zk7EFaRUAkSkh8KYupweqLXhoGcHxJC/ftAv+XD3uz/oL
	 yB6EGIyqj8DjKp9sgh6Sg7wD+CycIhRZtn/ZuFwTjj5osNGk6WXj0Yx0mTogfV7Py7
	 WOuL31iMTiW25Swp2w4nr8gW5ehQTCOr8lPmzv9pXDAyG/lVgLFrxLMLbpq6H6eDZF
	 M2s1yOH7D9PW5kZ6dOhr5mkwVVLvu8ks1acPWETCoKdLrDc+shDHScUms8ACZmrE8L
	 wZythJEl7kTS3xNOK1q4GVfYDGZsqSn6YmKNVYLwte5fS5UYIrKQBzlHyDy7SzZDK7
	 RVHk3MWL5Q/oA==
Date: Fri, 3 Jul 2026 01:28:00 +0000
From: Yixun Lan <dlan@kernel.org>
To: Yao Zi <me@ziyao.cc>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20260703012800-GKC35811@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
 <akaeBJv5T3YmlfpC@pie>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <akaeBJv5T3YmlfpC@pie>

Hi Yao,

On 17:21 Thu 02 Jul     , Yao Zi wrote:
> On Thu, Jul 02, 2026 at 02:31:36AM +0000, Yixun Lan wrote:
> > SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> > which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> > M-PHY v3.0 standard.
> > 
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > ---
> >  drivers/ufs/host/Kconfig        |  12 +
> >  drivers/ufs/host/Makefile       |   1 +
> >  drivers/ufs/host/ufs-spacemit.c | 931 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/ufs/host/ufs-spacemit.h |  90 ++++
> >  4 files changed, 1034 insertions(+)
> 
> ...
> 
> > +static int ufs_spacemit_wait_mphy_pll_lock(struct ufs_hba *hba)
> > +{
> > +	int timeout = MPHY_PLL_LOCK_TIMEOUT_US;
> > +	u32 val;
> > +
> > +	while (timeout-- > 0) {
> > +		val = ufshcd_readl(hba, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> > +		if (val & MPHY_PLL_LOCK_BIT)
> > +			return 0;
> > +
> > +		udelay(1);
> > +	}
> > +
> > +	dev_err(hba->dev, "M-PHY PLL lock timeout\n");
> > +	return -ETIMEDOUT;
> > +}
> 
> Could this loop be replaced by read_poll_timeout() like
> 
> 	read_poll_timeout(ufshcd_readl, val, val & MPHY_PLL_LOCK_BIT,
> 			 1, MPHY_PLL_LOCK_TIMEOUT_US, false, hba,
> 			 UFS_PHY_MSG_BASE + UFS_MPHY_PU_CTRL);
> 
I think so, thanks for the suggestion

> 
> ...
> 
> > +/**
> > + * ufs_spacemit_init - init phy and prepare clk
> > + * @hba: host controller instance
> > + */
> > +static int ufs_spacemit_init(struct ufs_hba *hba)
> > +{
> > +	int err = 0;
> > +	struct device *dev = hba->dev;
> > +	struct ufs_spacemit_host *host;
> > +
> > +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> > +	if (!host)
> > +		return -ENOMEM;
> > +
> > +	host->rst = devm_reset_control_get_optional_exclusive_deasserted(dev, NULL);
> 
> "resets" property is marked as required in the binding, but the optional
> API is used here. Is this expected?
> 
Ok, I will switch to non-optional API and check return value

> ...
> 
> > +/**
> > + * ufs_spacemit_hce_enable_notify - Configure HCE enable sequence
> > + * @hba: host controller instance
> > + * @status: notification status (PRE_CHANGE or POST_CHANGE)
> > + *
> > + * Configures host controller enable with proper sequencing.
> > + * Handles crypto enable if supported.
> > + *
> > + * Returns: 0 on success
> > + */
> > +static int ufs_spacemit_hce_enable_notify(struct ufs_hba *hba,
> > +					  enum ufs_notify_change_status status)
> > +{
> > +	struct ufs_spacemit_host *host = ufshcd_get_variant(hba);
> > +	u32 enable_val, val;
> > +
> > +	if (status == PRE_CHANGE) {
> > +		enable_val = CONTROLLER_ENABLE;
> > +
> > +		if (hba->caps & UFSHCD_CAP_CRYPTO)
> > +			enable_val = CRYPTO_GENERAL_ENABLE | CONTROLLER_ENABLE;
> > +
> > +		if (!host->first_hce_done) {
> > +			host->first_hce_done = true;
> > +			dev_dbg(hba->dev, "First HCE enable\n");
> > +		} else {
> > +			val = ufshcd_readl(hba, REG_CONTROLLER_ENABLE);
> > +			if (val == enable_val) {
> > +				ufshcd_writel(hba, enable_val & (1 << CONTROLLER_ENABLE),
> > +					      REG_CONTROLLER_ENABLE);
> > +
> > +				while (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) ==
> > +				       (enable_val & (1 << CONTROLLER_ENABLE)))
> > +					;
> 
> Shouldn't we set a timeout for the polling loop?
> 
Yes, good idea and will do in next version

-- 
Yixun Lan (dlan)
