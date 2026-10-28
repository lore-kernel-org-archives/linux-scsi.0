Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793166337;
	b=h9Ad9fTfKd5CWWyZGOe8buDH5EaLC4eCpVcYkBgxDosVzLrATvi+gcyi3fFwgC+4PQop
	 r3Kj0RgvGl9LtaN16hrgv6vK0GrWpkptekbG1bBBy8li93tKcpfNhl4zUruV1m5eYuQ02
	 OjUvOK0UPtxQMZwL+3QIq/n2j5/gt7JNE4AjrG+qXPTGqkFFhQ+UVMjTaLZf4L7qLGP06
	 /hb0GpnWInl5LdDnKRcr3R+XVrQmxi/siZxR9lt06jEL1VK7paoG271fclxRDnstqp81q
	 HV/DDJoOWo2EH46KGBwOvdO9++uns9v1jw9cIrTK9z61KGxVzVU3teiDcMFHgFmuJYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793166337;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gVxm9drXJPkBehDC0JDeZxOcL2m/QtqIt72taNSL1cA=;
	b=e/rgwUj03Wrwkc8WrCVzE2nqExy2BBZvwGjjJJj5JZdbD9oxUwvGFE8TZouVPDylvnE7
	 aTH235nAA2QwGg09D4l/vU0HyB50+4xWs6JiutO/su6KABLuTWyfxFQAJme1l5/YJjvax
	 XRpoDwc2tAUzUboO9erTSzpkHCSI26qn6DrWDzmOx3Ttk2H3+yYZrmWWIpfMXR6Tbi1jk
	 mcO6/JvkDgTdaaYWhNsD3Y2RREaUjJyxRllxt6nFihjDd2GZMoyf881IPE6cp5x2oX0ni
	 OoKBo8Dp6HQPqEe0ePQOiOJdy2yFFOhyjTeWpwM0HPIMNaEKFGYLx92VO8o+7tC5S2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EkjXNdz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80B2606A31E;
	Wed, 28 Oct 2026 05:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EkjXNdz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF2F1F01825;
	Wed, 28 Oct 2026 05:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793166336;
	bh=gVxm9drXJPkBehDC0JDeZxOcL2m/QtqIt72taNSL1cA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EkjXNdz3vkMMq0aaKndAmjFAPH55nPAWRqu0R9IcU2dlEvnlsaWx2qvB79KzJRli+
	 CIZBWMs0PPmvZGC7VB1tWnjHqTc1g8nTVOpEQB2cXyri8ZzB/b5qtVRzBjB4VHkxd+
	 bg9DmbM0UUkfb2fNEAiYbIwn9DZjkYAUsu9dlTQ6y1y8D7QrgWHYW+5wEMZGX0JjKu
	 kxuJMNA0oz9lhh00COwZZQgsj0BUNeQmma0RIS9u6pGQfnmcZisL0bR9qrZ0d1IcI4
	 8lZB6eSER/6s69fffUY/uEAmgZHEPEf8HcyvP3TayWX+wxXrJvvw9zIgqLYoLP6HhG
	 Xhehi6bsX8mmw==
Message-ID: <sashiko-outbox-187541@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 2/2] zfcp: Use DMA streaming API to map I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "M Nikhil" <nikh1092@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261028051446.3163392-3-nikh1092@linux.ibm.com>
References: <20261028051446.3163392-1-nikh1092@linux.ibm.com>
 <20261028051446.3163392-3-nikh1092@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 05:45:35 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] scsi: zfcp: premature DMA unmap and UAF on adapter shutdown in=
 SCSI EH
- [Critical] scsi: zfcp: use-after-free and DMA leak on host reset with ERP=
_FAILED
- [High] scsi: zfcp: stale QDIO SBALE DMA address on abort and status read =
error paths
- [High] scsi: zfcp: race between zfcp_fsf_reqid_check() and zfcp_scsi_forg=
et_cmnds() on restored req->data
--

commit 62d32e0c324a9864b32b7819374bcb22949814d1
Author: M Nikhil <nikh1092@linux.ibm.com>

zfcp: Use DMA streaming API to map I/O

This commit converts zFCP I/O buffer mappings (QTCB, SRB, CT/ELS, and SCSI
I/O) from direct physical address translations to the DMA streaming API usi=
ng
dma_map_sgtable() and dma_unmap_sgtable(). It also updates the SCSI error
handling and QDIO submission paths to manage DMA mapping lifetimes and SBAL
cleanup.

> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index 12b3d2d0a2c87..05f3b226b1634 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
[ ... ]
> @@ -954,17 +1066,29 @@ int zfcp_fsf_status_read(struct zfcp_qdio *qdio)
>  	memset(sr_buf, 0, sizeof(*sr_buf));
>  	req->data =3D sr_buf;
> =20
> -	zfcp_qdio_fill_next(qdio, &req->qdio_req, sr_buf, sizeof(*sr_buf));
> +	sg_init_one(&req->metadata_sg, sr_buf, sizeof(*sr_buf));
> +	req->metadata_sgt.sgl =3D &req->metadata_sg;
> +	req->metadata_sgt.orig_nents =3D 1;
> +
> +	retval =3D zfcp_fsf_req_map_sg(req, &req->metadata_sgt, DMA_FROM_DEVICE=
);
> +	if (unlikely(retval))
> +		goto failed_dma_map;
> +
> +	zfcp_qdio_fill_next(qdio, &req->qdio_req,
> +			    sg_dma_address(req->metadata_sgt.sgl),
> +			    sg_dma_len(req->metadata_sgt.sgl));
>  	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
> =20
>  	retval =3D zfcp_fsf_req_send(req);
>  	if (retval)
>  		goto failed_req_send;
>  	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
> =20
>  	goto out;
> =20
>  failed_req_send:
> +	zfcp_fsf_req_unmap_metadata(req);
> +failed_dma_map:
>  	req->data =3D NULL;
>  	mempool_free(virt_to_page(sr_buf), adapter->pool.sr_data);
>  failed_buf:
>  	zfcp_dbf_hba_fsf_uss("fssr__1", req);
>  	zfcp_fsf_req_free(req);
>  out:
>  	spin_unlock_irq(&qdio->req_q_lock);
>  	return retval;
>  }
[ ... ]
> @@ -1076,6 +1200,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct=
 scsi_cmnd *scmnd)
>  	}
> =20
>  out_error_free:
> +	zfcp_fsf_req_unmap_metadata(req);
>  	zfcp_fsf_req_free(req);
>  	req =3D NULL;
>  out:

[Severity: High]
Can the error paths in zfcp_fsf_abort_fcp_cmnd() and zfcp_fsf_status_read()
leave stale DMA addresses in the QDIO request queue SBALs?

In zfcp_fsf_abort_fcp_cmnd(), zfcp_fsf_req_create() allocates and maps
req->qtcb and calls zfcp_qdio_req_init() with has_qtcb =3D true, which writ=
es
element[0] and element[1] (with qtcb_dma_handle and qtcb_len) of
qdio->req_q[qdio->req_q_idx]:

drivers/s390/scsi/zfcp_qdio.h:zfcp_qdio_req_init() {
	...
	q_req->sbale_curr =3D 1;
	sbale->eflags =3D 0;
	sbale->sflags =3D SBAL_SFLAGS0_COMMAND | sbtype;

	if (unlikely(!has_qtcb))
		return;
	sbale++;
	sbale->addr =3D u64_to_dma64(qtcb_dma_handle);
	sbale->length =3D qtcb_len;
}

If the LUN is blocked (!(atomic_read(&zfcp_sdev->status) &
ZFCP_STATUS_COMMON_UNBLOCKED)), zfcp_fsf_abort_fcp_cmnd() jumps to
out_error_free and unmaps and frees req->qtcb without calling
zfcp_qdio_zero_sbals() and without advancing qdio->req_q_idx.

If the next caller to use qdio->req_q[qdio->req_q_idx] is
zfcp_fsf_status_read(), its zfcp_fsf_req_create() calls zfcp_qdio_req_init()
with has_qtcb =3D false, which sets q_req->sbale_curr =3D 1, initializes
element[0], and returns early without clearing element[1].
zfcp_fsf_status_read() then calls zfcp_qdio_fill_next(), which increments
q_req->sbale_curr to 2 and writes the status read buffer DMA address into
element[2]. The SRB SBAL is then submitted to the adapter with element[1]
still holding the unmapped and freed QTCB DMA address.

Similarly, in zfcp_fsf_status_read(), if mempool_alloc() (goto failed_buf) =
or
zfcp_fsf_req_map_sg() (goto failed_dma_map) fails after zfcp_fsf_req_create=
()
initialized element[0], zfcp_qdio_zero_sbals() is not called before freeing
req. Should both out_error_free in zfcp_fsf_abort_fcp_cmnd() and failed_buf
in zfcp_fsf_status_read() call zfcp_qdio_zero_sbals()?

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index ea4b968352f4d..99ea8c499bd1a 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -163,6 +163,70 @@ static int zfcp_scsi_sdev_init(struct scsi_device *s=
dev)
[ ... ]
> +static int zfcp_scsi_abort_failed(struct zfcp_adapter *adapter,
> +				  struct scsi_cmnd *scpnt, u64 old_reqid)
> +{
> +	struct zfcp_fsf_req *old_req;
> +	unsigned long flags;
> +
> +	write_lock_irqsave(&adapter->abort_lock, flags);
> +	old_req =3D zfcp_reqlist_find(adapter->req_list, old_reqid);
> +	if (old_req) {
> +		old_req->data =3D scpnt;
> +		write_unlock_irqrestore(&adapter->abort_lock, flags);
> +		return FAILED;
> +	}
> +	write_unlock_irqrestore(&adapter->abort_lock, flags);
> +
> +	zfcp_scsi_unmap_cmnd(adapter, scpnt);
> +	return FAILED;
> +}

[Severity: High]
When zfcp_scsi_abort_failed() restores old_req->data =3D scpnt so that a la=
ter
LUN or target reset will unmap and detach scpnt in zfcp_scsi_forget_cmnds(),
can a concurrent completion in zfcp_fsf_reqid_check() race with
zfcp_scsi_forget_cmnds()?

On the QDIO completion path, zfcp_fsf_reqid_check() removes fsf_req from
adapter->req_list before acquiring adapter->abort_lock in
zfcp_fsf_fcp_cmnd_handler():

drivers/s390/scsi/zfcp_fsf.c:zfcp_fsf_reqid_check() {
	...
	fsf_req =3D zfcp_reqlist_find_rm(adapter->req_list, req_id);
	...
	zfcp_fsf_req_complete(fsf_req);
	  -> zfcp_fsf_fcp_cmnd_handler(fsf_req)
	       read_lock_irqsave(&req->adapter->abort_lock, flags);
}

If CPU1 removes old_req in zfcp_reqlist_find_rm() just before CPU2 runs
zfcp_scsi_forget_cmnds() at the end of zfcp_scsi_task_mgmt_function():

drivers/s390/scsi/zfcp_scsi.c:zfcp_scsi_forget_cmnds() {
	...
	write_lock_irqsave(&adapter->abort_lock, flags);
	zfcp_reqlist_apply_for_all(adapter->req_list, zfcp_scsi_forget_cmnd,
				   &filter);
	write_unlock_irqrestore(&adapter->abort_lock, flags);
}

CPU2 will not find old_req in adapter->req_list, so zfcp_scsi_forget_cmnd()
never unmaps scpnt or clears old_req->data. zfcp_scsi_task_mgmt_function()
then returns SUCCESS to scsi_eh, which either reuses scpnt for scsi_eh_tur()
(where scsi_eh_prep_cmnd() zeroes scpnt->sdb and sets scpnt->sc_data_direct=
ion
=3D DMA_NONE) or finishes and frees scpnt.

When CPU1 subsequently enters zfcp_fsf_fcp_cmnd_handler() and acquires
adapter->abort_lock, it sees req->data =3D=3D scpnt still non-NULL, skips
unmapping the zeroed scpnt->sdb (leaking the DMA mapping), and calls
scsi_done(scpnt) on a command that is either mid-TUR or already finished.

> @@ -198,18 +284,57 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_c=
mnd *scpnt)
>  		zfcp_erp_wait(adapter);
>  		ret =3D fc_block_scsi_eh(scpnt);
>  		if (ret) {
> +			/*
> +			 * fc_block_scsi_eh returned FAST_IO_FAIL because
> +			 * fast_io_fail_tmo fired.  This may originate from a
> +			 * per-port reopen (fc_timeout_fail_rport_io ->
> +			 * zfcp_scsi_terminate_rport_io ->
> +			 * zfcp_erp_port_forced_reopen) that closes the port
> +			 * asynchronously without shutting QDIO down or
> +			 * calling zfcp_fsf_req_dismiss_all().
> +			 *
> +			 * Only unmap scpnt's DMA buffers if QDIO is already
> +			 * down.  That is the exact precondition enforced by
> +			 * zfcp_fsf_req_dismiss_all() (BUG_ON QDIOUP) and
> +			 * guarantees the hardware is no longer using them.
> +			 *
> +			 * If QDIO is still up the hardware may still be
> +			 * writing into the buffers; we must not unmap now.
> +			 * Return FAILED so scsi_eh escalates instead of
> +			 * finishing scpnt.  zfcp_scsi_abort_failed() hands
> +			 * the unmap back to the request's completion or
> +			 * dismissal, or to the TMF path (forget_cmnds), so
> +			 * the mapping is not leaked.
> +			 */
>  			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
> -			return ret;
> +			if (atomic_read(&adapter->status) &
> +			    ZFCP_STATUS_ADAPTER_QDIOUP)
> +				return zfcp_scsi_abort_failed(adapter, scpnt,
> +							      old_reqid);
> +			retval =3D ret; /* FAST_IO_FAIL, QDIO is down */
> +			goto out_unmap;
>  		}
>  		if (!(atomic_read(&adapter->status) &
>  		      ZFCP_STATUS_COMMON_RUNNING)) {
> +			/*
> +			 * Adapter is gone; ERP shut down QDIO and dismissed
> +			 * all requests before clearing RUNNING.  Safe to
> +			 * unmap now.
> +			 */
>  			zfcp_dbf_scsi_abort("abrt_ru", scpnt, NULL);
> -			return SUCCESS;
> +			retval =3D SUCCESS;
> +			goto out_unmap;
>  		}
>  	}
[ ... ]
> @@ -305,6 +479,21 @@ static int zfcp_scsi_task_mgmt_function(struct scsi_=
device *sdev, u8 tm_flags)
>  		ret =3D fc_block_rport(rport);
>  		if (ret) {
>  			zfcp_dbf_scsi_devreset("fiof", sdev, tm_flags, NULL);
> +			/*
> +			 * QDIO still up: the FCP channel may still be using
> +			 * the buffers of outstanding commands.  Do not let
> +			 * scsi_eh finish them; escalate to host reset instead.
> +			 */
> +			if (atomic_read(&adapter->status) &
> +			    ZFCP_STATUS_ADAPTER_QDIOUP)
> +				return FAILED;
> +			/*
> +			 * QDIO down: the hardware is done with the buffers.
> +			 * Detach and unmap the commands so that a later
> +			 * completion or dismissal of their requests cannot
> +			 * touch a finished scpnt.
> +			 */
> +			zfcp_scsi_forget_cmnds(zfcp_sdev, tm_flags);
>  			return ret;
>  		}
> =20
>  		if (!(atomic_read(&adapter->status) &
>  		      ZFCP_STATUS_COMMON_RUNNING)) {
>  			zfcp_dbf_scsi_devreset("nres", sdev, tm_flags, NULL);
>  			return SUCCESS;
>  		}

[Severity: Critical]
Is it safe to assume that QDIO has been shut down and all requests have been
dismissed whenever ZFCP_STATUS_COMMON_RUNNING is clear?

Looking at zfcp_erp_adapter_shutdown() -> zfcp_erp_adapter_reopen() in
drivers/s390/scsi/zfcp_erp.c:

drivers/s390/scsi/zfcp_erp.c:zfcp_erp_adapter_shutdown() {
	int flags =3D ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
	zfcp_erp_adapter_reopen(adapter, clear | flags, dbftag);
	  -> zfcp_erp_adapter_block(adapter, clear | flags);
	  -> zfcp_scsi_schedule_rports_block(adapter);
	  -> write_lock_irqsave(&adapter->erp_lock, ...);
	  -> zfcp_erp_action_enqueue(..., ZFCP_ERP_ACTION_REOPEN_ADAPTER, ...);
}

zfcp_erp_adapter_block() clears ZFCP_STATUS_COMMON_RUNNING synchronously
before the ERP action is enqueued, while zfcp_qdio_close() and
zfcp_fsf_req_dismiss_all() run asynchronously later on the ERP thread in
zfcp_erp_adapter_strategy_close().

This appears to cause a few problems in the error handlers:

1. In zfcp_scsi_eh_abort_handler() (at "abrt_ru"), if
   zfcp_erp_adapter_shutdown() runs concurrently (for example, between
   zfcp_erp_adapter_block() and zfcp_erp_action_enqueue() so zfcp_erp_wait()
   returns immediately, or right after zfcp_erp_wait() returns),
   ZFCP_STATUS_COMMON_RUNNING is already clear while QDIO is still active.
   Jumping to out_unmap will unmap scpnt's DMA buffers and return SUCCESS
   while the FCP channel may still be performing DMA.

2. If zfcp_scsi_eh_abort_handler() fails and zfcp_scsi_abort_failed()
   restores old_req->data =3D scpnt, scsi_eh escalates to
   zfcp_scsi_task_mgmt_function(). At "nres", observing
   !(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_RUNNING) returns
   SUCCESS without checking ZFCP_STATUS_ADAPTER_QDIOUP and without calling
   zfcp_scsi_forget_cmnds(). scsi_eh then finishes scpnt while old_req is
   still on adapter->req_list with old_req->data =3D=3D scpnt. When
   zfcp_fsf_req_dismiss_all() or normal completion later runs
   zfcp_fsf_fcp_cmnd_handler(), it will unmap and call scsi_done() on the
   already-finished scpnt.

3. In zfcp_qdio_close() in drivers/s390/scsi/zfcp_qdio.c,
   ZFCP_STATUS_ADAPTER_QDIOUP is cleared before calling tasklet_disable(),
   qdio_stop_irq(), and qdio_shutdown(). Can the lockless checks of
   ZFCP_STATUS_ADAPTER_QDIOUP in "abrt_bl" and "fiof" observe QDIOUP cleared
   and unmap scpnt before qdio_shutdown() has actually stopped hardware DMA?

[Severity: Critical]
In addition, when zfcp_scsi_eh_abort_handler() (at "abrt_bl" or "abrt_ar")
and zfcp_scsi_task_mgmt_function() (at "fiof" or "reqf") return FAILED
because ZFCP_STATUS_ADAPTER_QDIOUP is still set while old_req->data =3D=3D =
scpnt
remains on adapter->req_list, what happens if scsi_eh escalates to
zfcp_scsi_eh_host_reset_handler() after a link-down event?

When a local link-down event occurs (zfcp_fsf_status_read_link_down() ->
zfcp_fsf_link_down_info_eval(), or FSF_PROT_LINK_DOWN in
zfcp_fsf_protstatus_eval()), zfcp_erp_set_adapter_status(adapter,
ZFCP_STATUS_COMMON_ERP_FAILED) sets ZFCP_STATUS_COMMON_ERP_FAILED on
adapter->status while leaving ZFCP_STATUS_ADAPTER_QDIOUP set.

When fast_io_fail_tmo fires on the blocked rport and both abort and
LUN/target reset return FAILED because QDIOUP is set, scsi_eh calls
zfcp_scsi_eh_host_reset_handler():

drivers/s390/scsi/zfcp_scsi.c:zfcp_scsi_eh_host_reset_handler() {
	...
	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
	zfcp_erp_wait(adapter);
	fc_ret =3D fc_block_scsi_eh(scpnt);
	if (fc_ret)
		ret =3D fc_ret;
	...
	return ret;
}

Because zfcp_erp_adapter_reopen() is called with clear =3D 0,
zfcp_erp_action_enqueue() -> zfcp_erp_handle_failed() sees
ZFCP_STATUS_COMMON_ERP_FAILED still set on adapter->status and suppresses
ZFCP_ERP_ACTION_REOPEN_ADAPTER (need =3D 0). As a result, zfcp_qdio_close()=
 and
zfcp_fsf_req_dismiss_all() are never executed, QDIO stays up, and old_req
remains in adapter->req_list with old_req->data =3D=3D scpnt.

zfcp_scsi_eh_host_reset_handler() then returns FAST_IO_FAIL (or SUCCESS) to
scsi_eh_host_reset(), which finishes and frees scpnt. When the link later
comes back up (FSF_STATUS_READ_LINK_UP) or the adapter is shut down,
zfcp_fsf_req_dismiss_all() will invoke zfcp_fsf_fcp_cmnd_handler(old_req)
with req->data pointing to the freed scpnt, causing a use-after-free in
zfcp_fsf_req_unmap_sg() and scsi_done().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028051446.3163=
392-1-nikh1092@linux.ibm.com?part=3D2
