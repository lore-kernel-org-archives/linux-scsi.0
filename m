From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] bsg: call idr_pre_get() outside the lock.
Date: Thu, 16 Sep 2010 22:55:30 -0400
Message-ID: <1284692130.26423.53.camel@mulgrave.site>
References: <m2eidda6bq.fsf@elisp.net>
	 <20100916163735.ed8dbb51.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab0IQCzm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 22:55:42 -0400
In-Reply-To: <20100916163735.ed8dbb51.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naohiro Aota <naota@elisp.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>, linux-scsi@vger.kernel.org

On Thu, 2010-09-16 at 16:37 -0700, Andrew Morton wrote:
> On Wed, 01 Sep 2010 23:26:01 +0900
> Naohiro Aota <naota@elisp.net> wrote:
> 
> > The idr_pre_get() kernel-doc says "This function should be called
> > prior to locking and calling the idr_get_new* functions.", but the
> > idr_pre_get() calling in bsg_register_queue() is put inside
> > mutex_lock(). Let's fix it.
> > 
> 
> The idr_pre_get() kerneldoc is wrong.  Or at least, misleading.
> 
> The way this all works is that we precharge the tree via idr_pre_get()
> and we do this outside locks so we can use GFP_KERNEL.  Then we take
> the lock (a spinlock!) and then try to add an element to the tree,
> which will consume objects from the pool which was prefilled by
> idr_pre_get().
> 
> There's an obvious race here where someone else can get in and steal
> objects from the prefilled pool.  We can fix that with a retry loop:
> 
> 
> again:
> 	if (idr_pre_get(..., GFP_KERNEL) == NULL)
> 		return -ENOMEM;		/* We're really out-of-memory */
> 	spin_lock(lock);
> 	if (idr_get_new(...) == -EAGAIN) {
> 		spin_unlock(lock);
> 		goto again;		/* Someone stole our preallocation! */
> 	}
> 	...
> 
> this way we avoid the false -ENOMEM which the race would have caused. 
> We only declare -ENOMEM when we're REALLY out of memory.
> 
> 
> But none of this is needed when a sleeping lock is used (as long as the
> sleeping lock isn't taken on the the VM pageout path, of course).  In
> that case we can use the sleeping lock to prevent the above race.
> 
> > diff --git a/block/bsg.c b/block/bsg.c
> > index 82d5882..5fd8dd1 100644
> > --- a/block/bsg.c
> > +++ b/block/bsg.c
> > @@ -1010,13 +1010,11 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
> >  	bcd = &q->bsg_dev;
> >  	memset(bcd, 0, sizeof(*bcd));
> >  
> > -	mutex_lock(&bsg_mutex);
> > -
> >  	ret = idr_pre_get(&bsg_minor_idr, GFP_KERNEL);
> > -	if (!ret) {
> > -		ret = -ENOMEM;
> > -		goto unlock;
> > -	}
> > +	if (!ret)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&bsg_mutex);
> >  
> >  	ret = idr_get_new(&bsg_minor_idr, bcd, &minor);
> >  	if (ret < 0)
> 
> So the old code was OK.
> 
> The new code, however, is not OK because it is vulnerable to the above
> race wherein another CPU or thread comes in and steals all of this
> thread's preallocation.

Hmm, you're right ... I've dropped the patch.

James


