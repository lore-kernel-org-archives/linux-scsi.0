Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09882427F8F
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890205; cv=none; b=T5wwMCdJjhZNoFnq9L1JPpwtreeZUUHJv3CBY2aZ6IVetANvbT2LgXloCZv8IFdoJP88u+02V+E6CmiIaUk1nCAF9CunWyVj7MUDCVK7BpvU6rw56slRm3sU7KePYenhEeExoAHTs3i0JSyjF/32Ae18g4yclkAT9QxVHisA+Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890205; c=relaxed/simple;
	bh=ursqdOkwh14daS9c8qf8+TWM3p1v007J7q+K78LUIUE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZjHodeW7ihmxU5cQSKtJu5tRWePt/IF5bqA33uvklkASBpvAclbMM4lZYs+WdAUA41SuaN2JhgRxLevBNmDNBV9Fpu+RhMb8wa4GRjOS8ap3Ccvt62qaxngxPpcvJrcJ778mORwz0usxYWDwNHzyTSUjPd+QGv01szX7vQALU7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kg4qv8vI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kg4qv8vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F135F1F000E9;
	Fri, 24 Jul 2026 10:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784890201;
	bh=oE5Lci6lUgtW12U4Gqnhe2goYGc2aJhYp6KzLpLgJn8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kg4qv8vIBzadZZc9ZXNFNAMEQcHLYyx1AX4a7s0Sv27PJIP8eGMEbrnOPNfdtN2nQ
	 WGmfzoKwfd65sD5yzAx73M2FHggehD5NcETg57Bpl6vtbZ5C8Yy4aUy2hoQLRXtBi4
	 LkzeCZ91voOhRrbdDE+eeLnrQbwCxpDEoViyaH23mglBLkcwIjJi2Jw2aM5y8LMiTy
	 Jt/yv23+DTevHJuWSeVhE938E0reeh1gOW36OqpLxIFbtu86NpERSLAUSQ5sB/1xZe
	 /MPr3oHDOALmTos3e6Q3aXM4VKdt7GH5MEyfyM82MMfzUvGVeQSsydoayH622RkR8q
	 Btar4j7AIqg0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/10] mpi3mr: Fix performance regression caused by
 extended IRQ poll sleep
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724102505.115136-6-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
 <20260724102505.115136-6-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 10:50:00 +0000
Message-Id: <20260724105000.F135F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] Leaked invalid `reply_dma` address allows arbitrary hardware D=
MA memory corruption.
- [High] Double-decrement of the `op_reply_q->in_use` lock breaks queue mut=
ual exclusion.
- [High] Improper use of `continue` inside the TOCTOU fallback skips critic=
al DMA memory barriers and batch consumer index updates.
- [High] Breaking out of the processing loop on an invalid `request_queue_i=
d` without advancing the consumer index causes an unrecoverable infinite po=
lling loop and CPU lockup.
- [High] Reclaiming the queue lock after a TOCTOU race without reloading lo=
cal indices causes data corruption via double-processing of descriptors.
--

--- Patch [5]: [PATCH v3 05/10] mpi3mr: Fix performance regression caused b=
y extended IRQ poll sleep ---
commit 166312d7a3fc2817bfd92d0a670bc3744b27cc2e
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix performance regression caused by extended IRQ poll sleep

This patch restores the IRQ poll sleep range to 2-20 us to recover lost
throughput on unaffected kernels. It also introduces missing dma_rmb()
barriers, bounds checking for request_queue_id, TOCTOU race fixes, and
replaces a panic() with a safe log in the reply queue processing logic.

Link: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@br=
oadcom.com?part=3D5
Link: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@b=
roadcom.com?part=3D5

[ ... ]
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 434b66f7b502d..9f7cee26ebcd3 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
[ ... ]
> @@ -565,14 +578,33 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mr=
ioc,
>  	if ((le16_to_cpu(reply_desc->reply_flags) &
>  	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
>  		atomic_dec(&op_reply_q->in_use);
> +		/* Check for a TOCTOU race condition */
> +		dma_rmb();
> +		if ((le16_to_cpu(reply_desc->reply_flags) &
> +		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) =3D=3D exp_phase) {
> +			if (atomic_add_unless(&op_reply_q->in_use, 1, 1))
> +				goto process_desc;

[Severity: High]
If we reclaim the lock here and jump to process_desc, won't we use the local
exp_phase and reply_ci variables?

If another thread already processed this descriptor and updated the global
op_reply_q->ci and op_reply_q->ephase, could we end up double-processing
the same descriptor because our local indices weren't reloaded?

> +		}
>  		return 0;
>  	}
> +process_desc:
> +	/*
> +	 * Ensure that the descriptor payload is read only after
> +	 * the phase bit check is complete.
> +	 */
> +	dma_rmb();
> =20
>  	do {
>  		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
>  			break;
> =20
>  		req_q_idx =3D le16_to_cpu(reply_desc->request_queue_id) - 1;
> +
> +		if (unlikely(req_q_idx >=3D mrioc->num_op_req_q)) {
> +			ioc_err(mrioc, "Invalid request queue id %d\n", req_q_idx + 1);
> +			break;

[Severity: High]
If we break out of the loop here, we don't advance the consumer index
(reply_ci) or decrement op_reply_q->pend_ios.

In mpi3mr_isr_poll(), if pend_ios remains > 0 and num_op_reply is 0,
could this cause an unrecoverable infinite polling loop?

> +		}
> +
>  		op_req_q =3D &mrioc->req_qinfo[req_q_idx];
> =20
>  		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->request_queue_ci));
> @@ -592,8 +624,23 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mri=
oc,
>  		reply_desc =3D mpi3mr_get_reply_desc(op_reply_q, reply_ci);
> =20
>  		if ((le16_to_cpu(reply_desc->reply_flags) &
> -		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase)
> +		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
> +			atomic_dec(&op_reply_q->in_use);
> +			/* Check for a TOCTOU race condition */
> +			dma_rmb();
> +			if ((le16_to_cpu(reply_desc->reply_flags) &
> +			    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) =3D=3D exp_phase) {
> +				/* Descriptor arrived, try to reclaim ownership */
> +				if (atomic_add_unless(&op_reply_q->in_use, 1, 1))
> +					continue;

[Severity: High]
If we successfully reclaim ownership and use continue to jump back to the
start of the loop, doesn't this bypass the trailing dma_rmb() and the
threshold_comps exact-match check at the end of the loop?

Could missing the exact-match threshold check prevent the consumer index
from being batched to the hardware, potentially stalling IO?

> +			}
>  			break;

[Severity: High]
If the phase bit check fails here and we break out of the loop, we have
already called atomic_dec(&op_reply_q->in_use) above.

Since the function cleanup block at the end also unconditionally executes
atomic_dec(&op_reply_q->in_use), will this result in a double-decrement
that drops the lock value below zero and breaks queue mutual exclusion?

> +		}
[ ... ]
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 7b86152922bad..39624fae9131f 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3426,8 +3426,7 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc=
 *mrioc,
>  		scsi_reply =3D mpi3mr_get_reply_virt_addr(mrioc,
>  		    *reply_dma);
>  		if (!scsi_reply) {
> -			panic("%s: scsi_reply is NULL, this shouldn't happen\n",
> -			    mrioc->name);
> +			ioc_err(mrioc, "scsi_reply is NULL, invalid reply_frame_address\n");
>  			goto out;

[Severity: Critical]
When mpi3mr_get_reply_virt_addr() returns NULL, we log an error and jump
to the 'out' label, but *reply_dma remains populated with the unvalidated
address.

In the caller mpi3mr_process_op_reply_q(), we have:

    mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma, reply_qidx);
    if (reply_dma)
        mpi3mr_repost_reply_buf(mrioc, reply_dma);

Does this mean we will unknowingly repost this unvalidated DMA address back
to the hardware, allowing arbitrary hardware DMA memory corruption?

>  		}
>  		host_tag =3D le16_to_cpu(scsi_reply->host_tag);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724102505.1151=
36-1-ranjan.kumar@broadcom.com?part=3D5
