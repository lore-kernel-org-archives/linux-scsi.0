Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3255485CC7
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076913; cv=none; b=WI7wTvtyxyVVxAk4+xywqRxwCsmssRYO6oCjygAWGkR3Y3kJdpsgIly+GORLyjTj0E9I1hI4FkQPdkaebbapClygmd0OGHP85el1oO9930JGJhHur721dWqDpJN8juRj9wFuXYcnAszgflC5Gan9JQYomxlUSnwewATb+FbTmU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076913; c=relaxed/simple;
	bh=+1Exz42S0qgPN0QsOJkuWkB4ClyyWxOZ4tlUAa7Dl4c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Nlbelx7687sBBwO7JgfKvBYY/45a1+hIwnQhapjV67NdYqkW/kEPKGn1qiKtxawnZaA754Pv/9ikEyVlfUgL8jVxOBaXa1ELpo60zmVoAvHAHsrf1v6l2u+wsXhcxLjlWCcYmG7vR/4xpZT34Vnie+klCOhNnzefYi4sKXp5eH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDq+qzbH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDq+qzbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BDB1F000E9;
	Tue, 18 Aug 2026 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787076911;
	bh=hjDKHRDBKTIIsM1IZnezr4Oj/N4H/u463HxfKEUADYI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fDq+qzbHTU/5n17dhbO7IxEuBjebO47+mtPNw8GKIvqwwovfjLcRNO2EQnoltG6H9
	 Gd3seyywb55BI0VWkDBv/PB0MELBWYpvV24leL0ozDC5ImO8r+rTV+Jbodbyhx7sUG
	 JCDhI5gRjNEiN8bD8LX8Ue0Drv5sAQahnqb4Lyfa1MwgFKUt0/iAskvkpB59ogNBjm
	 /XHWcZ8vJNm77rQCJF8Q+7wXNdu2gfYpobPo2BuvacP9hy2eAbmxjgT8iftZ9yrXjm
	 SAHSJtyW/OuBl2+zF4OTwxLp2eD6/wdhnMxPDLXh2ve6ROXGvwr+7KH44bYTsOfHmL
	 1XC+5okRwdV6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/17] mpi3mr: Fix out-of-bounds read when copying BSG
 MPI requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-3-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-3-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:15:11 +0000
Message-Id: <20260818181511.75BDB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] On 32-bit architectures, pointer wrap-around and integer trunc=
ation bypass buffer bounds checks, leading to arbitrary kernel memory read/=
write.
- [Critical] The driver fails to validate the user-provided `job->request_l=
en` before casting and parsing the BSG request packet, leading to an out-of=
-bounds heap read and a kernel panic.
- [High] Failure to decrement `stgt_priv->block_io` on early failure of `mp=
i3mr_admin_request_post`.
- [High] DMA coherent memory allocated for PRP lists is leaked on command t=
imeout or post failure.
--

--- Patch [2]: [PATCH 02/17] mpi3mr: Fix out-of-bounds read when copying BS=
G MPI requests ---
commit 0259dbaa420364e7270c5c71574f90668291edf7
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds read when copying BSG MPI requests

The MPI request is copied out of the caller supplied payload without
first checking that the requested amount is actually present, so the
copy can read past the end of the payload buffer.

Check the range before copying.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 8e5d24793efd0..1cd1c38dcd565 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2538,6 +2538,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg=
_job *job)
>  				rval =3D -EINVAL;
>  				goto out;
>  			}
> +			if (sgl_iter + mpi_msg_size >
> +			    dout_buf + job->request_payload.payload_len) {

[Severity: Critical]
This is a pre-existing issue, but can pointer arithmetic wrap around on 32-=
bit
architectures and bypass this new bounds check?

If a userspace application sends an MPI3MR_MPT_CMD BSG request with a craft=
ed
buf_len (e.g., 0x10001000) such that the sum modulo 2^32 remains small, the
sgl_iter pointer wrap-around could mathematically bypass both the end-of-bu=
ffer
limit check and this newly added check.

Concurrently, can kern_buf_len / MPI3MR_IOCTL_SGE_SIZE truncate from 0x10001
to 1 in the u16 needed_desc variable in mpi3mr_map_data_buffer_dma()?

This would bypass the descriptor limits, allowing the driver to create DMA
mappings for arbitrary kernel addresses.

> +				dprint_bsg_err(mrioc, "%s: MPI request buf exceeds dout_buf\n",
> +					       __func__);
> +				mutex_unlock(&mrioc->bsg_cmds.mutex);
> +				rval =3D -EINVAL;
> +				goto out;
> +			}
>  			memcpy(mpi_req, sgl_iter, mpi_msg_size);
>  			break;
>  		default:

[Severity: Critical]
This is a pre-existing issue, but does the driver validate job->request_len
before casting and parsing the BSG request packet?

If a userspace application submits a BSG request with request_len set to 0,
the BSG core invokes memdup_user(), which returns ZERO_SIZE_PTR (0x10).

Will the driver unconditionally dereference this pointer here?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_request() {
	...
	switch (bsg_req->cmd_type) {
	...
}

Could this lead to an immediate unhandled kernel panic?  Additionally, if a
small non-zero length is provided, does the driver read bufcnt from the
unvalidated payload in mpi3mr_bsg_process_mpt_cmds() and loop over unalloca=
ted
heap memory?

[Severity: High]
This is a pre-existing issue, but is there a missing decrement of
stgt_priv->block_io on early failure of mpi3mr_admin_request_post()?

When processing a SCSI task management request that specifies blocking I/O,
stgt_priv->block_io is incremented. If mpi3mr_admin_request_post() fails,
the code jumps directly to out_unlock:

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
	...
		goto out_unlock;
	...
}

Does this skip the atomic_dec(&stgt_priv->block_io) matching the earlier
increment, permanently blocking all future I/O to the affected SCSI target?

[Severity: High]
This is a pre-existing issue, but is DMA coherent memory allocated for PRP
lists leaked on command timeout or post failure?

When an NVMe encapsulated request utilizes a PRP list, mpi3mr_build_nvme_pr=
p()
allocates a DMA coherent buffer in mrioc->prp_list_virt.

If mpi3mr_admin_request_post() fails, or if wait_for_completion_timeout()
times out, the code branches to out_unlock without freeing the memory:

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
	...
	if (mrioc->prp_list_virt) {
		dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
	...
}

Would a subsequent NVMe command blindly overwrite mrioc->prp_list_virt with=
 a
new allocation, permanently leaking the previous DMA buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D2
