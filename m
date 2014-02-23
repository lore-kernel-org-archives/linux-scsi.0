From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: memory-barriers.txt again (was Re: [PATCH 4/9] firewire: don't use
 PREPARE_DELAYED_WORK)
Date: Sun, 23 Feb 2014 02:23:03 +0100
Message-ID: <20140223022303.3240093c@stein>
References: <1392929071-16555-5-git-send-email-tj@kernel.org>
	<5306AF8E.3080006@hurleysoftware.com>
	<20140221015935.GF6897@htj.dyndns.org>
	<5306B4DF.4000901@hurleysoftware.com>
	<20140221021341.GG6897@htj.dyndns.org>
	<5306E06C.5020805@hurleysoftware.com>
	<20140221100301.GA14653@mtj.dyndns.org>
	<53074BE4.1020307@hurleysoftware.com>
	<20140221130614.GH6897@htj.dyndns.org>
	<5307849A.9050209@hurleysoftware.com>
	<20140221165730.GA10929@htj.dyndns.org>
	<5307DAC9.2020103@hurleysoftware.com>
	<1393094608.11497.1.camel@dabdike.int.hansenpartnership.com>
	<5308F0E2.3030804@hurleysoftware.com>
	<1393095138.11497.5.camel@dabdike.int.hansenpartnership.com>
	<5308F48C.8080609@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5308F48C.8080609@hurleysoftware.com>
Sender: target-devel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Paul,

in patch "Documentation/memory-barriers.txt: Downgrade UNLOCK+BLOCK" (sic),
you wrote:
+     Memory operations issued before the LOCK may be completed after the
+     LOCK operation has completed.  An smp_mb__before_spinlock(), combined
+     with a following LOCK, orders prior loads against subsequent stores
+     and stores and prior stores against subsequent stores.  Note that

Is there a "and stores" too many?  Or was one "stores" mistyped and meant
to be something else?  Or what else is meant?

@@ -1677,13 +1681,57 @@ LOCK, and an access following the UNLOCK to happen before the UNLOCK, and the
 two accesses can themselves then cross:
 
 	*A = a;
-	LOCK
-	UNLOCK
+	LOCK M
+	UNLOCK M
 	*B = b;
 
 may occur as:
 
-	LOCK, STORE *B, STORE *A, UNLOCK
+	LOCK M, STORE *B, STORE *A, UNLOCK M
+
+This same reordering can of course occur if the LOCK and UNLOCK are
+to the same lock variable, but only from the perspective of another
+CPU not holding that lock.

The example says "LOCK M" and "UNLOCK M" (since the patch).  I read
this as LOCK and UNLOCK to the same variable, M.  Why does the
following sentence then say that "this same reordering can... occur
if the LOCK and UNLOCK are to the same lock variable"?  This sentence
would make sense if the example had been about LOCK M, UNLOCK N.

+In short, an UNLOCK followed by a LOCK may -not- be assumed to be a full
+memory barrier because it is possible for a preceding UNLOCK to pass a
+later LOCK from the viewpoint of the CPU, but not from the viewpoint
+of the compiler.  Note that deadlocks cannot be introduced by this
+interchange because if such a deadlock threatened, the UNLOCK would
+simply complete.

So rather than deadlock, "the UNLOCK would simply complete".  But
/why/ does it complete?  It is left unclear (to me at least), why
it would do so.  IOW, what mechanism will make it always proceed
to the UNLOCK?  Without knowing that, it is left entirely unclear
(to me) why the deadlock wouldn't happen.
-- 
Stefan Richter
-=====-====- --=- =-===
http://arcgraph.de/sr/
