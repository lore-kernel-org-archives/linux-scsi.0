Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93104FD26C
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781062; cv=none; b=PbD7ZFuQ1lxG221y3ySgWOUZFWzHW0Vguxu4S70oAejZvsDFKcRQYmLFPaGE88h+bUNSc+lF8JTROnyZlGMNurvl3qIxcBas+WgjghrOkx4x3xp2HfIPBHXKcFi3/pdVXSf48c2ZGK9Z7k4aRA0xQ8lwxf6yOumDPVKdEoZbPnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781062; c=relaxed/simple;
	bh=TLk+Cj8W1qtmUXrhx2DTS+udter+tk50JVLSfFFfjWk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jffsp/8X8+8xKyuKdr4A37ha0Eav4jfhh8fL858XIw52H5GiF3zp/KQ0a79/yeWpHReuevtZwdcgiQTyVqFfgJRrsCt2tq9xW0YtxukNMaOWuO6XFEm6Xo23ipTlYZpgj5ITAYEHwOCC9wR58YerWrrmt+CJlwYYKz8AegvNzdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiKaHjgR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiKaHjgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23801F000FF;
	Wed, 30 Sep 2026 15:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790781040;
	bh=iLGwVeuS1RFyGt713zZE/4i+1i+o8GNyBboDV+48dw4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YiKaHjgR+shqi4XJfYIHiCRNWLw1sWgJfO8GRq3X+Mr4f6WQw4kV8aK+730RZFVXi
	 yDWLOu/Yy6cbVbdBogK4BN83i2hC8UWAlo1zHf5fIS0GRyrxzqtYfWRNNWp2j2p8om
	 tzgXUqebESz5bc8N9PanFeukSlCyJ6PMxR7o+NYLEojcqrx2pRkAGyPLwBxoSpG4vf
	 UK+khc+8vKQXRp3ZRf8ynBdVoHyvUdxbRDgDc57TlZUqNm9BeQ2SP/nB1SNIea6NZv
	 S09kg0/vKZ7+8Jtiec/rGzZ2kvxSEw/27VcjfCo9ZWpuvy5PmtOB2zg5rrFkyL5ZOr
	 gmfYXiGAVFFDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: mpi3mr: Poll a reply queue that an interrupt
 found busy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260930145606.2632749-2-usama.arif@linux.dev>
References: <20260930145606.2632749-1-usama.arif@linux.dev>
 <20260930145606.2632749-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 15:10:39 +0000
Message-Id: <20260930151039.F23801F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mpi3mr: unhandled missed reply race under PREEMPT_RT
--

commit c0b0a317901b4ce93a734871bf41b604287947d5
Author: Usama Arif <usama.arif@linux.dev>

scsi: mpi3mr: Poll a reply queue that an interrupt found busy

This patch sets a flag to trigger a thread wakeup when an interrupt finds a
reply queue busy. It aims to prevent missed replies when another context
owns the queue.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index f0d3cd398dd00..102f84667a5cf 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
[ ... ]
> @@ -588,8 +588,11 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mri=
oc,
> =20
>  	reply_qidx =3D op_reply_q->qid - 1;
> =20
> -	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1))
> +	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1)) {
> +		/* The owner may have missed a reply, let the thread poll */
> +		WRITE_ONCE(op_reply_q->enable_irq_poll, true);

[Severity: High]
When this code executes in mpi3mr_process_op_reply_q() under PREEMPT_RT,
does it leave missed IO replies stranded?

Under CONFIG_PREEMPT_RT, the interrupt handler is mpi3mr_isr_primary(),
which exits without checking the enable_irq_poll flag or returning
IRQ_WAKE_THREAD.

Additionally, looking at how the interrupt is requested:

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_request_irq() {
    ...
#else
	retval =3D request_threaded_irq(pci_irq_vector(pdev, index), mpi3mr_isr_pr=
imary,
	    NULL, IRQF_SHARED, intr_info->name, intr_info);
#endif
    ...
}

Because the polling thread handler is explicitly NULL under PREEMPT_RT,
there is no polling thread to wake up to process the missed replies.
Could this cause SCSI command timeouts and host resets during concurrent
IO under PREEMPT_RT?

>  		return 0;
> +	}
> =20
>  	exp_phase =3D op_reply_q->ephase;
>  	reply_ci =3D op_reply_q->ci;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930145606.2632=
749-1-usama.arif@linux.dev?part=3D1
