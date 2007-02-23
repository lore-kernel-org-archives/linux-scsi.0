From: Greg KH <gregkh@suse.de>
Subject: Re: [Patch 2/2] cciss: supercedes add shutdown support (replaces reboot notifier)
Date: Fri, 23 Feb 2007 13:32:36 -0800
Message-ID: <20070223213236.GA3535@suse.de>
References: <20070223204239.GA10570@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48906 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbXBWVeK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Feb 2007 16:34:10 -0500
Content-Disposition: inline
In-Reply-To: <20070223204239.GA10570@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Feb 23, 2007 at 02:42:39PM -0600, Mike Miller (OS Dev) wrote:
> Patch 2/2
> 
> This patch supercedes yesterdays cciss-shutdown patch. The primary difference is
> removing __devexit from cciss_remove_one. Instead of create another function I'd
> rather use the code that was intended to perform the cleanup and cache flush. I've
> tested as a loadable module and statically linked without error.
> Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> ------------------------------------------------------------------------------------------
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 9d84ab3..b16f48c 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3404,7 +3404,7 @@ #endif
>  	return -1;
>  }
>  
> -static void __devexit cciss_remove_one(struct pci_dev *pdev)
> +static void cciss_remove_one(struct pci_dev *pdev)
>  {
>  	ctlr_info_t *tmp_ptr;
>  	int i, j;
> @@ -3428,9 +3428,10 @@ static void __devexit cciss_remove_one(s
>  	memset(flush_buf, 0, 4);
>  	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
>  			      TYPE_CMD);
> -	if (return_code != IO_OK) {
> -		printk(KERN_WARNING "Error Flushing cache on controller %d\n",
> -		       i);
> +	if (return_code == IO_OK) {
> +		printk(KERN_WARNING "Completed flushing cache on controller %d\n", i);

Why do you want the world to know this on every shutdown?

At the least, use dev_warn() to show the proper device and driver that
this is happening to, but does it really need to go to the warning log?
It sounds like a normal operation to me.  How about dev_dbg() instead?

thanks,

greg k-h
