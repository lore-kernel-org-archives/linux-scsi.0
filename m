From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] cciss: handler scsi_add_host failure
Date: Wed, 5 Jan 2005 20:49:18 +0100
Message-ID: <20050105194918.GA6393@lst.de>
References: <20050103132431.GA22309@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:65492 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262138AbVAETtf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2005 14:49:35 -0500
Content-Disposition: inline
In-Reply-To: <20050103132431.GA22309@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com, iss_storagedev@hp.com
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

Mike, is this patch okay?

On Mon, Jan 03, 2005 at 02:24:31PM +0100, Christoph Hellwig wrote:
> --- 1.23/drivers/block/cciss_scsi.c	2004-10-14 16:15:25 +02:00
> +++ edited/drivers/block/cciss_scsi.c	2004-12-31 14:42:51 +01:00
> @@ -691,14 +691,13 @@ static int
>  cciss_scsi_detect(int ctlr)
>  {
>  	struct Scsi_Host *sh;
> +	int error;
>  
>  	sh = scsi_host_alloc(&cciss_driver_template, sizeof(struct ctlr_info *));
>  	if (sh == NULL)
> -		return 0;
> -
> +		goto fail;
>  	sh->io_port = 0;	// good enough?  FIXME, 
>  	sh->n_io_port = 0;	// I don't think we use these two...
> -
>  	sh->this_id = SELF_SCSI_ID;  
>  
>  	((struct cciss_scsi_adapter_data_t *) 
> @@ -706,10 +705,16 @@ cciss_scsi_detect(int ctlr)
>  	sh->hostdata[0] = (unsigned long) hba[ctlr];
>  	sh->irq = hba[ctlr]->intr;
>  	sh->unique_id = sh->irq;
> -	scsi_add_host(sh, &hba[ctlr]->pdev->dev); /* XXX handle failure */
> +	error = scsi_add_host(sh, &hba[ctlr]->pdev->dev);
> +	if (error)
> +		goto fail_host_put;
>  	scsi_scan_host(sh);
> -
>  	return 1;
> +
> + fail_host_put:
> +	scsi_host_put(sh);
> + fail:
> +	return 0;
>  }
>  
>  static void __exit cleanup_cciss_module(void);
---end quoted text---
