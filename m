Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E65401A0A;
	Thu, 30 Jul 2026 09:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405450; cv=none; b=JPLg0usPTtViovWbS96ZGSWLN8Q1oS4hKvIVCTKWLhx5O+Uzq45E4n5AXwP7M11gvxEZlzfYnsjzXODsJC1kTFINtGEBjmQW+X2FRN2s0dQepR27D1/M7UfMiEqDfT1Lzpwtt1W+KUlqdUbK8sAjk0P6dvho/+BD+M8BLxLXfjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405450; c=relaxed/simple;
	bh=X6dmBnceiESCZAqE6/ztrMyuTNb0v2wTjNX5z13Q94M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T+Dd264IKAwKTp+cJ4cPVfPL+8XnIgZz9oBrZ9guwKv754pi1oIXUkHWkrAliDRJhfvxhR+MRImU0dE1IVE+t/86EXDVYBGBCccznBTfWTwPFyNls7wD6sI3tC1e3PaDn6qOfZY4SzpPMiYAfmKNZyzRMJnCZz+i0VreHRSI4ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqchFDnE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqchFDnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8891F00A3A;
	Thu, 30 Jul 2026 09:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785405449;
	bh=b+vfWu1ola51xy9nswRhq9CC0HcMCp0ViCVth5o0f2A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jqchFDnEVVu59jScbr8g+voltb1YxA+ir9chWBov/wVPbNocMehlw+6ryOCTw44Bv
	 8pzVJ9DUgK4gLcp3E5a5lmHAx33bxMhzIQW5En7SSJ0ZEA1F2ru77RjqRfWLHFmIbl
	 VegsCRloIMFLBA72734EZ2yOHwB0OiZXLqTS/PSzYENSicYDhIWS9H838bAxfQPwCa
	 TNoTPfD5QGwXKagSsX4WOIBC0dGZSJqTTyeRF96cgguUEsnlVpMNmeAJDlsQBuwgW3
	 fJXKXEuL+qG20QSi9Zd8p0D8dvlZQuBZENdVMs2SwPycSkdnNbsRWslFltRa6yUiid
	 KYoYEbzA4scgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 02/26] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: conor+dt@kernel.org, neil.armstrong@linaro.org, devicetree@vger.kernel.org, linux-phy@lists.infradead.org, olteanv@gmail.com, robh@kernel.org, vkoul@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-2-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-2-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 09:57:28 +0000
Message-Id: <20260730095729.0A8891F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The property `clock-names` is misspelled as `clocks-names` in the M=
T8192 conditional block, leaving the actual property unconstrained.
--

--- Patch [2]: [PATCH v10 02/26] dt-bindings: ufs: mediatek,ufs: Complete t=
he binding ---
commit 515312405d3e2237cad578f6e9bc085ee3772431
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

dt-bindings: ufs: mediatek,ufs: Complete the binding

This commit updates the MediaTek UFS binding to replace deprecated frequency
tables with operating-points-v2 and adds missing optional resets. It also
corrects the clock definitions for different SoC variants and documents the
required power supplies.

> diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Do=
cumentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> index 15c347f5e6604..e7e360c59ba59 100644
> --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml

[ ... ]

> @@ -54,29 +96,41 @@ allOf:

[ ... ]

> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt8192-ufshci
> +    then:
>        properties:
>          clocks:
> -          maxItems: 1
> +          minItems: 3
> +          maxItems: 3
> +        clocks-names:
           ^^^^^^^^^^^^

[Severity: Low]
Is there a typo in this property name? It appears to say clocks-names inste=
ad
of clock-names. This might leave the actual clock-names property unconstrai=
ned
for the MT8192 hardware variant and cause schema validation to miss incorre=
ct
device tree configurations.

> +          minItems: 3
> +          maxItems: 3
> +        avdd09-supply: false

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D2
