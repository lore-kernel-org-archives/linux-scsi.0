Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466543AB289
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409877; cv=none; b=NEgE42fElDvfw9DgNAjEvOhZx7ZJv2aZpq77W2ZmOfRyYIYO5rir1fJWJciTQGfPxRNBhadoTHfiR/ZkDUww1pR1f+o8iwKG0zI9nHZThXnxRBcmrOl6VX+JBiii/t39qnsr8egZdPwdCT6fI9mU39ML8lUG3mNOWU8s70U8eI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409877; c=relaxed/simple;
	bh=vCs10xkCRorPnX1kQRtxj4u2D39uXKZMcERalAK/RJY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A8vo1OLjGoNoEr7WG/Te+5sqd8i/Y5q8xD/i8MRPwMIowgHqx3x8R7BUuWXVdukcC1Fb3cbyo3wDI3gbp/oCwn/+O3gwG6qqDScrOb5GTlldffDQ/1o5L1mXYGJ2DtIHW7viDIi6x9tQtVVi0jr9siRKqZlw4/5nyjidiuqhRrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mrLM3DRC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mrLM3DRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179921F000E9;
	Tue,  7 Jul 2026 07:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409876;
	bh=MenBZh4T0AKYZEQ7psU+36xRa/uq2bA/5eb+xPGfSf8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mrLM3DRCJJGdZl4G7BLAKCZ/V7F3fi4CH+mVF9WPDsXke/C0HZ/ZmnQ4+P30fCRXN
	 enssIX1mTUkaqmukrIjNiLYj1zeVfdpyd+YHGH67G8QTnwIAQhTSgrrRJV1ZjvAmyI
	 TbFqvxDXmWOXz/2oRmyuJ/tFSZ9c8PgfDCnlnz3VRxj5svFvpcAsp0Xg3AnULxSLp+
	 qGKKoiUDLzABjKzB4shhYviQq1+WbbqaEL3Xb9pglvQZQkSUBhtTeU8QUsNlnrFXlc
	 ++3UYBBgP48XBwOkR1tz+uifQbu0TerB0s+AZ2Bnoya9O8kwtDBe58THkUGnAcPTF4
	 or3nG+4JhzXMg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 75/88] scsi: qla2xxx: Avoid double completion in
 async IOCB timeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-76-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-76-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:37:55 +0000
Message-Id: <20260707073756.179921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete Fix / Use-After-Free in timeout handlers
- [High] Firmware resource leak on timeout path
- [High] Spurious Abort / Race Condition due to handle reuse
- [High] Use-After-Free in abort completion handler
- [High] Indefinite Hang and Resource Leak in abort timeout handler
--

--- Patch [75]: [PATCH v3 75/88] scsi: qla2xxx: Avoid double completion in =
async IOCB timeout ---
commit f23f1a72942887da2ba25584e4324ef06430c7bc
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Avoid double completion in async IOCB timeout

This commit addresses a double completion and potential use-after-free
in qla2x00_async_iocb_timeout() when an async IOCB times out. It tracks
whether the SRB was successfully removed from outstanding_cmds[] before
invoking sp->done(), preventing a race with the response ISR.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 1f20ab386003d..d935fe5e5316a 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
[ ... ]
> @@ -251,6 +251,7 @@ qla2x00_async_iocb_timeout(void *data)
>  			lio->u.logio.data[1] =3D
>  				lio->u.logio.flags & SRB_LOGIN_RETRIED ?
>  				QLA_LOGIO_LOGIN_RETRIED : 0;
> +			found =3D 0;
>  			spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
>  			for (h =3D 1; h < sp->qpair->req->num_outstanding_cmds;
>  			    h++) {
> @@ -258,11 +259,19 @@ qla2x00_async_iocb_timeout(void *data)
>  				    sp) {
>  					sp->qpair->req->outstanding_cmds[h] =3D
>  					    NULL;

[Severity: High]
This isn't a bug introduced by this patch, but does removing the SRB here l=
eak
firmware resources?

By setting the outstanding_cmds[] slot to NULL without calling
qla_put_fw_resources(sp->qpair, &sp->iores), the resources are never releas=
ed.

The ISR would normally execute this cleanup, but since the SRB is removed f=
rom
the array, the ISR will never process it.

Does this permanently leak ha->fwres.iocb_used and ha->fwres.exch_used?

> +					found =3D 1;
>  					break;
>  				}
>  			}
>  			spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
> -			sp->done(sp, QLA_FUNCTION_TIMEOUT);
> +			/*
> +			 * Only complete the command if this path removed it
> +			 * from outstanding_cmds.  Otherwise the ISR already
> +			 * completed it and a second sp->done() would race the
> +			 * submitter's freeing of the on-stack completion.
> +			 */
> +			if (found)
> +				sp->done(sp, QLA_FUNCTION_TIMEOUT);

[Severity: High]
This is a pre-existing issue, but is this same tracking logic needed in oth=
er
timeout handlers?

Functions like qla2x00_els_dcmd2_iocb_timeout(), qla2x00_fxdisc_iocb_timeou=
t(),
and qla2x00_els_dcmd_iocb_timeout() currently invoke sp->done() or complete=
()
unconditionally, even if the command was not found in outstanding_cmds.

Could those functions suffer from the exact same double-completion and stack
use-after-free this patch fixes?

[ ... ]
> @@ -275,6 +284,7 @@ qla2x00_async_iocb_timeout(void *data)
>  	default:
>  		rc =3D qla24xx_async_abort_cmd(sp, false);

[Severity: High]
This is a pre-existing issue, but does this unconditional abort submission =
race
with handle reuse?

If the timer execution races with the ISR, the ISR may complete the original
command and return its handle to the pool before the abort is submitted.

Then qla2xxx_get_next_handle() could assign that same handle to a newly
submitted, unrelated command. Will the firmware then receive the abort and
incorrectly terminate the new command?

[Severity: High]
This is also a pre-existing issue, but can qla24xx_async_abort_cmd() introd=
uce
a use-after-free in its completion handler?

When building the abort command, it stores a weak pointer to the original
command:
    abt_sp->cmd_sp =3D sp;
   =20
This is done without incrementing the original command's reference count.

If the ISR completes and frees the original command before the abort comple=
tes,
would qla24xx_abort_sp_done() dereference the freed memory via
qla_wait_nvme_release_cmd_kref(orig_sp)?

[Severity: High]
While looking at the abort timeout path, there is another pre-existing issu=
e.
Does qla24xx_abort_iocb_timeout() have a loop termination bug that leaves
commands stranded?

When iterating over outstanding_cmds to locate both the abort command (sp)
and the original command (sp->cmd_sp), the loop breaks immediately if it
encounters the abort command first.

Because handles can wrap around, the abort command can receive a lower inde=
x.
In that scenario, sp->cmd_sp is never reached in the search.

Does this leave the original command in outstanding_cmds forever, causing t=
he
submitter to hang indefinitely?

>  		if (rc) {
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D75
