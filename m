Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A673D0BED
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 11:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806365; cv=none; b=bcu80/n9pYyR27z2Y7Pot9yJj9dT96Fvln5DHvnQWRo1dO9H70yebrj26bYPoPS/6JIFE97If+DZqAf4gc+qZ7YTl7HZulU2qQop+d5F7SKbqSBnBfm48csAe+ttnzAtgiEzRS4TDwJlOW+mJQ0NsmwZjF3PwfdgH9FlJSlKeuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806365; c=relaxed/simple;
	bh=OLE/byhcY9Swb80yvwPNa6cRO89Bt61WmL8INLn9Ly4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rbKb4t6JgPqRqO20tSBYPVFFH4BULcsTnyrUJg1ayzbn5zZ+UezmLvRUhWGEuh8KkQWtNEHlpXIs7c5TKcP6rjY4x/4/NUi+u0yGnOgqvmvCHw7Z1Ir9dFFSsqwFB+YyDHQnoXsfy+tXDACa3hfsnNmh9qRR/CXMZDHMwfbIXpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Al08JzTi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Al08JzTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB801F0089C;
	Mon, 12 Oct 2026 11:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791806364;
	bh=u/b0jgRlXummApz7eRlpkCcksLVZ/rqvHSVAyzVG468=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Al08JzTiR3WdCqXhzeiX7BRC9z/66Rzz/QTrqR+2wf5wbzclgXwJ1ToX4tWObLCzR
	 +Z54jtKjZVEJkwrbaC1ncBFE85ZAja+/kInJMNaHwE5+3kTGNc0ZIisxFo19ASzhNz
	 MCn9752sLk38DpmOfOJVlxSq4gBWUdF1OSC8uJ7JYAROeyTRQ02q14iKWwcEpmaHaq
	 Sr3Skb7WYxvhF5t3GIzADJ4f8DVBFIwXgvoO93aCt/AQ3g1MqBisdGD4/keOvQI8GL
	 bHCMOw9YBJgBLJlieHkKYWy3aJDjyaZe1X+XO8PNcBZ43AgEz65J/QuQKMZmuSxhvn
	 hBLhECHA+pTjw==
Message-ID: <sashiko-outbox-168041@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] scsi: arcmsr: wrap the type B completion index
 before using it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <459990a0367f7268c0056098f6e2631700e20327.1791803953.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791803953.git.yhlee@isslab.korea.ac.kr>
 <459990a0367f7268c0056098f6e2631700e20327.1791803953.git.yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 11:59:23 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: arcmsr: infinite loop in ISR processing due to unbounded h=
ardware DMA
--

commit 728fbf206bd1c95a2cfbe31aec39150fac1e1356
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: arcmsr: wrap the type B completion index before using it

This commit fixes a KASAN slab-out-of-bounds issue in arcmsr_hbaB_postqueue=
_isr
and arcmsr_hbaB_polling_ccbdone by wrapping the doneq_index with
ARCMSR_MAX_HBB_POSTQUEUE before it is used to index into done_qbuffer[].

> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcms=
r_hba.c
> index e635b76daae9a..d13bd0febb81a 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -2568,7 +2568,7 @@ static void arcmsr_hbaB_postqueue_isr(struct Adapte=
rControlBlock *acb)
>  	bool error;
>  	unsigned long cdb_phy_addr;
> =20
> -	index =3D reg->doneq_index;
> +	index =3D reg->doneq_index % ARCMSR_MAX_HBB_POSTQUEUE;
>  	while ((flag_ccb =3D reg->done_qbuffer[index]) !=3D 0) {

[Severity: Medium]
Could this loop spin infinitely? The loop condition depends entirely on
hardware-controlled DMA memory without an iteration limit.

If a faulty or malicious PCIe device continuously populates the DMA-mapped
done_qbuffer faster than the CPU processes it, or supplies an endless stream
of non-zero completions, can this lead to a CPU soft or hard lockup?

>  		cdb_phy_addr =3D (flag_ccb << 5) & 0xffffffff;
>  		if (acb->cdb_phyadd_hipart)

[ ... ]

> @@ -3671,7 +3671,7 @@ static int arcmsr_hbaB_polling_ccbdone(struct Adapt=
erControlBlock *acb,
>  	/* clear doorbell interrupt */
>  	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
>  	while(1){
> -		index =3D reg->doneq_index;
> +		index =3D reg->doneq_index % ARCMSR_MAX_HBB_POSTQUEUE;
>  		flag_ccb =3D reg->done_qbuffer[index];
>  		if (flag_ccb =3D=3D 0) {

[Severity: Medium]
Could this polling loop also lack a structural bound and spin infinitely?

If the hardware continuously supplies non-zero completions, poll_count is o=
nly
evaluated when flag_ccb =3D=3D 0. Can this result in a denial of service if=
 the
hardware never returns a zero completion?

>  			if (poll_ccb_done){

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791803953.gi=
t.yhlee@isslab.korea.ac.kr?part=3D3
