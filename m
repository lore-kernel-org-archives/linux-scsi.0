From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large amount of scsi-sgpool objects
Date: Tue, 3 Mar 2009 18:19:16 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0903031818230.29264@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>  <49ACF8FE.2020904@panasas.com>  <1236093718.3263.3.camel@localhost.localdomain>  <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
 <1236097526.3263.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <1236097526.3263.17.camel@localhost.localdomain>
Sender: linux-rt-users-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 3 Mar 2009, James Bottomley wrote:

> On Tue, 2009-03-03 at 17:08 +0100, Jan Engelhardt wrote:
> > On Tuesday 2009-03-03 16:21, James Bottomley wrote:
> > >> > $ slabtop
> > >> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> > >> > 818616 818616 100%    0.16K  34109       24    136436K sgpool-8
> > >> > 253692 253692 100%    0.62K  42282        6    169128K sgpool-32
> > >> >  52017  52016  99%    2.50K  17339        3    138712K sgpool-128
> > >> >  26220  26219  99%    0.31K   2185       12      8740K sgpool-16
> > >> >   8927   8574  96%    0.03K     79      113       316K size-32
> > >> 
> > >> Looks like a leak, by failing to call scsi_release_buffers()
> > >> somehow. (Which was changed recently)
> > >
> > >Firstly, I have to say I don't see this in the mainline tree, so could
> > >you try that with your setup just to verify (git head at 2.6.29-rc6).
> > 
> > Yes, looking at the rt patch (in broken-out it's in origin.diff),
> > it seems a bit obvious - the scsi_release_buffers is not called anymore:
> 
> OK, this is a bad patch, so just revert it.  It was posted to linux-scsi
> initially in this form before the author posted a new one with the
> missing release buffers added.  It looks like the first incarnation got
> pulled into the -rt tree for some reasons.
> 
> So the real question is why does the -rt tree even have patches not in
> the vanilla SCSI tree?  This type of cockup clearly demonstrates why
> it's a bad idea.

My bad. I was playing with that to get rid of the aic7xxx wreckage on
one of my test boxen and forgot to remove it.

Thanks,

	tglx
