From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Tue, 3 Mar 2009 14:49:05 -0700
Message-ID: <20090303214905.GA1539@parisc-linux.org>
References: <da824cf30902241600g121d2acfw937020a750a79a57@mail.gmail.com> <660360F4F2570145BD872F298951B17A7673CB09@cosmail03.lsi.com> <20090225211224.GW16891@parisc-linux.org> <1236115756.15993.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58140 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbZCCVtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 16:49:23 -0500
Content-Disposition: inline
In-Reply-To: <1236115756.15993.23.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Grant Grundler <grundler@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Mar 03, 2009 at 03:29:16PM -0600, James Bottomley wrote:
> On Wed, 2009-02-25 at 14:12 -0700, Matthew Wilcox wrote:
> > On Wed, Feb 25, 2009 at 01:27:00PM -0700, Moore, Eric wrote:
> > > > > +static void
> > > > > +_base_mask_interrupts(struct MPT2SAS_ADAPTER *ioc)
> > > > > +{
> > > > > + ? ? ? u32 him_register;
> > > > > +
> > > > > + ? ? ? ioc->mask_interrupts = 1;
> > > > > + ? ? ? him_register = readl(&ioc->chip->HostInterruptMask);
> > > > > + ? ? ? him_register |= MPI2_HIM_DIM + MPI2_HIM_RIM + 
> > > > MPI2_HIM_RESET_IRQ_MASK;
> > > > > + ? ? ? writel(him_register, &ioc->chip->HostInterruptMask);
> > > > 
> > > > This is a posted write. Does it need to be flushed?
> > > > ie do other parts of the driver require this take effect immediately
> > > > or will they tolerate some late arriving interrupt?
> > > 
> > > What are you suggesting?   Calling wmb()?
> > 
> > PCI writes can be posted, so the him_register writel() may not complete
> > for a few thousand cycles.  wmb() isn't going to solve the problem.  A
> > readl() from the device would, as would your current solution of
> > ignoring subsequent interrupts.
> 
> This seems to be the most serious issue with the current patch set.  If
> you repost with that fixed, I can put it into scsi-misc and we can
> address the other issues later.

I'm confused.  There's no issue with the code that Eric posted.  Grant
asked if he needs to readl() in order to flush the posted write, but the
answer is no, because if a spurious interrupt comes in, the interrupt
handler will ignore it.  So I don't see what Eric needs to fix.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
