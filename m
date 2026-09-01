Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB3942B74B;
	Tue,  1 Sep 2026 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788279865; cv=none; b=rSuU2uX3Z2AW9edD5r5yN/q7MK+0yA+0rnbVbb2UpQRMyoRfgrtSvgAiW6Hr/pz9RZ8mLiH/J8M+1aPzGxmPLndT/eZzyBfw81eOPwPqHy25J14K77fNsg9jIHQb/7ZVNy75xpOx7K/NU8WwYxvkIkMccLZltlY3kG1yygTPzE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788279865; c=relaxed/simple;
	bh=uF1K285igNNP9OjFv8GkTvMswztos5DyPyCES4Xx7e4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ucqfjlVxDVn8bTTe9Bes6Z/4Lv5vTXLAP+0B+30dK+DM31YxLzM2t5cqQQQ/5mknZf4LTUDq+SZhDZXrnr9QKiFlwBTVd6tG2RqlqGbUPaIKyaa3uV+R0eXPhotR/7rusNImMmRLhbfJymQ68dCtvN5d1QcNfIfsfjWjn4iWth8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LpaO8rBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LpaO8rBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4EE1F000E9;
	Tue,  1 Sep 2026 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788279864;
	bh=4UDZXTh6iCv0rFf07r29tde1mAL7NZr4a/6nnT9fwTI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LpaO8rBSyHasOXJ6e4yyjYXyOxfQn5Q3hjfEU3owKYQoriSp73sttdTD4oVWoFR5Y
	 xa8wtLI4Smfqia8kBDwP45K8q3IkpMJ0faR8w9Vwyr80OOjWZvKKwcWr+xgViJtnRx
	 he2wAfnIWsmTBP2tDfN/TSWWd7bXNFsQ0BGL7rNXP6oQaFusH1lt/s7a2UdB4EG7gJ
	 yG6mj1ScnF1J7hMgSRl5c3RAmaAdBIxVyHmgwaEMBSsRas3fQ9ccOPKCqCZrVCjSti
	 CyoCOwSB7/Ze5y0msVI64ksw/f1uwJHatznapSFmf0kuZ7gnDZoVVIICW+57K22C6L
	 YNjBqsxfSwzvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 20/24] scsi: ufs: mediatek: Rework hardware version
 reading
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org, olteanv@gmail.com, robh@kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-20-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-20-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:24:23 +0000
Message-Id: <20260901162423.BB4EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Ignored return values from `ufshcd_dme_get` lead to uninitialized =
stack variable usage.
- [High] Missing return value checks for `phy_power_on` and `ufs_mtk_mphy_p=
ower_on`.
--

commit ba11979e3018428c0d10fd5e9353229a8db31ad0
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework hardware version reading

Split assignment to the host struct out from the read function, and
utilise bitfield helpers to simplify the code. Also move the debug print
out of the legacy version helper, which means it no longer has to take a
struct ufs_hba as an input, and can be rewritten as a pure function.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 4e916d5ac2af7..f405f511f41fd 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -1232,7 +1229,11 @@ static int ufs_mtk_init(struct ufs_hba *hba)
> =20
>  	ufs_mtk_setup_clocks(hba, true, POST_CHANGE);
> =20
> -	ufs_mtk_get_hw_ip_version(hba);
> +	host->ip_ver =3D ufs_mtk_get_hw_ip_version(hba);
> +	host->legacy_ip_ver =3D ufs_mtk_is_legacy_chipset(host->ip_ver);
> +
> +	dev_dbg(hba->dev, "IP version 0x%x, legacy =3D %s", host->ip_ver,
> +		str_true_false(host->legacy_ip_ver));
> =20
>  	return 0;

[Severity: High]
This is a pre-existing issue and was not introduced by the patch under
review, but does ufs_mtk_init() ignore the return value of
ufs_mtk_mphy_power_on() when it is called earlier in this same function?

If ufs_mtk_mphy_power_on() fails (e.g. because regulators fail), probe
continues and eventually returns 0 (success). Attempting to communicate
over an unpowered PHY or accessing its registers can result in an
asynchronous bus fault, device timeout, or kernel hang.

Looking at ufs_mtk_mphy_power_on(), it also seems to ignore the error code
returned by the generic PHY power-on routine, incorrectly returning 0
(success) when phy_power_on(mphy) is called:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_mphy_power_on() {
    ...
		ret =3D ufs_mtk_09v_on(host);
		if (ret)
			return ret;
		phy_power_on(mphy);
	} else {
    ...
}

[Severity: High]
This is also a pre-existing issue and was not introduced by the patch under
review, but do we use uninitialized stack variables in ufs_mtk_cfg_unipro_c=
g()
and ufs_mtk_post_link() if ufshcd_dme_get() fails?

In ufs_mtk_cfg_unipro_cg():

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_cfg_unipro_cg() {
    ...
		ufshcd_dme_get(hba,
			       UIC_ARG_MIB(VS_SAVEPOWERCONTROL), &tmp);
		tmp =3D tmp |
		      (1 << RX_SYMBOL_CLK_GATE_EN) |
		      (1 << SYS_CLK_GATE_EN) |
		      (1 << TX_CLK_GATE_EN);
		ufshcd_dme_set(hba,
			       UIC_ARG_MIB(VS_SAVEPOWERCONTROL), tmp);
    ...
}

If ufshcd_dme_get() times out or fails due to intermittent link issues, tmp
retains stack garbage. Modifying and writing this garbage back to
VS_SAVEPOWERCONTROL can corrupt the UFS configuration, break the link, or
hang the bus.

A similar issue appears in ufs_mtk_post_link():

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_post_link() {
    ...
		ufshcd_dme_get(hba, UIC_ARG_MIB(VS_DEBUGOMC), &tmp);
		tmp |=3D 0x100;
		ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGOMC), tmp);
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D20
