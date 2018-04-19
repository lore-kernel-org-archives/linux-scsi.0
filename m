From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v3 1/6] ilog2: create truly constant version for sparse
Date: Thu, 19 Apr 2018 10:19:54 +0200
Message-ID: <c68a0f46-346c-70a0-a9b8-31747888f05f@rasmusvillemoes.dk>
References: <20180417233511.6573-1-mwilck@suse.com>
 <20180417233511.6573-2-mwilck@suse.com>
 <CA+55aFxLY2=RVAD8m-3bf4vKWpPKWSmjN_tLVWwb4Y7w81UTbA@mail.gmail.com>
 <1524039174.3028.24.camel@suse.com>
 <CA+55aFyLUNQUrog0MU3a07jesimiDYQ2HQc2UpAKG1SEOK23Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyLUNQUrog0MU3a07jesimiDYQ2HQc2UpAKG1SEOK23Xw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-04-18 23:21, Linus Torvalds wrote:
> On Wed, Apr 18, 2018 at 1:12 AM, Martin Wilck <mwilck@suse.com> wrote:
>>
>> No, it doesn't (gcc 7.3.0). -> https://paste.opensuse.org/27471594
>> It doesn't even warn on an expression like this:
>>
>>   #define SIZE (1<<10)
>>   static int foo[ilog2(SIZE)];
> 
> Ok, I think this is the "random gcc versions act differently" issue.
> 
> Sometimes __builtin_constant_p() to a ternary operation acts as a
> constant expression, and sometimes it doesn't.

So __builtin_constant_p on an actual ICE always fold immediately to 1.
Looking at the gcc history, that seems to have been there since at least
2000, but likely forever. And when it's the controlling expression of a
ternary, it's apparently a stronger 1 than a literal 1:

int foo(int);
#define SIZE (1<<10)
#define half(x) (__builtin_constant_p(x) ? (x)>>1 : foo(x))
int bla[half(SIZE)];
int bla2[1 ? 123 : foo(3)+2];

on godbolt.org, gcc 4.1 and gcc4.4 are perfectly happy with this, but
newer gccs complain

  error: variably modified 'bla2' at file scope.

Argh.

> I suspect using the __is_constexpr() trick would make it rather more
> technically correct, but would actually generate much worse code.
> 
> Because it would make us do that dynamic "__ilog2_uXX()" function call
> even when you have a compile-time constant value, if it wasn't
> actually a constant expression (ie a constant argument passed to an
> inline function, for example).

It's a bit ugly, but I suppose one could keep a __builtin_constant_p()
check in the not-ICE-branch, so there's really three cases (ICE,
constant due to various optimizations, really not known at compile
time). But don't we use gcc's intrinsics for fls when available, so that
gcc should be able to know the semantics of __builtin_fls(some-constant)
and hence evaluate that itself at compile time?

Somewhat unrelated, we should probably move the __is_constexpr helper
from kernel.h to some more basic compiler header, to avoid cyclic header
dependencies.

Rasmus
