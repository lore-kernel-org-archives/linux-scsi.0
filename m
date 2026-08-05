Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D29641F355
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785930025; cv=none; b=ODpqcBhe3draCFEEbCNdD0V7rZZHtv/eEhklzgDoDSRiVvU8xhWoHqvaPBAEkk/ioMck8AMW06xnSma5nJhOGwWbJ/W000NdJPhIqGVvLkFwfzN+OAldjUoZWGDnA5x00pV+IfYoK9ug2ih1WQl2iWMhQYnE9eGhVfLjmwH0OSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785930025; c=relaxed/simple;
	bh=dpCuwJXt0+0WxxwYn6GASPlYuiUUdL/zDdnITDWWGQM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=INSl43lYs4atQ+IdWzzsFXPsY6y2Jk/Ui0eEZZ9on4PU9480O6f2IXY0zj+/Vi5J1pzeQCCGuz3d/i57Roo9KHUMsUxnIN22UgavretudYdgD9223IoRn0eN+aZDW6rLj1TuEH3VWyI12XQzmsJcZpKBQw3DlRPyhtvKKZUelzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaf/DbGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaf/DbGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444C91F000E9;
	Wed,  5 Aug 2026 11:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785930022;
	bh=rR4Q81BaFncPcfTq/PEPrLQ/rnWeAgl+MV+9Wf6EOns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eaf/DbGD9O0OzhYdudBnWi54wsI3Dqrcqv7ELaZ1XIuQcDgoRMD0u9T64AFHK+U8J
	 ndkODVdpmbRHCWg4cRqtfbW0R03ZMogIlGLshstNXAxhgoo14J0oFW0FzSqcGVhe2S
	 KqACCXmWKGNcFovUrR/gYgB6967NOXPnw/RoWx082l+FRAF5MpaU6kDR1S5MOgWfre
	 w9RBQ/Tpd+BiTII8HzWBgPDNBuUBMyNJwUYXJfJHHrOC5Xkv+lQ9Hb+eSf3q8kb0ZV
	 ezzOdKkgWhfNeYLuZ9Z8yWJtCOYG81yW201USAhfaTh8WU18k8yJDFcaaT7rDPpdPJ
	 Fr3w22aKuWZ5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 04/10] mpi3mr: Fix NVMe page size caching for
 non-operational devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805110634.346670-5-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
 <20260805110634.346670-5-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 11:40:21 +0000
Message-Id: <20260805114022.444C91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Time-of-Check to Time-of-Use (TOCTOU) / Double Fetch vulnerability=
 in NVMe page size validation
--

--- Patch [4]: [PATCH v4 04/10] mpi3mr: Fix NVMe page size caching for non-=
operational devices ---
commit 84a34ae29dcd95f3e4be7fc74958e61313bd07c9
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>
mpi3mr: Fix NVMe page size caching for non-operational devices

This commit populates the NVMe page size attribute irrespective of device
access status so firmware can process IOCTLs and report appropriate errors.
It also adds bounds checking for page_size to prevent undefined shift
behavior, and initializes timeout values via local variables to avoid race
conditions.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D4
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar=
@broadcom.com?part=3D4
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar=
@broadcom.com?part=3D4

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index d2a20f2721dbf..88b1d6360dac2 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
[ ... ]
> @@ -1349,24 +1349,32 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_io=
c *mrioc,
>  		struct mpi3_device0_pcie_format *pcieinf =3D
>  		    &dev_pg0->device_specific.pcie_format;
>  		u16 dev_info =3D le16_to_cpu(pcieinf->device_info);
> +		u8 pgsz =3D MPI3MR_DEFAULT_PGSZEXP;
> +		u8 reset_to =3D MPI3MR_INTADMCMD_TIMEOUT;
> +		u8 abort_to =3D MPI3MR_INTADMCMD_TIMEOUT;
> =20
>  		tgtdev->dev_spec.pcie_inf.dev_info =3D dev_info;
>  		tgtdev->dev_spec.pcie_inf.capb =3D
>  		    le32_to_cpu(pcieinf->capabilities);
>  		tgtdev->dev_spec.pcie_inf.mdts =3D MPI3MR_DEFAULT_MDTS;
> -		/* 2^12 =3D 4096 */
> -		tgtdev->dev_spec.pcie_inf.pgsz =3D 12;
> +		/* Validate firmware page size to prevent undefined shift behavior */
> +		if (pcieinf->page_size >=3D MPI3MR_DEFAULT_PGSZEXP &&
> +		    pcieinf->page_size <=3D MPI3MR_MAX_PGSZEXP)
> +			pgsz =3D pcieinf->page_size;

[Severity: High]
Could this introduce a time-of-check to time-of-use (TOCTOU) double fetch
vulnerability?

Since pcieinf points into dev_pg0, which resides directly in the DMA-mapped
reply buffer, is it possible for a compromised or malfunctioning PCIe device
to modify pcieinf->page_size in memory between the bounds check evaluation
and the final assignment?

If the device changes the value right after the check passes, an out-of-bou=
nds
value might be stored into pgsz, bypassing the validation and potentially
triggering the undefined shift behavior this patch aims to prevent.

Would it be safer to fetch pcieinf->page_size into a local variable using
READ_ONCE() and then perform the validation and assignment on that local co=
py?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805110634.3466=
70-1-ranjan.kumar@broadcom.com?part=3D4
