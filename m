Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1DC3EC2EA;
	Mon, 27 Jul 2026 10:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785147616; cv=none; b=i3R6aRT7t391od3LsqWevSZxJy25eFdyZOd0zWupaVq3ZBtkFroa6WQogulyDvSnAQduNoHup2I1E8zw92heH9zBwa+EW6Zngxext5ED/y3pbkov/B0/JGMRqKXHUATdQmozwkk/zMhJVs0XIfwxv0iUnUlFmrpj47ebXJVd3LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785147616; c=relaxed/simple;
	bh=KHTNsg0aEkrvNbvusPce8L3DIwBnNoEDX51ufrHDJGY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OYKO257BDlhAxdnC3JYEgAjPw1pNBfvA7bTKGF4qN+/iO12ZhxBAvpUEyVTl8AM1KhDIHYKPTQ6+TaVi0DVFaSxaiv3elXLhyuLGzTdtzjkxjXXfDgCs/oqlK6voH9iMG79ydy5dFUuOYVBByENQ3r/TrStfDEA2jPpyIn3CpWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/b38l7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/b38l7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3231F000E9;
	Mon, 27 Jul 2026 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785147615;
	bh=HKG6qDtWlbNzWKj249J/e/hpoSLfELeYA/vpngf3/nU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D/b38l7CTdRdmEgVDCvaB+m5awIQu/EU6q2HDTzGRt3R+KiX2VEgK1a2sTvpzs493
	 9wp6hv7WmvCXXtXCgPSOdJv9akcFUTSgUVdw895fiaykCmNfRYqa9DINtDgRoMN74m
	 eEhoTe0kJUumAjXXn4Yu6Ut8V/CDOvonckFlStrK/FaVqQqohbsg2D09VPdQDUprkT
	 l5M5+AHcTNzK1N/i1hXLjjq7+a76YcNBTN51dk02wJ9PW7y6/Gpw0EPvu6pIyOSog+
	 TeXpwZpFnkOqPJuCRU8CMqNdHq19qavgh/MjWwgtSjDNZUV8lgAIGvO/m8wUaUdIc4
	 /3BLALdhtSjLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/3] soc: qcom: smem: Expose DDR data from SMEM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konrad Dybcio" <konradybcio@kernel.org>
Cc: robh@kernel.org, dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260727-topic-smem_dramc-v5-2-66188b3e338d@oss.qualcomm.com>
References: <20260727-topic-smem_dramc-v5-0-66188b3e338d@oss.qualcomm.com>
 <20260727-topic-smem_dramc-v5-2-66188b3e338d@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 10:20:13 +0000
Message-Id: <20260727102014.8B3231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Missing endianness conversion when reading `freq_khz` causes data =
corruption on big-endian architectures.
- [High] Global pointer `__dram` is left dangling when `qcom_smem` unbinds,=
 leading to a Use-After-Free.
- [High] Double free / Use-After-Free of `smem->debugfs_dir` dentry if `soc=
info` registration fails.
- [High] Hardware/firmware interface structures incorrectly use the variabl=
e-sized kernel type `phys_addr_t`, breaking strict ABI layout.
- [High] The DDR frequency calculation `1000 * freq_khz` overflows 32-bit u=
nsigned arithmetic for high frequencies.

Pre-existing issues:
- [High] `qcom_smem_remove()` unconditionally passes `__smem->socinfo` to `=
platform_device_unregister()`, leading to a kernel panic if it is an error =
pointer.
--

--- Patch [2]: [PATCH v5 2/3] soc: qcom: smem: Expose DDR data from SMEM ---
commit 31a4d704c3d015e6e35b14ee7b507b87476be924
Author: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

soc: qcom: smem: Expose DDR data from SMEM

Most modern Qualcomm platforms (>=3D SM8150) expose information about the
DDR memory present on the system via SMEM.

Link: https://git.codelinaro.org/clo/la/abl/tianocore/edk2/-/commit/1d11897=
d2cfcc7b85f28ff74c445018dbbecac7a

> diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
> index 43b66120fc644..4c689fc17011b 100644
> --- a/drivers/soc/qcom/smem.c
> +++ b/drivers/soc/qcom/smem.c
[ ... ]
> @@ -1236,19 +1246,26 @@ static int qcom_smem_probe(struct platform_device=
 *pdev)
>  	if (ret < 0 && ret !=3D -ENOENT)
>  		return ret;
> =20
> +	smem->debugfs_dir =3D smem_dram_parse(smem, smem->dev);
> +
>  	__smem =3D smem;
> =20
>  	smem->socinfo =3D platform_device_register_data(&pdev->dev, "qcom-socin=
fo",
>  						      PLATFORM_DEVID_NONE, NULL,
>  						      0);
> -	if (IS_ERR(smem->socinfo))
> +	if (IS_ERR(smem->socinfo)) {
> +		debugfs_remove_recursive(smem->debugfs_dir);
> +
>  		dev_dbg(&pdev->dev, "failed to register socinfo device\n");
> +	}
> =20
>  	return 0;
>  }

[Severity: High]
When socinfo registration fails, debugfs_remove_recursive() is called, but
smem->debugfs_dir is not cleared to NULL. Since the probe function still
succeeds and returns 0, could this lead to a double-free later?

When the driver is eventually unbound, qcom_smem_remove() will call
debugfs_remove_recursive(__smem->debugfs_dir) again on the same stale point=
er.

>  static void qcom_smem_remove(struct platform_device *pdev)
>  {
> +	debugfs_remove_recursive(__smem->debugfs_dir);
> +
>  	platform_device_unregister(__smem->socinfo);

[Severity: High]
This is a pre-existing issue, but does this code unconditionally pass an
ERR_PTR to platform_device_unregister() if the probe function failed to
register socinfo?

In qcom_smem_probe(), if platform_device_register_data() fails, it
stores an ERR_PTR in smem->socinfo and continues. Since
platform_device_unregister() only checks for NULL, deregistering an ERR_PTR
would cause a kernel panic.

> diff --git a/drivers/soc/qcom/smem_dramc.c b/drivers/soc/qcom/smem_dramc.c
> new file mode 100644
> index 0000000000000..63ebe7f6db590
> --- /dev/null
> +++ b/drivers/soc/qcom/smem_dramc.c
[ ... ]
> +/* V3 */
> +struct ddr_freq_plan_v3 {
> +	struct ddr_freq_table ddr_freq[MAX_DDR_FREQ_NUM_V3];
> +	u8 num_ddr_freqs;
> +	phys_addr_t clk_period_address;
> +};

[Severity: High]
Are these structures representing a fixed firmware ABI?

Using the kernel-dependent type phys_addr_t can cause the structure layout =
to
vary between 32-bit and 64-bit kernel builds. If the firmware layout is fix=
ed,
would this cause the driver to read misaligned data when the kernel config
doesn't match the bootloader's ABI size?=20

This also applies to struct ddr_freq_plan_v5 and=20
struct ddr_xbl2quantum_smem_data further below.

[ ... ]
> +/**
> + * qcom_smem_dram_get_hbb(): Get the Highest bank address bit
> + *
> + * Context: Check qcom_smem_is_available() before calling this function.
> + * Because __dram * is initialized by smem_dram_parse(), which is in turn
> + * called from * qcom_smem_probe(), __dram will only be NULL if the data
> + * couldn't have been found/interpreted correctly.
> + *
> + * Return: highest bank bit on success, -ENODATA on failure.
> + */
> +int qcom_smem_dram_get_hbb(void)
> +{
> +	if (!__dram || !__dram->hbb)
> +		return -ENODATA;

[Severity: High]
Is there a risk of a use-after-free here if the qcom_smem driver is unbound?

The __dram pointer is allocated with devm_kzalloc() during probe. When the
device unbinds, devm automatically frees this memory. However, __dram is
never cleared to NULL in qcom_smem_remove().

If this exported API is called by another driver after qcom_smem unbinds,
it will unconditionally dereference the freed __dram pointer.

[ ... ]
> +static void smem_dram_parse_v3_14freqs_data(struct smem_dram *dram, void=
 *data)
> +{
> +	struct ddr_details_v3_14freqs *details =3D data;
> +
> +	for (int i =3D 0; i < MAX_DDR_FREQ_NUM_V3 + 1; i++) {
> +		struct ddr_freq_table *freq_entry =3D &details->ddr_freq_tbl.ddr_freq[=
i];
> +
> +		if (freq_entry->freq_khz && freq_entry->enabled)
> +			dram->frequencies[dram->num_frequencies++] =3D 1000 * freq_entry->fre=
q_khz;
> +	}
> +}

[Severity: High]
Does freq_entry->freq_khz need a le32_to_cpu() conversion here?

Other parsing functions in this file convert this __le32 field before use,
but this assignment reads it directly. On big-endian architectures, this mi=
ght
result in byte-swapped values being used for DDR frequencies.

[ ... ]
> +static void smem_dram_parse_v5_data(struct smem_dram *dram, void *data)
> +{
> +	struct ddr_details_v5 *details =3D data;
> +	struct ddr_regions_v5 *region =3D &details->ddr_regions;
> +
> +	dram->hbb =3D le32_to_cpu(region[0].highest_bank_addr_bit);
> +
> +	for (int i =3D 0; i < MAX_DDR_FREQ_NUM_V5; i++) {
> +		struct ddr_freq_table *freq_entry =3D &details->ddr_freq_tbl.ddr_freq[=
i];
> +
> +		if (freq_entry->freq_khz && freq_entry->enabled) {
> +			u32 freq_khz =3D le32_to_cpu(freq_entry->freq_khz);
> +			dram->frequencies[dram->num_frequencies++] =3D 1000 * freq_khz;
> +		}
> +	}
> +}

[Severity: High]
Could this frequency calculation overflow 32-bit arithmetic?

The calculation 1000 * freq_khz multiplies a signed 32-bit integer by an
unsigned 32-bit integer. For high frequencies like modern LPDDR5X (e.g.,
4,800,000 kHz), the result will exceed the 32-bit maximum and wrap around
before being zero-extended and assigned to the 64-bit array element.

This identical calculation appears in the v3, v4, v5, and v7 parsing
functions. Should this cast to unsigned long before the multiplication?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-topic-smem=
_dramc-v5-0-66188b3e338d@oss.qualcomm.com?part=3D2
