Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95EA347505
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262796; cv=none; b=qXa8ZAWhIYaKr5H/VNTKaJ/U2EFRw3059V/8O+kDN1vxtPW0r5Dc/biGX3W2M6s+/k2UXSMdHwCBvEp1EqYLcvGXdSlMFO5+hc5Cmt+KBfkjQZpCa4UDDVtZOAzN8ALT8IFhv2HS8TOJze9Ux5QfQwBER6sC3rkzsN6IH1gZem4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262796; c=relaxed/simple;
	bh=3OFCapuo9cY2GR7WD+cdcjPvveafqIXx4pnc3GOTZd8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eTibBkcRDrbB1AqEUOmueeRH2jhncpTb2VlfrQCNhiVbMoYbYzMVq9y13sD1m/UWV0voN9tyANTjpzPT537BxDOQ3tNDfVXqH1hllgagaFezvpfd9qkmIAguygTN8LgNLjzR2q9xLPWo9NloqJ3TOyoCnc/TquoLyNRdAobw5wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kVMYmsOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kVMYmsOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05AB1F000E9;
	Fri, 12 Jun 2026 11:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781262795;
	bh=J8wBBcPnJRuMKP5EVEHuSejWh1vKbQ+NfjGBQoJ+DFg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kVMYmsOUqWSYas2ZE9vL3bHOm0+paD6Su1BkXwZHZglVkx/yCX4dcUkoJqDrOQALM
	 o4lEWnqQvQ361bgGzDqOwvJdYAtxiiiYeVKYd/EfkDgcBzs5XSPSGdwPo3pgOmg8xe
	 unSA8FnkmQdGTNtFQg0DdxW9aKWAHZ6o7jEIr4vEaIK7Zn8+wMt0c0QfQMSlntC5+I
	 BMs5tgZIydoTnqQJyfOD/LcwWFEnpZ8Hv8hk7S2TxKcLyComkjmquK3AUlKuwYm2vS
	 k4PNWWM9oHCXan2ydVWGmPjhgpdd4E/b7ce+fse9HF3HG9ykFR4hqiCr1yUtZAi5ht
	 XC5lpDhC+Ll+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 35/60] scsi: qla2xxx: Enhance task management IOCB
 handling for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-36-njavali@marvell.com>
References: <20260612095333.1666592-36-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:13:14 +0000
Message-Id: <20260612111314.D05AB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] TOCTOU race in `qla24xx_abort_command` allows aborting the wrong c=
ommand.
--

commit 4a66306dbd0c94dca32a3a10c1542df961832d3b
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance task management IOCB handling for 29xx series

Update qla24xx_tm_iocb() and __qla24xx_issue_tmf() to support the
extended task management structure (tsk_mgmt_entry_ext) for 29xx
adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c

[ ... ]

> int
> qla24xx_abort_command(srb_t *sp)
> {
> 	int		rval;
> 	unsigned long   flags =3D 0;

[ ... ]

> 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
> 	for (handle =3D 1; handle < req->num_outstanding_cmds; handle++) {
> 		if (req->outstanding_cmds[handle] =3D=3D sp)
> 			break;
> 	}
> 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> 	if (handle =3D=3D req->num_outstanding_cmds) {
> 		/* Command not found. */
> 		return QLA_ERR_NOT_FOUND;
> 	}
>=20
> 	abt_buf =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);

[Severity: High]
This is a pre-existing issue, but can this sequence lead to aborting the
wrong command?

In qla24xx_abort_command() here, the qp_lock_ptr spinlock is released after
finding the hardware handle for the command. Then dma_pool_zalloc() is call=
ed
with GFP_KERNEL, which can sleep.

During this sleep window, could the original command complete, freeing the
handle for reuse by a newly submitted I/O request?

When qla24xx_abort_command() resumes, it uses the now-stale handle to
construct the abort IOCB:
abt->handle_to_abort =3D make_handle(req->id, handle);

Could this cause the firmware to incorrectly abort the newly submitted I/O
command instead of the intended one?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D35
