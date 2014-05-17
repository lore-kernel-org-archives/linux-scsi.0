From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] kref: warn on uninitialized kref
Date: Sat, 17 May 2014 17:14:13 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1405171646290.32012@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405170647430.15837@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1405170650440.15837@file01.intranet.prod.int.rdu2.redhat.com> <20140517110454.GA1939@mguzik.redhat.com> <alpine.LRH.2.02.1405170836070.15837@file01.intranet.prod.int.rdu2.redhat.com>
 <53776918.7040402@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53776918.7040402@acm.org>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mateusz Guzik <mguzik@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Sat, 17 May 2014, Bart Van Assche wrote:

> On 05/17/14 14:38, Mikulas Patocka wrote:
> > I found a memory leak in iSCSI target that was caused by kref initialized
> > to zero (the memory object was allocated with kzalloc, kref_init was not
> > called and kref_put_spinlock_irqsave was called which changed "0" to "-1"
> > and didn't free the object).
> > 
> > Similar bugs may exist in other kernel areas, so I submit this patch that
> > adds a check to kref.h. If the value is zero or negative, we can assume
> > that it is uninitialized and we warn about it.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  include/linux/kref.h |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: linux-3.15-rc5/include/linux/kref.h
> > ===================================================================
> > --- linux-3.15-rc5.orig/include/linux/kref.h	2014-05-16 19:00:18.000000000 +0200
> > +++ linux-3.15-rc5/include/linux/kref.h	2014-05-17 13:19:31.000000000 +0200
> > @@ -69,7 +69,7 @@ static inline int kref_sub(struct kref *
> >  	     void (*release)(struct kref *kref))
> >  {
> >  	WARN_ON(release == NULL);
> > -
> > +	WARN_ON_ONCE(atomic_read(&kref->refcount) < (int)count);
> >  	if (atomic_sub_and_test((int) count, &kref->refcount)) {
> >  		release(kref);
> >  		return 1;
> > @@ -119,6 +119,7 @@ static inline int kref_put_spinlock_irqs
> >  	unsigned long flags;
> >  
> >  	WARN_ON(release == NULL);
> > +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
> >  	if (atomic_add_unless(&kref->refcount, -1, 1))
> >  		return 0;
> >  	spin_lock_irqsave(lock, flags);
> > @@ -136,6 +137,7 @@ static inline int kref_put_mutex(struct 
> >  				 struct mutex *lock)
> >  {
> >  	WARN_ON(release == NULL);
> > +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
> >  	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
> >  		mutex_lock(lock);
> >  		if (unlikely(!atomic_dec_and_test(&kref->refcount))) {
> 
> This patch adds two conditional branches and one atomic read to
> kref_sub(). What is the performance impact of this patch on kernel code
> that uses kref_put() in the hot path ? Has it been considered to enable
> the newly added code only if a CONFIG_DEBUG_* macro has been set ?
> 
> Bart.

The atomic modification takes several tens of ticks, the atomic read and 
compare is just one tick. I don't exepct any performance problem with 
this.

BTW. if we talk about performance - what about replacing:

	if (atomic_dec_and_test(&variable)) {
		... release(object);
	}

with this:

	if (atomic_read(&variable) == 1 || atomic_dec_and_test(&variable)) {
		barrier();
		... release(object);
	}

It avoids the heavy atomic instruction if there is just one reference. Is 
there any problem with this? At least on x86 we could do this always 
(there is no read reordering in hardware, so barrier() is sufficient to 
prevent reads from being reordered with atomic_read). On the architectures 
that reorder reads, we could do it only if the release method doesn't 
contain any reads of the object being released.

Mikulas
