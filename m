From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 3/4] scsi: fix compiler warning for sg
Date: Thu, 5 Nov 2015 13:32:19 -0500
Message-ID: <563BA0B3.6080506@codeaurora.org>
References: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
 <1446698789-19308-3-git-send-email-okaya@codeaurora.org>
 <CAHp75VfB1ToEZXRbxeWkU7xsWJkMz3v3A1O5QsH9LiiV4Be-iw@mail.gmail.com>
 <563B7180.2000405@codeaurora.org>
 <CAHp75VeVW3KRmCAa0mE4vPVus4Y9iFf0_PhV+kbvUziDWgTaOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VeVW3KRmCAa0mE4vPVus4Y9iFf0_PhV+kbvUziDWgTaOw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 11/5/2015 1:07 PM, Andy Shevchenko wrote:
>> OK, I didn't know that we had such a macro. To make this look like the other
>> >macro, I can do this.
>> >
>> >static inline u64 mult_frac64(u64 x, u32 numer, u32 denom)
>> >{
>> >         u64 quot;
>> >         u64 rem  = x % denom;
>> >         u64 rem2;
>> >
>> >         quot = x;
>> >         do_div(quot, denom);
>> >
>> >         rem2 = rem * numer;
>> >         do_div(rem2, denom);
>> >
>> >         return (quot * numer) + rem2;
>> >}
> Might be I did a wrong smaple, but do_div() returns two values actually.
> You perhaps overlooked it and thus wrote something redundant above.
>

OK, I was looking at example usages in the kernel. The ones I looked 
always used the first argument as an input & output parameter. I got 
nervous about overwriting something.

void __ndelay(unsigned long long nsecs)
{
	u64 end;

	nsecs <<= 9;
	do_div(nsecs, 125);
...
}

Let's try again.

static inline u64 mult_frac64(u64 x, u32 numer, u32 denom) {
	u64 rem  = x % denom;
	u64 quot = do_div(x, denom);
	u64 mul = rem * numer;
	
	return (quot * numer) + do_div(mul, denom);
}

I'll do a s/MULDIV/mult_frac64/g to address Timur's concern.

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
