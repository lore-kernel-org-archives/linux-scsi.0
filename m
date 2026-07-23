Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D44345CD3
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 09:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798116; cv=none; b=gfGwhLJaDj88DnqIz61xr1yg7ffZxUpF82fiCMGboEHe4Is0ks8wHgTykaenRo9NOCL6/W0owce827XiHSFg4Tz6nmMjgocAbNFRNyN0rsd8MqwrvD3rypFJ+di+1vlJTZgFgzl5pIsfOWTjTLKwFRUF4Je9FKI8TZCSx7oBm6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798116; c=relaxed/simple;
	bh=y3tbjVby9dD/LR4rOrISPQSZ5yDK4tT2D6qAEaIrFRo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GSXDp2dkvpxGXCTHLT71jsXF5xUMjg0vpHNbpdfTmZkoAHqr3mava1NPqXuTuZJBQc2UlsWt8yrDdKeGVF+cR3j1sPuXK6C2UMKgVJd9OpkSiRJ/fAbcFd5gOeun+HXu59kVKn++WA7gH4joROWx0walxxhoX5R45geWAMUCZnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQPX+1UH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQPX+1UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF6D1F000E9;
	Thu, 23 Jul 2026 09:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784798112;
	bh=JYkS4URpe+/8ocug65zQPED7c94PMrRo9n4Wmub8tRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FQPX+1UH3OnSlLz/xBybFEsyTflZF9dA/UaieYE9cUXTuUDJtrP//JKp21GAavxzu
	 CGjz8/d8EgQYLfyDDUyFTz9uv30h4rnUJrmhfo+P7rwbHePXCo2uaHJnOt9tMB7waI
	 1FJAAmTROZ4u8hBkukRWwzi2k4cSQCEmqz8/+XddGjb2fvoRL2ePuF3ilxPFo45YLh
	 m8rQFQmJWi4U5Fbm9HIbW0Ka93P0Vb2C0IJjNKgSHbR/fF1y8/d0HCtG+lcfGvphyl
	 j5aoGFp7vNJV9TQzXXWo2B/4QjkT1hY8zgALcz0tDE7quSpme2VHYFUzCjnxqMYkq6
	 4lhmwRreQ/sFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 14/56] scsi: qla2xxx: Enable get_fw_version mailbox
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-15-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-15-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 09:15:11 +0000
Message-Id: <20260723091512.0EF6D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The patch attempts to enable EDIF support for QLA29XX adapters, bu=
t the implementation is structurally unreachable dead code, and the underly=
ing EDIF I/O path explicitly rejects QLA29XX.
- [Medium] The sysfs attributes for `mpi_version` and `pep_version` are not=
 exported for QLA29XX adapters due to missing `IS_QLA29XX(ha)` checks in th=
eir respective show functions.
--

--- Patch [14]: [PATCH v6 14/56] scsi: qla2xxx: Enable get_fw_version mailb=
ox for 29xx ---
commit 93f36311743cc5868596ac6cab18df55689b0cd9
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable get_fw_version mailbox for 29xx

The serdes_version and several firmware capability fields were not
populated for 29xx because the get_fw_version mailbox path
excluded it from the 27xx/28xx checks. Add IS_QLA29XX() to
the relevant conditionals so that firmware version, EDIF, and
serdes information are correctly retrieved on 29xx adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index e8755ab86b6ac..c44f5282abb39 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1526,7 +1526,7 @@ qla2x00_serdes_version_show(struct device *dev, str=
uct device_attribute *attr,
>  	scsi_qla_host_t *vha =3D shost_priv(class_to_shost(dev));
>  	struct qla_hw_data *ha =3D vha->hw;
> =20
> -	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
>  		return scnprintf(buf, PAGE_SIZE, "\n");

[Severity: Medium]
Should the sysfs attributes for mpi_version and pep_version also be updated
to support 29xx?

The get_fw_version mailbox command now successfully retrieves ha->mpi_versi=
on
and ha->pep_version for 29xx adapters, but qla2x00_mpi_version_show() and
qla2x00_pep_version_show() in qla_attr.c still restrict visibility:

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_mpi_version_show() {
    ...
	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha) && !IS_QLA8044(ha) &&
	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
		return scnprintf(buf, PAGE_SIZE, "\n");
    ...
}

Will this cause userspace tools to incorrectly receive a blank line when
reading these attributes on 29xx hardware?

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 9c2633ca5036c..0feb98b83293a 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1212,7 +1212,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
>  			vha->flags.nvme2_enabled =3D 1;
>  		}
> =20
> -		if (IS_QLA28XX(ha) && ha->flags.edif_hw && ql2xsecenable &&
> +		if ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && ha->flags.edif_hw && ql2xsec=
enable &&
>  		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_EDIF)) {
>  			ha->flags.edif_enabled =3D 1;
>  			ql_log(ql_log_info, vha, 0xffff,

[Severity: High]
Is this EDIF enablement reachable for 29xx adapters, and if so, is it safe?

This condition requires ha->flags.edif_hw to be set, but looking at
qla2x00_execute_fw(), edif_hw is only initialized for QLA28XX:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_execute_fw() {
    ...
	if (IS_QLA28XX(ha) && (mcp->mb[5] & EDIF_HW_SUPPORT)) {
		ha->flags.edif_hw =3D 1;
    ...
}

Additionally, if EDIF were to be enabled here, would it cause I/O failures?
The underlying EDIF I/O path appears to explicitly reject 29xx hardware:

drivers/scsi/qla2xxx/qla_edif.c:qla28xx_start_scsi_edif() {
    ...
	if (IS_QLA29XX(ha)) {
		ql_log(ql_log_warn, vha, 0x13ae,
		    "EDIF is not supported on 29xx hardware; failing cmd sp=3D%p.\n",
		    sp);
		return QLA_FUNCTION_FAILED;
	}
    ...
}

Does the 29xx platform intentionally lack EDIF support, making this
conditional update unnecessary?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D14
