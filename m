Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D4C3F23B7
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409078; cv=none; b=JX4NlJebTT+BRVzH4f5EvUSRtRQuZZjjfcCyMd1baYEIoUOPOdAb4EsdqreDTkDitL/cwcrVCFL7BLraKT4z+VdaA5XUNNh76N5WGqIOUWluctkvr5ioBRI9Y1T7mqmoCjpmHBNjck5YSVK0f9/G0HNC95RAimIw8M443lqX6p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409078; c=relaxed/simple;
	bh=rO+umBysPnFThG4Tc5zbyBqf/hf0JzdWOncFmDP2xb8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RmNA6kQJ9L8x05LKtZlSKuUdeFU4k96AaCYZO9vJOCDILaQQCCy7FImiJACcuU6qm+3/wdE1RPO/mKGO4fzMTsiRZWhFyKJbcYoiBgQpTUzXUtMFCpDfpo4IzKtXWM6c7Xd295qgJFl7v0bhBJhj1B+qa+dPmfUrQwx79hl+LlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TXkmgvLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TXkmgvLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16DE1F000E9;
	Tue,  7 Jul 2026 07:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409071;
	bh=uj+SHIVq/2akjsIfVO74IgEj3DArwYfANj0oA0MhfW8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TXkmgvLACf3ivaT+nYRDFk4CCd9iqCDq07423bbD/Sqj9h9I/J22Mo2S3pPBeCW9Z
	 EylFiZ0Uwqu4HagKT36fr0glILt6JB8h49MUJR80q1i61JNVghvtD8tF5JAnj87kxy
	 AnLuHtyFwVR6Ta9pdM1cJrOPQSPNGhCrVKfDhfIQSZP8lnflkDpQEyAdOWoyWqi044
	 jpsy9jOl+fF7eoy4Y/UQ0t4t+z2l9sz8qpDkiAmlL8XAMy0zXqL2khTtyI71mBF19N
	 h8Xh899I1MDR+b9dGPKPxyX4iiKboSngLK7CMn96WqZIWGGSZU0b5HQFtT4OBP/CMX
	 mvzGr7maDuChA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 70/88] scsi: qla2xxx: Bound rsp_info_len to avoid OOB
 sense-data read
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-71-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-71-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:24:31 +0000
Message-Id: <20260707072431.B16DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The target-provided residual length (resid_len) is not validated a=
gainst the command buffer size, allowing a malicious or buggy target to byp=
ass the mid-layer underflow check and cause a massive integer underflow in =
the SCSI mid-layer's good_bytes calculation.
- [High] A malicious or buggy target can permanently wedge the response que=
ue by causing track_sense_len to be non-zero without providing a subsequent=
 Status Continuation IOCB. The patch exacerbates this by clamping rsp_info_=
len to par_sense_len, which zeroes par_sense_len and guarantees the driver =
waits for a continuation IOCB that the hardware will never send.
--

--- Patch [70]: [PATCH v3 70/88] scsi: qla2xxx: Bound rsp_info_len to avoid=
 OOB sense-data read ---
commit b3865601a37114806cad8f5a0140e56664a684aa
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read

This commit addresses an out-of-bounds sense-data read in
qla2x00_status_entry() when the target reports a larger rsp_info_len than
par_sense_len. It clamps rsp_info_len to par_sense_len before subtraction
to prevent underflow and memory disclosure.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 497a0fef742fa..91a8344fea6c7 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3598,6 +3598,18 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct =
rsp_que *rsp, void *pkt)
>  	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
>  		/* Sense data lies beyond any FCP RESPONSE data. */
>  		if (IS_FWI2_CAPABLE(ha)) {
> +			/*
> +			 * A hostile or buggy target may report an
> +			 * rsp_info_len larger than the IOCB data area.
> +			 * Clamp it so the par_sense_len subtraction cannot
> +			 * underflow and walk sense_data out of bounds.
> +			 */
> +			if (rsp_info_len > par_sense_len) {
> +				ql_log(ql_log_warn, fcport->vha, 0x3107,
> +				       "Truncating bogus rsp_info_len 0x%x to 0x%x.\n",
> +				       rsp_info_len, par_sense_len);
> +				rsp_info_len =3D par_sense_len;
> +			}
>  			sense_data +=3D rsp_info_len;
>  			par_sense_len -=3D rsp_info_len;

[Severity: High]
This is a pre-existing issue, but could this change permanently stall the
response queue?

If a hostile or buggy target provides an rsp_info_len larger than
par_sense_len, the clamping here sets rsp_info_len to par_sense_len, which
results in par_sense_len becoming 0.

If the target also reported sense_len > 0, qla2x00_handle_sense() will clamp
sense_len to 0, but track_sense_len remains > 0.

This causes qla2x00_handle_sense() to expect a Continuation IOCB:

    if (track_sense_len !=3D 0) {
        rsp->status_srb =3D sp;
        cp->result =3D res;
    }

Since no continuation IOCB is actually coming, rsp->status_srb is never
cleared. Could this skip the done() callback for all subsequent commands and
permanently stall the queue?

[ ... ]

>  		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER)) {
>  			resid =3D resid_len;
>  			scsi_set_resid(cp, resid);
>=20
>  			if (!lscsi_status &&
>  			    ((unsigned)(scsi_bufflen(cp) - resid) <
>  			     cp->underflow)) {

[Severity: High]
This isn't a bug introduced by this patch, but does this calculation underf=
low
if the target provides a resid_len that is greater than scsi_bufflen(cp)?

If resid is larger than the buffer size, the unsigned subtraction wraps aro=
und
to a huge value, which would bypass the underflow check and skip assigning
DID_ERROR to the command result.

Could this lead to the block layer incorrectly assuming the data transfer w=
as
fully successful?

This same pattern appears to exist in qlafx00_status_entry() as well.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D70
