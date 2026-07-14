Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647DB3890E0
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 16:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784044979; cv=none; b=LrR05x7A8ZJ8ZK0N3BDbKkg0asI9NfOtDls0VxFvkObK9cR8Htiegs/MAAR2qCGPDQah/oBNStM93Zk1vwX9GJLWypXT6sOXJzC6ocDFr8839hs8RncRR52HAB/tySj4MyJ1EPn/MZ+HUgpXKNUwMUF89GYHBCz5zTHwUYwG+z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784044979; c=relaxed/simple;
	bh=DlhRYvLAhmnEf+dzxsC8Phj1dj/eoO7NJbJfsOeO01Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QpNd4HXAkfTxRtZtcv1LJGqyCaaR8wMs79myZSrlyebZiT1IPdspGm56vNDigExg76h2laLz5ZTata/0H/rGtnuKE26FZ0kN6jmZGfRbcOsBY0AosBdZ0esRpUPOL5LXSoIfljDnW4c4Q0hFvMgkEBQ1xEy+VyDeNaZZOxGCQpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsAduPnr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsAduPnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1921F000E9;
	Tue, 14 Jul 2026 16:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784044978;
	bh=xFw5Z+FRKTtv6Sj99xC1SG5oBDNQlwrzQwmZV3tu++8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lsAduPnr1onrDgG0pcZKFoXcLr02TnRhuOnON3dx71BI+BAn19lQj44hQZU7IyR45
	 3tTZ7m5HSoLH+mIZIdn5mHKsdJZ3iya2BCEXAGkZJ9v0al4S7kmcnYtVNzukR3i4tO
	 pwZAwk27PF5kfoAynzfA0OAxtqFczsC948OOmjiEulqAsaIyqmHXo9DbvQ3sJD1aiY
	 Lvp9fy2FBfLTycyEiokpCykz/yKCMI64VvE6jBkxBdGL8mGj/xb4akTi5BdG8Yslw5
	 YxrsM+NSS88bkjt/BoM9/a+x6P2EdvCjHgACt7XAbuV8Tz6RtRg+cX5219+f1FUM9k
	 hXjZi9FeEauDg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 40/56] scsi: qla2xxx: Fix queue teardown NULL
 dma_free and bitmap locking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-41-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-41-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 16:02:57 +0000
Message-Id: <20260714160258.0E1921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing cancellation of `qpair->q_work` during queue pair teardown=
 leads to Use-After-Free of `qpair`.
- [High] DMA memory for queues is freed before safely clearing the queue po=
inters, leading to a race condition and Use-After-Free by concurrent reader=
s like firmware dump.
- [High] Hardware-supplied queue indices are used to index `ha->req_q_map` =
prior to bounds validation, leading to Out-of-Bounds Read.
- [Medium] Host memory and DMA mappings are leaked during teardown if queue=
s were allocated but not started in hardware.
--

--- Patch [40]: [PATCH v4 40/56] scsi: qla2xxx: Fix queue teardown NULL dma=
_free and bitmap locking ---
commit 00cbb695fac148d9ec27ea62ef3a784eac6e57fb
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking

This patch fixes a potential panic when freeing uninitialized DMA memory on
error paths. It also adds locking to prevent concurrent queue ID allocation
races.

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index bb2521c052bf8..7072af5b42178 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -576,16 +576,17 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, str=
uct req_que *req)
>  	uint16_t que_id =3D req->id;
>  	size_t req_entry_size =3D qla_req_entry_size(ha);
> =20
> -	dma_free_coherent(&ha->pdev->dev,
> -			  (req->length + 1) * req_entry_size,
> -			  req->ring, req->dma);
> +	if (req->ring)
> +		dma_free_coherent(&ha->pdev->dev,
> +				  (req->length + 1) * req_entry_size,
> +				  req->ring, req->dma);

[Severity: High]
This is a pre-existing issue, but does freeing the DMA memory here before
clearing the queue pointer create a race condition?

If a firmware dump occurs concurrently (e.g., triggered by a mailbox timeou=
t),
it executes qla27xx_fwdt_entry_t263() under hardware_lock and reads
from ha->req_q_map[i]. It could then copy from req->ring via
qla27xx_insertbuf() after the memory has been freed here.

Would it be safer to nullify ha->req_q_map[que_id] before calling
dma_free_coherent()?

>  	req->ring =3D NULL;
>  	req->dma =3D 0;
>  	if (que_id) {
> +		mutex_lock(&ha->mq_lock);
>  		ha->req_q_map[que_id] =3D NULL;
> -		mutex_lock(&ha->vport_lock);
>  		clear_bit(que_id, ha->req_qid_map);
> -		mutex_unlock(&ha->vport_lock);
> +		mutex_unlock(&ha->mq_lock);
>  	}
>  	kfree(req->outstanding_cmds);
>  	kfree(req);

[ ... ]

> @@ -605,16 +606,17 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, str=
uct rsp_que *rsp)
>  		rsp->msix->handle =3D NULL;
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but is it possible for a pending
work item to execute after the qpair is destroyed?

The interrupt handler qla2xxx_msix_rsp_q() queues qpair->q_work on the
workqueue. During teardown, we free the IRQ here, but the already-queued
work doesn't appear to be flushed or cancelled before qla2xxx_delete_qpair()
frees the qpair structure.

When the work eventually executes, qla_do_work() resolves the qpair:

qla_do_work() {
    struct qla_qpair *qpair =3D container_of(work, struct qla_qpair, q_work=
);
    ...
}

Could this lead to a use-after-free if the work runs after the qpair is
freed?

> -	dma_free_coherent(&ha->pdev->dev,
> -			  (rsp->length + 1) * rsp_entry_size,
> -			  rsp->ring, rsp->dma);
> +	if (rsp->ring)
> +		dma_free_coherent(&ha->pdev->dev,
> +				  (rsp->length + 1) * rsp_entry_size,
> +				  rsp->ring, rsp->dma);

[ ... ]

While reviewing the queue teardown paths, I also noticed a few other
pre-existing issues in the driver:

[Severity: Medium]
This is a pre-existing issue, but does qla25xx_delete_req_que() leak memory
if the queues were allocated but never started?

In qla25xx_delete_req_que():

qla25xx_delete_req_que() {
    ...
    if (req && vha->flags.qpairs_req_created) {
        req->options |=3D BIT_0;
        ret =3D qla25xx_init_req_que(vha, req);
        if (ret !=3D QLA_SUCCESS)
            return QLA_FUNCTION_FAILED;

        qla25xx_free_req_que(vha, req);
    }
}

If qpairs_req_created is false (such as during a driver initialization
failure or if startqp was false), the check fails and we never call
qla25xx_free_req_que(), which appears to leak the req structure and its DMA
mappings.

[Severity: High]
This is a pre-existing issue, but is it safe to use the hardware-supplied
queue index before validating it?

In qla2x00_status_entry(), the hardware returns sts->handle which is
used to look up the queue:

qla2x00_status_entry() {
    ...
    que =3D MSW(sts->handle);
    req =3D ha->req_q_map[que];

    /* Check for invalid queue pointer */
    if (req =3D=3D NULL ||
        que >=3D find_first_zero_bit(ha->req_qid_map, ha->max_req_queues)) {
        ...
}

The index que is used to access ha->req_q_map before checking if it is
within bounds. A similar pattern exists in qlafx00_status_entry() where
req is dereferenced before validation. Could a corrupted handle from
the firmware cause an out-of-bounds read here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D40
