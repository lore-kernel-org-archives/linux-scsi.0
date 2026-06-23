Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321761FB1
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 02:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180554; cv=none; b=TIKbQycSwaR2y86mGq27wE6YAb6Ob+IlFsz0wdy2ihZvA+zQaFkPNmijp9coUP2dab3WDQZ740SpeQLtNyDO4jDNEkqDTb9I9GhR92r2rnOMoyWutwu7TRKCCahB34ZC7fSCOKgb02ltE6URCbRqn+HERuY4uzm2Ww2b528inOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180554; c=relaxed/simple;
	bh=U0VsYD0BYUD6mO/FRF3Rcb3qA4zAl9GYDZ5OJ60754M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HM/exHt+XEHTL7MEJUh7TlysLfN1R1wXh2FEu+KUTv/pZORplb39aZqDHuKkZRTqyjLmNb5br5t1IMekFe82aYUORGlzC2qoEDUjvzqU4BjJSQ+IsTSbgzIo12xlZB9DTG3A+3FWDR30M9EymLjX/hvvYUzpXjEVrgmd7EpnFFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqcAYidV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqcAYidV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B411F000E9;
	Tue, 23 Jun 2026 02:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782180552;
	bh=ONQJWoYbX93X16D/MIVYTnLP46cO/Ouye28bJOPwL0Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eqcAYidVj/EPgY7iRv7nUlxYVhPP3x7aH8uGQmo/9sNRthk2EDGNWLflEBT7UQwFg
	 qLlgtAKjqGtO5nH4/6SxA9BAiT2aQ40Yad4s+OTDZ5Cf0eZTIsChyrUG7KtbJLBX86
	 kIf/K4hpnsuVctIYWO1GNi89Y+Uqd1StJFMHY4hWVIuqzOB5NQSGtC4z5CXCNiXQ8z
	 eEeASrJ4OwyrjzaOxSJ4amM5uUO1hf4xtm5Fm4xFWyJT1Ffx9CIdyR/7XexsfU0c4j
	 23bhDgsADKnFwuziWKIOusSOsKm1wry7pflkiUjvaoX/0uZQGsyAFQsIRVHQCfmTOF
	 gfM4lS8tRQ6sw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 26/29] ibmvfc: implement nvme-fc IO command submission
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-27-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-27-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 02:09:11 +0000
Message-Id: <20260623020912.49B411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Buffer overflow in NVMe scatterlist mapping when sg_cnt exceeds SG=
_ALL.
- [High] Returning SCSI-specific or bare memory allocation errors from `fcp=
_io` causes the NVMe-FC core to permanently fail retriable commands.
- [High] Overwriting `fcp_req->private` causes an invalid `kfree` of an int=
erior pool pointer and a memory leak.
- [High] Stale data is read from the ERSP buffer when the target responds w=
ith `IBMVFC_NVMS_VALID_NODMA_CQE`.
--

commit 6b37a58cc483eca7d86fda91190fd35dfdfe359a
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: implement nvme-fc IO command submission callback

This commit adds helpers to initialize an ibmvfc command from an
nvmefc_fcp_req. It handles scatterlist mapping, submits the request on
the NVMe hardware queue, and handles command completion translation.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index 506135c1a34e3..bff469d0b47df 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c

[ ... ]

> @@ -164,12 +165,149 @@ static void ibmvfc_nvme_ls_abort(struct nvme_fc_lo=
cal_port *lport,
>  {
>  }
> =20
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
Does this code read stale data from the ERSP buffer when the target
responds with IBMVFC_NVMS_VALID_NODMA_CQE?

If the completion queue entry was not DMA'd into the ersp buffer,
ersp->xfrd_len, cqe->status, and cqe->result are not initialized,
but this path proceeds to use be32_to_cpu(ersp->xfrd_len) to set the
transferred length.

Since the NVMe-FC core reuses the request structure without zeroing
the rspaddr buffer between commands, this can cause the driver to
read stale data from previous commands, resulting in data corruption
and validation failures.

> +	} else {
> +		fcp_req->rcv_rsplen =3D 0;
> +		fcp_req->transferred_length =3D 0;
> +		fcp_req->status =3D NVME_SC_INTERNAL;
> +	}
> +
> +	fcp_req->done(fcp_req);
> +	ibmvfc_free_event(evt);
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
> +
> +		if (!evt->ext_list)
> +			return -ENOMEM;
> +	}
> +
> +	ibmvfc_nvme_map_sg_list(fcp_req, evt->ext_list);

[Severity: High]
Can this cause a buffer overflow when fcp_req->sg_cnt exceeds SG_ALL?

The NVMe-FC transport template sets max_sgl_segments to 1024, allowing
requests with up to 1024 scatterlist elements.

However, the external list is allocated from vhost->sg_pool, which is
sized at SG_ALL (128) elements. If fcp_req->sg_cnt is greater than 128,
ibmvfc_nvme_map_sg_list() will iterate up to sg_cnt and write
out of bounds, corrupting adjacent DMA pool memory.

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

[Severity: High]
Could overwriting fcp_req->private cause an invalid kfree and memory leak?

The NVMe-FC core allocates the private area for the driver (specified by
fcprqst_priv_sz) and stores the pointer in fcp_req->private. For
Asynchronous Event Notifications (AENs), this memory is allocated via
kzalloc.

By overwriting the private pointer with evt here, during controller resets
or teardown, the NVMe-FC core will call kfree(aen_op->fcp_req.private).
Because the pointer now points to evt (which resides within the contiguous
pool->events array), this results in freeing an interior pointer, triggering
a kernel bug.

> +
> +	vfc_cmd =3D ibmvfc_nvme_init_vfc_cmd(evt, rport, fcp_req);
> +
> +	vfc_cmd->correlation =3D cpu_to_be64((u64)evt);
> +
> +	if (likely(!(rc =3D ibmvfc_nvme_map_sg_data(fcp_req, evt, vfc_cmd))))
> +		return ibmvfc_send_event(evt, vhost, 0);
> +
> +	ibmvfc_free_event(evt);
> +
> +	return rc;

[Severity: High]
Does returning rc directly bypass the expected -EBUSY retry mechanism?

The ibmvfc_nvme_fcp_io callback can return -ENOMEM from map_sg_data or
SCSI_MLQUEUE_HOST_BUSY (0x1055) from ibmvfc_send_event on temporary
allocation or queue closure failures.

The NVMe-FC core expects fcp_io to return exactly -EBUSY to trigger a
requeue (BLK_STS_RESOURCE). For any other non-zero return value,
nvme_fc_start_fcp_op returns BLK_STS_IOERR, translating transient
hardware constraints into permanent I/O errors and data loss for the
application.

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D26
