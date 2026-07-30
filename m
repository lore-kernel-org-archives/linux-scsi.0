Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C1A3E0C66;
	Thu, 30 Jul 2026 10:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408004; cv=none; b=heGemqljntRo9WfWva5JDEMKIN5XPVFHyHagsTMlaaJdrn0yJCKrTcvTMA8MPvjzletxwa01RzkQtaqXgLRVS6EgV6EO46x64E/O76EwfvXvLeiqB38Gd6mYiD1XJKhco/tdf6uPIEoF5op+4NXfgjnP2oMI/jTyjGbz7SFopoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408004; c=relaxed/simple;
	bh=KniDzzgrfACz53ThCt/8Vful0fkVM5tfH737yQ/Rbuk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=twQ7EIORq29TujuEn9EaCcJL1ryaSOM6IMqj6ZCd8ONj3jygt0QrDlb74HwNSh0T/d7lpZbMY6TbZ0vQyhkJBiRo3V4i0F2bGCGiD5pxde8n8ikkitkZ0W7wvyE9R1D1VxGanuy3/MXYI+ntoIoyQal1RL4u7qJTGubfW5d6+Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b25ZSnWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b25ZSnWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D061F00A3A;
	Thu, 30 Jul 2026 10:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408002;
	bh=woCQi2XgCOnLa0SXh4pDuRNuZ8kQCg7x1MjNi+hphZQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b25ZSnWXbAgUn5Qatneshyf+ZLCAeYR7m8MRXSPMTAHlGGncvVi22YltzTxPzfSO8
	 O/qtFoQSTDQbMg0f/VH4hj+yxF4c5muCgEosyiU6Bh5JTGYPwaQE7KoSiJtkjf6nJr
	 rNiLisCye8Y0uoWzG8cGRmvU1sPl0DDcgk29qV4ysDTaxQYT8h3M4NdcodFuJmK8wF
	 dyGUCGI9c3NfxisUDxOTv8NTK+8436g/RHrsb9YK8Vh9b6MG3iDPVMzZcaudiw137+
	 EpKv2HS4IqRcOKJ3JQseREeggp1cdyGPqcRAPtIb2j+fh3eJJpaid3NK8nHKFyL2fF
	 b4461gCEJob9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 13/26] scsi: ufs: mediatek: Use the common PHY
 framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, neil.armstrong@linaro.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org, robh@kernel.org, vkoul@kernel.org, olteanv@gmail.com, devicetree@vger.kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-13-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-13-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:40:01 +0000
Message-Id: <20260730104002.59D061F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The driver now fails to probe on platforms where the UFS PHY is no=
t defined in the device tree, breaking backward compatibility.
- [High] Returning an error late in PM runtime callbacks leaves the device =
in an inconsistent state and breaks PM state synchronization.

Pre-existing issues:
- [High] The return values of `phy_power_on()` and `phy_power_off()` are ig=
nored, which can lead to unbalanced PM runtime counts and hardware state co=
rruption.
--

--- Patch [13]: [PATCH v10 13/26] scsi: ufs: mediatek: Use the common PHY f=
ramework ---
commit 114da5212062d5f11b7f9274ba9701891ef82788
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Use the common PHY framework
   =20
This patch refactors the MediaTek UFS driver to use the common PHY framewor=
k=20
to acquire the device's PHY during ufshcd init, ensuring it is device-linke=
d=20
to the correct device.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index e5527969a5e67..385f0180b2309 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -1185,13 +1147,21 @@ static int ufs_mtk_init(struct ufs_hba *hba)
> =20
>  	ufs_mtk_init_mcq_irq(hba);
> =20
> -	err =3D ufs_mtk_bind_mphy(hba);
> -	if (err)
> +	host->mphy =3D devm_phy_get(dev, NULL);
> +	if (IS_ERR(host->mphy)) {
> +		err =3D dev_err_probe(dev, PTR_ERR(host->mphy), "Failed to get PHY\n");

[Severity: High]
Will this cause the driver probe to fail on platforms where the UFS PHY
is not defined in the device tree?

The original ufs_mtk_bind_mphy() tolerated -ENODEV to allow for unbound=20
mphys since not all platforms require specific mphy control. By switching=20
to devm_phy_get() instead of devm_phy_optional_get(), won't this return=20
-ENODEV and fail the probe if the "phys" property is missing, breaking=20
backward compatibility with older device trees?

> +		goto out_variant_clear;
> +	}
> +
> +	err =3D phy_init(host->mphy);
> +	if (err) {
> +		dev_err_probe(dev, err, "Failed to initialize PHY\n");
>  		goto out_variant_clear;
> +	}

[ ... ]

> @@ -2448,9 +2393,8 @@ static int ufs_mtk_system_resume(struct device *dev)
>  static int ufs_mtk_runtime_suspend(struct device *dev)
>  {
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
>  	struct arm_smccc_res res;
> -	int ret =3D 0;
> +	int ret;
> =20
>  	ret =3D ufshcd_runtime_suspend(dev);
>  	if (ret)
> @@ -2461,8 +2405,11 @@ static int ufs_mtk_runtime_suspend(struct device *=
dev)
>  	if (ufs_mtk_is_rtff_mtcmos(hba))
>  		ufs_mtk_mtcmos_ctrl(false, res);
> =20
> -	if (host->phy_dev)
> -		pm_runtime_put_sync(host->phy_dev);
> +	ret =3D ufs_mtk_mphy_power_on(hba, false);
> +	if (ret) {
> +		dev_err(dev, "Failed to power off PHY: %pe\n", ERR_PTR(ret));
> +		return ret;
> +	}

[Severity: High]
Does returning an error here leave the device in an inconsistent state?

If ufshcd_runtime_suspend() succeeds, the main UFS controller hardware is
fully suspended (clocks gated, link hibern8). If ufs_mtk_mphy_power_on()=20
fails afterward, this returns the error to the PM core.=20

Since the PM core intercepts the non-zero return as a runtime suspend=20
failure, it leaves the software state as RPM_ACTIVE. If the software=20
thinks the device is active while the hardware is actually suspended,=20
won't the next hardware access skip runtime_resume and cause a system=20
hang or bus error?

[Severity: High]
This is a pre-existing issue, but does ufs_mtk_mphy_power_on() safely
handle phy_power_on() failures?

Looking at ufs_mtk_mphy_power_on() in drivers/ufs/host/ufs-mediatek.c:

static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
{
        ...
        if (on) {
                ret =3D ufs_mtk_09v_on(host);
                if (ret)
                        return ret;
                phy_power_on(mphy);
        } else {
                phy_power_off(mphy);
        ...
        host->mphy_powered_on =3D on;
        return 0;
}

If phy_power_on() fails, it cleans up its runtime PM and does not=20
increment the power_count, but ufs_mtk_mphy_power_on() ignores the return=20
value and still sets host->mphy_powered_on =3D true.=20

When ufs_mtk_mphy_power_on(hba, false) is called later, it will blindly=20
call phy_power_off(). Won't this decrement the PHY's power_count=20
(potentially underflowing it), corrupting the PHY driver's PM usage=20
counter and causing an unbalanced PM state?

> =20
>  	return 0;
>  }
> @@ -2470,14 +2417,17 @@ static int ufs_mtk_runtime_suspend(struct device =
*dev)
>  static int ufs_mtk_runtime_resume(struct device *dev)
>  {
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
>  	struct arm_smccc_res res;
> +	int ret;
> =20
>  	if (ufs_mtk_is_rtff_mtcmos(hba))
>  		ufs_mtk_mtcmos_ctrl(true, res);
> =20
> -	if (host->phy_dev)
> -		pm_runtime_get_sync(host->phy_dev);
> +	ret =3D ufs_mtk_mphy_power_on(hba, true);
> +	if (ret) {
> +		dev_err(dev, "Failed to power on PHY: %pe\n", ERR_PTR(ret));
> +		return ret;
> +	}

[Severity: High]
Could a failure here cause similar PM state inconsistencies?

If ufs_mtk_mphy_power_on() fails during runtime resume, returning an=20
error without rolling back the prior partial initialization (such as=20
ufs_mtk_mtcmos_ctrl) might confuse the PM core. Does this need to clean=20
up previously resumed components before returning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D13
