Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DEB42E8E9
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785930030; cv=none; b=En73TRDLDGrmUwu8qYGueabCLZX77HJB5odSdByfw6mJQKf19DbkZQPgirEoOSXUKVrBbgRSwp+c+8QKa4JJspo+eIznfrk5bo1iZXRyEMRrc2Cb7x+BytY1TYLqtjvEpmd5z6snsIX5GtEoIs3lvVnXOWfJByZprONAjzGGy70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785930030; c=relaxed/simple;
	bh=p739HKICrpzPz5mTDh5NMTmdoHhy5rqexe8ZvHABhsc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cCDS4skyW83pm0t6zNoo3DWfeFmU2IdGPWVaPpkIsBoLh2UA+f96pZRF9S5mCgUpV/Fc4BXmCL08rdFgV4DM630ZbuuBAtlpqT3znfNBkuuATX0MR2sG1G4e6s2wamvLHpY5td+Bdkis8DRsbchUs+1n0kEWZvqmivzAg50T228=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNYKQs1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNYKQs1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0111F00A3D;
	Wed,  5 Aug 2026 11:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785930028;
	bh=kLJzhPsqZyuXECoXRgIy3WOJX6GPaOgrTTyPkyArufY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YNYKQs1/5kbS5yUF0McAKeMMqF2A0KmuJU3+c63ogtd8fOgIOItkTIi/j8GlsQ/Rc
	 PISsxM1azfIx4yRnq12P8aQ/+pWk+haHLKK2IN4oNX0Y67kYxVZH/54+nCHqK/f7uY
	 +7vSjxStWmHchbSgYV7MtBHpcbF62SpsOQPPvGOvm7qQAnj4O/TW+rql3u07J81aq9
	 M3w27Iq9WPWZDzYbzrz3+A8g62tMDRx4B44IUuf8gSQ2sMzbMI7d088ie0O5PqfR5y
	 /DcXb8nmBOgC1lsnQd46lPGDvAklhH2vnVouqWMA0TG3bcoyPPQGU3kvpVXN66qMwt
	 F9LoNZOrXdOtg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/10] mpi3mr: Fix memory leak on operational queue
 creation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805110634.346670-7-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
 <20260805110634.346670-7-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 11:40:27 +0000
Message-Id: <20260805114028.3B0111F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The threaded IRQ handler `mpi3mr_isr_poll` may exit early without =
re-enabling the IRQ, leaving the interrupt line permanently disabled.
- [High] Polling paths pass a potentially NULL `op_reply_q` pointer to `mpi=
3mr_process_op_reply_q`, leading to a kernel panic.
--

--- Patch [6]: [PATCH v4 06/10] mpi3mr: Fix memory leak on operational queu=
e creation failure ---
commit 3a3eabe2f05c3500da7a32007ea4df206d106e35
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix memory leak on operational queue creation failure

When operational queue creation fails, the error path frees queue informati=
on
arrays but does not release DMA memory segments. This patch ensures partial=
ly
allocated segments are freed immediately. It also attempts to resolve races
in the queue segment free/alloc paths by clearing the queue pointer before
freeing.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D6
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar=
@broadcom.com?part=3D6
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar=
@broadcom.com?part=3D6

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index e469507045dd6..880c07bdc9738 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c

[ ... ]

> @@ -767,10 +770,15 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *p=
rivdata)
>  {
>  	struct mpi3mr_intr_info *intr_info =3D privdata;
>  	struct mpi3mr_ioc *mrioc;
> +	struct op_reply_qinfo *op_reply_q;
>  	u16 midx;
>  	u32 num_op_reply =3D 0;
> =20
> -	if (!intr_info || !intr_info->op_reply_q)
> +	if (!intr_info)
> +		return IRQ_NONE;
> +
> +	op_reply_q =3D READ_ONCE(intr_info->op_reply_q);
> +	if (!op_reply_q)
>  		return IRQ_NONE;

[Severity: High]
Does returning early here leave the interrupt permanently masked?

If a concurrent queue deletion (e.g., from a reset) sets op_reply_q to NULL
right after mpi3mr_isr() reads it as non-NULL, the hardirq handler will
disable the IRQ and schedule this threaded handler:

mpi3mr_isr()
   disable_irq_nosync(intr_info->os_irq);
   return IRQ_WAKE_THREAD;

When mpi3mr_isr_poll() runs, it will read op_reply_q as NULL and return
IRQ_NONE without calling enable_irq(intr_info->os_irq). Future IOs on the
operational queue associated with this vector would hang.

> =20
>  	mrioc =3D intr_info->mrioc;

[ ... ]

> @@ -2021,10 +2032,17 @@ static void mpi3mr_free_op_reply_q_segments(struc=
t mpi3mr_ioc *mrioc, u16 q_idx)
>  	u16 j;
>  	int size;
>  	struct segments *segments;
> +	u16 midx =3D REPLY_QUEUE_IDX_TO_MSIX_IDX(q_idx, mrioc->op_reply_q_offse=
t);
> =20
> -	segments =3D mrioc->op_reply_qinfo[q_idx].q_segments;
> -	if (!segments)
> -		return;
> +	/*
> +	 * Stop the ISR/poll thread from picking up this queue before its
> +	 * segments are freed below, and wait for any in-flight handler
> +	 * that already has the old pointer to finish using it.
> +	 */
> +	if (midx < mrioc->intr_info_count) {
> +		WRITE_ONCE(mrioc->intr_info[midx].op_reply_q, NULL);
> +		synchronize_irq(pci_irq_vector(mrioc->pdev, midx));
> +	}
> =20
>  	if (mrioc->enable_segqueue) {

[Severity: High]
Could clearing op_reply_q to NULL here cause a NULL pointer dereference
in polling paths?

Polling paths read the op_reply_q pointer from the intr_info array and pass
it to mpi3mr_process_op_reply_q() without a NULL check:

mpi3mr_op_request_post()
    mpi3mr_process_op_reply_q(mrioc, mrioc->intr_info[midx].op_reply_q);

mpi3mr_poll_pend_io_completions()
    mpi3mr_process_op_reply_q(mrioc, mrioc->intr_info[i].op_reply_q);

If a concurrent controller reset frees the queues and sets this pointer
to NULL, mpi3mr_process_op_reply_q() will immediately dereference it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805110634.3466=
70-1-ranjan.kumar@broadcom.com?part=3D6
