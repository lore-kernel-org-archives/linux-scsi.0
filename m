From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.0 aacraid driver update
Date: Fri, 22 Aug 2003 17:16:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030822171600.A19262@infradead.org>
References: <1061567229.2067.15.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:32018 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263557AbTHVQQC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 12:16:02 -0400
Content-Disposition: inline
In-Reply-To: <1061567229.2067.15.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Fri, Aug 22, 2003 at 08:47:09AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Fri, Aug 22, 2003 at 08:47:09AM -0700, Mark Haverkamp wrote:
> --- 1.22/drivers/scsi/scsi_priv.h	Thu Aug  7 05:25:43 2003
> +++ edited/drivers/scsi/scsi_priv.h	Tue Aug 19 14:51:39 2003
> @@ -115,8 +115,6 @@
>  #endif /* CONFIG_PROC_FS */
>  
>  /* scsi_scan.c */
> -int scsi_scan_host_selected(struct Scsi_Host *, unsigned int, unsigned int,
> -			    unsigned int, int);

I'm not very happy with exporting this to drivers.  Can you explain the
code using it a bit?

> -	u32 			SavedIrql;     	/* Previous IRQL when the spin lock is taken */
> +	unsigned long		SavedIrql;     	/* Previous IRQL when the spin lock is taken */

This is still broken.  you must not store irq flags in structures but
have to restore them in the same function you take them in, otherwise things
like the irq window on sparc32 can fuck up.  Also it's really confusing.

> +#define CONTAINER_TO_BUS(cont)		(0)
> +#define CONTAINER_TO_TARGET(cont)	((cont))
> +#define CONTAINER_TO_LUN(cont)		(0)

why this obsfucation?

> -			pci_set_dma_mask(dev, 0xFFFFFFFFULL);
> +
> +			if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
> +				pci_set_dma_mask(dev, 0x7FFFFFFFULL);
> +			else
> +				pci_set_dma_mask(dev, 0xFFFFFFFFULL);

Please check the return value.


Also please convert the driver to be hotplug capable while you're
at it.
