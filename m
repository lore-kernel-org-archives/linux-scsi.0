From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 15:32:59 -0500
Message-ID: <1209673979.14864.23.camel@localhost.localdomain>
References: <4819C9DB.60104@panasas.com>
	 <1209651854.3067.8.camel@localhost.localdomain>
	 <4819DA39.70505@panasas.com>
	 <1209655360.3067.14.camel@localhost.localdomain>
	 <4819E371.2040403@panasas.com>
	 <1209656838.3067.16.camel@localhost.localdomain>
	 <4819E8C7.3040808@panasas.com>
	 <1209657731.3067.19.camel@localhost.localdomain>
	 <4819EEEE.5030205@panasas.com>
	 <1209659881.14864.4.camel@localhost.localdomain>
	 <4819F894.6020009@panasas.com>
	 <1209663229.14864.18.camel@localhost.localdomain>
	 <481A087D.10707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42725 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756290AbYEAUdF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 16:33:05 -0400
In-Reply-To: <481A087D.10707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>

On Thu, 2008-05-01 at 21:14 +0300, Boaz Harrosh wrote:
> On Thu, May 01 2008 at 20:33 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Thu, 2008-05-01 at 20:06 +0300, Boaz Harrosh wrote:
> >> On Thu, May 01 2008 at 19:38 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >> <snip> 
> >>> Er, but
> >>>
> >>>      1. struct cmdinfo is stack allocated; you can't dma to stack
> >>>      2. even if you fix this, the structure is packed and will have the
> >>>         original ppc coherence issues
> >>>      3. Finally, even on the stack, it's not necessarily reachable with
> >>>         the DMA mask
> >>>
> >> Ho, thanks for the catch. I really goofed here.
> >>
> >>> The whole point of managing sense buffer allocations centrally is to
> >>> prevent driver writers from falling into all these traps.  I really
> >>> don't think going back to hand rolled bounce buffering imporves the
> >>> situation.
> >>>
> >> We don't have a choice Andi is removing all this. ISA is becoming
> >> ISA's driver private problem.
> > 
> > No he's not .. not if it's going to cause this type of grief.
> > 
> > But I think you misread his patch set.  He still has a flag equivalent
> > of unchecked_isa_dma  it's just called sense_buffer_isa instead.  The
> > shift in his patch set is 
> > 
> >      1. it removes the need to allocate commands in dma'able memory
> >      2. it removes the need for the ULD request path to allocate in
> >         dma'able memory (it uses the block bounce path instead)
> >      3. it *can't* remove the need to dma to the sense buffer, hence the
> >         flag.
> > 
> > So it looks like the re-rolled patch set (when Andi gets around to
> > posting it) will use one pool for the cmd buffer, but separate isa and
> > non-isa pools for the sense buffer.  Thus it should just work for gdth
> > with scsi_allocate_command predicated on sense_buffer_isa.
> > 
> > James
> > 
> 
> I know all about Andi's patches, since I offered to help him as I
> have some experience with scsi drivers. And it will be me that will
> post the next round of ISA patches.
> 
> I have the complete body of work here:
> http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=boaz_sense_effort
> 
> I planed to first submit up to the Remove-ISA-dma tag and only then RFC and try
> to push the rest of the work.

But most of what you're doing in that patch set doesn't work.  The whole
reason for separating the sense buffer from the scsi command is the DMA
problem of cache line interference caused by doing DMA to an area
embedded in a structure that has host accessed variables in it.  With
what you're doing embedding the sense buffer in the internal control
areas, you're re-introducing that bug.

Additionally, it really doesn't make sense for every driver to do a roll
your own allocator.  It makes far more sense for them to be allocated
centrally (and correctly) so there's only one place it needs fixing if
there's yet another problem discovered.

James


