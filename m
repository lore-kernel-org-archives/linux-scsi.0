Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D545A530E14;
	Wed,  9 Sep 2026 11:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951749; cv=none; b=evyhCReb4sgCOdQxqVAptt4d4tbD5ocN4Mb+nb4ieh2FXYASBLMyXu2r/PTtseKvx9kzUg7ECESUDru04yACnDNx9bdap7vsqIHsg1n3fodXjn1qCDozuNXk3yBUcpHPHoqx59NPP8C8uoWJQ4H7t9lQgNaAGGyR2upu83ApNLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951749; c=relaxed/simple;
	bh=nfJgHbhd5gDMfjOZq4mkG685m5GPgQiYgYBfvxizHMA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i+x5SGZm5XwuivZ9dzzuAn0ww1xmiKXzTunzmDeF5VveBc1DLgKT/Xz9IAAFgjM0cJmD4S1M8itz5f5r3kbNkZ7z5QJ7jBBQYd+8tybT/VFJTYMC2ewy9uuRMKdXIdeqZDHrvMYA1zYPPIdr176bK8cB79G8LoV/aV322g43Vzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9IIzfBp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9IIzfBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144521F00A3E;
	Wed,  9 Sep 2026 11:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788951738;
	bh=mPWCYQAFk8tuMF3T+TRRNR9WoG+fstFyZBgB8JuSlTk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I9IIzfBpDd7J49iq199htWkYjwnr8JfRV0v/0sbQVct5wRQUW0oWmjP5t1jlWq77G
	 c0aRMLr60Kb0TY2hPwRrK8g2puw1Ehr5CnLbTlZR820ElbIA0aNATOSpNKWfMQh2/S
	 ytYZhTAiOsjO4+NZY30p6eaesani8oi9/z+/O22YApkANMENdxsU7SeFnZI4IG3Ep0
	 kd9AD5c92kizwQnwgWkCH555+n1kbey+4PxbdFWUbbxJcufP/8pU1VHQEw9EIxouU6
	 ZCDW3h3WL9h3GsQ8OJgJsGBA3rS5NmJ/ksSEPau+hA8tsl7cCBRawwzTESJJPVazuG
	 PDkJ1AzLjjkkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kartik Rajput" <kkartik@nvidia.com>
Cc: robh@kernel.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260909-tegra264-ufs-v1-4-e4a9831702a0@nvidia.com>
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
 <20260909-tegra264-ufs-v1-4-e4a9831702a0@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 11:02:17 +0000
Message-Id: <20260909110218.144521F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Medium] Referencing a non-existent Kconfig symbol `PHY_TEGRA_MPHY` in `s=
elect`.
- [Medium] Unmet dependency risk due to unconditionally selecting a potenti=
ally architecture-specific symbol in a driver that supports `COMPILE_TEST`.
- [Medium] Integer truncation of the 5.84 GHz clock rate on 32-bit architec=
tures during `COMPILE_TEST`.
- [Medium] Hardware PHY teardown sequence incorrectly uses forward setup or=
der instead of reverse.
--

commit ba95657952b3e5dc9efe191a253d2fb49a5a1f66
Author: Kartik Rajput <kkartik@nvidia.com>
Subject: scsi: ufs: tegra: Add Tegra264 UFS host controller driver

This commit adds a new UFS host controller driver for NVIDIA Tegra264 SoCs.
It implements Tegra-specific auxiliary registers, clocks, and resets, and
drives four M-PHY lane directions.

> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index ff170c0b6da0c..e4c565fce53cc 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -168,3 +168,16 @@ config SCSI_UFS_AMD_VERSAL2
[ ... ]
> +config SCSI_UFS_TEGRA
> +	tristate "NVIDIA Tegra264 UFS controller platform driver"
> +	depends on SCSI_UFSHCD_PLATFORM && (ARCH_TEGRA_264_SOC || COMPILE_TEST)
> +	select PHY_TEGRA_MPHY

[Severity: Medium]
Does the PHY_TEGRA_MPHY symbol exist in the kernel tree? If not, selecting =
it
here will cause silent build failures or leave features disabled.

[Severity: Medium]
Additionally, since this driver supports COMPILE_TEST, does unconditionally
selecting an architecture-specific PHY risk triggering unmet dependency
warnings on unsupported architectures during cross-compilation?

> diff --git a/drivers/ufs/host/ufs-tegra.c b/drivers/ufs/host/ufs-tegra.c
> new file mode 100644
> index 0000000000000..859fe0af66e51
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-tegra.c
[ ... ]
> +#define UFSHC_AUX_DEV_CTRL			0x14
> +#define DEV_CTRL_CLK_EN				BIT(0)
> +#define DEV_CTRL_RESET				BIT(1)
> +
> +#define UFS_TEGRA_PHY_CLK_HS_RATE_HZ		5840000000UL

[Severity: Medium]
Is this literal too large for a 32-bit unsigned long? The literal requires
33 bits, but when COMPILE_TEST is enabled on 32-bit architectures, this
value will be truncated.

[ ... ]
> +static void ufs_tegra_mphy_exit(struct ufs_hba *hba)
> +{
> +	struct ufs_tegra *ufs =3D ufshcd_get_variant(hba);
> +
> +	phy_exit(ufs->mphy_l0_rx);
> +	phy_exit(ufs->mphy_l0_tx);
> +	phy_exit(ufs->mphy_l1_rx);
> +	phy_exit(ufs->mphy_l1_tx);
> +}

[Severity: Medium]
Does this exit sequence incorrectly mirror the forward initialization order?
Standard resource teardown typically reverses the initialization sequence to
prevent state corruption or lockups upon driver unbind or runtime suspend.

[ ... ]
> +static void ufs_tegra_mphy_power_off(struct ufs_hba *hba)
> +{
> +	struct ufs_tegra *ufs =3D ufshcd_get_variant(hba);
> +
> +	phy_power_off(ufs->mphy_l0_rx);
> +	phy_power_off(ufs->mphy_l0_tx);
> +	phy_power_off(ufs->mphy_l1_rx);
> +	phy_power_off(ufs->mphy_l1_tx);
> +}

[Severity: Medium]
Similarly, does this power off sequence execute in exact forward
initialization order instead of reverse?

[ ... ]
> +static int ufs_tegra_pwr_change_notify(struct ufs_hba *hba,
> +				       enum ufs_notify_change_status status,
> +				       struct ufs_pa_layer_attr *dev_req_params)
> +{
[ ... ]
> +	if (dev_req_params->hs_rate =3D=3D PA_HS_MODE_A ||
> +	    dev_req_params->hs_rate =3D=3D PA_HS_MODE_B) {
> +		err =3D clk_set_rate(ufs->phy_clk, UFS_TEGRA_PHY_CLK_HS_RATE_HZ);

[Severity: Medium]
The clk_set_rate() API takes an unsigned long for the rate. Does passing
the 33-bit UFS_TEGRA_PHY_CLK_HS_RATE_HZ literal cause an implicit narrowing
conversion and incorrect clock rate configuration on 32-bit systems?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-tegra264-u=
fs-v1-0-e4a9831702a0@nvidia.com?part=3D4
