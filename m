From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 6/7 add and use a per-scsi_device queue_lock
Date: 27 Mar 2003 10:09:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048781376.1789.49.camel@mulgrave>
References: <20030324175337.A14957@beaverton.ibm.com>
	<20030324175422.A14996@beaverton.ibm.com>
	<20030324180227.A15047@beaverton.ibm.com>
	<20030324180247.B15047@beaverton.ibm.com>
	<20030324180304.C15047@beaverton.ibm.com>
	<20030324180325.D15047@beaverton.ibm.com>
	<20030324180341.E15047@beaverton.ibm.com>
	<1048627234.2883.156.camel@mulgrave>
	<20030325180133.A1874@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030325180133.A1874@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-03-25 at 20:01, Patrick Mansfield wrote: 
> On Tue, Mar 25, 2003 at 03:20:32PM -0600, James Bottomley wrote:
> > and leads to awful problems
> > for your starved_list: the host_lock is actually protecting the starved
> > list, so the way you currently have it, you have to drop the host lock
> > to acquire the queue_lock to run the block queue.  Unfortunately, doing
> > this could lead to the device being readded when running the queue. 
> > Thus, the queue_next_request can spin removing and adding the device to
> > the starved list---probably working from a copy of the starved list will
> > help with this.
> 
> The above doesn't happen because of the while() check: if anyone gets put
> on or re-added to the starved list, we drop out of the while loop. The
> current code also allows mutiple IO completions to run starved queues in
> parallel (I doubt it helps any, but I have no evidence one way or the
> other).

Well, not necessarily.  Dropping out of the while loop assumes that
host_busy goes below can_queue.  However, if something else is sourcing
requests, it may get in between dropping the host_lock and acquiring the
queue_lock.  In this case, running the block queues would simply re-add
the request and keep host_busy at can_queue, thus we could get into a
loop. 

> > I'd also like to see avoidance of the locking hierarchy where possible. 
> > i.e. in the scsi_request_fn for instance, can we move the actions that
> > need the host_lock outside the queue_lock?
> 
> I tried coding to avoid the lock hierarchy but did not quite make it.

OK.

What about making the host processing in the scsi_request_fn exceptional
(i.e. putting it outside the queue lock after the request has been
dequeued).  That way we'd have to do a queue push back if it was
unacceptable (and get the counter decrements correct)?

> Without a lock hierarchy, (in scsi_request_fn) I have to lock, check for
> resources, increment host_busy or device_busy, and unlock.
> 
> Then, if unable to get a host resource, I have to decrement device_busy.
> 
> For the blk_queue_empty(q) or the "if !(req)" cases, I have to decrement
> both device_busy and host_busy.
> 
> I thought (past tense) moving up blk_queue_empty(q) and the "if (!req)"
> checks would cause problems by not decrementing device_blocked and
> host_blocked, and that there is no way to handle host_busy being
> decremented back to 0 there.
> 
> On further thought, those checks can be moved up before checking any of
> the sdev or shost values (if blk_queue_empty, we don't care about
> device_blocked or host_blocked). Agree? If so that issue goes away.

Hmm, moving them should be OK.  The !req case probably wants to be
treated the same as starvation (except you have to beware the
device_busy == 0 && host_busy == 0 case where the queue needs plugging).

> There is a still an issue with the single_lun checks, where we allow
> continued IO to a device that has device_busy set, but not for a device
> that has device_busy == 0 and target_busy != 0; so we have to get the
> lock for device_busy, and the lock for target busy. I could keep the lock
> hierarchy only in single_lun cases, or add another target lock that would
> be part of a lock hierarchy.

That's probably OK, since these checks are now exceptional (we only get
into the logic if the flag is set).

> Should I add a target lock? 

Not unless you can provide an *extremely* good justification for it.

> Excluding the single_lun case, do you think it's worthwhile to avoid the
> lock hierarchy?

As long as it doesn't contort the code, yes.  Lock hierarchies are
accidents waiting to happen, so taking reasonable pains to avoid them is
good.

> Related note: the new workq code in blk probably messes up our device_blocked
> and host_blocked handling, since there is now a 3 millisecond timeout (see
> blk_plug_queue). device_blocked and host_blocked should really be use some
> type of timeout mechanism. Maybe a new blk_plug_timeout(). This might also
> allow us to get rid of the one remaining recursive call into
> scsi_request_fn.

Since we never gave any guarantees other than "eventually" about the
restart time, I don't necessarily think it does.

James


