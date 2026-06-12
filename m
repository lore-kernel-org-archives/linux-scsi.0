Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F346E3EE1C4
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781270593; cv=none; b=W9tzXx4540Js+0u64Pm5RLbPNwzIN0rw/QtwoUDpWW3OekfbGWsdJfr/ZNw50ABD8EeRqHNrUpelxRPVUo5BK6SUiOnFdm24in4KDSGpR+heXwPD4W8cO0HDemDQgFMYJo0uKezxKe21WsZs0c/dABCZqi8ekZaoUoejy0QPCV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781270593; c=relaxed/simple;
	bh=ACQ+PD6GUcfqCJxNtsRb5qjm1rKq1JksbjEuR288ijQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=opLrxeE1TysOEM77h7ZQPFGObJrtqEYlKwngePKskVb9goMNakpao6vVCf3GQVQYjHbhUoWZNwVfqTF+kXCp8oPLbVcgFFQM10/kt4ZCubek50NykhD1aEIAb1z2t/UKiGij2exZEwA2dhhVmcLHK8exSCntN0f+w1pkNMbU80w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QyARaXRB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QyARaXRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DE31F000E9;
	Fri, 12 Jun 2026 13:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781270591;
	bh=Dg4m2uwxQ+fCnD6ZVsfvUoguRQY8M4GyPal8N423B9E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QyARaXRB+xZBtrzgPNgSjuiyunzR9e++2K8XRjJ9YEjXw+eXRuGSg/1QpPjT/Bmvd
	 0iBP8eK0hDVFptuDmONwVagipHuj99Tiaji+f1yOSP6fYu60IaXguc1EUZmVQZywJO
	 LeC7/M5vLMhAmia7KQwjTmlg6lHzTcFi7u0mO2BGNqnBw+kXp3H7pH7EOqCEPwchH/
	 6yLSFB/aXKTJfT+PzOaouSOTEKwWyXG2koqs6VoKlsDOA3GJShJPrmQmK7bemAHF26
	 mo/QvAhzQWkT6fQboBaFXMondWH+Cgr0CpEcUHjyzc+67hw3iu4hYz4/GzBB0YYSei
	 D9wXlNqj5Lk9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 45/60] scsi: qla2xxx: Fix queue teardown NULL
 dma_free and bitmap locking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-46-njavali@marvell.com>
References: <20260612095333.1666592-46-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 13:23:10 +0000
Message-Id: <20260612132311.84DE31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing cancel_work_sync() for qpair->q_work in qla2xxx_delete_qpa=
ir() leads to a Use-After-Free condition of the qpair structure.
- [High] Incorrect teardown ordering in qla2xxx_delete_qpair() leaves the r=
esponse queue IRQ active while freeing the request queue, risking a Use-Aft=
er-Free.
- [High] Time-of-check to time-of-use (TOCTOU) race when locklessly reading=
 `ha->req_q_map` in `qla2x00_error_entry()`.
--

commit 39ad14d24efefe86744d37bc2d46a853a7de6d76
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking

This commit fixes undefined behavior caused by calling dma_free_coherent()
with a NULL pointer during request and response queue teardown. It also
addresses a concurrency issue by protecting bitmap and map clear operations
with the mq_lock instead of vport_lock.

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
>  	req->ring =3D NULL;
>  	req->dma =3D 0;
>  	if (que_id) {
> +		mutex_lock(&ha->mq_lock);
>  		ha->req_q_map[que_id] =3D NULL;

[Severity: High]
This is a pre-existing issue, but modifying ha->req_q_map here under mq_lock
exposes a Time-of-check to time-of-use (TOCTOU) race in qla2x00_error_entry=
().

In drivers/scsi/qla2xxx/qla_isr.c:qla2x00_error_entry():
    if (que >=3D ha->max_req_queues || !ha->req_q_map[que])
        goto fatal;

    req =3D ha->req_q_map[que];

Since ha->req_q_map is read locklessly in the ISR, could it become NULL
between the check and the assignment, leading to a NULL pointer dereference?

> -		mutex_lock(&ha->vport_lock);
>  		clear_bit(que_id, ha->req_qid_map);
> -		mutex_unlock(&ha->vport_lock);
> +		mutex_unlock(&ha->mq_lock);
>  	}
>  	kfree(req->outstanding_cmds);
>  	kfree(req);
> @@ -605,16 +606,17 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, str=
uct rsp_que *rsp)
>  		rsp->msix->handle =3D NULL;
>  	}
> =20
> -	dma_free_coherent(&ha->pdev->dev,
> -			  (rsp->length + 1) * rsp_entry_size,
> -			  rsp->ring, rsp->dma);
> +	if (rsp->ring)
> +		dma_free_coherent(&ha->pdev->dev,
> +				  (rsp->length + 1) * rsp_entry_size,
> +				  rsp->ring, rsp->dma);
>  	rsp->ring =3D NULL;
>  	rsp->dma =3D 0;

[Severity: High]
This isn't a bug introduced by this patch, but does the queue teardown sequ=
ence
in qla2xxx_delete_qpair() have a use-after-free risk during queue cleanup?

In drivers/scsi/qla2xxx/qla_init.c:qla2xxx_delete_qpair():
    ret =3D qla25xx_delete_req_que(vha, qpair->req);
    if (ret !=3D QLA_SUCCESS)
        goto fail;

    ret =3D qla25xx_delete_rsp_que(vha, qpair->rsp);

The request queue memory is freed before the response queue IRQ is disabled.

Does this leave a race window where an interrupt firing on another CPU could
cause the ISR (qla24xx_process_response_queue) to access the already freed
request queue?

[Severity: High]
This is also a pre-existing issue, but does qla2xxx_delete_qpair() safely
teardown the qpair workqueue?

In drivers/scsi/qla2xxx/qla_init.c:qla2xxx_delete_qpair():
    ret =3D qla25xx_delete_rsp_que(vha, qpair->rsp);
    ...
    kfree(qpair);

Since qla25xx_delete_rsp_que() disables the MSI-X interrupt via free_irq(),=
 but
free_irq() doesn't wait for asynchronous work to complete, could the queued
work function still execute?

In drivers/scsi/qla2xxx/qla_mid.c:qla_do_work():
    struct qla_qpair *qpair =3D container_of(work, struct qla_qpair, q_work=
);
    ...
    spin_lock_irqsave(&qpair->qp_lock, flags);

If the interrupt fired just before free_irq() and scheduled qpair->q_work,
could qla_do_work() dereference the qpair structure after it has been freed?

>  	if (que_id) {
> +		mutex_lock(&ha->mq_lock);
>  		ha->rsp_q_map[que_id] =3D NULL;
> -		mutex_lock(&ha->vport_lock);
>  		clear_bit(que_id, ha->rsp_qid_map);
> -		mutex_unlock(&ha->vport_lock);
> +		mutex_unlock(&ha->mq_lock);
>  	}
>  	kfree(rsp);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D45
