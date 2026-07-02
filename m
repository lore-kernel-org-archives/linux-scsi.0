Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78731431E49;
	Thu,  2 Jul 2026 02:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782959899; cv=none; b=eofwL23NIdEl4Krg6Ofxe6jO/ifqmIIkHpb6dS93Oh3ssO/plwexzeH2Y34pYr+4GbMF+Mw67tKEzqU2/jFRLE7l6ssmmNlFvXB/zlEyc2BpbXdQiwfQ8w4NPrrxJ0xyZ4/Hstc7sqXAO+/Y6xuTdpFnxZOGlnADIP8QZWG+mOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782959899; c=relaxed/simple;
	bh=vh/jTv7R6a9TeyhyLanp45MTiX3GjgtJpLShHsPG7rM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YhhfWEq/SD3ZHr3rQL2W7FdO/mLugXLr6+MnwCRiLLp6MkUBm2NwQQkCgpcqBSJ6EycJEOqneudwD/fQcawRypkqN/W4uQ7xqbtukOb/69A0wl7cqj/4vWQXOO/OOkCIuhVBGIXSw21F5KoRGNL1pFJ7vFpNxsIRsdrSCREy5ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNhoLGII; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNhoLGII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC27A1F000E9;
	Thu,  2 Jul 2026 02:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782959898;
	bh=b1GXHfFyvAN2Z7/b/Bgo7L2sJPaZrnifzqvI1I3y1/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kNhoLGIIqxq6zV7xtvVBSfWwjXtyOfPAACYVp4GBeAPC0zAKNjZ2dOHXIqN3JDx2i
	 oobaSZLU1BFHqjdsLLBh8qhernMKaXaXJRkJJqR99Me8Ye3XHUimcZdcXil7Cxd815
	 782HMhRSyjdh1KRTSzHuV3AitmlGNGMvwnqOk14CqpoKnu5nsKkVnnVFrNOB6xU4MU
	 93Umsd6NGOl0F6u7RVNR/A+g698EcfNFKNLUE6BE96mQKkKEQlElisjyW7rH+bxZ3r
	 2e+VIa8TFyD4B4ljWjgD3WbYkkJqYAZ+VHNvT6JYWMu0voI1IKSvFPHssYQGnNnwsK
	 2BoThung9Yu5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: robh@kernel.org, devicetree@vger.kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260702-08-k3-ufs-support-v1-1-1a64a3ab128f@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-1-1a64a3ab128f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 02:38:17 +0000
Message-Id: <20260702023817.AC27A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] The example device tree node is missing the required `interrupts` p=
roperty, causing schema validation (`dt_binding_check`) to fail.
- [Low] The `freq-table-hz` property in the example uses an invalid flat ar=
ray syntax for a matrix property and relies on a deprecated binding.
--

commit 1206e23c10bdd35379971f48c29e246d5b43200d
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC

Document the compatible for UFS (Universal Flash Storage) Host Controller
which found in SpacemiT K3 SoC chip. This adds the YAML schema defining=20
features like MIPI UniPro v1.61 and M-PHY v3.0 compliance.

> diff --git a/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml=
 b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
> new file mode 100644
> index 0000000000000..e6cb6fb2496c8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml

[ ... ]

> +examples:
> +  - |
> +    #include <dt-bindings/clock/spacemit,k3-clocks.h>
> +    #include <dt-bindings/reset/spacemit,k3-resets.h>
> +    ufs@c0e00000 {
> +        compatible =3D "spacemit,k3-ufshc";
> +        reg =3D <0xc0e00000 0x40000>;

[Severity: Low]
Does this example node miss the interrupts property? The included
ufs-common.yaml schema requires an interrupts property, which might cause
make dt_binding_check to fail validation here.

> +        clocks =3D <&syscon_apmu CLK_APMU_UFS_ACLK>,
> +        <&syscon_apmu CLK_APMU_UFS_REFCLK>;
> +        clock-names =3D "aclk", "ref_clk";
> +        resets =3D <&syscon_apmu RESET_APMU_UFS_ACLK>;
> +        freq-table-hz =3D <491520000 491520000 19200000 19200000>;

[Severity: Low]
Is this the correct formatting for freq-table-hz? This property expects a
multi-dimensional array, so writing it as a flat array (rather than
<A B>, <C D>) will likely cause dt-schema validation to fail.

Also, does this introduce a deprecated property to a new binding?

> +        lanes-per-direction =3D <2>;
> +    };

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702-08-k3-ufs-=
support-v1-0-1a64a3ab128f@kernel.org?part=3D1
