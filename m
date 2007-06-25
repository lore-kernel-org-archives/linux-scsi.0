From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sr: fix error handling in module_init
Date: Mon, 25 Jun 2007 20:30:05 +0100
Message-ID: <20070625193005.GA25736@infradead.org>
References: <20070625153933.GA14464@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54053 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbXFYTaI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2007 15:30:08 -0400
Content-Disposition: inline
In-Reply-To: <20070625153933.GA14464@APFDCB5C>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

On Tue, Jun 26, 2007 at 12:39:33AM +0900, Akinobu Mita wrote:
> Sweep registered blkdev when scsi_register_driver has failed.
> 
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> Index: 2.6-rc/drivers/scsi/sr.c
> ===================================================================
> --- 2.6-rc.orig/drivers/scsi/sr.c
> +++ 2.6-rc/drivers/scsi/sr.c
> @@ -885,7 +885,11 @@ static int __init init_sr(void)
>  	rc = register_blkdev(SCSI_CDROM_MAJOR, "sr");
>  	if (rc)
>  		return rc;
> -	return scsi_register_driver(&sr_template.gendrv);
> +	rc = scsi_register_driver(&sr_template.gendrv);
> +	if (rc)
> +		unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
> +
> +	return rc;

Looks good.
