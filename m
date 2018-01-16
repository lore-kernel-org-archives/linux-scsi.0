From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH] mptfusion: use strlcpy() instead of strncpy()
Date: Tue, 16 Jan 2018 19:06:57 +0800
Message-ID: <5eb35077-8bc9-f5af-1446-00279d8644df@huawei.com>
References: <1515757619-29651-1-git-send-email-wangxiongfeng2@huawei.com>
 <CAHp75VctB9uRwvEQH=GW65gfOOn4-P7UKNa2OxM0pO7qQjOZrw@mail.gmail.com>
 <1515769770.3124.3.camel@wdc.com>
 <CAHp75Vc3exQ=EoiQSPqcECF8rkp=yDkP30SCytveQx94bSJK=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4226 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751124AbeAPLHO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jan 2018 06:07:14 -0500
In-Reply-To: <CAHp75Vc3exQ=EoiQSPqcECF8rkp=yDkP30SCytveQx94bSJK=g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "arnd@arndb.de" <arnd@arndb.de>



On 2018/1/16 3:34, Andy Shevchenko wrote:
> On Fri, Jan 12, 2018 at 5:09 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>> On Fri, 2018-01-12 at 15:45 +0200, Andy Shevchenko wrote:
>>> On Fri, Jan 12, 2018 at 1:46 PM,  Wang <wangxiongfeng2@huawei.com> wrote:
> 
>>> This one is false positive.
> 
> 
>>>> +       strlcpy (karg.name, ioc->name, MPT_MAX_NAME);
>>>> +       strlcpy (karg.product, ioc->prod_name, MPT_PRODUCT_LENGTH);
>>>
>>> These two as well.
>>
>> But using strlcpy() makes the code easier to read.
> 
> This is another story, not mentioned in the original commit message.
> 
>> Xiongfeng, if you want to continue with this patch, please change the third
>> argument of all strlcpy() calls into a sizeof() expression. That make the
>> code easier to verify.
>>
>>>> -       strncpy(karg.serial_number, " ", 24);
>>>> +       strlcpy(karg.serial_number, " ", 24);
>>>
>>> This one is interesting indeed.
>>> Though the fix would be rather something like
>>>
>>> memset(&karg.serial_number, " ", 24); // leave 24 for best performance of memset
>>> karg.serial_number[24-1] = '\0';
>>
>> Does performance really matter in this context?
> 
> Nope, but still good to understand this aspect. On some architectures
> unaligned access is expensive.
> 
>> How about the following instead:
>>
>> snprintf(karg.serial_number, sizeof(karg.serial_number), "%*s", (int)(karg.serial_number) - 1, "");
> 
> ...and you is talking about "easy to read"?!
> 
> So, my view on the patch is:
> 1) fix a real issue w/o touching everything around;


> 2) (optionally) move to strlcpy() with a correct selling point.
> 

The code is right. There are no issues. It's just that the new compiler gcc-8 prints the warnings.
I use strlcpy() instead of strncpy() just to suppress the warnings.

Thanks,
Xiongfeng
