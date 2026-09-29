Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3E34F96BD;
	Tue, 29 Sep 2026 10:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676489; cv=none; b=tfiXLr/DjwMfniSOWAe1vvSn7leI3DkV/KUCJRKY+0wgaEg19xmW17XNPg8+3ajGNHwFxQmisLAHHL9TSeDH1iKMAUVdi4lJ6u1tUhOWYq5OJ1ErhyQ8jFr/C74kIOifK2esOMOkn+5o7+ZntpNKtA2TiP6Nn0sN/PnOh+PpzPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676489; c=relaxed/simple;
	bh=FXH8iGoR6cMjAywh9HbeuWGuTLG7tro3JZdXsminjRc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uYqEZn5nkoZp/xVidd6uWCQxAWJb/+58RmRJI3nDygpDsmP9BrehfTUbb3uTzkYd7UotoLC+wqH8Q60x5s94UiiQ90Ex54i9bwFRVBo+gAMd3falIAfR0bSkIxqzAOxK7LRyguug4kd7uUfWJsupkIHDZ5wbMcBBAT2VFFAqeTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQA9ewvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQA9ewvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DDE1F000FF;
	Tue, 29 Sep 2026 10:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790676469;
	bh=FW3F0lLIlaKCC8WhBPATmO6jrxmFcobjzZxy8dREMO4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GQA9ewvLWYQB9WUnlcmuxtSx4c6FTlgbIUG3O7l5frRi8vWuYdaunora6YLNgMr+D
	 tcXkn9DYL00GI3fN7ZgE48aGvBIkK34u4ij+hLa52JKqt5kwlnFAT1blOzBMyyy5hE
	 DeuJYYiUB1afsfglfH7s6FVFVq7euNrZaPQS7M22KpEp24O8M6HlXY+ned3FdGM280
	 twl1kMdULSMvQ5nWlJoPqosqKFM5SbtZXyY2L1wnIsCgShtF8IX2BJd5BC/fONIozi
	 DIuyW6jf5OehjPHV4ixAfi86EecUnMYNXhcrZJQ3DfMqtLoxEyVWcZLWbdXwrD+Grm
	 fjRFgvKgKyBlA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: tegra: Add Tegra264 UFS host
 controller driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kartik Rajput" <kkartik@nvidia.com>
Cc: robh@kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260929-tegra264-ufs-v2-4-f0467b9c503e@nvidia.com>
References: <20260929-tegra264-ufs-v2-0-f0467b9c503e@nvidia.com>
 <20260929-tegra264-ufs-v2-4-f0467b9c503e@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 10:07:48 +0000
Message-Id: <20260929100749.37DDE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] ufs: tegra: missing hardware reset assertion in teardown path
- [Medium] ufs: tegra: missing dummy readl() after writel() to guarantee de=
lay timing and ordering
--

commit 1b8e042f5d752753eca62f28d9beaa880236dcb0
Author: Kartik Rajput <kkartik@nvidia.com>

scsi: ufs: tegra: Add Tegra264 UFS host controller driver

Add a driver for the UFS host controller found on NVIDIA Tegra264 SoCs.
The controller has Tegra-specific auxiliary registers, clocks and resets,
and it drives the four M-PHY lane directions exposed by the Tegra264
M-PHY driver.

> diff --git a/drivers/ufs/host/ufs-tegra.c b/drivers/ufs/host/ufs-tegra.c
> new file mode 100644
> index 0000000000000..f122654325924
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-tegra.c
[ ... ]
> +static void ufs_tegra_configure_aux(struct ufs_hba *hba)
> +{
> +	struct ufs_tegra *ufs =3D ufshcd_get_variant(hba);
> +	u32 value;
> +
> +	value =3D readl(ufs->aux + UFSHC_AUX_DEV_CTRL);
> +	value |=3D DEV_CTRL_CLK_EN;
> +	writel(value, ufs->aux + UFSHC_AUX_DEV_CTRL);
> +
> +	/* Let the reference clock stabilise before deasserting device reset. */
> +	usleep_range(1000, 2000);

[Severity: Medium]
Memory-mapped peripheral writes via writel() provide CPU ordering but do not
guarantee that the write has reached the interconnect. Does this sleep begin
without guaranteeing the clock enable write has reached the peripheral?

Without a dummy readl() to flush the posted write, the CPU can proceed while
the write is still buffered, causing the timing delay to execute prematurel=
y.

> +
> +	value |=3D DEV_CTRL_RESET;
> +	writel(value, ufs->aux + UFSHC_AUX_DEV_CTRL);
> +}
> +
> +static void ufs_tegra_aux_init(struct ufs_hba *hba)
> +{
> +	struct ufs_tegra *ufs =3D ufshcd_get_variant(hba);
> +	u32 value;
> +
> +	value =3D readl(ufs->aux + UFSHC_AUX_DEV_CTRL);
> +	value &=3D ~(DEV_CTRL_CLK_EN | DEV_CTRL_RESET);
> +	writel(value, ufs->aux + UFSHC_AUX_DEV_CTRL);
> +
> +	/* Ensure the clear is observed before we re-enable. */
> +	usleep_range(100, 200);

[Severity: Medium]
Similarly here, does this sleep begin without guaranteeing the clear operat=
ion
has reached the peripheral? A dummy readl() might be needed to flush the
posted write before delaying.

> +
> +	ufs_tegra_configure_aux(hba);
> +}
[ ... ]
> +static int ufs_tegra_hce_enable_notify(struct ufs_hba *hba, enum ufs_not=
ify_change_status status)
> +{
> +	struct ufs_tegra *ufs =3D ufshcd_get_variant(hba);
> +	u32 value;
> +	int err;
> +
> +	switch (status) {
> +	case PRE_CHANGE:
> +		err =3D ufs_tegra_power_up_sequence(hba);
> +		if (err)
> +			return err;
> +
> +		/* Assert device reset; POST_CHANGE releases it via
> +		 * ufs_tegra_configure_aux() so the HCE toggle pulses it.
> +		 */
> +		value =3D readl(ufs->aux + UFSHC_AUX_DEV_CTRL);
> +		value &=3D ~DEV_CTRL_RESET;
> +		writel(value, ufs->aux + UFSHC_AUX_DEV_CTRL);
> +		break;

[Severity: Medium]
Does this write need to be flushed before returning? Without flushing the
auxiliary write, the core driver proceeds to write REG_CONTROLLER_ENABLE.
The HCE toggle might beat the reset assertion, causing hardware initializat=
ion
failures.

> +	case POST_CHANGE:
[ ... ]
> +static void ufs_tegra_exit(struct ufs_hba *hba)
> +{
> +	ufs_tegra_mphy_disable(hba);
> +}

[Severity: Medium]
Does this teardown function lack a call to reset_control_bulk_assert()?

The hardware resets are initially deasserted in ufs_tegra_init() via
reset_control_bulk_deassert(). However, the teardown callback
ufs_tegra_exit() misses the matching assertion. The API
devm_reset_control_bulk_get_exclusive() only releases the references but do=
es
not auto-assert the reset lines upon unbind.

This leaves the UFS host controller hardware unquiesced (active) when the
driver is unbound, potentially leading to state issues on kexec or power
leaks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929-tegra264-u=
fs-v2-0-f0467b9c503e@nvidia.com?part=3D4
