Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876423B27FA;
	Thu, 30 Jul 2026 09:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405600; cv=none; b=aOCf1PWB1087fNss4NNFIleGQMUCNBfyFM4lJ/tC2iQ5usxQfwGAGTGQaEQvtkFRlwpNNPasUO1iyZ0zF7BmWRTTjICGu8FzPsud7DZCw9smGvkzoLTRSIziL64O+L4s89Nmok0WjJiZf61hvlwRv0om83msB5kZgS13gtoaL4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405600; c=relaxed/simple;
	bh=tchxTTvBcdO02dGHnWnKG4MhRfWMWJsiYVUkgq7JxyA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eP0HoORISUrdDFV58WxfBMA0euztUNOOJhAKZiuxXXNMBueoy5Ihtg6U9PVDf3nDaILdJfXqMjHM6Mo5X1Nvg+WKLwkSpr/+nOFc2okIQr1CDUljv5NM/paCAINoGtykg//7AQOYIYtM3TPOjSo5Dd0ZSFqK2ChRzw2mw0NKBhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igOVAejB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igOVAejB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ED01F000E9;
	Thu, 30 Jul 2026 09:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785405599;
	bh=WK2tHPEkzBY2stLBdpC+fE4u48BNObxZFm8c/FNCDFM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=igOVAejB/OUbAzCHWVWjSSqRus6Ju7IUtE0GOUwaAXfEOBAabcicXh7NLGDU2x00I
	 SJ2E05ZfPDyWBkLmGRnRQqY1a/nHsyV7KwSc3/ybfX9jS95PdtUe7rJW0nEiPWll8Y
	 HoSYa7ZJTZ7DVC3kNOrFOoMx6fA0YSrc4jLJpyi7dXYhuXKkEqUR8HbOS1mwkEjMeU
	 +aHSayHpWmqzezIl/nE2vRcaZEm6klGlvRdWwfOaRg/U5FO04EFWz4SmbFqUh5ff/h
	 idphYHK140k5YpheYQM8rWZMSI1uiiXrRn4ytm2ENCtSjXjV62baPwPb9IycRi+ACi
	 64diCu6dIJA+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 03/26] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: devicetree@vger.kernel.org, linux-phy@lists.infradead.org, conor+dt@kernel.org, neil.armstrong@linaro.org, robh@kernel.org, vkoul@kernel.org, olteanv@gmail.com, linux-scsi@vger.kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-3-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-3-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 09:59:58 +0000
Message-Id: <20260730095958.88ED01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] A typo in the `mediatek,mt8192-ufshci` conditional block uses `c=
locks-names` instead of `clock-names`, bypassing array length validation.
- [Low] The binding omits a supply property for the `AVDD09_UFS_1` pin, tyi=
ng it to `AVDD09_UFS`, which violates the principle that Device Tree descri=
bes the SoC hardware rather than a specific board's power routing.
--

--- Patch [3]: [PATCH v10 03/26] dt-bindings: ufs: mediatek,ufs: Add mt8196=
 variant ---
commit e0eeeaec009272d40ddbc2fee8902782c15e776c
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

dt-bindings: ufs: mediatek,ufs: Add mt8196 variant

The MT8196 SoC's UFS controller uses a different set of supplies, making it
incompatible with MT8195. This commit adds a compatible string for mt8196
and updates the binding. It also notes that the AVDD09_UFS and AVDD09_UFS_1
pins are commoned together on the referenced board.

> While it does have a AVDD09_UFS_1 pin in addition to the AVDD09_UFS pin,
> it appears that these two pins are commoned together, as the board
> schematic I have access to uses the same supply for both, and the
> downstream driver does not distinguish between the two supplies either.

[Severity: Low]
Does omitting a separate supply property for the AVDD09_UFS_1 pin violate t=
he
principle that Device Tree bindings should describe the SoC hardware rather
than a specific board's power routing?

If a future board design supplies the AVDD09_UFS and AVDD09_UFS_1 pins from
separate voltage regulators, the current binding wouldn't be able to accura=
tely
describe that hardware.

While reviewing the file touched by this patch, I noticed a regression in t=
he
conditional block for the mt8192-ufshci compatible string:

Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml:allOf
>   - if:
>       properties:
>         compatible:
>           contains:
>             const: mediatek,mt8192-ufshci
>     then:
>       properties:
>         clocks:
>           minItems: 3
>           maxItems: 3
>         clocks-names:
>           minItems: 3
>           maxItems: 3

[Severity: Medium]
Is the "clocks-names" property a typo here? It seems like this should be
"clock-names".

Because of the typo, the length of the clock-names array is not properly
constrained for mt8192-ufshci. An invalid device tree with 3 clocks but a
mismatched number of clock-names could silently pass dt_binding_check valid=
ation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D3
