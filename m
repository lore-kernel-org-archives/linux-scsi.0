From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: mpt sets 64bit consistent mask yet requires mapping in same 4 GB chunk?!?
Date: Wed, 18 Feb 2004 17:09:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040219010939.GB502690@sgi.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703EF93EA@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:55893 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S267314AbUBSBK5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 20:10:57 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703EF93EA@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Alex Williamson <alex.williamson@hp.com>, jbarnes@sgi.com, bjorn.helgaas@hp.com, willy@debian.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Wed, Feb 18, 2004 at 07:03:47PM -0500, Moore, Eric Dean wrote:
> Jeremy - thanks for your reply. Just wanted to clarify
> if this would work on your system:
> 
> 
> mptbase_probe(pdev,id) {
> 
> u64 mask64 = 0xFFFFFFFFFFFFFFFF;
> u32 mask32 = 0xFFFFFFFF;
> 
> pci_enable_device(pdev);
> 
> ioc->pcidev32 = pdev;
> ioc->pcidev64 = pdev;
> 
> r = pci_set_dma_mask(ioc->pcidev64, mask64 );
> r = pci_set_consistent_dma_mask(ioc->pcidev64, mask64 );
> r = pci_set_dma_mask(ioc->pcidev32, mask32 );
> r = pci_set_consistent_dma_mask(ioc->pcidev32, mask32 );
> 
> /* use 
>  * ioc->pcidev32 
>  * for the three fifo memory allocations for < 4gb  
>  *
>  * use
>  * ioc->pcidev64 
>  * for all other allocations
>  */
> 
> }

I don't think so, for two reasons.

The first is that we require 64 bit PCI addresses for all PCI-X devices.

The second is that if I understand your pseudo-code correctly, the pcidev64
and pcidev32 pointers are both pointing to the same struct pci_dev, which
would mean that the second pci_set_consistent_dma_mask call would override
the first.

Hopefully it's not too much effort to change it to a single consistent
allocation for all three FIFO chunks.  I don't see another way around
this.

jeremy
