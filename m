From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 3/4] scsi: fix compiler warning for sg
Date: Thu, 5 Nov 2015 21:56:42 +0200
Message-ID: <CAHp75VdaeGZ-cD6j4cUc_wdGnGYN2_x6vqua3Xrt2Fi8MGH+tQ@mail.gmail.com>
References: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
	<1446698789-19308-3-git-send-email-okaya@codeaurora.org>
	<CAHp75VfB1ToEZXRbxeWkU7xsWJkMz3v3A1O5QsH9LiiV4Be-iw@mail.gmail.com>
	<563B7180.2000405@codeaurora.org>
	<CAHp75VeVW3KRmCAa0mE4vPVus4Y9iFf0_PhV+kbvUziDWgTaOw@mail.gmail.com>
	<563BA0B3.6080506@codeaurora.org>
	<CAHp75Vfx0eCtP4H9kMPxy4g6UQM5jnBjJ43xnenn+h3N6uyvag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Vfx0eCtP4H9kMPxy4g6UQM5jnBjJ43xnenn+h3N6uyvag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 5, 2015 at 9:31 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Thu, Nov 5, 2015 at 8:32 PM, Sinan Kaya <okaya@codeaurora.org> wrote:
>> On 11/5/2015 1:07 PM, Andy Shevchenko wrote:
>
>> Let's try again.
>>
>> static inline u64 mult_frac64(u64 x, u32 numer, u32 denom) {
>>         u64 rem  = x % denom;
>>         u64 quot = do_div(x, denom);
>>         u64 mul = rem * numer;
>>
>>         return (quot * numer) + do_div(mul, denom);
>> }
>
> First of all why not to put this to generic header? We have math64.h
> and kernel.h.
> Might be a good idea (needs to check current users) to move mult_frac
> to math64.h.
>
> Then, x % y is already a problem. After all, you seems messed quot and
> remainder.
>
> What about something like
>
> #if BITS_PER_LONG == 64
>
> #define mult_frac64(x,n,d)  mult_frac(x,n,d)
>
> #else
>
> static inline u64 mult_frac64(u64 x, u32 numer, u32 denom) {
>         u64 r1 = do_div(x, denom);
>         u64 r2 = r1 * numer;
>
>         do_div(r2, denom);
>         return (x * numer) + r2;
> }
>
> #endif
>
> ?

One more look to the users of MULDIV.

They all seems 32 bit for x.
It means you don't need two do_div()s at all.

Just do something like:

u64 d = x * numer;
do_div(d, denom);
return d;

-- 
With Best Regards,
Andy Shevchenko
