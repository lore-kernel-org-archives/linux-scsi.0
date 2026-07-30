Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE3D410D32;
	Thu, 30 Jul 2026 11:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785410009; cv=none; b=EGx+O/pR+ey/KxpuTNz7JhWswtwbbimzah9e+h0bhQYj3CsWbsU7h7GCmWC337tIve+m2sIS9j4FQiUaSbbbAPjHt7hTdWwq6Cd5YeBHGuyvq053poi/mHKpfWA1q4Jfb7HGV1vu/iTVKcqv5lGNkXRycovQWPfCk8fpAPi8il4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785410009; c=relaxed/simple;
	bh=6cxibO1OAUR7Y0Nyaqf/c9Eu5zMlvus+uTTntTeH8ns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jRfQBqXLFnGvVA+pP8A56mjk9on1jqbpD26VhpghkSctPmRnQSnTuq8E2CfB/am87Cye3bxsiZFykGR1swHNKjjQvwvnZX2EwFD4cPYLhzVPolrehFgf1iHJqv7xfFjO9atkwhhh5YsZRPV7IaKkoagJArKGzd3bV1/g0j+bahU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwcJc3lZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwcJc3lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D051F00A3A;
	Thu, 30 Jul 2026 11:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785410007;
	bh=aPOvsIc3guHZFzSxfhOwyQI1XWMCxa87Cbpi6kj7XmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BwcJc3lZpkKPGfehX0CFhcOgvguoxoFTa16dBhoxoL7Dl2P7lQHefdj8uoVVWH5Fy
	 wFkpADZi2g6tKBEHZXuH+iCHwWua134rdzsvQ+8PVQffhaRHg5AfjEpMeBv/IJfObf
	 QyQrMfUrfzbqEQjsi5/3VxC0XXef9ELjP/wiDORxcc79kbPg65p9bBOod9IVLK4r6p
	 R1up+B1rHkEmcOXEF1BboxmImzVE6BaIhJa9q93RgiGovtHnZKPIobM6JH1U2H/ux/
	 kAAp34jvwYTymCQSGayluVGeRZu0Ss+7htBPd/5xvGEDVPv2xY4ohN7cZXmP5fNNg+
	 dxVYKFpaG+6ZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 24/26] arm64: dts: mediatek: mt8195: Align ufshci
 node to dt-bindings changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: olteanv@gmail.com, robh@kernel.org, devicetree@vger.kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org, neil.armstrong@linaro.org, linux-phy@lists.infradead.org, vkoul@kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-24-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-24-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 11:13:26 +0000
Message-Id: <20260730111326.E2D051F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Removing the `freq-table-hz` property without adding an `operating=
-points-v2` table causes the UFS core platform driver to skip parsing and e=
nabling all hardware clocks, resulting in a controller initialization failu=
re.
--

--- Patch [24]: [PATCH v10 24/26] arm64: dts: mediatek: mt8195: Align ufshc=
i node to dt-bindings changes ---
commit eac3ed6e6791c53424e4e025e4dfd47b68309eb7
Author: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

arm64: dts: mediatek: mt8195: Align ufshci node to dt-bindings changes

This commit updates the MT8195 UFS host controller dt bindings by adding
new required clocks and removing the deprecated freq-table-hz property.
It states that converting to an OPP table is not needed since the values
were all zero.

> diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt8195.dtsi
> --- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
[ ... ]
> @@ -1481,15 +1480,15 @@ ufshci: ufshci@11270000 {
>  				 <&infracfg_ao CLK_INFRA_AO_UNIPRO_TICK>,
>  				 <&infracfg_ao CLK_INFRA_AO_UFS_MP_SAP_B>,
>  				 <&infracfg_ao CLK_INFRA_AO_UFS_TX_SYMBOL>,
> -				 <&infracfg_ao CLK_INFRA_AO_PERI_UFS_MEM_SUB>;
> -			clock-names =3D "ufs", "ufs_aes", "ufs_tick",
> -					"unipro_sysclk", "unipro_tick",
> -					"unipro_mp_bclk", "ufs_tx_symbol",
> -					"ufs_mem_sub";
> -			freq-table-hz =3D <0 0>, <0 0>, <0 0>,
> -					<0 0>, <0 0>, <0 0>,
> -					<0 0>, <0 0>;
> -

[Severity: High]
Does removing this property introduce a regression in the UFS controller
initialization?

Looking at ufshcd_parse_clock_info() in drivers/ufs/host/ufshcd-pltfrm.c,
the driver skips parsing the clock properties entirely if freq-table-hz is
missing:

drivers/ufs/host/ufshcd-pltfrm.c:ufshcd_parse_clock_info() {
    ...
	sz =3D of_property_count_u32_elems(np, "freq-table-hz");
	if (sz <=3D 0) {
		dev_info(dev, "freq-table-hz property not specified\n");
		goto out;
	}
    ...
}

Since an operating-points-v2 node is also absent, the alternative parser
ufshcd_parse_operating_points() will also return early. This leaves
hba->clk_list_head empty.

If the list is empty, ufshcd_init_clocks() and ufshcd_setup_clocks()
will silently return without turning on any hardware clocks.=20

Could this cause a probe failure or a system crash (SError) when the driver
later attempts to access unclocked UFS MMIO registers?

> +				 <&infracfg_ao CLK_INFRA_AO_PERI_UFS_MEM_SUB>,
> +				 <&topckgen CLK_TOP_UFS_RX_SYMBOL>,
> +				 <&topckgen CLK_TOP_UFS_RX_SYMBOL1>;
> +			clock-names =3D "main", "aes", "tick", "unipro_sysclk",
> +				      "unipro_tick", "unipro_mp_bclk",
> +				      "tx_symbol", "mem_sub", "rx_symbol0",
> +				      "rx_symbol1";
> +			interrupts =3D <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH 0>;
> +			phys =3D <&ufsphy>;
>  			mediatek,ufs-disable-mcq;
>  			status =3D "disabled";
>  		};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D24
