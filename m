Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840643ACF0C
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 19:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783539033; cv=none; b=P0b9nr3BptA7YYuISmaj9FGGMpmMtK3iKPJpsyNYg9EMxQ5/LWvUxBIyfTAymUgGV3sKNmWZOxtoxr4mCN2VmGc9Edk4BTc1sFL1jqwNtuuikZyo1n8YBBuHzEKOBRcOJJ7uspJJZvueLqdG61czk7+odBA7ppXS1TL8M19f+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783539033; c=relaxed/simple;
	bh=7bcWT7ZI03knh2SNY/WYcI2H3WSqr2YojZCNz+kWZcg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ve/cEtBvq8idC7OIPiDDswLcylpMJtf/IF+FpEEW0B9F3i6JaClRFoytGKtM/ARDzmghDLVyTG+FcWkpfDdrPDVaY96+yqj1GEgotuhkL+e/9CJoEt2WSZrjQHuAo51uve9FIh1fsx+HxaXcro5kr+apATg4QCnoCV8pArdRPqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ey0idmSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ey0idmSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7511F000E9;
	Wed,  8 Jul 2026 19:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783539030;
	bh=NwYbVTMutHrOOT9P4Ge/Cn3WSe+SC2NpfyDDMImtldo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ey0idmSe6+Gh6/Tfdxhv8nSLsmYglFxIYFwvP8yBzPPCKGsP8II5g60kYvVi1u1zk
	 pd1UE6EMos9aVtKHKPk0hNJkKTzo6Y9cP5mCFufXxWDwY3o8cFWpIAMAz19NonMN5P
	 SBKOvP9OHfycMjxUBNflHt0IHKjqGLzezHsfkT7D4J7XriPbYvxw4rHLkNYFGKQurM
	 0d7X7iSh1O8Ft66SJTJZAQxu54s2pHlmJ4Ly4JoFEeSBMgAAANP4+CTzcsea1Qca/2
	 ZEygdrkpW93+uf/SXMl2/NacusKhAhcbO+fnD2L+mv72p77RJ3WFdnrNsnKY8uPWm5
	 JhG3LoLjguyYw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/10] mpi3mr: Fix performance regression caused by
 extended IRQ poll sleep
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260708183305.244485-6-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
 <20260708183305.244485-6-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 19:30:29 +0000
Message-Id: <20260708193030.5E7511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The driver extracts `request_queue_id` from the hardware-popul=
ated descriptor and uses it as an array index without bounds checking, lead=
ing to out-of-bounds memory corruption.
- [High] A TOCTOU race in `mpi3mr_process_op_reply_q` can cause operational=
 reply descriptors to be missed, leading to IO stalls and timeouts.
- [High] The threaded IRQ polling routine `mpi3mr_isr_poll` enters an unbou=
nded busy-sleep loop waiting for slow hardware IOs to complete, causing sev=
ere CPU consumption.
- [High] An invalid `reply_frame_address` provided in a DMA reply descripto=
r triggers a direct kernel panic.
--

--- Patch [5]: [PATCH v2 05/10] mpi3mr: Fix performance regression caused b=
y extended IRQ poll sleep ---
commit 6c88e5d170a116451ea90d4d4dc8870ab7372f57
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix performance regression caused by extended IRQ poll sleep

This commit reverts a previous change to the threaded IRQ poll sleep
interval, restoring it to 2-20 us to fix a 7% throughput regression
on NVMe direct-attached RAID10 configurations. It also adds missing
dma_rmb() barriers in the admin and operational reply queue loops
to ensure phase bit checks complete before payloads are read.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D5

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 434b66f7b502d..2f787fa36ffdb 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
[ ... ]
> @@ -568,6 +581,12 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mri=
oc,
>  		return 0;
>  	}
> =20
> +	/*
> +	 * Ensure that the descriptor payload is read only after
> +	 * the phase bit check is complete.
> +	 */
> +	dma_rmb();
> +
>  	do {
>  		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
>  			break;

[Severity: Critical]
This is a pre-existing issue, but does this code bounds check the queue ID
before using it as an array index?

In mpi3mr_process_op_reply_q(), the driver computes req_q_idx from
device-supplied DMA memory:

		req_q_idx =3D le16_to_cpu(reply_desc->request_queue_id) - 1;
		op_req_q =3D &mrioc->req_qinfo[req_q_idx];

		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->request_queue_ci));

If the hardware provides an invalid queue ID (such as 0, underflowing to
65535, or a value larger than mrioc->num_op_req_q), could this lead to an
out-of-bounds memory write to the host kernel heap?


[Severity: High]
This isn't a bug introduced by this patch, but does
mpi3mr_process_op_reply_desc() safely handle malformed DMA reply addresses?

If a malicious or faulty PCIe device sends an invalid reply_frame_address,
mpi3mr_get_reply_virt_addr() will return NULL, triggering a panic:

		scsi_reply =3D mpi3mr_get_reply_virt_addr(mrioc,
		    *reply_dma);
		if (!scsi_reply) {
			panic("%s: scsi_reply is NULL, this shouldn't happen\n",
			    mrioc->name);
			goto out;
		}

Could a compromised device or hypervisor repeatedly send crafted DMA frames
containing invalid addresses to intentionally crash the host system?

[ ... ]
> @@ -594,6 +613,12 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mri=
oc,
>  		if ((le16_to_cpu(reply_desc->reply_flags) &
>  		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase)
>  			break;
> +
> +		/*
> +		 * Ensure that the descriptor payload is read only after
> +		 * the phase bit check is complete.
> +		 */
> +		dma_rmb();

[Severity: High]
This is a pre-existing issue, but is there a TOCTOU race condition when
finishing descriptor processing in mpi3mr_process_op_reply_q()?

If the active thread breaks out of the loop after checking the phase bit,
but before it executes:

	atomic_dec(&op_reply_q->in_use);

And the hardware writes a new descriptor and triggers an MSI-X interrupt in
that tiny window, the interrupt handler will fail the atomic_add_unless()
check:

	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1))
		return 0;

Will this permanently drop the interrupt without re-checking for newly
arrived descriptors, potentially stalling the queue until another unrelated
command completes?

[ ... ]
> @@ -744,7 +769,7 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *pri=
vdata)
>  			    mpi3mr_process_op_reply_q(mrioc,
>  				intr_info->op_reply_q);
> =20
> -		usleep_range(MPI3MR_IRQ_POLL_SLEEP, MPI3MR_IRQ_POLL_SLEEP + 1);
> +		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
> =20
>  	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
>  	    (num_op_reply < mrioc->max_host_ios));

[Severity: High]
This isn't a bug introduced by this patch, but does this threaded IRQ polli=
ng
loop busy-wait unboundedly for slow hardware IOs?

When pend_ios exceeds 8, mpi3mr_isr_poll is awoken. The thread loops and
continuously executes usleep_range():

	do {
		...
		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);

	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
	    (num_op_reply < mrioc->max_host_ios));

If multiple slow IOs are pending, will this keep the CPU occupied with
thousands of context switches, rather than going to sleep and waiting for
the actual hardware interrupt when the async IO finishes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708183305.2444=
85-1-ranjan.kumar@broadcom.com?part=3D5
