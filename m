From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [29/82] x86_64: Rename IOMMU option, fix help and mark option embedded.
Date: Sun, 25 Jun 2006 17:22:23 +0200
Message-ID: <200606251722.23294.ak@suse.de>
References: <449C852C.mailCZT11F9YB@suse.de> <20060624231433.GA24862@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:51344 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751432AbWFYPWf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 11:22:35 -0400
In-Reply-To: <20060624231433.GA24862@devserv.devel.redhat.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: torvalds@osdl.org, discuss@x86-64.org, akpm@osdl.org, markh@osdl.org, linux-scsi@vger.kernel.org, axboe@suse.de

On Sunday 25 June 2006 01:14, Alan Cox wrote:
> On Sat, Jun 24, 2006 at 02:19:56AM +0200, Andi Kleen wrote:
> > To my astonishment I discovered the aacraid driver tests this
> > symbol directly. This looks quite broken to me - it's an internal
> > implementation detail of the PCI DMA API. Can the maintainer
> > please clarify what this test was intended to do? 
> 
> Shouldn't be to your astonishment, you were involved in the process

Can't remember sorry.

> Older aacraid hardware cannot address the 3-4GB range where the iommu
> remaps pages. As the PCI DMA implementation for the x86-64 is flawed and
> doesn't support any nice way to deal with this via swiotlb instead the
> driver handles it internally.

Then you should just force a low bounce pfn < 0xfffffff for the block device - 
then the block layer  should use GFP_DMA bouncing.

-Andi

