Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE58A379C5D
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782475376; cv=none; b=leKxIrXdJGVUt+aJUmWw7+MuOfJGYRysTWOoClwqU1MglzliaG+k5GuIRGMMMqpScj2xX8Z5TM1hp8clivA1/+fJoZdEsAxrdZjF5uCnaucCNgtvI1KJXalYnvU0D89+TmoHh94pM6TUY08ladZXSsq2rHWp9Si7fC/Xg+7mBNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782475376; c=relaxed/simple;
	bh=aGBwsUA6e6PzqutXk/uskCrcXiRNP36iJtuI3oL5fpo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DOPoyyPjIuGxE5mYSuhBXdwhu6nIGOHfbRCISKvebRE99HL0KLRG0oX8Q5wgi9mdp/D0wYTKJ/54LNNvzOp2ciF25fb42ooW0qqhTSvSExzB5yWvgvBJofwpm67xoxX+AZLkxnDEt2qd7nQCbyXWO9WWRmJyHUs1e4A95TrZm4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JHG/oNi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JHG/oNi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17191F000E9;
	Fri, 26 Jun 2026 12:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782475375;
	bh=awu6UWDIpyFKA79n0Be2HPuIHeRSLnIINm0ZIENJfKY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JHG/oNi1IZPRY9fe3AhJdVIAzeynvR6p//GXoxU4Wt+QDV41CwfAGtM45vJtsnfJ1
	 zHoEM9suWDrHpGFVylekhX4iK8rMCnMGYgHoXglWzx0cbLntSI+AccT/yKsAzlUSNV
	 Aaznv1iV1qbEn8Iy3Y1pZkoKfJVA60VfX0PlhsH8TDFz9mZKjBPBcS3Ubbq1xyJ5Y+
	 4zYT3vOJNt4uhUKn1n7kPmDihNzk7AjkcJSccnqID36Q5UbdILopGAbYesv+X/8hL/
	 U0GoxkIWhgvebKidWCcXhKDuLk5zca8M1ZColTFgrJqrvhP6yiSQ9tddJYHAAMY13+
	 rwQdQSHxi2ruA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 05/10] mpi3mr: Fix performance regression caused by
 extended IRQ poll sleep
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260626114109.43685-6-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
 <20260626114109.43685-6-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 12:02:54 +0000
Message-Id: <20260626120254.B17191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing dma_rmb() when reading DMA-mapped reply descriptors, riski=
ng stale data processing on weakly ordered architectures.
--

commit f91311d5d4eeee7718829b492ee38d52ed25a32a
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

    mpi3mr: Fix performance regression caused by extended IRQ poll sleep

This commit restores the threaded IRQ poll sleep range from 20-21 us back to
2-20 us. The previously extended interval caused an approximate 7% throughp=
ut
regression on NVMe direct-attached RAID10 configurations. This reverts the
sleep behavior to recover the lost throughput.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 1f2f0951b560e..1d11d7c69536b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -178,7 +178,7 @@ extern atomic64_t event_counter;
>  #define MPI3MR_DEFAULT_SDEV_QD	32
> =20
>  /* Definitions for Threaded IRQ poll*/
> -#define MPI3MR_IRQ_POLL_SLEEP			20
> +#define MPI3MR_IRQ_POLL_SLEEP			2
>  #define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
> =20
>  /* Definitions for the controller security status*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 496d7ca3ab372..32aeae20481ec 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -744,7 +744,7 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *pri=
vdata)
>  			    mpi3mr_process_op_reply_q(mrioc,
>  				intr_info->op_reply_q);

[Severity: High]
This isn't a bug introduced by this patch, but is a dma_rmb() missing when
reading the DMA-mapped reply descriptors?

Looking at mpi3mr_process_op_reply_q() which is called here, the CPU checks
the phase bit of the DMA-mapped descriptor, and then immediately reads the
payload:

mpi3mr_process_op_reply_q() {
...
	if ((le16_to_cpu(reply_desc->reply_flags) &
	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
		atomic_dec(&op_reply_q->in_use);
		return 0;
	}

	do {
		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
			break;

		req_q_idx =3D le16_to_cpu(reply_desc->request_queue_id) - 1;
...
}

And similarly at the end of the loop:

		if ((le16_to_cpu(reply_desc->reply_flags) &
		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase)
			break;
...

Without an intervening dma_rmb(), could weakly ordered architectures (like
ARM64) fetch the descriptor payload via out-of-order execution or speculati=
on
before the phase bit check is complete?

If the hardware is still updating it, could this result in processing stale
data such as an incorrect request_queue_id?

It looks like mpi3mr_process_admin_reply_q() might have the same pattern
where it reads request_queue_ci right after checking the phase bit without
a memory barrier.

> -		usleep_range(MPI3MR_IRQ_POLL_SLEEP, MPI3MR_IRQ_POLL_SLEEP + 1);
> +		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
> =20
>  	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
>  	    (num_op_reply < mrioc->max_host_ios));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626114109.4368=
5-1-ranjan.kumar@broadcom.com?part=3D5
