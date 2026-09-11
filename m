Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFF043DEB9;
	Fri, 11 Sep 2026 10:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123051; cv=none; b=qEr8jmBNFnqKE3ngTizuWb1kWdXhjia82cFdrGf40yw6GQwS+1Jm2klBX+ajsF5f0gat2A9qglt13WmEAEXpiY6LWXeetspKVn08f0DfoBaC0+zupGClBQyZbYfpLitGNVQMYMOy1v8yv4FJC+VMkF8dYxSkfSVUh9OpbwiP0ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123051; c=relaxed/simple;
	bh=VBC2lzKLOR0XBH4X68w1+Namvmclxm2TD0bZo0z6uVg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VvckzAFTds20mIKkHi0A5MbSxgsqP+T07sSGL7JG6XMteOqnOYM5Fe6ucTHe57pdpN8dGDl3xinD9NNlxYA9YigB/5L7rMi6CB9jtsIHbIixeL7ShpoeZOtGbUeuI7jKr7TfHyf/nrlAPJrF2rfroNICpO3FwW6kc5wlMdZTzkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7SB8sD8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7SB8sD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4431F000FF;
	Fri, 11 Sep 2026 10:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789123041;
	bh=FcdYHnAFD/EmO8GeMPtllmGFtL3bgqr3LjcGUzY0Yi0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B7SB8sD84yiC8jEPrf+LMq7zj7wFpEE5i/cGqM3eL9vBhWm8dMrQYLGm1zXrW6UsJ
	 jVEFfz76/xx4q61Rdme5I/nWlAubnctj8PpyLDwpmIsX1TdnQCTqVZwIYTP5SSRv8s
	 UZTQMsPTXfty0Nxoo39yxJOvx18wydkIXUz9br6BA21fxaoPTE/W7fNinJ90/NWiGM
	 7+oXm/tUKJqOTCEGIPw0gXqcnPfOhKY8falHjhur/g0AAfJGKzu8y9fZBMd4aIYHwy
	 SUPtN7q0Yf+A4REsecgel8VXtBrduwchXthTw23snOc9jCdgiYBdZboZ0BGxPDmUft
	 S6Pemo89Y+7EQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] scsi: ufs: starfive: Add UFS support for
 StarFive JHB100 SoC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Minda Chen" <minda.chen@starfivetech.com>
Cc: linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260911102359.83288-4-minda.chen@starfivetech.com>
References: <20260911102359.83288-1-minda.chen@starfivetech.com>
 <20260911102359.83288-4-minda.chen@starfivetech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 10:37:20 +0000
Message-Id: <20260911103720.AE4431F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Double disable and unprepare of the UFS clock (`ufs_clk`) during d=
river teardown.
- [High] Resource leak of the `phy_reset` line if PHY initialization fails.

Pre-existing issues:
- [High] Data race in `ufs_dwc_phy_reg_write` due to the use of an unprotec=
ted static array.
--

commit 7e44e99d3adeb04d28f12e6d3a13f795f6d5cf86
Author: Minda Chen <minda.chen@starfivetech.com>

scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC

Add support for the UFS host controller on JHB100 SoC, built on
the Synopsys DWC UFS controller and using UFSHCD platform driver.
This controller requires specific configurations like
M-PHY/RMMI/UniPro

> diff --git a/drivers/ufs/host/ufs-starfive.c b/drivers/ufs/host/ufs-starf=
ive.c
> new file mode 100644
> index 0000000000000..fab65da0507e8
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-starfive.c
> @@ -0,0 +1,297 @@

[ ... ]

> +static int ufs_starfive_phy_config(struct ufs_hba *hba, struct ufs_starf=
ive_host *host)
> +{
> +	static struct ufs_dwc_phy_pair_data phy_data[] =3D {
> +		{ RAWAONLANEN_DIG_MPLLA_COARSE_TUNE, 0x51},
> +		{ MPLL_SKIPCAL_COARSE_TUNE, 0x51},
> +		{ RX_AFE_ATT_IDAC(0), 0x8a},
> +		{ RX_AFE_ATT_IDAC(1), 0xc2},
> +		{ RX_AFE_CTLE_IDAC(0), 0x8e},
> +		{ RX_AFE_CTLE_IDAC(1), 0x8b},
> +		{ FAST_FLAGS(0), 0x0004 },
> +		{ FAST_FLAGS(1), 0x0004 },
> +		{ RX_ADAPT_DFE(0), 0xa00},
> +		{ RX_ADAPT_DFE(1), 0xa00},
> +	};
> +	struct ufs_dwc_phy_pair_data *data;
> +	int ret, i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(phy_data); i++) {
> +		data =3D &phy_data[i];
> +		ret =3D ufs_dwc_phy_reg_write(hba, data->addr, data->value);

[Severity: High]
This is a pre-existing issue, but calling ufs_dwc_phy_reg_write() here
appears to expose a data race if multiple Synopsys DWC UFS host controllers
are probed concurrently.

Looking at ufs_dwc_phy_reg_write() in drivers/ufs/host/ufshcd-dwc.c:

int ufs_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
{
	static struct ufshcd_dme_attr_val phy_write_attrs[] =3D {
		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
        ...
	phy_write_attrs[0].mib_val =3D (u8)addr;

Because phy_write_attrs is declared as static and modified before being
passed to ufshcd_dwc_dme_set_attrs(), concurrent invocations will clobber
each other's configuration payloads.=20

Can this cause undefined device behavior or link startup failures if multip=
le
controllers execute PHY initialization simultaneously?

> +		if (ret)
> +			return ret;
> +	}

[ ... ]

> +static int ufs_starfive_phy_init(struct ufs_hba *hba)
> +{

[ ... ]

> +	ret =3D reset_control_deassert(host->phy_reset);
> +	if (ret) {
> +		dev_err(hba->dev, "Failed to reset phy\n");
> +		return ret;
> +	}
> +
> +	ret =3D regmap_read_poll_timeout(host->syscon,
> +				       SRAM_STATUS, val,
> +				       (val & SRAM_INIT_DONE),
> +				       MPHY_POLL_INTERVAL_US,
> +				       MPHY_POLL_TIMEOUT_US);
> +	if (ret) {
> +		dev_err(hba->dev, "wait sram init done timeout\n");
> +		return ret;
> +	}

[ ... ]

> +	host->phy_init =3D 1;
> +
> +	return 0;
> +}

[ ... ]

> +static int ufs_starfive_init(struct ufs_hba *hba)
> +{

[ ... ]

> +	host->ufs_clk =3D devm_clk_get_enabled(&pdev->dev, "main");
> +	if (IS_ERR(host->ufs_clk))
> +		return dev_err_probe(dev, PTR_ERR(host->ufs_clk),
> +				     "Failed to get ufs clock\n");

[ ... ]

> +static void ufs_starfive_exit(struct ufs_hba *hba)
> +{
> +	struct ufs_starfive_host *host =3D ufshcd_get_variant(hba);
> +
> +	if (host->phy_init) {
> +		reset_control_assert(host->phy_reset);
> +		host->phy_init =3D 0;
> +	}

[Severity: High]
Could this leak the phy_reset line in a deasserted state if initialization
fails partway through?

If ufs_starfive_phy_init() successfully deasserts host->phy_reset, but a
subsequent operation (like regmap_read_poll_timeout()) fails, it returns
early and leaves host->phy_init as 0.=20

When the probe rollback path subsequently calls ufs_starfive_exit(), it sees
host->phy_init =3D=3D 0 and skips asserting the reset line.=20

Is it possible this leaves the hardware in an invalid state that prevents
subsequent driver probe retries from succeeding?

> +	clk_disable_unprepare(host->ufs_clk);

[Severity: High]
Will this result in an unbalanced clock disable during driver teardown?

In ufs_starfive_init(), host->ufs_clk is acquired using
devm_clk_get_enabled(). This API automatically registers a devres action th=
at
calls clk_disable_unprepare() when the driver is unbound.

By explicitly calling clk_disable_unprepare(host->ufs_clk) here in
ufs_starfive_exit(), it seems this might disable the clock a second time wh=
en
the devres framework fires its cleanup action, triggering a kernel warning.

> +
> +	reset_control_assert(host->core_reset);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911102359.8328=
8-1-minda.chen@starfivetech.com?part=3D3
