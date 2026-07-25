Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA312331203;
	Sat, 25 Jul 2026 10:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784976368; cv=none; b=Fywg3X/n/qYKcuMWYEHAO/H34KFlI64xBgybZeGbF5RjCfz/QGZN6Q071SAT5IqHqhQDCOlqmKt8I+RNSCHSpdl9+FRchzftRHoLls61hglKG1dBN2S4xOiOe4dTxxrxaU0JgCLqcp4Gq/WklYbUip/hzpMx7FDw2C6s5ZW2U24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784976368; c=relaxed/simple;
	bh=106UL/W7Dj6aqguFZRIdDZpsJ+Dkqd6Q8qJCpuyq0m4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZJAzUFYSIq9kKjO838NZuXe4Gh4qB1HbzFUBJ2aC07Aca5kXSKANk2npbpnRUtuWmEWCjnXW+GFc1hXhn2sIndPs470h5dTg2sjhG6MewVwyrtSTMzytrLnrCR27KS1oVYkaMEyFvDxusuVxh9hOaaundD2IOFAgls0MG0OqzHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bcl5RdTa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bcl5RdTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA851F000E9;
	Sat, 25 Jul 2026 10:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784976367;
	bh=ZokpYVcEpWT2zVB9KzxJKWSwH3/C3FPOW2IXcy9DbzQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bcl5RdTaMs+NAk59zBNQgB8L5LOZaxaky0N/MNistu8rZJs42mcMiGmqpKTWvIhxG
	 nbLiyAgbwRlqt4MjcOCyNdIQLSIgSUWb2l6QH5bvPm6C8qLvCno224canNTat/pU+C
	 SfuYrMeTm4xEYQf97TqYvs2Vz1Sh2Aglm10mrboU0z4kVBBPq9XiLWmk/NkVXeDgvm
	 At2x0K7BYMb8mUoyY4N4opPEB1Pwcu4yciX/+H9USjnFr6I5Ib4+62+KsT+D7jseb6
	 Ihu7aWheEcqplSW4ygdOuDVIfk2CnTmzY0RBiQEUipqTwiRd7meL9GGzAZWK3IRJFG
	 CwBHn2ptEKWKw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: conor+dt@kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260725-08-k3-ufs-support-v2-1-45036a2a2418@kernel.org>
References: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
 <20260725-08-k3-ufs-support-v2-1-45036a2a2418@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 25 Jul 2026 10:46:06 +0000
Message-Id: <20260725104607.0AA851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] The DT binding example incorrectly formats the deprecated `freq-tab=
le-hz` property as a flat array, causing a schema validation failure.
- [Low] The `compatible` property is omitted from the `required` list in th=
e binding schema.
--

--- Patch [1]: [PATCH v2 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS con=
troller for K3 SoC ---
commit b7ba054d14f9257aed59f8435e45924091cd034f
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC

This commit documents the device tree bindings for the UFS (Universal Flash
Storage) Host Controller found on the SpacemiT K3 SoC.

> diff --git a/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml=
 b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
> new file mode 100644
> index 0000000000000..45cd7837c3f76
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml

[ ... ]

> +required:
> +  - reg
> +  - clocks
> +  - clock-names
> +  - resets

[Severity: Low]
Is the compatible property missing from this list? Standard schema guidelin=
es
generally require leaf device bindings to explicitly include compatible in
their required array to properly enforce its presence during node validatio=
n.

> +
> +allOf:
> +  - $ref: ufs-common.yaml

[ ... ]

> +    ufs@c0e00000 {
> +        compatible =3D "spacemit,k3-ufshc";
> +        reg =3D <0xc0e00000 0x40000>;
> +        clocks =3D <&syscon_apmu CLK_APMU_UFS_ACLK>,
> +        <&syscon_apmu CLK_APMU_UFS_REFCLK>;
> +        clock-names =3D "aclk", "ref_clk";
> +        resets =3D <&syscon_apmu RESET_APMU_UFS_ACLK>;
> +        interrupts =3D <135 IRQ_TYPE_LEVEL_HIGH>;
> +        freq-table-hz =3D <491520000 491520000 19200000 19200000>;

[Severity: Low]
Will this fail schema validation?

The ufs-common.yaml schema defines freq-table-hz as an array of arrays, so
this flat array might need to be formatted as tuples, for example:
<491520000 491520000>, <19200000 19200000>;

Also, freq-table-hz is explicitly marked as deprecated in the common schema
and replaced by operating-points-v2. Does this new binding need to use a
deprecated property in its example?

> +        lanes-per-direction =3D <2>;
> +    };

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260725-08-k3-ufs-=
support-v2-0-45036a2a2418@kernel.org?part=3D1
