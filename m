From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: next-20081119: general protection fault:
 get_next_timer_interrupt()
Date: Mon, 24 Nov 2008 20:31:08 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0811242018370.3235@localhost.localdomain>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com>  <alpine.LFD.2.00.0811191308030.3119@localhost.localdomain>  <a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com>  <alpine.LFD.2.00.0811241816120.3301@localhost.localdomain>
 <1227554117.25499.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1227554117.25499.46.camel@localhost.localdomain>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>, Jens Axboe <jens.axboe@oracle.com>, Mike Anderson <andmike@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 24 Nov 2008, James Bottomley wrote:
> On Mon, 2008-11-24 at 18:43 +0100, Thomas Gleixner wrote:
> > > scsi0 : LSI SAS based MegaRAID driver
> > > Driver 'sd' needs updating - please use bus_type methods
> > > scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HE160HJ  0-24 PQ: 0 ANSI: 5
> > > ------------[ cut here ]------------
> > > WARNING: at lib/debugobjects.c:215 debug_print_object+0x4f/0x57()
> > > ODEBUG: free active object type: timer_list
> > 
> > That's the cause for your boot crash. The scsi/blk code is freeing a
> > page which contains an active timer, so the timer code references gone
> > memory. You triggered it because DEBUG_PAGEALLOC unmaps the page when
> > it's freed.
> > 
> > James, or other scsi experts please.
> 
> Well, not sure.  Most likely candidate is the new block timer code.
> What seems to be happening is that the queue is being released with
> either an outstanding request (refcounting problem) or ticking timer
> with no work (block timer problem).  The way scanning works is that we
> create a request queue for each device we probe and then delete it again
> if nothing appears after the bus settle time.   The argument against
> this is that it should show up on every scanned bus.  However, these are
> getting rarer; I was just about to write that I hadn't seen it when I
> remembered that all my SCSI testing systems are currently running
> hotplug reporting busses (i.e. don't do scanning).  However,
> fortunately, I've also booted voyager recently which does use parallel
> SCSI and doesn't see this either, so it could also be megaraid_sas
> specific.

Yeah, block could it be as well. Jens, Mike ?

One note about not seeing it: We have had such bugs before where the
page was freed but not touched and the timer survived w/o tripping the
system over. Alexander noticed because of DEBUG_PAGEALLOC and you can
also see it by enabling debugobjects, which will give you the nice
backtrace.

CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=Y

and add "debug_objects" to the kernel command line.
 
> Could you turn on SCSI logging so we can see the sequences.  Probably
> since this is boot time, just enable all logging:
> 
> echo 0xffffffff > /sys/module/scsi_mod/parameters/scsi_logging_level
> 
> (kernel must be compiled with CONFIG_SCSI_LOGGING=y
> 
> James
> 
> 
