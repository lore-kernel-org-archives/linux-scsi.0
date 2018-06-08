From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH] scsi: ipr: fix build on 32-bit architectures
Date: Fri, 8 Jun 2018 11:27:15 -0400
Message-ID: <04758f3a-0f03-4fe9-6eb8-10ebb2430a98@codeaurora.org>
References: <20180608144617.2900894-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180608144617.2900894-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
List-Id: linux-scsi@vger.kernel.org

+Will,

On 6/8/2018 10:46 AM, Arnd Bergmann wrote:
> Replacing writeq() with writeq_relaxed() doesn't work on many architectures,
> as that variant is not available in general:
> 
> net/Makefile:24: CC cannot link executables. Skipping bpfilter.
> drivers/scsi/ipr.c: In function 'ipr_mask_and_clear_interrupts':
> drivers/scsi/ipr.c:767:3: error: implicit declaration of function 'writeq_relaxed'; did you mean 'writew_relaxed'? [-Werror=implicit-function-declaration]
>    writeq_relaxed(~0, ioa_cfg->regs.set_interrupt_mask_reg);
>    ^~~~~~~~~~~~~~
>    writew_relaxed
> 
> The other issue here is that the patch eliminated the wrong barrier.
> As per a long discussion that followed Sinan's original patch submission,
> the conclusion was that drivers should generally assume that the barrier
> implied by writel() is sufficient for ordering DMA, so this reverts his
> change and instead removes the extraneous wmb() before it, which is no
> longer needed on any architecture now.
> 
> Fixes: 0109a4f2e02d ("scsi: ipr: Eliminate duplicate barriers on weakly-ordered archs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This looks good on paper however we need an input from the driver maintainer
because some drivers like Intel NIC are using write barriers in place of
a SMP barrier + write barrier combination as an optimizatin.

Removing the barrier itself can actually break the driver if SMP barrier is
actually needed instead.

So, it is difficult to judge how this barrier has been used without an
expert opinion.

Changing 

wmb() + writel()

to 

wmb() + writel_relaxed()

is safer than dropping the wmb() altogether.

Will Deacon should probably look at why writeq_relaxed is missing on some ARM
arches too.

Drivers shouldn't worry about write derivatives.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
