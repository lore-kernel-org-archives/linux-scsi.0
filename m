From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [Bug 9880] dma_free_coherent in arcmsr when calling areca tools
Date: Mon, 4 Feb 2008 08:19:40 +0000
Message-ID: <20080204081940.GC15955@flint.arm.linux.org.uk>
References: <20080204030037.6C061108018@picon.linux-foundation.org> <1202097337.3318.143.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50134 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYBDIUW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 03:20:22 -0500
Content-Disposition: inline
In-Reply-To: <1202097337.3318.143.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: bugme-daemon@bugzilla.kernel.org, David Brownell <david-b@pacbell.net>, Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi@vger.kernel.org

On Sun, Feb 03, 2008 at 09:55:37PM -0600, James Bottomley wrote:
> I've cc'd the people responsible for this apparent bit of idiocy.  Since
> the API addition to dma_alloc_coherent() was the GFP flags so you could
> call it from interrupt context with GFP_ATOMIC if so desired,
> (pci_dma_alloc_consistent always has GFP_ATOMIC semantics), why on earth
> would the corresponding free routine require non-atomic semantics?

For the N-th time, when tearing down the MMU mappings which we need
to setup for coherent mappings, we need to invalidate the TLB.  On
SMP systems, that means doing an IPI to the other CPUs to tell them
to invalidate their TLBs as well.

Now, look at the restrictions on calling smp_call_function_on_cpu()
or equivalent function which is used to do the IPIs.  I don't care if
you look that up for x86 or ARM, because the restrictions are the same
- see the last two lines:

x86:
/**
 * smp_call_function_mask(): Run a function on a set of other CPUs.
 * @mask: The set of cpus to run on.  Must not include the current cpu.
 * @func: The function to run. This must be fast and non-blocking.
 * @info: An arbitrary pointer to pass to the function.
 * @wait: If true, wait (atomically) until function has completed on other CPUs. *
  * Returns 0 on success, else a negative status code.
 *
 * If @wait is true, then returns once @func has returned; otherwise
 * it returns just before the target cpu calls @func.
 *
 * You must not call this function with disabled interrupts or from a
 * hardware interrupt handler or from a bottom half handler.
 */

arm:
/*
 * You must not call this function with disabled interrupts, from a
 * hardware interrupt handler, nor from a bottom half handler.
 */


So, if the architecture requires you to IPI the TLB flush to other CPUs
this restriction has to propagate to dma_free_coherent.  Or we just don't
provide *any* DMA coherent memory and dictate that such platforms can
never use DMA.

Which is more idiotic?

> Is it seriously true that you can call dma_alloc_coherent() from atomic
> context on arm, but not dma_free_coherent()?

Yes.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
