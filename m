Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267E74052A3;
	Mon, 14 Sep 2026 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789394519; cv=none; b=dpyqd93THBA2TtFx1aM4WKKkfKiSDJBAgZ2aAnBUR6M/OhVAoqRefdTzsHhoh8vH38uGoSERMPA3w9tZVfhOU24otSWG5oACS7a4/UD0KQHJSbDs8nqN1rPwDtaAomcHVCq49P8TaZBfrZ3JJo3qgTGRR7GCZKw9+B4UUzRAAxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789394519; c=relaxed/simple;
	bh=ZmCDJ3iUnG5EakJT+NSFh6pkgWJYzBQOmBylfkKg8nE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MLWXy3MX2FY53ypxgdoOZz4AUZ1HNZH9q9AkqvEZOzl+wbGQR3zZPTIuBKZlzV8OdK2QFTMOi49m7a22VuwkY/P2r+uSVVlRUihmmomzPEnAdjzGUHtqLHZlq+oTeLjjghK1J1qWztpT2hogiWs4nPgbOUMaIbLVsexL6CkFyHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oc74Gnsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oc74Gnsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434091F000FF;
	Mon, 14 Sep 2026 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789394517;
	bh=XR+3lHWmj+vWRrA2ShpnGjsNonWm0O8+3gRpjwMcJGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oc74Gnsi8nXr32dtIMz7JdWBCcWoS+xxTAR1gVrr/X1lQGL5Xwxw/NvpvlYuK3iDF
	 J8dHYqKtegnAevB5rCdkGUAdQ/Y/VXOuY84PepyGejuEKZi+1YMqeh3iFHRXg1/AJz
	 BeLADVIrRWOJ9hMXknO9oIV44hoThzMv1Yt63i8JLdxGC2BVuwKvoJzGiW+Y1Q/Wk/
	 QZH2CAiiDWoxoEDPMZT2eXH37q4SQrkBwRcUsEangMLCYMaFQMe532WBkKghBCeZW9
	 96Iaa7ehs7eR4XL/ZVNUSwowArYg7wLrw1WrLHdQBx5gZZxHcZzfGauQQwvGK5Lc6/
	 mAPwNHopgcCKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/10] arm64: dts: freescale: s32n79: Add UFS host
 controller
Reply-To: sashiko-reviews@lists.linux.dev
To: "Larisa Grigore" <larisa.grigore@oss.nxp.com>
Cc: robh@kernel.org, devicetree@vger.kernel.org, imx@lists.linux.dev, conor+dt@kernel.org, Frank.Li@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260914125000.30812-9-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
 <20260914125000.30812-9-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 14:01:56 +0000
Message-Id: <20260914140157.434091F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing Clock Enable for the UFS Core Clock
--

commit 90b92b70b82e1240cda14e91539c0096398b8f62
Author: Larisa Grigore <larisa.grigore@oss.nxp.com>

arm64: dts: freescale: s32n79: Add UFS host controller

Add the S32N79 UFS host controller node to the SoC dtsi. The controller
remains disabled by default and is enabled by board dts files as needed.

> diff --git a/arch/arm64/boot/dts/freescale/s32n79.dtsi b/arch/arm64/boot/=
dts/freescale/s32n79.dtsi
> index 94ab58783fdc8..0b51ca8bc7f9b 100644
> --- a/arch/arm64/boot/dts/freescale/s32n79.dtsi
> +++ b/arch/arm64/boot/dts/freescale/s32n79.dtsi
> @@ -100,6 +100,16 @@ uart7: serial@4aa40000 {
>  			status =3D "disabled";
>  		};
> =20
> +		ufshc: ufs@4ac80000 {
> +			compatible =3D "nxp,s32n79-ufshc", "jedec,ufs-2.0";
> +			reg =3D <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
> +			reg-names =3D "ufshc", "scm";
> +			interrupt-parent =3D <&irqsteer_coss>;
> +			interrupts =3D <211>;
> +			clocks =3D <&clks 0x92>;

[Severity: High]
Does this node need a clock-names property to ensure the clock is enabled?

Without clock-names, the UFS core framework's automatic clock management
(ufshcd_setup_clocks) is bypassed. The ufs-nxp-s32n7 driver fetches this
clock via devm_clk_get() in ufs_s32n_init():

	ufs->core_clk =3D devm_clk_get(dev, NULL);
	if (IS_ERR(ufs->core_clk))
		return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
				     "Failed to get core clock.\n");

However, the driver never calls clk_prepare_enable(). Additionally, without=
 a
power-domains property, the generic PM domain framework will not implicitly
enable the clock.

Could this cause the Common Clock Framework to disable it as an unused clock
during late initialization, leading to a bus lockup or synchronous external
abort when the device's memory-mapped registers are accessed?

> +			status =3D "disabled";
> +		};
> +
>  		irqsteer_coss: interrupt-controller@4ed00000 {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914125000.3081=
2-1-larisa.grigore@oss.nxp.com?part=3D8
