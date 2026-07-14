Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345AF371D1F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 10:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024901; cv=none; b=lzQ89XG5SrUDy5FIoVLtrOcPa8m8sHWBF5m3vbgv5kqnZshKxO2NP97WQm713RddFVx6Pm3upQpQZAzq9bdaQHaOXrTKl/lSMVpgumdCwubf5l3VCQbAH2vbnHsbygqQGiAFwQROOLQ6gFy+QlE2k8lmvRXX7oQd1BYqYgEqheM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024901; c=relaxed/simple;
	bh=U0XCjeEpZxGyzKOSL7HHbEZ4MICKoLZJ7YnrEvb2P7c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OCcd0MTdyjK2WKupSkuLDWmcTDC2E3ULrtBkuhcF0MAplpn2qF9o8EIQHobuLettFNToCTgG+kZInagRcTpxumgvFKoXzlayTi4NhwIk7wjNr/0m9oczpTnMmckPic/iFnZtKIVawSG1SJ1hBopo5Bq0CiPSJHsZNXE/fWw9tHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTX2iY9g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTX2iY9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973661F000E9;
	Tue, 14 Jul 2026 10:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784024899;
	bh=xtZ+dvn/P4Bm0HD5n+c+sUMZqqq96qpgLPPx9PZJZAo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GTX2iY9gOBzvzQJl8cNUsPtaSIt1/ZbGq+RTF223quwqzLDFhorA+GKWqFZCOoR8G
	 4oPRymlcbd7/v+q8iffFFphX4GB/BLpxTa9hCBFmXoBFJzgTfHDUkeKneTzyAl2Gwb
	 JwBzMfxdMGMRfBpOVGniQlMQCcAN4+JbAfBw5NJnY7DsMAo9YDJFCbAz250BpOlQMr
	 8NszxL6+fVfwIzXytQsUqTGaOEqVZaqClaW0DFaWoqD0mzZjY8CofGwTqCSAJ3jy+l
	 AYBXajQLe1kCXc9eY2ohhEJile2ysxa9NwZya+eAtgkc2sBuT9TBRKGp7NKWpsRrtr
	 MOAuV4OVlhC1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 04/56] scsi: qla2xxx: Add 29xx support in queue
 initialisation path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-5-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-5-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:28:19 +0000
Message-Id: <20260714102819.973661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [Critical] Base queue DMA rings (Queue 0) are undersized for 29xx hardwar=
e, which will lead to firmware reading and writing out-of-bounds memory.
- [Critical] Response queue lockless synchronization signatures are imprope=
rly initialized for 29xx, leaving half the ring buffer zero-initialized and=
 vulnerable to phantom processing.
- [High] Mismatched queue pointer arithmetic for QLA29XX introduces hardwar=
e synchronization failures, queue stalls, and breaks bisectability.

Pre-existing issues:
- [High] The queue cleanup paths blindly pass a potentially NULL pointer to=
 `dma_free_coherent()`, triggering a kernel crash if the initial queue allo=
cation fails.
- [High] Inconsistent locking between `vport_lock` and `mq_lock` when manag=
ing dynamic queue IDs and queue maps.
- [High] Uninitialized kernel stack memory is written to hardware mailbox r=
egisters.
--

--- Patch [4]: [PATCH v4 04/56] scsi: qla2xxx: Add 29xx support in queue in=
itialisation path ---
commit 13a40ca7120445e92ae33446755917919989aa14
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add 29xx support in queue initialisation path

This patch extends queue initialization and mailbox commands to support the
QLA29XX hardware. It introduces 128-byte request and response structures and
doubles the DMA ring memory allocated for multi-queues.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 2d052f870b2bc..2b232b225c900 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4584,7 +4584,8 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, str=
uct req_que *req)
>  	mcp->mb[12] =3D req->qos;
>  	mcp->mb[11] =3D req->vp_idx;
>  	mcp->mb[13] =3D req->rid;
> -	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
> +	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
> +	    IS_QLA29XX(ha))
>  		mcp->mb[15] =3D 0;

[Severity: High]
This is a pre-existing issue, but does this leak uninitialized kernel stack
memory to the hardware mailbox?

The mbx_cmd_t structure is allocated on the stack but not zero-initialized:

mbx_cmd_t mc;
mbx_cmd_t *mcp =3D &mc;

Several mailbox fields (like mcp->mb[14]) are left unwritten, yet their
corresponding validity bits (MBX_14) are set in the mcp->out_mb bitmask:

mcp->out_mb =3D MBX_14|MBX_13|MBX_12|MBX_11|MBX_10|...

When qla2x00_mailbox_command() iterates over the out_mb mask, does it read
these uninitialized stack values and issue them directly to the hardware via
wrt_reg_word()?

[ ... ]

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

[Severity: High]
This is a pre-existing issue, but can this trigger a kernel panic if the
initial allocation fails?

If memory pressure causes dma_alloc_coherent() to return NULL during queue
creation, the error path executes this cleanup and passes the NULL req->ring
pointer directly into dma_free_coherent().

[Severity: High]
This is a pre-existing issue, but is there a data race in the queue ID
cleanup later in this function?

Dynamic queue ID allocation in qla25xx_create_req_que() protects the
ha->req_qid_map read-modify-write cycle using mutex_lock(&ha->mq_lock).
However, the cleanup path clears the map globally without holding mq_lock
and clears the bitmap using vport_lock:

ha->req_q_map[que_id] =3D NULL;
mutex_lock(&ha->vport_lock);
clear_bit(que_id, ha->req_qid_map);
mutex_unlock(&ha->vport_lock);

Could this corrupt the queue tracking structures when racing against queue
creation?

>  	req->ring =3D NULL;
>  	req->dma =3D 0;
>  	if (que_id) {

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
>  	dma_free_coherent(&ha->pdev->dev, (rsp->length + 1) *
> -		sizeof(response_t), rsp->ring, rsp->dma);
> +			  rspsz, rsp->ring, rsp->dma);

[Severity: High]
This is a pre-existing issue, but passing a potentially NULL rsp->ring poin=
ter
into dma_free_coherent() can also trigger a wild pointer dereference here if
queue creation fails.

>  	rsp->ring =3D NULL;
>  	rsp->dma =3D 0;
>  	if (que_id) {

[ ... ]

> @@ -706,6 +715,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16=
_t options,
>  	uint16_t que_id =3D 0;
>  	device_reg_t *reg;
>  	uint32_t cnt;
> +	uint16_t reqsz;
> =20
>  	req =3D kzalloc_obj(struct req_que);
>  	if (req =3D=3D NULL) {
> @@ -714,9 +724,12 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint1=
6_t options,
>  		goto failed;
>  	}
> =20
> +	reqsz =3D IS_QLA29XX(ha) ? sizeof(struct request_ext) :
> +				 sizeof(request_t);
> +
>  	req->length =3D REQUEST_ENTRY_CNT_24XX;
>  	req->ring =3D dma_alloc_coherent(&ha->pdev->dev,
> -			(req->length + 1) * sizeof(request_t),
> +			(req->length + 1) * reqsz,
>  			&req->dma, GFP_KERNEL);

[Severity: Critical]
Does this leave the base DMA rings (Queue 0) undersized for 29xx hardware?

While this patch updates MQ allocations here to use 128-byte strides (reqsz=
),
the base queue allocations in qla_os.c:qla2x00_mem_alloc() appear to still =
be
hardcoded to sizeof(request_t) (64 bytes).

Since 29xx hardware expects 128-byte entries across all rings, won't the
firmware perform out-of-bounds DMA read/writes into a buffer sized for
64-byte entries, potentially corrupting adjacent physical memory?

[Severity: High]
Does deferring shadow pointer calculation updates to later patches break
bisectability and cause hardware synchronization failures?

The commit message notes pointer arithmetic is handled by later patches.
However, since req->ring is a request_t * (64 bytes), calculations later in
this initialization sequence like:

req->out_ptr =3D (uint16_t *)(req->ring + req->length);

will use 64-byte pointer arithmetic. For 29xx, which expects a 128-byte
stride, this pointer lands in the middle of the active ring buffer instead
of the trailing slot. Is it safe to allocate 128-byte strides here without
simultaneously updating the shadow pointer calculations?

>  	if (req->ring =3D=3D NULL) {
>  		ql_log(ql_log_fatal, base_vha, 0x00da,

[ ... ]

> @@ -833,6 +846,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16=
_t options,
>  	struct scsi_qla_host *vha =3D pci_get_drvdata(ha->pdev);
>  	uint16_t que_id =3D 0;
>  	device_reg_t *reg;
> +	uint16_t rspsz;
> =20
>  	rsp =3D kzalloc_obj(struct rsp_que);
>  	if (rsp =3D=3D NULL) {
> @@ -841,9 +855,12 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint1=
6_t options,
>  		goto failed;
>  	}
> =20
> +	rspsz =3D IS_QLA29XX(ha) ? sizeof(struct response_ext) :
> +				 sizeof(response_t);
> +
>  	rsp->length =3D RESPONSE_ENTRY_CNT_MQ;
>  	rsp->ring =3D dma_alloc_coherent(&ha->pdev->dev,
> -			(rsp->length + 1) * sizeof(response_t),
> +			(rsp->length + 1) * rspsz,
>  			&rsp->dma, GFP_KERNEL);

[Severity: Critical]
Does this cause phantom processing of zero-initialized memory due to
mismatched buffer strides?

This patch provisions 128-byte strides (rspsz) for QLA29XX, but
qla2x00_init_response_q_entries() populates the RESPONSE_PROCESSED signature
by stepping linearly using pkt++ on a 64-byte response_t * pointer:

for (cnt =3D 0; cnt < rsp->length; cnt++) {
    pkt->signature =3D RESPONSE_PROCESSED;
    pkt++;
}

Won't this only write the signatures into the first half of the 128-byte
structures (hitting the reserved space) and leave the second half zeroed?

Since 0 !=3D RESPONSE_PROCESSED, will the driver's interrupt handler falsely
interpret these zeroes as valid incoming firmware responses?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D4
