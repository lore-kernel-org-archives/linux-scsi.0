From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 28 Sep 2011 13:48:59 -0400
Message-ID: <20110928174859.GA21628@redhat.com>
References: <20110928004722.GA27421@kernel.dk>
 <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>
 <4E82751C.9050908@kernel.dk>
 <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
 <1317183038.17578.9.camel@dabdike.hansenpartnership.com>
 <4E832A55.30709@kernel.dk>
 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
 <4E832BD2.50409@kernel.dk>
 <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com>
 <1317224616.19034.41.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1317224616.19034.41.camel@dabdike.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 28, 2011 at 10:43:36AM -0500, James Bottomley wrote:
> On Wed, 2011-09-28 at 08:22 -0700, Linus Torvalds wrote:
> > On Wed, Sep 28, 2011 at 7:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > >
> > >  /*
> > > - * Note: If a driver supplied the queue lock, it should not zap that lock
> > > - * unexpectedly as some queue cleanup components like elevator_exit() and
> > > - * blk_throtl_exit() need queue lock.
> > > + * Note: If a driver supplied the queue lock, it is disconnected
> > > + * by this function. The actual state of the lock doesn't matter
> > > + * here as the request_queue isn't accessible after this point
> > > + * (QUEUE_FLAG_DEAD is set) and no other requests will be queued.
> > >  */
> > 
> > So quite frankly, I just don't believe in that comment.
> > 
> > If no more requests will be queued or completed, then the queue lock
> > is irrelevant and should not be changed.
> 
> That was my original argument for my patch.  I lost it because you can
> still hold a queue reference in the sysfs code for block, which means
> that the put in blk_cleanup_queue() won't be the final one and you'll
> get a use after free of the lock when the sysfs directory is exited
> because we take the lock again as we destroy the elevator.
> 
> > More importantly, if no more requests are queued or completed after
> > blk_cleanup_queue(), then we wouldn't have had the bug that we clearly
> > had with the elevator accesses, now would we? So the comment seems to
> > be obviously bogus and wrong.
> 
> So this I agree with.  blk_cleanup_queue() prevents any new access to
> the queue, but we still have the old reference holders to contend with.
> They can submit requests, although we try to error them again with the
> queue guards check.
> 
> > I pulled this, but I think the "just move the teardown" would have
> > been the safer option. What  happens if a request completes on another
> > CPU just as we are changing locks, and we lock one lock and then
> > unlock another?!
> 
> The only code for which this could be true is code where we use the
> block supplied lock, so effectively it never changes.

> The drivers which supply their own lock are supposed to have already
> ensured that the queue is unused.

Hi James,

For my education purposes, how will driver come to know that queue is
unused? Does it happen by checking if any requsts are queued or not? If
yes, we might run into issues with throttling logic.

For example, if some bio have been throttled and are queued in some data
structures on queue.  In that case driver does not even know that some bios
are queued and will be submitted later. Now if driver calls blk_cleanup_queue()
it might happen that throttling related worker is already queue lock and
trying to do some housekeeping or trying to dispatch bio etc. Now if queue
lock is swapped, it will just cause all the kind of issues.

I am wondering if we should retain blk_throtl_exit() in blk_cleanup_queue()
before lock swap and just move elevator cleanup in blk_release_queue().

A note to myself, I should probably enhance blk_throtl_exit() to look for any
queued throttled bio and single their completion with error (-ENODEV) or
something like that.

Thanks
Vivek
