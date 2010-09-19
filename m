From: Naohiro Aota <naota@elisp.net>
Subject: Re: [PATCH] bsg: call idr_pre_get() outside the lock.
Date: Sun, 19 Sep 2010 12:11:38 +0900
Message-ID: <87fwx6v34l.fsf@elisp.net>
References: <m2eidda6bq.fsf@elisp.net>
	<20100916163735.ed8dbb51.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100916163735.ed8dbb51.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 16 Sep 2010 16:37:35 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 01 Sep 2010 23:26:01 +0900
> Naohiro Aota <naota@elisp.net> wrote:
>
>> The idr_pre_get() kernel-doc says "This function should be called
>> prior to locking and calling the idr_get_new* functions.", but the
>> idr_pre_get() calling in bsg_register_queue() is put inside
>> mutex_lock(). Let's fix it.
>> 
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
>> diff --git a/block/bsg.c b/block/bsg.c
>> index 82d5882..5fd8dd1 100644
>> --- a/block/bsg.c
>> +++ b/block/bsg.c
>> @@ -1010,13 +1010,11 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
>>  	bcd = &q->bsg_dev;
>>  	memset(bcd, 0, sizeof(*bcd));
>>  
>> -	mutex_lock(&bsg_mutex);
>> -
>>  	ret = idr_pre_get(&bsg_minor_idr, GFP_KERNEL);
>> -	if (!ret) {
>> -		ret = -ENOMEM;
>> -		goto unlock;
>> -	}
>> +	if (!ret)
>> +		return -ENOMEM;
>> +
>> +	mutex_lock(&bsg_mutex);
>>  
>>  	ret = idr_get_new(&bsg_minor_idr, bcd, &minor);
>>  	if (ret < 0)
>
> So the old code was OK.
>
> The new code, however, is not OK because it is vulnerable to the above
> race wherein another CPU or thread comes in and steals all of this
> thread's preallocation.

I see. Thank you for your comment.

> The idr_pre_get() kerneldoc is wrong.  Or at least, misleading.

Then we can fix the kerneldoc like this?

----
>From 707ec72b10950ae123f955308f4f1dc32d7a77be Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naota@elisp.net>
Date: Sun, 19 Sep 2010 08:33:01 +0900
Subject: [PATCH] idr: Fix idr_pre_get() realated description about locking

Despite the idr_pre_get() kernel-doc, there is some case you can call
idr_pre_get() in lock regions. This patch add descriprion for such
cases.

See also: http://lkml.org/lkml/2010/9/16/462

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 lib/idr.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 5e0966b..0f97611 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -110,9 +110,10 @@ static void idr_mark_full(struct idr_layer **pa, int id)
  * @idp:	idr handle
  * @gfp_mask:	memory allocation flags
  *
- * This function should be called prior to locking and calling the
- * idr_get_new* functions. It preallocates enough memory to satisfy
- * the worst possible allocation.
+ * This function should be called prior to calling the idr_get_new*
+ * functions. It preallocates enough memory to satisfy the worst
+ * possible allocation. You can sleep in this function iff without
+ * holding spinlock.
  *
  * If the system is REALLY out of memory this function returns 0,
  * otherwise 1.
@@ -290,9 +291,8 @@ static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
  * This is the allocate id function.  It should be called with any
  * required locks.
  *
- * If memory is required, it will return -EAGAIN, you should unlock
- * and go back to the idr_pre_get() call.  If the idr is full, it will
- * return -ENOSPC.
+ * If memory is required, it will return -EAGAIN, you should go back to
+ * the idr_pre_get() call. If the idr is full, it will return -ENOSPC.
  *
  * @id returns a value in the range @starting_id ... 0x7fffffff
  */
@@ -321,9 +321,8 @@ EXPORT_SYMBOL(idr_get_new_above);
  * This is the allocate id function.  It should be called with any
  * required locks.
  *
- * If memory is required, it will return -EAGAIN, you should unlock
- * and go back to the idr_pre_get() call.  If the idr is full, it will
- * return -ENOSPC.
+ * If memory is required, it will return -EAGAIN, you should go back to
+ * the idr_pre_get() call. If the idr is full, it will return -ENOSPC.
  *
  * @id returns a value in the range 0 ... 0x7fffffff
  */
-- 
1.7.2.3
