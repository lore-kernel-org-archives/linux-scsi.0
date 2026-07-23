Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5579A42B73F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 09:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799949; cv=none; b=gKEgRHLcroNdtyIpOvB6LyxY6NkIQt0J6wa9G2QcFfMcKSmLW2vE8frXvXd0GQguG8fIL9uOB0PB/f0347PpOw60cZrIG3R2EQE53P/EkvB2CrxbnbgfQ9ve41jPNoTINGkL9XRxishMORKcHqL9VEFBxsdOjHObvYZLBoAf6mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799949; c=relaxed/simple;
	bh=nXj7ZDB1c8MOqI2WUMxOqKAF60il7yB89DFqVK2ULlg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ncqj8zp2eG1vlpeAZ+kG+OF6aYcCfXmXi+BpJaAZVCV+OvjkAbD3AvD0SeVVNhBRiQks9QTOEt38LYnt4uUjXM8dj+qyHbf8GQeJOdMB4mOrADZOwGZ+pyvlqZ4oy7r7aQJlEXJI+bI02SCOSUKHYg6YIzFkX3eS+9Oq2uLLghY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43881F000E9;
	Thu, 23 Jul 2026 09:45:47 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 17/56] scsi: qla2xxx: Enable init_firmware mailbox
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-18-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-18-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 09:45:45 +0000
Message-Id: <20260723094547.D43881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing IS_QLA29XX() generation checks in firmware state and dat=
a rate mailbox commands, leading to incomplete hardware support.
--

--- Patch [17]: [PATCH v6 17/56] scsi: qla2xxx: Enable init_firmware mailbo=
x for 29xx ---
commit 7e60ed82a282887839ef4256a5c2633b284fa01f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable init_firmware mailbox for 29xx
   =20
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

[ ... ]

> @@ -1992,7 +1992,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_=
t size)
>  			    0x0104d, ha->ex_init_cb, sizeof(*ha->ex_init_cb));
>  		}
>  	} else {
> -		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {

[Severity: Medium]
Since IS_QLA29XX(ha) is added here for SFP validation and mailbox commands,
should it also be added to other mailbox commands like
qla2x00_get_firmware_state()?

For example, without it, MPI state reporting fails to request mcp->mb[12]
on 29xx adapters:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_get_firmware_state() {
	...
	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
		mcp->mb[12] =3D 0;
		mcp->out_mb |=3D MBX_12;
		mcp->in_mb |=3D MBX_12;
	}
	...
}

This also causes sysfs MPI state reads to fail for 29xx adapters:

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_mpi_fw_state_show() {
	...
	if (!(IS_QLA27XX(ha) || IS_QLA28XX(ha)))
		return scnprintf(buf, PAGE_SIZE,
				"MPI state reporting is not supported for this HBA.\n");
	...
}

Does IS_QLA29XX(ha) also need to be included in data rate commands to report
FEC link status?

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_set_data_rate() {
	...
	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
		mcp->in_mb |=3D MBX_4|MBX_3;
	...
}

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_get_data_rate() {
	...
	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
		mcp->in_mb |=3D MBX_4|MBX_3;
	...
}

>  			if (mcp->mb[2] =3D=3D 6 || mcp->mb[3] =3D=3D 2)
>  				ql_dbg(ql_dbg_mbx, vha, 0x119d,
>  				    "Invalid SFP/Validation Failed\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D17
