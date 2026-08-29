Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960A24A078;
	Sat, 29 Aug 2026 07:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787990117; cv=none; b=cORfqTOEmm2didJkb6NjtaCYGwSMcV8CMYmkn/AUOf3r36/ppU8LrrHyO2Ai9XTS58FooTeGyZ8NNcXSNieUUIhRuoSG5Gh0okLkEBBCMNsC2JMr6IgpfZb6M5WcDWO1ikIn8UWCYOyMcYNXTw1Yzo9487nzCEf5LhKTErtjrAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787990117; c=relaxed/simple;
	bh=FxANAY7SliOvAm/6NUkHq6tagheVLIOMYTmYHBwm0Jw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qSno6ctGv1RGh2JCKyKsBBhea6EBgukAR7N9Np17Mx3Hv8GRaz73nPNf/2UjgsXwruu9WgPn+IMqfLQvE68iHtPyeFs/VQHCCUgQi7EK1GhXHpQtrcyvq+FmLUOZut0mO29raZJX825O9gHEAsaAU7QFH6b4dETnBc+zoUfjG9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CdvJm0v1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CdvJm0v1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2674E1F000E9;
	Sat, 29 Aug 2026 07:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787990115;
	bh=4Jrxe2NFe6z+4UAOF/ws4ZtdTGXM1xJAP+l305qoIzk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CdvJm0v11DAJ81+/0gnzAoawf26K9SfFx/5RdiqCE3ylegh65jTAdFJuW81cyx0VV
	 8MECWtrSSNcya4r9dgGXSeb5XsxUS+z8cWk0fzbiVgaV7NZGyt0K+MM2KeVnWfSOP8
	 K5K3aXBK1bdLBifgzYcgl6VjaOMsQHLQRilXp6zZ3sUAqm8zVJHYQWK7ZJbd55osFu
	 LX6sf3FcLFK0wKNSUvv9pirfTiHtaa6HiI4Y/Ef1C7zklBamRlFIXsBlGfF9Szg5Wc
	 BQVvXRdnH24s4kDdHYtT+kq8RMXhA05Zeisfu5kRdzvHtfDitFPGZ30Nrmp9bz2FGg
	 x7VswJ6eXKcng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 1/2] scsi: ufs: ufs-qcom: Add specified gear support
 for multi gear scaling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nitin Rawat" <nitin.rawat@oss.qualcomm.com>
Cc: devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260829074355.946543-2-nitin.rawat@oss.qualcomm.com>
References: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
 <20260829074355.946543-2-nitin.rawat@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 07:55:14 +0000
Message-Id: <20260829075515.2674E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Valid `opp-level` DT gear configurations are improperly ignored an=
d downgraded if they exceed the attached device's maximum supported gear, b=
reaking forward compatibility.
--

commit d0c65635e24a4008e442b75486fc367af65e28be
Author: Ziqi Chen <ziqi.chen@oss.qualcomm.com>

scsi: ufs: ufs-qcom: Add specified gear support for multi gear scaling

This commit introduces a device tree based configuration interface that all=
ows
specifying the HS gear speed for supported operating frequencies using the
"opp-level" property. If this property is not configured, the driver falls
back to a default frequency-to-gear mapping table.

> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 291c434487648..399269c3f0597 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c

[ ... ]

> @@ -2490,12 +2491,32 @@ static unsigned long ufs_qcom_opp_freq_to_clk_fre=
q(struct ufs_hba *hba,
> =20
>  static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned lon=
g freq)
>  {
> -	u32 gear =3D UFS_HS_DONT_CHANGE;
> +	struct dev_pm_opp *opp;
>  	unsigned long unipro_freq;
> +	u32 gear =3D UFS_HS_DONT_CHANGE;
> =20
>  	if (!hba->use_pm_opp)
>  		return gear;
> =20
> +	opp =3D dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
> +	if (IS_ERR_OR_NULL(opp)) {
> +		dev_err(hba->dev, "%s: Failed to find OPP for exact frequency %lu\n",
> +			__func__, freq);
> +		return gear;
> +	}
> +
> +	/* Get HS gear speed from 'opp-level' */
> +	gear =3D dev_pm_opp_get_level(opp);
> +	dev_pm_opp_put(opp);
> +
> +	/*
> +	 * Greater than max gear means that there is no specified gear configur=
ed in DT
> +	 * or the specified gear is invalid.
> +	 */
> +	if (gear <=3D hba->max_pwr_info.info.gear_rx)
> +		return gear;
> +

[Severity: High]
Does this condition inadvertently downgrade valid DT gear configurations if
they exceed the attached device's maximum supported gear?

If a platform specifies a valid opp-level (e.g., 5) but the connected UFS
device supports a lower maximum gear (e.g., gear_rx =3D 4), this check
evaluates to false. The driver will then incorrectly fall back to the
legacy hardcoded mapping table instead of using the capped value.

If the frequency is not present in the fallback table, it returns
UFS_HS_DONT_CHANGE, which can cause a mismatch between the configured clock
and active gear speed. This mismatch could potentially lead to UFS link dro=
ps
and system panics during frequency scaling.

It appears this logic conflates a missing DT property (where gear might
evaluate to OPP_LEVEL_UNSET or U32_MAX) with a valid property that simply
exceeds the device capability.

Could this be addressed by explicitly checking if the property was provided,
and if so, safely capping it to the device's maximum supported gear using
min_t(u32, gear, hba->max_pwr_info.info.gear_rx)?

> +	gear =3D UFS_HS_DONT_CHANGE;
>  	unipro_freq =3D ufs_qcom_opp_freq_to_clk_freq(hba, freq, "core_clk_unip=
ro");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260829074355.9465=
43-1-nitin.rawat@oss.qualcomm.com?part=3D1
