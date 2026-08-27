Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4900B4DD6C4
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 19:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787858232; cv=none; b=PFjIBV1Mtwz7sAQdJ5Jo0rxhYiMF9pQvI0ztjNhKUhOizYze+xlIDHMyfQKddyH3n9H0fegtZVbzEZz7VqD5QAq1zg5Hbzl41p1TeT3/h3dnQHF9fY3whY6gtB9Z/shj7RuJwX0dBiD2MScRV9KCA6ngmttQXCJjGUiDAPVEDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787858232; c=relaxed/simple;
	bh=ELo2Nccte4i0VIwftP/OE/s/HN3QBFe1OdelBEHsLYA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=s2CY2voAkdqGaqdGnB+WiR48glBDtusGmylGAMWFMO9xlCynHh0ey6g5BLdEX/nJ8Cah2IqHByRqTrWmoIsMFmALY0LFg7tV4qGeZ0CsYA2W5Lr6CyBCfKBAbIzXmUEOY249Tvpp5cfevaQYCgwy1W7RjQT9j5vMoyJKEjAm/dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5iersJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5iersJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53C91F000E9;
	Thu, 27 Aug 2026 19:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787858226;
	bh=O39zfl4riPGonWKh5cKAXd60TRYb5HV/BklmzrD/sAs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m5iersJ4UP39OB9wn3e4vUse6PxgmPEubOxvPmnLwmGhy0S89QeY4ah6LY2Oinbnx
	 IdWURNPzgt9bSjyLm6BvQCuboD+EHnmo1u2dkyBhKGsG/ixHIvpedW718VSWcRm2yb
	 AvJm8JGHLgyAizciMNA4x2RZUtZ5m1/Dtu7x0dj7mHS7xiBo5j2sQv17bV6a8O0br8
	 DjUjjjZhvUR2Lj0Pu9SL/rNBUfspKUJ+m2RWmQuMI4PM0ZpmDr+PiEXHCronyvi509
	 SgLQME3+FcE9fm/w+yCh4OhWVsMQvJQJ48JDjonzbkLoULn0JiifMO7iVZHbFRdMZM
	 ZmlYDU04nnu6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] nvme/ioctl: call io_uring_cmd_set_res32() in
 ->end_io()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Caleb Sander Mateos" <csander@purestorage.com>
Cc: dsterba@suse.cz, linux-scsi@vger.kernel.org
In-Reply-To: <20260827185722.3234622-3-csander@purestorage.com>
References: <20260827185722.3234622-1-csander@purestorage.com>
 <20260827185722.3234622-3-csander@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 19:17:05 +0000
Message-Id: <20260827191705.D53C91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Polled NVMe uring_cmd requests completing via IRQ cause a Use-=
After-Free in nvme_ns_chr_uring_cmd_iopoll.
- [Critical] io_do_iopoll unconditionally overwrites req->cqe.flags, destro=
ying IORING_CQE_F_32 for polled uring_cmd requests.
--

commit 67604b5180877187b81d959a1a1acc3b5bc52ca4
Author: Caleb Sander Mateos <csander@purestorage.com>

nvme/ioctl: call io_uring_cmd_set_res32() in ->end_io()

This commit moves io_uring_cmd_set_res32() from the task work callback
into the end_io handler for nvme uring commands. This eliminates the need
to store the result and status in the PDU, saving memory and unifying
the completion path.

> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index 269afd5bc02e3..8d357c47111f8 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c

[ ... ]

> @@ -414,15 +411,17 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(str=
uct request *req,
>  {
>  	struct io_uring_cmd *ioucmd =3D req->end_io_data;
>  	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
> +	u64 result =3D le64_to_cpu(nvme_req(req)->result.u64);
> +	int status;
> =20
>  	if (nvme_req(req)->flags & NVME_REQ_CANCELLED) {
> -		pdu->status =3D -EINTR;
> +		status =3D -EINTR;
>  	} else {
> -		pdu->status =3D nvme_req(req)->status;
> -		if (!pdu->status)
> -			pdu->status =3D blk_status_to_errno(err);
> +		status =3D nvme_req(req)->status;
> +		if (!status)
> +			status =3D blk_status_to_errno(err);
>  	}
> -	pdu->result =3D le64_to_cpu(nvme_req(req)->result.u64);
> +	io_uring_cmd_set_res32(ioucmd, status, result);

[Severity: Critical]
This is a pre-existing issue, but does moving this call before polling expo=
se
a regression with IORING_CQE_F_32?

When io_uring_cmd_set_res32() posts 32-byte CQE results, it sets:
    req->cqe.flags |=3D IORING_CQE_F_32;

However, for polled requests, io_do_iopoll() later executes:
    req->cqe.flags =3D io_put_kbuf(req, max(req->cqe.res, 0), NULL);

This unconditional assignment completely overwrites the flags, erasing
IORING_CQE_F_32. As a result, when io_fill_cqe_req() processes the
completion, it allocates a 16-byte slot instead of 32 bytes and silently
drops extra1 and extra2 (the NVMe-specific result values).

> =20
>  	/*
>  	 * For IOPOLL, check if this completion is happening in the context
> @@ -435,7 +434,6 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struc=
t request *req,
>  	    iob->poll_ctx =3D=3D io_uring_cmd_ctx_handle(ioucmd)) {
>  		if (pdu->bio)
>  			blk_rq_unmap_user(pdu->bio);
> -		io_uring_cmd_set_res32(ioucmd, pdu->status, pdu->result);
>  		io_uring_cmd_done(ioucmd, 0);
>  	} else {
>  		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
>  	}
>  	return RQ_END_IO_FREE;

[Severity: Critical]
This isn't a bug introduced by this patch, but is there a use-after-free
regression when a polled NVMe uring_cmd completes via an interrupt?

If the completion is not in the expected poll context (e.g. hybrid polling
or a spurious interrupt), this path queues nvme_uring_task_cb() via
io_uring_cmd_do_in_task_lazy() and returns RQ_END_IO_FREE, which frees the
block request immediately.

However, the io_uring state flag req->iopoll_completed is not set to 1 until
the task_work runs. Concurrently, the io_uring polling thread in
io_do_iopoll() sees req->iopoll_completed =3D=3D 0 and invokes
nvme_ns_chr_uring_cmd_iopoll().

This function then dereferences pdu->req (which points to the just-freed
block request) to check blk_rq_is_poll(req):

drivers/nvme/host/ioctl.c:nvme_ns_chr_uring_cmd_iopoll() {
    ...
    struct request *req =3D pdu->req;

    if (req && blk_rq_is_poll(req))
    ...
}

Can this lead to memory corruption if the unprivileged user issuing the
command continues polling while the interrupt path frees the request?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827185722.3234=
622-1-csander@purestorage.com?part=3D2
