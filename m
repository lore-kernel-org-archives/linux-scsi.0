Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC8E470EA2
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 01:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768741; cv=none; b=BSIuJNgiguhp7BX04EuTUIWmNTom9jalrc3GEpJ0MNws0ei8bPdsFpNGyPsGJllo48m0HdmaW0Ij0+t/AoGlmwYJHHrOJZqkRbld1Ek8p0GIshPByOoZdJCP2JovZ6sYuiPrrwzC5xAtUzHUnIVbMBUqaBaia/CSzJ78NQifuPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768741; c=relaxed/simple;
	bh=xCGQO2aa6wgewKdTPGWNL8rI3qevC93WJHXsb6xLKcM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aGmVyuyv3h+aV5lChtuFLqBs1oSHmBPus0lZ9E/82U+EK9akPkef/h320KEGKv/csHXFjfiz/lpgRfgNk7Zpsvf1ojPtDbZ8CTlvFO2Ar6ma0FfgXH9snIwkw003jWxdH17jFS14p5a3U66YQ+hbLDxDCaWxxWRovFiO0IkaE4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6vNYo6H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6vNYo6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8BC1F000E9;
	Thu, 23 Jul 2026 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784768740;
	bh=SFC/2C6cvZr1PLwzza9D+zI4GG4noeHKdE/IuszBljs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g6vNYo6Ht7gceb2zkK0iEyf/EsZrbnC1CVy+GEyK3dDAV9484RJiz412Q52F4LQPX
	 uUEvkgNIg/4KpNPwP6B5xzCqz0z34JxGpWlOblm/wY6dA6teq7ROcwIk+qnNXl7agl
	 ki7SD+CrbVq15EV+B5JKEDGosfea1qxBHFLs8FMpoMCVmtcfKHtkffzgxrgoDT6WaI
	 8pP7tbPtTLwNW5kpisxHWYvWtK6RTKvjVvi456nigvzlravidklQZcpn5WwL9E9C9b
	 tjW05FBnxQA+6dUTjwi9t8b9vRbSOEL9YbnmqLpCAaAetQm13Jvw/4trtcdi7/5Zh/
	 o8aE16VRRSBNQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 32/33] ibmvfc: implement nvme-fc FCP abort callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-33-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-33-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 01:05:39 +0000
Message-Id: <20260723010539.CD8BC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Lockless access to the original event in the FCP abort handler=
 leads to Use-After-Free and spurious aborts of innocent I/O requests.
- [Critical] Dereferencing the uninitialized `abt_evt->tgt` pointer in `ibm=
vfc_init_fcp_abort` will cause a guaranteed kernel panic.
- [High] The `fcp_abort` callback blocks synchronously waiting for the abor=
t MAD to complete on the wire, stalling the block layer's timeout workqueue.
- [High] FCP abort hangs forever if the adapter resets while the abort MAD =
is in-flight because NVMe queues are not purged.
--

--- Patch [32]: [PATCH v2 32/33] ibmvfc: implement nvme-fc FCP abort callba=
ck ---
commit b7d2ac0c1d18f363d56507d99dd9acbcd4cd3058
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

    ibmvfc: implement nvme-fc FCP abort callback
   =20
    Implement the NVMe-FC FCP abort callback by issuing an NVMF cancel MAD
    on the same submission queue used by the original FCP request.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index 390410e44f0d8..54f80b6265d45 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> @@ -374,11 +374,75 @@ static int ibmvfc_nvme_fcp_io(struct nvme_fc_local_=
port *lport,
>  	return rc;
>  }
> =20
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

[Severity: Critical]
Does this dereference an uninitialized pointer?

When an FCP IO is submitted via ibmvfc_nvme_fcp_io(), the evt->tgt field is
never populated.

When this IO times out, the code above extracts abt_evt->tgt and immediately
dereferences it to assign tmf->target_wwpn.

Since the correct target pointer is passed into fcp_abort as rport->private,
should that be used here instead to avoid a panic?

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

[Severity: Critical]
Can accessing abort_req->private locklessly race with a hardware completion?

If an IO completes in hardware at the same time as a block layer timeout,
ibmvfc_nvme_done() can unconditionally free the event:

ibmvfc_nvme_done()
  ibmvfc_free_event(evt);

If this event is immediately reallocated for a new IO request on another CP=
U,
would using this reused event as the task_tag and cancel_key cause the VIOS
to abort the newly allocated, unrelated IO?

> +	struct ibmvfc_queue *queue;
> +	union ibmvfc_iu rsp;
> +	unsigned long flags;
> +	u16 status =3D 0;
> +
> +	if (!abt_evt)
> +		return;

[ ... ]

> +	spin_unlock_irqrestore(queue->q_lock, flags);
> +
> +	wait_for_completion(&evt->comp);

[Severity: High]
Does waiting synchronously here stall the blk-mq timeout worker thread?

The fcp_abort callback executes in the timeout workqueue. By waiting
synchronously for the MAD to complete on the wire, it seems this could stall
the timeout worker for up to default_timeout seconds, preventing timeout
handling for all other requests.

[Severity: High]
Could this wait_for_completion() block indefinitely during an adapter reset?

If the abort MAD times out, ibmvfc_timeout() resets the host and calls
ibmvfc_purge_requests() to fail all pending IOs.

However, the purge logic only loops over SCSI queues:

ibmvfc_purge_requests() {
  struct ibmvfc_queue *queues =3D vhost->scsi_scrqs.scrqs;
  ...
  for (i =3D 0; i < hwqs; i++) {
    list_for_each_entry_safe(evt, pos, &queues[i].sent, queue_list)
  ...
}

Since the NVMe queues (vhost->nvme_scrqs.scrqs) are completely ignored,
the NVMe MADs are left hanging. Will this cause this completion to never
be signaled?

> +	status =3D be16_to_cpu(rsp.mad_common.status);
> +
> +	spin_lock_irqsave(queue->q_lock, flags);
> +	ibmvfc_free_event(evt);
> +out:
> +	spin_unlock_irqrestore(queue->q_lock, flags);
> +
> +	if (status)
> +		ibmvfc_dbg(vhost, "fcp_abort: cancel failed with rc=3D%x\n", status);
> +
> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D32
