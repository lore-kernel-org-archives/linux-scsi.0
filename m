Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C135032ED54
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784052454; cv=none; b=DfpwD9qXpWQ46CTRK4ru61i4PNGyXV6bZvzZTivo6zorQmZbFRWvkbzh5ogJrLlovKQNax5IXljvFw1lwgaktDKxt9HqT6iUiwLfOnd0hOWHQ8MkE+P8WSdHz7wett1tzlSEdODNGwBeZ2ZE/5DvyFN4Ln1zSg0cFe7OK2nyia4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784052454; c=relaxed/simple;
	bh=pXGP1CxMwALf1X/pyduNPtJZQGf4XfNK1wTw65pWlD0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MdpUaYEJzIyvvAYNFkm73tbClxly5Vs2/+KQqmACtooKPhzzEMrH3oWIovG8teDvPPUdaEItlJwNa2xhUjDPdnrxHRGgtMXz8At5JZOki5Ns71A68Ky9qN/WxAxFpLOFuoghvctGoSd1khLBbVBiMVLYRvyAOsy96/Bs3xNDTmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5QcztsT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5QcztsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357091F000E9;
	Tue, 14 Jul 2026 18:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784052453;
	bh=aZ4m5FRZH8qcJ2WotPQOnUx616v7I8S8XLSTNWYYb5U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R5QcztsTeDHut28klFxMbSNm5XAfMWDbpM3dPhsPJLpPn8JbCC9MPpnqm4xkwtFKG
	 hG61zHp4IE9S7qS9Mop39UVrWRy/yBvfE3RV9eIvxnK1y48S5jxFotF1svHa+ts/Hi
	 Jmvdy9LhgiC0ts8vWooCkf4VN29SCfuAPKrdybokdskGeJX+6aaDEpnDp0RyOcBO/B
	 Pj267q7bgmQlI6JP6QR3a++2f4EeYyrFH9F3Id0Dz9ixTUBcKlaWApdOqwAwjonfbX
	 +BOPSWlp/Afk6HigOUpoFuI0FEeKLzPAF59ZF/+h57x9sZyEZzxDvfvqe27V31i8Kl
	 f7NTsoJF3Wg4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 52/56] scsi: qla2xxx: Hold qpair lock when sending
 NVMe LS reject
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-53-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-53-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 18:07:32 +0000
Message-Id: <20260714180733.357091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing list_del() in qla_nvme_xmt_ls_rsp() error path leads to Us=
e-After-Free list corruption
- [High] Concurrent lockless modifications of fcport->unsol_ctx_head list c=
ause list corruption
- [High] Concurrent formatting of shared HBA-wide LS Reject payload buffer =
causes data corruption
--

--- Patch [52]: [PATCH v4 52/56] scsi: qla2xxx: Hold qpair lock when sendin=
g NVMe LS reject ---
commit ad95c4a49a1dcc181e2c5db29ae039a2ea5d99d4
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject

This commit takes the hardware_lock (via qp_lock_ptr) in the unlocked calle=
rs
of qla_nvme_ls_reject_iocb(), preventing concurrent execution with normal I=
/O
submission on the base ring. It ensures the ring producer state is protecte=
d=20
from corruption leading to duplicated or dropped commands.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -440,7 +441,9 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_p=
ort *lport,
>  	a.vp_idx =3D vha->vp_idx;
>  	a.nport_handle =3D uctx->nport_handle;
>  	a.xchg_address =3D uctx->exchange_address;
> +	spin_lock_irqsave(ha->base_qpair->qp_lock_ptr, flags);
>  	qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
> +	spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
>  	kfree(uctx);

[Severity: High]
This is a pre-existing issue, but missing a list_del() in the
qla_nvme_xmt_ls_rsp() error path can lead to a use-after-free list corrupti=
on.

When the transport layer attempts to send the response, if sending fails,
the code jumps to the out: error path. It frees the uctx object via kfree()
without unlinking uctx->elem from the fcport->unsol_ctx_head list.

A subsequent unsolicited LS request will perform list_add_tail() on this li=
st,
writing to the freed memory. Should a list_del() be added here?

[ ... ]

> @@ -1243,6 +1246,10 @@ static void qla_nvme_lsrjt_pt_iocb(struct scsi_qla=
_host *vha,
>  	}
>  }
> =20
> +/*
> + * Allocates from and advances the request ring, so the caller must hold
> + * qp->qp_lock_ptr (the response-queue caller already holds it).
> + */
>  static int
>  qla_nvme_ls_reject_iocb(struct scsi_qla_host *vha, struct qla_qpair *qp,
>  			struct qla_nvme_lsrjt_pt_arg *a, bool is_xchg_terminate)

[Severity: High]
This isn't a bug introduced by this patch, but doesn't
qla_nvme_ls_reject_iocb() format the shared HBA-wide LS Reject payload buff=
er
without HBA-level synchronization?

When an invalid unsolicited NVMe-FC LS request is received,
qla2xxx_process_purls_iocb() invokes qla_nvme_ls_reject_iocb(..., false).
This formats the reject payload directly into vha->hw->lsrjt.c, a single
HBA-wide buffer allocated at probe time.

Because qla2xxx_process_purls_iocb() is called holding only the per-queue-p=
air
lock, if multiple NVMe-FC requests arrive on different queue pairs
simultaneously, multiple CPUs will concurrently overwrite the same lsrjt.c
buffer without any HBA-level synchronization.

Could this result in the hardware doing a DMA from concurrently overwritten
memory, transmitting corrupted or interleaved protocol data?

[ ... ]

> @@ -1311,7 +1319,9 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha=
, struct purex_item *item)
>  		a.vp_idx =3D vha->vp_idx;
>  		a.nport_handle =3D uctx->nport_handle;
>  		a.xchg_address =3D uctx->exchange_address;
> +		spin_lock_irqsave(vha->hw->base_qpair->qp_lock_ptr, flags);
>  		qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a, true);
> +		spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr, flags);
>  		list_del(&uctx->elem);
>  		kfree(uctx);
>  	}

[Severity: High]
This is a pre-existing issue, but does removing elements from the
fcport->unsol_ctx_head list without locks cause list corruption?

Elements are added to fcport->unsol_ctx_head via list_add_tail() in
qla2xxx_process_purls_iocb() from the response queue processing context whi=
le
holding the queue pair lock.=20

However, they are removed here via list_del() in qla2xxx_process_purls_pkt()
entirely unlocked, which is now clearly outside the newly added qp_lock_ptr
region.

The same unlocked list_del() also occurs in qla_nvme_release_lsrsp_cmd_kref=
().
Could these concurrent non-atomic operations corrupt the next and prev poin=
ters?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D52
