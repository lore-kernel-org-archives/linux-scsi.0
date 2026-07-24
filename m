Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F3F3CB544
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890268; cv=none; b=buE10j375Mer6avewksQ+QmyiKC2f2xSFxK127GPrDQFmfk+o12xOj9CiWOSai1dBkrDzyKe9DP6na0WNG3PRUZGOU3yCy4x/NRkAjRJubJd5jcwBi4dlZd8jxEhjEwcs90aekC+kK8vdJTssrmqQ+P8qQNG2aAf0+fwYrtIDAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890268; c=relaxed/simple;
	bh=dhz/gpblTmEfodGkanlon+8iLh/K4HBn1b7Pd45/5sQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=flcfflefooxzZlkQyhmTKzm4KE6X7sgx1p56eDS2dz9u73qA5TR9lyzU1+m/PxBbtYSjmEein7+9lBCsZU5V3FubNgN3Pb19Ai7cVtrL/AlCI7wBs3xIeiKpEXGN83CJngy+B3+kwoWIh0mE2Rb9Hv/ZhPal4FweMlrJ2PxyGgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDdoxVjr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDdoxVjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37551F000E9;
	Fri, 24 Jul 2026 10:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784890267;
	bh=NtjMPwEnQW70bGlD4TqrG5T0deytCGQSs3jtQ5fZ69s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MDdoxVjrmU869Suo+SvlP+Nox3B/1BbSnbTJIpy9Hat6VnbVuXDoWr5J5JA6KVIeV
	 DnxYfJg5cEyy9y4Gbv0JIcTAAVtQe6aLM4GRApI/GoZGds+KGzbaXEyQAicF+kJhXJ
	 S9krQVPf134LXs/8WG5H8/9IBo5cFH15DtA9z8pVBEe0wo2B9o0Ud4CY8gortMZvuS
	 BvIKUm9KsHzFdanB/HETgOouqF2Ox0u6tAI3W55LNTGlxclYMh55nEo8sMMHBwApvM
	 5CTOdC/06aBVwzZHfiI3r+v+bx0uxswC2anXTUt6MK0Kx9Xvo2gLoMRoTPRQ6ixMZe
	 CyeJlaa64Begg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/10] mpi3mr: Fix memory leak on operational queue
 creation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724102505.115136-7-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
 <20260724102505.115136-7-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 10:51:06 +0000
Message-Id: <20260724105106.D37551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Race condition in interrupt pointer clearing causes Use-After-Free=
 and TOCTOU NULL pointer dereferences.
- [High] Permanent DMA memory leak of `q_segment_list` when `kzalloc_objs` =
fails during queue allocation.
--

--- Patch [6]: [PATCH v3 06/10] mpi3mr: Fix memory leak on operational queu=
e creation failure ---
commit 30cab2ccb258127e2dd2cf1a6d7a0d940a8b72fa
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix memory leak on operational queue creation failure

When operational queue creation fails after one or more queues have
been created, the error path frees the queue information arrays but
does not release the DMA memory segments associated with the created
queues, resulting in a memory leak. Fix this by ensuring that partially
allocated segments are freed immediately if a queue fails to create.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D6
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar=
@broadcom.com?part=3D6

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 9f7cee26ebcd3..370ad85681171 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2020,6 +2020,10 @@ static void mpi3mr_free_op_reply_q_segments(struct=
 mpi3mr_ioc *mrioc, u16 q_idx)
>  	u16 j;
>  	int size;
>  	struct segments *segments;
> +	u16 midx =3D REPLY_QUEUE_IDX_TO_MSIX_IDX(q_idx, mrioc->op_reply_q_offse=
t);
> +
> +	if (midx < mrioc->intr_info_count)
> +		mrioc->intr_info[midx].op_reply_q =3D NULL;

[Severity: High]
This isn't a bug introduced by this patch, but can this clear the pointer
while an interrupt is actively accessing it?

Since we clear mrioc->intr_info[midx].op_reply_q without disabling the
IRQ or calling synchronize_irq(), a hardware interrupt firing concurrently
could access the queue locklessly.

For example, in drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_isr_poll():

    if (!atomic_read(&intr_info->op_reply_q->pend_ios))
        break;

The pointer is evaluated unconditionally and could be set to NULL
concurrently before being read again.

Similarly, in mpi3mr_isr_primary():

    if (intr_info->op_reply_q)
        num_op_reply =3D mpi3mr_process_op_reply_q(mrioc,
            intr_info->op_reply_q);

There is a race window where op_reply_q can be set to NULL after the
check, resulting in processing a queue whose segments are actively
being freed.

> =20
>  	segments =3D mrioc->op_reply_qinfo[q_idx].q_segments;
>  	if (!segments)
>  		return;

[Severity: High]
This is a pre-existing issue, but could this early return bypass the
cleanup for q_segment_list?

In mpi3mr_alloc_op_reply_q_segments(), if the kzalloc_objs() call for
q_segments fails, it returns without cleaning up the successfully allocated
q_segment_list:

    op_reply_q->q_segments =3D kzalloc_objs(struct segments,
                                          op_reply_q->num_segments);
    if (!op_reply_q->q_segments)
        return -ENOMEM;

Because q_segments is NULL in this failure path, the cleanup function
mpi3mr_free_op_reply_q_segments() returns early here, bypassing the
dma_free_coherent() cleanup for q_segment_list. This could cause a
permanent DMA memory leak of q_segment_list.

Does this same vulnerability exist in mpi3mr_alloc_op_req_q_segments()
and mpi3mr_free_op_req_q_segments() where similar early returns occur?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724102505.1151=
36-1-ranjan.kumar@broadcom.com?part=3D6
