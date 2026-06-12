Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12530356751
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 22:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781303356; cv=none; b=Reics4oi5DpWyFMVCOT8pbyiKm9DkNOWHuHbOSsoy+sEHPVaYFLB+FTf9uDaMbEA2vlTV9vtQbNlHU0vdKNRlC2YV0SB4E3Hsy5ClE9w23X66HfFcScMirXZWZ5lGxjMaKIGSivYS6a5H3mx847g9j6XuWVGKPtqkHc4IMZKThs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781303356; c=relaxed/simple;
	bh=PzRtwC/5499sW6Ew6S904I5LnXOBx/emu64ZskSvzME=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QcssECS+WGNM+koOLEPblQBsghGYPx/22RDHK0z4whgZFVm0t6AgxJlAH3x9ffxBAHZKvxdu7a5Iu2gbBzdH4qLJPSOehhISPErxTQv6tBp9xDCoeH4l4fU63QT3WFPH9bmfSpckGK6DPDVHxEmK/zw+aQc5S1C6S/tfumKzvFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsIbXCwg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsIbXCwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C040C1F000E9;
	Fri, 12 Jun 2026 22:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781303354;
	bh=KUtf2JGJAGJlAopZynwDI7uK6KKHM1kTn46v3MzM1iY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZsIbXCwgx7G7dFzQi8nafEiiGDlAZ0CjsdmBOKRHkJHNqOD6/DRKmKeegvYveFxr2
	 QvJ+mwq0Nly0y+SUo29aIdvDELciJdU60H05l7vcTJXkcQ2RwVhSobpzsMadSgE+qf
	 28fmyvaWZH+tPziCRZCluGrhbI0fFFVxSMjSNgRejSNQA9jXcThaS3DdL7PxfNougn
	 55kczT26YetukLyReBZrhYZQSh1hqpGynRLMtnxHQLt6eeBxJ3fpEgTda45ntzyMzi
	 f1ao129gORKMIlt87YPSwcYzFQ72ORBk/QkjmsS4YNfDalqCHX65oCFO2QT8AFW4hj
	 C2p+gwSwUPteA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/13] scsi: fnic: Handle NVMe LS frames in FDLS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-9-kartilak@cisco.com>
References: <20260612180918.8554-9-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 22:29:14 +0000
Message-Id: <20260612222914.C040C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] IRQ state corruption due to locking inconsistency with local flags=
 vs struct member
- [High] State corruption and Use-After-Free of OXIDs due to incomplete poo=
l reset
- [High] ABBA deadlock involving `timer_delete_sync()` and `fnic->fnic_lock`
- [Medium] Dead code in defensive check causing NULL pointer dereference
--

commit fab490a6f935460a8594dd821b190a2f2d7c7b5c
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Handle NVMe LS frames in FDLS

Classify NVMe LS request OXIDs, route NVMe LS responses and ABTS frames
through the FCS receive path, and reset NVMe exchanges when FDLS tears
down target ports. Extend FDLS link-down and frame-processing paths so
NVMe LS traffic follows the same discovery and cleanup state machine as
FCP traffic.

> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -387,10 +387,16 @@ static bool fdls_is_oxid_tgt_req(uint16_t oxid)
>  	return true;
>  }
> =20
> +static inline bool fdls_is_oxid_nvme_req(uint16_t oxid)
> +{
> +	return FNIC_FRAME_TYPE(oxid) =3D=3D FNIC_FRAME_TYPE_NVME_LS;
> +}
> +
>  static void fdls_reset_oxid_pool(struct fnic_iport_s *iport)
>  {
>  	struct fnic_oxid_pool_s *oxid_pool =3D &iport->oxid_pool;
> =20
> +	bitmap_clear(oxid_pool->bitmap, 0, FNIC_OXID_POOL_SZ);
>  	oxid_pool->next_idx =3D 0;
>  }

[Severity: High]
Does this clear the bitmap without tearing down the background reclaim time=
rs?

If oxid_reclaim_work is still pending or the oxid_reclaim_list is not clear=
ed
when fdls_reset_oxid_pool() is called, the background reclaim task might run
after the link is reset.

If a new connection starts allocating OXIDs, could the pending reclaim task
blindly clear bits for newly allocated OXIDs? This might cause those active
OXIDs to be marked free again, leading to double-allocation and session
corruption.

[ ... ]

> @@ -1288,6 +1294,10 @@ bool fdls_delete_tport(struct fnic_iport_s *iport,=
 struct fnic_tport_s *tport)
>  		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
>  		fnic_rport_exch_reset(iport->fnic, tport->fcid);
>  		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
> +		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +		nvfnic_exch_reset(iport, tport);
> +		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
>  	}

[Severity: High]
Can using the structure member fnic->lock_flags here instead of a local fla=
gs
variable corrupt the IRQ state?

If a caller (like nvfnic_remote_port_delete) acquires the lock using a local
flags variable, releasing and reacquiring it here with fnic->lock_flags will
restore a stale or uninitialized IRQ state instead of the actual state.
Could this prematurely re-enable interrupts and lead to an IRQ reentrancy
deadlock?

A similar lock mismatch appears to happen in nvfnic_process_ls_abts_rsp(),
which is called from fdls_tport_timer_callback() where the lock is acquired
with a local flags variable.

[ ... ]

> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
> @@ -313,8 +319,14 @@ void fnic_handle_frame(struct work_struct *work)
>  		fchdr_offset =3D (cur_frame->rx_ethhdr_stripped) ?
>  			0 : FNIC_ETH_FCOE_HDRS_OFFSET;
> =20
> -		fnic_fdls_recv_frame(&fnic->iport, cur_frame->fp,
> -							 cur_frame->frame_len, fchdr_offset);
> +		fchdr =3D (struct fc_frame_header *)((u8 *)cur_frame->fp + fchdr_offse=
t);
> +		if (IS_FNIC_NVME_INITIATOR(fnic) && fnic_is_nvme_frame(fchdr)) {
> +			nvfnic_ls_rsp_recv(&fnic->iport, fchdr,
> +					  cur_frame->frame_len - fchdr_offset);

[Severity: High]
Is there a risk of an ABBA deadlock occurring inside nvfnic_ls_rsp_recv()
when it calls timer_delete_sync()?

nvfnic_ls_rsp_recv() executes while holding fnic->fnic_lock and calls
timer_delete_sync(&nvfnic_ls_req->ls_req_timer).=20

Meanwhile, the timer callback nvfnic_ls_req_timeout() unconditionally acqui=
res
fnic->fnic_lock at its start via spin_lock_irqsave().

If the timer callback begins executing on another CPU right before
timer_delete_sync() is called, will it spin indefinitely waiting for
fnic_lock while timer_delete_sync() spins indefinitely waiting for the
timer callback to finish?

[ ... ]

> @@ -617,6 +629,9 @@ void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic=
_rq_buf *buf)
>  	void *rq_buf =3D buf->os_buf;
>  	struct fnic *fnic =3D vnic_dev_priv(rq->vdev);
> =20
> +	if (WARN_ON(!buf))
> +		return;
> +

[Severity: Medium]
Will this defensive check ever evaluate successfully if buf is NULL?

Because buf->os_buf is dereferenced on the first line of the function to
initialize rq_buf, a NULL buf will cause a crash before this WARN_ON check
is reached. Should the check be moved above the dereference?

[ ... ]

> @@ -917,6 +933,9 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic=
_wq_buf *buf)
>  	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
>  			 DMA_TO_DEVICE);
> =20
> +	if (WARN_ON(!buf))
> +		return;
> +
>  	mempool_free(buf->os_buf, fnic->frame_pool);

[Severity: Medium]
Similarly, will this check prevent a crash if buf is NULL?

By the time execution reaches this WARN_ON, buf->dma_addr and buf->len have
already been dereferenced in the dma_unmap_single() call above it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D8
