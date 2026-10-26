Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793014713;
	b=b2+SmO1Y8IM5+tvm0hOFQ77E2TSLhwnmT8ZjwOP1Ayy8ZSfDpEfXIih0zvSYqGlkYk0q
	 RmFQ7XXN03jbhE/hL3WK7LLuNrjx7uPsu/i6jIPZpLJ15YVUoKwDmEXpS/H71PeXdU+JD
	 33T+FPCnCqalFkyjc2a6XOSpNjWELjrpbK2+5kCU9eJtT2Xzn3jPZ27Fy5epv+GbT0399
	 5cRcq+VaTo8Z3Ti6lpjQtOmAf7WltNiuqJvS34VN2OW+AQPfRqA44rW84iypHWPd0X3AH
	 N2aSrq/6K3H/pNuCnlLCS5frKEklX6tRAexopuh22U8SHnLrhV+QMrDrFCkuN2vk50w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793014713;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dVytERwZYlqym/vAWy6xipuPbdpG5IKGRkl6qB2EwJc=;
	b=wF0FSL9egmEXf36PfwYbVwifX8S6+Ftbxioxx5hlDG0E799Gxy5vUWdV4lG3vujZlDNv
	 7CVrvFB/qMiAlJyv32Qj/yb/nsBlIVSfdrxclkvIB2bkISBospBvtD9eGxRJQe638cSwN
	 325PgVOEBEyk/cx58bHK16xBI1DqE/0n3oOCcin4dkdllSa6h9StdlCtL/VBnN7lNCirQ
	 fugZP5eX475YE/1iJ+cYoX50jD2iRDI6pC5TByYG0gJPHMzetoD+m0huW7/esAZuKMARs
	 J2KcS997I8rUDco5oItQ1lPhhWBjJWJkELWNsqje6akmrVs1dnZTWa+V9C31U/QaqrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E1wurWmV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEE7606A31B;
	Mon, 26 Oct 2026 11:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E1wurWmV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58191F01828;
	Mon, 26 Oct 2026 11:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793014712;
	bh=dVytERwZYlqym/vAWy6xipuPbdpG5IKGRkl6qB2EwJc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E1wurWmVbKWiPlVFg2yiWGEBAMENbC6G//4CSkhQA4PfDrijvxE06yL6KxMuA1KF9
	 SbHTQw0rjtjs2tkGsur51FrFVSodRJjVQALd+3EogogC5wbiJMuIM1SoWSacCBjkMu
	 gdg41ArRyipjtTAcAS/+4H3bNPvbkJ7haem3QtWQp3qpqdYVQPn/PjwAw0JrrpM28L
	 1FIMBxj6enBwzJ4oIAkLQiP+jtBA5HjCs24Hj+VoKLk1R2cAqhmsmEzckyOJl9W0Rm
	 blWCHgdnq4QXKDe8wI/+loPS7rNtsmFXtu6zRR/UEqm9nP7DNZb+PIzIzqOn+B8tLB
	 oveHVbCjYkNjQ==
Message-ID: <sashiko-outbox-185112@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 2/2] zfcp: Use DMA streaming API to map I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "M Nikhil" <nikh1092@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261026101301.3543163-3-nikh1092@linux.ibm.com>
References: <20261026101301.3543163-1-nikh1092@linux.ibm.com>
 <20261026101301.3543163-3-nikh1092@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 11:38:31 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] scsi: zfcp: premature command finish and UAF on FAST_IO_FAIL i=
n TMF reset
- [High] scsi: zfcp: DMA mapping leak and double map after zfcp_scsi_eh_abo=
rt_handler()
--

commit 14eb6f8d5a95f776e71a82cf2adfa01567fe0309
Author: M Nikhil <nikh1092@linux.ibm.com>

zfcp: Use DMA streaming API to map I/O

This commit converts zFCP I/O buffer mappings for QTCB, SRB, CT/ELS, and
SCSI I/O buffers from direct physical address translations to the DMA
streaming API using sg_table, dma_map_sgtable(), and dma_unmap_sgtable().

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index ea4b968352f4d..bda27153c3268 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -179,11 +179,31 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_c=
mnd *scpnt)
>  	write_lock_irqsave(&adapter->abort_lock, flags);
> =20
>  	old_req =3D zfcp_reqlist_find(adapter->req_list, old_reqid);
> -	if (!old_req) {
> +	if (!old_req || !old_req->data) {
>  		write_unlock_irqrestore(&adapter->abort_lock, flags);
>  		zfcp_dbf_scsi_abort("abrt_or", scpnt, NULL);
>  		return FAILED; /* completion could be in progress */
>  	}
> +
> +	/*
> +	 * Suppress the normal completion handler's unmap by clearing
> +	 * req->data now, under the abort_lock write-side.  The actual
> +	 * DMA unmap is deferred until the hardware has stopped using
> +	 * the buffers (after wait_for_completion or after ERP has
> +	 * quiesced the adapter), so that we never call dma_unmap_sgtable
> +	 * while the FCP channel may still be writing into the pages.
> +	 *
> +	 * old_req->data is left NULL permanently and never restored.
> +	 * Restoring it while returning non-SUCCESS to scsi_eh would be
> +	 * unsafe: scsi_eh is free to call scsi_finish_command() on scpnt
> +	 * as soon as we return non-SUCCESS, freeing scpnt's scatter-gather
> +	 * tables while old_req (with data pointing at the freed scpnt) is
> +	 * still live.  Any subsequent completion or ERP dismissal of
> +	 * old_req would then dereference a freed scpnt in
> +	 * zfcp_fsf_fcp_cmnd_handler() -- use-after-free and double
> +	 * scsi_done().  Leaving data =3D NULL means zfcp_fsf_fcp_cmnd_handler
> +	 * returns early harmlessly if old_req completes after we return.
> +	 */
>  	old_req->data =3D NULL;
> =20
>  	/* don't access old fsf_req after releasing the abort_lock */
> @@ -198,16 +218,55 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_c=
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
> +			 * finishing scpnt.  old_req->data stays NULL, so
> +			 * the eventual dismiss will skip the unmap (accepted
> +			 * DMA mapping leak for this path).
> +			 */
>  			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
> -			return ret;
> +			if (atomic_read(&adapter->status) &
> +			    ZFCP_STATUS_ADAPTER_QDIOUP) {
> +				retval =3D FAILED;
> +				return retval;
> +			}
> +			retval =3D ret; /* FAST_IO_FAIL, QDIO is down */
> +			goto out_unmap;
>  		}

[Severity: Critical]
When fc_block_scsi_eh() returns FAST_IO_FAIL while
ZFCP_STATUS_ADAPTER_QDIOUP is set, zfcp_scsi_eh_abort_handler() returns
FAILED here so that scsi_eh escalates instead of finishing scpnt while the
FCP channel may still be performing DMA.

However, when scmd_eh_abort_handler() escalates to
zfcp_scsi_eh_device_reset_handler() or zfcp_scsi_eh_target_reset_handler(),
both call zfcp_scsi_task_mgmt_function():

drivers/s390/scsi/zfcp_scsi.c:zfcp_scsi_task_mgmt_function() {
	while (retry--) {
		fsf_req =3D zfcp_fsf_fcp_task_mgmt(sdev, tm_flags);
		if (fsf_req)
			break;

		zfcp_dbf_scsi_devreset("wait", sdev, tm_flags, NULL);
		zfcp_erp_wait(adapter);
		ret =3D fc_block_rport(rport);
		if (ret) {
			zfcp_dbf_scsi_devreset("fiof", sdev, tm_flags, NULL);
			return ret;
		}
}

If zfcp_fsf_fcp_task_mgmt() also returns NULL because the LUN is still
blocked, fc_block_rport() immediately returns FAST_IO_FAIL, and
zfcp_scsi_task_mgmt_function() returns FAST_IO_FAIL directly to
scsi_eh_bus_device_reset() or scsi_eh_target_reset() without checking
ZFCP_STATUS_ADAPTER_QDIOUP and without calling zfcp_scsi_forget_cmnds().

In scsi_eh_bus_device_reset() and scsi_eh_target_reset(), a FAST_IO_FAIL
return is treated the same as SUCCESS, moving all commands for that LUN or
target to done_q where scsi_eh_flush_done_q() calls scsi_finish_command()
and scsi_free_sgtables().

Won't this finish scpnt and free its scatter-gather tables and I/O pages
while QDIO is still up and the hardware may still be performing DMA?
In addition, for any other command on that LUN or target that reached
LUN/target reset without going through zfcp_scsi_eh_abort_handler() (for
example, if scsi_host_eh_past_deadline() skipped abort or
SCSI_EH_ABORT_SCHEDULED was already set on a retry), old_req->data remains
non-NULL, so a subsequent completion or ERP dismissal in
zfcp_fsf_fcp_cmnd_handler() will dereference the freed scpnt and its
scpnt->sdb.table.

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
>  	if (!abrt_req) {
> +		/*
> +		 * abrt_ar: all retries of zfcp_fsf_abort_fcp_cmnd() failed.
> +		 * The hardware may still be running the original I/O; do not
> +		 * unmap.  old_req->data stays NULL so any eventual completion
> +		 * or ERP dismissal of old_req is a harmless no-op.
> +		 */
>  		zfcp_dbf_scsi_abort("abrt_ar", scpnt, NULL);
>  		return FAILED;
>  	}
> @@ -219,11 +278,49 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_c=
mnd *scpnt)
>  	else if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED)
>  		dbf_tag =3D "abrt_nn";
>  	else {
> -		dbf_tag =3D "abrt_fa";
> -		retval =3D FAILED;
> +		/*
> +		 * abrt_fa: the abort FSF request itself was dismissed by ERP
> +		 * (neither ABORTSUCCEEDED nor ABORTNOTNEEDED is set).  We do
> +		 * not know whether the hardware has stopped the original I/O;
> +		 * do not unmap.  old_req->data stays NULL.
> +		 */
> +		zfcp_dbf_scsi_abort("abrt_fa", scpnt, abrt_req);
> +		zfcp_fsf_req_free(abrt_req);
> +		return FAILED;
>  	}

[ ... ]

> @@ -237,13 +334,17 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_r=
eq *old_req, void *data)
>  {
>  	struct zfcp_scsi_req_filter *filter =3D
>  		(struct zfcp_scsi_req_filter *)data;
> +	struct scsi_cmnd *scpnt;
> =20
> -	/* already aborted - prevent side-effects - or not a SCSI command */
> +	/* already aborted - prevent side-effects - or not a SCSI I/O command */
>  	if (old_req->data =3D=3D NULL ||
>  	    zfcp_fsf_req_is_status_read_buffer(old_req) ||
> -	    old_req->qtcb->header.fsf_command !=3D FSF_QTCB_FCP_CMND)
> +	    old_req->qtcb->header.fsf_command !=3D FSF_QTCB_FCP_CMND ||
> +	    old_req->handler =3D=3D zfcp_fsf_fcp_task_mgmt_handler)
>  		return;
> =20
> +	scpnt =3D old_req->data;
> +
>  	/* (tmf_scope =3D=3D FCP_TMF_TGT_RESET || tmf_scope =3D=3D FCP_TMF_LUN_=
RESET) */
>  	if (old_req->qtcb->header.port_handle !=3D filter->port_handle)
>  		return;
> @@ -253,6 +354,17 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_re=
q *old_req, void *data)
>  		return;
> =20
>  	zfcp_dbf_scsi_nullcmnd((struct scsi_cmnd *)old_req->data, old_req);
> +
> +	if ((scsi_get_prot_op(scpnt) !=3D SCSI_PROT_NORMAL) &&
> +	    scsi_prot_sg_count(scpnt))
> +		zfcp_fsf_req_unmap_sg(&old_req->adapter->ccw_device->dev,
> +				      &scpnt->prot_sdb->table,
> +				      scpnt->sc_data_direction);
> +
> +	zfcp_fsf_req_unmap_sg(&old_req->adapter->ccw_device->dev,
> +			      &scpnt->sdb.table,
> +			      scpnt->sc_data_direction);
> +
>  	old_req->data =3D NULL;
>  }

[Severity: High]
When zfcp_scsi_eh_abort_handler() clears old_req->data =3D NULL on entry and
then returns FAILED on the abrt_ar, abrt_fa, or abrt_bl (with QDIOUP) paths
without unmapping scpnt->sdb.table and scpnt->prot_sdb->table, how are those
DMA mappings cleaned up when SCSI error recovery escalates?

In scmd_eh_abort_handler(), a FAILED return from eh_abort_handler does not
finish scpnt; instead it calls scsi_eh_scmd_add(scpnt) to escalate recovery
to LUN reset, target reset, and host reset in scsi_unjam_host().

Because old_req->data was already set to NULL:
- If LUN reset or target reset succeeds in zfcp_scsi_task_mgmt_function(),
  zfcp_scsi_forget_cmnds() -> zfcp_scsi_forget_cmnd() sees
  old_req->data =3D=3D NULL and returns early without unmapping scpnt.
- If host reset (zfcp_scsi_eh_host_reset_handler()) or adapter ERP runs
  zfcp_fsf_req_dismiss_all(), or if old_req completes before reset,
  zfcp_fsf_fcp_cmnd_handler() sees req->data =3D=3D NULL and returns early
  without unmapping scpnt (and on the abrt_fa path where ERP dismissed
  abrt_req, old_req was already dismissed and freed with data =3D=3D NULL).

When scsi_eh_flush_done_q() then runs after the reset succeeds, won't it
either requeue scpnt via scsi_queue_insert() and call dma_map_sgtable() a
second time on the still-mapped scpnt->sdb.table in zfcp_fsf_fcp_cmnd(), or
call scsi_finish_command() and leak the DMA mappings and SWIOTLB bounce
buffer slots?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026101301.3543=
163-1-nikh1092@linux.ibm.com?part=3D2
