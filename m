From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 28 Sep 2011 13:53:04 -0400
Message-ID: <20110928175304.GA3985@infradead.org>
References: <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>
 <4E82751C.9050908@kernel.dk>
 <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
 <1317183038.17578.9.camel@dabdike.hansenpartnership.com>
 <4E832A55.30709@kernel.dk>
 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
 <4E832BD2.50409@kernel.dk>
 <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com>
 <1317224616.19034.41.camel@dabdike.hansenpartnership.com>
 <20110928174859.GA21628@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110928174859.GA21628@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 28, 2011 at 01:48:59PM -0400, Vivek Goyal wrote:
> I am wondering if we should retain blk_throtl_exit() in blk_cleanup_queue()
> before lock swap and just move elevator cleanup in blk_release_queue().
> 
> A note to myself, I should probably enhance blk_throtl_exit() to look for any
> queued throttled bio and single their completion with error (-ENODEV) or
> something like that.

The root of this evil is how queue_lock is implemented and (ab)used.
Instead of letting the driver assign a pointer to make the core use
its locks we really need to make the queue_lock a lock embedded directly
into the queue, and drivers may or may not use that lock for their
internal data structures.  For high performance drivers they preferable
should use their own locks as queue_lock is far too contended already
for any high IOPS device.   The same applies to throtteling btw -
instead of overloading an already highly contended lock it really
should have its own.
