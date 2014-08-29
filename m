From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: Debugging scsi abort handling ?
Date: Fri, 29 Aug 2014 20:14:32 +1000 (EST)
Message-ID: <alpine.LNX.2.00.1408291924010.25858@nippy.intranet>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com>
 <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com> <53FF39F7.3070004@suse.de> <53FF430F.5060103@redhat.com> <53FF4709.9040801@suse.de> <alpine.LNX.2.00.1408291419070.29948@nippy.intranet> <540018E0.9050907@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:53817 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaH2KPg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Aug 2014 06:15:36 -0400
In-Reply-To: <540018E0.9050907@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>, Robert Elliot <elliot@hp.com>


On Fri, 29 Aug 2014, Hannes Reinecke wrote:

> On 08/29/2014 06:39 AM, Finn Thain wrote:
> >
> > On Thu, 28 Aug 2014, Hannes Reinecke wrote:
> >
> > > What might happen, though, that the command is already dead and gone 
> > > by the time you're calling ->scsi_done() (if you call it after 
> > > eh_abort). So there might not _be_ a command upon which you can call
> > > ->scsi_done() to start with.
> > >
> > > Hence any LLDD need to clear up any internal references after a call 
> > > to eh_XXX to ensure it doesn't call ->scsi_done() an in invalid 
> > > command.
> > >
> > > So even if the LLDD returns 'FAILED' upon a call to eh_XXX it 
> > > _still_ needs to clear up the internal reference.
> >
> > This is a question that has been bothering me too. If the host's 
> > eh_abort_cmd() method returns FAILED, it seems the mid-layer is liable 
> > to re-issue the same command to the LLD (?)
> >
> No.
> FAILED for any eh_abort_cmd() means that the TMF hasn't been sent.

Makes sense, though it appears to contradict this advice about returning 
SUCCESS in some situations: 
http://marc.info/?l=linux-scsi&m=140923498632496&w=2

> The command will only ever be re-issued once EH completes.

...

> 
> But indeed, 'FAILED' is not very meaningful here, leaving the midlayer 
> with no information about what happened to the command.
> 
> Personally I would like to enforce this meaning on the eh_XXX callbacks:
> - upon each eh_XXX callback the LLDD clears any internal references
>   to the command / command scope (ie eh_abort_cmd clears the
>   references to the command, eh_lun_reset clears all internal
>   references to commands to this ITL nexus etc.)
>   This happens irrespective of the return code.
> - The eh_XXX callback shall return 'FAILED' if the respective
>   TMF (or equivalent) could not be initiated.
> - The eh_XXX callback shall return 'SUCCESS' if the respective
>   TMF (or equvalent) could be initiated.
> - After each eh_XXX callback control for this command / command
>   scope is transferred back to the midlayer; the LLDD shall not
>   assume the associated command structures to remain valid after
>   that point.

Perhaps that last constraint should be relaxed to "After the final EH 
callback (whether implemented or unimplemented by the host), command / 
command scope is transferred back to the midlayer..."

A more severe TMF is probably mandatory (e.g. bus reset) but if the driver 
author later added a milder one (e.g. bus device reset), your rule would 
mean that the existing handler would then operate under new constraints, 
which might cause surprises.

> [...] I'm tempted to enshrine this in the documentation;

It is helpful, thanks.

-- 
