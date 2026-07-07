Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1196B33ADA3
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783438245; cv=none; b=YYPYWUFA01qM8W2U507ve2P2DhW3IIYF/Iyj7fO/SUt8vZNbnbJ3sKvU2i4KSd/fgsoY3fQKJ/w/BwWyYtpA6/Ok4lTXgNNwmIiHZsnw4A1hh9FPc/8CRJXEqAXQ+MrUD4y5OfdZR4q5hOQRVLqF5BirNoDU3GRAlK9qV7gmf7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783438245; c=relaxed/simple;
	bh=4wM0WHeNvTMy3oMb/LSvRXB+oQe68R9gJQI9NC71PYA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ULgkcaQEZ2rQPXx7u0/T0n7bvitAp/ca4TuAweWRuFniWYizbGsICtrgt69vd9wUN3P/ROsH9E8RjvHHkkI43V3nRLlzUZt/mrESaAVtrZhxZ4FMDVWcVzIHM1PL6bVfoKTZ7Ylt7snuqBhIS1Y1yllDOVHJ856t1Wq+Y/3iQSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oP+NxZxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oP+NxZxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FB91F00A3F;
	Tue,  7 Jul 2026 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783438243;
	bh=lJNSaUdb8xoqECq5N1Sl5dZ1ozWaKycvVUnqvwdly7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oP+NxZxYcpgqTEhTTeNasAmd82LupzSMuECxipHORoctSeZRMaDEzrBeCM9josahE
	 dwAaeNGgWkU0G9aBelNZvBwD40KunN6snJPVWxJmkpi41DQrGyepkKXUAq+0awH3fd
	 rK4A8gqA6agVts6NnrjTDaeMnY27IkhnC5LGiKQgz34WXfJdEFCIBH9JgcJiH+ONcR
	 EIl0vNsptPbelro5dzEWWZB73HARaT45gtaL0QRAAQamsHP4mHnkKpHqwCNCr6HoDT
	 dFAnLNf7CAQ5kp7Zwr9yJfHgbD/103eIgI9uSJ5dx3dqwLPDDZoQhKUNXd7unAT94o
	 X1tZTCT1Sd8HA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mptfusion: Avoid NULL alt_ioc reload in reset
 work
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ruoyu Wang" <ruoyuw560@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707151344.2335768-1-ruoyuw560@gmail.com>
References: <20260707151344.2335768-1-ruoyuw560@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 15:30:43 +0000
Message-Id: <20260707153043.81FB91F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch resolves a TOCTOU NULL pointer dereference but leave=
s a severe Use-After-Free (UAF) vulnerability. If the alternate controller =
is detached and freed concurrently, the worker thread will dereference a fr=
eed pointer when acquiring the task management lock.
- [High] Detaching an alternate IOC permanently stops fault polling for the=
 remaining primary IOC, silently leaving it unmonitored.
--

--- Patch [1]: [PATCH] scsi: mptfusion: Avoid NULL alt_ioc reload in reset =
work ---
commit 62bf3402df60ac4d2e56595bb2e871b578a2c9e5
Author: Ruoyu Wang <ruoyuw560@gmail.com>

scsi: mptfusion: Avoid NULL alt_ioc reload in reset work

mpt_fault_reset_work() alternates delayed fault polling between bound IOC
ports by switching to ioc->alt_ioc before rearming the timer.

> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mp=
tbase.c
> index 3a431ffd3e2eb..29bcf44356d23 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -424,8 +424,7 @@ mpt_fault_reset_work(struct work_struct *work)
>  	/*
>  	 * Take turns polling alternate controller
>  	 */
> -	if (ioc->alt_ioc)
> -		ioc =3D ioc->alt_ioc;
> +	ioc =3D READ_ONCE(ioc->alt_ioc) ?: ioc;

[Severity: Critical]
This is a pre-existing issue, but can this code cause a use-after-free
when the alternate controller is detached concurrently?

If the primary adapter (A) runs mpt_fault_reset_work() and reads A->alt_ioc
(pointing to B), and concurrently mpt_detach() runs for B,
mpt_adapter_dispose() clears A->alt_ioc and frees B:

drivers/message/fusion/mptbase.c:mpt_adapter_dispose() {
	if (ioc->alt_ioc)
		ioc->alt_ioc->alt_ioc =3D NULL;

	kfree(ioc);
}

If A's work reads A->alt_ioc just before it is cleared, will A attempt to
acquire the freed B->taskmgmt_lock below?

> =20
>  	/* rearm the timer */
>  	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
>  	if (ioc->reset_work_q)
>  		queue_delayed_work(ioc->reset_work_q, &ioc->fault_reset_work,
>  			msecs_to_jiffies(MPT_POLLING_INTERVAL));

[Severity: High]
This is also a pre-existing issue, but does detaching an alternate IOC
break fault polling for the remaining primary IOC?

If the primary adapter (A) and alternate adapter (B) alternate queueing each
other's reset work, what happens when B is detached?

drivers/message/fusion/mptbase.c:mpt_detach() {
	wq =3D ioc->reset_work_q;
	ioc->reset_work_q =3D NULL;
	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
	cancel_delayed_work(&ioc->fault_reset_work);
}

If B's work was the currently scheduled one, it is cancelled, and A's work =
is
never queued again. Alternatively, if A's work evaluates the now-NULL
B->reset_work_q here, will it skip rearming the timer and leave A
without polling?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707151344.2335=
768-1-ruoyuw560@gmail.com?part=3D1
