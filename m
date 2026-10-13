Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47C32EB0F
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 00:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850067; cv=none; b=fLwdzp/ZqLtkOsCOuijZi9A+k4IzlU6Xlyhox7RDbVyyyL8n51gOipF1X/C9NL9Mr4IvSLYKj8vT92quXKVT+1UaESKSaAvj5yAmYmmYfk6dAl2AIFYJtwYwfH8Jhh+U5jKG+BxfXAeobXeYLVF7V9muhycTASforwsDugZrFnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850067; c=relaxed/simple;
	bh=zs5Fveyl3EWZ/IfOvGqxfIm3PvYIIh6795SJIU3NBAc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HC9caDOfkaJLFRieqd0j2lyc9vj7zF0l3CCwZsoekbGZZ9uDSUyHrlv8wG6sa/g0cBivXb4dpbv0vvsW2ium8tuAJnuy0WvTeb/55/t8JzuyAdYZf8Zu492QczRbztKhskmbb9jCR8paSbSHyU0cKaT0MT7C5qKJTF73hBVnGJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeTAyc3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeTAyc3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAEF1F0089B;
	Tue, 13 Oct 2026 00:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850066;
	bh=f/ceiu6tQzndeTgfWOvSW2guTddhpZ79A+yrfZ4ejH4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XeTAyc3pLt7429dz9q1X0Xzrsh3sL8054FxLy+3EDth5hA1S0Kxwn0fTGdI5GHiwq
	 FgDyTepaTDnB7ZNH3c7Q++7QVR7x3/QK1aUyJHZW7+hHySQhtx8NVACSaNJKpODJwY
	 xeit4BwF6Sy6ZA1hcZP9fwlXrf2FdxcuZK8OugNGH5mdq00qInKugAryLGy4wYLovb
	 WJ+2TcsJJ96jCnZOljHVtVbmL1TXNI+VJQfUCJwlVKJPFRbsREJklflcOH74SmoQEy
	 Ga3m/BQfqTrOxSj86KrIiR+ZECoyQ4rEku+U4W0ggqh17JhvgiTpNNaOLRWxbVprXZ
	 GHaxxcK5K8Qww==
Message-ID: <sashiko-outbox-168775@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 3/8] lpfc: Fix kernel oops when unmapping scsi dma
 buffers for an aborted cmd
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013001648.62289-4-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
 <20261013001648.62289-4-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 00:07:45 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: lpfc: incomplete fix leaves DMA unmap oops window open durin=
g LUN reset
- [High] scsi: lpfc: data race on cmd_flag can lose LPFC_DRIVER_ABORTED
--

commit 675425a729cb7c6ac7d9c7e57d4ee3019d93591f
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cmd

This commit attempts to fix a kernel oops at dma_unmap_sg_attrs by ensuring
inflight scsi I/Os are counted if either LPFC_IO_ON_TXCMPLQ or
LPFC_DRIVER_ABORTED is set. This is to keep the LLDD retaining an interest
in the scsi_cmnd and avoid premature unmapping.

> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index a167ad96d2a62..7a187d0efaa92 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -12739,8 +12739,12 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint=
16_t tgt_id, uint64_t lun_id,
[ ... ]
> -		if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
> -		    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ))
> +		/* Only count FCP i/o */
> +		if (!(iocbq->cmd_flag & LPFC_IO_FCP))
> +			continue;
> +		/* Count i/o whilst LLDD retains an interest in the scsi_cmnd */
> +		if (!(iocbq->cmd_flag &
> +				(LPFC_IO_ON_TXCMPLQ | LPFC_DRIVER_ABORTED)))
>  			continue;

[Severity: High]
Does this still leave a window open for the DMA unmap oops during LUN reset?

If a hardware completion arrives just before the SCSI error handler calls
lpfc_abort_handler(), the fast-path IRQ handler lpfc_sli_iocbq_lookup_by_ta=
g()
removes the IOCB from TXCMPLQ and clears LPFC_IO_ON_TXCMPLQ.

Because the command is no longer on the TX queue, lpfc_abort_handler()
skips it and returns FAILED without ever setting LPFC_DRIVER_ABORTED:

drivers/scsi/lpfc/lpfc_scsi.c:lpfc_abort_handler() {
    ...
	/* the command is in process of being cancelled */
	if (!(iocb->cmd_flag & LPFC_IO_ON_TXCMPLQ)) {
		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
			"3169 SCSI Layer abort requested I/O has been "
			"cancelled by LLD.\n");
		ret =3D FAILED;
		goto out_unlock_ring;
	}
    ...
}

If the SCSI error handler escalates to lpfc_device_reset_handler(), it
flushes I/Os by calling lpfc_sli_sum_iocb(). Since both LPFC_IO_ON_TXCMPLQ
and LPFC_DRIVER_ABORTED are 0, wouldn't lpfc_sli_sum_iocb() skip the
command and return 0?

This could allow the LUN reset handler to assume no commands are inflight
and finish, allowing the SCSI midlayer to free or repurpose the scsi_cmnd.
Finally, the delayed softirq completion handler lpfc_scsi_cmd_iocb_cmpl()
could execute and call lpfc_scsi_unprep_dma_buf() on the freed scsi_cmnd.


[Severity: High]
Can a data race on cmd_flag cause LPFC_DRIVER_ABORTED to be lost?

The cmd_flag is a 32-bit field updated using non-atomic bitwise operators.
The lpfc_sli_iocbq_lookup_by_tag() function clears LPFC_IO_ON_TXCMPLQ in
the completion handler holding only pring->ring_lock:

drivers/scsi/lpfc/lpfc_sli.c:lpfc_sli_iocbq_lookup_by_tag() {
    ...
			cmd_iocb->cmd_flag &=3D ~LPFC_IO_ON_TXCMPLQ;
    ...
}

Concurrently, abort handlers like lpfc_sli_issue_abort_iotag() and
lpfc_sli4_issue_abort_iotag() set LPFC_DRIVER_ABORTED holding buf_lock
and hbalock, but explicitly without pring->ring_lock:

drivers/scsi/lpfc/lpfc_sli.c:lpfc_sli4_issue_abort_iotag() {
    ...
	cmdiocb->cmd_flag |=3D LPFC_DRIVER_ABORTED;
    ...
}

If LPFC_DRIVER_ABORTED is lost due to this race, lpfc_sli_sum_iocb()
could miss the command. This would bypass the logic introduced in this
patch and lead to early unload or unmap while hardware DMA is still active.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013001648.6228=
9-1-nkirkland2304@gmail.com?part=3D3
