From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 28 Sep 2011 18:34:49 -0400
Message-ID: <20110928223449.GD21628@redhat.com>
References: <1317183038.17578.9.camel@dabdike.hansenpartnership.com>
 <4E832A55.30709@kernel.dk>
 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
 <4E832BD2.50409@kernel.dk>
 <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com>
 <1317224616.19034.41.camel@dabdike.hansenpartnership.com>
 <20110928174859.GA21628@redhat.com>
 <20110928175304.GA3985@infradead.org>
 <20110928180905.GB21628@redhat.com>
 <20110928181649.GA27441@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110928181649.GA27441@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 28, 2011 at 02:16:49PM -0400, Christoph Hellwig wrote:
> On Wed, Sep 28, 2011 at 02:09:05PM -0400, Vivek Goyal wrote:
> > I had thought of implementing a separate lock for throttling. Then I
> > noticed few operations like checking for queue flags where I would
> > be required to hold queue locks.
> 
> Can you do a writeup of these issues?  E.g. if the flags are throtteling
> specific we can move them to a separate flags field, if not we can
> see if we can make them atomic or similar.

Sure. I am going through the code and trying to list down some of the
dependencies.

But before that I would say that tyring to optimize the throttling code
to reduce the queue lock contention should be last on the priority list.
The simple reason being that in common case it does not incur any locking
cost. One needs to have IO cgroup configured and needs to have some
throttling rules put in place only then queue lock cost will come into
picture. And for most of the people, I don't think that's the common
case.

Now coming back to question of dependencies. We take some services from
request queue which needs to happen under queue lock.

- Looks like in current code I am only accessing QUEUE_FLAG_DEAD. I see
  that flag is not synchronized using queue lock. So it probably is not
  a concern.

- I am using tracing functionality. blk_add_trace_msg(). I guess it is
  not required to take queue lock for this. But I am not sure.

- I am accessing q->backing_dev_info to get to associated devices's
  major and minor number.

That's it I guess. That's what a quick look tells me. So looks like
it is not too hard to convert existing blk throttle code to use its
own lock. That will also get rid of dependency on queue lock and
in turn uncertainity associated with queue lock being valid (if
driver provided the lock).

Thanks
Vivek
