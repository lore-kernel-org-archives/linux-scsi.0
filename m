Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECAF4AE109;
	Fri, 16 Oct 2026 12:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154801; cv=none; b=MMGKlYk8JOEFlVtLiIWJ6WO28viM51Zji7MDl0XRZvPeaJvKmvAVbRjHYfsAMCdOCeTO36iLbCVdCE0ELTuHDvHCPNSEnJTy27l1e7bFv9fnQF9hiJrsugY+6ZlujcOlWnG9QTSEIlxGVfZ5ajIqgBUA3JO9giLHSp56kWWdtJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154801; c=relaxed/simple;
	bh=ZDFHTXyAZThK3CaaXd5DPwvhDcExsBTjb7giRFHJ/dk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OX2P4PgK7oBGMONRIcq1TVJqKvhvL5C5U4oAsv4vatP/t6+r/elJ+fXf2q/Redgd1zCgyeXaPZYZQNhCz3oKX4Af77yW7FDMqrwqYUrNK5nKdqjjn6gZB43mEJeaOH58X6wWDvF4x+Ozh6+y9PLkUO08g6UBVfHcLoBWhORz1Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKGyFuyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKGyFuyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE011F000C4;
	Fri, 16 Oct 2026 12:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792154799;
	bh=wsQYsV1A6d3Q9LTOhBvoV1/8at0kxLQz0vH3H68Dex4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SKGyFuyWcy9p1xIgFNeeENir2EK1iGEqcjOS+x3uCLdv0gmDZqRNhTfOzEKAh9Utx
	 X2g5pcg0nyjEawqqS4BkiPHvlE6gvuVYOLrNLOkfipW7Re1hOvFf+V0tHorljmY3cy
	 BGU49Sr6rXCAGv+rStGYHkTOpn6zuSaRvfNSxRBYJAqIK5Y6u2SKh1k/UCwJTFvn+k
	 DDiW4IRS+FL605BQMRYePuOMwM755G4q9Tl3p26XSfETUG4OsVvSlCcfanDiBhLvkK
	 8BQ8NcCZ2q6qnACfVVj6hQaeMYimH97OE6n7OxYjwVDs54CNfbUDsxVc2bA4sTlw8G
	 CVPoDr986CoTg==
Message-ID: <sashiko-outbox-174333@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 02/23] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261016-mt8196-ufs-v14-2-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
 <20261016-mt8196-ufs-v14-2-e8d565e0cd45@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 12:46:38 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] dt-bindings: ufs: mediatek: incompatible schema change breaks in=
-tree mt8195.dtsi
--

commit 2eee1dd0c91a095faf6d7717e0d6ad307cbf851d
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

dt-bindings: ufs: mediatek,ufs: Complete the binding

This commit updates the mediatek,ufs.yaml binding by making freq-table-hz
disallowed, enforcing operating-points-v2, and renaming and expanding the
clock requirements for MT8195 and MT8192 platforms. It also documents vario=
us
power supply pins and adds a new example for MT8195.

>     Disallow freq-table-hz and move to operating-points-v2. It's fine to
>     break compatibility here, as the binding is currently unused and would
>     be impossible to correctly use in its current state.

Is this description accurate regarding the binding being unused?

Looking at arch/arm64/boot/dts/mediatek/mt8195.dtsi, there is an active
mainline user of the mediatek,mt8195-ufshci compatible string:

arch/arm64/boot/dts/mediatek/mt8195.dtsi:ufshci() {
        ...
        compatible =3D "mediatek,mt8195-ufshci";
        ...
        clock-names =3D "ufs", "ufs_aes", "ufs_tick",
                      "unipro_sysclk", "unipro_tick",
                      "unipro_mp_bclk", "ufs_tx_symbol",
                      "ufs_mem_sub";
        freq-table-hz =3D <0 0>, <0 0>, <0 0>, <0 0>;
        ...
}

Will this change cause dtbs_check validation to fail for the MT8195 platform
since it still relies on freq-table-hz and the old ufs-prefixed clock names?

> diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Do=
cumentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> index 15c347f5e6604..945cb986b06b7 100644
> --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml

[ ... ]

> @@ -54,29 +96,41 @@ allOf:
>        properties:
>          compatible:
>            contains:
> -            enum:
> -              - mediatek,mt8195-ufshci

[ ... ]

> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt8195-ufshci
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 10
> +        clock-names:
> +          minItems: 10

[Severity: Medium]
Does enforcing a minimum of 10 clocks here break existing in-tree device
trees?

As shown above, the existing mt8195.dtsi specifies exactly 8 clocks. Because
this patch requires 10 clocks, explicitly requires the new names without the
ufs_ prefix, and forbids freq-table-hz, will it break backward compatibility
and leave the tree in a broken state for MT8195 users?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016-mt8196-ufs=
-v14-0-e8d565e0cd45@collabora.com?part=3D2
