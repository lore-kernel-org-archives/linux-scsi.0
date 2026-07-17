Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462AE42BE83
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784309856; cv=none; b=Ww+k378XWi/druFJWxCSmUZs1zKTWvSVQTuZ9RG+2dyXHm7AswJtM2U/CxFWo56bCaE6sh5BJYQbK0XIIumijdpRpRNsUwl6snX+1vr/92YHc0AZL3Nvpc/feyhC1xhDQpcrDT7A/gNs+IEhwh6POBOI/PCskJNNtcegzJrJtYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784309856; c=relaxed/simple;
	bh=DucHory4z2grTsW2TqCCRz+VN+A1t9gifJkIOr4j+cg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PFJzR0QFhxZkCn85TUcoLr5asrhpsnM2Ots3DvIeplI2EU/aRjfsyHR9EIa0Rj5C2SfWf76+PAGW4/oWIjbHobBSaYLf8CbtrnOB06Rwmbkix+n6T9i5g/RKNCQcNk9h//c9ALSUwAuZqdKILsDvdcwsiCRId3ZZO94AWRVBqF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KcSFcGwK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KcSFcGwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619531F000E9;
	Fri, 17 Jul 2026 17:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309850;
	bh=GVTOKMJANEIxxoXZkhPUVs1gsxMOJ9ckHVLt2dNWVi4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KcSFcGwKIbzvRAvPB10upmklEyxkXgg8tWLHedhrsq6Yl3IE5/TTnTkJsTJi4cgNt
	 ONmVLXJ4w79JqK+d9GXH8xKp2F8Ei05sBULunAF0dW4zH0L9RMfzu2XHPc+Zj2Cr/9
	 bGxW5Zxvf8VV7wA3bIgQ3tR0q6jSVsEObfbsjBZluFgA/tEa+nk/+3Bhpjq4E8z1Yy
	 Z2E+CaK4TmTBzc7vQ8dZTy46GkralbUExRRRpNpb3Ok4ma+uzNxJXkd9IP5hIPp291
	 3nT8ewM4ijODpj8gyE3nYS8qLKiPxemm6wr2J6tcjiSFs9427DXTWPaUyaJMydq7xw
	 HvoRqxyBaa9iQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 46/56] scsi: qla2xxx: edif: Fix NULL pointer deref in
 RX SA delete check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-47-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-47-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 17:37:29 +0000
Message-Id: <20260717173730.619531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Type confusion via union aliasing leads to garbage pointer derefer=
ence and out-of-bounds memory access.
- [High] Lockless access and lifecycle violations of `sp->comp` in `qla2xxx=
_eh_abort` lead to Use-After-Free writes and stack memory corruption.
--

--- Patch [46]: [PATCH v5 46/56] scsi: qla2xxx: edif: Fix NULL pointer dere=
f in RX SA delete check ---
commit f3d9d21eec008d26eea4a3d4464f6407598d13d3
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check

This patch adds a check in qla_chk_edif_rx_sa_delete_pending() to return
early if the command pointer obtained via GET_CMD_SP(sp) is NULL. This
prevents a kernel crash in interrupt context when accessing
cmd->sc_data_direction for commands that have already been returned or
aborted.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
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

[Severity: High]
This is a pre-existing issue, but does this fully protect against
dereferencing an invalid pointer?

If a non-SCSI command completion (such as SRB_BIDI_CMD or SRB_CT_CMD)
is processed by qla2x00_status_entry() in qla_isr.c and falls through to
qla_chk_edif_rx_sa_delete_pending(), GET_CMD_SP() will read from the
overlapping fields in the sp->u union.

If those overlapping bytes happen to be non-zero, this new check passes,
and we could end up dereferencing a garbage pointer when accessing:

    if (cmd->sc_data_direction !=3D DMA_FROM_DEVICE)
        return;

Could this lead to out-of-bounds memory accesses or a kernel panic if
the firmware sends a STATUS_TYPE completion for a non-SCSI command?

>  	handle =3D (uint32_t)LSW(sts24->handle);
> =20
>  	/* find out if this status iosb is for a scsi read */

While reviewing the SRB completion paths related to this change, I noticed
another unrelated lifecycle issue in drivers/scsi/qla2xxx/qla_os.c.

[Severity: High]
This is a pre-existing issue, but is there a potential use-after-free
race condition between qla2xxx_eh_abort() and qla2x00_sp_compl()?

In qla2xxx_eh_abort(), a completion struct is allocated on the stack
and assigned to sp->comp. If the firmware concurrently completes the
command, qla2x00_sp_compl() might execute this sequence:

drivers/scsi/qla2xxx/qla_os.c:qla2x00_sp_compl() {
    ...
    scsi_done(cmd);
    if (comp)
        complete(comp);
    ...
}

Because scsi_done() is called before complete(comp), ownership of the
scsi_cmnd transfers to the block layer, which could asynchronously free it.
If qla2xxx_eh_abort() wakes up and clears the pointer:

drivers/scsi/qla2xxx/qla_os.c:qla2xxx_eh_abort() {
    ...
    sp->comp =3D NULL;
    ...
}

Could it write to a freed scsi_cmnd?=20

Furthermore, if qla2x00_sp_compl() reads sp->comp but is preempted before
calling complete(), and qla2xxx_eh_abort() times out and returns,
destroying its local stack frame, could qla2x00_sp_compl() later resume
and call complete() on a destroyed stack variable?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D46
