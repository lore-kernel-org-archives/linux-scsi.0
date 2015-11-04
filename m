From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v2] string_helpers: fix precision loss for some inputs
Date: Wed, 04 Nov 2015 10:02:07 +0100
Message-ID: <87vb9icf3k.fsf@rasmusvillemoes.dk>
References: <1446582810.6440.36.camel@HansenPartnership.com>
	<1446585708.6440.47.camel@HansenPartnership.com>
	<87d1vqd945.fsf@rasmusvillemoes.dk>
	<1446591259.6440.52.camel@HansenPartnership.com>
	<874mh2d5qh.fsf@rasmusvillemoes.dk>
	<1446594149.6440.70.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446594149.6440.70.camel@HansenPartnership.com> (James
	Bottomley's message of "Tue, 03 Nov 2015 15:42:29 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 04 2015, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2015-11-04 at 00:26 +0100, Rasmus Villemoes wrote:
>> On Tue, Nov 03 2015, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>> >> Please spell it U32_MAX
>> >
>> > Why?  there's no reason not to use the arithmetic UINT_MAX here.  Either
>> > works, of course but UINT_MAX is standard.
>> 
>> We're dealing with explicitly sized integers
>
> An integer is explicitly sized: it's 32 bits. That's why UINT_MAX is
> a universal constant.

In the Linux universe, yes. It's kind of amusing how you try to argue
based on the UINT_MAX name being (defined in a) standard while at the same
time very much rely on sizeof(int) having a value which is not specified
by the standard. I repeat:

>> U32_MAX is the natural name for the appropriate constant.

(and it's defined right next to UINT_MAX in kernel.h, so it's not like
you'd have to introduce that macro).

>> Also, you could do > U32_MAX instead of >= U32_MAX, but that's unlikely
>> to make any difference (well, except it might generate slightly better
>> code, since it would allow gcc to just test the upper half for being 0,
>> which might be cheaper on some architectures than comparing to a
>> literal).
>
> Heh if we're going to be that concerned about the code generation, then
> we should just tell gcc exactly how to do it instead of hoping it can
> work it out for itself, so
>
> while (blk_size >> 32) {
> ...

Nah, that would still require the compiler to be able to transform that
to the other form, which apparently it isn't. On x86_64, the simplest
is to load U32_MAX once into a register and then do r/r comparisons, but
when it's possible to directly test the upper half (e.g. when the 64 bit
value is represented in a pair of 32 bit registers) that's much
simpler. gcc generates good code for 'blk_size > U32_MAX' on both x86_64
and x86_32, but ends up doing an extra cmp on x86_32 for >=, and ends up
doing mov,shift,test inside the loop on x86_64 for 'blk_size >> 32'.

Rasmus
