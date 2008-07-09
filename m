From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 09 Jul 2008 21:22:16 +0200
Message-ID: <1215631336.18506.15.camel@localhost.localdomain>
References: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl>
	 <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
	 <4561.1215612914@redhat.com>  <20080709164929.799e4e05@the-village.bc.nu>
	 <1215630402.18506.10.camel@localhost.localdomain>
	 <1215630817.3444.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4793 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYGITWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 15:22:21 -0400
In-Reply-To: <1215630817.3444.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Howells <dhowells@redhat.com>, akpm@linux-foundation.org, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2008-07-09 at 14:13 -0500, James Bottomley wrote:
> On Wed, 2008-07-09 at 21:06 +0200, Miquel van Smoorenburg wrote:
> > On Wed, 2008-07-09 at 16:49 +0100, Alan Cox wrote:
> > > On Wed, 09 Jul 2008 15:15:14 +0100
> > > David Howells <dhowells@redhat.com> wrote:
> > > 
> > > > Miquel van Smoorenburg <miquels@cistron.nl> wrote:
> > > > Maybe, but have you looked at i2o_cfg_passthru()?  Take this, for example:
> > > > 
> > > > 			/* Allocate memory for the transfer */
> > > > 			p = kmalloc(sg_size, GFP_KERNEL);
> > > > 			...
> > > > 			//TODO 64bit fix
> > > > 			sg[i].addr_bus = virt_to_bus(p);
> > > > 
> > > > That looks distinctly dodgy.  virt_to_bus() returns a 64-bit address, and as
> > > 
> > > Agreed - stick | GFP_DMA32 on the end then ;)
> > 
> > GFP_DMA32 doesn't work with kmalloc(), you need dma_alloc_coherent() or
> > pci_alloc_consistent() [here, i2o_dma_alloc() ]
> 
> Yes it does ... it was specifically designed for it.  GFP_DMA32 was
> introduced to allow this type of thing to happen (in the old days most
> drivers were allowed to assume kmalloc would return memory whose
> physical address was < 4GB; GFP_DMA32 allows that to continue while
> allowing kmalloc to stray beyond 4GB physical).

If you use alloc_pages(), yes. But not for kmalloc(). There are no
general GFP_DMA32 slabs.

Mike.

