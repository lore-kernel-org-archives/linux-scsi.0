From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: SCSI Command scatter-gather number
Date: Wed, 31 Jul 2002 00:44:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10207310044.ZM1319430@classic.engr.sgi.com>
References: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A678@nonamea.ptu.promise.com>
	<20020730144326.A26330@beaverton.ibm.com>
	<3D4757FF.9F91971F@torque.net>
	<20020731011159.B27756@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Doug Ledford <dledford@redhat.com>
        "Re: SCSI Command scatter-gather number" (Jul 31,  1:11am)
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Douglas Gilbert <dougg@torque.net>
Cc: Mike Anderson <andmike@us.ibm.com>, Haofeng Kou <haofengk@ptu.promise.com>, linux-scsi@vger.kernel.org

On Jul 31,  1:11am, Doug Ledford wrote:
> 
> Most LLDD don't want to use too large of a number because to be truly safe
> you must preallocate enough memory for these sg structs at init time and
> hold it forever.  You obviously can't allocate memory for a sg struct when
> you are out of mem, it's a deadlock scenario.  So, 256 elements per
> command is 2048 bytes of permanently allocated DMAable memory per command 
> the host controller can queue (given the typical 8 byte, 32bit DMA 
> address hardware sg struct, gets worse when you support 64bit 
> addressing).  Support something like 256 commands on the card total and 
> that's now 512K of memory just for sg structs and doesn't count the actual 
> scsi command blocks that the cards also need dma memory for...

Why not allocate 1 (or a small number) of giant s/g lists, and N
medium lists (where N is the max # of outstanding commands).  Then,
when you get a request that needs more s/g entries than the medium,
you allocate a new list.  If that fails, you use the preallocated
giant list when it's available, leaving the request on the lld's
internal queue?

I found that a good tradeoff between maximum request size and reasonable
memory usage.

Similary for the Qlogic example, you don't have to worry about throttling
to the lld, since it can just leave commands on its internal queue if
there isn't enough space in the request queue.  You can then issue the
queued commands when the next command completes, or you can set a timer
to check to see if there is new space in the request queue.

jeremy

> There are some controllers out there that can't use a fixed size,
> unfortunately.  Look at the crap in qlogicfc.c and qlogicisp.c in their
> queuecommand() routines to see what I'm referring to.  That's something I
> would like to do something about in my changes, but I haven't decided if
> it's worth it.  What I would like to do actually is decouple the maximum
> sg table size from the available sg table size by introducing the concept
> of both a maximum single command sg table size and a sg pool limit.  This
> way a low level driver can support a really large size sg table on a few
> commands and still deal with other smaller commands by doing internal DMA
> pool allocations.  However, this would have to be optional since pool
> fragmentation issues and such would make *truly* supporting this somewhat
> messy down in the LLDD.  The old way of doing sg limiting should still
> work (which is easy, just set the pool size to can_queue * sg_tablesize
> and forget about it).  Certain Qlogic cards need this to be treated like a
> finite resource where each command uses some number of these up out of a
> total count pool.
> 
> However, the way that the Qlogic driver needs to calculate both the
> available sg table entries and the available command queue slots is
> actually odd enough that no generic mechanism for supporting it in the mid
> layer is possible.  Only the driver really knows how these finite
> resources are used up, and when you know the manipulations the driver goes
> through then you'll agree only the driver should know, I'm sure ;-)
> 
> The Qlogic interface has a command queue slot which can start a command
> plus contain up to 4 sg entries.  Then, to get more sg entries, you must
> use a daisy chained command queue slot, which may contain up to 7 more sg
> segments.  In this way, a command with a 12 segment sg table needs to use
> 3 command queue slots to be sent out to the device.  So, while the mid
> layer would increase the active command count by 1 (while checking it
> against can_queue to keep from sending too many commands to the device)
> and also assumes that the number of available sg table entries is constant
> for the next command, we would have actually used up 3 command slots and
> 21 possible sg table entries.  The Qlogic drivers attempt to make up for
> this by futzing with can_queue and sg_tablesize in their queuecommand()  
> routines.  Switching to per queue locks breaks this futzing horribly and
> results in all sorts of crap with these drivers.
> 
> Properly supporting this type of driver interface model is something on my
> list of "want to accomplish" items, but I really haven't decided how to 
> try and accomplish it yet.  It would, at a minimum, require support from 
> the LLDD and it would likely require that scsi_resuest_fn() be prepared to 
> stick a command back on the request queue if it turns out that not all the 
> resources it thought were available truly were.
