From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] sg: O_EXCL and other lock handling
Date: Wed, 6 Nov 2013 07:50:44 -0800
Message-ID: <20131106155044.GA9323@infradead.org>
References: <52718713.7050906@interlog.com>
 <20131031155653.GA16944@infradead.org>
 <5272AD80.90203@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5272AD80.90203@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, vaughan <vaughan.cao@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2013 at 03:20:32PM -0400, Douglas Gilbert wrote:
> Yes, it is being used as a mutex. However looking at
> their semantics (mutex.h versus semaphore.h), a mutex
> takes into account the task owner. If the user space
> wants to pass around a sg file descriptor in a Unix
> domain socket (see TLPI, Kerrisk) I don't see why the
> sg driver should object (and pay the small performance
> hit for each check).

The sg driver won't object.  The lock is taken again and released
during sg_open and sg_release, which are guranteed not to migrate
to a different process during their run time.

> section) but why bother. Give me a simple mutex and
> I'll use it.

mutex_init/mutex_lock/mutex_unlock from <linux/mutex.h>

> Not (usually) in this case. The sdp->sfds list can only
> be expanded by another sg_open(same_dev) but this has
> been excluded by taking down(&sdp->or_sem) prior to that
> call. The sdp->sfds list is only normally decreased by
> sg_release() which is also excluded by down(&sdp->or_sem).

> The abnormal case is device removal (detaching). Now an
> open(same_dev, O_EXCL) may start waiting just after a
> detach but miss the wake up on open_wait. That suggests
> the wake_up(open_wait) in sg_remove() should also
> take the sdp->or_sem semaphore.
> Ah, and if sg_remove() can be called from an interrupt
> context then that takes out using mutexes :-)

I don't think that sg_remove can be called from irq context.
It always is called through the class interface remove_dev
method, which always is called under a lock.

> The two level of locks in sg_remove() is already making me
> uncomfortable, adding the sdp->or_sem semaphore to the
> mix calls for more analysis.

I would suggest to remove the list lock and only use the or_sem
replacement.

> IMO that is a bug in scsi_block_when_processing_errors()
> and the down() is placed lower than it should be in
> sg_open() to account for that bug.

How about we get that fixed first?
