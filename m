Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2698380FE6
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277982; cv=none; b=NVBm0YfDCEaQKYeG6LMuUH0klJWH5vy7QAJGr03wkEKq3LFpp0rOBbqXiXX+ZqaSo4w8NNpPOR2MwAEJc9H9GT6lCm9icKsO1LFq5JmGHBETK6EFG7k0kvmcqJe90d6o0nyrG1+Qq2SKkFSJGkYysTeNic5m583mdIAxjPpZheg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277982; c=relaxed/simple;
	bh=6fbWd2k8xoONYDhHT72z+pjrn/xScTOYvBrtIHit/tA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bwrZ3w//7w1VWcEX3XVkGNUaLkCryeiE/PKL1nw9mYEq4L3BQN8fLqGhXowvcOGQxofCTNmJofgGeDtsLH4IfCxN7WDOYmzzo1t0SvCzirOPJQRPjUP/MHyCAQ9FS1kyiPY0e2febOA40lPd1WmQRAta81/R9AUcnjGQIeUHf9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKR+YrSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKR+YrSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707741F000E9;
	Wed, 24 Jun 2026 05:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277980;
	bh=QJaYJe9iS//bFkyBVgN+uIBX0ErW+xDumojEMitUwm0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dKR+YrSespoPnfGAotONcv6wMA53KA7flCaeuCQNffKuffz0G6WV5l9ncHU5J/eb4
	 Ikx4cbJGaGX3vISf3GO5i52mzQM5T6C25k1dRcQ+q//P6H+2EqA5hEtqoor+5BH1Qx
	 dMkWGLtzggKIbRl9KqX1iHSzfuUdrnjK0z5/RxyRZLPHJyJr9h6un2VDVervMjgMFH
	 HO5SfDbZuUYjSGTogJ1IeF23ALQfRjvXQ3xUyasp/NSR67Xcn1XVp6TGQVmL3xT1EN
	 x89Rd8lZEAy4dxA1aZ6bFHiX1HJ0yOkqUZ8cYaoE85q/9ZY/Oqj9AF+STap3Hj5upx
	 6ZGxcQOmkjlnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/13] scsi: fnic: Handle NVMe LS frames in FDLS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-9-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-9-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:13:00 +0000
Message-Id: <20260624051300.707741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Using non-synchronous cancel_delayed_work() in fdls_reset_oxid_poo=
l() allows concurrent lockless execution of the retry worker, leading to st=
ate corruption and OXID double-allocations.
- [High] Mismatched lock/unlock flags cause IRQ state corruption when acqui=
ring fnic_lock with local flags and releasing it with the stale global fnic=
->lock_flags.
- [High] Using non-sync timer_delete() in nvfnic_ls_rsp_recv() causes a UAF=
 in the timer callback.

Pre-existing issues:
- [High] Dropping a lock inside list_for_each_entry_safe() allows concurren=
t deletion of the 'next' pointer.
- [High] Module unload/teardown sequence fails to synchronously cancel the =
oxid_pool delayed works, leading to a UAF crash.
--

commit 04dceb559b15b01cb194adfb5c26b4d828e90ace
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Handle NVMe LS frames in FDLS

Classify NVMe LS request OXIDs, route NVMe LS responses and ABTS frames
through the FCS receive path, and reset NVMe exchanges when FDLS tears
down target ports.

> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c

[ ... ]

> @@ -387,10 +387,25 @@ static bool fdls_is_oxid_tgt_req(uint16_t oxid)
> =20
>  static void fdls_reset_oxid_pool(struct fnic_iport_s *iport)
>  {
>  	struct fnic_oxid_pool_s *oxid_pool =3D &iport->oxid_pool;
> +	struct reclaim_entry_s *reclaim_entry, *next;
> =20
> +	cancel_delayed_work(&oxid_pool->oxid_reclaim_work);
> +	cancel_delayed_work(&oxid_pool->schedule_oxid_free_retry);
> +	list_for_each_entry_safe(reclaim_entry, next,
> +				 &oxid_pool->oxid_reclaim_list, links) {
> +		list_del(&reclaim_entry->links);
> +		kfree(reclaim_entry);
> +	}
> +	bitmap_clear(oxid_pool->pending_schedule_free, 0, FNIC_OXID_POOL_SZ);
> +	bitmap_clear(oxid_pool->bitmap, 0, FNIC_OXID_POOL_SZ);

[Severity: High]
Can this race with the lockless retry worker? fdls_reset_oxid_pool() uses
non-synchronous cancel_delayed_work() and immediately clears the bitmaps.

If fdls_schedule_oxid_free_retry_work() is traversing
pending_schedule_free locklessly on another CPU, could it read a set bit
just before the reset clears the bitmap, allocate memory, and block on
fnic_lock?

Once the reset finishes and unlocks, the worker might inject a stale
reclaim entry into the now empty list and schedule oxid_reclaim_work. When
the reclaim work fires, could it clear a bit in oxid_pool->bitmap that may
have been reallocated to a new active I/O request, causing an OXID
collision?

[Severity: High]
This is a pre-existing issue, but does the module unload/teardown sequence
fail to synchronously cancel these oxid_pool delayed works?

If fnic_remove() initiates driver teardown and frees the fnic struct without
calling cancel_delayed_work_sync(), flush_workqueue(fnic_event_queue) won't
synchronize them because they are queued on the system workqueue. Could
fdls_reclaim_oxid_handler() execute after the fnic structure is freed,
causing a use-after-free crash?

>  	oxid_pool->next_idx =3D 0;
>  }

[ ... ]

> @@ -1288,6 +1303,10 @@ bool fdls_delete_tport(struct fnic_iport_s *iport,=
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
This is a pre-existing issue, but does dropping fnic_lock here allow
concurrent modification of the tport_list?

When fnic_fdls_link_down() iterates over tport_list using
list_for_each_entry_safe(), it caches the next pointer. Since
fdls_delete_tport() unlocks the list briefly, could another context
process a concurrent event and delete the cached next entry?

If the cached next entry is freed while the lock is dropped, won't the
loop dereference a freed pointer when it continues?

[Severity: High]
Does this sequence corrupt the hardware IRQ masking state?

When callers like fdls_tport_timer_callback() or fnic_tport_event_handler()
acquire the fnic_lock using a local flags variable:

spin_lock_irqsave(&fnic->fnic_lock, flags);

and then invoke helpers like fdls_delete_tport() or
nvfnic_process_ls_abts_rsp() which temporarily drop and reacquire the lock
using the struct member fnic->lock_flags:

spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);

Because fnic->lock_flags was never initialized by the original caller, does
it restore an arbitrary stale IRQ state? Reacquiring the lock then overwrit=
es
fnic->lock_flags, causing the caller to unlock with the original local flags
and severely corrupt the IRQ state.

[ ... ]

> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c

[ ... ]

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
Does calling nvfnic_ls_rsp_recv() here introduce a use-after-free risk
in its timer callback?

Inside nvfnic_ls_rsp_recv(), it executes with fnic_lock held and invokes
timer_delete(&nvfnic_ls_req->ls_req_timer) without synchronization. If the
timer callback nvfnic_ls_req_timeout() is concurrently executing on another
CPU, it will spin-wait on fnic_lock.

nvfnic_ls_rsp_recv() then drops the lock and calls lsreq->done(), which
commonly causes the transport layer to free the request and its private
payload. Once the lock is dropped, will the spinning timer callback unblock,
acquire the lock, and inspect the now-freed nvfnic_ls_req memory?

> +		} else {
> +			fnic_fdls_recv_frame(&fnic->iport, cur_frame->fp,
> +					     cur_frame->frame_len, fchdr_offset);
> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D8
