From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: 29 Jan 2003 17:53:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1043880795.1775.2.camel@mulgrave>
References: <20030129104731.A2811@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA13845
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2003 14:53:22 -0800
In-Reply-To: <20030129104731.A2811@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-01-29 at 13:47, Patrick Mansfield wrote:
> The linux-scsi.bkbits.net scsi-kmem_alloc-2.5 and scsi-combined-2.5 tree
> include the scsi command slab allocation (Luben's patch).
> 
> How does the use of a single slab for all hosts and all devices allow for
> IO while under memory pressure?

In essence, all we really need to guarantee under memory pressure is
that I/O which is being used to clear memory (i.e. for the swap device)
will eventually proceed.  This is the weakest necessary assumption for
the system to make forward progress.  Having a single command per device
(or even just a single available command) guarantees this since if it is
outstanding, it will eventually return and be re-used for clearing
memory, which is all that is required.

With a single command per host, there is a starvation issue if you have
heavy I/O to a device whose controller also contains the swap.  However,
it would have to be fairly pathological conditions to continue doing
heavy I/O under memory pressure while starving the swap device.

> There is one extra scsi command pre-allocated per host, but don't we
> require at least one (and ideally maybe more) per device? The pre-slab
> (current mainline kernel) command allocation always had at least one
> command per device available, and usually more (because we allocated more
> commands during the scan and upper level init).

Now we get into tuning:  Even if the system is making forward progress, it
might be doing it erratically, so how best do we ensure that the memory
clearing I/O proceeds.

> That is - if we have swap on a separate disk and our command pool is small
> enough, IO to another disk could use the single per-host command under
> memory pressure, and we can fail to get a scsi command in order to write
> to the swap disk. 

Right: a single command reserved per swap device would be sufficient to assure
a steady stream of memory clearing I/O, which is probably sufficient
for most purposes.

> scsi_put_command() re-fills the host->free_list if it is empty, but under
> high (or higher) IO loads, the disk/device that generated the
> scsi_put_command will immediately issue a scsi_get_command for the same
> device.

That's true, but again, it's a system tuning issue.  The optimal thing to do
for SCSI is to issue a new command for a device that just returned one
because we know it has all the resources to hand.
> 
What we do under memory pressure needs to be separated from what we do
ordinarily.

> If all command allocations are failing for a particular device (i.e.
> swap), we will wait a bit (device_blocked and device_busy == 0) and try
> again, we will not retry based on a scsi_put_command(). Even if we did
> retry based on a scsi_put_command, we will can race with the
> scsi_put_command caller.

This is theoretically possible, but unlikely:  all of the allocated commands
must eventually return.  I can't think of any non pathological load scenarios
where we can load up the command queues so completely from userland as to
cause complete starvation of the swap devices...but doubtless somebody will
come up with one.

James

