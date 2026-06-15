Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53489219301
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781531117; cv=none; b=F9LlQRDeOjPIJrU1a0wA0rqmV4lwmSW9V2LjEIMxTeqI8gVm3e3mjF/Nceo0MvixDVMzTDwZmwlzRIQ5ma6BKgTrmtPzEjJSGKLly4WitW9u6ldOz+z9jqckExMLOctSgIUqIZjc3iYk0oEM8k785z9ZFvusd3e8Xre/nkQkKyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781531117; c=relaxed/simple;
	bh=h+TbHZSqneaJSLexdF3ZEyukepAP5vX3kWldF8c3Zrg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gMZ02MGTC+1aRooBzfVKFn8OTE5Sq+Xdf0dte9D4w23oKKtGsooV0wPXBFR4XJ09cMn+6SiSbppPtvTbYxIOmY2l5ug7RfVsLuA1Zt40Ln9WxcHRkK7KV/9YZtwQBrlC6s/UZOqd3+pvl8jzu2NPCGPxZESRieDRcqcPMuY/zH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRYMfyWo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRYMfyWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D19A1F000E9;
	Mon, 15 Jun 2026 13:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781531116;
	bh=AiiY3O2r4Me60mgTrcXqh1SG1Dl232SNPGSNFWVM6V4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gRYMfyWoN4XRDtNY9Hy7tEqFAymtZIr0Rh9zC5kpDM4u7DO/as01b3me5qRXZcv8W
	 +rGrIrQfG7qHxTSZH7bnky11PuiFEHEbuAOb16afGO+FWgyT85soAX1tmXpEXSUo8c
	 fZqW2Kn0VXtvLep9oPz1gZ7UxM1sc2q5LGgh6ZbDioiv8jD51zK+8lwjZexeA5aCTR
	 LHlGIoaxMIaaXKYcpKLqWG+KE4gr4dRW9B+oDFc3D4DipZgiWJHV7s1UlpxruR+98M
	 qYbN8JDS1jU2enopDGBmHd4CCkU1lj1MnyNgdzjBZ3w7il1cvohZoGOyPr9rc1eDnP
	 j4ovN8y9idZwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Can Guo" <can.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
References: <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 15 Jun 2026 13:45:15 +0000
Message-Id: <20260615134515.8D19A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Calling `devm_kzalloc` with `GFP_KERNEL` while the UFS block devic=
e queue is quiesced can cause a direct reclaim deadlock.
--

commit ad55228fec48bc54dfc7ac781e567e213cf4a86e
Author: Can Guo <can.guo@oss.qualcomm.com>

scsi: ufs: core: Add support for static TX Equalization settings

This patch parses board-specific static TX Equalization settings from
Device Tree for each HS gear. It introduces a from_dt flag to track=20
whether the settings came from the Device Tree and forces the TX EQTR
procedure to run when those static settings need to be overridden.

> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
> index aa64f2bf4f1ef..f06dc3c3492d1 100644
> --- a/drivers/ufs/core/ufs-txeq.c
> +++ b/drivers/ufs/core/ufs-txeq.c
> @@ -1301,7 +1301,13 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *h=
ba,
>  	}
> =20
>  	params =3D &hba->tx_eq_params[gear - 1];
> -	if (!params->is_valid || force_tx_eqtr) {
> +	/*
> +	 * TX EQTR must run for the following cases:
> +	 * 1. TX EQ settings are invalid.
> +	 * 2. TX EQ settings are from Device Tree.
> +	 * 3. TX EQTR procedure is forced.
> +	 */
> +	if (!params->is_valid || params->from_dt || force_tx_eqtr) {
>  		int ret;
> =20
>  		ret =3D ufshcd_tx_eqtr(hba, params, pwr_mode);

[Severity: High]
This is a pre-existing issue, but this patch further exposes it since the
new from_dt flag condition can trigger ufshcd_tx_eqtr() during devfreq
gear changes.

Can calling devm_kzalloc() with GFP_KERNEL in ufshcd_tx_eqtr() cause a
direct reclaim deadlock?

During devfreq gear scaling, the UFS block device queue is first quiesced:

ufshcd_clock_scaling_prepare() {
    ...
    blk_mq_quiesce_tagset(&hba->host->tag_set);
    ...
}

Later in the scaling process, this condition is evaluated and can trigger
the memory allocation:

ufshcd_config_pwr_mode()
  -> ufshcd_config_tx_eq_settings()
    -> ufshcd_tx_eqtr()
       params->eqtr_record =3D devm_kzalloc(hba->dev,
                                          sizeof(*params->eqtr_record),
                                          GFP_KERNEL);

If memory reclaim is triggered by this GFP_KERNEL allocation, the system
might attempt to flush dirty pages to the same UFS device. Since the queue
is already quiesced, the flush would block indefinitely.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260615132834.2985=
346-1-can.guo@oss.qualcomm.com?part=3D2
