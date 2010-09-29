From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA limit
 rather than to max memory
Date: Tue, 28 Sep 2010 22:55:39 -0700
Message-ID: <20100929055539.GA17499@us.ibm.com>
References: <4ca2688f17705a0195@agluck-desktop.sc.intel.com>
 <20100928225936.GA8993@us.ibm.com>
 <987664A83D2D224EAE907B061CE93D5301605546A7@orsmsx505.amr.corp.intel.com>
 <20100929004213.GA9978@us.ibm.com>
 <987664A83D2D224EAE907B061CE93D530160554805@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D530160554805@orsmsx505.amr.corp.intel.com>
Sender: linux-next-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Luck, Tony [tony.luck@intel.com] wrote:
> >What is the USB host controller's PCI device and vendor IDs? I see
> >ehci-ps3.c  and ohci-ps3.c setting it to DMA_BIT_rMASK(32). That may
> >present another bug???
> e
> I have a pair of ehci devices:
> 
> 00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2 (prog-if 20 [EHCI])
>         Subsystem: Platform Technologies, Inc. Device 6249
> 
> 00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1 (prog-if 20 [EHCI])
>         Subsystem: Device 2920:0034
> 
> >I don't know USB much, but someone seems to be lying that they can't do
> >DMA beyond 4GB!
> 
> The drivers may be confused about this.  ia64 systems support DMA to
> all addresses - either because they have an IOMMU that makes DMA
> possible to any address, or because they use swiotlb to pretend
> that they can.

That makes sense! This patch should work and considers the above
behaviour just as the old code. Please revert the commit and apply this
patch instead. Please let me know if this works.


block: set the bounce_pfn to the actual DMA limit rather than to max memory

The bounce_pfn of the request queue in 64 bit systems is set to the
current max_low_pfn. Adding more memory later makes this incorrect.
Memory allocated beyond this boot time max_low_pfn appear to require
bounce buffers (bounce buffers are actually not allocated but used in
calculating segments that may result in "over max segments limit"
errors).

Signed-off-by: Malahal Naineni (malahal@us.ibm.com)

diff -r 09daf852c1c5 block/blk-settings.c
--- a/block/blk-settings.c	Thu Sep 09 12:10:43 2010 -0700
+++ b/block/blk-settings.c	Tue Sep 28 22:43:40 2010 -0700
@@ -214,7 +214,7 @@ void blk_queue_bounce_limit(struct reque
 	 */
 	if (b_pfn < (min_t(u64, 0xffffffffUL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
-	q->limits.bounce_pfn = max_low_pfn;
+	q->limits.bounce_pfn = max(max_low_pfn, b_pfn);
 #else
 	if (b_pfn < blk_max_low_pfn)
 		dma = 1;
