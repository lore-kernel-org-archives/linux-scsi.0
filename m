From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 6/7 add and use a per-scsi_device queue_lock
Date: Thu, 27 Mar 2003 16:30:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030327163047.A14782@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <20030324180325.D15047@beaverton.ibm.com> <20030324180341.E15047@beaverton.ibm.com> <1048627234.2883.156.camel@mulgrave> <20030325180133.A1874@beaverton.ibm.com> <1048781376.1789.49.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048781376.1789.49.camel@mulgrave>; from James.Bottomley@SteelEye.com on Thu, Mar 27, 2003 at 10:09:34AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Mar 27, 2003 at 10:09:34AM -0600, James Bottomley wrote:
> On Tue, 2003-03-25 at 20:01, Patrick Mansfield wrote: 

> > The above doesn't happen because of the while() check: if anyone gets put
> > on or re-added to the starved list, we drop out of the while loop. The
> > current code also allows mutiple IO completions to run starved queues in
> > parallel (I doubt it helps any, but I have no evidence one way or the
> > other).
> 
> Well, not necessarily.  Dropping out of the while loop assumes that
> host_busy goes below can_queue.  However, if something else is sourcing

(Assume you meant hits can_queue.)

> requests, it may get in between dropping the host_lock and acquiring the
> queue_lock.  In this case, running the block queues would simply re-add
> the request and keep host_busy at can_queue, thus we could get into a
> loop. 

I don't see how new requests can cause a loop there, since a new request
will increment host_busy.

Or do you mean new IO can prevent other IO? It's possible for a new IO
(iff 1 request is sent) sneaking in and preventing a starved queue from
running (even with a list_splice algorithm).

Or do you mean the following case?

An IO completion with highly unlikely synchronization could lead to
a loop, for example:

       cpu1                                   cpu2

t1:

       in scsi_queue_next_request
       pulled sdev off starved
       list, called __blk_run_queue,
       one IO was sent, sdev was put
       back on starved_list

t2:
                                             got host_lock, decremented
					     host_busy

t3:
       waits for host_lock just
       at the end of the while loop

                                             releases host_lock

       go to t1

					     calls scsi_queue_next_request
					     and generally does nothing
					     since cpu1 ran the queue(s)

					     go to t2

It is probably impossible to keep the above syncronization, I don't know
if the irqs will route to another cpu in such a synchronized fashion (use
cpu1, but then use cpu2 for other interrupts from the same adapter).

Using list_splice (or somehow limiting it to one iteration accross all
sdev's) would prevent the above from occuring.

> > > I'd also like to see avoidance of the locking hierarchy where possible. 
> > > i.e. in the scsi_request_fn for instance, can we move the actions that
> > > need the host_lock outside the queue_lock?
> > 
> > I tried coding to avoid the lock hierarchy but did not quite make it.
> 
> OK.
> 
> What about making the host processing in the scsi_request_fn exceptional
> (i.e. putting it outside the queue lock after the request has been
> dequeued).  That way we'd have to do a queue push back if it was
> unacceptable (and get the counter decrements correct)?

I missed the dequeueing step.

> Hmm, moving them should be OK.  The !req case probably wants to be
> treated the same as starvation (except you have to beware the
> device_busy == 0 && host_busy == 0 case where the queue needs plugging).
> 

OK, I'll try to move those up, and do host locking/checking after the
blkdev_dequeue_request, and then push req back on the queue if the host
can't queue.

> > There is a still an issue with the single_lun checks, where we allow
> > continued IO to a device that has device_busy set, but not for a device
> > that has device_busy == 0 and target_busy != 0; so we have to get the
> > lock for device_busy, and the lock for target busy. I could keep the lock
> > hierarchy only in single_lun cases, or add another target lock that would
> > be part of a lock hierarchy.
> 
> That's probably OK, since these checks are now exceptional (we only get
> into the logic if the flag is set).

OK - so I will keep the lock hierarchy for single_lun.

> > Should I add a target lock? 
> 
> Not unless you can provide an *extremely* good justification for it.

Good, no target lock.

> > Related note: the new workq code in blk probably messes up our device_blocked
> > and host_blocked handling, since there is now a 3 millisecond timeout (see
> > blk_plug_queue). device_blocked and host_blocked should really be use some
> > type of timeout mechanism. Maybe a new blk_plug_timeout(). This might also
> > allow us to get rid of the one remaining recursive call into
> > scsi_request_fn.
> 
> Since we never gave any guarantees other than "eventually" about the
> restart time, I don't necessarily think it does.

It won't fail but we will quickly retry IO for a host busy or queue full
(when host_busy or device_busy == 0).

-- Patrick Mansfield
