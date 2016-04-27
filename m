From: Martin Jambor <mjambor@suse.cz>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Wed, 27 Apr 2016 13:05:03 +0200
Message-ID: <20160427110503.GB24887@virgil.suse.cz>
References: <20160419085221.GA29087@gmail.com>
 <5249561.9VpAPLD61M@wuerfel>
 <yq14maoh635.fsf@sermon.lab.mkp.net>
 <5298237.1Guzp0G04x@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbcD0LFI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 07:05:08 -0400
Content-Disposition: inline
In-Reply-To: <5298237.1Guzp0G04x@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com, Jan Hubicka <hubicka@ucw.cz>

Hi,

On Tue, Apr 26, 2016 at 05:58:20PM +0200, Arnd Bergmann wrote:
> On Tuesday 26 April 2016 09:06:54 Martin K. Petersen wrote:
> > >>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:
> > 
> > Arnd> I don't think we can realistically blacklist gcc-4.9.{0,1,2,3},
> > Arnd> gcc-5.{0,1,2,3}.* and gcc-6.0 and require everyone to upgrade to
> > Arnd> compilers that have not been released yet in order to build a
> > Arnd> linux-4.6 kernel.
> > 
> > I agree that compiler blacklisting is problematic and I'd like to avoid
> > it. The question is how far we go in the kernel to accommodate various
> > levels of brokenness.
> > 
> > In any case. Sticking compiler workarounds in device driver code is akin
> > to putting demolition orders on display on Alpha Centauri. At the very
> > minimum the patch should put a fat comment in the code stating that
> > these wrapper functions or #defines should not be changed in the future
> > because that'll break builds using gcc XYZ. But that does not solve the
> > problem for anybody else that might be doing something similar.
> > Converting between u64 and $RANDOM_TYPE in an inline wrapper does not
> > seem like a rare and unusual programming pattern.
> 
> It's not the driver really, it's the core scsi/fc layer, which makes
> it a little dangerous that a random driver.
> 
> I agree that putting a comment in would also help. What I understand
> from the bug report is that to trigger this bug you need these elements:
> 
> 1. an inline function marked __always_inline
> 2. another inline function that is automatically inlined (not __always_inline)
> 3. CONFIG_OPTIMIZE_INLINING=y to guarantee 2
> 4. __builtin_compatible_p inside that inline function

The __always_inline requirement is not true.  In fact, if you look at
the example testcase filed in
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646#c7 you'll see it
uses __builtin_compatible_p in an __always inline function that is
called from one that is not tagged with that attribute.

And generally speaking, always inline is never a requirement, any call
or chain of calls that the inliner can decide to inline can lead to
the bug (if it complies with the condition below).

What is a requirement, though, is that __builtin_compatible_p is
called on something passed in an argument by reference or in an
aggregate (i.e. struct or array) argument.

So,

  int foo1 (unsigned long *ref)
  {
    if (__builtin_constant (*ref))
      ...
    else
      /* wrongly unreachable code */
  }

can lead to this issue, as can

  int foo2 (struct S s)
  {
    if ((__builtin_constant (s.l))
      ...
    else
      /* wrongly unreachable code */
  }

but

  int foo3 (unsigned long val)
  {
    if (__builtin_constant (val))
      ...
    else
      /* all OK */
  }

cannot, and is fine.  But please note that wrapping a foo[12]-like
function into a dereferencing wrapper might not help if foo[12] would
be early-inlined into such wrapper (GCC has two inliners, a very
simple early-inliner that only handles simple cases and a full-blown
IPA inliner that contains the bug).  I believe this can be ensured by
making the wrapper always_inline and never calling it indirectly (via
a pointer).  Honza (CCed), you know inlining heuristics better, please
correct me if my last statement is somehow inaccurate (or indeed if
you have a better idea how kernel developers can make sure they do not
hit the bug).

Thanks,

Martin

> 
> The last point is what Denys introduced in the kernel with
> bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining of some
> byteswap operations"). So maybe it's better after all to revert that
> patch, to have a higher confidence in the same bug not appearing
> elsewhere. It's also really a workaround for another quirk of the
> compiler, but that one only results in duplicated functions in object
> code rather than functions that end in the middle.
> 
> 	Arnd
> 
