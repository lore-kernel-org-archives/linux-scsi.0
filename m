From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Wed, 27 Apr 2016 23:34:14 +0200
Message-ID: <4940273.pi2bWg8tAl@wuerfel>
References: <20160419085221.GA29087@gmail.com> <5298237.1Guzp0G04x@wuerfel> <20160427110503.GB24887@virgil.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160427110503.GB24887@virgil.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Jambor <mjambor@suse.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com, Jan Hubicka <hubicka@ucw.cz>, Chris Metcalf <cmetcalf@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 27 April 2016 13:05:03 Martin Jambor wrote:
> On Tue, Apr 26, 2016 at 05:58:20PM +0200, Arnd Bergmann wrote:
> > On Tuesday 26 April 2016 09:06:54 Martin K. Petersen wrote:
> > > >>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:
> > > 
> > > Arnd> I don't think we can realistically blacklist gcc-4.9.{0,1,2,3},
> > > Arnd> gcc-5.{0,1,2,3}.* and gcc-6.0 and require everyone to upgrade to
> > > Arnd> compilers that have not been released yet in order to build a
> > > Arnd> linux-4.6 kernel.
> > > 
> > > I agree that compiler blacklisting is problematic and I'd like to avoid
> > > it. The question is how far we go in the kernel to accommodate various
> > > levels of brokenness.
> > > 
> > > In any case. Sticking compiler workarounds in device driver code is akin
> > > to putting demolition orders on display on Alpha Centauri. At the very
> > > minimum the patch should put a fat comment in the code stating that
> > > these wrapper functions or #defines should not be changed in the future
> > > because that'll break builds using gcc XYZ. But that does not solve the
> > > problem for anybody else that might be doing something similar.
> > > Converting between u64 and $RANDOM_TYPE in an inline wrapper does not
> > > seem like a rare and unusual programming pattern.
> > 
> > It's not the driver really, it's the core scsi/fc layer, which makes
> > it a little dangerous that a random driver.
> > 
> > I agree that putting a comment in would also help. What I understand
> > from the bug report is that to trigger this bug you need these elements:
> > 
> > 1. an inline function marked __always_inline
> > 2. another inline function that is automatically inlined (not __always_inline)
> > 3. CONFIG_OPTIMIZE_INLINING=y to guarantee 2
> > 4. __builtin_compatible_p inside that inline function
> 
> The __always_inline requirement is not true.  In fact, if you look at
> the example testcase filed in
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646#c7 you'll see it
> uses __builtin_compatible_p in an __always inline function that is
> called from one that is not tagged with that attribute.
>
> And generally speaking, always inline is never a requirement, any call
> or chain of calls that the inliner can decide to inline can lead to
> the bug (if it complies with the condition below).

Ok, thanks for the clarification, I thought you always had to have both
kinds of inline functions.
 
> What is a requirement, though, is that __builtin_compatible_p is
> called on something passed in an argument by reference or in an
> aggregate (i.e. struct or array) argument.
> 
> So,
> 
>   int foo1 (unsigned long *ref)
>   {
>     if (__builtin_constant (*ref))
>       ...
>     else
>       /* wrongly unreachable code */
>   }
> 
>   }
> 
> cannot, and is fine.  But please note that wrapping a foo[12]-like
> function into a dereferencing wrapper might not help if foo[12] would
> be early-inlined into such wrapper (GCC has two inliners, a very
> simple early-inliner that only handles simple cases and a full-blown
> IPA inliner that contains the bug).  I believe this can be ensured by
> making the wrapper always_inline and never calling it indirectly (via
> a pointer).  Honza (CCed), you know inlining heuristics better, please
> correct me if my last statement is somehow inaccurate (or indeed if
> you have a better idea how kernel developers can make sure they do not
> hit the bug).

I guess that means that any user of this code in the kernel:

static inline __attribute_const__ __u64 __fswab64(__u64 val)
{
#ifdef __HAVE_BUILTIN_BSWAP64__
        return __builtin_bswap64(val);
#elif defined (__arch_swab64)
        return __arch_swab64(val);
#elif defined(__SWAB_64_THRU_32__)
        __u32 h = val >> 32;
        __u32 l = val & ((1ULL << 32) - 1);
        return (((__u64)__fswab32(l)) << 32) | ((__u64)(__fswab32(h)));
#else
        return ___constant_swab64(val);
#endif
}

#define __swab64(x)                             \
        (__builtin_constant_p((__u64)(x)) ?     \
        ___constant_swab64(x) :                 \
        __fswab64(x))

static __always_inline __u64 __swab64p(const __u64 *p)
{       
#ifdef __arch_swab64p
        return __arch_swab64p(p);
#else
        return __swab64(*p);
#endif
}

has a chance of running into the same problem, and we may want to solve
it at the root. For architectures that define __HAVE_BUILTIN_BSWAP64__
(i.e. ARM, MIPS, POWERPC, S390, and x86 with gcc-4.4 or higher, 4.8
for __HAVE_BUILTIN_BSWAP16__), we can probably just change the logic
to avoid __builtin_constant_p() and always use __builtin_bswap64().

This won't help on TILE, which is the one architecture that sets
ARCH_SUPPORTS_OPTIMIZED_INLINING but does not set ARCH_USE_BUILTIN_BSWAP.
Chris Metcalf should be able to figure out whether we can just
set ARCH_USE_BUILTIN_BSWAP for tile as well.

	Arnd
