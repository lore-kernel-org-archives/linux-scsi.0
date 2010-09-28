From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA limit rather than to max memory
Date: Tue, 28 Sep 2010 15:13:35 -0700
Message-ID: <4ca2688f17705a0195@agluck-desktop.sc.intel.com>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Malahal Naineni <malahal@us.ibm.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Starting with the next-20100927 tag of linux-next I saw this error
while booting ia64:

  Unable to handle kernel NULL pointer dereference (address 0000000000000020)
  usb-stor-scan[5915]: Oops 8813272891392 [1]
  Modules linked in: dm_mod usb_storage sg container button usbhid uhci_hcd ehci_hcd usbcore fan processor thermal thermal_sys

  Pid: 5915, CPU 0, comm:        usb-stor-scan
  psr : 00001010085a6010 ifs : 8000000000000894 ip  : [<a00000010012a630>]    Not tainted (2.6.36-rc5-generic-smp-next-20100927)
  ip is at mempool_alloc+0x70/0x200

The problem was that "page_pool" was NULL, but blk_queue_bounce()
had decided to use it!  The code in mm/bounce.c looks quite
fragile here as there are several places where page_pool is used, but
it is only initialized inside #ifdef CONFIG_HIGHMEM (which is not
set on ia64).

Reverting this patch so that the old rules for setting
q->limits.bounce_pfn are used cures the immediate problem.
But I think there must be some deeper issues involved.

I think that reverting means that I take the fast exit
from blk_queue_bounce():

	if (queue_bounce_pfn(q) >= blk_max_pfn)
		return;

which is probably just avoiding the problem, rather than
doing the right thing.

-Tony
