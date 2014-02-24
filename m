From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: memory-barriers.txt again (was Re: [PATCH 4/9] firewire: don't
 use PREPARE_DELAYED_WORK)
Date: Sun, 23 Feb 2014 19:09:55 -0500
Message-ID: <530A8DD3.8060404@hurleysoftware.com>
References: <5307849A.9050209@hurleysoftware.com> <20140221165730.GA10929@htj.dyndns.org> <5307DAC9.2020103@hurleysoftware.com> <1393094608.11497.1.camel@dabdike.int.hansenpartnership.com> <5308F0E2.3030804@hurleysoftware.com> <1393095138.11497.5.camel@dabdike.int.hansenpartnership.com> <5308F48C.8080609@hurleysoftware.com> <20140223022303.3240093c@stein> <20140223163743.GU4250@linux.vnet.ibm.com> <530A5B93.7010304@hurleysoftware.com> <20140223235012.GB8264@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140223235012.GB8264@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: paulmck@linux.vnet.ibm.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/23/2014 06:50 PM, Paul E. McKenney wrote:
> On Sun, Feb 23, 2014 at 03:35:31PM -0500, Peter Hurley wrote:
>> Hi Paul,
>>
>> On 02/23/2014 11:37 AM, Paul E. McKenney wrote:
>>> commit aba6b0e82c9de53eb032844f1932599f148ff68d
>>> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> Date:   Sun Feb 23 08:34:24 2014 -0800
>>>
>>>      Documentation/memory-barriers.txt: Clarify release/acquire ordering
>>>
>>>      This commit fixes a couple of typos and clarifies what happens when
>>>      the CPU chooses to execute a later lock acquisition before a prior
>>>      lock release, in particular, why deadlock is avoided.
>>>
>>>      Reported-by: Peter Hurley <peter@hurleysoftware.com>
>>>      Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>>>      Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>>>      Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>>
>>> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
>>> index 9dde54c55b24..c8932e06edf1 100644
>>> --- a/Documentation/memory-barriers.txt
>>> +++ b/Documentation/memory-barriers.txt
>>> @@ -1674,12 +1674,12 @@ for each construct.  These operations all imply certain barriers:
>>>        Memory operations issued after the ACQUIRE will be completed after the
>>>        ACQUIRE operation has completed.
>>>
>>> -     Memory operations issued before the ACQUIRE may be completed after the
>>> -     ACQUIRE operation has completed.  An smp_mb__before_spinlock(), combined
>>> -     with a following ACQUIRE, orders prior loads against subsequent stores and
>>> -     stores and prior stores against subsequent stores.  Note that this is
>>> -     weaker than smp_mb()!  The smp_mb__before_spinlock() primitive is free on
>>> -     many architectures.
>>> +     Memory operations issued before the ACQUIRE may be completed after
>>> +     the ACQUIRE operation has completed.  An smp_mb__before_spinlock(),
>>> +     combined with a following ACQUIRE, orders prior loads against
>>> +     subsequent loads and stores and also orders prior stores against
>>> +     subsequent stores.  Note that this is weaker than smp_mb()!  The
>>> +     smp_mb__before_spinlock() primitive is free on many architectures.
>>>
>>>    (2) RELEASE operation implication:
>>>
>>> @@ -1717,23 +1717,47 @@ the two accesses can themselves then cross:
>>>
>>>   	*A = a;
>>>   	ACQUIRE M
>>> -	RELEASE M
>>> +	RELEASE N
>>>   	*B = b;
>>>
>>>   may occur as:
>>>
>>> -	ACQUIRE M, STORE *B, STORE *A, RELEASE M
>>
>> This example should remain as is; it refers to the porosity of a critical
>> section to loads and stores occurring outside that critical section, and
>> importantly that LOCK + UNLOCK is not a full barrier. It documents that
>> memory operations from either side of the critical section may cross
>> (in the absence of other specific memory barriers). IOW, it is the example
>> to implication #1 above.
>
> Good point, I needed to apply the changes further down.  How does the
> following updated patch look?
>
> 							Thanx, Paul
>
> ------------------------------------------------------------------------
>
> commit 528c2771288df7f98f9224a56b93bdb2db27ec70
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Sun Feb 23 08:34:24 2014 -0800
>
>      Documentation/memory-barriers.txt: Clarify release/acquire ordering
>
>      This commit fixes a couple of typos and clarifies what happens when
>      the CPU chooses to execute a later lock acquisition before a prior
>      lock release, in particular, why deadlock is avoided.
>
>      Reported-by: Peter Hurley <peter@hurleysoftware.com>
>      Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>      Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>      Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 9dde54c55b24..9ea6de4eb252 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -1674,12 +1674,12 @@ for each construct.  These operations all imply certain barriers:
>        Memory operations issued after the ACQUIRE will be completed after the
>        ACQUIRE operation has completed.
>
> -     Memory operations issued before the ACQUIRE may be completed after the
> -     ACQUIRE operation has completed.  An smp_mb__before_spinlock(), combined
> -     with a following ACQUIRE, orders prior loads against subsequent stores and
> -     stores and prior stores against subsequent stores.  Note that this is
> -     weaker than smp_mb()!  The smp_mb__before_spinlock() primitive is free on
> -     many architectures.
> +     Memory operations issued before the ACQUIRE may be completed after
> +     the ACQUIRE operation has completed.  An smp_mb__before_spinlock(),
> +     combined with a following ACQUIRE, orders prior loads against
> +     subsequent loads and stores and also orders prior stores against
> +     subsequent stores.  Note that this is weaker than smp_mb()!  The
> +     smp_mb__before_spinlock() primitive is free on many architectures.
>
>    (2) RELEASE operation implication:
>
> @@ -1724,24 +1724,20 @@ may occur as:
>
>   	ACQUIRE M, STORE *B, STORE *A, RELEASE M
>
> -This same reordering can of course occur if the lock's ACQUIRE and RELEASE are
> -to the same lock variable, but only from the perspective of another CPU not
> -holding that lock.
> -
> -In short, a RELEASE followed by an ACQUIRE may -not- be assumed to be a full
> -memory barrier because it is possible for a preceding RELEASE to pass a
> -later ACQUIRE from the viewpoint of the CPU, but not from the viewpoint
> -of the compiler.  Note that deadlocks cannot be introduced by this
> -interchange because if such a deadlock threatened, the RELEASE would
> -simply complete.
> +When the ACQUIRE and RELEASE are a lock acquisition and release,
> +respectively, this same reordering can of course occur if the lock's
                                            ^^^^^^^
                                           [delete?]

> +ACQUIRE and RELEASE are to the same lock variable, but only from the
> +perspective of another CPU not holding that lock.

In the above, are you introducing UNLOCK + LOCK not being a full barrier
or are you further elaborating the non-barrier that is LOCK + UNLOCK.

If you mean the first, might I suggest something like,

"Similarly, a RELEASE followed by an ACQUIRE may -not- be assumed to be a full
memory barrier."

as the introductory sentence.

>  In short, a RELEASE
> +followed by an ACQUIRE may -not- be assumed to be a full memory barrier.


>   If it is necessary for a RELEASE-ACQUIRE pair to produce a full barrier, the
>   ACQUIRE can be followed by an smp_mb__after_unlock_lock() invocation.  This
>   will produce a full barrier if either (a) the RELEASE and the ACQUIRE are
>   executed by the same CPU or task, or (b) the RELEASE and ACQUIRE act on the
>   same variable.  The smp_mb__after_unlock_lock() primitive is free on many
> -architectures.  Without smp_mb__after_unlock_lock(), the critical sections
> -corresponding to the RELEASE and the ACQUIRE can cross:
> +architectures.  Without smp_mb__after_unlock_lock(), the CPU's execution of
> +the critical sections corresponding to the RELEASE and the ACQUIRE can cross,
> +so that:
>
>   	*A = a;
>   	RELEASE M
> @@ -1752,7 +1748,36 @@ could occur as:
>
>   	ACQUIRE N, STORE *B, STORE *A, RELEASE M
>
> -With smp_mb__after_unlock_lock(), they cannot, so that:
> +It might appear that this rearrangement could introduce a deadlock.
> +However, this cannot happen because if such a deadlock threatened,
> +the RELEASE would simply complete, thereby avoiding the deadlock.
> +
> +	Why does this work?
> +
> +	One key point is that we are only talking about the CPU doing
> +	the interchanging, not the compiler.  If the compiler (or, for
                  ^
             reordering?
> +	that matter, the developer) switched the operations, deadlock
> +	-could- occur.
> +
> +	But suppose the CPU interchanged the operations.  In this case,
                                  ^
                               reordered?

> +	the unlock precedes the lock in the assembly code.  The CPU simply
> +	elected to try executing the later lock operation first.  If there
> +	is a deadlock, this lock operation will simply spin (or try to
> +	sleep, but more on that later).  The CPU will eventually execute
> +	the unlock operation (which again preceded the lock operation
                                       ^^
                                     [delete?]
> +	in the assembly code), which will unravel the potential deadlock,
> +	allowing the lock operation to succeed.
> +
> +	But what if the lock is a sleeplock?  In that case, the code will
> +	try to enter the scheduler, where it will eventually encounter
> +	a memory barrier, which will force the earlier unlock operation
> +	to complete, again unraveling the deadlock.  There might be
> +	a sleep-unlock race, but the locking primitive needs to resolve
> +	such races properly in any case.
> +
> +With smp_mb__after_unlock_lock(), the two critical sections cannot overlap.
> +For example, with the following code, the store to *A will always be
> +seen by other CPUs before the store to *B:
>
>   	*A = a;
>   	RELEASE M
> @@ -1760,13 +1785,18 @@ With smp_mb__after_unlock_lock(), they cannot, so that:
>   	smp_mb__after_unlock_lock();
>   	*B = b;
>
> -will always occur as either of the following:
> +The operations will always occur in one of the following orders:
>
> -	STORE *A, RELEASE, ACQUIRE, STORE *B
> -	STORE *A, ACQUIRE, RELEASE, STORE *B
> +	STORE *A, RELEASE, ACQUIRE, smp_mb__after_unlock_lock(), STORE *B
> +	STORE *A, ACQUIRE, RELEASE, smp_mb__after_unlock_lock(), STORE *B
> +	ACQUIRE, STORE *A, RELEASE, smp_mb__after_unlock_lock(), STORE *B
>
> -If the RELEASE and ACQUIRE were instead both operating on the same lock
> -variable, only the first of these two alternatives can occur.
> +If the RELEASE and ACQUIRE were instead both operating on the
> +same lock variable, only the first of these two alternatives can
> +occur.  In addition, the more strongly ordered systems may rule out
> +some of the above orders.  But in any case, as noted earlier, the
> +smp_mb__after_unlock_lock() ensures that the store to *A will always be
> +seen as happening before the store to *B.
>
>   Locks and semaphores may not provide any guarantee of ordering on UP compiled
>   systems, and so cannot be counted on in such a situation to actually achieve

Thanks for your work on these docs (and rcu and locks and multi-arch barriers
in general :) )

Regards,
Peter Hurley
