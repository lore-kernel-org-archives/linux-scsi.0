Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A2536F91D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781259478; cv=none; b=BuVVdDNGIvPBEZaOdHy76NIbyQT1fdnlqk23xM/YKMOFcYmOqwzljfX8mD43ckzDU+NP7HQzmXKeTVmUQWEvUfWTmvdb1LKU9ArgI8Iue6LTby9vVswL53zjQd7MSksZuTmEYWn6fAWnaewpGgIGOeniAiJsWam5YuEDHxDLunw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781259478; c=relaxed/simple;
	bh=98HyHJzejweKFXnlODLXyzB/pJ1trKRzcS/5jryV528=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bXPqkXgmHn9STCGioUQ3YrWrR/qDhuI5r5MXvnIVg8EnVRhb7XFSXVXtfJOr+Y2KVx5S7Fg4O/Ij5VS5iObK0XKIAu6tBD+wPtMeLWeQRTMtJjL314aH2AzqYObu9SrZMdwWXCbh+Gm46O0t0F40C/dLqN97xTeixugn0ujgGUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7cETF1b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7cETF1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAF51F000E9;
	Fri, 12 Jun 2026 10:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781259477;
	bh=THeXxQcdcEgSmisYDLN1XgWYgO4E8/gpH4FlDmwkkTw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q7cETF1bp6podFTkkV/94PdZdvJBvQAH+N+CQeEoOBoiam02y4YGqralIL+7DFeFI
	 Fwp7a/f/vZdRJX4jREzjv6llQ+mpo/TPTkSscume3h34bN7nlKKrDVvmQqatbndWGd
	 6Oa6KZ/YoaIrKHyhYZP7yJwckxVZV4rHU/gAFE/MayOmCcQeFmfIBf3viV8c22d4so
	 PiG5o4k5KMzVegx5RhcLrPuNYJEmitRyKmr1aoEqXH+YolBvGAlFUNPntAfN5S/GIQ
	 cE55bQjAwvgxjFr/e2owlvjNjLe/OFoW/Zs34fPyHHgPgVbAM2+BXtF6psIapVXQdI
	 dtJpZhV72wTKw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/60] scsi: qla2xxx: Add 29xx support in queue
 initialisation path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-6-njavali@marvell.com>
References: <20260612095333.1666592-6-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:17:56 +0000
Message-Id: <20260612101756.EEAF51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free (UAF) in queue pair teardown due to missing work it=
em cancellation.
--

commit a6fdb9faf346a1dfcb7285602fa98749fbabf7ba
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add 29xx support in queue initialisation path

This commit extends the queue initialization and management to include 29xx
adapters. It introduces support for 128-byte request and response entries by
adding new extended structures and adjusting pointer arithmetic and allocat=
ions.

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c

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

[Severity: High]
This is a pre-existing issue, but can this lead to a use-after-free when
tearing down the queue pair?

The q_work item is initialized in qla25xx_create_rsp_que() to process
responses. During teardown, qla2xxx_delete_qpair() calls
qla25xx_free_rsp_que(), which unregisters the interrupt using free_irq()
as seen here.

While free_irq() waits for running hardirq handlers, it does not flush or
cancel work items already placed on the workqueue.

After qla25xx_free_rsp_que() returns, qla2xxx_delete_qpair() immediately
frees the qpair structure:

qla2xxx_delete_qpair() {
    ...
    mempool_destroy(qpair->srb_mempool);
    kfree(qpair);
    mutex_unlock(&ha->mq_lock);
}

If qpair->q_work was pending, it will later execute qla_do_work(),
dereferencing the freed qpair pointer to access vha and lock
qpair->qp_lock:

qla_do_work() {
    struct qla_qpair *qpair =3D container_of(work, struct qla_qpair, q_work=
);
    struct scsi_qla_host *vha =3D qpair->vha;

    spin_lock_irqsave(&qpair->qp_lock, flags);
    ...
}

This seems especially problematic in full adapter teardown, where
destroy_workqueue(ha->wq) forces pending work to run right after the queue
pairs are freed. Should a cancel_work_sync(&qpair->q_work) be added?

> +
>  	dma_free_coherent(&ha->pdev->dev, (rsp->length + 1) *
> -		sizeof(response_t), rsp->ring, rsp->dma);
> +			  rspsz, rsp->ring, rsp->dma);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D5
