From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] 2.6.0 aacraid driver update
Date: 27 Aug 2003 15:43:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061995388.22721.34.camel@dhcp23.swansea.linux.org.uk>
References: <1061567229.2067.15.camel@markh1.pdx.osdl.net>
	 <20030822171600.A19262@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:44448 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S263415AbTH0Ony (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2003 10:43:54 -0400
In-Reply-To: <20030822171600.A19262@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Gwe, 2003-08-22 at 17:16, Christoph Hellwig wrote:
> > -	u32 			SavedIrql;     	/* Previous IRQL when the spin lock is taken */
> > +	unsigned long		SavedIrql;     	/* Previous IRQL when the spin lock is taken */
> 
> This is still broken.  you must not store irq flags in structures but
> have to restore them in the same function you take them in, otherwise things
> like the irq window on sparc32 can fuck up.  Also it's really confusing.

Sparc isnt supported. Also last time I checked this field was no longer
in use. I've just not had time to remove it yet.

> > +			if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
> > +				pci_set_dma_mask(dev, 0x7FFFFFFFULL);
> > +			else
> > +				pci_set_dma_mask(dev, 0xFFFFFFFFULL);
> 
> Please check the return value.

Good point. I forgot that.

