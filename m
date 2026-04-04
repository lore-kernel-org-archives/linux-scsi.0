Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F706307AC6
	for <linux-scsi@vger.kernel.org>; Sat,  4 Apr 2026 03:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775272294; cv=none; b=qXMSHgYS2J1GusC3NkcgxOPAcLoYYHWhW6ppMM8rRQi+8QXb/bQvw+GPVllmvgq07ZYYBu94lKPEoVxWpDtb2wEaGk1udF+1PJr4hdIGonooK5LYTSejUK1FpAJVXhF1h5vN6LzTKWSC+Nb96DHddt6GgvJGXHkNMMstAVbGagA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775272294; c=relaxed/simple;
	bh=bGZTHTqfCxxjxXkh80QwccYDB6HxFG5lI1cWKQBG89w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QO5ksALSGuG3/V9qJq6Pg0l4Ux2qkrXPA9Iv94CR5lzHIEEn+XL4CVe3Pl8L6Ut/N2Y2C2w14tJFn4TlnEH4QJa4qNRCvK8uHKb6qUm9xgdkI61Z2OeW4g6UEetoAJ4N7dCECU6WRnN74nkD7yC6OMc02l26R65/8G8h9idGUp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=raAmZoum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="raAmZoum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E48C4CEF7;
	Sat,  4 Apr 2026 03:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775272293;
	bh=bGZTHTqfCxxjxXkh80QwccYDB6HxFG5lI1cWKQBG89w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=raAmZoum14SyiZEj4t608aVe4ZPtJRw/G/4D487vAOb+GAMesiz1NFtOVHvzNoktH
	 xpmu9qXa7ln34+pQumH72/Tz5VuUVSOspe8aBKDNYlB8ZQsUFUhgDwHqdcjjI6uPxX
	 07i+NLhwirioDFbfzsFG+xNJg07zHQIRgNGgNPna3+ihvEfbvkKdzqQChj/nT4ryI8
	 IxAFuZWdvp+RYoUuuTmDdlp1KOblgx726HblUS3CngQkYorQlMZJunRzyzXlQkk2Qs
	 w5I8xzl9vkCGVJA5s/aUu4HQOViminBlTX7Z9LeqnuTq7pQ6Bu0B1S5VHWFcCzahDH
	 WBGkVkqxqJHcA==
Date: Sat, 4 Apr 2026 08:41:23 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Nitin Rawat <quic_nitirawa@quicinc.com>, linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 3/3] ufs: qcom: Reduce interrupt latency
Message-ID: <pvualeorhaopbphb7vvvw2qbxibsupddl642jzrxa43jveyxze@bs2ixsupmbuz>
References: <20260330183311.1941942-1-bvanassche@acm.org>
 <20260330183311.1941942-4-bvanassche@acm.org>
 <fg4i4d3fjpjvwp5xe5zvzwjlhq5dlmiauchh62fka5lujmolcm@pzzbd7h3se3e>
 <99c8b626-4c06-411b-bc01-6324df5b3137@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <99c8b626-4c06-411b-bc01-6324df5b3137@acm.org>

On Tue, Mar 31, 2026 at 12:44:52PM -0700, Bart Van Assche wrote:
> On 3/31/26 12:09 AM, Manivannan Sadhasivam wrote:
> > + Nitin
> > 
> > On Mon, Mar 30, 2026 at 11:33:05AM -0700, Bart Van Assche wrote:
> > > Defer completion processing to thread context on slower CPU cores to
> > > prevent interrupt latency spikes. On the fastest CPU cores, keep
> > > processing all completions in interrupt context.
> > 
> > By default, all interrupts are pinned to CPU0. So unless some userspace entity
> > like irqbalance changes the CPU affinity, all the interrupts will be serviced
> > in the threaded context on CPU0
> 
> That's an unusual approach. All other blk-mq drivers I know of spread
> completion interrupt over CPU cores. Pinning all completion interrupts
> to a single CPU core is risky because it may cause that CPU core to
> spend all of its time handling interrupts with no time left for running
> kernel or user-space threads.
> 

What I mentioned above is the default platform behavior where the interrupt
controller assigns default affinity of all interrupts to CPU0 unless device
drivers/userspace ask explicitly to spread the affinity.

> > which will negatively impact performance with this patch.
> 
> Hmm ... the implementation of this patch is such that latency is not
> affected for queue depth 1. It will have a latency impact for queue
> depths above 4 but I don't think that just by reading the code it can
> be concluded whether or not IOPS will be affected. This patch could have
> an impact similar to enabling interrupt coalescing. Interrupt coalescing
> increases latency but typically also increases IOPS.

If I understand this patch correctly, irrespective of the queue depth, if the
default affinity is CPU0, then this patch will always cause the interrupts to be
processed by the threaded handler since CPU0 is not the fastest CPU core in the
hierarchy.

> > I think from the kernel driver, we should just set the IRQ affinity hint as
> > Nitin tried [1] and let the userspace to balance IRQ load based on the activity.
> > 
> > - Mani
> > 
> > [1] https://lore.kernel.org/all/20260122141331.239354-2-nitin.rawat@oss.qualcomm.com
>  Thanks for the link. Please consider calling
> devm_platform_get_irqs_affinity() or one of its variants instead of
> open-coding already existing code for spreading interrupts across CPU cores.
> As you may know there are two types of interrupts in the Linux
> kernel: non-managed and managed. For non-managed interrupts, a default
> CPU affinity is assigned when the interrupt is requested and the CPU
> affinity can be modified from user space. If all CPUs in the affinity
> mask of a non-managed interrupt go offline, the hotplug code changes the
> affinity mask to the remaining online CPUs.
> 
> Managed interrupts are spread evenly across CPUs by the code that
> requests these interrupts. User space code cannot modify the affinity
> mask of managed interrupts. If the last CPU in the affinity mask of a
> managed interrupt goes offline then the interrupt is shut down. If the
> first CPU in the affinity mask becomes online again then the interrupt
> is started up again.
> 
> I think the latter behavior is what is needed for UFS host controllers.
> 

I'm not too familiar with Android internals, but isn't that Android has some
irqbalance or similar utilities that manage the UFS interrupts based on system
load? Managed interrupts work better if we want the interrupts to be managed
by the kernel, without user intervention. Not sure if that's what we really want
for UFS.

I certainly cannot comment on that.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
