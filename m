From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH] block: set the bounce_pfn to the actual DMA limit
 rather than to max memory
Date: Tue, 28 Sep 2010 21:47:00 -0700
Message-ID: <987664A83D2D224EAE907B061CE93D530160554805@orsmsx505.amr.corp.intel.com>
References: <4ca2688f17705a0195@agluck-desktop.sc.intel.com>
 <20100928225936.GA8993@us.ibm.com>
 <987664A83D2D224EAE907B061CE93D5301605546A7@orsmsx505.amr.corp.intel.com>
 <20100929004213.GA9978@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20100929004213.GA9978@us.ibm.com>
Content-Language: en-US
Sender: linux-next-owner@vger.kernel.org
To: Malahal Naineni <malahal@us.ibm.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>What is the USB host controller's PCI device and vendor IDs? I see
>ehci-ps3.c  and ohci-ps3.c setting it to DMA_BIT_MASK(32). That may
>present another bug???

I have a pair of ehci devices:

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2 (prog-if 20 [EHCI])
        Subsystem: Platform Technologies, Inc. Device 6249

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1 (prog-if 20 [EHCI])
        Subsystem: Device 2920:0034

>I don't know USB much, but someone seems to be lying that they can't do
>DMA beyond 4GB!

The drivers may be confused about this.  ia64 systems support DMA to
all addresses - either because they have an IOMMU that makes DMA
possible to any address, or because they use swiotlb to pretend
that they can.

You are probably correct that this is the real source of the bug.
Your patch just stopped the block layer from hiding the problem.

>How much memory you have on the system? This probably doesn't matter but
>good to know.

This is a little machine - just 16GB.

-Tony
