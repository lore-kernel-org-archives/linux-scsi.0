Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1987421229;
	Wed, 23 Sep 2026 19:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790191385; cv=none; b=WDFFRolKpF1FwfU5dlwmQ9KiBezEOujTja7O5udVvBQrlCKIVvnCghcH7HtIvUQMu+YwjZ+tADZ3GEVWLczcaOvNzjvGjpeLs4ZTFeHWfpnP3RVv7YqZ4UWIzGv863ggxLczMNzREaWrBuzHLVKUoC6nGVWoEEy5XUpizoO8HWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790191385; c=relaxed/simple;
	bh=JFiHDwOHLg+mAGeQFK8MIRWRY8XE6fw6Cb9qjbWZ/KU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BAALBL9BSPJw3Yi7VuUEZeFIPbiCl/khLCp/5Vjf1yDJ1y6lYDrhMbOycFg5yBpGq9WJF5AOqO1mv1LYuD76xEI6jgcOV8NkVzrn4Fx26czAgE8qCxkFzZj1kQ6Cg/t0vUv5Mwq5aZNraMfugg2doB5t5zZMUKFhPilkjZ3LKqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZ+LGvnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZ+LGvnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C031F000FF;
	Wed, 23 Sep 2026 19:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790191384;
	bh=D3XsclrIBPHo1cJu6SyP/qgQIz7cKxSligY/nHHLKQM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AZ+LGvnj+0c5GjUK5keW8wnUjmxcpRla21w2IWCq3sqvVzMS2BLIcOxqBGb/QRAcD
	 mdQ/ax9QcwQwhPM2jNE3jDCGxpLR0GVwMz49Qgcblq14Y3+8UsC9Rfrf8mSQ78ZxvM
	 FWl1ooWvK69Lk/savqqNKd7poY+Q/FMn5yRcz55ac33SL3FJwG6QG+sbIsfobHKnO1
	 rbwuaeTJ+/dBPLr34fD0nBaLeVet3VYjPvQSci5O/z0BGZrwOQWgNWMmbeV6lwJX/N
	 nBZpDsqJ7DDgHCaWwR6QMnc2elpbXrAKJQYwPvUSX1TliUZudbESc+dBuPJ52BQ1DY
	 N2/MECHA56TqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] dt-bindings: scsi: Convert hisilicon,hip05-sas-v1 to
 DT schema
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Um9iIEhlcnJpbmcgKEFybSk=?= <robh@kernel.org>
Cc: conor+dt@kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260923191511.2205564-1-robh@kernel.org>
References: <20260923191511.2205564-1-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 19:23:03 +0000
Message-Id: <20260923192304.16C031F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] dt-bindings: missing allOf conditionals for version-specific con=
straints
- [Low] dt-bindings: missing interrupt-parent causes dt_binding_check failu=
re
--

commit 1af097509c0514a80fd91089aea8a399516e8223
Author: Rob Herring (Arm) <robh@kernel.org>

dt-bindings: scsi: Convert hisilicon,hip05-sas-v1 to DT schema

This commit converts the HiSilicon SAS controller binding from a plain text
document to a DT schema. The old text file is removed and replaced with a
new YAML schema covering both v1 and v2 hardware variants.

> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v=
1.yaml b/Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml
> new file mode 100644
> index 0000000000000..27d4cf5078e6e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml
[ ... ]
> +  interrupts:
> +    description: >
> +      Interrupt specifiers for PHY, SATA, and completion queues; orderin=
g and
> +      number depend on controller version.
[ ... ]
> +        - Completion queue interrupts - each completion queue has 1 inte=
rrupt
> +          source
> +    minItems: 58

[Severity: Medium]
Could this global minItems constraint inadvertently reject valid v2 hardware
configurations?

A typical v2 controller (8 phys, 32 queues) needs exactly 42 interrupts
(2 phy + 8 Sata + 32 CQ), which would inherently require fewer than 58
interrupts and fail schema validation.

> +    maxItems: 128
> +
> +  ctrl-reset-reg:
> +    description: Offset to controller reset register in SAS syscon regio=
n.
> +    $ref: /schemas/types.yaml#/definitions/uint32
[ ... ]
> +  ctrl-clock-ena-reg:
> +    description: Offset to controller clock enable register in SAS sysco=
n region.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  hip06-sas-v2-quirk-amt:
> +    description:
> +      Indicates that the v2 controller has the "am-max-transmissions" li=
mitation.
> +    type: boolean

[Severity: Medium]
Does this v2-specific quirk need an allOf conditional block with an if-then
restriction?

Without it, the quirk could silently pass schema validation on v1 hardware,
allowing it to be improperly set where it doesn't apply.

> +
> +  hisilicon,sas-syscon:
> +    description: Phandle of syscon used for SAS control.
> +    $ref: /schemas/types.yaml#/definitions/phandle
[ ... ]
> +examples:
> +  - |
> +    sas@c1000000 {
> +        compatible =3D "hisilicon,hip05-sas-v1";
> +        reg =3D <0xc1000000 0x10000>;
> +        dma-coherent;
> +        interrupts =3D <259 4>, <263 4>, <264 4>, /* phy0 */
> +                     <269 4>, <273 4>, <274 4>, /* phy1 */

[Severity: Low]
Does this example omit the interrupt-parent that was present in the original
text binding?

Without an overriding interrupt-parent, the default schema skeleton assumes=
 a
GIC with 3 cells (#interrupt-cells =3D <3>). This causes dtc validation to =
fail
due to a size mismatch, as the 2-cell interrupts here do not align with the
default parent.

> +                     <279 4>, <283 4>, <284 4>, /* phy2 */
> +                     <289 4>, <293 4>, <294 4>, /* phy3 */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923191511.2205=
564-1-robh@kernel.org?part=3D1
