From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] arcmsr: code cleanup and some corrections
Date: Fri, 18 Feb 2011 10:04:16 +0900
Message-ID: <20110218100400A.fujita.tomonori@lab.ntt.co.jp>
References: <4D53F7EF.70003@redhat.com>
	<6BCF37FA033449599C8CB43E2D84A0B6@arecaaebe11fae>
	<4D5D3941.2090407@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52007 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab1BRBEj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2011 20:04:39 -0500
In-Reply-To: <4D5D3941.2090407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com
Cc: nick.cheng@areca.com.tw, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Thu, 17 Feb 2011 16:05:37 +0100
Tomas Henzl <thenzl@redhat.com> wrote:

> the discussion is mostly if 'dma_alloc_coherent' 
> ...
> dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
> ...
> returns a page address - dma_coherent with last, I think five bits, zeroed.
> Could you help us with that?

Documentation/DMA-API-HOWTO.txt is not clear enough?

=
dma_alloc_coherent returns two values: the virtual address which you
can use to access it from the CPU and dma_handle which you pass to the
card.

The cpu return address and the DMA bus master address are both
guaranteed to be aligned to the smallest PAGE_SIZE order which
is greater than or equal to the requested size.  This invariant
exists (for example) to guarantee that if you allocate a chunk
which is smaller than or equal to 64 kilobytes, the extent of the
buffer you receive will not cross a 64K boundary.
