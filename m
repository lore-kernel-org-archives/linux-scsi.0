Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB39369980
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 05:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785216602; cv=none; b=tWfZGfAQ2TnsD9wXH0GZ76R6D9mBuveFcp2UtP/gtxRCL49WE0V/6sCfhpxiJMVwGGa+y0Hhzdvtsq+70Tvj/XcMBzcPZksgc7Za6Y9rq5me90ozELc6+KzTfBctkPez1pa0oHiLfpkxvP5c+5lYOxfhfr/agn8BAWfUpSMVFwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785216602; c=relaxed/simple;
	bh=XzbvBbBLi/Hph1DuexD+G/BbJmQLgcHNn1JkNo4OLGM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FvCh61UqL7df0PNwyRpmPcVuoM6I+jUQ2Np7xWqewJr9dOW1SPh8R458f00u2Ej81rReSmrXAqkQwHdUjuOs/STJwUvXQjeHj9+noN/O2bL7bkcD6axjW0sihu4tAACLA5MdSf8uVSdG7okYwA/fmZxMXWBGuIJoex4qIxHb4FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVPQBdO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVPQBdO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FDE1F00A3D;
	Tue, 28 Jul 2026 05:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216601;
	bh=pQY00IJs+7vkHF9XGx96KEjOCtv0dmdZ+25CYPDRlek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fVPQBdO5WahLnXAwgBiGjrvXTo6rlRuvWe/QABzxYubEX9/043aG3UBmEOktgBi4m
	 +kcC+bZSnfKh5KuxNeckslNS31FCwcZEIrdej3bxIw6wRHYuxyEGV4d33MXqu9tocd
	 seUVQXnIg1va8REsBMeoVcerRqIZWcsU6CLVc71RCFESPlSeCwqPGyoQS6JwKfyV14
	 d5ETFJIcwadEWaMrV/EIjA6uN6+U3BZljuiMQis8jDn2+reOnrl3HHzlZZoUNcmcCD
	 9Bk6wVyqEzSpjwl4tA5o39lLXlTGt33lDmgp3ZpYDOsPaF6p0zPYuj2YvxAtoeNNEJ
	 F+eW5Ts7Ij8cg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ufs: host: qcom: Enable MCQ support for sa8255p
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shawn Guo" <shengchao.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
References: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 05:30:00 +0000
Message-Id: <20260728053001.08FDE1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Calling `platform_device_msi_free_irqs_all()` during device remova=
l before `devres` frees the IRQ actions leads to a leak of `struct irqactio=
n`.
- [High] Missing cleanup of MSI IRQs on the probe error path leads to a mem=
ory leak and a devres WARN_ON_ONCE.
- [High] MCQ ESI configuration is permanently lost across device resets and=
 suspends because `ufs_qcom_config_esi` skips register programming if `host=
->esi_enabled` is already true.
- [High] The use of a static local variable `is_boot` in `ufs_qcom_fw_manag=
ed_device_reset` causes incorrect reset behavior if multiple UFS host insta=
nces exist or if the module is reloaded.
--

--- Patch [1]: [PATCH] ufs: host: qcom: Enable MCQ support for sa8255p ---
commit 7cb2953fc60985aba4ef6bffc3f9dc05ef977551
Author: Shawn Guo <shengchao.guo@oss.qualcomm.com>

ufs: host: qcom: Enable MCQ support for sa8255p
   =20
The sa8255p vops (fw-managed variant) was missing the MCQ hooks, causing
the driver to silently fall back to SDB mode even when MCQ resource is
available. Wire up the same MCQ ops used by the standard qcom vops,
so that MCQ mode works on sa8255p.

> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 0500320545c43..d2acbbe647cb4 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -2950,6 +2950,11 @@ static const struct ufs_hba_variant_ops ufs_hba_qc=
om_sa8255p_vops =3D {
>  	.resume                 =3D ufs_qcom_fw_managed_resume,
>  	.dbg_register_dump      =3D ufs_qcom_dump_dbg_regs,
>  	.device_reset           =3D ufs_qcom_fw_managed_device_reset,

[Severity: High]
This is a pre-existing issue, but does sharing a static variable across all
controller instances cause problems here?

In ufs_qcom_fw_managed_device_reset(), a static local variable is used to
track the first cold boot:

ufs_qcom_fw_managed_device_reset() {
    static bool is_boot =3D true;
    ...
}

If there are multiple firmware-managed UFS controllers, or if the driver is
unbound and re-bound, won't subsequent initializations see is_boot as false
and trigger an unwanted device reset during their cold boot?

> +	.mcq_config_resource	=3D ufs_qcom_mcq_config_resource,
> +	.get_hba_mac		=3D ufs_qcom_get_hba_mac,
> +	.op_runtime_config	=3D ufs_qcom_op_runtime_config,
> +	.get_outstanding_cqs	=3D ufs_qcom_get_outstanding_cqs,
> +	.config_esi		=3D ufs_qcom_config_esi,

[Severity: High]
This isn't a bug introduced by this patch, but does the early return in
ufs_qcom_config_esi() prevent ESI configuration from being restored after a
suspend or reset?

ufs_qcom_config_esi() has this check:

    if (host->esi_enabled)
        return 0;

When the device undergoes a reset or suspend, the controller's power is
toggled, clearing hardware registers like REG_UFS_CFG3. During resume, when
ufshcd_reset_and_restore() calls ufshcd_config_mcq(), which then calls
ufs_qcom_config_esi(), host->esi_enabled will still be true.

Will this skip reprogramming the hardware registers and leave ESI interrupts
broken?

[Severity: High]
This is also a pre-existing issue, but is there a memory leak if probe fails
after allocating MSIs?

ufs_qcom_config_esi() allocates MSI vectors via
platform_device_msi_init_and_alloc_irqs(). This API relies on devres to
release domain data but explicitly requires the caller to free the allocated
IRQs before the devres unwind phase.

If ufshcd_init() encounters an error later (for example, link startup fails)
and returns an error, the core and variant exit hooks don't call
platform_device_msi_free_irqs_all().

Will the devres teardown find the MSI xarray non-empty, triggering a
WARN_ON_ONCE(!xa_empty(&md->__macq)) and leaking resources?

[Severity: High]
Another pre-existing issue related to this: does driver unbind leak the
irqaction structures?

ufs_qcom_config_esi() uses devm_request_irq() to bind IRQ actions to devres.

During driver unbind, ufs_qcom_remove() manually calls
platform_device_msi_free_irqs_all(), which destroys the MSI descriptors and
IRQ mappings.

When devres unwinds after remove() returns, devm_irq_release() calls
free_irq(). Since the IRQ mapping was already destroyed, won't free_irq()
fail to find the descriptor and return early, leaking the irqaction?

>  };
> =20
>  /**

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728051104.6750=
88-1-shengchao.guo@oss.qualcomm.com?part=3D1
