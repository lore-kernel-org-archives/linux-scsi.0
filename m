From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: SCSI Command scatter-gather number
Date: Wed, 31 Jul 2002 18:16:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10207311816.ZM1325090@classic.engr.sgi.com>
References: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A678@nonamea.ptu.promise.com>
	<20020730144326.A26330@beaverton.ibm.com>
	<3D4757FF.9F91971F@torque.net>
	<20020731011159.B27756@redhat.com>  <dledford@redhat.com>
	<10207310044.ZM1319430@classic.engr.sgi.com>
	<20020731093644.B28154@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Doug Ledford <dledford@redhat.com>
        "Re: SCSI Command scatter-gather number" (Jul 31,  9:36am)
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Douglas Gilbert <dougg@torque.net>, Mike Anderson <andmike@us.ibm.com>, Haofeng Kou <haofengk@ptu.promise.com>, linux-scsi@vger.kernel.org

On Jul 31,  9:36am, Doug Ledford wrote:
> 
> On Wed, Jul 31, 2002 at 12:44:42AM -0700, Jeremy Higdon wrote:
> > On Jul 31,  1:11am, Doug Ledford wrote:
> > > 
> > > Most LLDD don't want to use too large of a number because to be truly safe
> > > you must preallocate enough memory for these sg structs at init time and
> > > hold it forever.  You obviously can't allocate memory for a sg struct when
> > > you are out of mem, it's a deadlock scenario.  So, 256 elements per
> > > command is 2048 bytes of permanently allocated DMAable memory per command 
> > > the host controller can queue (given the typical 8 byte, 32bit DMA 
> > > address hardware sg struct, gets worse when you support 64bit 
> > > addressing).  Support something like 256 commands on the card total and 
> > > that's now 512K of memory just for sg structs and doesn't count the actual 
> > > scsi command blocks that the cards also need dma memory for...
> > 
> > Why not allocate 1 (or a small number) of giant s/g lists, and N
> > medium lists (where N is the max # of outstanding commands).  Then,
> > when you get a request that needs more s/g entries than the medium,
> > you allocate a new list.  If that fails, you use the preallocated
> > giant list when it's available, leaving the request on the lld's
> > internal queue?
> 
> For random use patterns it might be sufficient, but under lots of load 
> scenarios that I've seen this wouldn't work too well.  It depends on 
> whether or not you want your driver to be able to do the full streaming 
> stuff that tends to blow up this type of allocation.

1.  You can tune the medium size s/g list size to whatever it needs to
    be for your usage.  The point is that you don't have to restrict
    your maximum I/O request size when you restrict your memory footprint.

2.  Memory allocation overhead for s/g lists for huge I/O requests is
    small, unless the memory allocator is very inefficient.


> > I found that a good tradeoff between maximum request size and reasonable
> > memory usage.
> > 
> > Similary for the Qlogic example, you don't have to worry about throttling
> > to the lld, since it can just leave commands on its internal queue if
> > there isn't enough space in the request queue.  You can then issue the
> > queued commands when the next command completes, or you can set a timer
> > to check to see if there is new space in the request queue.
> 
> This is exactly what I want to avoid.  There should not be any reason that 
> all the low level drivers implement their own queues and timers.  That 
> code most definitely *is* perfectly generic enough that I would like to 
> see the mid layer get it right and I would like to see low level drivers 
> yanking out queue code left and right, and instead the low level drivers 
> should not be required to do any more than tell the mid layer yes I can 
> take this or no I'm too busy right now, hold on to this until I'm ready.


That has the same effect as what I was describing.  It just moves the
code to another place and adds an interface call (scsi_does_lld_have_room()).
When would you check for room next -- when a command completes or after
a certain amount of time passes.

jeremy
