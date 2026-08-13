Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5480534AB00
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786640577; cv=none; b=qhREveb5cKbVwLaELb+mCCiI2hpAlg91mWFY4+1+Z0F0C+5pSrVsc7w1CcVvwVrrA8kUDxl7geNdVDS4/YeTMA6Z/l3tYOiTP+aJ3CSJnqjQ6WLavINzcm8RXnJgfl7+ovdD0ZR4GA3wzgqlfvGQVCItimgllqPFa/DVxuX5Hsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786640577; c=relaxed/simple;
	bh=AIhpdlsLnrvA01p4brABII+Yc6oRrNsv6voQdylD+JA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R2YXX756myVpNJv8/5cyvuYVvcxCeynqsmppwwUF3g4ZMA/BxUEYG6vDDNx9yOP8wRV3omvlm8UjDEh2KYUYh+VPJV1zfu8Pnx6RI2L7Lbuj6ZxlU37Wmbd6YoHOq5Jbe15T0TDNt5c2jd2f6vchmXPTK0ur+muIewPnTD/JIP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZJhStCS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZJhStCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A74A1F000E9;
	Thu, 13 Aug 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786640576;
	bh=rhCkFn8nSh+fRn68iDbtmxZNJx2VbzW4pcoDTWJgbeY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VZJhStCSzDVlzegt6qnQzfu38km4O0z5W2WYKjlPbF2fUHPm9oqOyLKFjEcA+cC6e
	 GSPSkCLwFGWXtiVD8rYUtAgpdKdyChh/pXXYkdMS+sxlk3zkXuRBJ0AqZd8Ut3bQwV
	 ze8PKDxWSD0UguGUFdf30J7rE2bqrDDiDeSqt721XsbCSl1qTExpl04PnOD3/Gl2gE
	 zBaj6ubP7OaMRYGnW0gfhBqyuKja4IwSc2GifIM+JImud2ASvFs+49SP/7ACE2C28L
	 zTQRMz0m41nnss2cynYp+sC/jD039uDBAH1s7jpQXG0PT5hN1JrFrwHj2T4eBjiJwb
	 qP970OLtKeylA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: check the SMP passthrough reply status
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilya Khomyakov" <khomyakovilya@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260813164757.1610-1-khomyakovilya@gmail.com>
References: <20260813164757.1610-1-khomyakovilya@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 17:02:55 +0000
Message-Id: <20260813170256.1A74A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Subtracting 4 from DMA payload lengths can underflow, leading to a=
 massive out-of-bounds DMA transfer.
- [Medium] Bypassing the reply buffer initialization on the error path leak=
s 4 bytes of stale kernel memory to user space.
- [Medium] `mpi3mr_transport_phy_reset()` does not verify `ioc_status` when=
 issuing a phy reset command for HBA phys, causing a silent failure.
--

--- Patch [1]: [PATCH] scsi: mpi3mr: check the SMP passthrough reply status=
 ---
commit e3ae5fbfa11b135aa2d03a8b686ed5c492bc6d86
Author: Ilya Khomyakov <khomyakovilya@gmail.com>

scsi: mpi3mr: check the SMP passthrough reply status

This commit adds a check for ioc_status in mpi3mr_transport_smp_handler().
If the controller did not complete the SMP passthrough request successfully,
it now returns -EIO and skips the reply transfer, preventing the block layer
from seeing a successful zero-byte transfer.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 240f67a8e2e3b..6054d68ea112b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -3320,6 +3320,11 @@ mpi3mr_transport_smp_handler(struct bsg_job *job, =
struct Scsi_Host *shost,
>  	dprint_transport_info(mrioc,
>  	    "SMP request completed with ioc_status(0x%04x)\n", ioc_status);
> =20
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		rc =3D -EIO;
> +		goto unmap_in;
> +	}
> +

[Severity: Medium]
This is a pre-existing issue, but does skipping the reply initialization le=
ak
stale kernel memory to user space?

When taking the new error path, we skip copying mpi_reply to job->reply,
leaving job->reply with uninitialized data from a previous request.

The block layer's bsg_transport_sg_io_fn() will intercept the negative resu=
lt,
set job->reply_len =3D sizeof(u32), and copy those uninitialized 4 bytes to=
=20
user space:

block/bsg-lib.c:bsg_transport_sg_io_fn() {
    ...
    if (job->result < 0) {
        job->reply_len =3D sizeof(u32);
        ret =3D job->result;
    }

    if (job->reply_len && hdr->response) {
        int len =3D min(hdr->max_response_len, job->reply_len);

        if (copy_to_user(uptr64(hdr->response), job->reply, len))
    ...
}

[ ... ]

[Severity: High]
This isn't a bug introduced by this patch, but can the DMA length calculati=
on
underflow if the user-supplied payload length is less than 4 bytes?

Looking at mpi3mr_transport_smp_handler(), the driver subtracts 4 from the
payload lengths without ensuring a minimum length:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_transport_smp_handler() {
    ...
    psge =3D &mpi_request.request_sge;
    mpi3mr_add_sg_single(psge, sgl_flags, dma_len_out - 4, dma_addr_out);

    psge =3D &mpi_request.response_sge;
    mpi3mr_add_sg_single(psge, sgl_flags, dma_len_in - 4, dma_addr_in);
    ...
}

If a local user with BSG access (CAP_SYS_RAWIO) submits a request with a
payload length of 1, 2, or 3 bytes, this subtraction could underflow to a h=
uge
32-bit value, causing an out-of-bounds DMA transfer to the firmware.


[Severity: Medium]
This is a pre-existing issue, but does mpi3mr_transport_phy_reset() fail to
propagate firmware errors?

The function successfully issues the reset request but ignores the controll=
er's
completion status:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_transport_phy_reset() {
    ...
    if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
        &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status)) {
        rc =3D -EAGAIN;
        goto out;
    }

    dprint_transport_info(mrioc,
        "phy reset request completed with ioc_status(0x%04x)\n",
        ioc_status);
out:
    return rc;
}

Since rc remains 0 even if ioc_status indicates an error, does this break t=
he
SAS error recovery state machine by silently reporting success?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813164757.1610=
-1-khomyakovilya@gmail.com?part=3D1
