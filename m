From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: scsi command slab allocation under memory pressure
Date: Mon, 3 Feb 2003 22:15:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10302032204170.2810-100000@master.linux-ide.org>
References: <20030203225550.GJ29516@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030203225550.GJ29516@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Andrew Morton <akpm@digeo.com>, James Bottomley <James.Bottomley@steeleye.com>, patmans@us.ibm.com, luben@splentec.com, linux-scsi@vger.kernel.org


Doug,

I had argued some time ago for reserved and priority allocation for swap
under block period.  Regardless if this is scsi/ata/sas/sata the issue is
fundamential.  I spent a fair amount of time debating memory pressure
against swap in combination of saturated device request queues, with Rik
Riel.  This is one layer above the LLDD and regardless if you reserve
1,2,N-1,N command slots in the queuedcommand list.  If the request can
not be obtained from block because all request slots are stuffed full, you
have to deploy an out-of-bounds operation.

Progress will not happen period.  Elevator sorting on swap is silly!
If it is still done, you can not get there from here.  Any swap-io run via
the elevator must be inserted in the front of the request queue, period.
This will provide you N+1 jump without fracturing all the commands in
process or in flight.  Since it would be priority, one can stuff it with
the SPECIAL marker and boost it to the head of the queuedcommand list.

Maybe I am on crack, but so is the design delpoyed to date.
	(from top->bottom and not bottom->up)

Cheers,


Andre Hedrick
LAD Storage Consulting Group


On Mon, 3 Feb 2003, Doug Ledford wrote:

> On Fri, Jan 31, 2003 at 12:44:12PM -0800, Andrew Morton wrote:
> > Bear in mind that on the swapout path, the calling process has PF_MEMALLOC
> > set.  This is a strong and successful mechanism - it allows the caller to dip
> > into the final page reserves which are denied to even GFP_ATOMIC allocations.
> > There's maybe a megabyte or two there.
> > 
> > Could be that there's no problem to be solved here.  It depends on whether
> > these allocations are occurring in process context or not.
> 
> I think the case is that there is no problem to be solved.  One command 
> per host is enough to keep each host running, and that's enough to keep 
> the system running.  If we are ever low enough on mem that we get down to 
> failing scsi command allocations, the system is already hurting.  The 
> complaint was that a device doing something other than swap could starve a 
> swap device.  I don't buy that.  If the device is doing constant reads 
> then it's going to run out of mem eventually and block just like our 
> allocations are, if it's writing then it very likely is freeing up just as 
> many pages as the swap operation would be.  In short, I think if we keep 
> the disk subsystem running, even if crippled with just one command, the 
> problem becomes self correcting and there isn't much for us to solve.  Of 
> course, that's just my 5 minute analysis, someone feel free to prove me 
> wrong.
> 
> -- 
>   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
>          Red Hat, Inc. 
>          1801 Varsity Dr.
>          Raleigh, NC 27606
>   
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

