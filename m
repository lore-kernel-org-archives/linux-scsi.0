From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: ipr: fix build on 32-bit architectures
Date: Fri, 8 Jun 2018 17:47:18 +0200
Message-ID: <CAK8P3a2=uMFOcw=gZGuwsH+V=1DMXGgxf_hZHw3tMJD1nDdG2Q@mail.gmail.com>
References: <20180608144617.2900894-1-arnd@arndb.de> <04758f3a-0f03-4fe9-6eb8-10ebb2430a98@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <04758f3a-0f03-4fe9-6eb8-10ebb2430a98@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 8, 2018 at 5:27 PM, Sinan Kaya <okaya@codeaurora.org> wrote:
> +Will,
>
> On 6/8/2018 10:46 AM, Arnd Bergmann wrote:
>> Replacing writeq() with writeq_relaxed() doesn't work on many architectures,
>> as that variant is not available in general:
>>
>> net/Makefile:24: CC cannot link executables. Skipping bpfilter.
>> drivers/scsi/ipr.c: In function 'ipr_mask_and_clear_interrupts':
>> drivers/scsi/ipr.c:767:3: error: implicit declaration of function 'writeq_relaxed'; did you mean 'writew_relaxed'? [-Werror=implicit-function-declaration]
>>    writeq_relaxed(~0, ioa_cfg->regs.set_interrupt_mask_reg);
>>    ^~~~~~~~~~~~~~
>>    writew_relaxed
>>
>> The other issue here is that the patch eliminated the wrong barrier.
>> As per a long discussion that followed Sinan's original patch submission,
>> the conclusion was that drivers should generally assume that the barrier
>> implied by writel() is sufficient for ordering DMA, so this reverts his
>> change and instead removes the extraneous wmb() before it, which is no
>> longer needed on any architecture now.
>>
>> Fixes: 0109a4f2e02d ("scsi: ipr: Eliminate duplicate barriers on weakly-ordered archs")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> This looks good on paper however we need an input from the driver maintainer
> because some drivers like Intel NIC are using write barriers in place of
> a SMP barrier + write barrier combination as an optimizatin.
>
> Removing the barrier itself can actually break the driver if SMP barrier is
> actually needed instead.
>
> So, it is difficult to judge how this barrier has been used without an
> expert opinion.
>
> Changing
>
> wmb() + writel()
>
> to
>
> wmb() + writel_relaxed()
>
> is safer than dropping the wmb() altogether.

If the wmb() was not just about the writeq() then I would argue your patch
description was misleading. We certainly shouldn't replace random writeq()
calls with writeq_relaxed() just because we can show that the driver has
a barrier in front of it.

In particular, the ipr_mask_and_clear_interrupts() function has multiple
writeq() or writel() calls, and even a readl() and your patch only changes
one of them, which seems like a rather pointless exercise as the function
still fully synchronizes the I/O multiple times.

> Will Deacon should probably look at why writeq_relaxed is missing on some ARM
> arches too.
>
> Drivers shouldn't worry about write derivatives.

This driver defines writeq() itself for architectures that don't have it, but
it doesn't define writeq_relaxed() and doesn't include
linux/io-64-nonatomic-lo-hi.h
or linux/io-64-nonatomic-hi-lo.h. It seems that it needs a different behavior
from all other drivers here, storing the upper 32 bits into the lower
address and
the lower 32 bits into the upper address.

         Arnd
