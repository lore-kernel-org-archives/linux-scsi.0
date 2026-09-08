Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455193A7D91;
	Tue,  8 Sep 2026 07:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788854103; cv=none; b=E3DXmfdfwwzhRettOe1rH60ON7PmdYCgVCNieu3kIacjPp+SRxJttq072TEFAjO1wBC7WEGF1DHhvUHA2ZrrZuuif/uZuXiP6o63uW6tiIjRc5yh4CrqTK+ED82nr0gK/keyLqkxC2lGYUCloE+LpdVIJuVEQ7rCvr78QJmqz94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788854103; c=relaxed/simple;
	bh=K4Ym8PN35SHvHL0GAvrvHj6kewxSNl1YjdzFppXSOug=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HLInsAh2TyGJH591pPYPN5tSGPt6BdiHICV+9ftHYTZhCJYkz/FUmnpj2zr7gG3a+6p2azM07lEeisqsCupHJscIcyc9taS9JwVy8V2D+uWcHZSxgauwodN8TiY8C2vB/Y/3AE0b6La8RYhIgC5B5a/zENMM0xonYJCqS1ckPo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eh43IUjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eh43IUjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A4A1F00A3A;
	Tue,  8 Sep 2026 07:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788854101;
	bh=/njaPGUC0UnsYXWiMdKzzdlRKyO+rfrsXkLm+Vj1DHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eh43IUjZXawZbxgyCllrheup8Rsn+oZgk7Fs0pDvELBiw2JNMmDZBfs/Z43uMm2qf
	 IeLv7qM9DgOyvs0iBoJV3+fyceCpT8Uozi51qA7FfQmOPTHu2n0x7+7dgF6ttDqkkh
	 kAaS0awZybwK8rIzE7C7pFKuBsKLVpfJB+Yh5XPTg7HTyElKozdiwwo6AHI3dTV3Ga
	 BwLwXZp9AOky30OqxxFP64sGZFq3y4CZfCpeMFPLfUFyZfnHBukqwI5NIMDpMB17fT
	 T8OwqKIufe3pHcbRrW7u4RNdF8UUbHua/v1I31brXTFezZ1kdqyhh4HIgsa9/SXFMA
	 vjuYCbuGTEWIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260908-08-k3-ufs-support-v4-2-22aa2bd97d3b@kernel.org>
References: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
 <20260908-08-k3-ufs-support-v4-2-22aa2bd97d3b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 07:55:00 +0000
Message-Id: <20260908075501.66A4A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing lane 1 configuration for M-PHY tuning attribute 0xe8.
- [High] The SpacemiT UFS platform driver fails to configure PM (Power Mana=
gement) operations, breaking system suspend/resume.
--

commit e432cf6faf83c7fe0612ce4cb8a3f5d0731598d9
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: k3: Add UFS Host Controller driver
   =20
SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
M-PHY v3.0 standard.

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 0000000000000..9d037d90ac5e3
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c
[ ... ]
> +static int ufs_spacemit_link_startup_post_change(struct ufs_hba *hba)
> +{
> +	/* Add 0xe8 make UFS2.1 run GEAR3 + 2Lane@409M */
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x97 },
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0xd7 },
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x17 },
> +		{ UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), UFS_DL_AFC0REQTIMEOUTVAL_MAX },
> +	};

[Severity: High]
Is Lane 1 tuning intentionally omitted here?

The driver declares support for 2 TX lanes, and the comment mentions
configuring "2Lane@409M". However, the M-PHY tuning attribute 0xe8 is
only configured for Lane 0 via UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0).

Operating in 2-lane mode without applying the same PHY tuning to the
second lane can cause link instability or negotiation failures. Should
this also configure Lane 1?

[ ... ]
> +static struct platform_driver ufs_spacemit_pltform =3D {
> +	.probe	=3D ufs_spacemit_probe,
> +	.remove	=3D ufs_spacemit_remove,
> +	.driver	=3D {
> +		.name	=3D "ufshcd-spacemit",
> +		.of_match_table =3D of_match_ptr(ufs_spacemit_of_match),
> +	},
> +};
> +module_platform_driver(ufs_spacemit_pltform);

[Severity: High]
Does this driver correctly configure power management?

The platform driver structure does not initialize the pm field in its
driver sub-structure. Without a valid dev_pm_ops structure, the platform
bus will not invoke any PM callbacks for this device.

This means the UFS host controller will not participate in system
suspend/resume or runtime power management, which can lead to power
drain or system crashes on resume if the power domain was gated by
firmware. Should this assign standard UFS PM callbacks to the pm field?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-08-k3-ufs-=
support-v4-0-22aa2bd97d3b@kernel.org?part=3D2
