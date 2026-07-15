Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870C5480950
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128519; cv=none; b=CLNovjD1ZH5sNRqNkwH1UiYpIKX0GdBUxb/U/Ud51YiQAexp7hAY/TuJw4wlUwH0SpnNCaytO8RnPejWeh7fNPAMwj+LY270p25a+gDDYH8lMdUBR8Od4DnPyCDAZ31OTnRUuxtfEEiG+0OOOMk8IoofX3Na+ot4/SIMnXcwWpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128519; c=relaxed/simple;
	bh=vf0w7IKsbngcWAtxStzRaIaHe0VnO914W236kwoe1Qo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JuJYEDvtY1hIaKLoOoZ/kBLOwKqXiXG8mSc05OY0uypymLLC9JJVoiHE2+StEwF9r2KBeNzEUg/XxMYmnVhq2+CQdqxq2CDYNydWPS4xEltpKkvLXYWlX8QVR8q4Jet/UVjgf5ZBYDbJYvhQeLhN1uB6RlH4Po5fDa4QCuJrip4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=wRJLJiH7; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="wRJLJiH7"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id C8EB54E40DD8;
	Wed, 15 Jul 2026 15:15:15 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9307D6035C;
	Wed, 15 Jul 2026 15:15:15 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5F24111BD3C35;
	Wed, 15 Jul 2026 17:15:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784128514; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Z5nRLBJrfMoxIJoTFnYKDDJ1cv5nud/3WE9BCkcRYZc=;
	b=wRJLJiH7YULD5DZtSLxN1NZ6LWXhJDLD6Uwq2/fhaq7Fgn687aWu9USxlOFkPf12/WOWdR
	8qlsUUooGGH9IuLR5r3s4DxG2A2qudVxGP5sos6k3W6s2pyiP8SupoqtQvq4bJBfBdXd3J
	0ftLZygFRG3+SdA0C6+g0SkisDWGXwG2weSUjt1ZEoeW8DQwKXBFbC3ACOvDsoMfRZ9pRb
	NXEzeS9bWIvfjL0ntFmqtI4DUNylZ/HpOIyAS9iNAI7SXkuuAn3XyYXIrnv51/NDunUYu1
	dAQWfMEVxyupqDBddjnUvQs+6PuB9X7e/TvQ+4ytU780z0d/LQ6UQwbMnWOAeA==
From: Gregory CLEMENT <gregory.clement@bootlin.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Bart Van Assche
 <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Clark Williams <clrkwllms@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Thomas Petazzoni
 <thomas.petazzoni@bootlin.com>, Vladimir Kondratiev
 <vladimir.kondratiev@mobileye.com>, =?utf-8?Q?Beno=C3=AEt?= Monin
 <benoit.monin@bootlin.com>, =?utf-8?Q?Th=C3=A9o?= Lebrun
 <theo.lebrun@bootlin.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] scsi: ufs: core: Avoid sleeping in hard interrupt
 context when PREEMP_RT is enabled.
In-Reply-To: <20260706152031.ZUI06DL9@linutronix.de>
References: <20260630-ufshcd-spinlock-sleep-fix-v1-1-339b05a1c6f4@bootlin.com>
 <20260630141513.ujz0Ef-O@linutronix.de>
 <4244935a-8a49-42b0-ac27-234d2367e3e3@acm.org>
 <20260706152031.ZUI06DL9@linutronix.de>
Date: Wed, 15 Jul 2026 17:15:08 +0200
Message-ID: <87v7ag5loj.fsf@BLaptop.bootlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hello Sebastian,

> On 2026-07-06 07:30:48 [-0700], Bart Van Assche wrote:
>> On 6/30/26 7:15 AM, Sebastian Andrzej Siewior wrote:
>> >  From ufshcd_intr():
>> > |         intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>> > |         enabled_intr_status =3D intr_status & ufshcd_readl(hba, REG_=
INTERRUPT_ENABLE);
>> > |
>> > |         ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
>> >=20
>> > What does this do? Does it disable the IRQ source? If so then
>> > IRQF_ONESHOT should be removed.
>>=20
>> Writing into the REG_INTERRUPT_STATUS register clears the bits that are
>> set in the first argument of writel().
>
> This makes it sounds as it would acknowledge the interrupt. If that is
> the case then there is no need for IRQF_ONESHOT.
>
>> > |         /* Directly handle interrupts since MCQ ESI handlers does th=
e hard job */
>> > |         return ufshcd_sl_intr(hba, enabled_intr_status);
>> >=20
>> > If not, why is this not part of the threaded handler?
>> If MCQ is disabled, ufshcd_sl_intr() processes all types of interrupts.
>> If MCQ is enabled, the ESI interrupt handlers process I/O completions
>> and ufshcd_sl_intr() processes the remaining interrupt types.
>
> So MCQ is the trigger. Does its status change after device's init
> time?

The status doesn't change after the device's initialization, so we can
indeed register the interrupt according to whether MCQ is enabled or
not.

>
> If I understood it correctly, after the REG_INTERRUPT_STATUS there is no
> need for IRQF_ONESHOT since this masks the interrupt until the thread is
> done.
>
> If MCQ disabled there is no need for this ACK and the it could be just a
> request_irq(, ufshcd_sl_intr).
>
> If MCQ is enabled then request_threaded_irq(, mask_interrupt_only,
>    ufshcd_threaded_intr, IRQF_NO_THREAD)
>

I'm implementing your solution to see if it fixes the issue without
introducing a regression., but I'm puzzled by this previous line:
`mask_interrupt_only ??`.
Also, I don't understand why `IRQF_NO_THREAD` is used for the threaded
IRQ; it seems to indicate opposite behavior. Could you please explain
what you have in mind ?

Gr=C3=A9gory

> Would this work?
>
>> Bart.
>
> Sebastian

--=20
Gr=C3=A9gory CLEMENT, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
