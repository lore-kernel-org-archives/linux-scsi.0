From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 28 Sep 2011 10:43:36 -0500
Message-ID: <1317224616.19034.41.camel@dabdike.hansenpartnership.com>
References: <201109221318.p8MDIXPP020015@pentland.suse.de>
	 <20110928004722.GA27421@kernel.dk>
	 <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>
	 <4E82751C.9050908@kernel.dk>
	 <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
	 <1317183038.17578.9.camel@dabdike.hansenpartnership.com>
	 <4E832A55.30709@kernel.dk>
	 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
	 <4E832BD2.50409@kernel.dk>
	 <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-09-28 at 08:22 -0700, Linus Torvalds wrote:
> On Wed, Sep 28, 2011 at 7:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >
> >  /*
> > - * Note: If a driver supplied the queue lock, it should not zap that lock
> > - * unexpectedly as some queue cleanup components like elevator_exit() and
> > - * blk_throtl_exit() need queue lock.
> > + * Note: If a driver supplied the queue lock, it is disconnected
> > + * by this function. The actual state of the lock doesn't matter
> > + * here as the request_queue isn't accessible after this point
> > + * (QUEUE_FLAG_DEAD is set) and no other requests will be queued.
> >  */
> 
> So quite frankly, I just don't believe in that comment.
> 
> If no more requests will be queued or completed, then the queue lock
> is irrelevant and should not be changed.

That was my original argument for my patch.  I lost it because you can
still hold a queue reference in the sysfs code for block, which means
that the put in blk_cleanup_queue() won't be the final one and you'll
get a use after free of the lock when the sysfs directory is exited
because we take the lock again as we destroy the elevator.

> More importantly, if no more requests are queued or completed after
> blk_cleanup_queue(), then we wouldn't have had the bug that we clearly
> had with the elevator accesses, now would we? So the comment seems to
> be obviously bogus and wrong.

So this I agree with.  blk_cleanup_queue() prevents any new access to
the queue, but we still have the old reference holders to contend with.
They can submit requests, although we try to error them again with the
queue guards check.

> I pulled this, but I think the "just move the teardown" would have
> been the safer option. What  happens if a request completes on another
> CPU just as we are changing locks, and we lock one lock and then
> unlock another?!

The only code for which this could be true is code where we use the
block supplied lock, so effectively it never changes.  The drivers which
supply their own lock are supposed to have already ensured that the
queue is unused.  I don't really believe this given the sysfs example
above, but this fix is no worse than the use after free that would have
resulted with the previous code.

James
