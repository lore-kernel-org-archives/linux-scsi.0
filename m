From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RFC/RFT PATCH 0/5] mm: ARM nobootmem and few dma_mask fixes
Date: Fri, 26 Jul 2013 12:28:26 -0400
Message-ID: <51F2A3AA.4060801@ti.com>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
 <20130726151021.GU24642@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20130726151021.GU24642@n2100.arm.linux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Friday 26 July 2013 11:10 AM, Russell King - ARM Linux wrote:
> On Fri, Jul 12, 2013 at 05:48:09PM -0400, Santosh Shilimkar wrote:
>> The series is an attempt to move ARM port to NO_BOOTMEM. As discussed
>> on list NO_BOOTMEM move needed updates to max*pfn meaning to be maximum
>> PFNs but that breaks the dma_mask for few block layer drivers since
>> ARM start of physical memory is not PFN0 unlike most of the architectures.
>> Some more read on it is here:
>> 	http://lwn.net/Articles/543408/
>> 	http://lwn.net/Articles/543424/
>>
>> To address this issue, we introduce generic dma_max_pfn() helper which
>> can be overridden from the architectures.
>> 	
>> Another intention behind move to nobootmem is also to convert ARM to
>> switch to memblock and getting rid of bootmem allocator dependency which
>> don't work for LPAE machines which has physical memory starting beyond
>> 4 GB boundary. It needs changes to core kernel and also a new memblock
>> API. More on this can be found here:
>> 	https://lkml.org/lkml/2013/6/29/77
>>
>> I have been trying to cook up these patches with kind help from Russell
>> and we know series don't solve all the dma_mask bad assumptions. But at
>> least I am hoping that it can get the ball rolling.	
>>
>> Comments/testing help is welcome !!
> 
> As this is related to some of the cleanup of dma_mask which I've been
> doing, I think it may make sense to roll this into one tree.  Any
> objection to that?
> 
> Can we get any acks on this stuff from Jens and Jejb etc - especially
> for the bits which touch block/ and for the scsi bits as these are
> touching other subsystems.  (oddly, linux-scsi wasn't on the original
> mail for this series summary.)
> 
Sorry I missed the scsi lists on the summary patch.

While browsing the code I found another spot in mmc layer which
needs fixing. The patch is at the end of the email with Chris
and linux-mmc cc'ed here.

Regards,
Santosh

>From 06a27a784a1fd86bf22adf1b247ac82a7c21d46b Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Fri, 19 Jul 2013 21:36:46 -0400
Subject: [PATCH] mmc: Use dma_max_pfn(dev) helper for bounce_limit
 calculations

DMA bounce limit is the maximum direct DMA'able memory beyond which
bounce buffers has to be used to perform dma operations. MMC queue layer
relies on dma_mask but its calculation is based on max_*pfn which
don't have uniform meaning across architectures. So make use of
dma_max_pfn() which is expected to return the DMAable maximum pfn
value across architectures.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Chris Ball <cjb@laptop.org>

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/mmc/card/queue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index fa9632e..357bbc5 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -15,6 +15,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -196,7 +197,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	struct mmc_queue_req *mqrq_prev = &mq->mqrq[1];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
-		limit = *mmc_dev(host)->dma_mask;
+		limit = dma_max_pfn(mmc_dev(host)) << PAGE_SHIFT;
 
 	mq->card = card;
 	mq->queue = blk_init_queue(mmc_request_fn, lock);
-- 
1.7.9.5
