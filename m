Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58F3344D92
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307321; cv=none; b=EyGEBZnTYuQYFK7wNrnS/oc+9vcqxPzyq5hKT2ZwshBASfmjD8nC6QSn1C9PYmfroayyBB6yC5Uukxe1CD2pTJtCbpkc1lyWe+eLL9oHNBWw28q5WVjOSrk0N+qq1T8A3Zi8QPbO530eUWdk8OZ0nNFK3oUvZhb7iHHVKo36A+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307321; c=relaxed/simple;
	bh=+TEqotFBmhEtmo9Ea7WLO7Ej7/eCJdizjuJtenvM1Cw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sacIIO54pzKLXj92Idd18021I+eEUjkFXhABT9pW2wR5sSkoBQCh+EbnIfWXWa073sS+5TFuoxMUM/EgkB/+iLtSxorxW9Ife58LIz3UzQS+85MEaDFaLvWfI5IhPuCYWtK/F4h6UNkuQvKdsXqtz8Y/qcpGCA14I6t1/iMJE4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWUsInc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWUsInc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A2D1F000E9;
	Fri, 17 Jul 2026 16:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307320;
	bh=0CcCJV10xLQanxjXcUhtkRY+6NemmCH4X22kBm2cUCY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oWUsInc9bXX0AE7+QLKpHMZjR+tLiFN3uZ4AYNymHxVQKfVWraPOtktHglo3fVIej
	 d3fa0RmLTx1VaQR16V+Sv9PPt5bC1Xin9KetlCPiIGwf+bq3KrLvjpXXlbdTsugawu
	 RrGJDobXRiK75OglwSqBIJ4nR2hkhyjI9F8WMaQnfP8YCuFJwnTTACjrme+oMgKgDv
	 rlzRx0cQIHbaURA8ZPP/9M1ttEiLqYlI2tqEWSKxywEL0nygJW2Egd+HeXf9Eodv5K
	 u9sauFexue77SbDd7Lnh1ufM/bYTojvN1tSwFzn3SIZMLZASknt0taPzzGS8J773mZ
	 NUSjqw1a2DSNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 52/56] scsi: qla2xxx: Hold qpair lock when sending
 NVMe LS reject
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-53-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-53-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:55:19 +0000
Message-Id: <20260717165520.72A2D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing `list_del()` on the error path in `qla_nvme_xmt_ls_rsp=
()` leaves a freed object in `fcport->unsol_ctx_head`, causing use-after-fr=
ee and list corruption.
- [High] Concurrent, unlocked list operations on `fcport->unsol_ctx_head` l=
ead to race conditions and list pointer corruption.
- [High] Unconditional hardware doorbell writes in `qla_nvme_xmt_ls_rsp()` =
when firmware is stopped.
- [Medium] Concurrent handling of unsolicited NVMe Link Services on differe=
nt response queues causes a data race on the globally shared reject DMA buf=
fer (`vha->hw->lsrjt.c`).
--

--- Patch [52]: [PATCH v5 52/56] scsi: qla2xxx: Hold qpair lock when sendin=
g NVMe LS reject ---
commit 4dcde06839422633d8d12bf8b040c6155f279d01
Author: Nilesh Javali <njavali@marvell.com>
scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject

This patch adds queue pair lock protection around calls to
qla_nvme_ls_reject_iocb() in unlocked purex work and xmt_ls_rsp contexts.
This prevents concurrent accesses from corrupting the request ring
producer state.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 3b2f255a5d7d4..8dc6df6c2e1c5 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
[ ... ]
> @@ -440,7 +441,9 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_p=
ort *lport,
>  	a.vp_idx =3D vha->vp_idx;
>  	a.nport_handle =3D uctx->nport_handle;
>  	a.xchg_address =3D uctx->exchange_address;
> +	spin_lock_irqsave(ha->base_qpair->qp_lock_ptr, flags);
>  	qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
> +	spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
>  	kfree(uctx);

[Severity: Critical]
This isn't a bug introduced by this patch, but does the error path in
qla_nvme_xmt_ls_rsp() leave a freed object in the list?

If we reach the out label (for instance, when !ha->flags.fw_started is true=
),
kfree(uctx) is called, but list_del(&uctx->elem) is omitted. Could this lead
to a use-after-free if the fcport->unsol_ctx_head list is traversed later?

[Severity: High]
This is also a pre-existing issue, but does calling qla_nvme_ls_reject_iocb=
()
here unconditionally ring the hardware doorbell even when the firmware is
stopped?

Earlier in qla_nvme_xmt_ls_rsp(), if !ha->flags.fw_started is true, it jumps
to the out label, which calls qla_nvme_ls_reject_iocb(). That helper alloca=
tes
an iocb and calls qla2x00_start_iocbs(), which writes to the hardware doorb=
ell.
Can this cause hardware faults on a stopped or resetting device?

>  	return rval;
>  }
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

[Severity: Medium]
This is a pre-existing issue, but can concurrent calls to
qla_nvme_ls_reject_iocb() corrupt the shared reject buffer?

When called with is_xchg_terminate as false from different response queues,
the helper writes directly to the globally shared vha->hw->lsrjt.c buffer:

qla_nvme_ls_reject_iocb() {
    ...
    if (!is_xchg_terminate) {
        qla_nvme_fc_format_rjt((void *)vha->hw->lsrjt.c, a->opcode,
                               a->reason, a->explanation, 0);
        a->tx_addr =3D vha->hw->lsrjt.cdma;
    ...
}

Since multiple response queues can process unsolicited link service packets
concurrently while holding different queue-specific locks, can this lead to
torn writes and corrupted payloads being sent to the hardware?

>  			struct qla_nvme_lsrjt_pt_arg *a, bool is_xchg_terminate)
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

[Severity: High]
This is a pre-existing issue, but is the fcport->unsol_ctx_head list protec=
ted
against concurrent modifications?

In qla2xxx_process_purls_pkt(), list_del(&uctx->elem) is called from a work=
queue
context without holding a lock:

qla2xxx_process_purls_pkt() {
    ...
    list_del(&uctx->elem);
    kfree(uctx);
    ...
}

Elements are added to this list concurrently using list_add_tail() from the
response queue context (like in qla2xxx_process_purls_iocb), and removed
from other contexts (like qla_nvme_release_lsrsp_cmd_kref). Could this resu=
lt
in list pointer corruption?

>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D52
