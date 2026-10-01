Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914C1489FD8;
	Thu,  1 Oct 2026 08:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843937; cv=none; b=A1ACACzaDueUF1n4zg1nyGVrrCfrnXbd/aSfsS+Z3OrAINGQoR1X846X+6lDZFURodVZ/E1//V54+Fs3dFyqqf0fgOwrSgaHohcKaguJuOwv5G8I2GqreDCIrYx9XwIui12n+YSHKS/H5nqWu5UWkGcWUtYdIW0Y0LkFgP9ECac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843937; c=relaxed/simple;
	bh=itxGLdQmidTzoKyxRWvQuz2NS5WbJkqX9Y8ui6CrqBA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FVnrhZEDkjtJDfS+PytPtYri0w6GrR/BQ+i6olld4dytsup4sUWykhaRlL893071lxvJxLvP6YFT0U1np9gtyp79pov+BHxjxG9PcbReNAzoGGa42UGYPaeNBOjToSOPBOBbk28Scasyp3poDayztY832NvW1vDzVgMp8O8KZXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UrBvg0mb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UrBvg0mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE44A1F0089E;
	Thu,  1 Oct 2026 08:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790843935;
	bh=Jb7hOi/gVtdfFV1e2VDg6t2YGXHGD52QPs/n1x58YTU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UrBvg0mbg3KNtEWHs1Bd1BMHDtdeoCcvvqhX8Y8CRaSA8pUfRZFhjFKHJgLALmwlC
	 CErLdLJWI7qT0xMBIUp8Oxc5yo+Gh6Term20Tz11fmB/ZZggFP6a3k+F8aoDPyJNr6
	 vknJLTwGO3z4EmFgmN57uR45dJVZKEMToZe+QdLIAR5I1/scv0HfWq7TLK9KAIqXFs
	 K3t7x4td2q/2/hKtPoADdoAAEbbyzvBph/k9k+Xy3V0/8ZdRSkaqExXevCblOQwaq/
	 u9aVKbYifqx5IGSmd1W+gdP7aDSwbeTE6yHh5ThfKGyh55L+onwjJqi9sPLMyQ87/L
	 QUmJBg9O/CgpA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 05/24] phy: mediatek: ufs: Add support for resets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org, neil.armstrong@linaro.org, vkoul@kernel.org, olteanv@gmail.com, linux-phy@lists.infradead.org
In-Reply-To: <20261001-mt8196-ufs-v13-5-60854adab6d9@collabora.com>
References: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
 <20261001-mt8196-ufs-v13-5-60854adab6d9@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 08:38:54 +0000
Message-Id: <20261001083854.CE44A1F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Strict probe failure when firmware lacks optional MPHY backup SMC
- [Medium] Unhandled firmware error codes are silently treated as success i=
n ufs_mtk_phy_ctrl()
--

commit 9009c477dc0a8eefd792f29d6be7589214adb09e
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

phy: mediatek: ufs: Add support for resets

The MediaTek UFS PHY supports PHY resets. Until now, they've been
implemented in the UFS host driver. This commit migrates the MPHY reset log=
ic
into the PHY driver using the PHY subsystem's reset op.

> diff --git a/drivers/phy/mediatek/phy-mtk-ufs.c b/drivers/phy/mediatek/ph=
y-mtk-ufs.c
> index fc19e0fa8ed55..4439a9eb6b7ad 100644
> --- a/drivers/phy/mediatek/phy-mtk-ufs.c
> +++ b/drivers/phy/mediatek/phy-mtk-ufs.c
[ ... ]
> @@ -140,9 +151,59 @@ static int ufs_mtk_phy_power_off(struct phy *generic=
_phy)
>  	return 0;
>  }
> =20
> +static int ufs_mtk_phy_ctrl(struct ufs_mtk_phy *phy, enum ufs_mtk_mphy_o=
p op)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(MTK_SIP_UFS_CONTROL, UFS_MTK_SIP_MPHY_CTRL, op,
> +		      0, 0, 0, 0, 0, &res);
> +
> +	switch (res.a0) {
> +	case SMCCC_RET_NOT_SUPPORTED:
> +		return -EOPNOTSUPP;
> +	case SMCCC_RET_INVALID_PARAMETER:
> +		return -EINVAL;
> +	default:
> +		return 0;
> +	}

[Severity: Medium]
Does this default case mask unhandled firmware error codes?

If the firmware encounters a failure during PHY backup and restore operatio=
ns
and returns an error code other than SMCCC_RET_NOT_SUPPORTED or
SMCCC_RET_INVALID_PARAMETER, it seems it will fall through to the default
case and return 0 (success).

Could this cause the driver to silently ignore hardware or firmware failures
and proceed with potentially corrupted state?

> +}
[ ... ]
> @@ -162,8 +223,18 @@ static int ufs_mtk_phy_probe(struct platform_device =
*pdev)
>  	if (IS_ERR(phy->mmio))
>  		return PTR_ERR(phy->mmio);
> =20
> +	phy->reset =3D devm_reset_control_get_optional_exclusive(dev, NULL);
> +	if (IS_ERR(phy->reset))
> +		return dev_err_probe(dev, PTR_ERR(phy->reset), "Failed to get reset\n"=
);
> +
>  	phy->dev =3D dev;
> =20
> +	if (phy->reset) {
> +		ret =3D ufs_mtk_phy_ctrl(phy, UFS_MPHY_BACKUP);
> +		if (ret)
> +			return dev_err_probe(dev, ret, "Failed to back up MPHY\n");

[Severity: High]
Does this create a strict probe failure on systems with older firmware?

If a Device Tree accurately describing the hardware includes the reset line,
but the system is running an older ATF firmware that lacks the
UFS_MPHY_BACKUP SMC call, ufs_mtk_phy_ctrl() returns -EOPNOTSUPP.

Could this cause the driver probe to fail entirely, rendering the PHY and
dependent UFS host non-functional? Might it be better to degrade
gracefully if the optional firmware backup command is unsupported?

> +	}
> +
>  	ret =3D ufs_mtk_phy_clk_init(phy);
>  	if (ret)
>  		return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-mt8196-ufs=
-v13-0-60854adab6d9@collabora.com?part=3D5
