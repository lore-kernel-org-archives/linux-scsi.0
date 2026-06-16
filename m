Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27313321A2
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 14:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781619831; cv=none; b=bYpSm4jHpSR6AXvGm28DKFmU17LGHLnXnreI043NpNAQpfQmq+x9KJANyLeQZ9KD6ji28ANQKM3dGY5cmqdTfuJZty9UFABaYZjQ7+pDiVhg/9qclcLcBDaYMHW2L+lgEQvQdbmr85AxjIPvW9Z4XYl7RYj6MmajN+zQkOFe0II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781619831; c=relaxed/simple;
	bh=K+82UuNi4WFR1vDgcbaqvfDvnmJ185uUdXUczsOEsuE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DZuvMV0Gqmb7aTreNuhaeih8IRX55cB4sUQuwsxLhCTDmcdOi6kiJD3BodeoxxHyzFeOtWcLQULi0IHmpDMbI6ptbx2vaJa3zesTOl5d66WqYOWX6KZwHNx26vKe/fXfUx2dS0UHtuV7UeEcAm4wI8rsAIdCmescKFHJwt5cOyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLlOcIeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLlOcIeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288001F000E9;
	Tue, 16 Jun 2026 14:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781619830;
	bh=u1hyFoc1HXn1yy3yjPdPWB80/mFN6fdVmiMSF4PWwG8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FLlOcIeu9r0300B/Er05QkSzktQS6T7W2wFn+WRfrOW6O5KlPJ4wozi8jNKx/OY72
	 hjTIAkkb0cpkjZ7IYBZ0zj7unyASNsXTEMgw8ZfOl4+8jlskjxTYZy5ffwCEG2YRzu
	 6ZmrGRhwGLpSsOYMTKXS3NBYiItPmbE1/OpkiL/sbbSygDdz+YCd2qcgI9U7mJ4fm0
	 ucbqv0HsqEFW8tuXUKLCK6jAxklU+91jYBpwLuDptO1IE8BhPCBQIPzFEMMdMOkq+l
	 vyWD/0CS0BQAvriBz1CFCRA7jcAI+XVEip8eeDectLqEKOGqSFDx8jQdP9WC8bik42
	 nnsohbQCZheSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qedf: Fix memory leak in __qedf_probe()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dawei Feng" <dawei.feng@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260616135513.3982797-1-dawei.feng@seu.edu.cn>
References: <20260616135513.3982797-1-dawei.feng@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 14:23:49 +0000
Message-Id: <20260616142350.288001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Error masking in `qedf_prepare_sb()` leads to potential uninitiali=
zed hardware queue access.
- [High] Missing NULL pointer checks for `alloc_workqueue()` return values.
- [High] Unbalanced `scsi_host_put()` on the recovery mode error path.
- [High] Stack Use-After-Free and resource leak involving `simd_handler_con=
fig`.
- [High] Missing little-endian conversions when populating physical DMA add=
resses.
--

commit 154b38f89b94af6b83ab002c8ef9ed82528ea0a5
Author: Dawei Feng <dawei.feng@seu.edu.cn>
scsi: qedf: Fix memory leak in __qedf_probe()

This commit addresses a memory leak in __qedf_probe() by routing cleanup
paths through qedf_free_fcoe_pf_param() after a partial allocation failure.
It clears freed PF queue pointers so probe-level unwinds can safely share
the same cleanup.

> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index da429b3a42838..3a41c0210336e 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
[ ... ]
> @@ -3469,7 +3481,7 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
ode)
>  	if (rc) {
> =20
>  		QEDF_ERR(&(qedf->dbg_ctx), "Cannot start slowpath.\n");
> -		goto err2;
> +		goto err2_free_pf;
>  	}

[Severity: High]
This is a pre-existing issue, but is it possible that qedf_prepare_sb()
unconditionally returns 0 on error?

Looking at qedf_prepare_sb():

drivers/scsi/qedf/qedf_main.c:qedf_prepare_sb() {
    ...
    if (allocation_fails)
        goto err;
    ...
err:
    return 0;
}

If status block allocation or initialization fails, it seems qedf_prepare_s=
b()
jumps to err and unconditionally returns 0 (success). __qedf_probe() will
then proceed as if the queues were fully initialized, potentially dereferen=
cing
a NULL pointer or processing garbage CQEs when a fastpath interrupt fires.
Should qedf_prepare_sb() propagate the error code instead?

[ ... ]
> @@ -3713,10 +3725,11 @@ static int __qedf_probe(struct pci_dev *pdev, int=
 mode)
>  err5:
>  	qed_ops->stop(qedf->cdev);
>  err4:
> -	qedf_free_fcoe_pf_param(qedf);
>  	qedf_sync_free_irqs(qedf);
>  err3:
>  	qed_ops->common->slowpath_stop(qedf->cdev);
> +err2_free_pf:
> +	qedf_free_fcoe_pf_param(qedf);
>  err2:
>  	qed_ops->common->remove(qedf->cdev);
>  err1:

[Severity: High]
This is a pre-existing issue, but does this error path lead to an unbalanced
scsi_host_put() during recovery mode?

In __qedf_probe(), during a normal probe, a new Scsi_Host is allocated with
a reference count of 1. If the normal probe fails, jumping to err1 drops
this reference:

err1:
    scsi_host_put(lport->host);

However, if mode =3D=3D QEDF_MODE_RECOVERY, the driver reuses the existing
Scsi_Host from qedf->lport without incrementing its reference count. If the
recovery probe fails and jumps here, won't scsi_host_put() prematurely drop
a reference that was not taken, leading to a use-after-free or double-free
of the Scsi_Host?

[Severity: High]
This is a pre-existing issue, but there appear to be missing NULL pointer
checks for alloc_workqueue() in __qedf_probe().

The driver allocates link_update_wq and dpc_wq:

drivers/scsi/qedf/qedf_main.c:__qedf_probe() {
    ...
    qedf->link_update_wq =3D alloc_workqueue("qedf_%u_link",
                           WQ_MEM_RECLAIM | WQ_PERCPU,
                           1, qedf->lport->host->host_no);
    ...
    qedf->dpc_wq =3D alloc_workqueue("%s", WQ_MEM_RECLAIM | WQ_PERCPU, 1,
                    host_buf);
    ...
}

Neither of these allocations are checked for failure. Under memory pressure,
if alloc_workqueue() returns NULL, wouldn't passing a NULL workqueue to
queue_work() or queue_delayed_work() trigger an immediate kernel panic?

[Severity: High]
This is a pre-existing issue, but is there a stack use-after-free risk when
configuring the SIMD interrupt handler?

In qedf_setup_int(), the driver passes the address of the local stack
variable qedf (&qedf) to simd_handler_config():

drivers/scsi/qedf/qedf_main.c:qedf_setup_int() {
    ...
    qed_ops->common->simd_handler_config(qedf->cdev, &qedf,
        QEDF_SIMD_HANDLER_NUM, qedf_simd_int_handler);
    ...
    if (qedf->int_info.msix_cnt =3D=3D 0) {
        QEDF_ERR(&qedf->dbg_ctx,
             "Cannot load driver due to a lack of MSI-X vectors.\n");
        return -EINVAL;
    }
    ...
}

The registered handler then casts the cookie directly to the struct:

drivers/scsi/qedf/qedf_main.c:qedf_simd_int_handler() {
    struct qedf_ctx *qedf =3D (struct qedf_ctx *)cookie;
    QEDF_WARN(&(qedf->dbg_ctx), "qedf=3D%p.\n", qedf);
    ...
}

Since qedf_setup_int() passes a stack pointer as the cookie and then
immediately returns -EINVAL if msix_cnt =3D=3D 0, __qedf_probe() will jump =
to
err3 and bypass qedf_sync_free_irqs(). This leaves the SIMD handler
permanently registered with a pointer to dead stack memory. If an interrupt
fires after the probe fails, will this dereference corrupted stack memory?

[Severity: High]
This is a pre-existing issue, but does qedf_alloc_global_queues() incorrect=
ly
write physical addresses using native endianness?

When populating the physical block lists (PBL) for the completion queues and
global queues, the driver writes physical addresses using native assignment=
s:

drivers/scsi/qedf/qedf_main.c:qedf_alloc_global_queues() {
    ...
    *pbl =3D U64_LO(page);
    pbl++;
    *pbl =3D U64_HI(page);
    ...
    *list =3D U64_LO(qedf->global_queues[i]->cq_pbl_dma);
    list++;
    *list =3D U64_HI(qedf->global_queues[i]->cq_pbl_dma);
    ...
}

Hardware and firmware typically expect these DMA pointers in little-endian
format. On big-endian architectures, won't these native writes corrupt the
DMA pointers and cause the hardware to DMA into arbitrary memory locations?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616135513.3982=
797-1-dawei.feng@seu.edu.cn?part=3D1
