From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] 2.6.0 aacraid driver update
Date: Fri, 22 Aug 2003 11:58:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030822155807.GB31693@gtf.org>
References: <1061567229.2067.15.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([63.247.75.124]:12205 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S263516AbTHVP6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 11:58:08 -0400
Content-Disposition: inline
In-Reply-To: <1061567229.2067.15.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Fri, Aug 22, 2003 at 08:47:09AM -0700, Mark Haverkamp wrote:
>  			pci_set_master(dev);
> -			pci_set_dma_mask(dev, 0xFFFFFFFFULL);
> +
> +			if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
> +				pci_set_dma_mask(dev, 0x7FFFFFFFULL);
> +			else
> +				pci_set_dma_mask(dev, 0xFFFFFFFFULL);

Need to check return value of pci_set_dma_mask(), it can fail.


>  			host_ptr = scsi_register( template, sizeof(struct aac_dev) );
> +			if (host_ptr == (struct Scsi_Host *)0) {
> +				continue;

style:  no need for cast, just check for NULL.  or even
	if (!host_ptr)


