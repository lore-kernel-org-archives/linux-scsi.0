Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB54C39CD13
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 09:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787910059; cv=none; b=RXD/gzDJNe0/Rcm4Y7NwYf1uxrDGx8cPp+LbtRBqXAL+grxx89mXoNMIWbS2iLTKArmkOvN77U1DAEhKeNCm/n506iZWJYmTFiZJ/oM4CHOXcfz7/7dF2aMVVdSFcVbA519pt0l4DmpdrwBWyOhab0Zs/VqaYOTM4xgPEOE5TNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787910059; c=relaxed/simple;
	bh=2DMmmKrZFi5lpNcb6FdTssjtHf/Dfk9FuO7r12GDTWc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=seBAV8ClXoSRm1DyMM2MB+5osSfe8hogr/jV23vNBq4bhfeI5PzN1YIu0LeUrnFOxbhcks7BaUXhgpm8UBKHfTD3EYx88CQUCaTSEgsbTB47eZ0tsLhwF9WWhOql8VClXcKmOcWtKi08Mjtal/dE1G9r6AOBsw3fkdShOKMni70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ado2A58z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ado2A58z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B7D1F000E9;
	Fri, 28 Aug 2026 09:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787910058;
	bh=kFgtKpG4qWBhiWOAPtdRMQOIVjmiAQ3uqfptUtcEvD8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ado2A58zbpxcA6BDs8/cS+HQ/9nAlfxnmup4aEc+k9uQelSEN4PVZBNCVxBhelk+3
	 zu44nck5ExGQx28j/nP1dZp2ol6yIx3bp9HN0dgHF67mB4L/XPr0TChIsADoyEJ71K
	 mHj9h6tSj5LrS/khoY4Tbn2hj04eA8CeJHo7kPG1tvQEAdoQqVQFrymHsP72SX1Tc6
	 BIcXyh48RMN8cHVTV6VXgwtpl3f8mpoaS3yK6KVBd19eJ0rbZtsTsMb5mWtsViX7xc
	 aisifYNdyDGnmT3WsV9bFYJu1pKcTE7hRWYDX14F4rQCkeIjMXznKxgGDu0PxQQHcM
	 r9X9mu6FedEcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: mediatek: Handle mPHY power-on failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260828092311.10774-1-pengpeng@iscas.ac.cn>
References: <20260828092311.10774-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 28 Aug 2026 09:40:57 +0000
Message-Id: <20260828094058.17B7D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Failure in `regulator_disable()` during power-off leaves the softw=
are state flagged as 'powered on', despite the physical PHY being powered d=
own, which breaks subsequent power-on attempts.
- [High] Unbalanced PHY power management leading to clock setup with an unp=
owered PHY and VA09 regulator during resume.
--

commit abe799aa942a1ffc27379395adfb1d36f8c84af2
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

scsi: ufs: mediatek: Handle mPHY power-on failures

This patch updates ufs_mtk_mphy_power_on() to handle phy_power_on() failure=
s.
If the PHY fails to power on, the VA09 regulator is turned back off to prev=
ent
it from being left enabled, and the initialization path now checks and
propagates this error.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 865be3ddf448e..92dbd240c7ea5 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -524,7 +525,18 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba=
, bool on)
>  			usleep_range(200, 210);
>  			ufs_mtk_va09_pwr_ctrl(res, 1);
>  		}
> -		phy_power_on(mphy);
> +		ret =3D phy_power_on(mphy);
> +		if (ret) {
> +			if (ufs_mtk_is_va09_supported(hba)) {
> +				ufs_mtk_va09_pwr_ctrl(res, 0);
> +				rollback_ret =3D regulator_disable(host->reg_va09);
> +				if (rollback_ret)
> +					dev_warn(hba->dev, "failed to disable va09 after mphy failure: %d\n=
",
> +						 rollback_ret);
> +			}
> +			dev_info(hba->dev, "failed to enable mphy: %d\n", ret);
> +			return ret;
> +		}
>  	} else {
>  		phy_power_off(mphy);
>  		if (ufs_mtk_is_va09_supported(hba)) {

[Severity: High]
This isn't a bug introduced by this patch, but if regulator_disable() fails
here during power-off, does it leave the software state permanently out of =
sync?

In ufs_mtk_mphy_power_on(), we have:

	} else {
		phy_power_off(mphy);
		if (ufs_mtk_is_va09_supported(hba)) {
			ufs_mtk_va09_pwr_ctrl(res, 0);
			ret =3D regulator_disable(host->reg_va09);
		}
	}
out:
	if (ret) {
        ...
	} else {
		host->mphy_powered_on =3D on;
	}

If regulator_disable() returns an error, host->mphy_powered_on won't be
updated to false, even though phy_power_off() was already executed. Can this
cause future calls to ufs_mtk_mphy_power_on(hba, true) to early-exit, leavi=
ng
the PHY physically unpowered?


[Severity: High]
This is also a pre-existing issue, but does the current power management fl=
ow
cause unbalanced PHY power off calls?

During suspend, ufs_mtk_suspend() calls ufs_mtk_mphy_power_on(false), which
executes phy_power_off(mphy) and disables the regulator.

Later in the suspend path, ufshcd_suspend() calls ufs_mtk_setup_clocks(fals=
e),
which triggers ufs_mtk_pwr_ctrl(false). This redundantly calls
phy_power_off(mphy) again, dropping its internal power_count to -1.

During resume, ufs_mtk_pwr_ctrl(true) calls phy_power_on(mphy). Because
the power_count was -1, it only increments to 0 without actually powering on
the hardware. The VA09 regulator is also left disabled.

ufs_mtk_pwr_ctrl() then calls ufs_mtk_setup_ref_clk(true), which attempts to
poll reference clock registers on physically unpowered hardware.

Does this unconditionally lead to a timeout and broken I/O during resume on
systems binding a PHY?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260828092311.1077=
4-1-pengpeng@iscas.ac.cn?part=3D1
