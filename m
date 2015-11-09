From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 3/4] scsi: fix compiler warning for sg
Date: Sun, 8 Nov 2015 20:17:39 -0500
Message-ID: <563FF433.8000308@codeaurora.org>
References: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
 <1446698789-19308-3-git-send-email-okaya@codeaurora.org>
 <CAHp75VfB1ToEZXRbxeWkU7xsWJkMz3v3A1O5QsH9LiiV4Be-iw@mail.gmail.com>
 <563B7180.2000405@codeaurora.org>
 <CAHp75VeVW3KRmCAa0mE4vPVus4Y9iFf0_PhV+kbvUziDWgTaOw@mail.gmail.com>
 <563BA0B3.6080506@codeaurora.org>
 <CAHp75Vfx0eCtP4H9kMPxy4g6UQM5jnBjJ43xnenn+h3N6uyvag@mail.gmail.com>
 <CAHp75VdaeGZ-cD6j4cUc_wdGnGYN2_x6vqua3Xrt2Fi8MGH+tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VdaeGZ-cD6j4cUc_wdGnGYN2_x6vqua3Xrt2Fi8MGH+tQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 11/5/2015 2:56 PM, Andy Shevchenko wrote:
> On Thu, Nov 5, 2015 at 9:31 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>> On Thu, Nov 5, 2015 at 8:32 PM, Sinan Kaya <okaya@codeaurora.org> wrote:
>>> On 11/5/2015 1:07 PM, Andy Shevchenko wrote:
>>
>>> Let's try again.
>>>
>>> static inline u64 mult_frac64(u64 x, u32 numer, u32 denom) {
>>>          u64 rem  = x % denom;
>>>          u64 quot = do_div(x, denom);
>>>          u64 mul = rem * numer;
>>>
>>>          return (quot * numer) + do_div(mul, denom);
>>> }
>>
>> First of all why not to put this to generic header? We have math64.h
>> and kernel.h.
>> Might be a good idea (needs to check current users) to move mult_frac
>> to math64.h.
>>
>> Then, x % y is already a problem. After all, you seems messed quot and
>> remainder.
>>
>> What about something like
>>
>> #if BITS_PER_LONG == 64
>>
>> #define mult_frac64(x,n,d)  mult_frac(x,n,d)
>>
>> #else
>>
>> static inline u64 mult_frac64(u64 x, u32 numer, u32 denom) {
>>          u64 r1 = do_div(x, denom);
>>          u64 r2 = r1 * numer;
>>
>>          do_div(r2, denom);
>>          return (x * numer) + r2;
>> }

I'll use this instead. This is cleaner, scalable and functionally 
correct to the original code. I'll post a patch with this soon.

>>
>> #endif
>>
>> ?
>
> One more look to the users of MULDIV.
>
> They all seems 32 bit for x.
> It means you don't need two do_div()s at all.
>
> Just do something like:
>
> u64 d = x * numer;
> do_div(d, denom);
> return d;
>

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
