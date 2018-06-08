From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH] scsi: ipr: fix build on 32-bit architectures
Date: Fri, 8 Jun 2018 12:10:35 -0400
Message-ID: <830c2468-293c-385c-0b91-c96bedae4d4a@codeaurora.org>
References: <20180608144617.2900894-1-arnd@arndb.de>
 <04758f3a-0f03-4fe9-6eb8-10ebb2430a98@codeaurora.org>
 <CAK8P3a2=uMFOcw=gZGuwsH+V=1DMXGgxf_hZHw3tMJD1nDdG2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2=uMFOcw=gZGuwsH+V=1DMXGgxf_hZHw3tMJD1nDdG2Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>
List-Id: linux-scsi@vger.kernel.org

On 6/8/2018 11:47 AM, Arnd Bergmann wrote:
> On Fri, Jun 8, 2018 at 5:27 PM, Sinan Kaya <okaya@codeaurora.org> wrote:
>> +Will,
>>

[snip]

>> So, it is difficult to judge how this barrier has been used without an
>> expert opinion.
>>
>> Changing
>>
>> wmb() + writel()
>>
>> to
>>
>> wmb() + writel_relaxed()
>>
>> is safer than dropping the wmb() altogether.
> 
> If the wmb() was not just about the writeq() then I would argue your patch
> description was misleading. We certainly shouldn't replace random writeq()
> calls with writeq_relaxed() just because we can show that the driver has
> a barrier in front of it.
> 
> In particular, the ipr_mask_and_clear_interrupts() function has multiple
> writeq() or writel() calls, and even a readl() and your patch only changes
> one of them, which seems like a rather pointless exercise as the function
> still fully synchronizes the I/O multiple times.

You are right, I only searched wmb() + writel() combinations. Changed only
the places where I found issues. 

We were given a direction to go to eliminating barriers direction as you already
noted. 

I just wanted to highlight the difficulty of wholesale dropping of wmb() without
careful inspection. [1] [2]

We certainly need a better patch that covers all use cases. Your patch is
a step in the good direction. We just need some attention from the maintainer
that we are not actually breaking something.

> 
>> Will Deacon should probably look at why writeq_relaxed is missing on some ARM
>> arches too.
>>
>> Drivers shouldn't worry about write derivatives.
> 
> This driver defines writeq() itself for architectures that don't have it, but
> it doesn't define writeq_relaxed() and doesn't include
> linux/io-64-nonatomic-lo-hi.h
> or linux/io-64-nonatomic-hi-lo.h. It seems that it needs a different behavior
> from all other drivers here, storing the upper 32 bits into the lower
> address and
> the lower 32 bits into the upper address.

I don't think there is a consensus about using these includes in the community.
I bumped into this issue before and came up with an include you pointed.
I didn't get too much enthusiasm from the maintainer.

Why are we pushing the responsibility into the drivers? I'd think that architecture
should take care of this. Is there a portability issue that I'm missing from some
architecture I never heart of? (I work on Little-Endian machines most of the time)

[1] https://patchwork.kernel.org/patch/10301861/
[2] https://www.mail-archive.com/netdev@vger.kernel.org/msg227443.html

> 
>          Arnd
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
