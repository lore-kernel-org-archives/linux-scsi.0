Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833C138239A
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 18:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784313120; cv=none; b=Zm+strzmpde3l50lws/ccsdxBrpHnPTRRGNjAtGsaihiMltG46yHIkQP/wiu5RnczXQ4P/XAEkKEgpKW2BGoDijmkVmUJYm1QjNYVzbk3rW581zuQSs15HprnyzwiWns0CpaZCMw37POLDJOTh/JJu55eQkbRVE88eTM1UBrbBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784313120; c=relaxed/simple;
	bh=XmK6M6v6aYpSlSqS/0roexI67RwoN1AFAgngc+VDwEk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QEYgR8m3NmQ/S4xRhvHrAgmCCIFHNgkwkfESjx+vA0arWtE7GhZaJ1auhf/J27OMknP9CRB2FTchvJqkVFmrErwaC71o+P1Rg9oxaG1URwH6L+K4+Lfml6VoJZwMfniHWgWpi9ZWRsJr6QYRsEZDkoW3BwAxewnGk9sL3FX8ig0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ei+aR6t8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ei+aR6t8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038991F000E9;
	Fri, 17 Jul 2026 18:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784313119;
	bh=xKgQNpc8tY4R5bG1448v1T/S2Kr96y/YK+Hkcv7AwJo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ei+aR6t8xrWspLL9L3MHwdmTSSZRuNXHEDOuyXdvMZKhSlV+n8TxRBYk4gRqJaZ6F
	 7w7IpGsuJKQ24+ENcLDiOpSsK2pjcyb8ZmhsxRutvsg6RmJnT+Z99GZjgdripw7pD1
	 D+Lt21IR74He2QddH5oc0cTl8xtS2S0qQs2USmfTz39zEv8EqOc6t8KBXHFcbcyqiU
	 czPWXWIL9+gzenDql3LDpv5gnxA8BmYvtF7Yhuv34ln0A47Ak2ttiMsYzM9Q4kiN3Y
	 6elXl+m4fURQ2w5f3FS9Nzqltd1ErZeDfZn0ms54LlSH7vCE0mu8aVtoY1jEM7ACfp
	 026dXib6mPvaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 32/56] scsi: qla2xxx: Enhance task management IOCB
 handling for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-33-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-33-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 18:31:58 +0000
Message-Id: <20260717183159.038991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The async abort IOCB builder `qla24xx_abort_iocb()` uses the 64-by=
te `struct abort_entry_24xx` layout unconditionally without adapting for QL=
A29XX adapters, which require the 128-byte `struct abort_entry_24xx_ext` la=
yout. In the 29xx extended layout, the `vp_index` field is at offset 18, wh=
ereas in the 24xx layout it is at offset 51. Since the request slot is zero=
-initialized and the function writes to offset 51, the 29xx firmware will r=
ead a `vp_index` of 0.
--

--- Patch [32]: [PATCH v5 32/56] scsi: qla2xxx: Enhance task management IOC=
B handling for 29xx series ---
commit 64d0e684253fddc727ea9ea4498791ce4527162b
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance task management IOCB handling for 29xx series

This commit updates the QLA2XXX task management IOCB builders to use the
extended tsk_mgmt_entry_ext structure for QLA29XX adapters. By checking
IS_QLA29XX(), it correctly shifts the vp_index field assignment to match
the 128-byte stride layout expected by the 29xx series firmware.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
[ ... ]
> @@ -2736,26 +2736,39 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry =
*tsk)
[ ... ]
>  	tsk->control_flags =3D cpu_to_le32(flags);
> -	tsk->port_id[0] =3D fcport->d_id.b.al_pa;
> -	tsk->port_id[1] =3D fcport->d_id.b.area;
> -	tsk->port_id[2] =3D fcport->d_id.b.domain;
> -	tsk->vp_index =3D fcport->vha->vp_idx;
> +	if (IS_QLA29XX(ha)) {
> +		((struct tsk_mgmt_entry_ext *)pkt)->vp_index =3D
> +		    cpu_to_le16(fcport->vha->vp_idx);
> +	} else {
> +		tsk->port_id[0] =3D fcport->d_id.b.al_pa;
> +		tsk->port_id[1] =3D fcport->d_id.b.area;
> +		tsk->port_id[2] =3D fcport->d_id.b.domain;
> +		tsk->vp_index =3D fcport->vha->vp_idx;
> +	}

[Severity: High]
Does this logic also need to be applied to the asynchronous abort path in
qla24xx_abort_iocb() within the same file?

Looking at qla24xx_abort_iocb(), it appears to still use the legacy 64-byte
layout unconditionally:

static void
qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
{
    ...
	abt_iocb->vp_index =3D vha->vp_idx;
	abt_iocb->req_que_no =3D aio->u.abt.req_que_no;
    ...
}

Because the 29xx extended layout expects vp_index at offset 18 instead
of offset 51, and the request slot is zero-initialized, won't the 29xx
firmware read a vp_index of 0 here?

Could this result in asynchronous I/O aborts on NPIV virtual ports being
incorrectly routed through the physical port (VP 0) or rejected with
errors like CS_PORT_UNAVAILABLE?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D32
