Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EAD40680F;
	Wed,  7 Oct 2026 06:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791355260; cv=none; b=fIqy6DFs4WtzeQkwxvYD/G6Sa0bIVTg8HJgaJ5/VvXu7D1a5dL5B5N1TRgddprGbStQ8ODOun6TY1PglitFj04t+1k9q/Lng725gT3BZwSZOHA1Hi5l31unA2Mmy7rxtJBiDQY5GSqVjHeKlJx+E84gQ4189tl1B4Wy473ZRiVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791355260; c=relaxed/simple;
	bh=o0/Fgp1InkZxt733SjzVx4zmoGCsZLtiV7ANND6osNU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HbtI9nziz8AzMOSHkSlRlBerPolLDbUXROKiHks3vGuOdYsJhnv25l7MYi8TJouvOeKQ5HBxYwgYKXCdJ6XCsiGwMVvmyN3/vhyaPgAg1Exvb+9GJUajcUXwOjVWW2xeRhCyl8fkOKWR2Hm8jL6nDRbY8NDaL1KpJP86otr4A94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhYWwhbv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhYWwhbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7989D1F0089B;
	Wed,  7 Oct 2026 06:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791355259;
	bh=Pf3NWyRPQ0L09auWXUFmkUX75lTJ6eVPIYX7Gh2FhzI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FhYWwhbv/MivxQqipS5QvCY19Wu90M2LelaZWzZRyhcOk2GpxRX8vob1LAt/WFfbj
	 n/mgPxO5js60SdTkD6Mn/2PXL7iY9AaHbgU2m+XABmRsrLWn3oqyUScqkqZBUeZolo
	 AQQfJdKnNXY9d4WSwuAQis111lnGqQJEb1OvRdk1zwQ8/C6odGb5q4rM+9FHzkPigL
	 6Ewus/p4jUFOtOuV19qTHqcFGO0e2ijcM3WgMQyk+0dVqagfeX7pSEeTE9tlfw+5lT
	 bLccITWPlbHNiaW62UUt7pKW+Z4hyWtdhwaQN5+vZaTKHWFdy7+vinNAFVQJdxaTie
	 28vjkJdOapn/Q==
Message-ID: <sashiko-outbox-162678@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/5] arm64: dts: qcom: glymur: Add UFS nodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pradeep P V K" <pradeep.pragallapati@oss.qualcomm.com>
Cc: devicetree@vger.kernel.org, robh@kernel.org, olteanv@gmail.com, vkoul@kernel.org, linux-phy@lists.infradead.org, conor+dt@kernel.org, neil.armstrong@linaro.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261007-glymur_ufs_qcb_enablement-v3-3-84cf4f861415@oss.qualcomm.com>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-3-84cf4f861415@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 06:40:58 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] dts: missing required power-domains property in ufs_mem_phy
--

commit cc6e215ec76c80b1408b03a4a6419de1ac3953d3
Author: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

arm64: dts: qcom: glymur: Add UFS nodes

Add UFS PHY and UFS host controller nodes for Glymur SoC.

> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/q=
com/glymur.dtsi
> index 65a398c0a9920..49ef89b41aada 100644
> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
[ ... ]
> @@ -4102,6 +4102,125 @@ rng: rng@10c3000 {
>  			reg =3D <0x0 0x010c3000 0x0 0x1000>;
>  		};
> =20
> +		ufs_mem_phy: phy@1d80000 {
> +			compatible =3D "qcom,glymur-qmp-ufs-phy";
> +			reg =3D <0x0 0x01d80000 0x0 0x2000>;
> +
> +			clocks =3D <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> +				 /* UFS and PCIE4 share the same clkref */
> +				 <&tcsr TCSR_PCIE_4_CLKREF_EN>;
> +
> +			clock-names =3D "ref",
> +				      "ref_aux",
> +				      "qref";
> +
> +			resets =3D <&ufs_mem_hc 0>;
> +			reset-names =3D "ufsphy";
> +
> +			#clock-cells =3D <1>;
> +			#phy-cells =3D <0>;
> +
> +			status =3D "disabled";
> +		};

[Severity: Medium]
Is the ufs_mem_phy node missing a power-domains property?

This node appears to violate the qcom,sc8280xp-qmp-ufs-phy.yaml DT schema by
omitting this required property.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-glymur_ufs=
_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com?part=3D3
