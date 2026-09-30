Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416CA4DE701
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 15:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781643; cv=none; b=VMbR2AhmD6yW68etenAbMhAwo9SYkKRO4mkUuiXh4KFGMs3zv82sT1tFPFwrhLcWayB32LDPpOyYQ5ar5IZiz3VPtsQygppx8hNTvHZD8CsecU+qodESAbuOy/PUw9qX/m9xFtaxBRTZY0mTuyl/vmT7ZDSyiWHUgQcE9cANlIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781643; c=relaxed/simple;
	bh=pndn+8zkw4KwC5NWC7Jk24+1QO8/70Lt1NWTqr4GVeQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bx+tDG5WdxsqWUXGjhVR9uBIth2ZxfYWmA5I/6yRD6ULoC4fCcASxObz46qqwjBbeR/gdMu6oXiaoFy0CtxJtIVqlH8Wb4B9HSFS1mDJmS8LuiweVnqj8IOUiRtYqUZiOrUmOev6KZ+EbYi+Qz1ToFbioMuM8IX13NeJjej66FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXFm4UIN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXFm4UIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA8F1F000FF;
	Wed, 30 Sep 2026 15:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790781632;
	bh=8HNi+G/TLOPDjtbc9GI8m6Y1EhSJUPeIyGIzag0IX7o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LXFm4UINeVqybop23Rppz2OB4TH08tOUPE8Zo7g0UV17fUsVWB2EAK7b7SSd51qg0
	 EFcmnLZy7SYHpfohhhV42TU9efymk64SnZ2IH9CRntGEPNaCXNKzfuQNISB7yaXWZL
	 j2b0ebDQiY2UfVqaef5+zhU8VWgaMrLRYHO+JW/ccAQhhhTXU/St7p5FHsIE8DMFBb
	 HkMG1CkrM1VfvUNXO53yjhu6gr4LhBnTTw549W493XTOf+xOmPrnXGNah55djhNSW/
	 6vONt+a0xLZB2DCeRinCnOH+gRCiTknmh8yAWQhEBER5sMWCX+BceJRqe6sncAHpSm
	 5589Q5ugvW2/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: mpi3mr: Stop IRQ polling when no reply is
 ready
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260930145606.2632749-3-usama.arif@linux.dev>
References: <20260930145606.2632749-1-usama.arif@linux.dev>
 <20260930145606.2632749-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 15:20:32 +0000
Message-Id: <20260930152032.BDA8F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: mpi3mr: dropped IRQ poll trigger causes hard-IRQ storm
--

commit a00593b528c873a4c3ec905f3fa02c054a4e3bf0
Author: Usama Arif <usama.arif@linux.dev>
Subject: scsi: mpi3mr: Stop IRQ polling when no reply is ready

This commit modifies the IRQ polling logic in the mpi3mr driver to stop
polling when a post-sleep check finds the queue empty. It introduces a
barrier and a recheck of pend_ios to avoid losing wakeups from concurrent
submitters.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 102f84667a5cf..6f113d8625bb4 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
[ ... ]
> @@ -819,17 +829,34 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *p=
rivdata)
> =20
>  		if (!midx)
>  			mpi3mr_process_admin_reply_q(mrioc);
> -		num_op_reply +=3D
> -		    mpi3mr_process_op_reply_q(mrioc, op_reply_q);
> +		num_op_reply +=3D mpi3mr_process_op_reply_q(mrioc, op_reply_q,
> +							  &checked_empty);
> +		/* Stop only on an empty check made while owning the queue */
> +		if (slept && checked_empty) {
> +			idle =3D true;
> +			break;
> +		}
>  		if (!atomic_read(&op_reply_q->pend_ios))
>  			break;
> =20
>  		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
> +		slept =3D true;
> =20
>  	} while (num_op_reply < mrioc->max_host_ios);
> =20
> -	if (op_reply_q)
> -		op_reply_q->enable_irq_poll =3D false;
> +	if (op_reply_q) {
> +		WRITE_ONCE(op_reply_q->enable_irq_poll, false);
> +		if (idle) {
> +			/*
> +			 * Recheck after clearing, pairs with atomic_inc_return()
> +			 * in mpi3mr_op_request_post().
> +			 */
> +			smp_mb();
> +			if (atomic_read(&op_reply_q->pend_ios) >
> +			    MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT)
> +				WRITE_ONCE(op_reply_q->enable_irq_poll, true);
> +		}
> +	}

[Severity: Medium]
Could this unconditional clearing of the flag combined with gating the rech=
eck
behind if (idle) allow a concurrent submitter's trigger to be overwritten a=
nd
lost?

If the polling thread processes all replies and pend_ios drops to 0, it bre=
aks
the loop with idle =3D false.

If a concurrent submitter in mpi3mr_op_request_post() then posts a burst of
I/Os, surpasses the trigger threshold, and sets enable_irq_poll =3D true, t=
he
polling thread will subsequently execute WRITE_ONCE(op_reply_q->enable_irq_=
poll, false).

Because idle is false, the thread skips the smp_mb() barrier and the pend_i=
os
recheck. Doesn't this blindly overwrite the submitter's flag and leave
enable_irq_poll disabled, forcing all completions into the hard IRQ handler?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930145606.2632=
749-1-usama.arif@linux.dev?part=3D2
