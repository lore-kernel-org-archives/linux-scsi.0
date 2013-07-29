From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RFC/RFT PATCH 0/5] mm: ARM nobootmem and few dma_mask fixes
Date: Mon, 29 Jul 2013 09:26:44 -0400
Message-ID: <51F66D94.9060706@ti.com>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com> <20130726151021.GU24642@n2100.arm.linux.org.uk> <51F2A3AA.4060801@ti.com> <20130729111503.GG24642@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20130729111503.GG24642@n2100.arm.linux.org.uk>
Sender: linux-mmc-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chris Ball <cjb@laptop.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Monday 29 July 2013 07:15 AM, Russell King - ARM Linux wrote:
> On Fri, Jul 26, 2013 at 12:28:26PM -0400, Santosh Shilimkar wrote:
>> On Friday 26 July 2013 11:10 AM, Russell King - ARM Linux wrote:
>>> On Fri, Jul 12, 2013 at 05:48:09PM -0400, Santosh Shilimkar wrote:
>>>> The series is an attempt to move ARM port to NO_BOOTMEM. As discussed
>>>> on list NO_BOOTMEM move needed updates to max*pfn meaning to be maximum
>>>> PFNs but that breaks the dma_mask for few block layer drivers since
>>>> ARM start of physical memory is not PFN0 unlike most of the architectures.
>>>> Some more read on it is here:
>>>> 	http://lwn.net/Articles/543408/
>>>> 	http://lwn.net/Articles/543424/
>>>>
>>>> To address this issue, we introduce generic dma_max_pfn() helper which
>>>> can be overridden from the architectures.
>>>> 	
>>>> Another intention behind move to nobootmem is also to convert ARM to
>>>> switch to memblock and getting rid of bootmem allocator dependency which
>>>> don't work for LPAE machines which has physical memory starting beyond
>>>> 4 GB boundary. It needs changes to core kernel and also a new memblock
>>>> API. More on this can be found here:
>>>> 	https://lkml.org/lkml/2013/6/29/77
>>>>
>>>> I have been trying to cook up these patches with kind help from Russell
>>>> and we know series don't solve all the dma_mask bad assumptions. But at
>>>> least I am hoping that it can get the ball rolling.	
>>>>
>>>> Comments/testing help is welcome !!
>>>
>>> As this is related to some of the cleanup of dma_mask which I've been
>>> doing, I think it may make sense to roll this into one tree.  Any
>>> objection to that?
>>>
>>> Can we get any acks on this stuff from Jens and Jejb etc - especially
>>> for the bits which touch block/ and for the scsi bits as these are
>>> touching other subsystems.  (oddly, linux-scsi wasn't on the original
>>> mail for this series summary.)
>>>
>> Sorry I missed the scsi lists on the summary patch.
>>
>> While browsing the code I found another spot in mmc layer which
>> needs fixing. The patch is at the end of the email with Chris
>> and linux-mmc cc'ed here.
> 
> Would you mind putting them all in the patch system, I can add the acks
> should anyone supply them later, and I'll repost them along with my set
> of dma-mask patches.  Thanks.
> 
Done.
7794/1, 7795/1, 7796/1, 7797/1, 7798/1, 7799/1

Didn't know how to get XXXX/1,2,3,4... pushed into the tracker.
BTW, I have also pushed the patched on my git tree branch [1] just
in case you or some one needs it.

Regards,
Santosh
[1] git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
3.12/nobootmem_n_dma-mask

