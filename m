From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH -mm 0/11] fix iommu sg merging problem
Date: Wed, 24 Oct 2007 23:32:11 +0900
Message-ID: <20071024233419K.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
	<471F2F42.1080806@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:51036 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324AbXJXOcx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 10:32:53 -0400
In-Reply-To: <471F2F42.1080806@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, greg@kroah.com, muli@il.ibm.com, paulus@samba.org, tony.luck@intel.com, davem@davemloft.net, kyle@parisc-linux.org, aacraid@adaptec.com, fujita.tomonori@lab.ntt.co.jp

On Wed, 24 Oct 2007 07:40:50 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > IOMMUs merges scatter/gather segments without considering a low level
> > driver's restrictions. The problem is that IOMMUs can't access to the
> > limitations because they are in request_queue.
> > 
> > This patchset introduces a new structure, device_dma_parameters,
> > including dma information. A pointer to device_dma_parameters is added
> > to struct device. The bus specific structures (like pci_dev) includes
> > device_dma_parameters. Low level drivers can use dma_set_max_seg_size
> > to tell IOMMUs about the restrictions.
> > 
> > We can move more dma stuff in struct device (like dma_mask) to struct
> > device_dma_parameters later (needs some cleanups before that).
> > 
> > This includes patches for all the IOMMUs that could merge sg (x86_64,
> > ppc, IA64, alpha, sparc64, and parisc) though only the ppc patch was
> > tested. The patches for other IOMMUs are only compile tested.
> > 
> > Thanks to everyone for the comments on the previous submission
> > to linux-scsi.
> > 
> > This is against 2.6.24-rc1. The same patchset is also available:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git iommu-sg-fixes
> 
> Are you interested in collecting patches to libata that eliminate the 
> hand-rolled S/G splitting?  e.g. now ata_fill_sg() and mv_fill_sg() can 
> be made much more efficient.

Yeah, but ATA has the segment boundary limit too. It's much more
tricky than the segment size limit. It makes the IOMMU free space
managemet complicated.


> Again, thanks for doing this!  It's been needed for a long time.

My pleasure.
