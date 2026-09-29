Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA114EBAE0;
	Tue, 29 Sep 2026 10:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790677304; cv=none; b=PN1hU+uMeIv5bF/Hn0UUNODzP5a+5b7T4Zsom+EefBqbsMvKNfoxSTbhk6+IN9wHs02FndAuWYzrHFKV+o+DfHI1Uq8zvXQS2QbdIg8Mfa1K5O3WX0/d0S7FtUPYntfeZlj0nVlLAZHgmF4TYnEmjuDPbpdgUYyrZpFxcKIVjHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790677304; c=relaxed/simple;
	bh=mxf/hWbAS/t6nBfEDUIR0gDfSn1DX6nZ4eirA7URNIk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CjzUKNflvLkZMwEvw+OrDHbieQn9SAeJE0a+n68Nth7BqxqlIEuoDsWgXaC5u2RVMIicPSTw7RJR4f64Xv6fn7YQ4zkgMH5czLj7Lk/qETnwzkN2p9LBvYLKAjhc7d3X3nq4mADQcIqre59/sRRjjZDCwfAv6HFP1pe0XTl08F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZxx21c4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZxx21c4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35F71F00893;
	Tue, 29 Sep 2026 10:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790677303;
	bh=JAgXzEH3RCvnF1tk8UjPrVitXFc0UPEOfuFk6xIpceM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SZxx21c4XNdDMRQA9bIBzWjtjTTKH9lJ0XlkJ+AiVTfz1/8rivVqBtPI/CasCmrhd
	 v6I/NxmSsY1v6q6BiLwnYRDeaM9LdgrVHwQ4ihIJrcz1oUsHYrte7Rn5n6baguf+b5
	 sy7ltbia44gijqw4qqFRst/BejRSbBruS2FNTTZIVCSSVXOtLZrCnan/QwnTf3B+vC
	 vOL8EyYmaM+o+FBq1JKtZdinYoTsXOShazfdEFG2GtLUVHpHh1EniZO/1aUvslUiZq
	 GCjeAm+tP7UbwMZvyht+IwGaeZqtRuSBZqYEsU+0ACOMTjsn2oVv+3LWYTJ6Y3hcEA
	 uweJN9hyz1a9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 09/12] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Larisa Grigore" <larisa.grigore@oss.nxp.com>
Cc: conor+dt@kernel.org, linux-scsi@vger.kernel.org, Frank.Li@kernel.org, robh@kernel.org, devicetree@vger.kernel.org, imx@lists.linux.dev
In-Reply-To: <20260929100946.693962-10-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
 <20260929100946.693962-10-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 10:21:42 +0000
Message-Id: <20260929102142.A35F71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ufs: core_clk remains permanently enabled during PM suspend stat=
es
--

commit aea859e7e22ef8d785ddf1572d56548e903ae544
Author: Larisa Grigore <larisa.grigore@oss.nxp.com>
scsi: ufs: Add NXP S32N79 UFS host controller driver

This commit adds support for the UFS host controller on the NXP S32N79 SoC,
built on the Synopsys DesignWare architecture. It introduces platform glue
and specific initialization routines for clock scaling, M-PHY calibration,
and device hibernation transitions.

> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-=
s32n7.c
> new file mode 100644
> index 0000000000000..5374662763b6e
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c
[ ... ]
> +static int ufs_s32n7_init(struct ufs_hba *hba)
> +{
[ ... ]
> +	/*
> +	 * The core reference clock is not managed by the UFS core (the DT node
> +	 * has no clock-names/freq-table-hz, so it is never added to
> +	 * hba->clk_list_head).
> +	 */
> +	ufs->core_clk =3D devm_clk_get_enabled(dev, NULL);
> +	if (IS_ERR(ufs->core_clk))
> +		return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
> +				     "Failed to get and enable core clock.\n");
> +
> +	ufshcd_set_variant(hba, ufs);
> +
> +	return 0;
> +}
[ ... ]
> +static const struct dev_pm_ops ufs_s32n7_pm_ops =3D {
> +	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
> +	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
> +	.prepare	=3D pm_sleep_ptr(ufshcd_suspend_prepare),
> +	.complete	=3D pm_sleep_ptr(ufshcd_resume_complete),
> +};

[Severity: Medium]
Because the core clock is unconditionally enabled via devm_clk_get_enabled()
in ufs_s32n7_init() and is explicitly excluded from the UFS core's PM logic,
will this clock remain permanently enabled across all low-power states?

Since these power management ops map directly to the generic UFS core hooks
and the UFS variant ops don't implement suspend or resume callbacks, there
does not appear to be a mechanism to disable ufs->core_clk during system
suspend or runtime idle. Could this lead to unnecessary power consumption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929100946.6939=
62-1-larisa.grigore@oss.nxp.com?part=3D9
