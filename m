Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57C136A367
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277976; cv=none; b=rGe1TLOllNRx4TsIWy9ZxzE6d/j2dT6CcRkhL/M5m54Q3dLF4suE8yOwHN/pttI8VMuT+hAAtLzIRcPw6OCLXxyT5mjCbzVaflHeDFT8XevcQlhqRqq68FK8E5W9LZAm31TLYQXu5AKxDJ+WgCiOy1ejTyDZ6Qj9a7qsVkRmFF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277976; c=relaxed/simple;
	bh=0EiH4uLxIiIUL3rWdVg4y0UmmCed8eAbYZhQU3Q/ZDI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CGCHwtXE0CqhKBUhwibNES2JFGw8pXE+Puvc7gblYHzTq3huQ9Tjt/TqJI5j/fbkcYAKOURg0gdQf5Z26ff5YyKz+0onB41jAT+q7k5ZFpw9U8x2KWTbNFP7XV/Pi9kvGBcJH3raXvVhwjkvXYOiCk293Q1o8ZdO3gmeinFrzvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3hiT82G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3hiT82G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19751F000E9;
	Wed, 24 Jun 2026 05:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277974;
	bh=7HWuha4xXniyfH5D9qO34R8gd1ecANEx7aciXY04wqw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T3hiT82GXL49MnUwj2MnlgO8j6Bj0VDKjBQf37Q8SizlS2EDbBL+2jgv2P62CzIoQ
	 8rLSHI5/jCgBWHEA5eBcZ7Fnu7fxJbQv27vfNUhwpcXelDjgvMbeQ69vMJ5OA0eCjF
	 /cAx3h8CJF4SdnZQwx4YWfMufavyx+zB7dWUONCaroj76ffEZVDnC0i57vXVy5RqkP
	 CF7UTkXOLFESx6ERGun7AxxsGCctoZX99BCEmNniyh42QzI25gNow7223qKz6l2KNw
	 k0BabwRKScD+QEgYRhc42Ky/0rngVmPrQmRWV6MtprjDm1LW5/+F9QvxhllJQIFhSO
	 SDDYX1iBHNpNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/13] scsi: fnic: Add the NVMe/FC transport path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-7-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-7-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:12:54 +0000
Message-Id: <20260624051254.B19751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 11 potential issue=
(s) to consider:

New issues:
- [Critical] Premature freeing of I/O tags during ABTS completion leads to =
tag reuse and data corruption.
- [High] Non-sync timer cancel in nvfnic_ls_rsp_recv leads to Use-After-Fre=
e of lsreq and fnic structures.
- [High] Asynchronous deletion timeouts cause Use-After-Free of tport and l=
port objects.
- [High] Missing cancellation of nvme_io_cmpl_work allows a work item to ex=
ecute after the fnic structure is freed.
- [High] Leaked LS requests and active timers when remote port unregistrati=
on fails.
- [High] A failed abort request combined with a concurrent completion cause=
s an I/O to hang forever.
- [High] Concurrent I/O completion causes Use-After-Free of fcp_req when _t=
erminate_tport_ios drops the lock.
- [High] Accessing lsreq->private after dropping the lock in nvfnic_ls_req_=
abort causes Use-After-Free.
- [Medium] Uninitialized sgl_mapped state leads to unbalanced dma_unmap_sin=
gle calls for zero-length NVMe requests.
- [Medium] Permanent reference leak of the PCI device (pdev->dev) during lo=
calport registration.

Pre-existing issues:
- [High] Dropping the spinlock inside list_for_each_entry_safe() permits co=
ncurrent list corruption.
--

commit 78a3171c3dafe1bc2912707cce47ec94e43860f3
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Add the NVMe/FC transport path

This patch introduces the NVMe/FC transport path for the fnic driver.
It includes local and remote port registration, I/O submission, tag
management, abort handling, and cleanup logic.

Closes: https://lore.kernel.org/oe-kbuild-all/202605280430.wTYAqI3A-lkp@int=
el.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@int=
el.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202605280519.Jd4fmgAZ-lkp@int=
el.com/

> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 0d7828be244da..df8c8ebbc32b9 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
[ ... ]
> @@ -1215,6 +1286,11 @@ static void fnic_remove(struct pci_dev *pdev)
>  	 */
>  	fnic_cleanup(fnic);
> =20
> +	if (IS_FNIC_NVME_INITIATOR(fnic)) {
> +		sbitmap_free(&fnic->nvfnic_tag_map);
> +		fnic_free_ioreq_tables_mq(fnic);
> +	}
> +
>  	spin_lock_irqsave(&fnic_list_lock, flags);
>  	list_del(&fnic->list);
>  	spin_unlock_irqrestore(&fnic_list_lock, flags);

[Severity: High]
Does this code leave work items running after the fnic structure is freed?

Looking at fnic_remove(), we call fnic_cleanup(fnic) which drains the hardw=
are
completion queues, potentially finding completions and queueing work items =
via
queue_work(fnic_cmpl_queue, &fnic->nvme_io_cmpl_work).

Since there is no cancel_work_sync() before kfree(fnic), could a re-queued
work item execute after the memory is freed and cause a use-after-free cras=
h?

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> new file mode 100644
> index 0000000000000..8374464e4fcc8
> --- /dev/null
> +++ b/drivers/scsi/fnic/fnic_nvme.c
[ ... ]
> +void nvfnic_dma_unmap_sgl(struct fnic *fnic, struct fnic_io_req *io_req)
> +{
> +	if (io_req->sgl_mapped) {
> +		dma_unmap_single(&fnic->pdev->dev, io_req->sgl_list_pa,
> +				 sizeof(io_req->sgl_list[0]) * io_req->sgl_cnt,
> +				 DMA_TO_DEVICE);
> +		io_req->sgl_mapped =3D 0;
> +		io_req->sgl_list_pa =3D 0;
> +	}
> +}

[Severity: Medium]
Could this lead to an unbalanced DMA unmap?

In nvfnic_fcpio_send(), io_req->sgl_mapped is not explicitly zeroed during
initialization:

nvfnic_fcpio_send() {
    ...
    io_req->sgl_list_pa =3D 0;
    io_req->wq =3D hw_queue_handle;
    ...
}

If a previous I/O set sgl_mapped to 1, and the current I/O has zero length,
the mapping step is skipped but sgl_mapped might still be 1. Will this cause
nvfnic_dma_unmap_sgl() to unmap a 0 address with 0 length?

[ ... ]
> +void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
> +				       struct fcpio_fw_req *desc)
> +{
> +	u8 type;
> +	u8 hdr_status;
> +	struct fcpio_tag ftag;
> +	u32 id;
> +	struct fnic_io_req *io_req;
[ ... ]
> +	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &ftag);
> +	fcpio_tag_id_dec(&ftag, &id);
> +	tag =3D id & FNIC_TAG_MASK;
> +
> +	if (tag >=3D fnic->fnic_max_tag_id) {
> +		FNIC_NVME_DBG(KERN_ERR, fnic,
> +			    "Tag out of range tag: 0x%x hdr status: %s\n", tag,
> +			    fnic_fcpio_status_to_str(hdr_status));
> +		return;
> +	}
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +
> +	io_req =3D nvfnic_find_io_req_by_tag(fnic, tag);
> +
> +	WARN_ON_ONCE(!io_req);
> +	if (!io_req) {
[ ... ]
> +	/* firmware completed the io */
> +	io_req->io_completed =3D 1;
> +	if (io_req->cmd_state =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> +		/*
> +		 * set the FNIC_IO_DONE so that this doesn't get
> +		 * flagged as 'out of order' if it was not aborted
> +		 */
> +		io_req->cmd_flags |=3D FNIC_IO_DONE;
> +		io_req->cmd_flags |=3D FNIC_IO_ABTS_PENDING;
> +		if (hdr_status =3D=3D FCPIO_ABORTED)
> +			io_req->cmd_flags |=3D FNIC_IO_ABORTED;
> +		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +
> +		FNIC_NVME_DBG(KERN_INFO, fnic,
> +			      "icmnd abts hdr:%d %s tag:0x%x io:%p",
> +			      hdr_status, fnic_fcpio_status_to_str(hdr_status),
> +			      id, io_req);
> +		return;
> +	}

[Severity: High]
Could an I/O hang indefinitely here if the abort request fails to queue?

When aborting an I/O, nvfnic_fcpio_abort() sets the state to
FNIC_IOREQ_ABTS_PENDING and drops the lock. If a hardware completion arrives
during this window, nvfnic_fcpio_nvme_fast_cmpl_handler() observes
ABTS_PENDING and intentionally drops the completion.

If the subsequent nvfnic_queue_abort_io_req() call fails, the state is
reverted back to FNIC_IOREQ_CMD_PENDING. Because the completion was
permanently discarded and the hardware was not told to abort, does this
leave the I/O hanging forever?

[ ... ]
> +void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
> +				       struct fcpio_fw_req *desc)
> +{
> +	u8 type;
> +	u8 hdr_status;
[ ... ]
> +	/* If the status is IO not found consider it as success.
> +	 * NVME sends abort even if rport is down in which case
> +	 * we will get FCPIO_TIMEOUT. Consider this as success.
> +	 */
> +	if ((hdr_status =3D=3D FCPIO_IO_NOT_FOUND) ||
> +	    (hdr_status =3D=3D FCPIO_TIMEOUT) ||
> +	    (hdr_status =3D=3D FCPIO_ITMF_REJECTED))
> +		io_req->abts_state =3D FCPIO_SUCCESS;
> +
> +	io_req->cmd_flags |=3D FNIC_IO_ABT_TERM_DONE;
> +
> +
> +	io_req->fcp_req->transferred_length =3D 0;
> +	io_req->fcp_req->rcv_rsplen =3D 0;
> +	if (io_req->abts_state =3D=3D FCPIO_SUCCESS)
> +		io_req->fcp_req->status =3D NVME_SC_ABORT_REQ;
> +	else
> +		io_req->fcp_req->status =3D NVME_SC_INTERNAL;
> +
> +	nvfnic_release_nvme_ioreq_buf(iport, io_req);
> +	if (io_req->done)
> +		io_req->done(io_req);
> +	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +}

[Severity: Critical]
Does this allow a tag to be reused before the hardware has actually complet=
ed
the original request, potentially corrupting a new I/O?

When an ITMF (abort) completion times out (FCPIO_TIMEOUT), the tag is
forcefully freed via io_req->done() and can be reallocated to a new request.
Since the driver matches completions only by the tag without a generation
count, if the late completion for the original I/O arrives, will
nvfnic_fcpio_nvme_fast_cmpl_handler() match it to the new request and
prematurely complete it with stale data?

[ ... ]
> +bool _terminate_tport_ios(struct sbitmap *map, unsigned int tag,
> +				       void *data)
> +{
> +	struct fnic_tport_s *tport =3D data;
> +	struct fnic_iport_s *iport =3D tport->iport;
> +	struct fnic *fnic =3D iport->fnic;
> +	struct fnic_io_req *io_req;
> +	struct nvmefc_fcp_req *fcp_req =3D NULL;
> +	struct nvme_fc_local_port *lport =3D iport->nv_lport;
> +	struct nvme_fc_remote_port *rport =3D tport->nv_rport;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	io_req =3D fnic->sw_copy_wq[0].io_req_table[tag];
> +	if (!io_req) {
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		return true;
> +	}
> +
> +	if (io_req->tport !=3D tport) {
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		return true;
> +	}
> +
> +	FNIC_NVME_DBG(KERN_INFO, fnic,
> +		      "Terminate tag: 0x%x (tport fcid 0x%x)\n",
> +		      io_req->tag, io_req->tport->fcid);
> +	fcp_req =3D io_req->fcp_req;
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +	nvfnic_fcpio_abort(lport, rport, NULL, fcp_req);
> +	return true;
> +}

[Severity: High]
Can fcp_req be accessed after it has been freed?

Here, fcp_req is extracted from io_req under the lock. The lock is then dro=
pped
without modifying io_req->cmd_state. During this unlocked window, a concurr=
ent
hardware completion could run, process the I/O, invoke io_req->done(), and
return the request to the midlayer, which might free or reuse fcp_req.

When nvfnic_fcpio_abort() is subsequently called, could it dereference the
now-freed fcp_req structure?

[ ... ]
> +void nvfnic_nvme_zero_devloss_tports(struct fnic *fnic)
> +{
> +	struct fnic_tport_s *tport, *next;
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +	list_for_each_entry_safe(tport, next, &fnic->iport.tport_list, links) {
> +		if (tport->flags & FNIC_FDLS_NVME_REGISTERED) {
> +			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +			nvme_fc_set_remoteport_devloss(tport->nv_rport, 0);
> +			spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +		}
> +	}
> +	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +}

[Severity: High]
This is a pre-existing issue, but dropping the lock inside
list_for_each_entry_safe() allows concurrent list corruption.

list_for_each_entry_safe() protects against deletion of the *current* entry
by caching the 'next' pointer. However, while the fnic_lock is dropped,
concurrent threads can remove and free the cached 'next' entry from the lis=
t.

When the loop resumes and accesses 'next', does this result in a
use-after-free? This pattern also exists in fnic_delete_fcp_tports().

[ ... ]
> +void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
> +		struct fc_frame_header *fchdr, int len)
> +{
> +	uint8_t *fcid;
[ ... ]
> +	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_COMPLETE;
> +
> +	list_del_init(&nvfnic_ls_req->list);
> +	lsreq->private =3D NULL;
> +	fdls_free_oxid(iport, oxid, &nvfnic_ls_req->oxid);
> +	timer_delete(&nvfnic_ls_req->ls_req_timer);
> +
> +	if (status =3D=3D 0) {
> +		FNIC_NVME_DBG(KERN_DEBUG, fnic,
> +			      "tport:0x%x lsreq:0x%x completed\n",
> +			      tport_fcid, oxid);
> +
> +		/* Copy the Response */
> +		memcpy(lsreq->rspaddr, (uint8_t *)fchdr + sizeof(*fchdr),
> +		       rsp_len);
> +	}
> +
> +	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +	lsreq->done(lsreq, status);
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +}

[Severity: High]
Could the timer callback race with lsreq->done() and cause a use-after-free?

Because timer_delete() is used instead of timer_delete_sync(), the timer
callback might be concurrently executing on another CPU spinning on fnic_lo=
ck.
When the lock is dropped here, lsreq->done() is called, returning ownership
to the NVMe FC midlayer which frees lsreq.

Once the lock is released, won't the spinning timer callback wake up and
dereference the freed lsreq memory?

[ ... ]
> +void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
> +		   struct nvme_fc_remote_port *rport,
> +		   struct nvmefc_ls_req *lsreq)
> +{
> +	struct fnic_iport_s *iport =3D lport->private;
> +	struct fnic *fnic =3D iport->fnic;
> +	struct fnic_tport_s *tport;
> +	struct nvfnic_ls_req *nvfnic_ls_req;
> +	uint16_t oxid;
> +	int timeout;
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
[ ... ]
> +	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_ABTS_STARTED;
> +	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +	timer_delete_sync(&nvfnic_ls_req->ls_req_timer);
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +	nvfnic_ls_req =3D lsreq->private;
> +
> +	if ((nvfnic_ls_req =3D=3D NULL) ||
> +	    (nvfnic_ls_req->state =3D=3D FNIC_LS_REQ_CMD_ABTS_PENDING)) {

[Severity: High]
Does this dereference lsreq->private after the lock is reacquired, when lsr=
eq
might already be freed?

The fnic_lock is dropped to call timer_delete_sync(). During this window,
nvfnic_terminate_tport_ls_reqs() could process the request and invoke
lsreq->done(), returning it to the midlayer which then frees it.

When the lock is reacquired, nvfnic_ls_req =3D lsreq->private accesses the =
freed
lsreq memory. Can this result in a use-after-free crash?

[ ... ]
> +void nvfnic_delete_tport(struct fnic_iport_s *iport,
> +						struct fnic_tport_s *tport,
> +						unsigned long flags)
> +{
> +	struct fnic *fnic =3D iport->fnic;
> +	int ret;
> +	unsigned int time_wait =3D FNIC_NVME_TPORT_REMOVE_WAIT;
> +	unsigned int time_remain;
> +	DECLARE_COMPLETION_ONSTACK(tm_done);
> +	unsigned int fcid;
> +	int count =3D 0;
> +
> +	if (!tport)
> +		return;
> +
> +	fcid =3D tport->fcid;
> +	fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINE);
> +
> +	FNIC_NVME_DBG(KERN_DEBUG, fnic,
> +			"0x%x: scheduled deletion for tport: 0x%x\n",
> +		    iport->fcid, tport->fcid);
> +
> +	if (!(tport->flags & FNIC_FDLS_NVME_REGISTERED)) {
> +		FNIC_NVME_DBG(KERN_ERR, fnic,
> +			"0x%x: tport: 0x%x not registered. Freeing\n",
> +		    iport->fcid, tport->fcid);
> +		list_del(&tport->links);
> +		kfree(tport);
> +		return;
> +	}
> +
> +	tport->tport_del_done =3D &tm_done;
> +
> +	tport->flags |=3D FNIC_FDLS_TPORT_DELETED;
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +	ret =3D nvme_fc_unregister_remoteport(tport->nv_rport);
> +	if (ret) {
> +		FNIC_NVME_DBG(KERN_ERR, fnic,
> +			    "tport: 0x%x unregister failed %d\n",
> +			    tport->fcid, ret);
> +		spin_lock_irqsave(&fnic->fnic_lock, flags);
> +		tport->tport_del_done =3D NULL;
> +		list_del(&tport->links);
> +		kfree(tport);
> +		return;
> +	}

[Severity: High]
Does this leak pending LS requests and leave their timers active?

If nvme_fc_unregister_remoteport() fails, kfree(tport) is called directly.
This bypasses nvfnic_terminate_tport_ls_reqs(), which leaks all nvfnic_ls_r=
eq
structures left on tport->ls_req_list.

Since their timers are never stopped, won't nvfnic_ls_req_timeout()
eventually fire and access the freed tport structure?

> +	time_remain =3D wait_for_completion_timeout(tport->tport_del_done,
> +				msecs_to_jiffies(time_wait));
> +
> +	FNIC_NVME_DBG(KERN_DEBUG, fnic,
> +		      "tport: 0x%x wait for deletion done\n",
> +		      tport->fcid);
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	tport->tport_del_done =3D NULL;
> +
> +	if (!time_remain) {
> +		FNIC_NVME_DBG(KERN_ERR, fnic,
> +			    "tport: 0x%x nvme midlayer completion timed out\n",
> +			    tport->fcid);
> +
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		nvfnic_cleanup_tport_io(fnic, tport);
> +		spin_lock_irqsave(&fnic->fnic_lock, flags);
> +		tport->flags &=3D ~FNIC_FDLS_NVME_TPORT_CLEANUP_PENDING;
> +		list_del(&tport->links);
> +		kfree(tport);

[Severity: High]
If this timeout expires, will the NVMe FC midlayer still call the
remoteport_delete callback and cause a use-after-free?

When the timeout expires, the driver forcefully calls kfree(tport). However,
the NVMe FC midlayer retains pointers to these structures and will eventual=
ly
execute the asynchronous remoteport_delete callback.

When nvfnic_remote_port_delete() is called later, it dereferences
rport->private. Since tport was already freed here, does this lead to a
use-after-free crash?

[ ... ]
> +int nvfnic_add_lport(struct fnic *fnic)
> +{
> +	struct nvme_fc_port_info pinfo;
> +	struct fnic_iport_s *iport =3D &fnic->iport;
> +	int ret =3D 0;
[ ... ]
> +		ret =3D nvme_fc_register_localport(&pinfo, iport->nv_tmpl,
> +						 get_device(&fnic->pdev->dev),
> +						 &iport->nv_lport);
> +		if (ret) {
> +			FNIC_NVME_DBG(KERN_ERR, fnic,
> +					"Failed to add wwpn: 0x%llx ret: %d\n",
> +					iport->wwpn, ret);
> +			kfree(iport->nv_tmpl);
> +			return ret;
> +		}

[Severity: Medium]
Does this create a permanent reference leak of the PCI device?

The get_device(&fnic->pdev->dev) call takes a reference that is passed to
the NVMe FC midlayer, which internally takes its own reference when registe=
ring
the localport and puts it upon unregistration.

Because this driver-level get_device() is never balanced with a put_device()
call by fnic, will this leak prevent PCI device teardown or hot-unplug?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D6
