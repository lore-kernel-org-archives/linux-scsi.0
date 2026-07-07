Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22533D9544
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407353; cv=none; b=Ejfj2l0q457PpOPyhFUNcSW4INTfYvvfuA3Ep6zTJyw0mlQV7fgGvRfR0PqumxXAvTN1rd12QRpe48ye3zwdDbw6xeN/7xJw0YA5fTXICAAI8qfAwzXe69XTCcHFdwO4agXwOGmjIxmWyd3EhAOHrkiL/ExKB9meX+xs3RcGzUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407353; c=relaxed/simple;
	bh=IabCw2jXoVsROHnfgMK+ingJTrrmOOkzDbEEKag+/Ns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lL7YDfyN8ZAWnlcXJcFOa6rM/Au9qdbbcFbbuAgCy10F2YJq7UKsaAhBF3TdN0U56rNQ99NGUL27Ux4hht5O02u+Xze1JKKyTmurXf8g4BFWTT1BZDAruUyQoguvlNZRibcsjyhMGpv1g2E77Gi583ciAlQ2lCQODjFeQlvW99M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+X30uD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+X30uD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945741F000E9;
	Tue,  7 Jul 2026 06:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407350;
	bh=Uddl2C81DlESpJTMqmfpQE5uJNwB43YEMI1bnxUJUgw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c+X30uD0QhMnMNAEysTT5RmUFaEqNRzlFHWJIFk50TKaRWGh4rqGvOsNwDZmxFlkS
	 QygwwgC3ODTL6l+7ek1Th0hBpt9qc2Dsyj12zp1T8EESN1nXOEyIljdhLMfDoT5Yyh
	 q2U+izWidKk8u0mlaXIjsHnwsOFD5CfVag8FWX16jd85XodJAC9Pmp8YejJDFew1p3
	 yOLrnfZ8LZoPqTLgtw1yX6x4/AkeMBcKTxDj5q8O0u5j8Gkc2XQ0pIA0H9jDlq6i2v
	 6QMg1Jy2n02m7VCwVomd/iBhwcjRiEYe5Nt4AkRgv61btxDgmmuyFhSG862NwJARdQ
	 4QfkyuH9m9M0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 48/88] scsi: qla2xxx: Bound VP index against VP_CTRL
 IOCB bitmap size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-49-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-49-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:55:50 +0000
Message-Id: <20260707065550.945741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch prevents memory corruption by rejecting VP indices > 128=
 during disable operations, but fails to restrict their creation, leading t=
o undeletable virtual ports that permanently leak hardware resources.
--

--- Patch [48]: [PATCH v3 48/88] scsi: qla2xxx: Bound VP index against VP_C=
TRL IOCB bitmap size ---
commit b7da58fc93a7a4174b4900187f0c2564ae2b437d
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size

This patch fixes an out-of-bounds write in qla25xx_ctrlvp_iocb() by bounding
the virtual port index against the size of the vp_idx_map bitmap. It adds a
check in qla24xx_control_vp() to reject operations on vp_index values that
cannot fit in the 128-bit bitmap, preventing memory corruption.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 59648a9229ace..22f2d81e20099 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 7072af5b42178..b7d9c1a53f3ce 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -987,6 +987,14 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
>  	if (vp_index =3D=3D 0 || vp_index >=3D ha->max_npiv_vports)
>  		return QLA_PARAMETER_ERROR;
> =20
> +	/*
> +	 * The VP_CTRL IOCB selects the target VP through a fixed 128-bit
> +	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
> +	 * if firmware advertises more NPIV vports.
> +	 */
> +	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
> +		return QLA_PARAMETER_ERROR;
> +

[Severity: High]
This isn't a bug introduced by this patch, but does this new check leave
undeletable virtual ports that permanently leak hardware resources?

If a user creates more than 128 NPIV vports, the driver will allocate a
vp_index > 128 and successfully create it in firmware. When the user later
deletes the vport, this new check in qla24xx_control_vp() will reject the
operation because the VP index cannot fit in the 128-bit vp_idx_map.

When qla24xx_control_vp() fails, qla24xx_disable_vp() fails and returns -1.
However, qla24xx_vport_delete() ignores this failure:

drivers/scsi/qla2xxx/qla_attr.c:qla24xx_vport_delete() {
    ...
    qla24xx_disable_vp(vha);
    qla2x00_wait_for_sess_deletion(vha);
    ...
}

This proceeds to tear down and free all software structures, leaving the
firmware with a dangling, active VP and permanently leaking the hardware NP=
IV
slot until a full adapter reset.

Should ha->max_npiv_vports be capped at 128 when it is initialized from the
firmware in qla2x00_get_resource_cnts() to prevent creating these
unmanageable vports in the first place?

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_get_resource_cnts() {
    ...
    ha->max_npiv_vports =3D mcp->mb[11];
    ...
}

>  	/* ref: INIT */
>  	sp =3D qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
>  	if (!sp)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D48
