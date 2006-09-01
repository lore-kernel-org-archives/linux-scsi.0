From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] sd: fix cache flushing on module removal (and	individual
 device removal)
Date: Fri, 01 Sep 2006 11:02:07 +0200
Message-ID: <44F7F70F.4010000@s5r6.in-berlin.de>
References: <1157058484.3666.5.camel@mulgrave.il.steeleye.com> <1157062522.3666.10.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:35502 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1750958AbWIAJGN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Sep 2006 05:06:13 -0400
In-Reply-To: <1157062522.3666.10.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
[...]
> --- linux-2.6.orig/drivers/scsi/scsi.c
> +++ linux-2.6/drivers/scsi/scsi.c
> @@ -835,14 +835,14 @@ EXPORT_SYMBOL(scsi_track_queue_full);
>   */
>  int scsi_device_get(struct scsi_device *sdev)
>  {
> -	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
> +	if (sdev->sdev_state == SDEV_DEL)
>  		return -ENXIO;
>  	if (!get_device(&sdev->sdev_gendev))
>  		return -ENXIO;
> -	if (!try_module_get(sdev->host->hostt->module)) {
> -		put_device(&sdev->sdev_gendev);
> -		return -ENXIO;
> -	}
> +	/* We can fail this if we're doing SCSI operations
> +	 * from module exit (like cache flush) */
> +	try_module_get(sdev->host->hostt->module);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(scsi_device_get);
> @@ -857,7 +857,10 @@ EXPORT_SYMBOL(scsi_device_get);
>   */
>  void scsi_device_put(struct scsi_device *sdev)
>  {
> -	module_put(sdev->host->hostt->module);
> +	/* The module refcount will be zero if scsi_device_get()
> +	 * was called from a module removal routine */
> +	if (likely(module_refcount(sdev->host->hostt->module) != 0))
> +		module_put(sdev->host->hostt->module);
>  	put_device(&sdev->sdev_gendev);
>  }
>  EXPORT_SYMBOL(scsi_device_put);

Somehow the (void)try_module_get(...) looks dangerous to me. Is it
really safe to always ignore failures to get the module? Why would we
want to ignore failures? Couldn't there be border cases where a
module_getter/_putter in a concurrent code path disturbs
scsi_device_get/_put's underlying assumptions?
-- 
Stefan Richter
-=====-=-==- =--= ----=
http://arcgraph.de/sr/
