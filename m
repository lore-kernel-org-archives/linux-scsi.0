Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C14266B46;
	Mon, 20 Jul 2026 02:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784515485; cv=none; b=oNkfc6EXTFOKyfiOk6/Hch+r0hhsvMPzn7HCBrCrNd3FbWz6O052Jed0QifZjpSEs8ncw2kUhundiNGMt25FGxJollYxJ2MX02gEViNmQtB43nIFTlRR+2Tq7+r647ojdQGD1V/p5PogUEV9wFeJNVQ/ye6LNM7SOlK8FKBQeFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784515485; c=relaxed/simple;
	bh=LFYGrvS2+Ugtv7QDXkc7EMHLIrh6ME9tUxxVmSqHDPI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IFwYJStCUnRX0mz/CzBAMHL0k7TeYDM6bLvqaXofICz+IVEfZoHRs2jeHnG34YP6pSoSU+RdpUP6PTWYSFSEf8EC0XJCrikH1v4Va9xg0Sfs3qUJKogrJU2qVRkGgD5gkxisnfANg+c1bIEy3DV0oz56vd53qliO2sW+ymrgq1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKWlKx+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKWlKx+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F80D1F000E9;
	Mon, 20 Jul 2026 02:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784515484;
	bh=FskehnLV2pKot38nX8CNAGMdJMVu09Cd+vu2rW5rI/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oKWlKx+K3d0/se9vRomqF/TuHxDAsac6Y4+QmnEJ5R5ep5s7oGCVBi9fOT680cY08
	 NC50TZRceg7MblyzGWvrMUR8b2iwU64QQv8MFojgO4rY0Lv6WOMpfIA4LeKZmQ1hd8
	 mpyBW8AoHaEtXYkKLPTCmTUQlxcKvppWwPksdMS79dQngrP8Hc4vTsyuI1MgzcC63j
	 wLROYvpp17QiSvMnmuQRBqubC5bq1JnRD6kgqUrgd9isB6WKsBWPiHadcFnXR+CXYB
	 w92VXrUJqUYK9l/JwTZSsHVsgRzeRDvY2TVrSl/E+1VNbE356Sma/JKJF+/ufYDXIv
	 eYB1agvxijRSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: ufs: dt-bindings: Add missing mcq reg for
 qcom,sa8255p-ufshc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shawn Guo" <shengchao.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org
In-Reply-To: <20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com>
References: <20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 02:44:43 +0000
Message-Id: <20260720024444.5F80D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The Device Tree schema update fails to enforce the presence of t=
he newly documented `mcq` register space and `reg-names` property.
--

--- Patch [1]: [PATCH v2] scsi: ufs: dt-bindings: Add missing mcq reg for q=
com,sa8255p-ufshc ---
commit 871a91874eb00f9814a93dfb44bc94d0b96e8791
Author: Shawn Guo <shengchao.guo@oss.qualcomm.com>

scsi: ufs: dt-bindings: Add missing mcq reg for qcom,sa8255p-ufshc

Qualcomm UFS controller found on SoCs SA8255P/SA8797P has a MCQ I/O
address space. It should be defined in the bindings even though Linux
driver currently doesn't utilize it. Fix the binding before it gets
adopted by DTS.

> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yam=
l b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> index db165a235cb6d..66d73e9025d6b 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> @@ -18,7 +18,14 @@ properties:
>            - const: qcom,sa8255p-ufshc
> =20
>    reg:
> -    maxItems: 1
> +    minItems: 1
> +    maxItems: 2
> +
> +  reg-names:
> +    minItems: 1
> +    items:
> +      - const: std
> +      - const: mcq

[Severity: Medium]
Since the commit message indicates the MCQ I/O address space should be defi=
ned
before it gets adopted by DTS, should reg and reg-names strictly require tw=
o=20
items?

Setting minItems to 1 for both properties allows device trees to pass
schema validation with only a single register space.=20

Additionally, should reg-names be added to the required list to enforce its
presence?

The examples section was also not updated and still demonstrates a single
register space:

        compatible =3D "qcom,sa8255p-ufshc";
        reg =3D <0x01d84000 0x3000>;
        interrupts =3D <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;

Could this be updated to demonstrate the newly added mcq register and
reg-names?

> =20
>    interrupts:
>      maxItems: 1

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720023552.2667=
237-1-shengchao.guo@oss.qualcomm.com?part=3D1
