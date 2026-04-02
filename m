Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444073750A7;
	Thu,  2 Apr 2026 09:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775120986; cv=none; b=ny8ZI4m5RBTZKvSFtG6kgGhEhlmUQLGslxe7FacW3tUwrF1msyKH0h0WTnyXojBxlbXOnL7vavGvIocI0L/z9PzK0fP+up0uifohS9I9SIWL9V4w0oiA2sPvuoiShWVP4g0Y0UcUBCWX7Tf10Kfqzm1r7vMENwOZkld7C3ngCZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775120986; c=relaxed/simple;
	bh=TuGik8RXHnYMOBFzZzJ8Z1EDIzIDUfS6hJtG0TBgUfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4xWkYc3k5d9MnE855FKFcaFZbCZ/K3qCUCZrymcCWJa/QnCXhM5sD9M2hR9zmMVZv+SdLbnWDkR22xuAGc410Cu3CyT9kdfylWWQMvS9UYrJglp5tQcBO4zbWNCPjIkeiE7Rn4cbZdthVfUdvyu8VxPqYHmwxSpnmdRvJqGr90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=odde0n62; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jWPcQeev; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="odde0n62";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jWPcQeev"
Date: Thu, 2 Apr 2026 11:09:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1775120983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fwrBn0MM36ml3NMuCzWd/m89P37wcag8vmF/9UbXMcQ=;
	b=odde0n62hjn9LZuq2B/dNwt9vUJZXCyajd+XWvOnXWmMaFGfXUE69bDf4leWPam241E+Uo
	+t41Oorwn99laL8GawIlMBvyPAbCTIGh0H2AUKz00FIWozPRG019it7jkX8/Ire+WLTsc+
	MGkmMskasKYO/5jh4zdm0Wc6bePiqfI/eNq2qyPIjv8eEvy984XIYnxDEKDs9rnmXk1o0w
	pa2PYrA1InqHqmCkp/yzbOh8y1YPrIPL9sWcgxzyrS4uoVYs81UxfG3u+yPmEHirc/pDRo
	jHZqmkz992BIVJYTKebOathyOPxUjscWc4RX4+zhXMHAcUsxLoHvYJo8zu+hMA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1775120983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fwrBn0MM36ml3NMuCzWd/m89P37wcag8vmF/9UbXMcQ=;
	b=jWPcQeevqgP+QitjhXQzSifCfojusGMWduLoSkX24XZKzhrOV1MXsOOvAlCQ9Xy22O+9/K
	7W5PFVNeWP3iKtBw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	mst@redhat.com, aacraid@microsemi.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	liyihang9@h-partners.com, kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com,
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com,
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org,
	longman@redhat.com, chenridong@huawei.com, hare@suse.de,
	kch@nvidia.com, ming.lei@redhat.com, steve@abita.co, sean@ashe.io,
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
Message-ID: <20260402090940.5j0WmVX_@linutronix.de>
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <20260330221047.630206-10-atomlin@atomlin.com>
 <20260401124947.-d4D5Cr-@linutronix.de>
 <c7phvlvohdn2ksc2jymxk5foolwlqaqq2jzcdv7oic4uzomh3j@yjimbwcnnst3>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c7phvlvohdn2ksc2jymxk5foolwlqaqq2jzcdv7oic4uzomh3j@yjimbwcnnst3>

On 2026-04-01 16:58:22 [-0400], Aaron Tomlin wrote:
> Hi Sebastian,
Hi,

> Thank you for taking the time to document the "managed_irq" behaviour; it
> is immensely helpful. You raise a highly pertinent point regarding the
> potential proliferation of "isolcpus=" flags. It is certainly a situation
> that must be managed carefully to prevent every subsystem from demanding
> its own bit.
> 
> To clarify the reasoning behind introducing "io_queue" rather than strictly
> relying on managed_irq:
> 
> The managed_irq flag belongs firmly to the interrupt subsystem. It dictates
> whether a CPU is eligible to receive hardware interrupts whose affinity is
> managed by the kernel. Whilst many modern block drivers use managed IRQs,
> the block layer multi-queue mapping encompasses far more than just
> interrupt routing. It maps logical queues to CPUs to handle I/O submission,
> software queues, and crucially, poll queues, which do not utilise
> interrupts at all. Furthermore, there are specific drivers that do not use
> the managed IRQ infrastructure but still rely on the block layer for queue
> distribution.

Could you tell block which queue maps to which CPU at /sys/block/$$/mq/
level? Then you have one queue going to one CPU.
Then the drive could request one or more interrupts managed or not. For
managed you could specify a CPU mask which you desire to occupy.
You have the case where
- you have more queues than CPUs
  - use all of them
  - use less
- less queues than CPUs
  - mapped a queue to more than once CPU in case it goes down or becomes
    not available
  - mapped to one CPU

Ideally you solve this at one level so that the device(s) can request
less queues than CPUs if told so without patching each and every driver.

This should give you the freedom to isolate CPUs, decide at boot time
which CPUs get I/O queues assigned. At run time you can tell which
queues go to which CPUs. If you shutdown a queue, the interrupt remains
but does not get any I/O requests assigned so no problem. If the CPU
goes down, same thing.

I am trying to come up with a design here which I haven't found so far.
But I might be late to the party and everyone else is fully aware.

> If managed_irq were solely relied upon, the IRQ subsystem would
> successfully keep hardware interrupts off the isolated CPUs, but the block

The managed_irqs can't be influence by userland. The CPUs are auto
distributed.

> layer would still blindly map polling queues or non-managed queues to those
> same isolated CPUs. This would force isolated CPUs to process I/O
> submissions or handle polling tasks, thereby breaking the strict isolation.
> 
> Regarding the point about the networking subsystem, it is a very valid
> comparison. If the networking layer wishes to respect isolcpus in the
> future, adding a net flag would indeed exacerbate the bit proliferation.

Networking could also have different cases like adding a RX filter and
having HW putting packet based on it in a dedicated queue. But also in
this case I would like to have the freedome to decide which isolated
CPUs should receive interrupts/ traffic and which don't.

> For the present time, retaining io_queue seems the most prudent approach to
> ensure that block queue mapping remains semantically distinct from
> interrupt delivery. This provides an immediate and clean architectural
> boundary. However, if the consensus amongst the maintainers suggests that
> this is too granular, alternative approaches could certainly be considered
> for the future. For instance, a broader, more generic flag could be
> introduced to encompass both block and future networking queue mappings.
> Alternatively, if semantic conflation is deemed acceptable, the existing
> managed_irq housekeeping mask could simply be overloaded within the block
> layer to restrict all queue mappings.
> 
> Keeping the current separation appears to be the cleanest solution for this
> series, but your thoughts, and those of the wider community, on potentially
> migrating to a consolidated generic flag in the future would be very much
> welcomed.

I just don't like introducing yet another boot argument, making it a
boot constraint while in my naive view this could be managed at some
degree via sysfs as suggested above.

> 
> Kind regards,

Sebastian
