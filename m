Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9686F448B9B;
	Thu,  1 Oct 2026 08:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843910; cv=none; b=T/gerJACpxV6CdZE47M5X7ONOeUxiF7rtugEXJfUL5Mz05txAwWPsnQjB1hX8mly3bYMtEqVwEEI8xIa5wB/DCRFMboOhxLvPls7yNkt21nZ+vK+NClgU4iTib+71E2LWNrhYNKhIlPm26ueJrjd9Wj8XADtifX7IlqHXwUOyy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843910; c=relaxed/simple;
	bh=5D/jyZSHpIoSL6Y3LMLCGrRtqV1KRi+XEvEJYWOqxHc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lxxCtgkxNewPsWGLLAhiu7z3BIzRl4IWdLM1czcKTU6OAi298niEsEEq4ccfAjD/PjxavJGkSbCU76ryu2yh70/yGe4gsyhDuwqX5KL3C0RbKEbf/UzZf8jwsOdsUqX/lpbFyoRWb2QbJNhPN4iH1fWGCCBz1l62kKeCPqqKETQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=haGz6lgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haGz6lgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB461F008A4;
	Thu,  1 Oct 2026 08:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790843909;
	bh=VDZyHyKdoQxaDtb/4DumozyI5n+Wmf+3IrC7bJy9wcM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=haGz6lgBsR36TWj3gMtv15tsydDrCAMMtbWAvYJd0EVQB5QXwPBMev7l5G3dUj9zr
	 FZMqc6vmXyIfWxbVXheqRENXPBXOrwRkeCz3GYsuqPG4chs2WsAo9WADDDVu/WWNZ+
	 so3JOWSXiwwZfzehWVYYaY2Iyjal5j7XAduZBwJ3iWlrEjyePIR0m2Gw83kyrXdaL0
	 iIruvGZEr9Cm5U7or1gGdFAjsUmwpg7rYXaYizKb48GtuUGyQQOeeF11IdjgBsr2cV
	 NVDETEz641YgnrWSlQDaKCZCFM2ghi2mPpSIxDHX+DfwLbJmJWavjA/XN2B+LTSCft
	 h011/0Iksibkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 02/24] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: vkoul@kernel.org, olteanv@gmail.com, linux-phy@lists.infradead.org, conor+dt@kernel.org, devicetree@vger.kernel.org, robh@kernel.org, neil.armstrong@linaro.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261001-mt8196-ufs-v13-2-60854adab6d9@collabora.com>
References: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
 <20261001-mt8196-ufs-v13-2-60854adab6d9@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 08:38:28 +0000
Message-Id: <20261001083828.DCB461F008A4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] dt-bindings: ufs: mediatek: brittle schema constraint misrepresents=
 hardware clocks
--

commit 52701a7e111f7103b8f873c8ff58dfce872a6586
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

dt-bindings: ufs: mediatek,ufs: Complete the binding

This commit updates the Mediatek UFS binding to make it more complete,
removing deprecated properties and updating the clocks and resets lists.
It attempts to set clock constraints for different SoC generations such as
MT8183, MT8192, and MT8195.

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
> +            const: mediatek,mt8183-ufshci
>      then:
>        properties:
>          clocks:
> -          minItems: 8
> +          maxItems: 1

[Severity: Low]
Does this arbitrarily restrict MT8183 to a single clock, ignoring its UniPro
and AES clocks? Because the global items list enforces positional ordering,
if a device tree attempts to add the physically present UFS-related clocks
for this SoC, schema validation will reject the changes due to this maxItems
limit.

>          clock-names:
>            items:
> -            - const: ufs
> -            - const: ufs_aes
> -            - const: ufs_tick
> -            - const: unipro_sysclk
> -            - const: unipro_tick
> -            - const: unipro_mp_bclk
> -            - const: ufs_tx_symbol
> -            - const: ufs_mem_sub
> -    else:
> +            - const: main
> +        avdd12-ckbuf-supply: false
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

[Severity: Low]
Does this restrict MT8192 to 3 clocks, explicitly blocking proper hardware
representation? Since the newly introduced global items list strictly
enforces positional ordering, a device with maxItems: 3 is forced to provide
specifically "main", "aes", and "tick".

If MT8192 hardware actually implements UFS UniPro clocks, as evidenced by
this clock definition in drivers/clk/mediatek/clk-mt8192.c:

infra_clks:
    GATE_INFRA2(CLK_INFRA_UNIPRO_SYS, "infra_unipro_sys", "ufs_sel", 11),

wouldn't this rule prevent accurately describing these clocks in the device
tree?

>          clock-names:
> -          items:
> -            - const: ufs
> +          minItems: 3
> +          maxItems: 3

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-mt8196-ufs=
-v13-0-60854adab6d9@collabora.com?part=3D2
