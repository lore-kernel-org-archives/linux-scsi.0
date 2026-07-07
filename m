Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ECE3AB5BB
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783408079; cv=none; b=N7MQAlEhElkGh7LFDBXj9HN/0Jl5spubrgt5ntqLw0VwXpcRgo4eoBCQ/BdmT/eOwGeKVXUb80SRBMKry2xPG6m4mwSC+mKWGX9Bzt2UIv6+Py33n5SSD4q3htK4TYrCnDfeujn7pqpMbYhXvd5oCUf//M04YnaJOZjVMcqDtJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783408079; c=relaxed/simple;
	bh=I3WlmSJUztZGl3vpwPkYSktEOpYZkICFQB+7JLPobUs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qqKhqjg8bsjdotOoeNSEk69wzWG6Rvu8MiLlbKR67Gkr7mK4esJv3d+UdndS8x/BoJW2FejYPagTlQmAojVSIy4DourC1AgJA5keKI4UXISihD7LbimJJ7rrd2iamHUEIuWLHl9HK/oFojRavo9EtdDuhcb7dqxMmtOggM+pWcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuCCi6QM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuCCi6QM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E487C1F000E9;
	Tue,  7 Jul 2026 07:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783408078;
	bh=iroSRFvXvRdtx9PBdMxzPIqsb77LtzF2u5954618eFU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PuCCi6QMxfcH15BgkM1k/IAoWirRQnm9MzwPp+eVgYGFGumeXANBMsim6V1yeiE4S
	 bSKfpOiT7dVW5Z+683gFmow0e1dapXj1/N1/g8YRfV1Deia/ihdeZksJjX2h38vbpE
	 FN45s5bSYWNxUIF5sWyqBP5PaeXBfzqSgJWAqgEhR6WtQYJDhEWPn5lgA6j0oeMwmp
	 IW5Z7861lqc/lposoRZs1ynvRNFNOsujABlH74tLF80qYZWqQ+XI6YSLF8gcEQ1moS
	 HgijPgpySgQ9t1tIc5WBLB9/fQ5i6go0i6jOXk2cdZQeIwKe/lHsIUm46thXx2dMVH
	 TiGTeFqG4t6lA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 52/88] scsi: qla2xxx: Hold qpair lock when sending
 NVMe LS reject
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-53-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-53-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:07:57 +0000
Message-Id: <20260707070757.E487C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Concurrent, unprotected modifications to `fcport->unsol_ctx_he=
ad` lead to list corruption.
- [Critical] Missing `list_del()` before freeing `uctx` on the error path i=
n `qla_nvme_xmt_ls_rsp()` causes use-after-free and list corruption.
- [High] Concurrent calls to `qla_nvme_ls_reject_iocb()` corrupt the shared=
 HBA-wide DMA buffer `vha->hw->lsrjt.c`.
- [High] Hardware request ring and MMIO doorbell are accessed unconditional=
ly on error paths even when the firmware is not started.
--

--- Patch [52]: [PATCH v3 52/88] scsi: qla2xxx: Hold qpair lock when sendin=
g NVMe LS reject ---
commit f0adf8d49d698bd5a0280fe2d4d514336c997f62
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject

qla_nvme_ls_reject_iocb() allocates from and advances the request ring
through __qla2x00_alloc_iocbs() (which assumes the hardware_lock is held)
and qla2x00_start_iocbs() (which advances the ring and rings the
request-in doorbell), but takes no lock itself. Two of its callers invoke
it without the producer lock held.

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

[Severity: High]
This is a pre-existing issue, but does this error path access the hardware
request ring and MMIO doorbell unconditionally even when the firmware is not
started?

Earlier in the function, there is a check:

    if (!ha->flags.fw_started)
        goto out;
       =20
If we jump to the out label because the firmware is offline or in reset,
we still call qla_nvme_ls_reject_iocb() here, which allocates IOCBs and
explicitly rings the MMIO doorbell. Can accessing ring structures and
ringing doorbells when the firmware is stopped result in hardware state
machine violations or a PCI Master Abort?

>  	kfree(uctx);

[Severity: Critical]
This isn't a bug introduced by this patch, but is a list_del() call missing
before freeing uctx on this error path?

If qla_nvme_xmt_ls_rsp() encounters an error and jumps to the out label,
it frees uctx via kfree(uctx). However, uctx was previously added to
fcport->unsol_ctx_head in qla2xxx_process_purls_iocb(). Won't skipping
list_del() leave a freed structure linked in the active list, leading to a
use-after-free the next time the list is traversed?

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
>  			struct qla_nvme_lsrjt_pt_arg *a, bool is_xchg_terminate)

[Severity: High]
This is a pre-existing issue, but are there missing concurrency protections
around the formatting of the HBA-wide DMA buffer vha->hw->lsrjt.c?

When qla_nvme_ls_reject_iocb() is called with is_xchg_terminate =3D false
from qla2xxx_process_purls_iocb(), it formats the reject payload directly
into this single shared buffer and submits an asynchronous command pointing
to its DMA address:

    qla_nvme_fc_format_rjt((void *)vha->hw->lsrjt.c, a->opcode,
                           a->reason, a->explanation, 0);
    a->tx_addr =3D vha->hw->lsrjt.cdma;

Since it can be called concurrently on different response queues (which
hold different qp_lock_ptr locks), could the payload be overwritten before
hardware DMA completes, causing the hardware to transmit mixed or corrupted
NVMe LS reject payloads?

[ ... ]

> @@ -1311,7 +1319,9 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha=
, struct purex_item *item)
>  		a.vp_idx =3D vha->vp_idx;
>  		a.nport_handle =3D uctx->nport_handle;
>  		a.xchg_address =3D uctx->exchange_address;
> +		spin_lock_irqsave(vha->hw->base_qpair->qp_lock_ptr, flags);
>  		qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a, true);
> +		spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr, flags);

[Severity: High]
This isn't a bug introduced by this patch, but does this function also issue
a reject unconditionally on the error path without checking if the firmware
is started?

If the firmware is stopped, could calling qla_nvme_ls_reject_iocb() here
result in similar hardware state machine violations?

>  		list_del(&uctx->elem);

[Severity: Critical]
This is a pre-existing issue, but does list_del() need a dedicated lock to
protect against concurrent list modifications?

The fcport->unsol_ctx_head list is modified in qla2xxx_process_purls_iocb()
using list_add_tail() while holding only the queue pair's hardware lock.
Meanwhile, list_del() is called here in a workqueue context entirely
unprotected.

Could multiple PURLS packets processed concurrently trigger concurrent
list_add_tail() and list_del() calls, leading to list corruption and kernel
panics?

>  		kfree(uctx);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D52
