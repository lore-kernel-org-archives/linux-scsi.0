From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6.0 aacraid driver update
Date: Fri, 22 Aug 2003 10:29:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061573399.2067.65.camel@markh1.pdx.osdl.net>
References: <1061567229.2067.15.camel@markh1.pdx.osdl.net>
	 <20030822171600.A19262@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:31389 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263121AbTHVRaG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 13:30:06 -0400
In-Reply-To: <20030822171600.A19262@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Fri, 2003-08-22 at 09:16, Christoph Hellwig wrote:
> On Fri, Aug 22, 2003 at 08:47:09AM -0700, Mark Haverkamp wrote:
> > --- 1.22/drivers/scsi/scsi_priv.h	Thu Aug  7 05:25:43 2003
> > +++ edited/drivers/scsi/scsi_priv.h	Tue Aug 19 14:51:39 2003
> > @@ -115,8 +115,6 @@
> >  #endif /* CONFIG_PROC_FS */
> >  
> >  /* scsi_scan.c */
> > -int scsi_scan_host_selected(struct Scsi_Host *, unsigned int, unsigned int,
> > -			    unsigned int, int);
> 
> I'm not very happy with exporting this to drivers.  Can you explain the
> code using it a bit?

Sorry, I can't explain it,  this code turned up in the 2.4 version.  I
assume it was added by someone from Adaptec. Although it looks like I
accidentally lost some comments when I brought the code over.  Here it
is, I'll add it back into the function.

		 /*
		  * This deals with new devices that have
		  * appeared. If the device has gone offline, scan_scsis will
		  * also discover this, but we do not want the device to
		  * go away. We need to check the access_count for the
		  * device since we are not wanting the devices to go away.
		  */


> 
> > -	u32 			SavedIrql;     	/* Previous IRQL when the spin lock is taken */
> > +	unsigned long		SavedIrql;     	/* Previous IRQL when the spin lock is taken */
> 
> This is still broken.  you must not store irq flags in structures but
> have to restore them in the same function you take them in, otherwise things
> like the irq window on sparc32 can fuck up. Also it's really confusing.

I'll take a look at this.

> 
> > +#define CONTAINER_TO_BUS(cont)		(0)
> > +#define CONTAINER_TO_TARGET(cont)	((cont))
> > +#define CONTAINER_TO_LUN(cont)		(0)
> 
> why this obsfucation?

Not sure, again this is from the recent 2.4 update.  I could just remove
the macros and plug in the values.

> 
> > -			pci_set_dma_mask(dev, 0xFFFFFFFFULL);
> > +
> > +			if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
> > +				pci_set_dma_mask(dev, 0x7FFFFFFFULL);
> > +			else
> > +				pci_set_dma_mask(dev, 0xFFFFFFFFULL);
> 
> Please check the return value.

I'll check the return value. 

> 
> 
> Also please convert the driver to be hotplug capable while you're
> at it.

Is there a how-to posted somewhere for this?


> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Mark Haverkamp <markh@osdl.org>

