Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D442BB13
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 01:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768903; cv=none; b=gw+O5AHcdweEWXaH8YDqDtky3I+N2kaQ6c5WRlrfHpBMBTc1Xd/8OiVgNAmehEdxv0JFA1XpUCv6sstc0FSaBS3aZGUoSGgxT7vbFSS0qCf0Zt0iWm00KUYWILvuLupaKzlyHSZfZmLh0sNXfe5QG+Jbl8kN5g7n5g/kaC3FWC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768903; c=relaxed/simple;
	bh=O9sI8XotX+eMBfTNK37clvFNy35w94cjp2PzD5JK5/M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hgUzZ1yBt65zljxJJA1SAJHquiY1PXnLrxKFTlp2M8Nw5O3Y0CNwi0EyF+UN1Evxpzng4jkSAB6uxQjVrA8tpNupS7N//QMBe7J845SnLsH9SxBwLpKNmWess4gjBZB548B4VnEyGA/2tFX3ppvc0DxOPScUm360KvmXjj6bNwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7OlTR2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7OlTR2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75981F000E9;
	Thu, 23 Jul 2026 01:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784768901;
	bh=QzyXlmAejEu7aDhAMh3MUvglgjxkhYyQ+oBhsRdbwcY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n7OlTR2sELgmrc60HfhaSn7Q3J7iELpcreHaxCxu/QvV0pXdmMBos9JB2uJqaRT/Z
	 fanxfFIzedQ8Lx0Lp0chmbZ5InPcHSB78uFR7DdAe5Lhpc7KJG4n9oCkZYvh1IWtN2
	 /Ifu2+C6VHS1WGAR4iR7IrD723RisKYhw5mPzJXdAwJeHXCKJFiG9DhaSvNpKLgika
	 QGVAZWE8uKsvUGkreukSR0wypHh2+Tqu3VO8h6FGRyNWMvrHBLtlb4EKQm1D3LHbpP
	 e3+srWT55aF6ReWNGYzfUAJj31PQZZQ2LBsQ518q4RaqmSBSjjmxwUu1o0fQS59M8E
	 c99/T53Tlp9Eg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 30/33] ibmvfc: implement nvme-fc IO command
 submission callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-31-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-31-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 01:08:21 +0000
Message-Id: <20260723010821.B75981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] NVMe FCP requests are incorrectly processed as MAD requests in=
 error and purge paths, causing uninitialized pointer dereferences and sile=
nt data corruption.
- [Critical] Heap buffer overflow in scatterlist mapping due to mismatch be=
tween driver-advertised maximum segments and the DMA pool block size.
- [High] The driver passes uninitialized or stale NVMe Completion Queue Ent=
ries (CQE) to the NVMe-FC transport when the adapter skips the ERSP DMA.
- [High] `ibmvfc_nvme_fcp_io` propagates SCSI midlayer error codes directly=
 to the NVMe-FC core, causing NVMe I/O requests to permanently fail instead=
 of being retried.
- [Medium] Truncating a 64-bit pointer to a 32-bit `cancel_key` risks colli=
sions across multiple command queues.
--

--- Patch [30]: [PATCH v2 30/33] ibmvfc: implement nvme-fc IO command submi=
ssion callback ---
commit 6afa68277a7b61e829a727b116180c19195e096c
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: implement nvme-fc IO command submission callback

This commit implements the NVMe-FC IO command submission callback for the
ibmvfc driver. It adds helpers to initialize commands, map scatterlists,
and submit the requests to the hardware queue.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index cf72f0682297b..d31e7e9ea7a9e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
[ ... ]
> +static void ibmvfc_nvme_done(struct ibmvfc_event *evt)
> +{
> +	struct ibmvfc_cmd *vfc_cmd =3D &evt->xfer_iu->cmd;
> +	struct nvmefc_fcp_req *fcp_req =3D evt->fcp_req;
> +	struct nvme_fc_ersp_iu *ersp =3D (struct nvme_fc_ersp_iu *)fcp_req->rsp=
addr;
> +	struct nvme_completion *cqe =3D &ersp->cqe;
> +	struct nvme_command *sqe =3D &((struct nvme_fc_cmd_iu *)fcp_req->cmdadd=
r)->sqe;
> +
> +	ibmvfc_dbg(evt->vhost, "fc_done: (%x:%x)\n", be16_to_cpu(vfc_cmd->statu=
s),
> +		   be16_to_cpu(vfc_cmd->error));
> +	ibmvfc_dbg(evt->vhost, "fc_done: cmdlen: %d, rsplen %d, payload_len %d\=
n",
> +		   fcp_req->cmdlen, fcp_req->rsplen, fcp_req->payload_length);
> +
> +	fcp_req->status =3D 0;
> +	if (!vfc_cmd->status) {
> +		fcp_req->rcv_rsplen =3D NVME_FC_SIZEOF_ZEROS_RSP;
> +		fcp_req->transferred_length =3D fcp_req->payload_length;
> +	} else if (be16_to_cpu(vfc_cmd->status) & IBMVFC_FC_NVME_STATUS) {
> +		fcp_req->rcv_rsplen =3D sizeof(struct nvme_fc_ersp_iu);
> +		fcp_req->transferred_length =3D be32_to_cpu(ersp->xfrd_len);
> +		if (be16_to_cpu(vfc_cmd->error) & IBMVFC_NVMS_VALID_NODMA_CQE)
> +			cqe->command_id =3D sqe->common.command_id;

[Severity: High]
Does this pass uninitialized or stale NVMe Completion Queue Entries (CQE) to
the NVMe-FC transport?

If the adapter skips the ERSP DMA (indicated by IBMVFC_NVMS_VALID_NODMA_CQE=
),
this forces the NVMe core to process the response buffer by setting
fcp_req->rcv_rsplen =3D sizeof(struct nvme_fc_ersp_iu). Since the host memo=
ry at
fcp_req->rspaddr is recycled and not zeroed by the NVMe core, could this ca=
use
the NVMe core to process stale cqe->status and cqe->result data without
verifying that IBMVFC_NVMS_VALID_ERSP was set?

> +	} else {
> +		fcp_req->rcv_rsplen =3D 0;
> +		fcp_req->transferred_length =3D 0;
> +		fcp_req->status =3D NVME_SC_INTERNAL;
> +	}
> +
> +	fcp_req->done(fcp_req);
> +	ibmvfc_free_event(evt);
> +}
> +
> +static struct ibmvfc_cmd *ibmvfc_nvme_init_vfc_cmd(struct ibmvfc_event *=
evt,
> +						   struct nvme_fc_remote_port *rport,
> +						   struct nvmefc_fcp_req *fcp_req)
> +{
> +	struct ibmvfc_target *tgt =3D rport->private;
> +	struct ibmvfc_cmd *vfc_cmd =3D &evt->iu.cmd;
> +
> +	memset(vfc_cmd, 0, sizeof(*vfc_cmd));
> +
> +	vfc_cmd->resp.va =3D cpu_to_be64(fcp_req->rspdma);
> +	vfc_cmd->resp.len =3D cpu_to_be32(fcp_req->rsplen);
> +	vfc_cmd->frame_type =3D cpu_to_be32(IBMVFC_NVME_FCP_TYPE);
> +	vfc_cmd->flags |=3D cpu_to_be16(IBMVFC_NVMEOF_PROTOCOL);
> +	vfc_cmd->payload_len =3D cpu_to_be32(fcp_req->cmdlen);
> +	vfc_cmd->resp_len =3D cpu_to_be32(fcp_req->rsplen);
> +	vfc_cmd->cancel_key =3D cpu_to_be32((u64)evt);

[Severity: Medium]
Does truncating the 64-bit evt pointer to a 32-bit cancel_key risk collisio=
ns?

Since events are allocated from per-queue DMA pools, is it possible for two
different event queues to be mapped at virtual memory addresses separated by
exactly 4GB? This would make their lower 32 bits identical, risking duplica=
te
cancel keys across multiple command queues and potentially aborting the wro=
ng
command.

> +	vfc_cmd->target_wwpn =3D cpu_to_be64(rport->port_name);
> +	vfc_cmd->tgt_scsi_id =3D cpu_to_be64(rport->port_id);
> +	vfc_cmd->assoc_id =3D cpu_to_be64(tgt->assoc_id);
> +
> +	memcpy(&vfc_cmd->v3nvme.iu, fcp_req->cmdaddr, fcp_req->cmdlen);
> +
> +	return vfc_cmd;
> +}
[ ... ]
> +static int ibmvfc_nvme_map_sg_data(struct nvmefc_fcp_req *fcp_req,
> +				    struct ibmvfc_event *evt,
> +				    struct ibmvfc_cmd *vfc_cmd)
> +{
> +	struct srp_direct_buf *data =3D &vfc_cmd->ioba;
> +	struct ibmvfc_host *vhost =3D evt->vhost;
> +
> +	if (!fcp_req->sg_cnt) {
> +		vfc_cmd->flags |=3D cpu_to_be16(IBMVFC_NO_MEM_DESC);
> +		return 0;
> +	}
> +
> +	if (fcp_req->io_dir =3D=3D NVMEFC_FCP_WRITE)
> +		vfc_cmd->flags |=3D cpu_to_be16(IBMVFC_WRITE);
> +	else
> +		vfc_cmd->flags |=3D cpu_to_be16(IBMVFC_READ);
> +
> +	if (fcp_req->sg_cnt =3D=3D 1) {
> +		ibmvfc_nvme_map_sg_list(fcp_req, data);
> +		return 0;
> +	}
> +
> +	vfc_cmd->flags |=3D cpu_to_be16(IBMVFC_SCATTERLIST);
> +
> +	if (!evt->ext_list) {
> +		evt->ext_list =3D dma_pool_alloc(vhost->sg_pool, GFP_ATOMIC,
> +					       &evt->ext_list_token);

[Severity: Critical]
Can this overflow the DMA pool buffer?

The vhost->sg_pool appears to hold a maximum of 128 items, but if the
transport advertises support for up to 1024 scatterlist segments
(.max_sgl_segments =3D 1024), ibmvfc_nvme_map_sg_list() will iterate up to =
1024
times. If fcp_req->sg_cnt exceeds 128, won't this write past the end of the
allocated buffer and corrupt adjacent memory?

> +
> +		if (!evt->ext_list)
> +			return -ENOMEM;
> +	}
> +
> +	ibmvfc_nvme_map_sg_list(fcp_req, evt->ext_list);
> +
> +	data->va =3D cpu_to_be64(evt->ext_list_token);
> +	data->len =3D cpu_to_be32(fcp_req->sg_cnt * sizeof(struct srp_direct_bu=
f));
> +	data->key =3D 0;
> +	return 0;
> +}
> +
>  static int ibmvfc_nvme_fcp_io(struct nvme_fc_local_port *lport,
>  			      struct nvme_fc_remote_port *rport,
>  			      void *hw_queue_handle,
>  			      struct nvmefc_fcp_req *fcp_req)
>  {
> -	return 0;
> +	struct ibmvfc_host *vhost =3D lport->private;
> +	struct ibmvfc_nvme_qhandle *qhandle =3D hw_queue_handle;
> +	struct ibmvfc_cmd *vfc_cmd;
> +	struct ibmvfc_event *evt;
> +	int rc;
> +
> +	ibmvfc_dbg(vhost, "nvme_fcp_io\n");
> +	evt =3D ibmvfc_get_event(qhandle->queue);
> +	if (!evt)
> +		return -EBUSY;
> +
> +	evt->hwq =3D qhandle->index;
> +	ibmvfc_dbg(vhost, "vfc-nvme-mq-%d\n", evt->hwq);
> +
> +	ibmvfc_init_event(evt, ibmvfc_nvme_done, IBMVFC_CMD_FORMAT);
> +	evt->fcp_req =3D fcp_req;
> +	fcp_req->private =3D evt;
> +
> +	vfc_cmd =3D ibmvfc_nvme_init_vfc_cmd(evt, rport, fcp_req);
> +
> +	vfc_cmd->correlation =3D cpu_to_be64((u64)evt);
> +
> +	if (likely(!(rc =3D ibmvfc_nvme_map_sg_data(fcp_req, evt, vfc_cmd))))
> +		return ibmvfc_send_event(evt, vhost, 0);

[Severity: Critical]
Could this lead to NVMe FCP requests being incorrectly processed as MAD
requests in error paths?

If ibmvfc_send_event() fails (e.g., due to a transport error) or if
ibmvfc_fail_request() is called during a queue purge, does the driver assume
that any event without a SCSI cmnd is a MAD request? Since NVMe FCP requests
lack a cmnd, it appears they might fall into legacy branches where an
uninitialized evt->_done is executed, or where mad_common.status (which
overlaps with NVMe's payload_len) is written to instead of vfc_cmd->status,
resulting in a crash or the request being completed as a false success.

[Severity: High]
Will this propagate SCSI midlayer error codes directly to the NVMe-FC core?

If ibmvfc_send_event() detects a transient queue closure, it returns
SCSI_MLQUEUE_HOST_BUSY. Since the NVMe-FC core expects standard Linux error
codes (like -EBUSY) from the fcp_io callback, will returning this positive
error code cause it to be translated to BLK_STS_IOERR, leading to spurious
hard failures instead of retrying the I/O?

> +
> +	ibmvfc_free_event(evt);
> +
> +	return rc;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D30
