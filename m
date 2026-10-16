Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A8642255C;
	Fri, 16 Oct 2026 12:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154777; cv=none; b=cTcJNQ0rrK4FBu6JWp+sF3BgbjBoFimL+PX4RBuwi4JiCPvuZ9ubCSv8H/684aOtw5jFYOj1fsHAEfJ4hEozQjQUed0BCnse0+OASwLibcAWQ6UFU4bk0QJQX+oKa4bcHEXhzKW7x239DPUfRojj5D1lgEezoV8qCVm4oZaEyWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154777; c=relaxed/simple;
	bh=zTx3jRqYIkqX0qE/sGwz6z0FW+YyVZyX8OtrqqX37nc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=kguXQaGH0/BgbhF4g/mmgviscawreBHCK/I1x7eHUJsAZm1u/VXq2P165qgWo5ndc3mti/Nvl4vwfuaM69ggCOo6bscNLzBjmMuSwVEoVPaP1E3fWXBZWkH6k61hUtNXUOJxSihXwiMQ4JJp2nQ/c859XmDgfGLMtIOqe0krj2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PWgcn4Em; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PWgcn4Em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9E21F000C4;
	Fri, 16 Oct 2026 12:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792154773;
	bh=bZSVr67GOzjeDO8RwnHXv1RMNVjexZQSBUgX5FXEjxg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PWgcn4EmdDe/Fa6k6JRuVHophhopTjcTt7CJ9NxAJGbVnYhjpbQnfYa5dzqmwe8zQ
	 DZPpHcQ8+2JE94hsgHS8mE+EWup/kp0IOlsGipMrjRkab+a3SHO4yUYYT2/Uj2MKlw
	 MkMzKzT6hkjj7EgoOR4yS9onitIunKYp0AURRutkNWzQIpCnvDxhBxLSJo7/oLu4RB
	 PyQf9up/JWObkE+JOGeqdF58QR9Is2/KJtvfehDNr4OqkQLExOg7dGqdkcy7yNWsZo
	 7GxxYFwiq0kh6jGY7CT9zy6lsPGaI3DOfWiCiFd9v6t/3He5wVQqhVZHCjPKOAnM69
	 +MtvLaTGfNUbA==
Message-ID: <sashiko-outbox-174332@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 05/23] phy: mediatek: ufs: Add support for resets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261016-mt8196-ufs-v14-5-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
 <20261016-mt8196-ufs-v14-5-e8d565e0cd45@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 12:46:12 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] phy: mediatek: ufs: ufs_mtk_phy_ctrl silently ignores unknown SM=
C error codes
--

commit f23118e44631c954bc88642a9abc5f62081c23bf
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

phy: mediatek: ufs: Add support for resets

The MediaTek UFS PHY supports PHY resets. Until now, they've been
implemented in the UFS host driver. Since they were never documented in
the UFS HCI node's DT bindings, and no mainline DT uses it, it's fine if
it's moved to the correct location, which is the PHY driver.

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

[Severity: Medium]
In ufs_mtk_phy_ctrl(), will this default case silently swallow other error
codes from the SMC call and treat them as success?

For example, mtk_sip_svc.h defines SIP_SVC_E_INVALID_PARAMS as -2 and
SIP_SVC_E_PERMISSION_DENIED as -4. Standard SMCCC errors like
SMCCC_RET_NOT_REQUIRED (-2) could also be returned.

If the firmware returns one of these errors, the default case will return 0,
making the driver assume the MPHY backup or restore operation succeeded when
it actually failed. Should this explicitly check for success (res.a0 =3D=3D=
 0)
and return an error for any other unhandled code?

> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016-mt8196-ufs=
-v14-0-e8d565e0cd45@collabora.com?part=3D5
