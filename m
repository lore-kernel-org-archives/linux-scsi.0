Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483AE282F29
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 01:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775179263; cv=none; b=aUQsSq4GEiNuRq8kI3+FqyQaz/EY0ngHdgMBB6isLByxqi0bRclIHXC3JWEPYedGGtbHN9mKo39ISK6wRPPnYEPNFpTEwAR2v2ZDQdrICJ3bBLAcovVKjHdBQ4es/h13pMYwrTCu5U9Kz3bcT01kcR0r2P/iDagZmylsN/fUHZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775179263; c=relaxed/simple;
	bh=99oqsGx91DsEpIePme+xeZymCjzOITLkHrLhbM3wCVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isn4m8ELpFx9Zt77hWtzpUlOsKJ9SDMDqwUKRIOZku2BWrHjYPZoNMAjkxxb/OFhwCvzgsyHCVlRswgZ5g1/GomMMosMYbkVqu+Z9LAW5eZOWaM6vaafOLmwRHobW00diH634baKd21VrnWksU5qalQpWfL3YkVikqHXuYzDHPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dIAGXXcE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dIAGXXcE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775179260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mWKTO9AaLYaViyVKa2V+dw4sP1VwptNtafpoFtDToBU=;
	b=dIAGXXcEnhQ8Xxl8C/XaR5NskMyOHX//qX+xR0I228o2vMW3monMkK6vHFhopu7d/cX5uV
	wwqE7YNS/1O/y5JpOqOYjnBhxfcrpzLXoLas9b1u+9iXXDq1szDt4kKDhiCR5RPY9fdvIA
	R7BBzq/U4VkaNkwT4EPJ+MNOMpXZP7Y=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-Oumg8602NQGwExDbfGYUwQ-1; Thu,
 02 Apr 2026 21:20:54 -0400
X-MC-Unique: Oumg8602NQGwExDbfGYUwQ-1
X-Mimecast-MFC-AGG-ID: Oumg8602NQGwExDbfGYUwQ_1775179250
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80D791956089;
	Fri,  3 Apr 2026 01:20:47 +0000 (UTC)
Received: from fedora (unknown [10.72.116.83])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8AA2180076B;
	Fri,  3 Apr 2026 01:20:22 +0000 (UTC)
Date: Fri, 3 Apr 2026 09:20:17 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, axboe@kernel.dk,
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, mst@redhat.com,
	aacraid@microsemi.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, liyihang9@h-partners.com,
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com,
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com,
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org,
	longman@redhat.com, chenridong@huawei.com, hare@suse.de,
	kch@nvidia.com, steve@abita.co, sean@ashe.io, chjohnst@gmail.com,
	neelx@suse.com, mproche@gmail.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
Message-ID: <ac8V0RO-yg3juOox@fedora>
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <20260330221047.630206-10-atomlin@atomlin.com>
 <20260401124947.-d4D5Cr-@linutronix.de>
 <c7phvlvohdn2ksc2jymxk5foolwlqaqq2jzcdv7oic4uzomh3j@yjimbwcnnst3>
 <20260402090940.5j0WmVX_@linutronix.de>
 <sluplntvagevh6ehfm3kqinbh23d2gnin7stkptxk6drvogh2g@4hpz74fidrq2>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sluplntvagevh6ehfm3kqinbh23d2gnin7stkptxk6drvogh2g@4hpz74fidrq2>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Apr 02, 2026 at 08:50:55PM -0400, Aaron Tomlin wrote:
> On Thu, Apr 02, 2026 at 11:09:40AM +0200, Sebastian Andrzej Siewior wrote:
> > On 2026-04-01 16:58:22 [-0400], Aaron Tomlin wrote:
> > > Hi Sebastian,
> > Hi,
> > 
> > > Thank you for taking the time to document the "managed_irq" behaviour; it
> > > is immensely helpful. You raise a highly pertinent point regarding the
> > > potential proliferation of "isolcpus=" flags. It is certainly a situation
> > > that must be managed carefully to prevent every subsystem from demanding
> > > its own bit.
> > > 
> > > To clarify the reasoning behind introducing "io_queue" rather than strictly
> > > relying on managed_irq:
> > > 
> > > The managed_irq flag belongs firmly to the interrupt subsystem. It dictates
> > > whether a CPU is eligible to receive hardware interrupts whose affinity is
> > > managed by the kernel. Whilst many modern block drivers use managed IRQs,
> > > the block layer multi-queue mapping encompasses far more than just
> > > interrupt routing. It maps logical queues to CPUs to handle I/O submission,
> > > software queues, and crucially, poll queues, which do not utilise
> > > interrupts at all. Furthermore, there are specific drivers that do not use
> > > the managed IRQ infrastructure but still rely on the block layer for queue
> > > distribution.
> > 
> > Could you tell block which queue maps to which CPU at /sys/block/$$/mq/
> > level? Then you have one queue going to one CPU.
> > Then the drive could request one or more interrupts managed or not. For
> > managed you could specify a CPU mask which you desire to occupy.
> > You have the case where
> > - you have more queues than CPUs
> >   - use all of them
> >   - use less
> > - less queues than CPUs
> >   - mapped a queue to more than once CPU in case it goes down or becomes
> >     not available
> >   - mapped to one CPU
> > 
> > Ideally you solve this at one level so that the device(s) can request
> > less queues than CPUs if told so without patching each and every driver.
> > 
> > This should give you the freedom to isolate CPUs, decide at boot time
> > which CPUs get I/O queues assigned. At run time you can tell which
> > queues go to which CPUs. If you shutdown a queue, the interrupt remains
> > but does not get any I/O requests assigned so no problem. If the CPU
> > goes down, same thing.
> > 
> > I am trying to come up with a design here which I haven't found so far.
> > But I might be late to the party and everyone else is fully aware.
> > 
> > > If managed_irq were solely relied upon, the IRQ subsystem would
> > > successfully keep hardware interrupts off the isolated CPUs, but the block
> > 
> > The managed_irqs can't be influence by userland. The CPUs are auto
> > distributed.
> > 
> > > layer would still blindly map polling queues or non-managed queues to those
> > > same isolated CPUs. This would force isolated CPUs to process I/O
> > > submissions or handle polling tasks, thereby breaking the strict isolation.
> > > 
> > > Regarding the point about the networking subsystem, it is a very valid
> > > comparison. If the networking layer wishes to respect isolcpus in the
> > > future, adding a net flag would indeed exacerbate the bit proliferation.
> > 
> > Networking could also have different cases like adding a RX filter and
> > having HW putting packet based on it in a dedicated queue. But also in
> > this case I would like to have the freedome to decide which isolated
> > CPUs should receive interrupts/ traffic and which don't.
> > 
> > > For the present time, retaining io_queue seems the most prudent approach to
> > > ensure that block queue mapping remains semantically distinct from
> > > interrupt delivery. This provides an immediate and clean architectural
> > > boundary. However, if the consensus amongst the maintainers suggests that
> > > this is too granular, alternative approaches could certainly be considered
> > > for the future. For instance, a broader, more generic flag could be
> > > introduced to encompass both block and future networking queue mappings.
> > > Alternatively, if semantic conflation is deemed acceptable, the existing
> > > managed_irq housekeeping mask could simply be overloaded within the block
> > > layer to restrict all queue mappings.
> > > 
> > > Keeping the current separation appears to be the cleanest solution for this
> > > series, but your thoughts, and those of the wider community, on potentially
> > > migrating to a consolidated generic flag in the future would be very much
> > > welcomed.
> > 
> > I just don't like introducing yet another boot argument, making it a
> > boot constraint while in my naive view this could be managed at some
> > degree via sysfs as suggested above.
> 
> Hi Sebastian,
> 
> I believe it would be more prudent to defer to Thomas Gleixner and Jens
> Axboe on this matter.
> 
> 
> Indeed, I am entirely sympathetic to your reluctance to introduce yet
> another boot parameter, and I concur that run-time configurability
> represents the ideal scenario for system tuning.

`io_queue` introduces cost of potential failure on offlining CPU, so how
can it replace the existing `managed_irq`?

> 
> At present, a device such as an NVMe controller allocates its hardware
> queues and requests its interrupt vectors during the initial device probe
> phase. The block layer calculates the optimal queue to CPU mapping based on
> the system topology at that precise moment. Altering this mapping
> dynamically at runtime via sysfs would be an exceptionally intricate
> undertaking. It would necessitate freezing all active operations, tearing
> down the physical hardware queues on the device, renegotiating the
> interrupt vectors with the peripheral component interconnect subsystem, and
> finally reconstructing the entire queue map.
> 
> Furthermore, the proposed io_queue boot parameter successfully achieves the
> objective of avoiding driver level modifications. By applying the
> housekeeping mask constraint centrally within the core block layer mapping
> helpers, all multiqueue drivers automatically inherit the CPU isolation
> boundaries without requiring a single line of code to be changed within the
> individual drivers themselves.
> 
> Because the hardware queue count and CPU alignment must be calculated as
> the device initialises, a reliable mechanism is required to inform the
> block layer of which CPUs are strictly isolated before the probe sequence
> commences. This is precisely why integrating with the existing boot time
> housekeeping infrastructure is currently the most viable and robust
> solution.
> 
> Whilst a fully dynamic sysfs driven reconfiguration architecture would be a
> great, it would represent a substantial paradigm shift for the block layer.
> For the present time, the io_queue flag resolves the immediate and severe
> latency issues experienced by users with isolated CPUs, employing an
> established and safe methodology.

I'd suggest to document the exact existing problem, cause `managed_irq`
should cover it in try-best way, so people can know how to select the two
parameters.


Thanks,
Ming

