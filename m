Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22482DB7B4
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 17:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784049848; cv=none; b=griq4sJJh6ncWH87DbLoFM5kUA1w0K+fJNWqcCIsIFkshk/AFmQFeCFK2ukGy5TiZi9uvnLtHNs+3/59TMPHJlVeUTVaKBRlmaj12as2HbghrH4C/0z8rPJNuBM9dqcsgtjC2/XO4SDw/w2acDUpPWpR3bcrGwIQ+UUyutjpSYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784049848; c=relaxed/simple;
	bh=qPVME59PUDZTlP+LbrA+OrN88N2Fzau15jA0qQWKf8A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bBWz4TQfOTzELim7od31iCfcQC0Q+Mn1LVThsLmi9h52xo2lxn/vX70xBrQBDLBUqgL3NT08Wfs9qHEnmLcLFHno8vhJXLHHQ0Tx1rVW2iGQ0RFAFDRpwAmge3YPfx5CjH9HN8PskKoSCQxtY+yH8jYqEmezk7IhWDriF532hts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQSrxE+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQSrxE+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AED91F000E9;
	Tue, 14 Jul 2026 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784049847;
	bh=bU80hRUrN7n4Tee8a6EfwN8lfY0dg2X4fbnXSOVdSKI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hQSrxE+dqZybgbmWxadsUNPNeloiRvBYdqIQec2zSoufa4uYNrwDauijuVT30xpWg
	 3W0ufOElP3n4YrvnDshHew1YMCg8/srpvMDPjuh6nSXncAW1t6jxbxY9PQ5EWw8Xkd
	 Nra91LafP5kheesFKX5Qwyu5ke51Y76mkq2z3YvJLMSqvBr9cXe30KpKlqt+iPeY/i
	 LDG/BQDoL+UbrBVJiUIbbe7gRUrZtSQqz2hPY/qXvyKxtngkOOSOhugOvxFIDCGCpq
	 dTDCGl2+4uCH0pNn/yHkUCLGuDjpQ3+61kd32MlDUcTmajr/k18Q6V2wSyIm7xH0E1
	 o1TFCTBEYwHmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 46/56] scsi: qla2xxx: edif: Fix NULL pointer deref in
 RX SA delete check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-47-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-47-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 17:24:06 +0000
Message-Id: <20260714172407.0AED91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch incompletely fixes a type confusion bug caused by la=
te firmware completions, leaving a wild pointer dereference and out-of-boun=
ds write unhandled.
- [High] Non-SCSI commands that erroneously fall through to the SCSI comple=
tion path are leaked because their completion callback is never executed if=
 the union alias evaluates to NULL.
--

--- Patch [46]: [PATCH v4 46/56] scsi: qla2xxx: edif: Fix NULL pointer dere=
f in RX SA delete check ---
commit 05a47ccd14015571b07bc1e0befc11762885c911
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
   =20
qla_chk_edif_rx_sa_delete_pending() obtains the SCSI command via
GET_CMD_SP(sp) and immediately dereferences cmd->sc_data_direction.
That command pointer can be NULL: the firmware may post a status
completion for a command that has already been returned or aborted.
The caller qla2x00_status_entry() acknowledges this on the very same
status path, re-fetching GET_CMD_SP(sp) and bailing out with the
"Command already returned" message when it is NULL -- but that check
runs only after qla_chk_edif_rx_sa_delete_pending() has already
dereferenced the pointer, so a NULL cmd crashes the kernel in
interrupt context.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index ade1d81785736..bfa520f936a24 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -3540,6 +3540,9 @@ void qla_chk_edif_rx_sa_delete_pending(scsi_qla_hos=
t_t *vha,
>  	uint32_t handle;
>  	uint16_t sa_index;
> =20
> +	if (!cmd)
> +		return;
> +

[Severity: Critical]
This is a pre-existing issue, but does this check fully protect against wild
pointers?

If a non-SCSI command (like a BSG or ELS command) is completed with a
STATUS_TYPE IOCB (e.g., due to a timeout or transport error), sp->type
might not be SRB_SCSI_CMD.

In that case, the union evaluation in GET_CMD_SP(sp) could yield a non-NULL
wild pointer, leading to an out-of-bounds read when accessing
cmd->sc_data_direction here:

	if (cmd->sc_data_direction !=3D DMA_FROM_DEVICE)

And similarly, the caller in qla2x00_status_entry() could cast this wild
pointer as a valid scsi_cmnd and corrupt memory in scsi_set_resid().

Should we verify sp->type =3D=3D SRB_SCSI_CMD before trusting GET_CMD_SP(sp=
)?

[Severity: High]
This is also a pre-existing issue, but does the NULL check in the caller
leak non-SCSI commands?

Looking at qla2x00_status_entry() in drivers/scsi/qla2xxx/qla_isr.c:

	cp =3D GET_CMD_SP(sp);
	if (cp =3D=3D NULL) {
		...
		req->outstanding_cmds[handle] =3D NULL;
		return;
	}

If a non-SCSI command (like an ELS PLOGI/LOGO command) is submitted, and the
GET_CMD_SP(sp) union happens to evaluate to NULL (e.g., if the flags and
els_cmd fields are zero), this path returns early without calling sp->done(=
).

Can this leak the command and cause threads waiting for completion to hang?

>  	handle =3D (uint32_t)LSW(sts24->handle);
> =20
>  	/* find out if this status iosb is for a scsi read */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D46
