From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: memory-barriers.txt again (was Re: [PATCH 4/9] firewire: don't
	use PREPARE_DELAYED_WORK)
Date: Sun, 23 Feb 2014 08:37:43 -0800
Message-ID: <20140223163743.GU4250@linux.vnet.ibm.com>
References: <53074BE4.1020307@hurleysoftware.com>
	<20140221130614.GH6897@htj.dyndns.org>
	<5307849A.9050209@hurleysoftware.com>
	<20140221165730.GA10929@htj.dyndns.org>
	<5307DAC9.2020103@hurleysoftware.com>
	<1393094608.11497.1.camel@dabdike.int.hansenpartnership.com>
	<5308F0E2.3030804@hurleysoftware.com>
	<1393095138.11497.5.camel@dabdike.int.hansenpartnership.com>
	<5308F48C.8080609@hurleysoftware.com>
	<20140223022303.3240093c@stein>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20140223022303.3240093c@stein>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, target-devel@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux1394-devel@lists.sourceforge.net, laijs@cn.fujitsu.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 23, 2014 at 02:23:03AM +0100, Stefan Richter wrote:
> Hi Paul,
> 
> in patch "Documentation/memory-barriers.txt: Downgrade UNLOCK+BLOCK" (sic),
> you wrote:
> +     Memory operations issued before the LOCK may be completed after the
> +     LOCK operation has completed.  An smp_mb__before_spinlock(), combined
> +     with a following LOCK, orders prior loads against subsequent stores
> +     and stores and prior stores against subsequent stores.  Note that
> 
> Is there a "and stores" too many?  Or was one "stores" mistyped and meant
> to be something else?  Or what else is meant?

Good catch!  (This should also answer Peter Hurley's concern on another
email thread.)

The last "stores" on the third line should be a "loads":

	Memory operations issued before the ACQUIRE may be
	completed after the ACQUIRE operation has completed.  An
	smp_mb__before_spinlock(), combined with a following ACQUIRE,
	orders prior loads against subsequent loads and stores and
	also orders prior stores against subsequent stores.  Note that
	this is weaker than smp_mb()!  The smp_mb__before_spinlock()
	primitive is free on many architectures.

> @@ -1677,13 +1681,57 @@ LOCK, and an access following the UNLOCK to happen before the UNLOCK, and the
>  two accesses can themselves then cross:
> 
>  	*A = a;
> -	LOCK
> -	UNLOCK
> +	LOCK M
> +	UNLOCK M
>  	*B = b;
> 
>  may occur as:
> 
> -	LOCK, STORE *B, STORE *A, UNLOCK
> +	LOCK M, STORE *B, STORE *A, UNLOCK M
> +
> +This same reordering can of course occur if the LOCK and UNLOCK are
> +to the same lock variable, but only from the perspective of another
> +CPU not holding that lock.
> 
> The example says "LOCK M" and "UNLOCK M" (since the patch).  I read
> this as LOCK and UNLOCK to the same variable, M.  Why does the
> following sentence then say that "this same reordering can... occur
> if the LOCK and UNLOCK are to the same lock variable"?  This sentence
> would make sense if the example had been about LOCK M, UNLOCK N.

Good point.  How about the following?

	When the ACQUIRE and RELEASE are a lock acquisition and release,
	respectively, this same reordering can of course occur if the
	lock's ACQUIRE and RELEASE are to the same lock variable, but
	only from the perspective of another CPU not holding that lock.

> +In short, an UNLOCK followed by a LOCK may -not- be assumed to be a full
> +memory barrier because it is possible for a preceding UNLOCK to pass a
> +later LOCK from the viewpoint of the CPU, but not from the viewpoint
> +of the compiler.  Note that deadlocks cannot be introduced by this
> +interchange because if such a deadlock threatened, the UNLOCK would
> +simply complete.
> 
> So rather than deadlock, "the UNLOCK would simply complete".  But
> /why/ does it complete?  It is left unclear (to me at least), why
> it would do so.  IOW, what mechanism will make it always proceed
> to the UNLOCK?  Without knowing that, it is left entirely unclear
> (to me) why the deadlock wouldn't happen.

One key point is that we are only talking about the CPU doing the
interchanging, not the compiler.  If the compiler (or, for that matter,
the developer) switched the operations, deadlock -could- occur.

But suppose the CPU interchanged the operations.  In this case, the
unlock precede the lock in the assembly code.  The CPU simply elected
to try executing the lock operation first.  If there is a deadlock,
this lock operation will simply spin (or try to sleep, but more on
that later).  The CPU will eventually execute the unlock operation
(which again preceded the lock operation in the assembly code), which
will unravel the potential deadlock.

But what if the lock is for a sleeplock?  In that case, the code will
try to enter the scheduler, where it will eventually encounter a
memory barrier, which will force the unlock operation to complete,
again unraveling the deadlock.

Please see below for a patch against the current version of
Documentation/memory-barriers.txt.  Does this update help?

						Thanx, Paul

------------------------------------------------------------------------

commit aba6b0e82c9de53eb032844f1932599f148ff68d
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Sun Feb 23 08:34:24 2014 -0800

    Documentation/memory-barriers.txt: Clarify release/acquire ordering
    
    This commit fixes a couple of typos and clarifies what happens when
    the CPU chooses to execute a later lock acquisition before a prior
    lock release, in particular, why deadlock is avoided.
    
    Reported-by: Peter Hurley <peter@hurleysoftware.com>
    Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
    Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 9dde54c55b24..c8932e06edf1 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1674,12 +1674,12 @@ for each construct.  These operations all imply certain barriers:
      Memory operations issued after the ACQUIRE will be completed after the
      ACQUIRE operation has completed.
 
-     Memory operations issued before the ACQUIRE may be completed after the
-     ACQUIRE operation has completed.  An smp_mb__before_spinlock(), combined
-     with a following ACQUIRE, orders prior loads against subsequent stores and
-     stores and prior stores against subsequent stores.  Note that this is
-     weaker than smp_mb()!  The smp_mb__before_spinlock() primitive is free on
-     many architectures.
+     Memory operations issued before the ACQUIRE may be completed after
+     the ACQUIRE operation has completed.  An smp_mb__before_spinlock(),
+     combined with a following ACQUIRE, orders prior loads against
+     subsequent loads and stores and also orders prior stores against
+     subsequent stores.  Note that this is weaker than smp_mb()!  The
+     smp_mb__before_spinlock() primitive is free on many architectures.
 
  (2) RELEASE operation implication:
 
@@ -1717,23 +1717,47 @@ the two accesses can themselves then cross:
 
 	*A = a;
 	ACQUIRE M
-	RELEASE M
+	RELEASE N
 	*B = b;
 
 may occur as:
 
-	ACQUIRE M, STORE *B, STORE *A, RELEASE M
-
-This same reordering can of course occur if the lock's ACQUIRE and RELEASE are
-to the same lock variable, but only from the perspective of another CPU not
-holding that lock.
-
-In short, a RELEASE followed by an ACQUIRE may -not- be assumed to be a full
-memory barrier because it is possible for a preceding RELEASE to pass a
-later ACQUIRE from the viewpoint of the CPU, but not from the viewpoint
-of the compiler.  Note that deadlocks cannot be introduced by this
-interchange because if such a deadlock threatened, the RELEASE would
-simply complete.
+	ACQUIRE M, STORE *B, STORE *A, RELEASE N
+
+When the ACQUIRE and RELEASE are a lock acquisition and release,
+respectively, this same reordering can of course occur if the lock's
+ACQUIRE and RELEASE are to the same lock variable, but only from the
+perspective of another CPU not holding that lock.
+
+In short, a RELEASE followed by an ACQUIRE may -not- be assumed to be
+a full memory barrier because it is possible for a preceding RELEASE
+to pass a later ACQUIRE from the viewpoint of the CPU, but not from the
+viewpoint of the compiler.  Note that the CPU cannot introduce deadlocks
+with this interchange because if such a deadlock threatened, the RELEASE
+would simply complete.
+
+	Why does this work?
+
+	One key point is that we are only talking about the CPU doing
+	the interchanging, not the compiler.  If the compiler (or, for
+	that matter, the developer) switched the operations, deadlock
+	-could- occur.
+
+	But suppose the CPU interchanged the operations.  In this case,
+	the unlock precedes the lock in the assembly code.  The CPU simply
+	elected to try executing the later lock operation first.  If there
+	is a deadlock, this lock operation will simply spin (or try to
+	sleep, but more on that later).  The CPU will eventually execute
+	the unlock operation (which again preceded the lock operation
+	in the assembly code), which will unravel the potential deadlock,
+	allowing the lock operation to succeed.
+
+	But what if the lock is a sleeplock?  In that case, the code will
+	try to enter the scheduler, where it will eventually encounter
+	a memory barrier, which will force the earlier unlock operation
+	to complete, again unraveling the deadlock.  There might be
+	a sleep-unlock race, but the locking primitive needs to resolve
+	such races properly in any case.
 
 If it is necessary for a RELEASE-ACQUIRE pair to produce a full barrier, the
 ACQUIRE can be followed by an smp_mb__after_unlock_lock() invocation.  This


------------------------------------------------------------------------------
Managing the Performance of Cloud-Based Applications
Take advantage of what the Cloud has to offer - Avoid Common Pitfalls.
Read the Whitepaper.
http://pubads.g.doubleclick.net/gampad/clk?id=121054471&iu=/4140/ostg.clktrk
