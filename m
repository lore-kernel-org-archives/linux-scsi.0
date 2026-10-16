Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A797D493D29;
	Fri, 16 Oct 2026 12:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154649; cv=none; b=hJjA/WFGDqsVDXDFEhaBUVc4vR0L5/Awhij/0SoYsE4dzw8h//hBmOT4h3IYHThZ1A6BZVsCVVssfV9kA6DmQo3jk3iyLu5sZOorjLVSQpfoij0l5c4bjNhEdaHqilTFxhFeSAtDJ1vYFVnXfBtxSd9/tt3LU2/tmgFNOQNqwuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154649; c=relaxed/simple;
	bh=fvtbvDczJg32NCrtnH93nsbCQyWe+kR8swyk5Uy1a1w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=djpQbDShLx+d7rmhWpHfKw5MVrRy4Cv9jW1O+uSer6EBKcg45Wzur8Wx6ZRcqgrpzrJaSy5xJ2iceXuVi3Ol7oDAXcOD1BB5GQMA5YOCscPCrXUmoDjjuRa3VMY+5KMCXPRTaQGlnOZXdldrk5PiWVNVdNG2oDnVWuDWuNToWMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWC/skRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWC/skRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BD41F000C4;
	Fri, 16 Oct 2026 12:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792154647;
	bh=QtaNKjNuConHU1ln2GcxJlzR9mNdCnZz5UyC9pXCoBI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gWC/skRzjf5Hc8eJi9+vGb4pXfn/0dEuNv4kdxZm/FcXEntQ2OcxnGd/FpEaS0hNJ
	 69LcmQgVFSqnvEBVc8jTtQdIr+XOiYZ+pEhqr7ZrR+Y6+ci/fqTDJMI1EyJMBilTMS
	 ef9xCVXPyX8489ZJ2iwjBSVaqHQGu+rU0C5ikScczS5Pjr4tbdRg4WIYEA+uznmKEz
	 Sdpy0NtvRW1tjpmvkJ3wz4Ixcm5+QxZ1b+3gP3dqkh7lGh0MddyE/Giwz3Q5CEF5za
	 +RHJu2xpC21+I0L1w9beOHZr5avBMUt/n5oV/3HXKazA1VOwfO033UsyCZPstY3YFb
	 PbxSCH43P7vsQ==
Message-ID: <sashiko-outbox-174331@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 07/23] scsi: ufs: mediatek: Rework 0.9V regulator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261016-mt8196-ufs-v14-7-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
 <20261016-mt8196-ufs-v14-7-e8d565e0cd45@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 12:44:06 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ufs: unbalanced phy power refcount on regulator disable fail=
ure
--

commit 27b915ec9285afe5a63f7cbb4e66e08323344507
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework 0.9V regulator

The mediatek UFS host driver is refactored to manage the 0.9V regulator
by relying on the regulator framework instead of adding explicit sleeps
and checking downstream names. It renames the regulator to avdd09 and
updates the devicetree matching appropriately.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 2aa13b5954800..bcb7f350984c0 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -508,56 +510,77 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *=
hba, u32 state,
[ ... ]
>  static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
>  {
>  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
>  	struct phy *mphy =3D host->mphy;
> -	struct arm_smccc_res res;
> -	int err;
> -	int ret =3D 0;
> +	int ret;
> =20
> -	if (!mphy || !(on ^ host->mphy_powered_on))
> +	if (!mphy || on =3D=3D host->mphy_powered_on)
>  		return 0;
> =20
>  	if (on) {
> -		if (ufs_mtk_is_va09_supported(hba)) {
> -			ret =3D regulator_enable(host->reg_va09);
> -			if (ret < 0)
> -				goto out;
> -			/* wait 200 us to stablize VA09 */
> -			usleep_range(200, 210);
> -			ufs_mtk_va09_pwr_ctrl(res, 1);
> -		}
> +		ret =3D ufs_mtk_09v_on(host);
> +		if (ret)
> +			return ret;
>  		ret =3D phy_power_on(mphy);
>  		if (ret) {
> -			if (ufs_mtk_is_va09_supported(hba)) {
> -				ufs_mtk_va09_pwr_ctrl(res, 0);
> -				err =3D regulator_disable(host->reg_va09);
> -				if (err)
> -					dev_err(hba->dev,
> -						"failed to unwind va09: %d\n", err);
> -			}
>  			dev_err(hba->dev, "failed to enable mphy: %d\n", ret);
> +			ufs_mtk_09v_off(host, false);
>  			return ret;
>  		}
>  	} else {
>  		phy_power_off(mphy);
> -		if (ufs_mtk_is_va09_supported(hba)) {
> -			ufs_mtk_va09_pwr_ctrl(res, 0);
> -			ret =3D regulator_disable(host->reg_va09);
> -		}
> -	}
> -out:
> -	if (ret) {
> -		dev_info(hba->dev,
> -			 "failed to %s va09: %d\n",
> -			 on ? "enable" : "disable",
> -			 ret);
> -	} else {
> -		host->mphy_powered_on =3D on;
> +		ret =3D ufs_mtk_09v_off(host, true);
> +		if (ret)
> +			return ret;

[Severity: High]
Does returning early here leave the mphy_powered_on boolean out of sync with
the physical state?

If ufs_mtk_09v_off() fails, the early return skips updating
host->mphy_powered_on =3D on (where on is false). This leaves the state as
true even though phy_power_off(mphy) has already been called.

Because of the early return, a subsequent request to power off would evalua=
te
on =3D=3D host->mphy_powered_on (false =3D=3D true) to false, causing the f=
unction
to execute phy_power_off(mphy) again and underflow the PHY power count.
Conversely, a request to power on would evaluate true =3D=3D true, causing =
an
early success return without actually powering on the PHY, potentially brea=
king
UFS I/O permanently.

>  	}
> =20
> -	return ret;
> +	host->mphy_powered_on =3D on;
> +
> +	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016-mt8196-ufs=
-v14-0-e8d565e0cd45@collabora.com?part=3D7
