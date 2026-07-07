Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7698345CCE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405878; cv=none; b=TlLZTiFi+UHN4DbFcLoYpoV03X+7kTNCxI48x6Mzpys7oIzmWga0ux7ENQQvJeKVuXURzcxgDmWSHzeSzhPWPAsCmy8sGPa6yp6qdkLSttFDdRN1xeFaPE1kLnDAhuoSlDnbGn/X6flAn8vpQrEloXEr9PxzfEpo+9xdKRpzSxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405878; c=relaxed/simple;
	bh=bfHZSmc06RWJDNObDl2HazKKm7k6n5qXeQxAS6aXyEo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r2xaMVQyk9wla5lP8HtsgxJFxlZ9l+gvy9JdkXEYP4gdc3SZG+mO1uiSDWTbomN3h/JPXdkKeKdQnBlHLqR+g3EFBCmdULaTalR7KqG3/Yq/n58JxE98bc/wlau6B6eJxm5yqLPi6BKYzl/SocffYxrhNjsAiO9EALOBfNRenxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLz3MMEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLz3MMEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D5B1F000E9;
	Tue,  7 Jul 2026 06:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405876;
	bh=xTq97qMcy2qZOgn6VcpIf4aDnsC2nQyPACDlXxeCPtM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mLz3MMEXOWsB3vueoqlT8ZNFGlDXeV0532uJSVi1+AvLj3Lxw88zPIj0+5U0qinAM
	 fYwlmNrI42aLzyRjfS9IgaIdn6Md9vJv69PFrJvB3Z3eEjYPmwCVP4VkrV6sFY9Qzn
	 2+eheaBSBe/+ShemuhXmWQrPFAQPksuwo8GPYfoX6Po1yZXWM6vuJOVqmM0BL3vzmq
	 nJwrERdHdTWEfkxM8qyWLfKLPDa/gKjv9R19lWhHTbzBLrqJCEn8oqArQA7BMcqo4B
	 Ygm2CQaRy8sGBiEAXrMmE6jWfr9X3WjwOdV/psV8VkZ7fn3zJTH4FyW86YwH5bUby5
	 cxj9DnhtvKsWg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/88] scsi: qla2xxx: Add 29xx support in queue
 initialisation path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-5-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-5-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:31:15 +0000
Message-Id: <20260707063116.53D5B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Critical] The base queue (queue 0) allocation in `qla2x00_mem_alloc()` i=
s not updated to allocate 128-byte entries for QLA29XX, leading to hardware=
 DMA overruns.
- [Critical] The patch enlarges queue DMA buffers to 128-byte strides for 2=
9xx but retains 64-byte pointer arithmetic, corrupting shadow pointers and =
fast-path iteration.

Pre-existing issues:
- [High] Inconsistent locking protecting the multiqueue mappings (`req_q_ma=
p`/`req_qid_map` and `rsp_q_map`/`rsp_qid_map`) leads to data races.
- [High] Pending response queue work (`qpair->q_work`) is not canceled befo=
re freeing the queue and its lock, leading to a Use-After-Free.
--

--- Patch [4]: [PATCH v3 04/88] scsi: qla2xxx: Add 29xx support in queue in=
itialisation path ---
commit 4452b9447592dcc921780bd1cb74d843e0bd2ad1
Author: Manish Rangankar <mrangankar@marvell.com>
Subject: scsi: qla2xxx: Add 29xx support in queue initialisation path

This patch extends queue initialization to support the larger 128-byte
entries used by the 29xx adapters. It adds extended request and response
structures and updates the queue allocation sizes accordingly.

>     The enlarged entry stride doubles the DMA ring memory allocated for
>     both request and response queues on 29xx, and all ring pointer
>     arithmetic must account for the wider entries (handled by later
>     patches in this series).

[Severity: Critical]
Since the current patch enlarges the queue DMA buffers but leaves pointer
arithmetic for later patches, will shadow pointer calculations use the lega=
cy
64-byte stride in the meantime?

For example, in qla25xx_create_req_que() and qla25xx_create_rsp_que():

    req->out_ptr =3D (uint16_t *)(req->ring + req->length);
    rsp->in_ptr =3D (uint16_t *)(rsp->ring + rsp->length);

Because req->ring is a 64-byte typed pointer, this will point to the middle
of the 128-byte stride array, which may miscalculate the hardware shadow
index. Additionally, fast-path iterations like rsp->ring_ptr++ in
qla24xx_process_response_queue() will implicitly advance by 64 bytes instead
of 128 bytes, which could cause the driver to interpret the zeroed padding
as the next response.

[Severity: Critical]
Also, it looks like the base queue allocation in qla2x00_mem_alloc() is not
updated to use the new 128-byte size:

    (*req)->ring =3D dma_alloc_coherent(&ha->pdev->dev,
        ((*req)->length + 1) * sizeof(request_t),
        &(*req)->dma, GFP_KERNEL);

Could this cause hardware DMA overruns during device probe if the base queue
is allocated at half the required size for a 29xx adapter? Is it safe to
separate these changes from the pointer arithmetic and base queue allocation
updates in the series?

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index c563133f751e8..e75b7ae22bc52 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -574,9 +574,13 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, stru=
ct req_que *req)
>  {
>  	struct qla_hw_data *ha =3D vha->hw;
>  	uint16_t que_id =3D req->id;
> +	uint16_t reqsz;
> +
> +	reqsz =3D IS_QLA29XX(ha) ? sizeof(struct request_ext) :
> +				 sizeof(request_t);
> =20
>  	dma_free_coherent(&ha->pdev->dev, (req->length + 1) *
> -		sizeof(request_t), req->ring, req->dma);
> +			  reqsz, req->ring, req->dma);
>  	req->ring =3D NULL;
>  	req->dma =3D 0;
>  	if (que_id) {

[Severity: High]
This is a pre-existing issue, but is there a data race when cleaning up
these queues?

In qla25xx_create_req_que(), the queue map allocations are protected by
ha->mq_lock. However, in qla25xx_free_req_que() and qla25xx_free_rsp_que(),
it looks like ha->req_q_map is modified without locks, and ha->req_qid_map
is cleared using ha->vport_lock:

    ha->req_q_map[que_id] =3D NULL;
    mutex_lock(&ha->vport_lock);
    clear_bit(que_id, ha->req_qid_map);
    mutex_unlock(&ha->vport_lock);

Could this mismatch allow concurrent queue creation and teardown to race,
potentially leading to array corruption or dual-allocation of the same
queue ID?

[ ... ]

> @@ -594,6 +598,10 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, stru=
ct rsp_que *rsp)
>  {
>  	struct qla_hw_data *ha =3D vha->hw;
>  	uint16_t que_id =3D rsp->id;
> +	uint16_t rspsz;
> +
> +	rspsz =3D IS_QLA29XX(ha) ? sizeof(struct response_ext) :
> +				 sizeof(response_t);
> =20
>  	if (rsp->msix && rsp->msix->have_irq) {
>  		free_irq(rsp->msix->vector, rsp->msix->handle);
> @@ -601,8 +609,9 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struc=
t rsp_que *rsp)
>  		rsp->msix->in_use =3D 0;
>  		rsp->msix->handle =3D NULL;
>  	}
> +

[Severity: High]
This isn't a bug introduced by this patch, but does this teardown path
need to cancel pending response queue work before freeing the DMA memory?

It looks like cancel_work_sync(&qpair->q_work) is not called before
dma_free_coherent() or before kfree(qpair) later on. If an interrupt fires
and queues the work just before free_irq(), could qla_do_work() execute
concurrently and try to access the freed qpair->rsp memory, resulting in a
use-after-free?

>  	dma_free_coherent(&ha->pdev->dev, (rsp->length + 1) *
> -		sizeof(response_t), rsp->ring, rsp->dma);
> +			  rspsz, rsp->ring, rsp->dma);
>  	rsp->ring =3D NULL;
>  	rsp->dma =3D 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D4
