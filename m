From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Areca RAID driver remaining items?
Date: Fri, 24 Feb 2006 09:50:41 +0100
Message-ID: <1140771042.2874.10.camel@laptopd505.fenrus.org>
References: <1140458552.3495.26.camel@mentorng.gurulabs.com>
	 <20060220182045.GA1634@infradead.org>
	 <001401c63779$12e49aa0$b100a8c0@erich2003>
	 <20060222145733.GC16269@infradead.org>
	 <00dc01c63842$381f9a30$b100a8c0@erich2003>
	 <1140683157.2972.6.camel@laptopd505.fenrus.org>
	 <001901c6385e$9aee7d40$b100a8c0@erich2003>
	 <1140688569.4672.24.camel@laptopd505.fenrus.org>
	 <005a01c6386f$84b30d50$b100a8c0@erich2003>
	 <1140696452.4672.43.camel@laptopd505.fenrus.org>
	 <004701c638e7$31d9dc80$b100a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:6588 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932111AbWBXIuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 03:50:46 -0500
In-Reply-To: <004701c638e7$31d9dc80$b100a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: "\"\"\"Christoph Hellwig\"\"\"" <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, oliver@neukum.org

On Fri, 2006-02-24 at 10:08 +0800, erich wrote:
> Dear Arjan van de Ven,
> 
> I would keep dma_alloc_coherent usage.
> 
> > [Exception is that you can say that you are ok with a bigger mask for
> > this type of memory, but just don't do that if you're not]
> 
> Should I remove "pci_set_dma_mask(pci_device, DMA_64BIT_MASK)" for this 
> case?

no what you have is correct; the function to change this behavior is
called 
pci_set_consistent_dma_mask()

pci_set_dma_mask() sets the mask for the "data" (eg dynamic mappings via
pci_map_single and pci_map_page and such). pci_set_consistent_dma_mask()
sets the mask for all the "consistent" allocators.

so again your code is fine as is. If you want to explicitly set that
mask to DMA_32BIT_MASK as documentation that you REALLY want it to be 32
bit, that is probably fine too, but not really needed.

Greetings,
   Arjan van de Ven

