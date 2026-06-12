Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F89376A14
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 21:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781301554; cv=none; b=DmjeQCUdcdrjG+mMRnzmrK2jJ37I37HJ1ShmH1VMEkIWPCUUrBvwAJaqjqOXsuc3t6ctUkduSxQjI7IbC69czRTN5cGHzYTzyDGhOV16i/prckJ44qqquz/Ls03wlALPnOsCZ11fOpiwjgudn9QS5ndA/ngIF/Zbbc5W8WPL3Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781301554; c=relaxed/simple;
	bh=AJl5iunmYpIh9pzUxeWFMuIZ9C53uWqL4M+JfvIA3Co=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bXO7qr3VrWvYkyotMTEuCrX6TxbLKPrKZzcWjSuint+wj04iDTsV3qdSzCnSO5qlrelu+25k+NyElCmcdlQB3y9TFlnbWQxYuHFKQltWPH4g4HOZ+TFKaZRfM2+uD3CK0y6uXIvcZGGogfoePRX+TcpbErUN6a22A/G2x+WMKgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iwljQhXw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iwljQhXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0A61F000E9;
	Fri, 12 Jun 2026 21:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781301552;
	bh=wm2X4zBJ5S0EWN2OwINYQ+mGTL+gzBskIfXWqHDk8yI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iwljQhXwebbJDJlfQeyx2Y6fVp/JA/48ybf195hbK/jPzcEf2mVQ9ecnJ0vF6JK6z
	 kUo1bjaRvmTbw+02GvkORoMRzrxcBM4o84bjIsXaKLjoXuh80XrDIjqIeqolh8eve8
	 xMMdjY6VheBmTz3i6yHhsH7B/HKCycrh6NRYdDvyi3N7r92ztomZe6A2mJbpmFuhCI
	 CZwcUdqZpVij7NJyx+5K2iPVUOklVtoGW26wHPKfHMblf4dYPgJXtG1mtGAZ7xcSsv
	 DpMYEgP2KaqODyjxoh32BaSZNpD22ifC6kdFoxiHOiF4e26WCeCgc511aP8mDm9mIg
	 4U44UyvXslZow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/13] scsi: fnic: Add the NVMe/FC transport path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-7-kartilak@cisco.com>
References: <20260612180918.8554-7-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 21:59:11 +0000
Message-Id: <20260612215912.7D0A61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 10 potential issue=
(s) to consider:

New issues:
- [High] Calling timer_delete_sync() while holding fnic_lock causes an AB-B=
A deadlock.
- [High] Dropping the spinlock inside list_for_each_entry_safe() exposes th=
e cached 'next' pointer to concurrent deletion, leading to Use-After-Free.
- [High] Lockless access to io_req_table elements in _terminate_tport_ios()=
 races with IO completions, causing Use-After-Free.
- [High] Unhandled NVMe abort failures permanently leak fnic_io_req and han=
g the NVMe core.
- [High] Freeing tag_map and io_req_table in nvfnic_nvme_unload before disa=
bling interrupts causes Use-After-Free on late IO completions.
- [High] Early return on nvme_fc_unregister_localport failure in nvfnic_nvm=
e_unload leaks memory and guarantees Use-After-Free of the fnic structure.
- [Medium] Unused memory pool io_req_pool is leaked on module unload for NV=
Me initiators.
- [Medium] The fnic_tport_s structure memory is leaked if NVMe remote port =
unregistration fails or times out.
- [Medium] Valid DMA mappings at address 0 will not be unmapped, causing an=
 IOMMU resource leak.

Pre-existing issues:
- [Critical] Using a shared struct member (fnic->lock_flags) with spin_lock=
_irqsave() corrupts CPU IRQ states.
--

commit bbeed4ae296bbd0a10dc168bc3c202bd9dce7297
Author: Karan Tilak Kumar <kartilak@cisco.com>
Subject: scsi: fnic: Add the NVMe/FC transport path

This patch adds the NVMe/FC transport path to the fnic driver. It includes
NVMe local-port and remote-port registration, I/O submission, DMA mapping,
tag management, completion, abort handling, and cleanup logic.

Link: https://lore.kernel.org/oe-kbuild-all/202605280430.wTYAqI3A-lkp@intel=
.com/
Link: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@intel=
.com/
Link: https://lore.kernel.org/oe-kbuild-all/202605280519.Jd4fmgAZ-lkp@intel=
.com/

> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c
> [ ... ]
> @@ -44,6 +44,8 @@ int nvfnic_dma_map_sgl(struct fnic *fnic, struct fnic_i=
o_req *io_req,
>  void nvfnic_dma_unmap_sgl(struct fnic *fnic, struct fnic_io_req *io_req)
>  {
>  	if (io_req->sgl_list_pa)
>  		dma_unmap_single(&fnic->pdev->dev, io_req->sgl_list_pa,
>  				 sizeof(io_req->sgl_list[0]) * io_req->sgl_cnt,
>  				 DMA_TO_DEVICE);
>  }

[Severity: Medium]
Could this leak IOMMU mappings if the DMA mapping happens to be at address =
0?
On many architectures, 0 is a perfectly valid DMA address, so evaluating
it directly for truthiness might falsely skip unmapping a legitimate mappin=
g.

> [ ... ]
> @@ -288,6 +290,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic =
*fnic,
>  			    desc->hdr.type, desc->hdr.status, desc->hdr._resvd,
>  			    id);
>  		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
>  		return;
>  	}
>  	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);

[Severity: Critical]
This is a pre-existing issue, but does using a shared structure member
(fnic->lock_flags) for saving IRQ state corrupt CPU IRQ states?=20

When spin_lock_irqsave() is called, it saves the local CPU's IRQ state into
the provided variable. Since multiple CPUs could hit this concurrently and
overwrite the shared lock_flags, unlocking may restore corrupted state
and cause hard lockups.

> [ ... ]
> @@ -530,6 +533,7 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic =
*fnic,
>  		io_req->fcp_req->status =3D NVME_SC_ABORT_REQ;
> =20
>  		nvfnic_release_nvme_ioreq_buf(iport, io_req);
>  		if (io_req->done)
>  			io_req->done(io_req);
>  		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
>  		return;
>  	}
>  	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
>  }

[Severity: High]
If the abort command fails (e.g., returning FCPIO_TIMEOUT), does this path
accidentally skip calling io_req->done()? It looks like the function just
returns without it, meaning the midlayer is never notified of the completio=
n,
which could permanently hang the block layer queue and leak the IO request
buffers.

> [ ... ]
> @@ -582,6 +586,7 @@ void nvfnic_cleanup_tport_io(struct fnic *fnic, struc=
t fnic_tport_s *tport)
> =20
>  	spin_lock_irqsave(&fnic->fnic_lock, flags);
>  	list_for_each_entry_safe(nvfnic_ls_req, next,
>  				 &(tport->ls_req_list), list) {
>  		lsreq =3D nvfnic_ls_req->ls_req;
>  		if (!lsreq || (lsreq->private =3D=3D NULL)) {
>  			FNIC_NVME_DBG(KERN_INFO, fnic,
>  				"fnic_cleanup_tport_io lsreq NULL\n");
>  			continue;
>  		}
>  		list_del(&nvfnic_ls_req->list);
>  		lsreq->private =3D NULL;
>  		oxid =3D nvfnic_ls_req->oxid;
>  		fdls_free_oxid(&fnic->iport, oxid, &nvfnic_ls_req->oxid);
>  		nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_COMPLETE;
>  		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  		timer_delete_sync(&nvfnic_ls_req->ls_req_timer);
>  		lsreq->done(lsreq, -ENXIO);
>  		spin_lock_irqsave(&fnic->fnic_lock, flags);
>  	}

[Severity: High]
Can dropping fnic_lock inside the list_for_each_entry_safe() loop cause a
use-after-free?=20

The list_for_each_entry_safe() macro caches the 'next' pointer before
executing the loop body. Because the lock is temporarily dropped, a
concurrent timeout or completion handler could execute and free that cached
'next' element before the loop reacquires the lock and advances to it.

> [ ... ]
> @@ -647,6 +652,7 @@ bool _terminate_tport_ios(struct sbitmap *map, unsign=
ed int tag,
>  	struct fnic *fnic =3D iport->fnic;
>  	struct fnic_io_req *io_req;
> =20
>  	io_req =3D fnic->sw_copy_wq[0].io_req_table[tag];
>  	if (!io_req)
>  		return true;
> =20
>  	if (io_req->tport !=3D tport)
>  		return true;

[Severity: High]
Is it safe to access io_req_table here without holding fnic_lock? An IO
completion could concurrently execute nvfnic_fcpio_cmpl(), complete the IO,
and hand the memory back to the block layer where it gets freed. We might
dereference a freed io_req or io_req->tport during this check.

> [ ... ]
> @@ -704,6 +710,7 @@ void nvfnic_nvme_unload(struct fnic *fnic)
>  	fnic_flush_tport_event_list(fnic);
>  	fnic_delete_fcp_tports(fnic);
> =20
>  	if (iport->flags & FNIC_LPORT_NVME_REGISTERED) {
>  		ret =3D nvme_fc_unregister_localport(fnic->iport.nv_lport);
>  		if (ret) {
>  			FNIC_NVME_DBG(KERN_ERR, fnic,
>  				"Unregister nvme localport failed: %d\n", ret);
>  			spin_lock_irqsave(&fnic->fnic_lock, flags);
>  			fnic->nvme_lport_unreg_done =3D NULL;
>  			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  			return;
>  		}

[Severity: High]
If nvme_fc_unregister_localport() fails, does returning early here cause a
use-after-free?=20

Returning early skips the rest of the local teardown and yields control back
to fnic_remove(), which proceeds to free the fnic structure entirely. Becau=
se
the local port remains registered, the NVMe FC transport could continue mak=
ing
callbacks to the freed fnic structure.

> [ ... ]
> @@ -735,6 +742,7 @@ void nvfnic_nvme_unload(struct fnic *fnic)
>  	fnic->nvme_lport_unreg_done =3D NULL;
>  	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> =20
>  	nvfnic_flush_nvme_io_list(fnic);
>  	sbitmap_free(&fnic->nvfnic_tag_map);
>  	for (hwq =3D 0; hwq < fnic->wq_copy_count; hwq++)
>  		kfree(fnic->sw_copy_wq[hwq].io_req_table);
>  }

[Severity: High]
Does freeing nvfnic_tag_map and the io_req_table array here cause a
use-after-free if a late completion interrupt fires? Hardware interrupts and
completion queues aren't disabled until fnic_cleanup() is called later in t=
he
removal process, so an active ISR might still try to access these structure=
s.

[Severity: Medium]
Also, does this function forget to destroy fnic->io_req_pool? It appears
fnic_scsi_unload_cleanup() destroys it for FCP initiators, but NVMe-only
initiators might skip that step and leak the pool entirely on module unload.

> [ ... ]
> @@ -826,6 +834,7 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
>  	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_COMPLETE;
> =20
>  	list_del_init(&nvfnic_ls_req->list);
>  	lsreq->private =3D NULL;
>  	fdls_free_oxid(iport, oxid, &nvfnic_ls_req->oxid);
>  	timer_delete_sync(&nvfnic_ls_req->ls_req_timer);

[Severity: High]
Can calling timer_delete_sync() while holding fnic_lock cause an AB-BA
deadlock?=20

timer_delete_sync() will spin waiting for the timer callback to finish, but=
 if
the callback (nvfnic_ls_req_timeout()) is already executing concurrently on
another CPU, it will attempt to acquire fnic_lock and spin indefinitely.

> [ ... ]
> @@ -1164,6 +1173,7 @@ void nvfnic_delete_tport(struct fnic_iport_s *iport,
>  	tport->flags |=3D FNIC_FDLS_TPORT_DELETED;
>  	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  	ret =3D nvme_fc_unregister_remoteport(tport->nv_rport);
>  	if (ret) {
>  		FNIC_NVME_DBG(KERN_ERR, fnic,
>  			    "tport: 0x%x unregister failed %d\n",
>  			    tport->fcid, ret);
>  		spin_lock_irqsave(&fnic->fnic_lock, flags);
>  		tport->tport_del_done =3D NULL;
>  		return;
>  	}

[Severity: Medium]
Are we leaking the tport structure on failure here? If=20
nvme_fc_unregister_remoteport() returns an error, the function returns early
without freeing tport.

> [ ... ]
> @@ -1186,6 +1196,7 @@ void nvfnic_delete_tport(struct fnic_iport_s *iport,
>  		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  		nvfnic_cleanup_tport_io(fnic, tport);
>  		spin_lock_irqsave(&fnic->fnic_lock, flags);
>  		tport->flags &=3D ~FNIC_FDLS_NVME_TPORT_CLEANUP_PENDING;
>  	} else {
>  		while (!(tport->flags & FNIC_TPORT_CAN_BE_FREED) && (count < 8)) {
>  			count++;

[Severity: Medium]
Similarly, if wait_for_completion_timeout() times out, does the !time_remain
branch bypass the kfree(tport) call that happens in the else block, leaking
the memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D6
