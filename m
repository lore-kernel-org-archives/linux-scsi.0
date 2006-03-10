From: Doug Ledford <dledford@redhat.com>
Subject: Re: scsi_track_queue_full function - static values ?
Date: Fri, 10 Mar 2006 14:16:19 -0500
Message-ID: <20060310191619.GC1841@redhat.com>
References: <440D8B7C.9020001@ext.bull.net> <20060310164027.GA6397@infradead.org> <20060310182032.GA1841@redhat.com> <1142015990.2876.94.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:23268 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1752014AbWCJTQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 14:16:26 -0500
Content-Disposition: inline
In-Reply-To: <1142015990.2876.94.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org, Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>, Christoph Hellwig <hch@infradead.org>

On Fri, Mar 10, 2006 at 07:39:50PM +0100, Arjan van de Ven wrote:
> 
> > QUEUE_FULLs happen in bunches.  When you have 10 commands waiting to go to a
> > drive, and you fill its queue, depending on the driver you will either block
> > the remaining 9 commands or all 10 commands will end up getting sent back to
> > back and all 10 will QUEUE_FULL out.  You want these mass QUEUE_FULL events
> > to be treated as a single QUEUE_FULL for the purpose of tracking the
> > device's queue depth.  In addition, you want to know the depth the device
> > was at, not how many commands the mid layer has created.  Only the driver
> > can now that since different drivers queue things differently internally,
> 
> drivers no longer queue thankfully ;)

Drivers always queue and always will ever since the age of the 1542 ISA
cards.  There isn't a SCSI host in use today that doesn't have some sort of
smarts or scripts or other things that mean that a command on the card !=
command on the drive.  Move things up to the mid layer that make sense there
and where you can do them well there, but don't move them there for the sake
of making driver writing a lowest common demoninator profession, especially
when doing so cripples a driver's ability to do the "Right Thing".  Counting
the actual queue depth is a driver specific thing and it will be until the
entire current crop of hardware drastically changes.

> > there may be commands that are paused and not yet sent to the device but are
> > present on the card, etc. 
> 
> that'll be hard to find out anyway

Not for the card driver.  Not to speak for the aic7xxx, but at least in the
aic7xxx_old driver, on QUEUE_FULL, my driver did the following things:

1) looking for any commands on the device queue (this is where commands from
aic7xxx_queue go to first, it's in the driver itself, not on the card) and
move them to the waiting queue (another driver internal queue that was
monitored and when it wasn't empty, a backup timer was set to make sure it
didn't stall permanently).

2) pause sequencer on card, look for the current position of the sequencer
on the QIN_FIFO.  If it isn't at the head, then search from current position
to head looking for commands for the problem device, if found, move those to
the head of the waiting queue, update head pointer of queue.

3) check current command in sequencer to make sure it isn't a command for
target device that hasn't been sent yet and may be in selection, if so, kill
it and set sequencer to restart on unpause

4) check waiting list on card to see if any commands are waiting for
selection (only happens on first command send, never for reselection as
that's target driven and it's the disconnected list instead), if they match
target, kill them as well.  If no command left on list or in process, make
sure selection is killed on the bus.

5) check QOUT_FIFO for commands that have already completed but not yet
serviced by an interrupt that belong to the device

After clearing all that stuff out, then and only then do I have an accurate
count of what depth the device was at when it sent a QUEUE_FULL.

For every single card with a firmware or scripts this is going to be
different depending on how that firmware handles things.  So, I say again,
drivers *ALWAYS* queue, whether you choose to acknowledge it or not is your
business.  Handling queue fulls properly will, therefore, *never* be
something that can be genericized fully.  My code was an attempt to
genericize just that part which is common across all devices, the
host/target interaction.  The host specific stuff was all left up to the
driver.

> 
> > command outstanding at a time, any driver that sets cmd_per_lun > 1 must, by
> > definition, be able to do it's own internal queueing and respect the limit
> > of 1 command at a time on untagged devices. 
> 
> 
> Hmmmmmmmm are you sure?

Try sending more than 1 untagged command to a device at a time.  Instant
error.  So, of course if cmd_per_lun is > 1 and the device is untagged it
must be queued somewhere.  Where may be a question now, but it used to be
either in the driver or the hardware.  In my case, it was the driver and
that was specifically so that on command completion of an untagged command I
would have the next command ready to go and could stick it in the cards
QIN_FIFO during the interrupt handler, thereby improving things like round
trip time on tape drives so as to not interrupt streaming.  If it's at the
mid layer level now, then you've taken away a driver's ability to do what I
just mentioned.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
