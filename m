From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3 1/6] ilog2: create truly constant version for sparse
Date: Wed, 18 Apr 2018 14:21:14 -0700
Message-ID: <CA+55aFyLUNQUrog0MU3a07jesimiDYQ2HQc2UpAKG1SEOK23Xw@mail.gmail.com>
References: <20180417233511.6573-1-mwilck@suse.com> <20180417233511.6573-2-mwilck@suse.com>
 <CA+55aFxLY2=RVAD8m-3bf4vKWpPKWSmjN_tLVWwb4Y7w81UTbA@mail.gmail.com> <1524039174.3028.24.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524039174.3028.24.camel@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 18, 2018 at 1:12 AM, Martin Wilck <mwilck@suse.com> wrote:
>
> No, it doesn't (gcc 7.3.0). -> https://paste.opensuse.org/27471594
> It doesn't even warn on an expression like this:
>
>   #define SIZE (1<<10)
>   static int foo[ilog2(SIZE)];

Ok, I think this is the "random gcc versions act differently" issue.

Sometimes __builtin_constant_p() to a ternary operation acts as a
constant expression, and sometimes it doesn't.

Oh well.

> sparse 0.5.2 doesn't warn about that either.

Yeah, sparse doesn't get picky about "constant value" vs "constant
expression" normally. But some things do use the strict form, and
array index expressions is one of those cases.

> So maybe I was wrong, and this is actually a false positive in sparse.

No, it's correct, it's just that the semantics of exactly when
something is considered constant are a bit fluid.

> Do you want me to convert the patch to your approach anyway?

I suspect using the __is_constexpr() trick would make it rather more
technically correct, but would actually generate much worse code.

Because it would make us do that dynamic "__ilog2_uXX()" function call
even when you have a compile-time constant value, if it wasn't
actually a constant expression (ie a constant argument passed to an
inline function, for example).

So I guess your patch is fine, but I also wonder if we should just
default sparse to allow the good old non-strict "constant values are
ok" for indexes.

And turn on strict mode only with -pedantic or something.

                 Linus
