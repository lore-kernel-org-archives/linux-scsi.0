From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Thu, 6 Mar 2003 09:41:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030306094156.A23231@beaverton.ibm.com>
References: <20030228111924.A32018@beaverton.ibm.com> <1046833360.2757.43.camel@mulgrave> <20030305104320.A14722@beaverton.ibm.com> <1046966278.1746.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1046966278.1746.12.camel@mulgrave>; from James.Bottomley@steeleye.com on Thu, Mar 06, 2003 at 09:57:55AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Mar 06, 2003 at 09:57:55AM -0600, James Bottomley wrote:
> On Wed, 2003-03-05 at 12:43, Patrick Mansfield wrote: 
> > On Wed, Mar 05, 2003 at 04:02:38AM +0100, James Bottomley wrote:

> > Note that if we go over can_queue performance can suffer no matter what we
> > do in scsi core. If the bandwidth or a limit of the adapter is reached, no
> > changes in scsi core can fix that, all we can do is make sure each
> > scsi_device can do some IO. So, we are trying to figure out a good way to
> > make sure all devices can do IO when can_queue is hit.
> 
> So what you're basically trying to do is to ensure restart fairness for
> the host starvation case. 

Well more specifically, that each device can do an equal amount of IO - so
not just restart fairness, but IO's/second fairness.

> Since the driver can't service any requests in this case, I do think the
> correct thing to do is to leave the requests in the block queue in the
> hope that the elevator has longer to merge them, so we ultimately get
> fewer, larger requests. 

> > Going to a block request queue now might be hard - it would likely need a
> > further separation of scsi_device and scsi_host within scsi core (in the
> > request and prep functions, and in the IO completion path).
> 
> But we already have a per device block request queue, it's the block queue
> associated with the current device which we already use.

Yes - but the host could be represented as another request queue.

> > With multiple starved devices with IO requests pending for all of them,
> > the algorithm we have now (assuming it worked right) can unfairly allow
> > each scsi_device to have as many commands outstanding as it did when we
> > hit the starved state.
> > 
> > The current algorithm could be fixed and throttling added.
> 
> How about a different fix: instead of a queue of pending commands, a queue (or
> really an ordered list) of devices to restart.  Add to the tail of this list
> when we're over the host can_queue limit, but restart from the head.  Leave
> in place the current prep one command extra per device, that way we just
> do a __blk_run_queue() in order from this list.  It replaces the
> some_device_starved and device_starved flags, will keep the current
> elevator behaviour and should ensure reasonable fairness.
> 
> I believe this should ensure for equal I/O pressure to two devices that
> they eventually get half the available slots each when we run into
> the can_queue limit, which looks desirable.
> 
> James

That is close to what the current algorithm is trying to do.

But ... my logic was off in assuming that this approach is unfair
(thinking that the device that sent IO before hitting any starved case
would *always* have more requests outstanding than any other devices that
come in later).

Let me see what I can code up along these lines.

Such a solution complicates moving to a per-device queue lock - we need a
per-host lock while pulling off the restart list, and we need a
per-queue-lock prior to calling __blk_run_queue(); but when starving in
the scsi_request_fn(), we have a per-queue-lock and need the per-host lock
to add to the restart list. So we have to allow dropping a lock in both
cases without leading to a hung requeset queue.

Thanks.

-- Patrick Mansfield
