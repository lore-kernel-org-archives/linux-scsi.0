Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97521418A38
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306532; cv=none; b=d21U8bhPFChXH+FMW0QYS3XRpiAexfigqzgoXfrs91jPgYXrJcRWtfjImIZIsC9MVmnyL/Oyc8CVEKVXO/XkMDncg8j2iBsTEHJhLNciVUFH0dlH0CbnOfoXVddV06vuCwmilXgM1u0xGhMo5dqdBPmidyr+CSBJdjqIiElZzVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306532; c=relaxed/simple;
	bh=7tBDK4PnZ1mCWgJxhNirVtZZ9oRA0VVemod9kR8imq8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AzQYqsl9+6eCiIt/Lojiur914gd6E2u2dzalS2YnBmlFU7s+HZPJOkinF5lClBPYHn5JyIDc/IDEUkXMFuRX2U2BjP46hvIcaaScwOoofjaefjYglHF29guIN7BSNeP30gWhkMTWb8yLFwL46p29KR5+OsB5aVrEb0kiaNRQjkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WoWCsSqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WoWCsSqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276A31F00A3A;
	Fri, 17 Jul 2026 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306531;
	bh=9JdY6WCeO/8BsszJ/Yj8yFMIQZQbnwTfrW9g67+3dqc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WoWCsSqCpw8qI3dZVrrKtKxEhALmgYgclYALhMSWsnqQ3k7NGVrZ38FCF5OOylUNm
	 vuyNzGg2O/qfmZaVDG7msFEYZlR1Oc5sk6Dd26hbh+QxxIXO7N7TuYtNJxxg98UNtR
	 N9M7LY2psuU9UmO2nVexSglvGcO5MTzBSdIWje7evMExDMksZ2e79KkcJque57PvGD
	 JcD4o7eYHNc0UXlHxM4ds36qHSzl00N1zBB8eI5pLMVVusMJLPaUkKHYIvcMqTavrF
	 QNN1q+J2ilbVVIu5+gkyTE9KBUwig8xHdt5Nq+6QM2jRGi1m78pmQMKddyq0rJWncg
	 //xXaz+X2Npeg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 33/56] scsi: qla2xxx: Add abort command handling for
 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-34-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-34-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:42:10 +0000
Message-Id: <20260717164211.276A31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Race condition in asynchronous aborts (e.g., ELS DCMD timeouts) le=
ads to a Use-After-Free of the original command SRB (`orig_sp`) and potenti=
al memory corruption of newly allocated NVMe commands.
--

--- Patch [33]: [PATCH v5 33/56] scsi: qla2xxx: Add abort command handling =
for 29xx series ---
commit d0967e5f98d09c6d227bb75d1093a54e5b842954
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add abort command handling for 29xx series

Extend the abort-IOCB code path to support the 29xx extended
abort_entry_24xx_ext structure alongside the existing
abort_entry_24xx.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
[ ... ]
> @@ -3973,7 +3973,14 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, str=
uct req_que *req,
>  		return;
> =20
>  	abt =3D &sp->u.iocb_cmd;
> -	abt->u.abt.comp_status =3D pkt->comp_status;
> +	/*
> +	 * abort_entry_24xx_ext overlays abort_entry_24xx through the
> +	 * nport_handle/comp_status union at offset 8, so reading
> +	 * comp_status is stride-agnostic and goes through the 24xx view.
> +	 */
> +	abt->u.abt.comp_status =3D
> +	    ((struct abort_entry_24xx *)pkt)->comp_status;
> +
>  	orig_sp =3D sp->cmd_sp;
>  	/* Need to pass original sp */
>  	if (orig_sp)

[Severity: High]
This is a pre-existing issue, but could this race condition cause a
use-after-free on orig_sp?

If an SRB_ELS_DCMD or SRB_LOGIN_CMD times out, it triggers an async abort.=
=20
Since wait is false, the timeout handler returns immediately without waitin=
g=20
for the abort to complete.

If the firmware completes the original command (e.g., with CS_ABORTED), the=
=20
driver processes the completion, calls the done() callback, and frees the S=
RB=20
back to srb_mempool.

When the firmware later completes the ABT_IOCB, this code reads the now-fre=
ed=20
orig_sp:

qla24xx_abort_iocb_entry() {
    orig_sp =3D sp->cmd_sp;
    if (orig_sp)
        qla_nvme_abort_process_comp_status(pkt, orig_sp);
}

If that freed memory was reallocated for an active NVMe command,=20
qla_nvme_abort_process_comp_status() dereferences it, and=20
qla_wait_nvme_release_cmd_kref() drops the cmd_kref:

qla_wait_nvme_release_cmd_kref() {
    if (!(ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(orig_sp)))
        return;
    kref_put(&orig_sp->cmd_kref, orig_sp->put_fn);
}

Wouldn't this prematurely free an unrelated active NVMe command and cause=20
memory corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D33
