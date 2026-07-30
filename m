Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CCE3F86F0;
	Thu, 30 Jul 2026 10:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785406073; cv=none; b=uPWDTYSMvXpzYAnarRbxm330N1fyFNmjnPsrooIOpfA60Y2zn7SBEJkHrSXYkdCz9qlaH7mu0cT8RSk0wAQgAkTPGe/aqFRoLc1pmxLbdrD0F7cwS5kWbMdj7CMFvPsR4/reSVd2ByKNF1aUzKmaEOU96mHr601IJGz4aDGmxK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785406073; c=relaxed/simple;
	bh=zC2D5XcmFDI2jFeGKaTBpwDTFYjycIQ6TtoyR/9A2H8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y+0EEK9NK9tj2wW5vl8mbfSdeWCk9HBHjSLpCJ57ivDfDj4yM4NkKfIouEo7BjBntl/jTVR48zGBscYBCMer2dBRfAfcXlHLtyuSSB+3hc38tmeHJ3kSPPxxttY9eLAKOWIsKvEEK69BsD8gsrpix0B188LFUgV44R7NaeKnxWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltXV8Add; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltXV8Add"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3F01F00A3D;
	Thu, 30 Jul 2026 10:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785406067;
	bh=+DdtGIGw5KisOkEqv6VLLhJyKxudfBrpLNeEuZR/x+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ltXV8AddneWCj10H+yXmyOp1Ivd5uAPjM1XJSmyc/nozeWSTTjRqplIDONq7Z+00a
	 guSMm8lizOkqxz4hZzYqtA8w54K5BzHeOMjTXCZ8cJRXCaAvvHFQCyqNG40DnLBCQB
	 Wq58QIHE6JHlHrMnAFNyXesvlkww2S2iS5QzB+fqRauFZVoWv+BX8vc6KzD0JO6YU3
	 9aEpRyd1NvUr+b01xnDRgHmwKgRyzMPLeOekgpZVEjIiJ+HyxAhAHV/EI4B6HFSSna
	 Tz3d0ChQ1DNAzipP9UUgBaxVKFSHJwXHUIeK39Yl+/9Y69xu4cxb3wuhWoH1cAZnJG
	 GBzAZQEa2hhLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 08/26] scsi: ufs: mediatek: Rework init function
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: neil.armstrong@linaro.org, devicetree@vger.kernel.org, vkoul@kernel.org, conor+dt@kernel.org, olteanv@gmail.com, robh@kernel.org, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-8-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-8-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:07:46 +0000
Message-Id: <20260730100746.AB3F01F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The return value of `ufs_mtk_mphy_power_on()` is ignored during ho=
st initialization.
- [High] Use-After-Free risk due to saving a released device pointer in `ho=
st->phy_dev`.
--

--- Patch [8]: [PATCH v10 08/26] scsi: ufs: mediatek: Rework init function =
---
commit 5d79268ac1559dd4c6c615601ae1b9838e4b77bc
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework init function

This commit reworks the initialization function for the MediaTek UFS driver.
It removes unnecessary error prints for memory allocation failures and remo=
ves
redundant device tree matching. It also simplifies the error handling path
by removing unnecessary goto statements and returning directly on success.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index f6859cd0b1d4d..50e7701d7943b 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -1356,11 +1334,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
> =20
>  	ufs_mtk_get_hw_ip_version(hba);
> =20
> -	goto out;
> +	return 0;
> =20
>  out_variant_clear:
>  	ufshcd_set_variant(hba, NULL);
> -out:
>  	return err;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does this code ignore the
return value of ufs_mtk_mphy_power_on() earlier in ufs_mtk_init()?

Looking at ufs_mtk_init():

	err =3D ufs_mtk_get_supplies(host);
	if (err)
		goto out_variant_clear;

	/*
	 * ufshcd_vops_init() is invoked after
	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
	 * phy clock setup is skipped.
	 *
	 * Enable phy clocks specifically here.
	 */
	ufs_mtk_mphy_power_on(hba, true);

	if (ufs_mtk_is_rtff_mtcmos(hba)) {

If ufs_mtk_mphy_power_on() fails (e.g. regulator_enable fails in
ufs_mtk_09v_on), the driver will proceed as if the PHY powered on
successfully.  Should this check the return value and handle the error?

[ ... ]
> @@ -2402,6 +2379,18 @@ static const struct ufs_hba_variant_ops ufs_hba_mt=
k_vops =3D {
>  	.config_scsi_dev     =3D ufs_mtk_config_scsi_dev,
>  };
> =20
> +static const struct ufs_mtk_soc_data mt8183_data =3D {
> +	.has_avdd09 =3D true,
> +};
> +
> +static const struct of_device_id ufs_mtk_of_match[] =3D {
> +	{ .compatible =3D "mediatek,mt8183-ufshci", .data =3D &mt8183_data },
> +	{ .compatible =3D "mediatek,mt8192-ufshci" },
> +	{ .compatible =3D "mediatek,mt8195-ufshci" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
> +
>  /**
>   * ufs_mtk_probe - probe routine of the driver
>   * @pdev: pointer to Platform device handle

[Severity: High]
This is a pre-existing issue, but is there a use-after-free risk in
ufs_mtk_probe() when saving the released device pointer?

Looking at ufs_mtk_probe():

	if (phy_node) {
		phy_pdev =3D of_find_device_by_node(phy_node);
		if (!phy_pdev)
			goto skip_phy;
		phy_dev =3D &phy_pdev->dev;

		...
		put_device(phy_dev);
	}
	...
skip_phy:
	err =3D ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops);
	...
	if (phy_node && phy_dev) {
		host =3D ufshcd_get_variant(hba);
		host->phy_dev =3D phy_dev;
	}

of_find_device_by_node() acquires a reference to the phy device. This
reference is unconditionally dropped via put_device(phy_dev), but the
unreferenced pointer is then stored in host->phy_dev.

If the phy device is removed or unbound and the memory is freed, the UFS
driver continues to dereference it during runtime PM operations:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_runtime_suspend() {
    ...
	if (host->phy_dev)
		pm_runtime_put_sync(host->phy_dev);
    ...
}

Should the reference be held until the UFS host device is unbound?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D8
