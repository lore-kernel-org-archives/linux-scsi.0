Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E80E38735D;
	Mon,  6 Jul 2026 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783351235; cv=none; b=u8bRfkD3Q3p8KcMH1EqeoqR0VqN0YSkeiP4xFveCWewh0aDTIIjnJTFJSZciPIHs5IfDT2fK4f4kh9M/XwFbAF+Ngtk4ZfrZTqDO08QiGyyp7PI4GrBNVL0v1FdElAFUcmffld6nKVawqwCOSS7z3rWuAchJ80uZYbKj2XRghUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783351235; c=relaxed/simple;
	bh=cLudJc4df39CTOhx2vkGzDAQNvBd9myY4hn/4PMYH+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVgFcrTWAQSD9L+PHCKIdtmYm4WQHAWcWhHoGfPuhoFkTGCOHOZvUPRBWyJVuD+zvOUnw8d79vxAwURAzjVUDtBFrTchaA1uVU5RrZTI4Ukc90NcQ50l6IzjK0mdqe8yt/yyIIu4ZJA9XBfbqpkcz1F76rqBIltAcsQ75Szju3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1eBwE/47; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=DWdQUkvO; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1eBwE/47";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="DWdQUkvO"
Date: Mon, 6 Jul 2026 17:20:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783351232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wfGwrrbp2hP5Xl39KLlHgHJvWV1ymyHsqnrm3h2mulg=;
	b=1eBwE/47guNQgWAzYxji2XrFOfo+B8+s9k7VToglwNnw3p/j6Lelo8TIX6775u0V0YbUD1
	ae+SemHbQ8fAi15ndiVHOWPrJn6b46u+jT1flSMr44YR7lEg7CseVhHEo1DimryFySigYD
	0nLw1o6JVtScOq0zhWk91TDwilBazmkOXWrtnfFIkhjrXSPfcnNvlAqeknyDyqtEelZbwh
	8u9IoumGKjyirx2bJbJGmD8wY/tKpWsnBn3sj85dZUtHrcCJdc1tKatAFN80xI6VNIPyyo
	I+9vYGz4LBipKgcQPjSrqu10Io8KxU9QhC6ijZMq7HltZXUxBXxCRU/UWfBPeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783351232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wfGwrrbp2hP5Xl39KLlHgHJvWV1ymyHsqnrm3h2mulg=;
	b=DWdQUkvOi49zraWlZRl5HKA4eDa88a3m5zy3+y3o/lM5Ucdqu9oP/9fKkuxvjSAQfog/CH
	5q8/W5paoBpSQQCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>,
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
Message-ID: <20260706152031.ZUI06DL9@linutronix.de>
References: <20260630-ufshcd-spinlock-sleep-fix-v1-1-339b05a1c6f4@bootlin.com>
 <20260630141513.ujz0Ef-O@linutronix.de>
 <4244935a-8a49-42b0-ac27-234d2367e3e3@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4244935a-8a49-42b0-ac27-234d2367e3e3@acm.org>

On 2026-07-06 07:30:48 [-0700], Bart Van Assche wrote:
> On 6/30/26 7:15 AM, Sebastian Andrzej Siewior wrote:
> >  From ufshcd_intr():
> > |         intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> > |         enabled_intr_status = intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> > |
> > |         ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
> > 
> > What does this do? Does it disable the IRQ source? If so then
> > IRQF_ONESHOT should be removed.
> 
> Writing into the REG_INTERRUPT_STATUS register clears the bits that are
> set in the first argument of writel().

This makes it sounds as it would acknowledge the interrupt. If that is
the case then there is no need for IRQF_ONESHOT.

> > |         /* Directly handle interrupts since MCQ ESI handlers does the hard job */
> > |         return ufshcd_sl_intr(hba, enabled_intr_status);
> > 
> > If not, why is this not part of the threaded handler?
> If MCQ is disabled, ufshcd_sl_intr() processes all types of interrupts.
> If MCQ is enabled, the ESI interrupt handlers process I/O completions
> and ufshcd_sl_intr() processes the remaining interrupt types.

So MCQ is the trigger. Does its status change after device's init time?

If I understood it correctly, after the REG_INTERRUPT_STATUS there is no
need for IRQF_ONESHOT since this masks the interrupt until the thread is
done.

If MCQ disabled there is no need for this ACK and the it could be just a
request_irq(, ufshcd_sl_intr).

If MCQ is enabled then request_threaded_irq(, mask_interrupt_only,
   ufshcd_threaded_intr, IRQF_NO_THREAD)

Would this work?

> Bart.

Sebastian
