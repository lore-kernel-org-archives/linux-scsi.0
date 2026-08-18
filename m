Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93842439F89
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076698; cv=none; b=da5gMI2dSF0Tt3TKdhkiejhbMhG33ijr6zN0y6cwac5rNzWJijWILx+UwmE3rfUfBR3klUTGHm56zFKSbsc2pjTW25/XeJ1t8IQFJRxjJKGVgOsR8Dv2c88lup4+0wMRYtGdGoQWbnEpMoNn9UKyG92JyZ3a6/UUkDBvt09ER2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076698; c=relaxed/simple;
	bh=qWpuPuAki/OA9wras3IToP+m4svFJoQDpiqF/6SmYx4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Sxw/9QljZHkNu1RSPMBvclYzftxTIHOyhMOvlwzKP/nht1AwkZw3hzNxtWF4StGB1M+Yui9Aeuu/AScAhHl9rs7oWFw9BV1vHBRmhtROSvm/fVaHh/BQkIHnQv7X3+Ne0BJoh7nslRppv/+/gITqjPyfNPQWzZAsWTRLAOg+g68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyuuWb0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyuuWb0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F35A1F000E9;
	Tue, 18 Aug 2026 18:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787076697;
	bh=hX/b0g7palmQulMdtbJaEp8nRLpBo6cjGGr6Jm0DhvA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WyuuWb0ay0CYgaXoGyV8p+4w7E/2wku2yWgLC5sgBcMe8BBfmf9jt3LaRknkNOCQF
	 rXOXXy/2XJ3RsLoB2M/1iCROv/NALFkNyVbknd7PjOWWbCKC7vyV9qgEwNTWQVk4Tt
	 KK5CFA9gnlwARqdERKGQAcJyYNa3nRp+Fu4Bp25n5wDFIbWMxcEnZyDRlvMiVTt/IG
	 cGWuLjFfEBRiQUxVdEAsAxm4wPgr8k2Ls9cMtXIJUDRrjff9lTcOrbuT5kHaXJAnML
	 gHkYTh1Xx/yVfXCY0rjbzqw04bsrCJ2rcj1oxvOrAtr9p1K8JLwoNHJf/HzxFkbyyj
	 kjifyzXSUvczg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/17] mpi3mr: Fix out-of-bounds sense buffer access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-8-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-8-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:11:37 +0000
Message-Id: <20260818181137.5F35A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] 64-bit division by a non-constant integer causes a `__umoddi3` link=
 error on 32-bit platforms with 64-bit DMA addresses.

Pre-existing issues:
- [High] Missing `dma_rmb()` in the operational and admin reply queue polli=
ng loops.
--

--- Patch [7]: [PATCH 07/17] mpi3mr: Fix out-of-bounds sense buffer access =
---
commit 7536a65ff98a39b2e42c7eb228f93604d2b3086e
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds sense buffer access

The sense buffer address reported on completion is turned into a
virtual address with no range check, so an address outside the pool
resolves to memory that does not belong to it.

Check that it lies within the pool and is correctly aligned.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 5e61448d8dbc6..103ce9dd22666 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -141,6 +141,12 @@ void *mpi3mr_get_sensebuf_virt_addr(struct mpi3mr_io=
c *mrioc,
>  	if (!phys_addr)
>  		return NULL;
> =20
> +	if (phys_addr < mrioc->sense_buf_dma ||
> +	    (phys_addr > mrioc->sense_buf_dma +
> +	     (mrioc->num_sense_bufs * MPI3MR_SENSE_BUF_SZ) - MPI3MR_SENSE_BUF_S=
Z) ||
> +	    ((phys_addr - mrioc->sense_buf_dma) % MPI3MR_SENSE_BUF_SZ))

[Severity: Low]
Does this modulo operation cause a build failure on 32-bit platforms with
64-bit DMA addresses?

When building for a 32-bit architecture with CONFIG_ARCH_DMA_ADDR_T_64BIT
enabled (such as x86 PAE or ARM LPAE), dma_addr_t is 64-bit. Modulo
dividing a 64-bit integer by a runtime variable forces the compiler to
emit a call to __umoddi3, which is not exported in the kernel.

The issue was flagged in mpi3mr_get_reply_virt_addr() within the same file:

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_get_reply_virt_addr() {
    ...
	if ((phys_addr < mrioc->reply_buf_dma) ||
	    (phys_addr > mrioc->reply_buf_dma_max_address - mrioc->reply_sz) ||
	    ((phys_addr - mrioc->reply_buf_dma) % mrioc->reply_sz))
		return NULL;
    ...
}

[Severity: High]
This is a pre-existing issue, but does the reply queue processing miss
memory barriers?

Looking at the polling loops for both the operational and admin reply queue=
s,
the phase bit is checked without a subsequent dma_rmb():

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_process_op_reply_q() {
    ...
	if ((le16_to_cpu(reply_desc->reply_flags) &
	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
		atomic_dec(&op_reply_q->in_use);
		return 0;
	}
    ...
}

And similarly in mpi3mr_process_admin_reply_q():

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_process_admin_reply_q() {
    ...
	if ((le16_to_cpu(reply_desc->reply_flags) &
	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
		atomic_dec(&mrioc->admin_reply_q_in_use);
		return 0;
	}
    ...
}

Under high concurrent I/O throughput on weakly-ordered architectures like
ARM64, when the hardware DMAs a reply descriptor, could the CPU speculative=
ly
execute reads for the descriptor payload or sense buffer before the phase b=
it
condition is definitively synchronized?

If the phase bit changes, without a memory barrier, subsequent reads to oth=
er
descriptor fields might bypass the phase bit evaluation and read stale memo=
ry
data from the previous iteration.

> +		return NULL;
> +
>  	return mrioc->sense_buf + (phys_addr - mrioc->sense_buf_dma);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D7
