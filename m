Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93852931CD
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785857525; cv=none; b=LV9PBQds8T7YLl6X/DWxzAFTmg2dvABv8PLOJS+Z1viSyAzkOP+SVqaRGP1gv/UCCNpSll4VyTPjbpNMAO7eODJ9zv2jCZcQ+b7FV/2b20a3p8eouYWfDQlVdjsr7GeBidVDSR8HmntTZDLrefnydP67MfBk7y2//NYjyILdI5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785857525; c=relaxed/simple;
	bh=jpTt0NOt1sWYF4Oduqlz4B6fVcMnE0O/yecHEc0IwJo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZqvKNKanIxAm+kLoeTgVZ6ETOksdWz8i/ywSNhcs3qBIwuyzxJ1ccWRdRH+q1ROUIO5nfVGiJcu31xvByNNP9+QIcPnnYMaLn9gDpoxKjscwDIeCwtHTx7DJE/JGckgTROPlLpwOZGpSMv6DYVEO0nyRHfRO+p/GLClkB4lFCxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWkvjpqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWkvjpqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD251F000E9;
	Tue,  4 Aug 2026 15:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785857523;
	bh=ByTfuI/V7sv9qHOsSML7wcFm7Ibrp3O9nfgJ2Q1gloE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SWkvjpqq8MwNe5yoKBSya9FZW2aSoXfVQPDDq67GnSC/f3m6cz6V3aYC0YMuwwqUn
	 Xr9pVBihFoOM/D2tcOzBcVhJqnaWzW5Rqzy43aB3UYXN2DBZpSwgMCIchDeAAV6LFw
	 LFqHHqMfxwN6kGGycv+75b+RFDIvEVNTm5hZYSt/gph9PpGaYzQ5f3KjFYfaMR5IFC
	 lCgH1rntZfzh2F9cmYaN8YiZf5UugZPP5bmRYOj4EGqFy5I6P50svAHImKIffPHhIq
	 9vc2rrtfOalX9hGp3opCHjzeYUeiFainC3x5KeECOJNWTWrK/1OOXfvRS43pPshryY
	 CgOpdDYndU51Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] firmware: xilinx: ufs: move PHY/SRAM ready polling into
 the firmware backend
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michal Simek" <michal.simek@amd.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <eaeaaea8ed76069943e0706a0917139ff6569929.1785855749.git.michal.simek@amd.com>
References: <eaeaaea8ed76069943e0706a0917139ff6569929.1785855749.git.michal.simek@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 15:32:02 +0000
Message-Id: <20260804153203.5CD251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The patch makes per-read primitives static and un-exports them, =
contradicting the commit message claim that they stay exported.
- [Medium] The refactoring regresses error handling by grouping lower-level=
 firmware transport failures under hardware-specific timeout error messages.
--

--- Patch [1]: [PATCH] firmware: xilinx: ufs: move PHY/SRAM ready polling i=
nto the firmware backend ---
commit e824b853b832156de7cffafd5b473161a8e6545d
Author: Michal Simek <michal.simek@amd.com>

firmware: xilinx: ufs: move PHY/SRAM ready polling into the firmware backend

This commit moves the open-coded do/while polling loops for UFS PHY and SRA=
M=20
initialization into coarse blocking helpers in the firmware driver. It=20
introduces zynqmp_pm_wait_mphy_tx_rx_config_ready() and=20
zynqmp_pm_wait_sram_init_done() to keep the UFS controller backend-agnostic.

> Introduce coarse blocking helpers, zynqmp_pm_wait_mphy_tx_rx_config_ready=
()
> and zynqmp_pm_wait_sram_init_done(), that take a caller-supplied timeout
> budget and contain the poll loop. The loop is EEMI-specific (legacy
> firmware only exposes the per-read status primitive) so it lives in the
> firmware driver, keeping the UFS driver backend-agnostic: a future
> backend can offload the wait to the platform in a single call without
> touching the controller driver again. The existing per-read primitives st=
ay
> exported, so the current EEMI interface is unchanged.

[Severity: Medium]
The commit message indicates that "The existing per-read primitives stay
exported, so the current EEMI interface is unchanged." However, the code
modifications below make these functions static and remove their prototypes.
Is it intentional to un-export these primitives, contrary to the commit
message?

> diff --git a/drivers/firmware/xilinx/zynqmp-ufs.c b/drivers/firmware/xili=
nx/zynqmp-ufs.c
> index 85da8a822f3a5..81ccf61a037ce 100644
> --- a/drivers/firmware/xilinx/zynqmp-ufs.c
> +++ b/drivers/firmware/xilinx/zynqmp-ufs.c

[ ... ]

> @@ -33,7 +34,7 @@
>   *
>   * Return:	Returns 0 on success or error value on failure.
>   */
> -int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
> +static int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
>  {
>  	u32 regval;
>  	int ret;
> @@ -53,7 +54,6 @@ int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
> =20
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(zynqmp_pm_is_mphy_tx_rx_config_ready);

[ ... ]

> @@ -61,7 +61,7 @@ EXPORT_SYMBOL_GPL(zynqmp_pm_is_mphy_tx_rx_config_ready);
>   *
>   * Return:	Returns 0 on success or error value on failure.
>   */
> -int zynqmp_pm_is_sram_init_done(bool *is_done)
> +static int zynqmp_pm_is_sram_init_done(bool *is_done)
>  {
>  	u32 regval;
>  	int ret;
> @@ -81,7 +81,69 @@ int zynqmp_pm_is_sram_init_done(bool *is_done)
> =20
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(zynqmp_pm_is_sram_init_done);

[ ... ]

> diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-am=
d-versal2.c
> index 2154d62868171..dff0c2c954865 100644
> --- a/drivers/ufs/host/ufs-amd-versal2.c
> +++ b/drivers/ufs/host/ufs-amd-versal2.c

[ ... ]

> @@ -235,23 +233,15 @@ static int ufs_versal2_phy_init(struct ufs_hba *hba)
>  		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>  	};
> =20
> -	/* Wait for Tx/Rx config_rdy */
> -	time_left =3D TIMEOUT_MICROSEC;
> -	do {
> -		time_left--;
> -		ret =3D zynqmp_pm_is_mphy_tx_rx_config_ready(&is_ready);
> -		if (ret)
> -			return ret;
> -
> -		if (!is_ready)
> -			break;
> -
> -		usleep_range(1, 5);
> -	} while (time_left);
> -
> -	if (!time_left) {
> +	/*
> +	 * Wait for Tx/Rx config_rdy. The poll loop lives in the firmware
> +	 * backend (EEMI today, SCMI in future) so this driver stays
> +	 * backend-agnostic; the timeout budget stays here with the consumer.
> +	 */
> +	ret =3D zynqmp_pm_wait_mphy_tx_rx_config_ready(TIMEOUT_MICROSEC);
> +	if (ret) {
>  		dev_err(hba->dev, "Tx/Rx configuration signal busy.\n");
> -		return -ETIMEDOUT;
> +		return ret;
>  	}

[Severity: Medium]
Will this change result in misleading error logs if a firmware transport
error occurs?

In the original code, if zynqmp_pm_is_mphy_tx_rx_config_ready() failed with=
 a
transport error like -EIO, the function returned silently. The
"Tx/Rx configuration signal busy" error was only logged when the timeout
actually expired.

With this update, if zynqmp_pm_wait_mphy_tx_rx_config_ready() returns -EIO,
it seems we will incorrectly log "Tx/Rx configuration signal busy." instead
of propagating the transport failure silently.

>  	ret =3D ufshcd_dwc_dme_set_attrs(hba, rmmi_attrs, ARRAY_SIZE(rmmi_attrs=
));
> @@ -264,23 +254,11 @@ static int ufs_versal2_phy_init(struct ufs_hba *hba)
>  		return ret;
>  	}
> =20
> -	/* Wait for SRAM init done */
> -	time_left =3D TIMEOUT_MICROSEC;
> -	do {
> -		time_left--;
> -		ret =3D zynqmp_pm_is_sram_init_done(&is_ready);
> -		if (ret)
> -			return ret;
> -
> -		if (is_ready)
> -			break;
> -
> -		usleep_range(1, 5);
> -	} while (time_left);
> -
> -	if (!time_left) {
> +	/* Wait for SRAM init done (poll handled by the firmware backend). */
> +	ret =3D zynqmp_pm_wait_sram_init_done(TIMEOUT_MICROSEC);
> +	if (ret) {
>  		dev_err(hba->dev, "SRAM initialization failed.\n");
> -		return -ETIMEDOUT;
> +		return ret;
>  	}

[Severity: Medium]
Similarly, if zynqmp_pm_wait_sram_init_done() returns a generic firmware
transport error, will it now misleadingly print "SRAM initialization failed=
."
rather than bubbling up the underlying error?

[ ... ]

> diff --git a/include/linux/firmware/xlnx-zynqmp-ufs.h b/include/linux/fir=
mware/xlnx-zynqmp-ufs.h
> index d3538dd5822a5..00383dd835f24 100644
> --- a/include/linux/firmware/xlnx-zynqmp-ufs.h
> +++ b/include/linux/firmware/xlnx-zynqmp-ufs.h
> @@ -9,17 +9,17 @@
>  #define __FIRMWARE_XLNX_ZYNQMP_UFS_H__
> =20
>  #if IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
> -int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready);
> -int zynqmp_pm_is_sram_init_done(bool *is_done);

[Severity: Medium]
Is it intentional to remove these prototypes from the public header, despite
the commit message mentioning that the per-read primitives stay exported?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/eaeaaea8ed76069943e=
0706a0917139ff6569929.1785855749.git.michal.simek@amd.com?part=3D1
