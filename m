From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH -mm 0/11] fix iommu sg merging problem
Date: Wed, 24 Oct 2007 15:24:34 +0200
Message-ID: <20071024132434.GZ14671@kernel.dk>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:11884 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbXJXNYi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 09:24:38 -0400
Content-Disposition: inline
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, greg@kroah.com, jeff@garzik.org, muli@il.ibm.com, paulus@samba.org, tony.luck@intel.com, davem@davemloft.net, kyle@parisc-linux.org, aacraid@adaptec.com, fujita.tomonori@lab.ntt.co.jp

On Wed, Oct 24 2007, FUJITA Tomonori wrote:
> IOMMUs merges scatter/gather segments without considering a low level
> driver's restrictions. The problem is that IOMMUs can't access to the
> limitations because they are in request_queue.
> 
> This patchset introduces a new structure, device_dma_parameters,
> including dma information. A pointer to device_dma_parameters is added
> to struct device. The bus specific structures (like pci_dev) includes
> device_dma_parameters. Low level drivers can use dma_set_max_seg_size
> to tell IOMMUs about the restrictions.
> 
> We can move more dma stuff in struct device (like dma_mask) to struct
> device_dma_parameters later (needs some cleanups before that).
> 
> This includes patches for all the IOMMUs that could merge sg (x86_64,
> ppc, IA64, alpha, sparc64, and parisc) though only the ppc patch was
> tested. The patches for other IOMMUs are only compile tested.
> 
> Thanks to everyone for the comments on the previous submission
> to linux-scsi.
> 
> This is against 2.6.24-rc1. The same patchset is also available:

Looks good to me, I think we should get this included sooner rather than
later.

-- 
Jens Axboe

