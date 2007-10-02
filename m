From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Mon, 1 Oct 2007 19:39:02 -0600
Message-ID: <20071002013902.GP12049@parisc-linux.org>
References: <20070925142157B.tomof@acm.org> <20070926160558.GA10819@suse.de> <1191281770.3530.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42863 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbXJBBjE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2007 21:39:04 -0400
Content-Disposition: inline
In-Reply-To: <1191281770.3530.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg KH <gregkh@suse.de>, FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, Oct 01, 2007 at 07:36:10PM -0400, James Bottomley wrote:
> One possibility we could do is to add a
> 
> struct dma_device {
> 	struct device dev;
> 	u64 dma_mask;
> 	u64 coherent_dma_mask;
> 	unsigned int max_segment_size;
> 	/* plus any other DMA parameters */
> };
> 
> but then every bus that can do DMA would need to include a struct
> dma_device instead of the struct device they do now.  Then the IOMMU
> would know it could cast out from struct device to struct dma_device,
> but this would be a lot of work to thread through the current
> infrastructure.

If we're going to do this, then we should go further and include:
 - unsigned int irq
 - struct resources (how many?)
 - struct list_head        dma_pools

dma_device might not be the right name.  Really, we're talking about
'internal' device types (EISA, PCI, GSC, Zorro, ...) as opposed to
external like usb.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
