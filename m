Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D6E3DD84A;
	Thu, 30 Jul 2026 10:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407363; cv=none; b=mVwj/gy8l6fUAvouiyDKkycS682YdRCnYLF9Ko/stbW2uROcvdT/Iilr6prkOK1ITn5uPs1DUP/xf5BfZxP3J/n/ACjk81mWbm4XI0z1ITl8kkZycPLgWSQfFUMMy0qLqzzT6RY47E//+hEu+n1+HfzGSCVeIO9jk9A0XOqnurU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407363; c=relaxed/simple;
	bh=MLauP4h2O6XL26eRLvcalEouLmyVFX1LW0k1z/gxMKc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M7tN5G5BHde0eFpBuEOJR4vQRZEYFA9JN88ynuP26YlmzUurYorRbrOx7CkzoMZYP926DiDB92ZxDc76sPbkre6tDJKm75JUBDhQbHCdzdwmMzSQDcmRaVjiKrpA0kjCjy964JmCbmRjmH9tCiRWTSNih0SqqZ1yv1pKkuP4Zm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NT1LUnTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NT1LUnTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01161F000E9;
	Thu, 30 Jul 2026 10:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785407360;
	bh=/2nKL1zddxuvJ2jaD6upOvmdfCXrufRhTlLZM2+uv2w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NT1LUnTY7Gw2EwHnCcGhPtuI9a9eb41muuJmtz37dKINz1sGR/LCbzMxY3RFHTSra
	 YudKO0mM7xuyoc0GzIwzpb22g3pQj9N66/qGLuGypXDEb3Zue+xcDLDoR1C2zczi5R
	 JMXw+i5rptMQZ5FL3RG8HecKxZFR8rYiZXNSO6f6WyW+bPB87RpNmDMCNytPpjOqFh
	 dSgED/26KNhCRKnulsYbK0FedbZGHa9j4GlANnHhIjY+fD2F0GVjqIc/rlJ5sPoncs
	 BukfOl4NO1Ou39pmrV3R21pHEkNqgJh2x3P+ySmzZuuXEkI9Mu59AjaQDQk8FME1xT
	 d7K2JlpEuG7Ug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 10/26] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org, olteanv@gmail.com
In-Reply-To: <20260730-mt8196-ufs-v10-10-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-10-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:29:19 +0000
Message-Id: <20260730102919.C01161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The UFS driver caches a dangling pointer to the PHY device after p=
rematurely dropping its reference, leading to a Use-After-Free.
- [High] The driver ignores the return value of `ufs_mtk_mphy_power_on()`, =
potentially leading to hardware hangs if the PHY fails to power on.
--

--- Patch [10]: [PATCH v10 10/26] scsi: ufs: mediatek: Handle misc host vol=
tage regulators ---
commit 8242d1302e10cd1046e43a3ff8124f21223143fe
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
scsi: ufs: mediatek: Handle misc host voltage regulators

This commit adds support for acquiring miscellaneous host voltage regulators
using the regulator bulk API in the MediaTek UFS driver. It handles per-SoC
specific regulator names and enables them during acquisition so they are
kept on during suspend.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 55701172bcf15..65036c8390318 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -1188,8 +1190,21 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_hos=
t *host)
>  {
>  	struct device *dev =3D host->hba->dev;
>  	const struct ufs_mtk_soc_data *data =3D of_device_get_match_data(dev);
> +	int ret;
> +
> +	if (!data)
> +		return 0;
> +
> +	if (data->num_reg_names) {
> +		ret =3D devm_regulator_bulk_get_enable(dev, data->num_reg_names,
> +						     data->reg_names);
> +		if (ret) {
> +			dev_err(dev, "Failed to get misc regulators: %pe\n", ERR_PTR(ret));
> +			return ret;
> +		}
> +	}
> =20
> -	if (!data || !data->has_avdd09)
> +	if (!data->has_avdd09)
>  		return 0;
> =20
>  	host->reg_avdd09 =3D devm_regulator_get_optional(dev, "avdd09");

[ ... ]

[Severity: High]
This isn't a bug introduced by this patch, but does this driver ignore the=
=20
return value of ufs_mtk_mphy_power_on() when initializing?

In ufs_mtk_init(), the function is called without checking if it fails:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_init() {
    ...
	/*
	 * ufshcd_vops_init() is invoked after
	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
	 * phy clock setup is skipped.
	 *
	 * Enable phy clocks specifically here.
	 */
	ufs_mtk_mphy_power_on(hba, true);

	if (ufs_mtk_is_rtff_mtcmos(hba)) {
    ...
}

If the underlying regulator enablement fails, the PHY could remain unpowere=
d.

Could this cause the UFS host controller driver to assume the PHY is
functional, which might lead to timeouts or unrecoverable hardware hangs
during initialization?

[Severity: High]
This is also a pre-existing issue, but does this driver cache a dangling
pointer to the PHY device?

Looking at ufs_mtk_probe(), the driver acquires a device reference to the
PHY node but immediately drops it:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_probe() {
    ...
	if (phy_node) {
		phy_dev =3D of_find_device_by_node(phy_node);
		of_node_put(phy_node);
		if (!phy_dev) {
			dev_err(dev, "phy_dev not found\n");
			goto skip_phy;
		}
		put_device(phy_dev);
		dev_info(dev, "phys node found\n");
	}
    ...
skip_phy:
    ...
	if (phy_node && phy_dev) {
		host =3D ufshcd_get_variant(hba);
		host->phy_dev =3D phy_dev;
	}
    ...
}

Because put_device() is called earlier, phy_dev could potentially be freed =
if
the PHY device is unbound.

If the PHY device is later freed, will accessing pm_runtime_put_sync() or
pm_runtime_get_sync() on host->phy_dev during suspend and resume callbacks
trigger a use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D10
