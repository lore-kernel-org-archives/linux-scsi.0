Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48FF4343F2;
	Tue, 22 Sep 2026 19:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790104190; cv=none; b=q5hR2XvnDJz685Xbu8d/5pMqBE7BaWm7xhTaO4bFSFDTGqjzhLn3InDavNP/PAFJnwylKwpZEhf2vzfS9BpBdT4BtGmliv324PO7LIghA443CleJF90dCnmCMIHmnseKRNY1IcGclvn6zd/bvBrBZWgYnUdUpXNt/K1dvdVUZ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790104190; c=relaxed/simple;
	bh=o4LTPiGny/gQ54itCrnf/+2scV1HhZzTPTmYjzKNIaY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gwa8xH0lt4X9fVKO2kQGNxzYvg0YDiGt7S7Rct6mZM67BkRCxfwdif0zAITiV7vcLlwdP9KTeMYkp1x+kOK/MQpjGI2ecoFbPoTLZD+zy8I4d4qoyjJvUvjDVfw4IvgiWb7zXGGr1kLHQmeiQ3hRZiY6w6CHACq9ezNeH7WrOc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CkBkpvjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkBkpvjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1231F000FF;
	Tue, 22 Sep 2026 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790104188;
	bh=ekpHOi7JoTsBh//XCYnRrkLv216Gg4X6V3DMZ/y0xeU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CkBkpvjVd9jRtJhRmHjUDPVasWjUYDp70Tvh3yqQSxtbKZF2hMO580+6Spqg260Oa
	 N3LVJtun74Pvshfw2X9BSHiUctYoCNzRZ6JQ2GWRgkF2cDptZiDaqCIlyRbSYoQeBd
	 k8fyVkFXKtuQnOxuDBIjcWJKCxgOXtGa/yatFwmY58bFsssbsGeQWXj/VIIwURAfzG
	 nx+gVv4VAxK6A26HaVJMQtI8qCkafcXUsByUUejvfR/eruVh6rVIDWLmOweZUVduJ/
	 QwwsKiTcv9JU2MOizTMr/u+TvaK8nk2HRhEsXeqCX71UcaT6Cas1e5zLny3MCwbn50
	 mc+wPtbEmax6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dt-bindings: scsi: Convert hisilicon,hip05-sas-v1 to DT
 schema
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Um9iIEhlcnJpbmcgKEFybSk=?= <robh@kernel.org>
Cc: linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260922190128.376072-1-robh@kernel.org>
References: <20260922190128.376072-1-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 19:09:47 +0000
Message-Id: <20260922190948.2B1231F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] dt-bindings: hisi_sas: incorrect minItems and truncated example =
for interrupts
- [Low] dt-bindings: hisi_sas: incorrect description for syscon offset regi=
sters
--

commit df864f7524bed6f8dd806c6c738b770b5097c904
Author: Rob Herring (Arm) <robh@kernel.org>

dt-bindings: scsi: Convert hisilicon,hip05-sas-v1 to DT schema

Convert the HiSilicon SAS controller binding to DT schema. It's a
straight forward conversion.

> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v=
1.yaml b/Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml
> new file mode 100644
> index 0000000000000..847d90018243f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/scsi/hisilicon,hip05-sas-v1.yaml

[ ... ]

> +  interrupts:
> +    description: >
> +      Interrupt specifiers for PHY, SATA, and completion queues; orderin=
g and
> +      number depend on controller version.
> +
> +      For v1 hw: Interrupts for phys, completion queues, and fatal
> +      sources; the interrupts are ordered in 3 groups, as follows:

[ ... ]

> +    minItems: 53
> +    maxItems: 128

[Severity: Medium]
Does this enforce an artificially low minimum bound based on a corrupted
example?=20

The YAML conversion drops 5 interrupts from the example (3 CQ interrupts an=
d 2
fatal interrupts), artificially reducing the array size to 53, and then
erroneously sets minItems: 53 to match.=20

If a developer uses this example as a template, the resulting device tree w=
ill
pass schema validation but fail during driver probe. The hisi_sas_v1_hw.c
driver's interrupt_init_v1_hw() function sequentially requests exactly 58
interrupts (phy-count * 3 + queue-count + 2) via platform_get_irq(). For the
example configuration (8 PHYs, 32 queues), it will fail with an error when =
it
attempts to fetch index 53, aborting the probe sequence.

> +
> +  ctrl-reset-reg:
> +    description: Offset to controller reset register in SAS register reg=
ion.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  ctrl-reset-sts-reg:
> +    description: Offset to controller reset status register in SAS regis=
ter region.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  ctrl-clock-ena-reg:
> +    description: Offset to controller clock enable register in SAS regis=
ter region.
> +    $ref: /schemas/types.yaml#/definitions/uint32

[Severity: Low]
Are these descriptions accurate?=20

They incorrectly state these are offsets in the "SAS register region". This
misinforms hardware integrators about which memory space these registers re=
side
in.

The kernel driver (hisi_sas_main.c and hisi_sas_v1_hw.c) correctly retrieve=
s a
syscon regmap using the hisilicon,sas-syscon phandle and applies these offs=
ets
to the syscon region, not the SAS register region defined by the reg proper=
ty.
This is a documentation error introduced during the text-to-YAML conversion
(the original text binding correctly said "ctrl reg").

[ ... ]

> +examples:
> +  - |
> +    sas@c1000000 {
> +        compatible =3D "hisilicon,hip05-sas-v1";
> +        sas-addr =3D [50 01 88 20 16 00 00 0a];
> +        reg =3D <0x0 0xc1000000 0x0 0x10000>;
> +        hisilicon,sas-syscon =3D <&pcie_sas>;
> +        ctrl-reset-reg =3D <0xa60>;
> +        ctrl-reset-sts-reg =3D <0x5a30>;
> +        ctrl-clock-ena-reg =3D <0x338>;
> +        queue-count =3D <32>;
> +        phy-count =3D <8>;
> +        dma-coherent;
> +        interrupts =3D <259 4>, <263 4>, <264 4>,
> +                     <269 4>, <273 4>, <274 4>,
> +                     <279 4>, <283 4>, <284 4>,
> +                     <289 4>, <293 4>, <294 4>,
> +                     <299 4>, <303 4>, <304 4>,
> +                     <309 4>, <313 4>, <314 4>,
> +                     <319 4>, <323 4>, <324 4>,
> +                     <329 4>, <333 4>, <334 4>,
> +                     <339 1>, <340 1>, <341 1>,

[Severity: Medium]
Is this example missing entries?

It appears to be missing CQ 0-2 and the two fatal interrupts, yielding only=
 53
interrupts despite specifying a queue-count of 32.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922190128.3760=
72-1-robh@kernel.org?part=3D1
