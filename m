Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AE04FDE7C;
	Thu, 15 Oct 2026 12:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792067379; cv=none; b=UhEtwloSKVkne/+WDyIvmr+/1JDmp8Jp3aog+VrWoTuULQOT9mK4t+mZOzeM6MTlOxpWuJbYHJltV3OEQ57MmG+6V1pPW5cHKAAPEISAvwqR3OyTyYTc5ZB9UP/MjIwJD6jp4LpZ52jfYp0tEXR/oZ0flo9IgfCSNjHO6L41B3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792067379; c=relaxed/simple;
	bh=EdkoGLcjTyLAvjh/5BwakDPBCwlzJa0pxxqLHTIhYzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRj/4J28//Ibrl0AFqYjb52Z4O6fyn0bCa1K3BXnftw/Z2wXwQz9W5mmG/Mm3DFhp2wtbiUfzlH9yNphyED+WS3o5eSvhO264CJ6Nw8EU6B654twTCmDn8pLeJihWf3UQ3KrPCNj4Zi8BEfEBMYS/Mmp5zD14x+ej3DPsuLSkIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=NDQaJqA1; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Diqi3L5P; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="NDQaJqA1";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Diqi3L5P"
Date: Thu, 15 Oct 2026 14:29:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792067375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SiJnkX+uFAvEbBRKpsYNT584aijBABjRduz0e55KArA=;
	b=NDQaJqA1XcisH3IazYB8/nWljI3F8weUNXOJLgfRscMyCTkuWSzsOJJkt0uwDzduEoBNNF
	nEvVe7jMpMH0LOXP8UBg7jjT04JglRlk73NiKd5JCpEyD6prTvdfi6BRyB2VWw/6K5VJ+y
	9JsSuM4qwR+0dJBHIxYLmM6oAo5w2qH4OmH48V3E2ZoLpoedS0QeOPmgWYa+G1gvQGny5u
	NxJAR5l4TIzo0AnMf+WPmLWAraxfHhPGU/YUvtEm4cMsYw9/UTrEgpm/KTra+xsc9QfrWT
	iIoIxIsajla/iGTyBGYjC2n4VML86fDIeKEWrePXA4tMpGWUMd9gb4CaWCSGAw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792067375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SiJnkX+uFAvEbBRKpsYNT584aijBABjRduz0e55KArA=;
	b=Diqi3L5PlE5sEU6DgUxl0lbiUUozIpHXpQKeV58bDnIvh2Ko9ik1GhSZQOZxl+A8vv5Jln
	jizG5+8pAa0WvvDg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Daniel Wagner <dwagner@suse.de>
Cc: Aaron Tomlin <atomlin@atomlin.com>, axboe@kernel.dk, tglx@kernel.org,
	aacraid@microsemi.com, James.Bottomley@hansenpartnership.com,
	mkp@kernel.org, frederic@kernel.org, ionut.nechita@windriver.com,
	corbet@lwn.net, vincent.guittot@linaro.org, mingo@redhat.com,
	peterz@infradead.org, radu@rendec.net, akpm@linux-foundation.org,
	steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com,
	mproche@gmail.com, nick.lange@gmail.com, marco.crivellari@suse.com,
	rishil1999@outlook.com, linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Message-ID: <20261015122934.5itxaJ3l@linutronix.de>
References: <20260910164237.500196-1-atomlin@atomlin.com>
 <2f32ffb6-d889-4281-a612-d4185311ca0d@flourine.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2f32ffb6-d889-4281-a612-d4185311ca0d@flourine.local>

On 2026-10-15 13:22:35 [+0200], Daniel Wagner wrote:
> During Plumbers we had several discussions on this series. This is what I
> remember we discussed and decided:
> 
>   - The current managed_irq behavior doesn't match the other flags of isolcpus.
> 
>   - Instead of introducing managed_irq_strict, it's better to change the
>     existing managed_irq to follow the strict interpretation.
> 
>   - The main existing user of the current managed_irq mapping is
>     RH with OpenShift. After discussing with Juri, it doesn't look like
>     it is a real blocker to change to the strict interpretation.

This is what I remember, too.

>   - If there are complaints about the managed irq behavior change, it's
>     better to introduce a different flag for this. Though there have been
>     many discussions and proposals on how to deal with isolation during the
>     conference, and the general mood was that the placement of resources
>     should be done during runtime. Thus it is likely that the old behaviour
>     is not necessary at all if runtime configuration is possible.

The main argument/ problem is that managed_irq does not work as expected
for the vast majority of users and should be fixed. This has only been
"recently" documented.

The whole isolcpus= was meant to be static and there was no argument why
it needs to vanish. A dynamic interface for dynamic workloads is what
you want especially if you have 80+ CPUs and workloads can change. But
on <16 CPUs system the partition probably do not change. It is also not
obvious if your driver(s) use managed_irqs or not.
To get a runtime interface for this you would need to be able to
reconfigure the managed_irq interrupt if "interrupts < CPUS". Otherwise
it is just enable and disable like during CPU-hotplug but without it. If
I remember it correctly, the device itself does not handle this at all
but the block layers drains and starts queues during a hotplug event.

> Hope this helps to move forward with this series,
> Daniel

Sebastian
