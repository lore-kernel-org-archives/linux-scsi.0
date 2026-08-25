Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCDF33B96B
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674157; cv=none; b=X2elXnUYYHhVmm1idajUxoNq9ZiOI6tb/3p9oQeECJ0mR1BNlYUUHc4rwfRYTaE/wbEUaltPS9b5NhFyU32zmpkfh4OTUQbZER6P1MbIGDysej081DLy+cSYvb14/o7GWz9oyG9YnYKEmAtd+y6J9rBioIOEeU61nAkJvUR3dcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674157; c=relaxed/simple;
	bh=GFj8dECLO2DW2mK/XNhpHDSwrRziFVVgKyGLgqbCAtA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dxq8/07q6PUY5b4UjQVJigLCfVsb/XukARPijFai4gGWnC+sMt8Ac0shTjtqNFs6MnBg3eYjtGrwmgu//3RA7LFpo3iLY5qTrengfmgZyaRBwtfICw+sCfdSA44E2HmGK2ym8JRxCIIUchPQXpNaaQOV2WVJKbYIjq8ahAiddTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WYbNRexb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYbNRexb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81FA1F000E9;
	Tue, 25 Aug 2026 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674156;
	bh=Xk4fUTkEoafE8vCMyLEsEUj3t0qz32Pgqhn1f62DOx4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WYbNRexbCEZwffyC1+qK2ruKWU73lJMuXpX+1R7BefX+KOSXkCuN8fTLG3x6g28Nt
	 1QRH89Gx8ZMHEu6CJ+0eoDt7nEr23cU4xMtVipGaGTkEP6A8cUwuXe/uQGsvxLEIPo
	 /bsLXjSM6TpooMHbBpw2GzQbHMqKGmOsTGxhaXeQv7+Sx44dprH2k7eb/cV7NoCqDu
	 I33Mq0BbK+TKHDUJyExM+5TAe6jHJx56/woxMTrNUMnsA3RV+ZeT6+hKGdK+Yi21cD
	 T3cUtQkgvVWPqk3u3UBwzYfNHlcWGo0HiIdsH6KfDX+1NeBBvzLGaDdtFuAwkUgN5r
	 rkep2wBo+XFow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/17] mpi3mr: Fix buffer overflow in BSG passthrough
 request copy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-2-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-2-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:09:15 +0000
Message-Id: <20260825160915.C81FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing validation of `job->request_len` allows out-of-bounds slab=
 memory reads when parsing the BSG request and buffer entries.
- [High] On 32-bit architectures, pointer wrap-around allows bypassing boun=
ds checks for specific buffer types, leading to out-of-bounds heap access.
- [High] DMA coherent memory allocated for NVMe PRP lists is leaked on comm=
and posting failures or command timeouts.
- [High] Potential Use-After-Free of `stgt_priv` if the SCSI target is remo=
ved concurrently during a long-running BSG command.
- [High] Data race and use-after-timeout on `mrioc->bsg_cmds` state between=
 timeout handler and interrupt handler.
--

commit 6909218adbd3af92548ad9194e535cec60aaccf1
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix buffer overflow in BSG passthrough request copy

The size of an incoming BSG request is checked using a variable that is
narrower than the field it is read from, so large values wrap and pass
the check. The copy that follows then uses the full value and writes
past the request buffer.

Widen the variable and copy only the amount that was checked.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

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

[Severity: High]
This is a pre-existing issue, but does this lack validation of
job->request_len when parsing the BSG request and buffer entries?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
...
	bsg_req =3D job->request;
	karg =3D (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
...
	bufcnt =3D karg->buf_entry_list.num_of_entries;
...
	buf_entries =3D karg->buf_entry_list.buf_entry;
...
}

And similarly in mpi3mr_bsg_process_drv_cmds():

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_drv_cmds() {
...
	bsg_req =3D job->request;
	drvrcmd =3D &bsg_req->cmd.drvrcmd;
	mrioc =3D mpi3mr_bsg_verify_adapter(drvrcmd->mrioc_id);
...
}

If a user intentionally specifies a request_len smaller than the size of
struct mpi3mr_bsg_packet, could this result in an out-of-bounds slab memory
read since the driver casts and accesses the buffer without checking the
length?

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

[Severity: High]
This is a pre-existing issue, but does this pointer arithmetic bypass
bounds checks on 32-bit architectures?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
...
		case MPI3MR_BSG_BUFTYPE_MPI_REPLY:
			sgl_iter =3D sgl_din_iter;
			sgl_din_iter +=3D buf_entries->buf_len;
...
}

If a user submits a massive buf_len (e.g., 0xFFFFFFFF), could the addition
to sgl_din_iter (which is a u8 *) cause an integer wrap-around on 32-bit
systems?

Since a wrapped pointer is mathematically smaller, would it bypass the
safety check:

	if (sgl_din_iter > (din_buf + job->reply_payload.payload_len))

And allow an out-of-bounds heap write when the driver copies the reply:

	memcpy(drv_buf_iter->bsg_buf, bsg_reply_buf, tmplen);

[Severity: High]
This is a pre-existing issue, but does this code leak DMA coherent memory
on command posting failures or timeouts?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_build_nvme_prp() {
...
	mrioc->prp_list_virt =3D dma_alloc_coherent(&mrioc->pdev->dev,
	    dev_pgsz, &mrioc->prp_list_dma, GFP_KERNEL);
...
}

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
...
		if (rval) {
			mrioc->bsg_cmds.is_waiting =3D 0;
			dprint_bsg_err(mrioc,
			    "%s: posting bsg request is failed\n", __func__);
			rval =3D -EAGAIN;
			if (block_io && stgt_priv)
				atomic_dec(&stgt_priv->block_io);
			goto out_unlock;
		}
...
}

If mpi3mr_admin_request_post() fails or if the command times out, the code
jumps to out_unlock. Does out_unlock fail to free mrioc->prp_list_virt,
leading to a permanent leak of DMA memory?

[Severity: High]
This is a pre-existing issue, but is there a potential Use-After-Free of
stgt_priv if the SCSI target is removed concurrently?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
...
		if (tgtdev) {
			if (tgtdev->starget && tgtdev->starget->hostdata) {
				stgt_priv =3D (struct mpi3mr_stgt_priv_data *)
				    tgtdev->starget->hostdata;
				atomic_inc(&stgt_priv->block_io);
			}
			mpi3mr_tgtdev_put(tgtdev);
		}
...
		if (block_io && stgt_priv)
			atomic_dec(&stgt_priv->block_io);
...
}

The reference to the target device is dropped via mpi3mr_tgtdev_put(tgtdev)
before the long wait. If the physical SCSI device is hot-unplugged during
the wait for command completion, could the SCSI midlayer free the starget
and stgt_priv before atomic_dec() is called?

[Severity: High]
This is a pre-existing issue, but is there a data race on mrioc->bsg_cmds
state between the timeout handler and the interrupt handler?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
...
		if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {
			mrioc->bsg_cmds.is_waiting =3D 0;
			rval =3D -EAGAIN;
...
}

And in the interrupt handler:

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_process_admin_reply_desc() {
...
	cmdptr->state |=3D MPI3MR_CMD_COMPLETE;
...
	cmdptr->state &=3D ~MPI3MR_CMD_PENDING;
...
	if (cmdptr->is_waiting) {
		cmdptr->is_waiting =3D 0;
		complete(&cmdptr->done);
	}
...
}

If a BSG command times out, the timeout handler locklessly sets
is_waiting =3D 0 and aborts, allowing another thread to acquire the lock
and submit a new command using the same structure.

If a delayed hardware interrupt for the original command fires while the
new command is pending, could the non-atomic modifications to cmdptr->state
in mpi3mr_process_admin_reply_desc corrupt the state of the new command
and prematurely complete it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D1
