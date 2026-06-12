Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE3E33F5BF
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 23:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781306167; cv=none; b=lFiGsbLxCwYystoCB2P7Umm/GUr407keAitUfGOLoAcAuvKLwcWjPeCCj4gArihbucpfBuhvLNf/hwE+yzDAhtSVima5SSJ68j7c4sf3VHU4XEKDA859uqXiySYQrc/TcMK6gMjb7Z2paX26IhEvcmItXS5RFH3FVPDXREm85R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781306167; c=relaxed/simple;
	bh=/Svp77bgp3BIjpBR/ZIKavRH6r0pUeyIQQD3UliNBOg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EpuLrQRXC9qNe9AQL5EBbg6pIUy4SFtZMpMi4X78NgtKMqqW912H/FE+KUUau5mGv86LTTg8iTDPVpiLTFEVnYJ8wkW292NyyzJD48lRKfRKWWb95ESXU2/k7s/rL2n7lCDATNWCMBikjaan8XnGNuLk3k/jcX8j5rr6z2AOz4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MYw3Lw49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYw3Lw49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1976E1F000E9;
	Fri, 12 Jun 2026 23:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781306166;
	bh=TWE2oZDF3qaO1tEDFdsfEw2fWOYjHX7C0RygXFDyrWQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MYw3Lw49dV/j3h46gfdsfzxXp3e+00DrAhBjPw7tGUyYstTpBRIGV9yMaC+i1ZGKs
	 8nDdMfKnAWGP7/zMnwJ1ukUd7mujA9w7/n7RAEk+F3wjUrxMRomg1TFiozm0RQGcUt
	 r0GQRQDJ9GBTvlUX5O7th3kW0hkHN/CTYrpTFtVeT5JU5b8a2ypgW2LFhl8wvZ8lMy
	 Q5gJNvtJMF4U5dF9Rd+K+atPeSZ2UKht8s5eu9/oOuE/5Zk/CzJfMz4TuI5iEu7xXU
	 9fatR4s1i1PgfLLNnoqt/UlwLTTzribdbWHkGjjbteEskF3d5QHYyO0NWQUjQlBcoN
	 N/gCdxk7rTkHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/13] scsi: fnic: Track NVMe transport statistics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-12-kartilak@cisco.com>
References: <20260612180918.8554-12-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 23:16:05 +0000
Message-Id: <20260612231606.1976E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Deadlock between fnic_lock and timer lock during NVMe LS response.
- [High] Use-After-Free of io_req when writing waitq_start_time.
- [High] Memory and active_ios leak when ITMF abort fails.
- [Medium] active_fw_reqs counter permanently drifts upwards on ERSP comple=
tions.
--

commit b68b40c66de8d347db7bd91c9ea2450605172e71
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Track NVMe transport statistics

Add counters for NVMe requests, responses, LS handling, aborts, and
wait-queue activity.

Update NVMe I/O, completion, LS response, LS abort, and abort paths to
maintain the new counters.

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index 9cc8f0baf09cb..2ccbfa0dfa92d 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c

[ ... ]

> @@ -193,6 +250,11 @@ inline int nvfnic_queue_wq_nvme_copy_desc(struct fni=
c *fnic,
>  					tport->max_payload_size, tport->r_a_tov,
>  					tport->e_d_tov);
> =20
> +	atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);
> +	if (atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs) >
> +	    atomic64_read(&fnic->fnic_stats.fw_stats.max_fw_reqs))
> +		atomic64_set(&fnic->fnic_stats.fw_stats.max_fw_reqs,
> +		     atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs));
> =20
>  	spin_unlock_irqrestore(&fnic->wq_copy_lock[idx], intr_flags);

[Severity: Medium]
Since this function increments active_fw_reqs for NVMe requests, does the
decrement in fnic_fcpio_cmpl_handler() in fnic_scsi.c need to be updated
to include FCPIO_NVME_ERSP_HW_CMPL?

Without updating the switch statement in fnic_fcpio_cmpl_handler(), will
the counter permanently drift upwards when NVMe commands complete with an
Extended Response?

[ ... ]

> @@ -766,11 +878,18 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fni=
c *fnic,
> =20
>  	io_req->cmd_flags |=3D FNIC_IO_ABT_TERM_DONE;
> =20
> +	if (!(io_req->cmd_flags & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
> +		atomic64_inc(&misc_stats->no_icmnd_itmf_cmpls);
> =20
>  	if (io_req->abts_state =3D=3D FCPIO_SUCCESS) {
>  		io_req->fcp_req->transferred_length =3D 0;
>  		io_req->fcp_req->rcv_rsplen =3D 0;
>  		io_req->fcp_req->status =3D NVME_SC_ABORT_REQ;
> +		atomic64_dec(&fnic_stats->io_stats.active_ios);
> +		if (atomic64_read(&fnic->io_cmpl_skip))
> +			atomic64_dec(&fnic->io_cmpl_skip);
> +		else
> +			atomic64_inc(&fnic_stats->io_stats.io_completions);
> =20
>  		nvfnic_release_nvme_ioreq_buf(iport, io_req);
>  		if (io_req->done)

[Severity: High]
Does this code leak memory and the active_ios counter when the abort status
is not FCPIO_SUCCESS?

If the abort fails, the function skips nvfnic_release_nvme_ioreq_buf(),
the io_req->done() callback, and the active_ios decrement before unlocking
and returning.

[ ... ]

> @@ -1067,11 +1191,14 @@ nvfnic_find_ls_req(struct fnic_tport_s *tport, ui=
nt16_t oxid)
>  void nvfnic_fcpio_cmpl(struct fnic_io_req *io_req)
>  {
>  	struct fnic *fnic =3D io_req->iport->fnic;
> +	struct fnic_stats *fnic_stats =3D &fnic->fnic_stats;
> =20
>  	nvfnic_free_fcpio_tag(io_req->iport, io_req);
> +	atomic64_inc(&fnic_stats->io_stats.nvme_ios_queued_for_rsp);
> =20
>  	llist_add(&io_req->nvfnic_io_cmpl, &fnic->nvme_io_event_llist);
>  	atomic_inc(&fnic->nvme_io_event_queued);
> +	atomic64_inc(&fnic_stats->io_stats.nvme_num_ios_in_waitq);
> =20
>  	io_req->waitq_start_time =3D jiffies;
>  	queue_work(fnic_cmpl_queue, &fnic->nvme_io_cmpl_work);

[Severity: High]
Can this write to waitq_start_time cause a use-after-free?

The io_req is published to a lockless list via llist_add() before assigning
waitq_start_time. A concurrent worker thread could dequeue the request,
process the completion, and free the memory before this assignment occurs.

[ ... ]

> @@ -1215,6 +1348,7 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
>  	}
> =20
>  	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_COMPLETE;
> +	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_responses);
> =20
>  	list_del_init(&nvfnic_ls_req->list);
>  	lsreq->private =3D NULL;

[Severity: High]
Is it possible the timer_delete_sync() call right after this block triggers
a deadlock?

nvfnic_ls_rsp_recv() is called with fnic->fnic_lock held. The sync
cancellation blocks on the timer callback if it's running, but the callback
(nvfnic_ls_req_timeout()) unconditionally attempts to acquire the same
fnic->fnic_lock, creating an AB-BA deadlock scenario.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D11
