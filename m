Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9577480DE6;
	Wed, 15 Jul 2026 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784129104; cv=none; b=OmBxCMxYshHTn4xj7/uIh9NNvzXdTunfv2jBz2KvZ9CvnugUjlkg7sDuRkDbWSMKNT1dZtLiVh1M5zmmkeEFAH2ROqBOurzntLqewzQ9I6wlZylR7LVQTsFCAeJYIhcbFwf1jqTkSPcadDFaplOAeOKdQ823F8mcdYJz268Lamo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784129104; c=relaxed/simple;
	bh=6nYpWDt513yOkUGYlsU1aafw03CATJdNDb4GDpL9kLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDJ8kO+bjVR73yIBBqQl8UzD6yy1iC8il26kBGjyjByuqkR5XIMzck1KQ5q0Y2NEpkP+o9nLEegdjDa6tyXfkhkQvVrhDxvIIDcoICr88EPNJK49M3gIt/cbUPNAlGe49sCAEX5XVvIdrPWb3rZqcUS5Zr3ILx2MBZixoJKdasM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=FtX5PTZD; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=49npnUXI; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="FtX5PTZD";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="49npnUXI"
Date: Wed, 15 Jul 2026 17:25:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784129101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X4+7Kbqw2/OQq9yB1ol7cVjn91VP4oHM+x87pbrvZjg=;
	b=FtX5PTZDTugw/LC1AHiFhB66AQTgrchnaOqgL9zYoG8lmH2JOpkwSSUCRTL+lMPQEw5CHp
	SIa0AKb/guSTiYOLXdd3rHB9JBxq0tsGw19GrtwOCxno4i0Jta4BYzKp54HHkAabgxRPil
	ilcTBPqZE16o1kxnha7YTM8RNlMIiMy0RkmRPq8wibAbh6gBM99dUjl9YgW7YOSxmlYZ63
	6ft12UIGBRBa59v3P3wc4y5gWF+qZ12NBizBp+AykQmb9CfeVSHIGADj/Lh3FXSB21hmBR
	WhTi9wtwsmIg0nA+/vckQOOJhRCqQ9d7BPEY8tLKcVvg+TnhDVNttghh5DlOqA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784129101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X4+7Kbqw2/OQq9yB1ol7cVjn91VP4oHM+x87pbrvZjg=;
	b=49npnUXIlWO8hzsX+6SRk3/zYfxu22wQSkJzmvNNODx4e32MWJ4/Kol1ltfqSNcP4efGtv
	IxpoFs6pdB7sAUAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>,
	=?utf-8?Q?Beno=C3=AEt?= Monin <benoit.monin@bootlin.com>,
	=?utf-8?B?VGjDqW8=?= Lebrun <theo.lebrun@bootlin.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] scsi: ufs: core: Avoid sleeping in hard interrupt
 context when PREEMP_RT is enabled.
Message-ID: <20260715152500.iY9-Bp-R@linutronix.de>
References: <20260630-ufshcd-spinlock-sleep-fix-v1-1-339b05a1c6f4@bootlin.com>
 <20260630141513.ujz0Ef-O@linutronix.de>
 <4244935a-8a49-42b0-ac27-234d2367e3e3@acm.org>
 <20260706152031.ZUI06DL9@linutronix.de>
 <87v7ag5loj.fsf@BLaptop.bootlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87v7ag5loj.fsf@BLaptop.bootlin.com>

On 2026-07-15 17:15:08 [+0200], Gregory CLEMENT wrote:
> Hello Sebastian,
Hi,

> > If MCQ is enabled then request_threaded_irq(, mask_interrupt_only,
> >    ufshcd_threaded_intr, IRQF_NO_THREAD)
> >
>=20
> I'm implementing your solution to see if it fixes the issue without
> introducing a regression., but I'm puzzled by this previous line:
> `mask_interrupt_only ??`.

mask_interrupt_only means the function would mask the interrupt in the
device (UFS) hardware so the IRQ does not raise again once interrupts
are enabled again. The ufshcd_threaded_intr() routine would then have to
unmask the interrupt at the end of its doing so the IRQ can raise again.

> Also, I don't understand why `IRQF_NO_THREAD` is used for the threaded
> IRQ; it seems to indicate opposite behavior. Could you please explain
> what you have in mind ?

The previous without IRQF_NO_THREAD provide a primary handler just
masking the IRQ line and a threaded handler. One thread visible in the
system.
With `threadirqs' or PREEMPT_RT enabled the IRQ core will thread the
primary handler (masking just the IRQ line) and the threaded handler
which does the work. So you will see two threads. Also the interrupt
line will be masked (in the IRQ-chip) as long the two handler are
running. ps will show two threads.

To limit this, IRQF_NO_THREAD will ensure that the primary handler
(which masks the IRQ line in the device's HW) will not be threaded. It
is brief, takes no locks so why not. The secondary handler is the only
thread. The IRQ will also not be masked in the IRQ-chip.

> Gr=C3=A9gory
>=20
Sebastian
