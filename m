From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Fri, 6 Jun 2008 13:44:30 +0900
Message-ID: <20080606134839Z.fujita.tomonori@lab.ntt.co.jp>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
	<20080605220216.GA12927@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52770 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbYFFEod (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2008 00:44:33 -0400
In-Reply-To: <20080605220216.GA12927@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mgross@linux.intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 5 Jun 2008 15:02:16 -0700
mark gross <mgross@linux.intel.com> wrote:

> On Wed, Jun 04, 2008 at 11:47:01PM +0900, FUJITA Tomonori wrote:
> > I resumed the work to make the IOMMU respect drivers' DMA alignment
> > (since I got a desktop box having VT-d). In short, some IOMMUs
> > allocate memory areas spanning driver's segment boundary limit (DMA
> > alignment). It forces drivers to have a workaround to split up scatter
> > entries into smaller chunks again. To remove such work around in
> > drivers, I modified several IOMMUs, X86_64 (Calgary and Gart), Alpha,
> > POWER, PARISC, IA64, SPARC64, and swiotlb.
> > 
> > Now I try to fix Intel IOMMU code, the free space management
> > algorithm.
> > 
> > The major difference between Intel IOMMU code and the others is Intel
> > IOMMU code uses Red Black tree to manage free space while the others
> > use bitmap (swiotlb is the only exception).
> > 
> > The Red Black tree method consumes less memory than the bitmap method,
> > but it incurs more overheads (the RB tree method needs to walk through
> > the tree, allocates a new item, and insert it every time it maps an
> > I/O address). Intel IOMMU (and IOMMUs for virtualization) needs
> > multiple IOMMU address spaces. That's why the Red Black tree method is
> > chosen, I guess.
> > 
> > Half a year ago, I tried to convert POWER IOMMU code to use the Red
> > Black method and saw performance drop:
> > 
> > http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-11/msg00650.html
> > 
> > So I tried to convert Intel IOMMU code to use the bitmap method to see
> > how much I can get.
> > 
> > I didn't see noticable performance differences with 1GbE. So I tried
> > the modified driver of a SCSI HBA that just does memory accesses to
> > emulate the performances of SSD disk drives, 10GbE, Infiniband, etc.
> > 
> > I got the following results with one thread issuing 1KB I/Os:
> > 
> >                     IOPS (I/O per second)
> > IOMMU disabled         145253.1 (1.000)
> > RB tree (mainline)     118313.0 (0.814)
> > Bitmap                 128954.1 (0.887)
> >
> 
> FWIW: You'll see bigger deltas if you boot with intel_iommu=strict, but
> those will be because of waiting on IOMMU hardware to flush caches and
> may further hide effects of gong with a bitmap as opposed to a RB tree.

Yeah, I know. I'll test 'intel_iommu=strict' option next time.

The patch also has 'intel_iommu=strict' option. Wiht it enabled, it
flushes TLB cache every time dma_unmap_* is called as the original
code does.


> > I've attached the patch to modify Intel IOMMU code to use the bitmap
> > method but I have no intention of arguing that Intel IOMMU code
> > consumes more memory for better performance. :) I want to do more
> > performance tests with 10GbE (probably, I have to wait for a server
> > box having VT-d, which is not available on the market now).
> > 
> > As I said, what I want to do now is to make Intel IOMMU code respect
> > drivers' DMA alignment. Well, it's easier to do that if Intel IOMMU
> > uses the bitmap method since I can simply convert the IOMMU code to
> > use lib/iommu-helper but I can modify the RB tree method too.
> >
> 
> I'm going to be out of contact for a few weeks but this work sounds
> interesting.  

Why did you choose the RB tree instead of a traditional bitmap scheme
to manage free space?


> > I'm just interested in other people's opinions on IOMMU
> > implementations, performances, possible future changes for performance
> > improvement, etc.
> > 
> > For further information:
> > 
> > LSF'08 "Storage Track" summary by Grant Grundler:
> > http://iou.parisc-linux.org/lsf2008/SUMMARY-Storage.txt
> > 
> > My LSF'08 slides:
> > http://iou.parisc-linux.org/lsf2008/IO-DMA_Representations-fujita_tomonori.pdf
> > 
> > 
> > Tis patch is against the latst git tree (note that it just converts
> > Intel IOMMU code to use the bitmap. It doesn't make it respect
> > drivers' DMA alignment yet).
> > 
> 
> I'll look closely at your patch later.

Thanks a lot!
