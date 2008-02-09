From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9880] dma_free_coherent in arcmsr when calling areca tools
Date: Sat,  9 Feb 2008 08:52:26 -0800 (PST)
Message-ID: <20080209165226.3853F11D109@picon.linux-foundation.org>
References: <bug-9880-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbYBIQyb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 11:54:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m19Gqadd030777
	for <linux-scsi@vger.kernel.org>; Sat, 9 Feb 2008 08:52:37 -0800
In-Reply-To: <bug-9880-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9880





------- Comment #4 from anonymous@kernel-bugs.osdl.org  2008-02-09 08:52 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Mon, 2008-02-04 at 08:19 +0000, Russell King wrote:
> On Sun, Feb 03, 2008 at 09:55:37PM -0600, James Bottomley wrote:
> > I've cc'd the people responsible for this apparent bit of idiocy.  Since
> > the API addition to dma_alloc_coherent() was the GFP flags so you could
> > call it from interrupt context with GFP_ATOMIC if so desired,
> > (pci_dma_alloc_consistent always has GFP_ATOMIC semantics), why on earth
> > would the corresponding free routine require non-atomic semantics?
> 
> For the N-th time, when tearing down the MMU mappings which we need
> to setup for coherent mappings, we need to invalidate the TLB.  On
> SMP systems, that means doing an IPI to the other CPUs to tell them
> to invalidate their TLBs as well.

Actually it's the first time I'm seeing this.

> Now, look at the restrictions on calling smp_call_function_on_cpu()
> or equivalent function which is used to do the IPIs.  I don't care if
> you look that up for x86 or ARM, because the restrictions are the same
> - see the last two lines:
> 
> x86:
> /**
>  * smp_call_function_mask(): Run a function on a set of other CPUs.
>  * @mask: The set of cpus to run on.  Must not include the current cpu.
>  * @func: The function to run. This must be fast and non-blocking.
>  * @info: An arbitrary pointer to pass to the function.
>  * @wait: If true, wait (atomically) until function has completed on other CPUs. *
>   * Returns 0 on success, else a negative status code.
>  *
>  * If @wait is true, then returns once @func has returned; otherwise
>  * it returns just before the target cpu calls @func.
>  *
>  * You must not call this function with disabled interrupts or from a
>  * hardware interrupt handler or from a bottom half handler.
>  */
> 
> arm:
> /*
>  * You must not call this function with disabled interrupts, from a
>  * hardware interrupt handler, nor from a bottom half handler.
>  */
> 
> 
> So, if the architecture requires you to IPI the TLB flush to other CPUs
> this restriction has to propagate to dma_free_coherent.  Or we just don't
> provide *any* DMA coherent memory and dictate that such platforms can
> never use DMA.
> 
> Which is more idiotic?

Why are you actually going to the trouble of freeing the mappings?

The MO of most consumers is either to allocate once on attach and free
on detach (effectively tying up the memory forever) or to alloc and free
descriptors as they come in and go out.  In the former case, there's no
need for free, in the latter the cycle of setup followed by teardown
will add a pretty big latency overhead.  Why not just use a pool
implementation, so you always add but never free ... it should reach a
steady state for the system and be a lot faster than the current
implementation.  Most architectures actually operate like this ... and
they tend to alloc and free in page size chunks to make it easy.

If you're worried about memory, you can always reap the pool in the
background.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
