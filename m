From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue
	reached
Date: 06 Mar 2003 09:57:55 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1046966278.1746.12.camel@mulgrave>
References: <20030228111924.A32018@beaverton.ibm.com>
	<1046833360.2757.43.camel@mulgrave>
	<20030305104320.A14722@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030305104320.A14722@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-03-05 at 12:43, Patrick Mansfield wrote: 
> On Wed, Mar 05, 2003 at 04:02:38AM +0100, James Bottomley wrote:
> > 
> > Could you elaborate on why a pending_queue (which duplicates some of the
> > block layer queueing functionality that we use) is a good idea.
> 
> > Under the current scheme, we prep one command beyond the can_queue limit
> > and leave it in the block queue, so the returning commands can restart
> > with a fully prepped command but we still leave all the others in the
> > block queue for potential elevator merging. 
> 
> Note that if we go over can_queue performance can suffer no matter what we
> do in scsi core. If the bandwidth or a limit of the adapter is reached, no
> changes in scsi core can fix that, all we can do is make sure each
> scsi_device can do some IO. So, we are trying to figure out a good way to
> make sure all devices can do IO when can_queue is hit.

So what you're basically trying to do is to ensure restart fairness for
the host starvation case. 

Since the driver can't service any requests in this case, I do think the
correct thing to do is to leave the requests in the block queue in the
hope that the elevator has longer to merge them, so we ultimately get
fewer, larger requests. 

> (Not sure if you implied the following change) The host pending_cmd queue
> could be replaced in the future with a (block) request queue for each
> LLDD, without much change in function - we would still have to pull
> requests off of the scsi_device queue before putting them into any LLDD
> request queue, so we still would not be able to leave requests in the
> scsi_device queue.  We could try to "sort" the LLDD queue so we have a mix
> of scsi_devices represented, but that could lead to other issues.
> 
> Going to a block request queue now might be hard - it would likely need a
> further separation of scsi_device and scsi_host within scsi core (in the
> request and prep functions, and in the IO completion path).

But we already have a per device block request queue, it's the block queue
associated with the current device which we already use.

> With multiple starved devices with IO requests pending for all of them,
> the algorithm we have now (assuming it worked right) can unfairly allow
> each scsi_device to have as many commands outstanding as it did when we
> hit the starved state.
> 
> The current algorithm could be fixed and throttling added.

How about a different fix: instead of a queue of pending commands, a queue (or
really an ordered list) of devices to restart.  Add to the tail of this list
when we're over the host can_queue limit, but restart from the head.  Leave
in place the current prep one command extra per device, that way we just
do a __blk_run_queue() in order from this list.  It replaces the
some_device_starved and device_starved flags, will keep the current
elevator behaviour and should ensure reasonable fairness.

I believe this should ensure for equal I/O pressure to two devices that
they eventually get half the available slots each when we run into
the can_queue limit, which looks desirable.

James


