From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] aacraid: error return checking
Date: Sat, 10 Sep 2005 20:19:25 +0100
Message-ID: <20050910191925.GC3662@infradead.org>
References: <1126212624.7479.23.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:11440 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932127AbVIJTT2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 15:19:28 -0400
Content-Disposition: inline
In-Reply-To: <1126212624.7479.23.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

> @@ -929,9 +932,14 @@
>  	printk(KERN_INFO "Adaptec %s driver (%s)\n",
>  	  AAC_DRIVERNAME, aac_driver_version);
>  
> -	error = pci_module_init(&aac_pci_driver);
> -	if (error)
> +	error = pci_register_driver(&aac_pci_driver);
> +	if (error < 0 || list_empty(&aac_devices)) {
> +		if (error >= 0) {
> +			pci_unregister_driver(&aac_pci_driver);
> +			error = -ENODEV;
> +		}
>  		return error;

The list_empty check is wrong.  I driver should stay loaded even if
no devices have been found.

