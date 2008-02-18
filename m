From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: gdth new set of patches for 2.6.24 stable
Date: Mon, 18 Feb 2008 14:02:58 +0000
Message-ID: <20080218140258.GB6606@flint.arm.linux.org.uk>
References: <47B48CAE.2020705@panasas.com> <47B864CB.4040604@panasas.com> <20080218045736.d35d5408.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40602 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYBROJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 09:09:51 -0500
Content-Disposition: inline
In-Reply-To: <20080218045736.d35d5408.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Brownell <dbrownell@users.sourceforge.net>, Greg Kroah-Hartman <gregkh@suse.de>, Ralf Baechle <ralf@linux-mips.org>

On Mon, Feb 18, 2008 at 04:57:36AM -0800, Andrew Morton wrote:
> But arm and mips require enabled local irqs because their
> dma_free_coherent() needs to do a cross-cpu IPI call.  Presumably because
> of certain unusual TLB protocols.

Consider that TLB flushing needs to call a function on another CPU.
Now look at x86's implementation to do cross calls:

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
static int
native_smp_call_function_mask(cpumask_t mask,
                              void (*func)(void *), void *info,
                              int wait)

You can not call functions on other CPUs without having IRQs enabled,
otherwise this functionality deadlocks.  That restriction is on all
smp_call_function() implementations.

Unfortunately, to flush the TLB on other CPUs on ARM, we need to do a
cross call, which means using smp_call_function(), which introduces the
same sodding restrictions that smp_call_function() has on the functions
which call it.

> Russell, Ralf: is there something we can do here to relax this requirement?

Do what x86 people have so far been unable to resolve and find some
way to allow smp_call_function() to operate with IRQs disabled without
deadlocking?

Another solution jejb suggested was to make dma_free_coherent() lazy,
but (a) I'm unconvinced that this'll work with drivers which constantly
alloc+free in IRQ context since there's generally only 2MB of VM space
for such mappings, and it probably won't take long to eat through that
limited space with such a scheme.

Also, I don't have the facility to really test out these issues...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
