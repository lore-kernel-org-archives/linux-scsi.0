From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 6/7 add and use a per-scsi_device queue_lock
Date: Tue, 25 Mar 2003 18:01:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030325180133.A1874@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <20030324180325.D15047@beaverton.ibm.com> <20030324180341.E15047@beaverton.ibm.com> <1048627234.2883.156.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048627234.2883.156.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Mar 25, 2003 at 03:20:32PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Mar 25, 2003 at 03:20:32PM -0600, James Bottomley wrote:
> On Mon, 2003-03-24 at 20:03, Patrick Mansfield wrote:
> > Add and use a per scsi_device queue_lock.
> 
> In doing this, you're introducing a locking heirarchy, which would need
> to be documented.  If you need both the host and queue locks, which do
> you take first?  The code implies that it's queue_lock and then
> host_lock, which is a bit counter intuitive 

scsi_request_fn is called with the queue_lock already held, so I decided
to get queue_lock first, rather than unlocking queue_lock followed by
locking it again later.

> and leads to awful problems
> for your starved_list: the host_lock is actually protecting the starved
> list, so the way you currently have it, you have to drop the host lock
> to acquire the queue_lock to run the block queue.  Unfortunately, doing
> this could lead to the device being readded when running the queue. 
> Thus, the queue_next_request can spin removing and adding the device to
> the starved list---probably working from a copy of the starved list will
> help with this.

The above doesn't happen because of the while() check: if anyone gets put
on or re-added to the starved list, we drop out of the while loop. The
current code also allows mutiple IO completions to run starved queues in
parallel (I doubt it helps any, but I have no evidence one way or the
other).

> I'd also like to see avoidance of the locking hierarchy where possible. 
> i.e. in the scsi_request_fn for instance, can we move the actions that
> need the host_lock outside the queue_lock?

I tried coding to avoid the lock hierarchy but did not quite make it.

Without a lock hierarchy, (in scsi_request_fn) I have to lock, check for
resources, increment host_busy or device_busy, and unlock.

Then, if unable to get a host resource, I have to decrement device_busy.

For the blk_queue_empty(q) or the "if !(req)" cases, I have to decrement
both device_busy and host_busy.

I thought (past tense) moving up blk_queue_empty(q) and the "if (!req)"
checks would cause problems by not decrementing device_blocked and
host_blocked, and that there is no way to handle host_busy being
decremented back to 0 there.

On further thought, those checks can be moved up before checking any of
the sdev or shost values (if blk_queue_empty, we don't care about
device_blocked or host_blocked). Agree? If so that issue goes away.

There is a still an issue with the single_lun checks, where we allow
continued IO to a device that has device_busy set, but not for a device
that has device_busy == 0 and target_busy != 0; so we have to get the
lock for device_busy, and the lock for target busy. I could keep the lock
hierarchy only in single_lun cases, or add another target lock that would
be part of a lock hierarchy.

Should I add a target lock? 

Excluding the single_lun case, do you think it's worthwhile to avoid the
lock hierarchy?

Related note: the new workq code in blk probably messes up our device_blocked
and host_blocked handling, since there is now a 3 millisecond timeout (see
blk_plug_queue). device_blocked and host_blocked should really be use some
type of timeout mechanism. Maybe a new blk_plug_timeout(). This might also
allow us to get rid of the one remaining recursive call into
scsi_request_fn.

-- Patrick Mansfield
