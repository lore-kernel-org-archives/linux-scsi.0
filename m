From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] qla1280: user pci_map_single
Date: Fri, 18 Feb 2005 11:21:31 +0100
Message-ID: <20050218102131.GA2941@lst.de>
References: <20050210160026.GB8743@lst.de> <yq03bvunqr3.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from verein.lst.de ([213.95.11.210]:36760 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261329AbVBRKVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 05:21:35 -0500
Content-Disposition: inline
In-Reply-To: <yq03bvunqr3.fsf@jaguar.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Fri, Feb 18, 2005 at 04:48:00AM -0500, Jes Sorensen wrote:
> Christoph,
> 
> When pci_map_page was originally introduced it was meant to deprecate
> pci_map_single, at least thats what my memory tells me.

No, it's for rather different uses.  pci_map_page would be nice to get
rid of in favour of pci_map_sg OTOH..

> If pci_map_single is suddenly recommended again we can change it back
> to that, but I don't really see the gain.

it's a micro-speedup by avoiding totally useless address arithmetics.
You first convert a buffer to page + offset and then it needs to be
converted back, e.g. in include/asm-ia64/dma-mapping.h:

#define dma_map_page(dev, pg, off, size, dir)			\
        dma_map_single(dev, page_address(pg) + (off), (size), (dir))

(pci_map_page is mapped to dma_map_page)

