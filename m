From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Wed, 25 Feb 2009 14:12:24 -0700
Message-ID: <20090225211224.GW16891@parisc-linux.org>
References: <da824cf30902241600g121d2acfw937020a750a79a57@mail.gmail.com> <660360F4F2570145BD872F298951B17A7673CB09@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44403 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbZBYVMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2009 16:12:42 -0500
Content-Disposition: inline
In-Reply-To: <660360F4F2570145BD872F298951B17A7673CB09@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Grant Grundler <grundler@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Feb 25, 2009 at 01:27:00PM -0700, Moore, Eric wrote:
> > > +static void
> > > +_base_mask_interrupts(struct MPT2SAS_ADAPTER *ioc)
> > > +{
> > > + ? ? ? u32 him_register;
> > > +
> > > + ? ? ? ioc->mask_interrupts = 1;
> > > + ? ? ? him_register = readl(&ioc->chip->HostInterruptMask);
> > > + ? ? ? him_register |= MPI2_HIM_DIM + MPI2_HIM_RIM + 
> > MPI2_HIM_RESET_IRQ_MASK;
> > > + ? ? ? writel(him_register, &ioc->chip->HostInterruptMask);
> > 
> > This is a posted write. Does it need to be flushed?
> > ie do other parts of the driver require this take effect immediately
> > or will they tolerate some late arriving interrupt?
> 
> What are you suggesting?   Calling wmb()?

PCI writes can be posted, so the him_register writel() may not complete
for a few thousand cycles.  wmb() isn't going to solve the problem.  A
readl() from the device would, as would your current solution of
ignoring subsequent interrupts.

> I thought I was handling this case.   I'm setting the flag "ioc->mask_interrupts".  If there are any spurious interrupts that occur following this calling this function, I will ignore them from the interrupt routine -> base_interrupt() where I have this sanity check.

> > > + ? ? ? /* reply post descriptor handling */
> > > + ? ? ? post_index_next = ioc->reply_post_host_index;
> > > + ? ? ? for (i = 0 ; i < completed_cmds; i++) {
> > > + ? ? ? ? ? ? ? post_index = post_index_next;
> > > + ? ? ? ? ? ? ? /* poison the reply post descriptor */
> > > + ? ? ? ? ? ? ? ioc->reply_post_free[post_index_next].Words =
> > > + ? ? ? ? ? ? ? ? ? 0xFFFFFFFFFFFFFFFFULL;
> > > + ? ? ? ? ? ? ? post_index_next = (post_index ==
> > > + ? ? ? ? ? ? ? ? ? (ioc->reply_post_queue_depth - 1))
> > > + ? ? ? ? ? ? ? ? ? ? 0 : post_index + 1;
> > > + ? ? ? }
> > > + ? ? ? ioc->reply_post_host_index = post_index_next;
> > > + ? ? ? writel(post_index_next, &ioc->chip->ReplyPostHostIndex);
> > > + ? ? ? wmb();
> > 
> > What is the wmb() protecting here? Add a comment?
> > 
> > My impression is the wmb() belongs in front of the writel() 
> > and not behind it.
> > That is, we want to make sure the updates to ioc->reply_post_free[]
> > are visible before sending out the writel().
> 
> I'm doing is a 64bit write to pcie memory. On some systems this is broken out to two 32bit writes.  So I put the barrier there to insure the entire 64bits was written out to the ReplyPostHostIndex register before another write was done.   
Um, you're doing a writel(), not a writeq(), so you're doing a 32-bit
write.  Also, PCI writes can't be reordered, so you don't need a wmb() here.

> > > + ? ? ? /* current HW implemention uses only one interrupt 
> > handler */
> > 
> > Which implementation?
> > This comment sounds like it expects to be obsolete soon.
> > Specifying the implementation makes it clear even when other
> > implementations become available.
> 
> The explanation is currently we only map the first MSIX vector for all interrupts   In future products we may have more expand to use more vectors, however that has not been decided upon yet. What I mean by more vectors is we might map the 1st vector for initiator mode, and the 2nd for target mode, or maybe in virtualization, each VF port is assigned its own handler.

It's also worth considering a mode where each CPU gets its own
interrupt.  That lets us complete IOs on the CPU which submitted them
and can be a real performance win.

> > 
> > > + ? ? ? r = request_irq(entries[0].vector, base_interrupt, 
> > IRQF_SHARED,
> > > + ? ? ? ? ? ioc->name, ioc);
> > 
> > MSI is never shared. IRQF_SHARED flag is still correct?
> > 
> > I have to stop looking now...back to work. :(
> > 
> 
> There are two drivers that currently implement MSIX in the scsi tree.  I found the emulex driver doing IRQF_SHARED, and qlogic is zero.    Since we suport shared interrupts, I set it up for that.  I didn't know if it mattered, does it?

It doesn't matter.

I'm somewhat puzzled that you request four MSI-X interrupts, then only
use one of them.  Why not just request one?


Are there any currently shipping products using this chip?  It'd be nice
to get hold of some.  Also, is there any documentation available to the
public (or under NDA) on programming this hardware?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
