From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] sg: O_EXCL and other lock handling
Date: Thu, 31 Oct 2013 15:20:32 -0400
Message-ID: <5272AD80.90203@interlog.com>
References: <52718713.7050906@interlog.com> <20131031155653.GA16944@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131031155653.GA16944@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, vaughan <vaughan.cao@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 13-10-31 11:56 AM, Christoph Hellwig wrote:
>> +	struct semaphore or_sem;  /* protect co-incident opens and releases */
>
> Seems like this should be a mutex.

Yes, it is being used as a mutex. However looking at
their semantics (mutex.h versus semaphore.h), a mutex
takes into account the task owner. If the user space
wants to pass around a sg file descriptor in a Unix
domain socket (see TLPI, Kerrisk) I don't see why the
sg driver should object (and pay the small performance
hit for each check).

A nasty side effect of a mutex taking into account the
task owner is that it can't be used in interrupt
context. My patch does not try to do that yet (see next
section) but why bother. Give me a simple mutex and
I'll use it.

>> sfds_list_empty(Sg_device *sdp)
>>   {
>>   	unsigned long flags;
>>   	int ret;
>>
>> +	spin_lock_irqsave(&sdp->sfd_lock, flags);
>> +	ret = list_empty(&sdp->sfds);
>> +	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
>>   	return ret;
>
> Protecting just a list_empty check with a local will give you racy
> results.  Seems like you should take the look over the check and the
> resulting action that modifies the list.  That'd also mean replacing the
> wait_event* calls with open coded prepare_wait / finish_wait loops.

Not (usually) in this case. The sdp->sfds list can only
be expanded by another sg_open(same_dev) but this has
been excluded by taking down(&sdp->or_sem) prior to that
call. The sdp->sfds list is only normally decreased by
sg_release() which is also excluded by down(&sdp->or_sem).

The abnormal case is device removal (detaching). Now an
open(same_dev, O_EXCL) may start waiting just after a
detach but miss the wake up on open_wait. That suggests
the wake_up(open_wait) in sg_remove() should also
take the sdp->or_sem semaphore.
Ah, and if sg_remove() can be called from an interrupt
context then that takes out using mutexes :-)

The two level of locks in sg_remove() is already making me
uncomfortable, adding the sdp->or_sem semaphore to the
mix calls for more analysis.

Also note that sdp->detached is only protected by a
volatile type modifier and checks on it are sprinkled
around the code in a rather unscientific way.

As you are no doubt aware, handling the "surprise" device
removal case safely is hard, very hard. And I have tried
to test this, loading up 4 processes with 100 tasks each,
some with asynchronous queueing requests but most hanging
on an open_wait then remove the device. So far I have not
seen a hang. Again, somebody with a big machine and
patience might like to try a scaled up device removal test
to see what breaks.

>> +	down(&sdp->or_sem);
>> +	alone = sfds_list_empty(sdp);
>> +	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE))) {
>> +		retval = -EPERM; /* Don't allow O_EXCL with read only access */
>> +		goto error_out;
>> +	}
>
> Seems like the pure flags check should move to the beginning of the
> function before taking any locks.

As Vaughan pointed out, just prior to that down() is a call
scsi_block_when_processing_errors() for blocking open()s.
That function will do a non-interruptible wait if error
recovery processing is underway. That could take tens of
seconds. If the down() was before that line then a subsequent
sg_open(dev, O_NONBLOCK) would block on a previous down()
for tens of seconds. That is not what an O_NONBLOCK open()
should do.

IMO that is a bug in scsi_block_when_processing_errors()
and the down() is placed lower than it should be in
sg_open() to account for that bug.


PS Most of the O_EXCL locking was designed by Vaughan Cao and
fixes the previous flaky O_EXCL handling (the block layer's
O_EXCL handling is also flaky) and races between sg_open()
and sg_release(). His solution went just a little too far
using read-write semaphores to implement the O_EXCL handling.
This was wrong because you cannot hold a semaphore when
returning to the user space (at least mutex.h documents
that subtle point). My part in this was to revert that
read-write semaphore to the previous wait queue solution for
O_EXCL, promote a few wake_up() calls to the "all" variants
and write some test code. That test code shows Vaughan's
strategy seems to be correct and is faster than the previous
implementation. I'm impressed; it may not be perfect but
is better than is what is in the mainline (released) kernels
today.

Doug Gilbert
