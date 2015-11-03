From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] string_helpers: fix precision loss for some inputs
Date: Tue, 03 Nov 2015 14:54:19 -0800
Message-ID: <1446591259.6440.52.camel@HansenPartnership.com>
References: <1446582810.6440.36.camel@HansenPartnership.com>
	 <1446585708.6440.47.camel@HansenPartnership.com>
	 <87d1vqd945.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87d1vqd945.fsf@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-11-03 at 23:13 +0100, Rasmus Villemoes wrote:
> On Tue, Nov 03 2015, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > From: James Bottomley <JBottomley@Odin.com>
> >
> > It was noticed that we lose precision in the final calculation for some
> > inputs.  The most egregious example is size=3000 blk_size=1900 in units of 10
> > should yield 5.70 MB but in fact yields 3.00 MB (oops). This is because the
> > current algorithm doesn't correctly account for all the remainders in the
> > logarithms.  Fix this by doing a correct calculation in the remainders based
> > on napier's algorithm.  Additionally, now we have the correct result, we have
> > to account for arithmetic rounding because we're printing 3 digits of
> > precision.  This means that if the fourth digit is five or greater, we have to
> > round up, so add a section to ensure correct rounding.  Finally account for
> > all possible inputs correctly, including zero for block size.
> >
> > Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Cc: stable@vger.kernel.org	# delay backport by two months for testing
> > Fixes: b9f28d863594c429e1df35a0474d2663ca28b307
> > Signed-off-by: James Bottomley <JBottomley@Odin.com>
> >
> > --
> >
> > v2: updated with a recommendation from Rasmus Villemoes to truncate the
> > initial precision at just under 32 bits
> >
> > diff --git a/lib/string_helpers.c b/lib/string_helpers.c
> > index 5939f63..363faca 100644
> > --- a/lib/string_helpers.c
> > +++ b/lib/string_helpers.c
> > @@ -43,38 +43,40 @@ void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
> >  		[STRING_UNITS_10] = 1000,
> >  		[STRING_UNITS_2] = 1024,
> >  	};
> > -	int i, j;
> > -	u32 remainder = 0, sf_cap, exp;
> > +	static const unsigned int rounding[] = { 500, 50, 5, 0};
> 
> j necessarily ends up being 0, 1 or 2. Any reason to include the last entry?

No reason beyond a vague worry someone might try to increase the printed
precision by one digit.

> > +
> > +	while (blk_size >= UINT_MAX)
> >  		i++;
> > -	}
> >  
> > -	exp = divisor[units] / (u32)blk_size;
> > -	/*
> > -	 * size must be strictly greater than exp here to ensure that remainder
> > -	 * is greater than divisor[units] coming out of the if below.
> > -	 */
> > -	if (size > exp) {
> > -		remainder = do_div(size, divisor[units]);
> > -		remainder *= blk_size;
> > +	while (size >= UINT_MAX)
> >  		i++;
> 
> Please spell it U32_MAX

Why?  there's no reason not to use the arithmetic UINT_MAX here.  Either
works, of course but UINT_MAX is standard.

> . Also, it's not clear why you left out the
> do_divs ;-)

Over reduction.

James


> Rasmus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
