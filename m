From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Mon, 31 Mar 2008 09:56:46 -0500
Message-ID: <1206975406.3192.16.camel@localhost.localdomain>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
	 <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
	 <1206743181.3662.55.camel@localhost.localdomain>
	 <20080328224335.1f14cf6a@core>
	 <1206748313.3662.66.camel@localhost.localdomain>
	 <da824cf30803281749l614c3592t89cce073c9b043c8@mail.gmail.com>
	 <1206760156.3662.79.camel@localhost.localdomain>
	 <da824cf30803302150m8157e8aob5914f8efef58ed9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33476 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257AbYCaO4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 10:56:51 -0400
In-Reply-To: <da824cf30803302150m8157e8aob5914f8efef58ed9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, 2008-03-30 at 21:50 -0700, Grant Grundler wrote:
> On Fri, Mar 28, 2008 at 8:09 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2008-03-28 at 17:49 -0700, Grant Grundler wrote:
> >  > On Fri, Mar 28, 2008 at 4:51 PM, James Bottomley
> >  > <James.Bottomley@hansenpartnership.com> wrote:
> >  > ...
> >  > >  So basically, most of the cpu_to_le32 in this driver look wrong.  If I
> >  > >  can fix it (or persuade someone else to fix it) can anyone test it on a
> >  > >  BE platform?
> >  >
> >  > But the code I submitted the patch is also broken for LE platforms.
> >  > (As you pointed out earlier and was my original incentive for
> >  > submitting the patch).
> >
> >  No ... it's correct on a LE platform .. the warning is superfluous we
> >  promote a u8 to a u32 and then complain when it's truncated to a u8
> >  again.
> 
> Yeah, you are right. It would produce correct code on LE platform.
> Not sure why now I thought it wouldn't.
> 
> >  > If most of the usage is wrong anyway, perhaps it's better to
> >  > not pretend the driver can work on a BE platform and just rip
> >  > all the cpu_to_le32() usage out...including the one I submitted
> >  > the patch for. Either way, that change should go in. Right?
> >
> >  Well, not really; the problem is it's not complete ... it only covers up
> >  the real problem by silencing the warning.
> 
> After looking at the code for a bit, I think I would prefer to disable
> the driver entirely for BE platforms since it's pretty clear it could
> never work correctly. I'm not willing to own it for BE platforms.

Unfortunately, there's no way to do that which won't have the random
configuration people after you with a big stick ... we don't have a
config option for BE, only a runtime option ... make the compile break
and they'll find it and bug report it.

Don't worry, I won't make you own the BE part of this.  A reasonable fix
that looks like it has a chance of working will be fine.

> >  If the actual BE pieces of the driver worked, you could make it correct
> >  either by making senselen a u32 and leaving the cpu_to_le32 or adding it
> >  to the point at which we assign it to bufflen.
> 
> Making senselen u32 would also require fixing this bit in tulip_main():
>                         if (!(scb->mode & SCM_RSENS)) {         /* not
> in auto req. sense mode */
> ...
>                                         if (scb->flags & SCF_SENSE) {
>                                                 u8 len;
>                                                 len = scb->senselen;
> ...
>                                                 scb->cdb[3] = 0;
>                                                 scb->cdb[4] = len;
>                                                 scb->cdb[5] = 0;
>                                                 initio_push_pend_scb(host, scb);
>                                                 break;
> ...

Sure ... but the u32 fix doesn't work because the driver isn't BE ready.
The correct fix is to trip the wrong cpu_to_leX out of it.

> 
> >  If you can verify my analysis of the way the driver works, then the
> >  complete fix should be pretty simple: just remove the cpu_to_le32 from
> >  everywhere except the sg list construction.
> 
> I think your analysis is correct. Seems the key bits are
> in initio_xfer_data_in/out() routines and around the SCF_SG handling.
> 
> But I am not interested in actually testing it.

I'm not sure anyone can.  All of the initio users I know (well both of
them) have x86 boxes.

> The more I look at this code, the less I want to do with it.

OK ... just fix what we currently know is broken and I'll find some
other willing victim^Wvolunteer if someone actually finds that it still
doesn't work.

> Another similar issue with bufptr usage in tulip_main():
> 
>                                                 scb->bufptr = scb->senseptr;
> 
> is pushing a LE32 into native byte pointer used in initio_state_5():

No ... bufptr is transmitted directly via outl, so it should be a CPU
native variable.  The only bus native variables we have in the entire
driver are the SG list elements.

>                                 scb->bufptr += ((u32) (i - scb->sgidx) << 3);
> 
> and
>                 scb->bufptr += (u32) xcnt;
> 
> bufptr will be converted to "Bus Endianess" when finally written to
> the controller:
>                 outl(scb->bufptr, host->addr + TUL_XAddH);

Right, so we strip the spurious cpu_to_leX and keep everything CPU
native (apart from the SG list entries).

> I also expected bugs with initio_host->semaph. I initially thought
> there would be memory ordering issues and needed to be
> declared "volatile". But seems to be properly protected by a spinlock.
> 
> Nit:  i91u_intr() could use spin_lock() instead of spinlock_irqsave().

The call chains for that one are pretty deep ... are you sure?  I agree
it looks like it should be re-entrant against other interrupts, but I
wouldn't bet the farm on it ... and if we're wrong the x86 users will
see corruption.

James


