Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0650F293B75
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 06:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784786636; cv=none; b=sxccGF1ZoIEOYlS3SUo5avddY2io+eMcSd40tqBxsBNsN3Mivngnc6bLboOu5WJslLXSHUNsbJCbOEjYWmgI2W9jtBF0zFZ2EFkJk9gINUS7BNya4pQvL16Zdq1J1UilsofM+wJqYZudj0Hz6+HV8RIKq2zsowrpt6QgnO5TIc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784786636; c=relaxed/simple;
	bh=ezBW9QAJaGONW6q0AHZzIgMpyt6v6DkJMfpxsuMDwzs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oi4Pt+43+bfa2X4j3ihkl7oiJ9mhetq4e9xI9s7kJBA5qlHWqErByKPRXEBCvThEVbj73agg83pewIXMrDzVM1sP/Ilmy1tQ29Eg2sbn10xYo5qYtiQNM8e4TKNbCUE99the475pXhXJASpkLfv1sj5fbucWHG8gKG3n4+iNZow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFtlbNrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFtlbNrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEFB1F000E9;
	Thu, 23 Jul 2026 06:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784786634;
	bh=Flk49QXEa8urZxoFfPO1kdJTfR6jr8RrrejdJ4sQMiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hFtlbNrKYg7d+tS2fbD04hlclfS8n12PPnb/2DQjkouXNdVu5u7KutsVyi7xZ1DM2
	 kInjIkZbabCMzSLOtOP4PxiGPGFYfGOz4O4PHwoI8o9Ijo9du3JNkgr6CYoWvyO7eB
	 QC1WjQAS82MzwWjmvbvU85AXU3XJSRtsVZmx5Sl+6pFgfmEZXgmJN+RS8CEgqY2hqw
	 a3HlZkjekRe/3L8yYtF1rLSf0rIf9riy8CAcdQNb3RU6auBzN8VR1rh/dmzImoM46t
	 tPFqyWLmGqJJtVweN3mU3EvfQ4ypgKPiktUC3wDxNFfABoJOh8I65U/eD/BDGYpWbC
	 K4dwtzuxfMgeg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/56] scsi: qla2xxx: Add NVRAM config support for
 29xx adapters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-4-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-4-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 06:03:53 +0000
Message-Id: <20260723060354.6AEFB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The pointer ha->fiv is not set to NULL when qla29xx_read_optrom_dat=
a() fails, leaving it pointing to a zeroed buffer instead of correctly indi=
cating absence.
--

--- Patch [3]: [PATCH v6 03/56] scsi: qla2xxx: Add NVRAM config support for=
 29xx adapters ---
commit d8579bb80f870f714d329c213d6291f565f67160
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add NVRAM config support for 29xx adapters

Extend the NVRAM read and configuration-apply paths to handle the
29xx series.  The 29xx NVRAM layout is similar to the 81xx family,
so reuse the existing nvram_81xx parsing while adding
29xx-specific fields and init-sequence integration.

Closes: https://lore.kernel.org/oe-kbuild-all/202607141733.w1IF5m43-lkp@int=
el.com/

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index e23e7ac48ae26..c6e928f11758c 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
[ ... ]
> @@ -9306,35 +9306,98 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
[ ... ]
>  	if (IS_QLA29XX(ha)) {
>  		uint16_t fw_options =3D 0, r_code;
>  		uint32_t vpd_r[] =3D {FLT_REG_VPD_0, FLT_REG_VPD_1,
>  				    FLT_REG_VPD_2, FLT_REG_VPD_3};
>  		uint32_t nvram_r[] =3D {FLT_REG_NVRAM_0, FLT_REG_NVRAM_1,
>  				      FLT_REG_NVRAM_2, FLT_REG_NVRAM_3};
>  		void *buf;
> =20
>  		BUILD_BUG_ON((VPD_OFFSET + FA_NVRAM_VPD_SIZE +
>  			      sizeof(struct qla_flash_memo_block)) >
>  			     MAX_NVRAM_SIZE);
> =20
>  		ha->fiv =3D (struct qla_flash_memo_block *)
>  			((char *)ha->vpd + ha->vpd_size);
> =20
>  		buf =3D qla29xx_read_optrom_data(vha, FLT_REG_FMB_PRI,
>  					       fw_options, ha->fiv, 0,
>  					       sizeof(struct qla_flash_memo_block));
>  		if (!buf) {
>  			ql_log(ql_log_info, vha, 0x01be,
>  			    "Unable to read Flash Image Version.\n");

[Severity: Low]
Should ha->fiv be set to NULL here when the FMB read fails?

Currently, if qla29xx_read_optrom_data() returns NULL, ha->fiv continues to
point at (ha->vpd + ha->vpd_size) rather than correctly indicating absence.=
 In
the signature mismatch case below, it is explicitly set to NULL. Does this
leave a dangling reference to uninitialized memory that could confuse future
code checking if ha->fiv is valid?

>  		} else if (ha->fiv->signature !=3D QLFC_FMB_SIG) {
>  			ql_log(ql_log_warn, vha, 0x01bf,
>  			    "Invalid FMB signature %#x, expected %#x.\n",
>  			    le32_to_cpu(ha->fiv->signature),
>  			    le32_to_cpu(QLFC_FMB_SIG));
>  			ha->fiv =3D NULL;
>  		} else {
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D3
