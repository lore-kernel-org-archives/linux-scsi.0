From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA limit
 rather than to max memory
Date: Tue, 28 Sep 2010 15:59:36 -0700
Message-ID: <20100928225936.GA8993@us.ibm.com>
References: <4ca2688f17705a0195@agluck-desktop.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:33802 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0I1W7i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2010 18:59:38 -0400
Content-Disposition: inline
In-Reply-To: <4ca2688f17705a0195@agluck-desktop.sc.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, linux-next@vger.kernel.org

Luck, Tony [tony.luck@intel.com] wrote:
> Starting with the next-20100927 tag of linux-next I saw this error
> while booting ia64:
> 
>   Unable to handle kernel NULL pointer dereference (address 0000000000000020)
>   usb-stor-scan[5915]: Oops 8813272891392 [1]
>   Modules linked in: dm_mod usb_storage sg container button usbhid uhci_hcd ehci_hcd usbcore fan processor thermal thermal_sys
> 
>   Pid: 5915, CPU 0, comm:        usb-stor-scan
>   psr : 00001010085a6010 ifs : 8000000000000894 ip  : [<a00000010012a630>]    Not tainted (2.6.36-rc5-generic-smp-next-20100927)
>   ip is at mempool_alloc+0x70/0x200
> 
> The problem was that "page_pool" was NULL, but blk_queue_bounce()
> had decided to use it!  The code in mm/bounce.c looks quite
> fragile here as there are several places where page_pool is used, but
> it is only initialized inside #ifdef CONFIG_HIGHMEM (which is not
> set on ia64).
> 
> Reverting this patch so that the old rules for setting
> q->limits.bounce_pfn are used cures the immediate problem.
> But I think there must be some deeper issues involved.
> 
> I think that reverting means that I take the fast exit
> from blk_queue_bounce():
> 
> 	if (queue_bounce_pfn(q) >= blk_max_pfn)
> 		return;

Let me know if this fixes the problem. Thank you very much.


diff -r 1a48e21f1e50 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Fri Sep 24 09:44:52 2010 -0700
+++ b/drivers/scsi/scsi_lib.c	Tue Sep 28 15:55:10 2010 -0700
@@ -1590,7 +1590,7 @@ static void scsi_request_fn(struct reque
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
 	struct device *host_dev;
-	u64 bounce_limit = 0xffffffff;
+	u64 bounce_limit = BLK_BOUNCE_HIGH;
 
 	if (shost->unchecked_isa_dma)
 		return BLK_BOUNCE_ISA;
