From: Andi Kleen <ak@muc.de>
Subject: Re: PATCH: Further aacraid work
Date: Thu, 17 Jun 2004 21:10:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3smcut2z0.fsf@averell.firstfloor.org>
References: <286GI-5y3-11@gated-at.bofh.it> <286Qp-5EU-19@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:64517 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S261875AbUFQTKv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 15:10:51 -0400
In-Reply-To: <286Qp-5EU-19@gated-at.bofh.it> (Anton Blanchard's message of
 "Thu, 17 Jun 2004 17:20:09 +0200")
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: mark_salyzyn@adaptec.com, Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Anton Blanchard <anton@samba.org> writes:

> Please divert some of your anger towards your manufacturer of dodgy
> hardware. Any sane hardware with an IOMMU handles this just fine.
> eg on ppc64 running a disk test:
>
> sg size    in        out
> 1           3      47569
> 2           0       2591
> 3           0       1123
> 4           0        447
> 5           0        429
> ...
> 62       5095          0
> 64      47061          0
>
> The IOMMU is taking 62-64 entry SG lists and producing 1-5 entry lists.

The AMD64 IOMMU could do it too (and the code to do it exists in
2.6). But the problem is that the current IO layer doesn't provide a
sufficient fallback path when this fails. You have to promise in
advance that you can merge and then later it's too late to change your
mind without signalling an IO error.

This is a real problem on AMD64, because IOMMU aperture is relatively
small and can fragment. 

I had a chat with James about this at last year's OLS. The Consensus
was iirc that it needs driver interface changes at least.

If there was a sane fallback path for this I would enable merging
always (and add some fragmentation avoidance algorithms to the 
bitmap allocator to make failure less likely)

It's also a balancing act in terms of performance. The IOMMU setup
is relatively slow (it has to do an PCI config space write and 
an uncached memory access), and it depends on the device if it's 
actually faster to go through the IOMMU. I did some benchmarks
and it seems to help on MPT Fusion controllers, but slows down
ethernet. Most probably we need an driver function call where
the driver can tell the IOMMU layer "I am slow at merging; 
give me merged sg lists and i can handle errors by falling back"

Also of course when the merging is used you will always get
addresses <32bit and can potentially use smaller descriptors.
But again you need fallback, because on AMD64 the IOMMus 
can be quite small and it's possible to overflow them 
in extreme traffic situations.

-Andi

