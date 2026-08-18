Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A442FC037
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076887; cv=none; b=MMB06X7W3nsDMNuPtqw51+Ub74N35D8jJRZ4HSdko0B/PZ/IUjHwQdyL6brUKsKMVx+e04BFPBfLf1E4I3PtFULLG0Bsr98eyhaCGq4bQkOaDXFkRYUZYWWRDdqPsHiWVn/G5A5fKKpIZrqFOzZaZvebKRtkwzf66noNpCfDDI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076887; c=relaxed/simple;
	bh=GzJjOa08Ue34QHFVBxFZQpOADynNtFzrMZEMwbbR9w4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BhYUS0L95ca9WWeqPXiRF6lRDxCFMsHbctciiT/mFUKe9CN83G8LnMvgtlnhtfcT9ulByb2CpVAq7j3byHigK9gWQYZCVwHcmApKQhsilOHb1Vts+PNsxmqSEF8I/qsrf1cTIbr9c1KzmcxVru3G9c7H48Lblhv73enmjbp3k2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kb695wiI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kb695wiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16AC1F000E9;
	Tue, 18 Aug 2026 18:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787076886;
	bh=tO6k/4Cvpy1EKQ79kyDyvf9rUtgm+nMOtj/R7md7t4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kb695wiIA2zUtKoFA2qytCvCt8jDtN9y0qvqlULaumvpUVNwpJMaiWZiwc++7zuq+
	 H+EZ7A8RA1KWuW73hkLLmq90VnwLL7oEiIiNQQIbmeyZbOgj7sDgrVKALsGG2GH24E
	 j0uACxDJxW7kGKNpAU/4tnNqBKgUYqU5UVe9yiLMsS75fWuqF2EgRvMmkvlBFc8rPT
	 zJHhG2aNIjPVweqHmgS2M8m9mO5kWkwOkLT+zAe8s5L5GxeIq6JKp4aOVweclbi9RN
	 nG2raT9W1bOEHwdQ23MSxUnY0k7vpYQiJWxUBsZ6P4W6X14SzrOXPTwGZEwkuSr3Qm
	 T53W/oCO4r7Ew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/17] mpi3mr: Fix buffer overflow in BSG passthrough
 request copy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-2-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-2-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:14:45 +0000
Message-Id: <20260818181445.E16AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Pointer arithmetic wrap-around on 32-bit architectures allows =
bypassing bounds checks, leading to arbitrary kernel memory read/write via =
DMA.
- [High] DMA coherent memory allocated for NVMe PRPs is leaked on BSG comma=
nd timeout or submission failure.
- [High] Target device `block_io` atomic counter is leaked if BSG command s=
ubmission fails.
- [High] Lockless TOCTOU check of `MPI3MR_CMD_COMPLETE` causes a Use-After-=
Free of `sense_buff_k` and data races on `reply` buffers.
- [High] Missing validation of the BSG request length (`job->request_len`) =
allows a user to send an undersized request buffer, leading to out-of-bound=
s memory reads and kernel panics.
--

--- Patch [1]: [PATCH 01/17] mpi3mr: Fix buffer overflow in BSG passthrough=
 request copy ---
commit ed6513158d24e842e223917348ef598d4d161609
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: mpi3mr: Fix buffer overflow in BSG passthrough request copy

This commit fixes a buffer overflow in the BSG passthrough request copy.
The check for an incoming BSG request size used a narrower variable than
its source field, allowing large values to wrap and pass the check.
The variable is widened to ensure the full size is validated properly.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 1353a8ff9c85d..8e5d24793efd0 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2384,7 +2384,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job)
>  	long rval =3D -EINVAL;
>  	struct mpi3mr_ioc *mrioc =3D NULL;
>  	u8 *mpi_req =3D NULL, *sense_buff_k =3D NULL;
> -	u8 mpi_msg_size =3D 0;
> +	u32 mpi_msg_size =3D 0;
>  	struct mpi3mr_bsg_packet *bsg_req =3D NULL;
>  	struct mpi3mr_bsg_mptcmd *karg;
>  	struct mpi3mr_buf_entry *buf_entries =3D NULL;
> @@ -2538,7 +2538,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job)
>  				rval =3D -EINVAL;
>  				goto out;
>  			}
> -			memcpy(mpi_req, sgl_iter, buf_entries->buf_len);
> +			memcpy(mpi_req, sgl_iter, mpi_msg_size);
>  			break;
>  		default:
>  			invalid_be =3D 1;

[Severity: Critical]
This is a pre-existing issue, but can the pointer arithmetic nearby lead to
an integer wrap-around on 32-bit architectures?

When iterating over buffer entries in the same function:

	case MPI3MR_BSG_BUFTYPE_DATA_OUT:
		sgl_iter =3D sgl_dout_iter;
		sgl_dout_iter +=3D buf_entries->buf_len;

If a user submits a BSG request with a crafted buf_len, does the u32 value =
wrap
the sgl_dout_iter pointer on 32-bit systems? This wrapped pointer could then
bypass the later bounds check:

	if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)) {

and allow arbitrary kernel memory access during subsequent payload processi=
ng.

While reviewing this patch, I noticed a few other pre-existing issues.

> drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_request()
> {
> 	long rval =3D -EINVAL;
> 	unsigned int reply_payload_rcv_len =3D 0;
>=20
> 	struct mpi3mr_bsg_packet *bsg_req =3D job->request;
>=20
> 	switch (bsg_req->cmd_type) {

[Severity: High]
This isn't a bug introduced by this patch, but does this function properly
validate job->request_len before dereferencing bsg_req->cmd_type?

If userspace submits a BSG request with a request_len of zero, could this
trigger a zero size pointer dereference and cause a kernel panic? Similarly,
if the length is too small, would this read uninitialized heap memory?

> drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds()
> {
[ ... ]
> 	if (block_io) {
> 		tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
> 		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
> 			stgt_priv =3D (struct mpi3mr_stgt_priv_data *)
> 			    tgtdev->starget->hostdata;
> 			atomic_inc(&stgt_priv->block_io);
> 			mpi3mr_tgtdev_put(tgtdev);
> 		}
> 	}
[ ... ]
> 	rval =3D mpi3mr_admin_request_post(mrioc, mpi_req,
> 	    MPI3MR_ADMIN_REQ_FRAME_SZ, 0);
>=20
> 	if (rval) {
> 		mrioc->bsg_cmds.is_waiting =3D 0;
> 		dprint_bsg_err(mrioc,
> 		    "%s: posting bsg request is failed\n", __func__);
> 		rval =3D -EAGAIN;
> 		goto out_unlock;
> 	}

[Severity: High]
This is a pre-existing issue, but does this error path permanently leak the
block_io atomic counter?

If mpi3mr_admin_request_post() fails, the goto out_unlock bypasses the
atomic_dec(&stgt_priv->block_io) that occurs after the completion timeout
logic. Does this leave the SCSI target device blocked indefinitely?

[Severity: High]
Similarly, this is a pre-existing issue, but does the same goto out_unlock
skip freeing the DMA memory allocated for NVMe PRPs?

If mpi3mr_build_nvme_prp() successfully allocated DMA memory in
mrioc->prp_list_virt earlier in this function, the jump to out_unlock skips
the success-path cleanup block:

	if (mrioc->prp_list_virt) {
		dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
		    mrioc->prp_list_virt, mrioc->prp_list_dma);

Would subsequent commands overwrite mrioc->prp_list_virt and permanently
leak the previous DMA coherent allocation?

> drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_process_admin_reply_desc()
> {
[ ... ]
> 	cmdptr =3D mpi3mr_get_drv_cmd(mrioc, host_tag, def_reply);
> 	if (cmdptr) {
> 		if (cmdptr->state & MPI3MR_CMD_PENDING) {
> 			cmdptr->state |=3D MPI3MR_CMD_COMPLETE;
> 			cmdptr->ioc_loginfo =3D ioc_loginfo;
[ ... ]
> 			if (sense_buf && cmdptr->sensebuf) {
> 				cmdptr->is_sense =3D 1;
> 				memcpy(cmdptr->sensebuf, sense_buf,
> 				       MPI3MR_SENSE_BUF_SZ);
> 			}

[Severity: High]
This isn't a bug introduced by this patch, but does setting the
MPI3MR_CMD_COMPLETE flag before the memory copy create a race condition?

If the application thread in mpi3mr_bsg_process_mpt_cmds() wakes up from a
natural timeout exactly when this flag is set, it performs a lockless check:

	if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {

Could the application thread assume the handler has fully finished, proceed
to read uninitialized reply memory, and free sense_buff_k before the interr=
upt
handler finishes copying into it? Would this result in a use-after-free when
the interrupt handler eventually executes the memcpy?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D1
