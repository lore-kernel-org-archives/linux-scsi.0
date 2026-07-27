Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26FE3BFE26;
	Mon, 27 Jul 2026 10:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785148382; cv=none; b=DHiqMTMrIfwjiwPQhj/QC+UHkkRa3++bOoIim44vEliMl7dchaJYiegWjel2hkmQbS1lL7BdunRNlZ2qWx6n3pAOmgWgrlgYntFhwUWRK4IH9FhXaDv/XkJ0MxboIaWfcI5Uzoau2ZsOjmlnh3ZUlC9S77l/v6ngTxenkowM8I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785148382; c=relaxed/simple;
	bh=3rkWHCIHYmqZn+lYrDqEAw4wvfUbCAnM6+Foxr6N654=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HvTmkfgHCmf1LJUyB6NVIqrbyp7G8wmk28yLwpiTSbRJqkCia2MyQlm0dYsCJehx3CxXijCBh8ZdvndeJQOlarRhmwIEg2md1Uov2DLyvAlhtK4Crobz/FN2RTiMhvv+LfIJqKF0EGVeZVhsJ5Hn7bcY4FlyPcvOvjQ9Ai/JJRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2PHzS68; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2PHzS68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBC61F000E9;
	Mon, 27 Jul 2026 10:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785148380;
	bh=vLR/oacCYSK1ZUz7IzVlj5PG6byYKm/ye0HVShOP8mE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R2PHzS68IrGeWx2lft+8/SiOo29pmHsTGuluEQoVLee1JLZwZFttZGYEE8j+ApuN8
	 DkwdJ5+sR5HFZuAE2EAxzQQQeuqNik3fDvcUZp9lwt8ANo3fr8yjgY7byogZZR5EQC
	 nfblZ2uxl7BHSUCIdPxEAkDTO/wYMJ7JqX6297RSehYDsodj4H7ebqZGtXb+zZWesK
	 YjFks3QNNKDTSVcp6tAhby3I0SIsKDStAgqEM2Vmp7540Z2IJdlcK5fgE0IVv3TzYT
	 QR+Q8hNYvgaiIffYtKyf1vySqKQWfDqyLimvbp4M6aaBsLI3k37Ou7twr4PhW6Bx2+
	 t9KIwXBBvSPGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/3] soc: qcom: ubwc: Get HBB from SMEM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konrad Dybcio" <konradybcio@kernel.org>
Cc: conor+dt@kernel.org, robh@kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260727-topic-smem_dramc-v5-3-66188b3e338d@oss.qualcomm.com>
References: <20260727-topic-smem_dramc-v5-0-66188b3e338d@oss.qualcomm.com>
 <20260727-topic-smem_dramc-v5-3-66188b3e338d@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 10:32:58 +0000
Message-Id: <20260727103259.8EBC61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The Kconfig option `QCOM_UBWC_CONFIG` lacks a dependency on `QCOM_=
SMEM`, leading to linker errors when `QCOM_SMEM` is disabled or built as a =
module.
- [High] Unconditional probe deferral if SMEM is absent or fails to probe, =
breaking device initialization (such as display and GPU).
--

--- Patch [3]: [PATCH v5 3/3] soc: qcom: ubwc: Get HBB from SMEM ---
commit 20edaba770542f67d21a0b4400573bdcc45e195f
Author: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

soc: qcom: ubwc: Get HBB from SMEM

This patch attempts to retrieve Highest Bank Bit (HBB) data from SMEM to
ensure correct DRAM configuration settings are applied. It updates the
UBWC configuration retrieval logic to first check for SMEM availability
and dynamically populate the HBB value if present.

> diff --git a/drivers/soc/qcom/ubwc_config.c b/drivers/soc/qcom/ubwc_confi=
g.c
> index 0209a02c390f0..23901a4c51f73 100644
> --- a/drivers/soc/qcom/ubwc_config.c
> +++ b/drivers/soc/qcom/ubwc_config.c
[ ... ]
> @@ -168,9 +169,25 @@ static const struct of_device_id qcom_ubwc_configs[]=
 __maybe_unused =3D {
>  	{ }
>  };
> =20
> +static struct qcom_ubwc_cfg_data *cfg;
> +static DEFINE_MUTEX(cfg_mutex);
> +/**
> + * qcom_ubwc_config_get_data() - Retrieve UBWC data for the platform.
> + *
> + * Return: Pointer to valid struct qcom_ubwc_cfg_data on success, negati=
ve
> + * errno on failure. Note that this may return EPROBE_DEFER.
> + */
>  const struct qcom_ubwc_cfg_data *qcom_ubwc_config_get_data(void)
>  {
>  	const struct qcom_ubwc_cfg_data *data;
> +	int hbb;
> +
> +	guard(mutex)(&cfg_mutex);
> +	if (cfg)
> +		return cfg;
> +
> +	if (!qcom_smem_is_available())
> +		return ERR_PTR(-EPROBE_DEFER);

[Severity: High]
If SMEM is absent on a platform or fails to probe (for example, if the
bootloader didn't initialize it and sets __smem to ERR_PTR(-ENODEV)),
qcom_smem_is_available() will always return false.

Will this cause dependent drivers to endlessly defer probe, completely
bypassing the valid static fallback data in qcom_ubwc_configs?

[Severity: High]
Since this patch introduces calls to qcom_smem_is_available() and
qcom_smem_dram_get_hbb(), which lack static inline stubs for the
!CONFIG_QCOM_SMEM case, could this cause a build failure?

For example, if a kernel is built with CONFIG_DRM_MSM=3Dy (which selects
QCOM_UBWC_CONFIG) and CONFIG_QCOM_SMEM=3Dm (or =3Dn), will this result in
undefined reference errors during the vmlinux linking phase because
QCOM_UBWC_CONFIG lacks a dependency on QCOM_SMEM in drivers/soc/qcom/Kconfi=
g?

> =20
>  	data =3D of_machine_get_match_data(qcom_ubwc_configs);
>  	if (!data) {
> @@ -178,9 +195,30 @@ const struct qcom_ubwc_cfg_data *qcom_ubwc_config_ge=
t_data(void)
>  		return ERR_PTR(-EINVAL);
>  	}
> =20
> -	return data;
> +	hbb =3D qcom_smem_dram_get_hbb();
> +	if (hbb =3D=3D -ENODATA) {
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-topic-smem=
_dramc-v5-0-66188b3e338d@oss.qualcomm.com?part=3D3
