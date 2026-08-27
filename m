Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F0535675E;
	Thu, 27 Aug 2026 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847273; cv=none; b=Hv95DI9JhW4yvW+onBD9i4LtUddL6n210Gy3aeLzM/10QVL3znjajG3BiB7bUZT/6ZWvLHqWZpQUuWPUF8RCfk8Ay8frK1+APFkpQleyHix471zrGtY4ONP6AOsGLO9DdVedwX4lbzNp4/FPyiM8DJ2yc4ygQ5HyMkhfSODvLcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847273; c=relaxed/simple;
	bh=qnXfusm4Vy4fRBP8m/pp2NJPd9sSeM3/8509lH7TD6E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m7g4zZ8IpvyhlQIPRnY59/EZr5KfAi9phV3hzfnBDB+VWYlIyNeCekUDni0s+4vagPyu64JZkcsBd5EwZ/f7m9F4HzsWeKrjgSxZ6HTPuHhxzXcrYO5IvJJuQO21iRGdzPfxoES/X0lzn+DlrqeW0nbSRJzsfQd8a9q6Eln1f+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5ftD2FQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5ftD2FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092961F000E9;
	Thu, 27 Aug 2026 16:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847272;
	bh=EyCbhDUwMdZlqDDVFpBmpsGxdaf+oHWdpoCx4wQI54U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P5ftD2FQyKbNExCPxFTh/pLrtDTNY5xZ1lwjeuVVvdQwsrnxJCR4xldzlTHZ9QlSk
	 lEobj/hw1QVtFyaJ0ByTar82jFc/9LZZ0L8nQYa8drsh/L9E92HhufYk1CWmPbKXPC
	 Mhb9mhmhRpoF+7Nbb4gu3RcuDGx7UYVRS+b13Ts8X202wr9UnWc+5KwSySoZdZU9Lc
	 HRurzR/6VBxlQOXyj2xEE8FGT5pME4YXk56ji8/hA/vqQ/q8WFfFyU3MBW0H/0xJV3
	 21GFRs1Nv4BbLTrcVjAXWE8XGBIpE0nRmyTrgmduhkolGCUzRuyfqa7C9u5PFeyFH4
	 JsyXtRTvA64JA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 04/11] dt-bindings: soc: qcom: add binding for
 qcom,crypto-virt
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: devicetree@vger.kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org
In-Reply-To: <20260827160806.1295313-5-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-5-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:14:31 +0000
Message-Id: <20260827161432.092961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The device tree binding uses a driver-centric title and an undersco=
re in the example node name, which violates device tree conventions.
--

commit 76a2bbd8a4bf8175fb462a6f688e076226259b19
Author: linlzhan <linlin.zhang@oss.qualcomm.com>

dt-bindings: soc: qcom: add binding for qcom,crypto-virt

This commit documents the device tree binding for the Qualcomm GVM crypto-v=
irt
node. It provides the wrapped-key buffer size needed by the driver to perfo=
rm
hardware-wrapped-key SCM operations backing virtio_blk's inline crypto laye=
r.

> diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,crypto-virt.=
yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,crypto-virt.yaml
> new file mode 100644
> index 0000000000000..5eb204f297627
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/soc/qcom/qcom,crypto-virt.yaml
> @@ -0,0 +1,39 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/soc/qcom/qcom,crypto-virt.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: QCOM GVM Crypto Virt driver

[Severity: Low]
Does this title violate device tree conventions by describing an OS driver
instead of the hardware or firmware interface?

[ ... ]

> +additionalProperties: false
> +
> +examples:
> +  - |
> +    crypto_virt {

[Severity: Low]
Should this example node name use a generic hyphenated name instead of an
underscore?

Using an underscore here propagates styling violations that trigger
'node_name_chars_strict' warnings during DT schema validation.

> +        compatible =3D "qcom,crypto-virt";
> +        qcom,wrapped-key-size =3D <100>;
> +    };

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D4
