From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: memory-barriers.txt again (was Re: [PATCH 4/9] firewire: don't
	use PREPARE_DELAYED_WORK)
Date: Mon, 24 Feb 2014 08:26:06 -0800
Message-ID: <20140224162605.GM8264@linux.vnet.ibm.com>
References: <5307DAC9.2020103@hurleysoftware.com>
	<1393094608.11497.1.camel@dabdike.int.hansenpartnership.com>
	<5308F0E2.3030804@hurleysoftware.com>
	<1393095138.11497.5.camel@dabdike.int.hansenpartnership.com>
	<5308F48C.8080609@hurleysoftware.com>
	<20140223022303.3240093c@stein>
	<20140223163743.GU4250@linux.vnet.ibm.com>
	<530A5B93.7010304@hurleysoftware.com>
	<20140223235012.GB8264@linux.vnet.ibm.com>
	<530A8DD3.8060404@hurleysoftware.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <530A8DD3.8060404@hurleysoftware.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 23, 2014 at 07:09:55PM -0500, Peter Hurley wrote:
> On 02/23/2014 06:50 PM, Paul E. McKenney wrote:
> >On Sun, Feb 23, 2014 at 03:35:31PM -0500, Peter Hurley wrote:
> >>Hi Paul,
> >>
> >>On 02/23/2014 11:37 AM, Paul E. McKenney wrote:
> >>>commit aba6b0e82c9de53eb032844f1932599f148ff68d
> >>>Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>>Date:   Sun Feb 23 08:34:24 2014 -0800
> >>>
> >>>     Documentation/memory-barriers.txt: Clarify release/acquire ordering
> >>>
> >>>     This commit fixes a couple of typos and clarifies what happens when
> >>>     the CPU chooses to execute a later lock acquisition before a prior
> >>>     lock release, in particular, why deadlock is avoided.
> >>>
> >>>     Reported-by: Peter Hurley <peter@hurleysoftware.com>
> >>>     Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >>>     Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> >>>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>>
> >>>diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> >>>index 9dde54c55b24..c8932e06edf1 100644
> >>>--- a/Documentation/memory-barriers.txt
> >>>+++ b/Documentation/memory-barriers.txt
> >>>@@ -1674,12 +1674,12 @@ for each construct.  These operations all imply certain barriers:
> >>>       Memory operations issued after the ACQUIRE will be completed after the
> >>>       ACQUIRE operation has completed.
> >>>
> >>>-     Memory operations issued before the ACQUIRE may be completed after the
> >>>-     ACQUIRE operation has completed.  An smp_mb__before_spinlock(), combined
> >>>-     with a following ACQUIRE, orders prior loads against subsequent stores and
> >>>-     stores and prior stores against subsequent stores.  Note that this is
> >>>-     weaker than smp_mb()!  The smp_mb__before_spinlock() primitive is free on
> >>>-     many architectures.
> >>>+     Memory operations issued before the ACQUIRE may be completed after
> >>>+     the ACQUIRE operation has completed.  An smp_mb__before_spinlock(),
> >>>+     combined with a following ACQUIRE, orders prior loads against
> >>>+     subsequent loads and stores and also orders prior stores against
> >>>+     subsequent stores.  Note that this is weaker than smp_mb()!  The
> >>>+     smp_mb__before_spinlock() primitive is free on many architectures.
> >>>
> >>>   (2) RELEASE operation implication:
> >>>
> >>>@@ -1717,23 +1717,47 @@ the two accesses can themselves then cross:
> >>>
> >>>  	*A = a;
> >>>  	ACQUIRE M
> >>>-	RELEASE M
> >>>+	RELEASE N
> >>>  	*B = b;
> >>>
> >>>  may occur as:
> >>>
> >>>-	ACQUIRE M, STORE *B, STORE *A, RELEASE M
> >>
> >>This example should remain as is; it refers to the porosity of a critical
> >>section to loads and stores occurring outside that critical section, and
> >>importantly that LOCK + UNLOCK is not a full barrier. It documents that
> >>memory operations from either side of the critical section may cross
> >>(in the absence of other specific memory barriers). IOW, it is the example
> >>to implication #1 above.
> >
> >Good point, I needed to apply the changes further down.  How does the
> >following updated patch look?
> >
> >							Thanx, Paul
> >
> >------------------------------------------------------------------------
> >
> >commit 528c2771288df7f98f9224a56b93bdb2db27ec70
> >Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >Date:   Sun Feb 23 08:34:24 2014 -0800
> >
> >     Documentation/memory-barriers.txt: Clarify release/acquire ordering
> >
> >     This commit fixes a couple of typos and clarifies what happens when
> >     the CPU chooses to execute a later lock acquisition before a prior
> >     lock release, in particular, why deadlock is avoided.
> >
> >     Reported-by: Peter Hurley <peter@hurleysoftware.com>
> >     Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >     Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >
> >diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> >index 9dde54c55b24..9ea6de4eb252 100644
> >--- a/Documentation/memory-barriers.txt
> >+++ b/Documentation/memory-barriers.txt
> >@@ -1674,12 +1674,12 @@ for each construct.  These operations all imply certain barriers:
> >       Memory operations issued after the ACQUIRE will be completed after the
> >       ACQUIRE operation has completed.
> >
> >-     Memory operations issued before the ACQUIRE may be completed after the
> >-     ACQUIRE operation has completed.  An smp_mb__before_spinlock(), combined
> >-     with a following ACQUIRE, orders prior loads against subsequent stores and
> >-     stores and prior stores against subsequent stores.  Note that this is
> >-     weaker than smp_mb()!  The smp_mb__before_spinlock() primitive is free on
> >-     many architectures.
> >+     Memory operations issued before the ACQUIRE may be completed after
> >+     the ACQUIRE operation has completed.  An smp_mb__before_spinlock(),
> >+     combined with a following ACQUIRE, orders prior loads against
> >+     subsequent loads and stores and also orders prior stores against
> >+     subsequent stores.  Note that this is weaker than smp_mb()!  The
> >+     smp_mb__before_spinlock() primitive is free on many architectures.
> >
> >   (2) RELEASE operation implication:
> >
> >@@ -1724,24 +1724,20 @@ may occur as:
> >
> >  	ACQUIRE M, STORE *B, STORE *A, RELEASE M
> >
> >-This same reordering can of course occur if the lock's ACQUIRE and RELEASE are
> >-to the same lock variable, but only from the perspective of another CPU not
> >-holding that lock.
> >-
> >-In short, a RELEASE followed by an ACQUIRE may -not- be assumed to be a full
> >-memory barrier because it is possible for a preceding RELEASE to pass a
> >-later ACQUIRE from the viewpoint of the CPU, but not from the viewpoint
> >-of the compiler.  Note that deadlocks cannot be introduced by this
> >-interchange because if such a deadlock threatened, the RELEASE would
> >-simply complete.
> >+When the ACQUIRE and RELEASE are a lock acquisition and release,
> >+respectively, this same reordering can of course occur if the lock's
>                                            ^^^^^^^
>                                           [delete?]

If you insist.  ;-)  Done.

> >+ACQUIRE and RELEASE are to the same lock variable, but only from the
> >+perspective of another CPU not holding that lock.
> 
> In the above, are you introducing UNLOCK + LOCK not being a full barrier
> or are you further elaborating the non-barrier that is LOCK + UNLOCK.
> 
> If you mean the first, might I suggest something like,
> 
> "Similarly, a RELEASE followed by an ACQUIRE may -not- be assumed to be a full
> memory barrier."
> 
> as the introductory sentence.

Nope, just got the "ACQUIRE" and "RELEASE" backwards.  The sentence
below now reads:

	In short, a ACQUIRE followed by an RELEASE may -not- be assumed
	to be a full memory barrier.

> > In short, a RELEASE
> >+followed by an ACQUIRE may -not- be assumed to be a full memory barrier.

But I do need an transition sentence before the following paragraph.

I added this to the beginning of the following paragraph:

	Similarly, the reverse case of a RELEASE followed by an ACQUIRE
	does not imply a full memory barrier.

> >  If it is necessary for a RELEASE-ACQUIRE pair to produce a full barrier, the
> >  ACQUIRE can be followed by an smp_mb__after_unlock_lock() invocation.  This
> >  will produce a full barrier if either (a) the RELEASE and the ACQUIRE are
> >  executed by the same CPU or task, or (b) the RELEASE and ACQUIRE act on the
> >  same variable.  The smp_mb__after_unlock_lock() primitive is free on many
> >-architectures.  Without smp_mb__after_unlock_lock(), the critical sections
> >-corresponding to the RELEASE and the ACQUIRE can cross:
> >+architectures.  Without smp_mb__after_unlock_lock(), the CPU's execution of
> >+the critical sections corresponding to the RELEASE and the ACQUIRE can cross,
> >+so that:
> >
> >  	*A = a;
> >  	RELEASE M
> >@@ -1752,7 +1748,36 @@ could occur as:
> >
> >  	ACQUIRE N, STORE *B, STORE *A, RELEASE M
> >
> >-With smp_mb__after_unlock_lock(), they cannot, so that:
> >+It might appear that this rearrangement could introduce a deadlock.
> >+However, this cannot happen because if such a deadlock threatened,
> >+the RELEASE would simply complete, thereby avoiding the deadlock.
> >+
> >+	Why does this work?
> >+
> >+	One key point is that we are only talking about the CPU doing
> >+	the interchanging, not the compiler.  If the compiler (or, for
>                  ^
>             reordering?
> >+	that matter, the developer) switched the operations, deadlock
> >+	-could- occur.
> >+
> >+	But suppose the CPU interchanged the operations.  In this case,
>                                  ^
>                               reordered?

Agreed, avoiding random use of synonyms makes it clearer.  These are
now changed as you suggest.

> >+	the unlock precedes the lock in the assembly code.  The CPU simply
> >+	elected to try executing the later lock operation first.  If there
> >+	is a deadlock, this lock operation will simply spin (or try to
> >+	sleep, but more on that later).  The CPU will eventually execute
> >+	the unlock operation (which again preceded the lock operation
>                                       ^^
>                                     [delete?]

I guess I didn't explicitly call out this before, so agree on deleting
"again".  Done.

> >+	in the assembly code), which will unravel the potential deadlock,
> >+	allowing the lock operation to succeed.
> >+
> >+	But what if the lock is a sleeplock?  In that case, the code will
> >+	try to enter the scheduler, where it will eventually encounter
> >+	a memory barrier, which will force the earlier unlock operation
> >+	to complete, again unraveling the deadlock.  There might be
> >+	a sleep-unlock race, but the locking primitive needs to resolve
> >+	such races properly in any case.
> >+
> >+With smp_mb__after_unlock_lock(), the two critical sections cannot overlap.
> >+For example, with the following code, the store to *A will always be
> >+seen by other CPUs before the store to *B:
> >
> >  	*A = a;
> >  	RELEASE M
> >@@ -1760,13 +1785,18 @@ With smp_mb__after_unlock_lock(), they cannot, so that:
> >  	smp_mb__after_unlock_lock();
> >  	*B = b;
> >
> >-will always occur as either of the following:
> >+The operations will always occur in one of the following orders:
> >
> >-	STORE *A, RELEASE, ACQUIRE, STORE *B
> >-	STORE *A, ACQUIRE, RELEASE, STORE *B
> >+	STORE *A, RELEASE, ACQUIRE, smp_mb__after_unlock_lock(), STORE *B
> >+	STORE *A, ACQUIRE, RELEASE, smp_mb__after_unlock_lock(), STORE *B
> >+	ACQUIRE, STORE *A, RELEASE, smp_mb__after_unlock_lock(), STORE *B
> >
> >-If the RELEASE and ACQUIRE were instead both operating on the same lock
> >-variable, only the first of these two alternatives can occur.
> >+If the RELEASE and ACQUIRE were instead both operating on the
> >+same lock variable, only the first of these two alternatives can
> >+occur.  In addition, the more strongly ordered systems may rule out
> >+some of the above orders.  But in any case, as noted earlier, the
> >+smp_mb__after_unlock_lock() ensures that the store to *A will always be
> >+seen as happening before the store to *B.
> >
> >  Locks and semaphores may not provide any guarantee of ordering on UP compiled
> >  systems, and so cannot be counted on in such a situation to actually achieve
> 
> Thanks for your work on these docs (and rcu and locks and multi-arch barriers
> in general :) )

Glad you like them, and thank you for your review and comments!

							Thanx, Paul


------------------------------------------------------------------------------
Flow-based real-time traffic analytics software. Cisco certified tool.
Monitor traffic, SLAs, QoS, Medianet, WAAS etc. with NetFlow Analyzer
Customize your own dashboards, set traffic alerts and generate reports.
Network behavioral analysis & security monitoring. All-in-one tool.
http://pubads.g.doubleclick.net/gampad/clk?id=126839071&iu=/4140/ostg.clktrk
