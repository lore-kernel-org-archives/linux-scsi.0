Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3844C65B;
	Mon, 14 Sep 2026 12:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388363; cv=none; b=gTpKg9mj84Nr7n32Lg8Ju+2YNcjz99CNR6g4mcmlaVFQ9szYQGz6Qg8oJLGp6Oh6uYwifciDTyIgeD4IdBLd0y6F1IRpOsdITe1l5Jj6kt1FCcoyRUFRsXUesPC7ZXN17L9d0i+2iB7wltzFGbxmDOo9xxOL2FAuxG4NHd+XIFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388363; c=relaxed/simple;
	bh=e7eCFjdbmtN3iLITHb2l98aK3cl5R8ooyacpgHumJ80=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S73hWa/To9XfXlZkLRcDvF+S8p9ItlYvKVj4cULS/p29We1gfrdX9Q/Nb/KBqL1o0iqfsJ6/CpYhh58kDvNLQpM6BZULizO9AJgK9NMEWBJcKNI1Rbz9jrzxqWseMfP20Xfv/kUU6Umj2QZQZyrvEMIN2YUfVom7lXj+AHb+SJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QW03ejSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QW03ejSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E671F000FF;
	Mon, 14 Sep 2026 12:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388362;
	bh=di97jBEzaBHuvQ8ntyVXnOUhi1XQP51jT/lsjlP0UQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QW03ejSpKeWDSuO/bRnDDmPFLDsPbRMJvNlvKfmiEU2qfRSBGTOdZ9ApNi2hMofzQ
	 44lHALmt/ur52x4+JcvFTHW41NcVO7/2ZpKEiJt9gLOdhWUR8e6GeIk/+Yr26KX9sZ
	 RO6t+yrLRsR7gd0R43VROt62SJ1Qpb4qKJAcV/vvtXUh8/W1gyZBxvTDKWEXqlJ0Ln
	 YsD30iJhdt1bBJeYsgT5in/GIR3bGksYYndkzFxZ0byAAIqavwz+SHbBXuAPsi4NhE
	 NhUbh1CMHL/M8qJqZYJwD3ymz2MB708wCtUCd5qJ5TYj2vGLgVurz8aUZHnh97j2pr
	 jvO6QvCPVOYCQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 07/24] scsi: ufs: mediatek: Rework 0.9V regulator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: vkoul@kernel.org, linux-phy@lists.infradead.org, neil.armstrong@linaro.org, conor+dt@kernel.org, devicetree@vger.kernel.org, olteanv@gmail.com, robh@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260914-mt8196-ufs-v12-7-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-7-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:19:21 +0000
Message-Id: <20260914121921.D3E671F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The return value of `phy_power_on()` is ignored, leading to an inc=
onsistent state if the PHY fails to power on.
- [High] Incomplete state update during error handling in `ufs_mtk_mphy_pow=
er_on()` when `ufs_mtk_09v_off()` fails causes MPHY power state desynchroni=
zation.
--

commit cfb0903918ef13a7077109511fbe7542b2b5728f
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework 0.9V regulator

This commit reworks how the mediatek UFS driver handles the 0.9V regulator.
It transitions from a downstream va09 check to standard avdd09 supply
naming and splits the regulator operations into separate helpers instead of
handling them directly within the phy power-on function.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -508,44 +510,70 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *=
hba, u32 state,

[ ... ]

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
This isn't a bug introduced by this patch, but does ignoring the return
value of phy_power_on() leave the driver in an inconsistent state?

If phy_power_on() fails due to underlying clock or i2c communication
timeouts, this function ignores the failure, unconditionally sets
host->mphy_powered_on =3D true, and returns success. This might cause the
driver to proceed as if the phy is fully operational, leading to hardware
timeouts or system hangs during subsequent controller I/O operations.

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
This is a pre-existing issue, but does this early return cause a permanent
state desynchronization when disabling the regulator fails?

If ufs_mtk_09v_off() fails during a power-off transition, the function
returns early and bypasses updating host->mphy_powered_on. Because
phy_power_off() was already called above, the physical hardware is powered
down, but the software state still evaluates host->mphy_powered_on as true.

On a subsequent resume attempt, the driver would evaluate
on =3D=3D host->mphy_powered_on as true and silently skip powering the phy =
back
on, which could result in a dead storage controller.

>  	}
> =20
> -	return ret;
> +	host->mphy_powered_on =3D on;
> +
> +	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-mt8196-ufs=
-v12-0-9279d7ef814d@collabora.com?part=3D7
