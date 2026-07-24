Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36318418A4B
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917042; cv=none; b=TmIBCYLoqqxcOHxGdRBPiR4ZMjtUYb793QD3KYMNCR5/vbr55YMP64L4m2nyi5Kl0zscczwlj+zxE4tywsxOVXwRRCfSQ6AFcyWCuGE881XV4c82qmbvPVmtdpaXw4nvabVN5uvzFsc/s49neYxk09L4R8PmnSVGi8Zn7eBkEq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917042; c=relaxed/simple;
	bh=FiwHdLRNtNzVLC9jj29vzkeVMH4Sf4U286HpxB7hZGw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MoxhPTeX3Zh9ZlmV239S1l2ADr8A/rFhgM+DqMVr+jUVzqrBWy0aXHJDPhcqmOyu0TRDbB55C5qcgXX135IwftSNFay0O3+cmoc5xzlIw1LIe42MA4+Iz5eVKQVkPI2zMiqrVkroUpLPivA7Yyj/YgaZoduMfDSabbbS+kGPh1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKl7RnOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKl7RnOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A487C1F000E9;
	Fri, 24 Jul 2026 18:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784917039;
	bh=hFR1lGjYzHsg1ffri91s9bY+BjOYwob25DxXZhzVetw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZKl7RnOLvk1IrhNyZpdAhXWUI0eHaJ2+JPX4nl/FZrskNNWm2O3lSQSYKS3b5sBKm
	 3gd4W+mhTMuO/GF4Rkksdv36WBQcz+ETFezcJ2iW/GntZq9ZCA79vELc8grjaDpeyn
	 i/mEJx0pTvcwbw4+dB2GKusDV50X8Y9fW97YQReQocgqFAncb4RbVn/CYqKe9At8Xn
	 m/HpyoTARQNUoqfhJU1Ac9xetXegiipffi/ArjLuAmVwvhUK5cE5BLkkeyKrBiV/v0
	 mh+K8lkXFXdObASEawhQ0dLQMVhIMCBrsDu8+Bwmgaz2RlTbMgHqOvzX0B0AT+f2yW
	 1FnJr0VCyWXZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/13] scsi: fnic: Handle NVMe LS frames in FDLS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-9-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-9-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:17:19 +0000
Message-Id: <20260724181719.A487C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Mismatched lock flags when temporarily dropping `fnic->fnic_lock` =
corrupt the CPU interrupt state.

Pre-existing issues:
- [High] Mempool-allocated FC frames are permanently leaked when hardware t=
ransmission fails.
- [High] Dropping a spinlock during `list_for_each_entry_safe` iteration al=
lows concurrent list modifications, leading to use-after-free on loop resum=
ption.
- [High] Missing synchronous cancellation of delayed works `oxid_reclaim_wo=
rk` and `schedule_oxid_free_retry` causes Use-After-Free during module unlo=
ad.
--

--- Patch [8]: [PATCH v6 08/13] scsi: fnic: Handle NVMe LS frames in FDLS -=
--
commit 1f929f12db7e96d3eff12397152cd2a0b81d2192
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Handle NVMe LS frames in FDLS

Classify NVMe LS request OXIDs, route NVMe LS responses and ABTS frames
through the FCS receive path, and reset NVMe exchanges when FDLS tears
down target ports.

Extend FDLS link-down and frame-processing paths so NVMe LS traffic
follows the same discovery and cleanup state machine as FCP traffic.

> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index e03256183ac63..30d9bcd3795f9 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
[ ... ]
> @@ -387,10 +394,25 @@ static bool fdls_is_oxid_tgt_req(uint16_t oxid)
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
> +	struct reclaim_entry_s *reclaim_entry, *next;
> =20
> +	cancel_delayed_work(&oxid_pool->oxid_reclaim_work);
> +	cancel_delayed_work(&oxid_pool->schedule_oxid_free_retry);

[Severity: High]
This is a pre-existing issue, but does this code leave active delayed=20
works running after module unload?

During module unload, the driver needs to synchronously cancel these works
to prevent them from executing after the underlying fnic structure is freed.

Since this only attempts asynchronous cancellation via cancel_delayed_work(=
),
if the worker is already running or concurrently dispatched, it will contin=
ue
executing after kfree(fnic) is called in the module teardown.

Could this lead to a use-after-free when dereferencing oxid_pool? Should
cancel_delayed_work_sync() be used instead?

> +	list_for_each_entry_safe(reclaim_entry, next,
> +				 &oxid_pool->oxid_reclaim_list, links) {
> +		list_del(&reclaim_entry->links);
> +		kfree(reclaim_entry);
> +	}
> +	bitmap_clear(oxid_pool->pending_schedule_free, 0, FNIC_OXID_POOL_SZ);
> +	bitmap_clear(oxid_pool->bitmap, 0, FNIC_OXID_POOL_SZ);
>  	oxid_pool->next_idx =3D 0;
>  }
[ ... ]
> @@ -1288,6 +1310,10 @@ bool fdls_delete_tport(struct fnic_iport_s *iport,=
 struct fnic_tport_s *tport)
>  		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
>  		fnic_rport_exch_reset(iport->fnic, tport->fcid);
>  		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);

[Severity: High]
This is a pre-existing issue, but can this lock drop cause a use-after-free
during list traversal?

When iterating over iport->tport_list or fnic->tport_event_list using
list_for_each_entry_safe(), the macro caches the next element at the start=
=20
of the loop.=20

However, dropping fnic_lock here in fdls_delete_tport() allows concurrent
threads to acquire the lock and modify or free the cached next element.

When the lock is reacquired and the loop continues, will evaluating the=20
loop condition access a freed next pointer?

> +	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
> +		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);

[Severity: High]
Can this sequence corrupt the CPU interrupt state?=20

Callers like fdls_tport_timer_callback() acquire the lock using a local=20
flags variable:

    spin_lock_irqsave(&fnic->fnic_lock, flags);

However, when this NVMe block temporarily drops the lock, it uses the=20
shared struct member fnic->lock_flags:

    spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);

Because fnic->lock_flags was never updated by the caller, doesn't this=20
restore a stale, unrelated, or potentially garbage interrupt state?

> +		nvfnic_exch_reset(iport, tport);
> +		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
>  	}
> =20
>  	if ((tport->flags & FNIC_FDLS_SCSI_REGISTERED) ||
[ ... ]
> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> index 94b7c150c08c2..b00672ef8b000 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
[ ... ]
> @@ -651,7 +667,7 @@ static int fnic_send_frame(struct fnic *fnic, void *f=
rame, int frame_len)
>  		dma_unmap_single(&fnic->pdev->dev, pa, frame_len, DMA_TO_DEVICE);
>  		FNIC_FCS_DBG(KERN_INFO, fnic,
>  					 "vnic work queue descriptor is not available");
> -		ret =3D -1;
> +		ret =3D -ENXIO;
>  		goto fnic_send_frame_end;
>  	}
> =20

[Severity: High]
This is a pre-existing issue, but does this error path leak the=20
mempool-allocated FC frame?

When fnic_send_frame() encounters a full hardware TX queue, it unmaps the=20
DMA address and exits via fnic_send_frame_end:

    dma_unmap_single(&fnic->pdev->dev, pa, frame_len, DMA_TO_DEVICE);
    ret =3D -ENXIO;
    goto fnic_send_frame_end;

However, it fails to free the frame back to fnic->frame_pool.

Since callers like fdls_send_fcoe_frame() systematically ignore the return=
=20
value, won't this frame be permanently leaked?=20

Under network congestion, could these leaks rapidly exhaust the mempool and=
=20
prevent the driver from processing discoveries or recovering?

> @@ -685,7 +701,6 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *frame, =
int frame_size,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D8
