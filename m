From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH] scsi:NCR5380: remove same check condition in
 NCR5380_select
Date: Fri, 3 Aug 2018 16:19:30 +1200
Message-ID: <6e28be9a-b601-17e2-4a04-9635925e5958@gmail.com>
References: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com>
 <c99a75a2905c1eef50f94ccc0871c36af431e21a.camel@wdc.com>
 <5B627E71.5020600@huawei.com>
 <928ae07a-8c4a-05fc-16af-48fb6e9c341d@gmail.com>
 <alpine.LNX.2.21.1808031148320.16@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1808031148320.16@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: zhong jiang <zhongjiang@huawei.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

Am 03.08.2018 um 14:56 schrieb Finn Thain:
> On Thu, 2 Aug 2018, Michael Schmitz wrote:
>
>>
>> This redundant load of the ICR has been in the driver code for a long
>> time. There's a small chance it is intentional,
>
> Actually, it is intentional.

I had a hunch it might be ...

>
>> so at least minimal testing might be in order.
>>
>
> Minimal testing is almost useless if you are trying to prove the absence
> of race conditions. SCSI arbitration is a race between targets by design;
> so a race between the CPU and the 5380 is going to be hard to observe.

Agreed - I was clearly being too subtle.

>
>> Finn - does the ICR_ARBITRATION_LOST bit have to be cleared by a write
>> to the mode register?
>>
>
> Something like that: the write to the mode register does clear the
> ICR_ARBITRATION_LOST bit, because it clears the MR_ARBITRATE bit.

Yes, but is that the only way the bit can get cleared? Or could the 
first read see the bit set, and the second read (after checking the bus 
data pattern for a higher arbitrating ID) see it cleared? I.e., is that 
bit latched, or does it just reflect current bus status (same as the 
data register)? (I haven't got the datasheet in front of me, so I'm 
guessing here.)

>> In that case, the first load would have been redundant and can be
>> omitted without changing driver behaviour?
>
> This code is a faithful rendition of the arbitration flow chart in the
> datasheet, so even if you are right, I wouldn't want to change the code.

I think that's a pretty clear hint that the 'arbitration lost' condition 
isn't latched. Anyway, we have no hope to demonstrate by testing that 
this patch (or my suggested alternative) does not change driver 
behaviour. No choice but to leave this as-is.

Cheers,

	Michael
