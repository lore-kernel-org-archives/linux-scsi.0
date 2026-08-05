Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A1D42CB02
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785929559; cv=none; b=rJP6bQyZxpUaCedsx08Vrz0uOt9cldgRN6rhGIGKd22p4bCyrhxwS8kdTNh2Eq5AQnLJ6IH2Mb/xAHscVng4X2CWgq+qb094gcIdGQNzoPqvE275BoZ2s3WyoPB6clbBMGGrX5w1BjQLUwnDPm6yypSqfhp3wW/77ftDjd97hnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785929559; c=relaxed/simple;
	bh=Znnvsq8ivPX+Qwkrze9nvUbnkmoO1Y+RzRFRS0DBsnw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lCe0XdVNBmwGwVFOIMUyKCjrLwusfXxZsas9nJJvG7CWbIVhaJrKbw34i36jK2U0ZnpUVa95CSbGflVxfTI4fc/4dyFXr2bTtUEsvZmWkrjdceCEPKGN1HS8vdJfyWzjTEJXfgF/Fb/tJ5nhRsExnW81xeQ97y0oJ58dF+7JZ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rs2czZaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rs2czZaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427781F00A3E;
	Wed,  5 Aug 2026 11:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785929558;
	bh=fuWcgU0Yuef4tjd5NDoIHzmHm/RG/PkxKwYaKglexIc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rs2czZazbEBDhbF0Vh0ZiNTxccfNrLvP02VDC6ZupxDMZAXvaA6emH/GnwhEsYqfa
	 cZNfTeb/JjAZ0soOq2VUmfYH/2k6XtV5It/6euwnDbSBxhacCwK24Ji/77/sbJy0Mw
	 QfXA/VeSITRbwhC1kyNQVToUyspOk1yw6FgjtJTfolQwLq0PQx9d26x/1RrJnQs8G/
	 lDUMDlyhLoNjSD/wO8yVZ0vG5N0ElzKQAxKpGA391rLZ5haHdqkS2KLDFTwj8ZOxLa
	 TA5GjK6xEz/T0TK+MXxQRCX2dq3SgcVBo4MzRKBGWgIdJZtdFUGLaBhNjNJPBlHNPd
	 fb4OwRHAgp7ag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/10] mpi3mr: Fix performance regression caused by
 extended IRQ poll sleep
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805110634.346670-6-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
 <20260805110634.346670-6-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 11:32:37 +0000
Message-Id: <20260805113238.427781F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The threaded IRQ polling loop will loop indefinitely if `pend_ios`=
 becomes negative due to skipped corrupt descriptors.

Pre-existing issues:
- [High] The admin reply queue path reposts unvalidated DMA addresses to th=
e hardware free queue when virtual address lookup fails, causing host memor=
y corruption.
- [High] Missing release memory barrier when unlocking the `in_use` queue l=
ock, allowing race conditions on weakly ordered architectures.
--

--- Patch [5]: [PATCH v4 05/10] mpi3mr: Fix performance regression caused b=
y extended IRQ poll sleep ---
commit 19ca49ca3a484c6837fd5a670f8512d409c2678d
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix performance regression caused by extended IRQ poll sleep
   =20
This patch restores the IRQ poll sleep base to 2 us and introduces bounds
checking for request queue IDs to prevent infinite polling. It also adds
memory barriers in the admin and operational reply queue processing loops
and fixes a panic condition on malformed DMA reply addresses.

Link: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@br=
oadcom.com?part=3D5
Link: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@b=
roadcom.com?part=3D5
Link: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@b=
roadcom.com?part=3D5

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c

[ ... ]

> @@ -565,15 +578,33 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mr=
ioc,
>  	reply_desc =3D mpi3mr_get_reply_desc(op_reply_q, reply_ci);
>  	if ((le16_to_cpu(reply_desc->reply_flags) &
>  	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
> +		/* Recheck under in_use before releasing, to avoid a reclaim race */
> +		dma_rmb();
> +		if ((le16_to_cpu(reply_desc->reply_flags) &
> +		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) =3D=3D exp_phase)
> +			goto process_desc;
>  		atomic_dec(&op_reply_q->in_use);

[Severity: High]
This is a pre-existing issue, but is a release memory barrier missing when
unlocking the in_use queue lock?

Both here and at the end of mpi3mr_process_op_reply_q(), the lock state is
released via atomic_dec():

    op_reply_q->ci =3D reply_ci;
    op_reply_q->ephase =3D exp_phase;
    atomic_sub(threshold_comps, &op_reply_q->pend_ios);
    atomic_dec(&op_reply_q->in_use);

Since non-value-returning RMW atomic operations like atomic_dec() do not
imply memory barriers, could weakly ordered architectures reorder the writes
to op_reply_q->ci and op_reply_q->ephase after the in_use decrement?

Could this allow another CPU to acquire in_use but read stale values for ci
and ephase, causing it to double-process reply descriptors?

>  		return 0;
>  	}

[ ... ]

> @@ -744,11 +787,12 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *p=
rivdata)
>  			num_op_reply +=3D
>  			    mpi3mr_process_op_reply_q(mrioc,
>  				intr_info->op_reply_q);
> +		if (!atomic_read(&intr_info->op_reply_q->pend_ios))
> +			break;

[Severity: High]
Can pend_ios become negative and cause this loop to run indefinitely?

If mpi3mr_process_op_reply_q() encounters a corrupted descriptor:

    if (unlikely(req_q_idx >=3D mrioc->num_op_req_q)) {
        ioc_err(mrioc, "Invalid request queue id %d, skipping reply\n",
            req_q_idx + 1);
        goto next_reply;
    }

It skips the reply but still increments threshold_comps, which is later
subtracted from pend_ios. If the descriptor did not correspond to a tracked
host submission, couldn't this decrement pend_ios below zero?

Since this exact equality check (!atomic_read) evaluates to false for
negative values, will the polling loop fail to break and wait indefinitely?

> -		usleep_range(MPI3MR_IRQ_POLL_SLEEP, MPI3MR_IRQ_POLL_SLEEP + 1);
> +		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
> =20
> -	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
> -	    (num_op_reply < mrioc->max_host_ios));
> +	} while (num_op_reply < mrioc->max_host_ios);
> =20

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3430,8 +3430,12 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_io=
c *mrioc,
>  		scsi_reply =3D mpi3mr_get_reply_virt_addr(mrioc,
>  		    *reply_dma);
>  		if (!scsi_reply) {
> -			panic("%s: scsi_reply is NULL, this shouldn't happen\n",
> -			    mrioc->name);
> +			ioc_err(mrioc, "scsi_reply is NULL, invalid reply_frame_address\n");
> +			/*
> +			 * Do not let the caller repost an address that
> +			 * failed virt-addr lookup back to the hardware.
> +			 */
> +			*reply_dma =3D 0;

[Severity: High]
This isn't a bug introduced by this patch, but does the admin reply queue
path suffer from the same unvalidated DMA address issue fixed here for the
operational queue?

In mpi3mr_process_admin_reply_desc():

    def_reply =3D mpi3mr_get_reply_virt_addr(mrioc, *reply_dma);
    if (!def_reply)
        goto out;

If def_reply is NULL, the function jumps to the out label but fails to
clear *reply_dma. Then in mpi3mr_process_admin_reply_q():

    mpi3mr_process_admin_reply_desc(mrioc, reply_desc, &reply_dma);
    if (reply_dma)
        mpi3mr_repost_reply_buf(mrioc, reply_dma);

Will this cause the caller to unknowingly repost the unvalidated, non-zero
reply_dma back to the hardware free queue, leading to host memory
corruption?

>  			goto out;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805110634.3466=
70-1-ranjan.kumar@broadcom.com?part=3D5
