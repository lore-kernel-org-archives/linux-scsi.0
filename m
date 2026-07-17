Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B970B3C4B93
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304554; cv=none; b=Hbq8BkVGyp06Ja9DNgYEOAUfZsKsPW1QjNhqBORRAnmwWWFoxndVwA0PX1xioFfCElb3+cPSzswzrquhDIkLkXbd/v4Zy2uj2XSkaJOvFCOvwo/cwnGOrXR/Z6OMBAps50rI5sFU1XVnF8gXprWioLolQP/Xv/okjk2CpHy4QW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304554; c=relaxed/simple;
	bh=u6NbIskttd4tmTbFtwMO11mU/3Feq/I+627w7ISi6kw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S1OUGSNik2vzVDtnSIQaeOrNtqbkLRikelw/jb3Qb28UofZfrUBnXy0iARVy4ySMr0C0llP598UkxnEDDfhIBki2nidleQut0sygq7QM5uoKtbFYaaSLKVTIyqid6ha+oCpUQ0Tx1uEXB3AEunpJ2fmFE5XtfdBhJD9pyZlpJc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcqzhNkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcqzhNkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B7A1F000E9;
	Fri, 17 Jul 2026 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304549;
	bh=fhxwyCY28UwsPfWB0Eh3dGur+Md5dtiimGx9Lt1jM6s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fcqzhNkRjyMKZm2odmXUIB7ffojkyHpWEfS3CpXmJuzHEVwwxxojM95k1duBTsd6j
	 UD7G87JjpENjG6ijjOFvUv40ukJrxVw9lUA0i+6fhyrBw1z29wUxzcfUfYJzUPlcAo
	 iGojN9yZxoxBRJ/uI8PrefIqQtjn8ElJEHCY/tFGLdIl2BdHrpYlGGPu50+kU2O6yc
	 qaYwobrvNZXti3aPoQBSI97B8Yowj9PhyPIRRsVIYFUEKyYpZ+OcIUDmVH/VyWPha7
	 YK7RHlCEd5pL5LrvvY/Uj1A9uhQbwkyt9B2HowYtmgaQvVmf4lqrecck+gs6h6BLPH
	 pV3y9LthZeurw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/56] scsi: qla2xxx: Add 29xx support in queue
 initialisation path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-5-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-5-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:09:08 +0000
Message-Id: <20260717160908.E1B7A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Critical] The patch intentionally introduces broken pointer arithmetic a=
nd structure size mismatches for QLA29XX hardware, severely breaking bisect=
ability.
- [Critical] Base queues are allocated with 64-byte entries, but initialize=
d as 128-byte entries on 29xx hardware, causing severe DMA out-of-bounds ac=
cess.

Pre-existing issues:
- [High] Unconditional call to dma_free_coherent() with a NULL virtual addr=
ess in the queue allocation error paths.
- [High] A queue ID is cleared twice during initialization failure and its =
mapping is nullified without locks, causing a race condition that silently =
destroys a concurrently allocated queue.
- [High] If the firmware is unresponsive during teardown, queue deletion ab=
orts and permanently leaks DMA memory and host structs.
--

--- Patch [4]: [PATCH v5 04/56] scsi: qla2xxx: Add 29xx support in queue in=
itialisation path ---
commit eb9f04cb3a041d8d7db2e1662875c85a2485be0c
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add 29xx support in queue initialisation path

Extend the queue initialisation and multi-queue management mailbox
commands to include IS_QLA29XX() checks, following the same mailbox
interface as 27xx/28xx. Unlike earlier adapters that use 64-byte
request/response ring entries, 29xx uses 128-byte entries.

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
This isn't a bug introduced by this patch, but if dma_alloc_coherent()
fails in qla25xx_create_req_que() or qla25xx_create_rsp_que(), the code
branches to the que_failed label and calls qla25xx_free_req_que() or
qla25xx_free_rsp_que().

Will this unconditionally call dma_free_coherent() with a NULL virtual
address for req->ring or rsp->ring? Could this trigger a kernel oops or
WARN during low memory conditions?

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
The commit message notes that pointer arithmetic for the wider entries is
handled by later patches in the series.

Does this mean this commit leaves req->out_ptr and rsp->in_ptr using 64-byte
pointer arithmetic on a 128-byte stride ring during initialization?

Could this place the DMA pointers exactly halfway through the allocated
ring buffer instead of at the end, causing the hardware to read and write
out of bounds, and potentially breaking bisectability if this specific comm=
it
is tested on QLA29XX adapters?

[Severity: Critical]
While this allocates 128-byte stride entries for multi-queues on 29xx
hardware, what happens to the primary base queues (queue 0)?

Looking at qla2x00_mem_alloc() in qla_os.c, the base queues still appear to
be allocated with a hardcoded sizeof(request_t) which is 64 bytes.

When the driver probes the 29xx hardware and initializes these base queues
with a 128-byte stride, could the hardware read and write past the end of t=
he
allocated DMA buffers?

[Severity: High]
This is a pre-existing issue, but looking at the error path in
qla25xx_create_req_que():

If qla25xx_init_req_que() fails, the code clears que_id from ha->req_qid_map
while holding ha->mq_lock, and then calls qla25xx_free_req_que().

Inside qla25xx_free_req_que():

    if (que_id) {
        ha->req_q_map[que_id] =3D NULL;
        mutex_lock(&ha->vport_lock);
        clear_bit(que_id, ha->req_qid_map);
        ...
    }

Could a concurrent thread re-allocate this same que_id before
qla25xx_free_req_que() sets ha->req_q_map[que_id] =3D NULL without holding
mq_lock? Would this silently destroy the concurrent allocation's queue poin=
ter
and clear the bit again using the wrong lock (vport_lock)?

[Severity: High]
This is also a pre-existing issue, but looking at queue teardown:

In qla25xx_delete_req_que(), the driver attempts to notify the firmware by
calling qla25xx_init_req_que().

If the firmware is unresponsive (e.g. due to a crash or PCI error), does
this function return early and skip calling qla25xx_free_req_que()?

Furthermore, in qla25xx_delete_queues(), the loop processing all queues
aborts on the first failure. Could this permanently leak all subsequent
struct req_que allocations and their large DMA rings, leading to DMA pool
exhaustion after device resets?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D4
