Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85559427F89;
	Tue,  1 Sep 2026 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788278489; cv=none; b=uYk052tjwYCSy2diLkgfmkKo/CHCYwoSAhC8VG/R2PBCM8XAjrWj0oeqwK+zpnMgNIE7FXmcbC3Vp4E1/3XzrhD7wcmBQla6MPfojNoW0Tn61s25HudgkmdPQKF35amfrUvER5Y2V9uKak7SOkOFIVOvHuHoACTX4jLBESJYg3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788278489; c=relaxed/simple;
	bh=K6iOz3xv8JB2fRba2PHEdYq6MTfzDlm/uF66JgGGg7U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qeAUArgZ3xxAjQ1I2MxEe7dTxQVtNkCequiBT6oTpwbfitTlIFfASKaH1vf1HG4m+rA0A7CtpwAEnUqxi7QkcqFEaJANJlj5l1ZWu5ra3EyBFScy1iC2R/kK20f1d7x+MwXTh2S4PrPrT+b3cANB8qFPSjPfvJrDhkgbBok4rdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TP14xNfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TP14xNfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32C51F000E9;
	Tue,  1 Sep 2026 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788278488;
	bh=c5EM6whpJGf7ZLLsPgoToeYQCNIHsO6sbxBPilETrPM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TP14xNfo5eQ+AXWQDUSw/o5JZt0o8oE2ZmUrn1of7QmQqLrs3r4ttHLKc7W0JMMKP
	 q8aA+ZDEYVlIPGF+k+JcMaqd/TebiC2ufYYVordGvl7FolKafrAKxhSA9URV4Ky0nD
	 aZoupALvmSfGAq9hG2r0u9UnKSADdxTbkH0CFH9ENebnr3xAYrtNWrpN5POWM0SRR6
	 2i8YiuwBG2Qm/VTvCowFluxVEs8CPrg+YBIXMRDwLXQLXhSFHSWsScfBKnMTXwjExE
	 u3Ey0MTqQz7q59m9JnwXkTG8CHnrc8wLZ0InQjpSE48gBCt6PkCkdfCfipTrwqe4ow
	 xkkVXmjNV/+3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 02/24] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, linux-phy@lists.infradead.org, olteanv@gmail.com, linux-scsi@vger.kernel.org, neil.armstrong@linaro.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-2-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-2-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:01:27 +0000
Message-Id: <20260901160127.E32C51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Changing clock names and constraints breaks DT validation for th=
e existing in-tree user `mt8195.dtsi` and omits crypt clocks expected by th=
e driver.
- [Low] Missing `#include <dt-bindings/interrupt-controller/arm-gic.h>` in =
the newly added device tree example.
--

commit 043addd7d18e6896e3ee286c9ea8d5a48e6e340a
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

dt-bindings: ufs: mediatek,ufs: Complete the binding

This commit updates the mediatek,ufs.yaml binding to make it more complete.
It disallows the deprecated freq-table-hz property, adds reset controls and
power supplies, modifies clock names by removing the ufs_ prefix, and
updates constraints for MT8183, MT8192, and MT8195. It also adds a second
example for MT8195.

> diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Do=
cumentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> index 15c347f5e6604..945cb986b06b7 100644
> --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml

[ ... ]

> @@ -19,11 +19,25 @@ properties:
> =20
>    clocks:
>      minItems: 1
> -    maxItems: 8
> +    maxItems: 10
> =20
>    clock-names:
>      minItems: 1
> -    maxItems: 8
> +    items:
> +      - const: main
> +      - const: aes
> +      - const: tick
> +      - const: unipro_sysclk
> +      - const: unipro_tick
> +      - const: unipro_mp_bclk
> +      - const: tx_symbol
> +      - const: mem_sub
> +      - const: rx_symbol0
> +      - const: rx_symbol1
> +
> +  operating-points-v2: true
> +
> +  freq-table-hz: false

[Severity: Medium]
Will this change cause dtbs_check validation failures for existing in-tree
device trees?

The in-tree arch/arm64/boot/dts/mediatek/mt8195.dtsi still uses the old
clock names and the freq-table-hz property:

arch/arm64/boot/dts/mediatek/mt8195.dtsi:ufshci() {
    ...
    compatible =3D "mediatek,mt8195-ufshci";
    ...
    freq-table-hz =3D <0 0>, <0 0>, <0 0>;
    ...
}

Since this patch explicitly disallows freq-table-hz and renames the clocks
without updating the dtsi, running make dtbs_check against the unchanged
dtsi will fail.

Additionally, does this list of clock names omit the crypt clocks? The
driver actively requests the crypt_mux, crypt_lp, and crypt_perf clocks
(along with the mediatek,ufs-boost-crypt property) in
ufs_mtk_init_boost_crypt().

[ ... ]

> @@ -94,9 +148,32 @@ examples:
>              phys =3D <&ufsphy>;
> =20
>              clocks =3D <&infracfg_ao CLK_INFRA_UFS>;
> -            clock-names =3D "ufs";
> -            freq-table-hz =3D <0 0>;
> +            clock-names =3D "main";
> =20
>              vcc-supply =3D <&mt_pmic_vemc_ldo_reg>;
>          };
>      };
> +  - |
> +    ufshci@11270000 {
> +        compatible =3D "mediatek,mt8195-ufshci";
> +        reg =3D <0x11270000 0x2300>;
> +        interrupts =3D <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;

[Severity: Low]
Does this new example fail to compile with dt_binding_check?

The example uses the C preprocessor macros GIC_SPI and IRQ_TYPE_LEVEL_HIGH
without including the header file that defines them. Since dt-schema parses
each example block independently, a missing
#include <dt-bindings/interrupt-controller/arm-gic.h>
will cause dtc compilation to fail during make dt_binding_check.

> +        phys =3D <&ufsphy>;
> +        clocks =3D <&infracfg_ao 63>, <&infracfg_ao 64>, <&infracfg_ao 6=
5>,
> +                 <&infracfg_ao 54>, <&infracfg_ao 55>, <&infracfg_ao 56>,
> +                 <&infracfg_ao 90>, <&infracfg_ao 93>, <&topckgen 212>,
> +                 <&topckgen 215>;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D2
