From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH: Further aacraid work
Date: Thu, 17 Jun 2004 14:32:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617133239.GA31936@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD23FF9@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:42155 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266482AbUFQNcl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 09:32:41 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FD23FF9@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Alan Cox <alan@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 17, 2004 at 08:53:36AM -0400, Salyzyn, Mark wrote:
> I *must* admit that the driver functions perfectly in other systems with
> more than 4G of memory; however we *are* having troubles specifically
> with AMD64 systems with more than 4G of memory in 2.6 kernels (the issue
> does not occur on 2.4 kernels). I have yet to investigate why this
> specific problem exists.

So what exactly is the firmware doing with this information?  What I
expected is that if the memory is smaller 4GB it's just use 32bit
descriptors.  If you want to keep that heck do the check _before_ setting
the dma_mask.  If you have a > 32bit dma mask but the firmware can't deal
with the high bits in the dma address actually set it's a bug.  It won't
show up on PCs but pretty much on any complex architecture with an iommu
(like AMD64)

> One would expect that if we erroneously got the memory model wrong (ie,
> <4GB of memory, one slice at 0-2G, another slice at 4G-6G) that the 32
> dma limit would protect us from functional problems in this delicate
> area but with a performance hit resulting from the scsi layer providing
> bounce buffers. Ideally we would like to have a mechanism to know if the
> DMAable area is limited to a 32 bit address space in order to take
> advantage of the more efficient FIB utilization.

Again, memory model doesn't matter.  For many plattforms dma address
aren't memory addresses.

