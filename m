Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21EF351C35;
	Tue,  1 Sep 2026 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788278367; cv=none; b=Eq8R2qjOqcTdjtyAPsyo/+NJla1n7Lv/rfUEq9Hqq1utLZkrbMOBo0IBo84Zg9Mv8i5EVZehBMat+qAFizMa73v+wZ+G2ekdlXsI1ja2pMPBLf/2y2mgS6WVRD5yiH/u+Tx4OpfXqjAmht8xLBXD4asu9owedS9D/EoZAbwSwak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788278367; c=relaxed/simple;
	bh=DqOnpo89K8LKl7OMnR3NgsDdM/uT/cPuCAAblLNH/Lg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SJUgCeM+EeKn4LnRpg8hSuWfFDpvvMwAiaq0iNFoNZiYRfBeONfr9X+GE2q11UbtAzOni29hwLgxjNbE2N4QNCjrvll5oy9IO1soJxdvIXJpXHPDdGevDTcGjgoNO/CgFCgCtK5+VN18sn9fFnzf5d9rIgU4b6HMEYZgeOrMYlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7cOKILJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7cOKILJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F9D1F000E9;
	Tue,  1 Sep 2026 15:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788278365;
	bh=iGBf8TyscxcHunYRJOHUVhrx6LQnH+hAUFAZp0UWao0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P7cOKILJ7jbmoo69Y87XRF93iNi/blbN33QK3bPL0Pa4MUTtgkg6eMeBLslTbWaGP
	 hCb9fGbd7zFEGR/Rbq1XfKPzfP6pccMLdyYatKSrosAlFI2PzJs8u7mJuWx5A4tl/o
	 bnW3hh/9Pjuh3r/8uBUxfjBnVlqsZeESwnqMbPH/mk1hY6bK7Tue/ecVkHMgk3lHn1
	 zC2m6u+ynl4JkAyDfUFVjXqP195jutojkEQCdA/NJl6AMqp6YcmT9ofQaiMbaz4VHm
	 lednBKQnlTt1VvAR+9LAGkSSR9aQutRAd897bAsMI1Ao43Q5CwjlNF956Eb70Bizsd
	 ziJE4p2XBC+9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 07/24] scsi: ufs: mediatek: Rework 0.9V regulator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: neil.armstrong@linaro.org, vkoul@kernel.org, olteanv@gmail.com, conor+dt@kernel.org, linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-7-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-7-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 15:59:24 +0000
Message-Id: <20260901155925.08F9D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] State desynchronization and missing error handling in `ufs_mtk_mph=
y_power_on` can permanently break PHY power state.
--

commit 2b9c574603dcb6952e8a93e242a09ed30fb488bf
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework 0.9V regulator
   =20
The mediatek UFS host driver does some pretty bad stuff with regards to
the 0.9V regulator. Instead of just checking for the presence of the
regulator, it adds a cap if it's there, and then checks for the cap.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 80c6ba3d026d2..eb7a0cc464f43 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -508,44 +510,70 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *=
hba, u32 state,
>  static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
>  {
>  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
>  	struct phy *mphy =3D host->mphy;
> -	struct arm_smccc_res res;
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
>  		phy_power_on(mphy);

[Severity: High]
This isn't a bug introduced by this patch, but does ignoring the return val=
ue
of phy_power_on() risk desynchronizing the power state?

If phy_power_on() fails (for example, if a clock enable fails in the
underlying implementation), this function will still return success and upd=
ate
host->mphy_powered_on =3D true. This could cause subsequent UFS operations =
to
hang or trigger a synchronous external abort when accessing unclocked PHY
registers.

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
> +		ret =3D ufs_mtk_09v_off(host);
> +		if (ret)
> +			return ret;

[Severity: High]
This is a pre-existing issue, but if ufs_mtk_09v_off() fails here, the
function exits early and leaves host->mphy_powered_on incorrectly set to tr=
ue.

Because phy_power_off() was already called, the PHY is physically shut down.
When attempting to power the PHY on again, the check
(on =3D=3D host->mphy_powered_on) at the start of ufs_mtk_mphy_power_on() w=
ill
evaluate to true and bypass the power-on sequence entirely, leaving the PHY
permanently uninitialized.

Could we make sure host->mphy_powered_on remains consistent even on early
exits?

>  	}
> =20
> -	return ret;
> +	host->mphy_powered_on =3D on;
> +
> +	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D7
