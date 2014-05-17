From: Mateusz Guzik <mguzik@redhat.com>
Subject: Re: [PATCH] kref: warn on uninitialized kref
Date: Sat, 17 May 2014 13:04:55 +0200
Message-ID: <20140517110454.GA1939@mguzik.redhat.com>
References: <alpine.LRH.2.02.1405170647430.15837@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1405170650440.15837@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1405170650440.15837@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, May 17, 2014 at 06:53:17AM -0400, Mikulas Patocka wrote:
> I found a memory leak in iSCSI target that was caused by kref initialized
> to zero (the memory object was allocated with kzalloc, kref_init was not
> called and kref_put_spinlock_irqsave was called which changed "0" to "-1"
> and didn't free the object).
> 
> Similar bugs may exist in other kernel areas, so I submit this patch that
> adds a check to kref.h. If the value is zero or negative, we can assume
> that it is uninitialized and we warn about it.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  include/linux/kref.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-3.15-rc5/include/linux/kref.h
> ===================================================================
> --- linux-3.15-rc5.orig/include/linux/kref.h	2013-07-02 22:23:38.000000000 +0200
> +++ linux-3.15-rc5/include/linux/kref.h	2014-05-16 18:56:18.000000000 +0200
> @@ -69,7 +69,7 @@ static inline int kref_sub(struct kref *
>  	     void (*release)(struct kref *kref))
>  {
>  	WARN_ON(release == NULL);
> -
> +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
>  	if (atomic_sub_and_test((int) count, &kref->refcount)) {
>  		release(kref);
>  		return 1;
> @@ -119,6 +119,7 @@ static inline int kref_put_spinlock_irqs
>  	unsigned long flags;
>  
>  	WARN_ON(release == NULL);
> +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
>  	if (atomic_add_unless(&kref->refcount, -1, 1))
>  		return 0;
>  	spin_lock_irqsave(lock, flags);
> @@ -136,6 +137,7 @@ static inline int kref_put_mutex(struct 
>  				 struct mutex *lock)
>  {
>  	WARN_ON(release == NULL);
> +	WARN_ON_ONCE(atomic_read(&kref->refcount) <= 0);
>  	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
>  		mutex_lock(lock);
>  		if (unlikely(!atomic_dec_and_test(&kref->refcount))) {

This has a side effect of detecting some overputs, which is nice.

However, could be made better if kref_sub checked that refs you want to
take don't put the count below 0.

i.e.
WARN_ON(count > atomic_read(&kref->refcount));

this also detects your original problem.

-- 
Mateusz Guzik
