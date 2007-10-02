From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Mon, 1 Oct 2007 21:22:48 -0700
Message-ID: <20071002042248.GA23399@suse.de>
References: <20070925142157B.tomof@acm.org> <20070926160558.GA10819@suse.de> <1191281770.3530.24.camel@localhost.localdomain> <20071002013902.GP12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:39307 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbXJBEUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 00:20:05 -0400
Content-Disposition: inline
In-Reply-To: <20071002013902.GP12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, Oct 01, 2007 at 07:39:02PM -0600, Matthew Wilcox wrote:
> On Mon, Oct 01, 2007 at 07:36:10PM -0400, James Bottomley wrote:
> > One possibility we could do is to add a
> > 
> > struct dma_device {
> > 	struct device dev;
> > 	u64 dma_mask;
> > 	u64 coherent_dma_mask;
> > 	unsigned int max_segment_size;
> > 	/* plus any other DMA parameters */
> > };
> > 
> > but then every bus that can do DMA would need to include a struct
> > dma_device instead of the struct device they do now.  Then the IOMMU
> > would know it could cast out from struct device to struct dma_device,
> > but this would be a lot of work to thread through the current
> > infrastructure.

Why not just hang these fields off of a struct device, that way if the
device doesn't/can't do dma, it only has the "loss" of a single pointer,
not all of these fields?

thanks,

greg k-h
