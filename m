Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470393876B2
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033332; cv=none; b=EBNnIh9p+YxmuMfRpcRu4G+z78Bb8re+mQfwdKZlp/4w9oXi2dKd5hAjBn4wMKYBqJM2SAtUy1na+LAIpx9P2ZtgEgPJILrSVlKG9ZQNsyfDWwR+DpskCSP7ILMySRfkhrSf0vDXHIIG1h0lWOyUi1QGpEmJuivrkZ0X6I94ZNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033332; c=relaxed/simple;
	bh=s4QI5U9524NT8zNd9kMrRJek+YUMHlXCHcN62Nvb8YU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gEgGGLBlkWGQ1xY9vHosjvrCtPAvkRoJIIU7sC0LpfKc+dQUPCtfgwitqUtP1/H4q91Wwm8hWUI3TpHKwpp0KFenz4Xsum3uXSzAg/U+C0xuLDKryrDBS1zig0V8HHYUZRO5i83vG33hu3bMTK9G9V0CwMHMfgUheRsenQi9R84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1enbIkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1enbIkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81091F000E9;
	Tue, 14 Jul 2026 12:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784033330;
	bh=J7mAFyYlVacSQaqb519EftCOR4vKFwb0KR8yHKFR0H8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F1enbIkB4YRUMdOpqkwsaZ7ReX5InSJcxZVHTpM7KeKdW/eLsbR/LgnZvialUJkji
	 GNJaE1uooVn7Cb21aFtiZROGIisNVWDv1XB/ikbSor8Y+JRdSG84IQepFCVZnxxc3W
	 OlOPZXOaG4EuilXPmM3FbHIZvbXWVy9XrnN0P/3cUrOpV6A+5mLgL0DWTy7bG0EjEe
	 UotHq/xG1QV/DERxn8IEgJ3p3tgAy00IwWVs3vKdLJaBGB/cdI7V2lWmu9Ix5dxhH6
	 qfSQBtsMqh4OhFKDZGBJYyruBFHRaCCy7orxQyC8O5ZmghyiZMCD4fpSpz8mFEqaf2
	 qE9kCJMXrVbUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 17/56] scsi: qla2xxx: Enable init_firmware mailbox
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-18-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-18-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 12:48:50 +0000
Message-Id: <20260714124850.B81091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] SFP validation debug logging for QLA29XX is missing in qla2x00_get_=
firmware_state().
--

--- Patch [17]: [PATCH v4 17/56] scsi: qla2xxx: Enable init_firmware mailbo=
x for 29xx ---
commit 46f14f9f25f252d1cca6f3d9503e629aa6ac9d97
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable init_firmware mailbox for 29xx

The init_firmware mailbox command needs 29xx adapter support for reading
back SFP information via mb3 and for validating SFP status on successful
firmware initialization. Add IS_QLA29XX() checks alongside the existing
27xx/28xx checks.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 3fc08120fdf11..9c78aa66e12b3 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1968,7 +1968,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_=
t size)
> =20
>  	/* 1 and 2 should normally be captured. */
>  	mcp->in_mb =3D MBX_2|MBX_1|MBX_0;
> -	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
> +	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha=
))
>  		/* mb3 is additional info about the installed SFP. */
>  		mcp->in_mb  |=3D MBX_3;
>  	mcp->buf_size =3D size;
> @@ -1992,7 +1992,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_=
t size)
>  			    0x0104d, ha->ex_init_cb, sizeof(*ha->ex_init_cb));
>  		}
>  	} else {
> -		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
>  			if (mcp->mb[2] =3D=3D 6 || mcp->mb[3] =3D=3D 2)
>  				ql_dbg(ql_dbg_mbx, vha, 0x119d,
>  				    "Invalid SFP/Validation Failed\n");

[Severity: Low]
Does this code also need to update qla2x00_get_firmware_state()?

In qla2x00_get_firmware_state(), there is a similar block that logs a
warning for an invalid SFP, but it currently only checks for 27XX and 28XX:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_get_firmware_state() {
...
	} else {
		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
			if (mcp->mb[2] =3D=3D 6 || mcp->mb[3] =3D=3D 2)
				ql_dbg(ql_dbg_mbx, vha, 0x119e,
				    "Invalid SFP/Validation Failed\n");
		}
...
}

Will retrieving the firmware state on a QLA29XX adapter with an invalid SFP
fail to produce the expected debug log?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D17
