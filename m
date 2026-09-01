Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963A547ECDD;
	Tue,  1 Sep 2026 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280113; cv=none; b=doaixKn04V31ufnJdGmUn/gdZnQ9I6Di+xRSPRpyRQ/rQkRluhuv+X8+Aa4+wD0hoZzbUUv8y0uoURYUH5oP3UPrS9xx1Gtjgppj3Fz7KITVT4fEQui7XcCYXT9m5KT4xSW7zEzI81PO2n/o1ON7uzezttnAHHuZuFXtMalbtrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280113; c=relaxed/simple;
	bh=KCqHn1ZD1LIK1l5hhEeEO/Kvh4MSJmAnoUug+ANOizw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O/FW4G2XN/teQbJE1Gp0qnx8/maF8OBg/Is7hfZN/5A9D14ztS9OqsHFsKFgq0M+//yi17uPpjT+C2V9gL/qr5tT9Zal5mZ2VroqVXGucC6A6AZ/USjompt2We3fbJtL9Zo+s5zEapsO0NIKjRq9hZ6WdThhW72ZYPsB3IvrApA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfw3EGXY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfw3EGXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F40A1F000E9;
	Tue,  1 Sep 2026 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788280112;
	bh=nktT8YFsUKr60J8plPiryqq49Q7dgfxOp4MtickuCRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bfw3EGXY0r4GVka9JCO/ptA01X0IeTuuObew1wJIfHXpRSd1N1d+vvj2yQHFjCHj4
	 QmnYCD5Ofl3k/GDIhxqTPSLlJcb/YBonm8dV7zM/XDNRJDhnrbo0cYNmQKhPkkYy3O
	 NlbreI+Cfcx23yJmmrYkCuMUhj3RlhgQJX9O44OZZCbYWOcUhAuGlPtlSEClgXRCn0
	 H6Wzv15fvBRMsawmdSUxrTBGm2ddJrsYfNW44u7tlfRYQVABYOdDx7PRkBbhVVkbn3
	 9W9W5Ygl0aHQ1ckLpCGQJgAuKJw+a5prv8z8zWxGcnCEmr+WvwVoELvrQff0iY7xuZ
	 cyyNyRdn3f6Dw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 14/24] scsi: ufs: mediatek: Use the common PHY
 framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, olteanv@gmail.com, vkoul@kernel.org, neil.armstrong@linaro.org, linux-scsi@vger.kernel.org, robh@kernel.org, linux-phy@lists.infradead.org, conor+dt@kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-14-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-14-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:28:31 +0000
Message-Id: <20260901162831.9F40A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Unhandled early return on PHY power-off failure in ufs_mtk_runtime=
_suspend leaves the UFS controller hardware suspended while the PM core bel=
ieves it is active.
- [High] Unconditional PHY power-off in runtime suspend breaks active UFS l=
inks.
- [Medium] Regulator enable count leak in ufs_mtk_09v_on error path.

Pre-existing issues:
- [High] Ignoring the return value of phy_power_on() causes PHY framework p=
ower_count corruption.
- [High] Unbalanced PHY power off and PM runtime put due to error handling.
--

commit 1bc61edb6ca30c41119dffded499a3c42a9eb908
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Use the common PHY framework
   =20
The commit converts the MediaTek UFS driver to use the common PHY framework
instead of custom OF parsing for PHYs. It acquires the device's PHY during
initialization to link it to the right device.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index ae053f40aaf46..1df16ce29ea4e 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -2488,9 +2433,8 @@ static int ufs_mtk_system_resume(struct device *dev)
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
> @@ -2501,8 +2445,11 @@ static int ufs_mtk_runtime_suspend(struct device *=
dev)
>  	if (ufs_mtk_is_rtff_mtcmos(hba))
>  		ufs_mtk_mtcmos_ctrl(false, res);
> =20
> -	if (host->phy_dev)
> -		pm_runtime_put_sync(host->phy_dev);
> +	ret =3D ufs_mtk_mphy_power_on(hba, false);
> +	if (ret) {

[Severity: High]
Does this unconditional power-off break active UFS links?

The UFS subsystem allows runtime PM to keep the link active depending on the
user-configured PM level (hba->rpm_lvl).

The underlying vendor suspend callback (ufs_mtk_suspend), which is called v=
ia
ufshcd_runtime_suspend() earlier in this function, explicitly checks
ufshcd_is_link_active(hba) and intentionally skips PHY power-off if the link
must remain active.

By adding an unconditional call to ufs_mtk_mphy_power_on(hba, false) here,
doesn't it override the link-state-aware logic and cut PHY power entirely,
killing the active electrical link?

[Severity: High]
This is a pre-existing issue, but does ignoring the return value of
phy_power_on() cause PHY framework power_count corruption?

Inside ufs_mtk_mphy_power_on():

	if (on) {
		ret =3D ufs_mtk_09v_on(host);
		if (ret)
			return ret;
		phy_power_on(mphy);
	}

If phy_power_on() fails, the PHY framework does not increment
phy->power_count and drops its PM runtime reference.

Because the return value is ignored, ufs_mtk_mphy_power_on() sets
host->mphy_powered_on =3D true.

Later, during suspend, it calls phy_power_off(), which decrements the zeroed
power_count (causing an underflow) and invokes phy_pm_runtime_put().

Can this cause an unbalanced PM put on the PHY device, leading to a negative
PM usage count and potential system instability?

[Severity: High]
This is a pre-existing issue, but does the error handling in
ufs_mtk_mphy_power_on() cause unbalanced PHY power off and PM runtime put?

Inside ufs_mtk_mphy_power_on():

	} else {
		phy_power_off(mphy);
		ret =3D ufs_mtk_09v_off(host);
		if (ret)
			return ret;
	}

	host->mphy_powered_on =3D on;

If ufs_mtk_09v_off() fails, it returns early and skips the assignment
host->mphy_powered_on =3D false.

The next time the device attempts to suspend, host->mphy_powered_on is still
true, and it executes the power-off branch again.

Doesn't this cause phy_power_off() to be called a second time for a single
power-on, double-decrementing power_count and causing an unbalanced PM runt=
ime
put?

[Severity: Medium]
Does the error path in ufs_mtk_09v_on() leak the regulator enable count?

Inside ufs_mtk_09v_on():

	if (host->reg_avdd09_1) {
		ret =3D regulator_enable(host->reg_avdd09_1);
		if (ret) {
			dev_err(host->hba->dev, "Failed to enable avdd09-1-supply: %pe\n",
				ERR_PTR(ret));
			return ret;
		}
	}

If the second regulator (reg_avdd09_1) fails to enable, the function returns
the error directly without calling regulator_disable(host->reg_avdd09) to u=
ndo
the previous successful enable step.

Doesn't this leak the regulator enable count, keeping the resource active
indefinitely?

> +		dev_err(dev, "Failed to power off PHY: %pe\n", ERR_PTR(ret));
> +		return ret;

[Severity: High]
Can this unhandled early return leave the UFS controller hardware suspended
while the PM core believes it is active?

If ufs_mtk_mphy_power_on(hba, false) fails, returning the error code here
causes the PM core to abort the suspend attempt and treat the device as
remaining RPM_ACTIVE.

However, ufshcd_runtime_suspend() was already executed successfully just
before this, meaning the UFS host controller is physically suspended.

Doesn't this state mismatch mean the PM core will not issue a resume on the
next access, leading to I/O targeting powered-down hardware, which causes
register access timeouts, bus hangs, or crashes?

> +	}
> =20
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D14
