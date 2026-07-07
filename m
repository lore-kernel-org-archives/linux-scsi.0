Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C50D3AEF27
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783408124; cv=none; b=WkSIlqU4WTh/4RsbeClgidFmeNLS/NIeHAkZnoiTqKaEkdJjQZOEXLaOAlh+Q50UmIvFieN54AG9VzhFg4UtFVPHe+cOG59UZgp3hDBjEaDh5nGLUhFA2HGCMqYCPZqQsrfU79CLJQxbwbhkNqntu0L0lOJVvQhIPa0VwaUsMbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783408124; c=relaxed/simple;
	bh=hVCWkCtdrBn4nunyLU0N7f8SyxrtE8wZ08s02v0HaaQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eUAfKVTS3X9WFGaInhY3mKBegpSfpx3hRwr0gnlgK5rnXHlDWEbS3ehCL1Y93Mnj+HpAxLnxI+XTdHu8c6qhieLdodsnrJSKfdcPtHRyaeW2m7YA7YzKpVCtKNf9vzco+wU4cZNWrOCAfy+h3wdW46QtKLM5Sb6c9toC1kf8KbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTwSP7/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTwSP7/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ED61F000E9;
	Tue,  7 Jul 2026 07:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783408123;
	bh=sAjsZd3yMJKmw3gZfwzYBahZWjrfM+aXRzhj5YarpFw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JTwSP7/Dyi+87j5b9/uyRPt/Pz3Y1A7qFd6nwAOlEsUjo2E7m6AC6xP9oJOzs+gvr
	 1QMm1Q1wrhImHd10rzRGLg9f1vP+SLsOBtxl32zIGzdbkB2FFMuRZa2mk6+3Mf9jH5
	 oPqlBYlaJ6loclobw1oOYn92ZoDeDSodGiSW5tQecMTu4sn5kuQON3R0jWVQAcq0KW
	 6EI4yLCVFvyqwaGQLO35YSiBr64MBWQUKuTEi381EgugD3wR94JUXfFQwQSXP3zrNo
	 jYI+FR11GRdNKL9N+fWXU7zHurebWy8MbLmByTIGP+mEuh8EfwgXWdJU+Kqx4o+yBM
	 aBm9bLqj8fFrw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 59/88] scsi: qla2xxx: Fix use-after-free of qpair
 work on queue teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-60-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-60-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:08:42 +0000
Message-Id: <20260707070843.26ED61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete fix for Use-After-Free of `qpair->q_work` on queue crea=
tion error path.
- [High] Race condition causing kernel panic if an interrupt fires before `=
INIT_WORK()`.
--

--- Patch [59]: [PATCH v3 59/88] scsi: qla2xxx: Fix use-after-free of qpair=
 work on queue teardown ---
commit 7b4564aa91c2297e4133057969d048526e18052f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown

The response queue MSI-X handler qla2xxx_msix_rsp_q() schedules
qla_do_work() via queue_work(ha->wq, &qpair->q_work). qla_do_work()
dereferences the qpair (vha, rsp) and takes qpair->qp_lock.

During teardown, qla2xxx_delete_qpair() deletes the response queue, which
calls free_irq() in qla25xx_free_rsp_que(), and then frees the queue and
the qpair. free_irq() waits for running hardirq handlers but does not
cancel work already placed on ha->wq. A still-pending q_work then runs
qla_do_work() against the freed qpair and response queue, causing a
use-after-free.

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index b7d9c1a53f3ce..33bfc61d81652 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c

[ ... ]

> @@ -606,6 +606,10 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, stru=
ct rsp_que *rsp)
>  		rsp->msix->handle =3D NULL;
>  	}
> =20
> +	/* Flush any queued response work before freeing the queue/qpair. */
> +	if (rsp->qpair && ha->wq)
> +		cancel_work_sync(&rsp->qpair->q_work);
> +

[Severity: High]
This isn't a bug introduced by this patch, but does this newly added guard
completely mitigate the use-after-free on the queue creation error path?

Looking at qla2xxx_create_qpair() in drivers/scsi/qla2xxx/qla_init.c,
rsp->qpair is only assigned after the request queue is successfully created:

drivers/scsi/qla2xxx/qla_init.c:qla2xxx_create_qpair() {
    ...
	ret =3D qla25xx_create_req_que(ha, options, vp_id, 0,
				     req_req_dma(qpair), req_req_size(qpair));
	if (!ret) {
		qpair->req =3D ha->req_q_map[vp_id];
        ...
		qpair->rsp->req =3D qpair->req;
		qpair->rsp->qpair =3D qpair;
    ...
}

If qla25xx_create_req_que() fails, the code jumps to fail_req and deletes
the response queue:

drivers/scsi/qla2xxx/qla_init.c:qla2xxx_create_qpair() {
    ...
fail_req:
	qla25xx_delete_rsp_que(vha, qpair->rsp);
    ...
}

When qla25xx_delete_rsp_que() calls qla25xx_free_rsp_que(), rsp->qpair will
be NULL. This bypasses the cancel_work_sync(), allowing any pending work
(scheduled by a spurious or early interrupt) to execute after qpair is freed
via kfree(qpair).

Is there a way to ensure the work is flushed even on this error path?


[Severity: High]
This is also a pre-existing issue, but is there a risk of enqueuing an
uninitialized work_struct if an interrupt fires too early during setup?

Looking at qla25xx_create_rsp_que() in drivers/scsi/qla2xxx/qla_mid.c,
the interrupt vector is requested before the work_struct is initialized:

drivers/scsi/qla2xxx/qla_mid.c:qla25xx_create_rsp_que() {
    ...
	ret =3D qla25xx_request_irq(ha, qpair, qpair->msix);
	if (ret)
		goto que_failed;
    ...
	if (qpair->hw->wq)
		INIT_WORK(&qpair->q_work, qla_do_work);
    ...
}

If a spurious interrupt fires immediately after qla25xx_request_irq(), it
triggers qla2xxx_msix_rsp_q() which calls queue_work() on qpair->q_work
before INIT_WORK() has been executed.

Additionally, if qla25xx_init_rsp_que() fails, the code jumps to que_failed
and INIT_WORK() is bypassed entirely, leaving the work completely
uninitialized when the ISR runs.

Could INIT_WORK() be moved before requesting the interrupt to prevent this?

>  	if (rsp->ring)
>  		dma_free_coherent(&ha->pdev->dev,
>  				  (rsp->length + 1) * rsp_entry_size,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D59
