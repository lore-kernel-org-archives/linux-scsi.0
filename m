Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A43C13C9C4
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 02:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180306; cv=none; b=tRTgOAaCw7Q0dSNE3/BQFSYGLksczB8jZcWNX+zBmzcH5L8QU5MMXHgSECpzzvHn6isAoQCuoJWB+fYy/m0o++dJn5mUEo8kz/eMyHDRpSMWXTQtIL9XbCPmBhbIsWzUNL5RcHy6DR+vQGKZTedzpdajQc+9fVBgGGxKA6Soiy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180306; c=relaxed/simple;
	bh=chb+bdgRCkFR3nRScMaMV5KxVP69o1mT9zU1xoty6Ao=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HHRI9Xn8i6h0DeP+lNA16xyfLbOYjwySN6a4QQ1IqowGuKFZbXjDBeLDYY5Ba1rwLvgPIeECWRauFo49go0TwsVLvv6RKWLhYz95aWV/zHm4qLxpkkZ8f1t7yofJuAIhdxtIH71kDMdLS4jdpDJ9C4BjXNAZnxOSHokXUt1g8OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeeccTgE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeeccTgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042221F000E9;
	Tue, 23 Jun 2026 02:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782180305;
	bh=1WlFeHxSF3qv7u6QJ/QMeG0UNmEHabPL5M3qURaoPWY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PeeccTgEpHsROpU/oZWm+0xCzQaskorcmfb8u0iGVhMG64TNb0E7wwxSNBqO7rlsp
	 D1mb7DLiPqIwYtwjgMCGQB7DizQwx96+JsauGmfLMGvUzyiqlVewIhOXzB0Vr8q8VO
	 Ur2GG81qZZU7tibh3UO/WVl3LMvHfTa0a6jok/iMMGmAtUhJ+io0h/r2jw3f5moxXk
	 cWV0TdRrJvMrzMk+eaHPiuwN6ixF+EZLlnugX4Xd3grjLlATIqkpJVnQ3qs5smwn3z
	 JxNdht8wWBlCGfulcGTGxznVtupnBXPFfrH+Qu2UBkFXwFP4NIILLUHK6AsbuRHHFP
	 kUHhW/uArsI7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 28/29] ibmvfc: implement nvme-fc FCP abort callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-29-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-29-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 02:05:04 +0000
Message-Id: <20260623020505.042221F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] Synchronous wait in `fcp_abort` violates the NVMe-FC transport API=
 and blocks the block layer timeout handler.
- [High] Lack of synchronization against command completion allows `fcp_abo=
rt` to abort the wrong I/O request and causes a Use-After-Free of `ibmvfc_e=
vent`.
- [High] Indefinite hang in `wait_for_completion` when an NVMe MAD command =
times out, due to missing NVMe queue cleanup in the host reset path.
- [High] Lock inversion (AB-BA) deadlock between the hardware queue lock an=
d the SCSI host lock during the failure path of `ibmvfc_send_event`.
- [High] Uninitialized `evt->tgt` pointer in FCP IO requests causes a NULL =
pointer dereference or Use-After-Free in the abort path.
- [Medium] Event pool exhaustion prevents aborts from issuing during hardwa=
re queue saturation, causing the transport to hang.
--

commit 0e079891124178111c0e0055ee9e67515aff453b
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: implement nvme-fc FCP abort callback

This commit implements the NVMe-FC FCP abort callback by issuing an NVMF
cancel MAD on the same submission queue used by the original FCP request.
It factors the TMF setup into a dedicated helper and sends the cancel
synchronously, waiting for completion.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index 18e8657abc444..92937f9aa4649 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> @@ -374,11 +374,75 @@ static int ibmvfc_nvme_fcp_io(struct nvme_fc_local_=
port *lport,
[ ... ]
> +static void ibmvfc_init_fcp_abort(struct ibmvfc_event *evt,
> +				  struct nvmefc_fcp_req *abort_req)
> +{
> +	struct ibmvfc_tmf *tmf;
> +	struct ibmvfc_event *abt_evt =3D abort_req->private;
> +	struct ibmvfc_target *tgt =3D abt_evt->tgt;
> +
> +	tmf =3D &evt->iu.tmf;
> +	memset(tmf, 0, sizeof(*tmf));
> +	tmf->common.version =3D cpu_to_be32(2);
> +	tmf->common.opcode =3D cpu_to_be32(IBMVFC_NVMF_TMF_MAD);
> +	tmf->common.length =3D cpu_to_be16(sizeof(*tmf));
> +	tmf->flags =3D cpu_to_be32(IBMVFC_TMF_ABORT_TASK | IBMVFC_TMF_NVMF_ASSO=
C);
> +	tmf->cancel_key =3D cpu_to_be32((u64)abt_evt);
> +	tmf->my_cancel_key =3D cpu_to_be32((u64)evt);
> +	tmf->target_wwpn =3D cpu_to_be64(tgt->wwpn);

[Severity: High]
Does this dereference a NULL or stale pointer?

It appears that when an NVMe FCP request is submitted via
ibmvfc_nvme_fcp_io(), an ibmvfc_event is allocated but its evt->tgt
field is never initialized. Because evt->tgt was never set during
submission, could it contain NULL (from pool zeroing) or a stale pointer
from a previous LS request when we extract it here?

> +	tmf->assoc_id =3D cpu_to_be64(tgt->assoc_id);
> +	tmf->task_tag =3D cpu_to_be64((u64)abt_evt);
> +
> +	init_completion(&evt->comp);
> +}
> +
> +static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
> +				  struct nvme_fc_remote_port *rport,
> +				  void *hw_queue_handle,
> +				  struct nvmefc_fcp_req *abort_req)
> +{
> +	struct ibmvfc_host *vhost =3D lport->private;
> +	struct ibmvfc_target *tgt =3D rport->private;
> +	struct ibmvfc_event *evt, *abt_evt =3D abort_req->private;
> +	struct ibmvfc_queue *queue;
> +	union ibmvfc_iu rsp;
> +	unsigned long flags;
> +	u16 status =3D 0;
> +
> +	if (!abt_evt)
> +		return;
> +
> +	queue =3D abt_evt->queue;

[Severity: High]
Is it possible for the original command to complete concurrently at the
hardware level before this code accesses abt_evt?

If the interrupt handler returns abt_evt to the free pool, could this
cause a use-after-free? Furthermore, if the event is reallocated to a
new I/O request on another CPU, could the TMF payload be populated with
the new event's tag, causing the VIOS to abort the wrong I/O request?

> +	if (!vhost->logged_in || !queue)
> +		return;
> +
> +	evt =3D ibmvfc_get_event(queue);
> +	if (!evt)
> +		return;

[Severity: Medium]
Will this silently drop the abort request if the standard event pool is
exhausted?

Since aborts are typically invoked when commands are timing out (often
due to submission queue saturation), should this use a reserved event?
If this returns NULL without sending the abort, could the command hang
indefinitely since the NVMe FC transport assumes the abort was initiated?

> +
> +	spin_lock_irqsave(queue->q_lock, flags);
> +	kref_get(&tgt->kref);
> +	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
> +	ibmvfc_init_fcp_abort(evt, abort_req);
> +	evt->sync_iu =3D &rsp;
> +
> +	if (ibmvfc_send_event(evt, vhost, default_timeout))

[Severity: High]
Can this cause a lock inversion (AB-BA) deadlock?

We acquire queue->q_lock before calling ibmvfc_send_event(). If
ibmvfc_send_event() encounters an error, it calls evt->done(evt).
Because the event is initialized with IBMVFC_MAD_FORMAT, the callback is
ibmvfc_locked_done(), which unconditionally acquires host_lock.

This creates an acquisition order of queue->q_lock -> host_lock. However,
the driver's reset path in ibmvfc_reset_host() acquires host_lock first,
then iterates over the hardware queues to acquire queue->q_lock inside
ibmvfc_purge_requests().

> +		goto out;
> +
> +	spin_unlock_irqrestore(queue->q_lock, flags);
> +
> +	wait_for_completion(&evt->comp);

[Severity: High]
Does this synchronous wait violate the NVMe-FC transport API?

The NVMe FC transport requires fcp_abort to be an asynchronous operation.
Because fcp_abort is invoked by the block layer's timeout worker, waiting
synchronously for the abort MAD to complete could stall the timeout
processing thread for the system until the VIOS responds.

[Severity: High]
Can this wait_for_completion() hang indefinitely if the NVMe MAD command
times out?

The fcp_abort TMF event is allocated on the NVMe queue (nvme_scrqs).
If the VIOS fails to respond to the cancel MAD, ibmvfc_send_event() times
out and triggers a host reset, invoking ibmvfc_purge_requests().

However, ibmvfc_purge_requests() iterates only over the legacy CRQ and
vhost->scsi_scrqs, entirely ignoring vhost->nvme_scrqs. Because the event
is never failed by the purge logic, could this wait forever?

> +	status =3D be16_to_cpu(rsp.mad_common.status);
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D28
