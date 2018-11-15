From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: kobject lifetime issues in blk-mq
Date: Wed, 14 Nov 2018 16:56:58 -0800
Message-ID: <20181115005658.GA24847@kroah.com>
References: <20181109203518.GA7130@roeck-us.net>
 <20181112092051.GA391@ming.t460p>
 <20181112094406.GB391@ming.t460p>
 <20181112164848.GA1790@roeck-us.net>
 <20181112200236.GA4415@kroah.com>
 <20181113002226.GA4455@ming.t460p>
 <20181113004124.GC4455@ming.t460p>
 <20181114110827.GA31430@ming.t460p>
 <20181114151410.GB26378@kroah.com>
 <20181115003616.GA32603@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181115003616.GA32603@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, Peter Zijlstra <peterz@infradead.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 15, 2018 at 08:36:17AM +0800, Ming Lei wrote:
> > So even if you think the kernel is not going to do this, remember, you
> > have no control over it.  Reference counted objects are done this way
> > for a reason, you really do not know who has a reference and you really
> > do not care.
> > 
> > You are just papering over the real issue here, see my previous email
> > for how to start working on resolving it.
> 
> IMO, there isn't real issue, and the issue is actually in 'delay release'.

Nope, sorry, that is not true.

> Please look at the code in block/blk-mq-sysfs.c, both q->mq_kobj and all
> ctx->kobj share same lifetime with q->kobj, we even don't call get/put
> on q->mq_kobj & all ctx->kobj, and all are simply released in q->kobj's
> release handler.

How do you "know" you are keeping those lifetimes in sync?  The joy of a
kobject is that _ANYTHING_ can grab a reference to your object without
you knowing about it.  That includes userspace programs.  Yes, sysfs is
now much better and it trys to release that reference "quickly" when it
determines you are trying to delete a kobject, but it's not perfict,
there are still races there.

And that is what the delay release code is showing you.  It is showing
you that you "think" your reference counting is wrong, but it is not.
It is showing you that if someone else grabs a reference, you are not
correctly cleaning up for yourself.

Never think that you really know the lifetime of a kobject, once you
realize that your code gets simpler and you can then just "trust" that
the kernel will do the right thing no matter what.

Because really, you are using a kobject because you want that correct
reference counting logic.  By ignoring that logic, you are ignoring the
reason to be using that object at all.  If you don't need reference
counting, then don't use it at all.

And if you need sysfs files, then you need to use the kobject and then
you need to handle it properly, because again, you do NOT have full
control over the lifetime of your object.  That's the basis for
reference counting in the firstplace.

So this code is broken without me evening having to look at it, please
fix it to handle release properly.  Again, the kernel tried to tell you
this, but you hacked around the kernel core to remove that warning
incorrectly.  Please go read the kobject documentation again for even
more details about this than what I said here.

thanks,

greg k-h
