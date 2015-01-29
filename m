From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Thu, 29 Jan 2015 15:09:18 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501291508440.1837-100000@iolanthe.rowland.org>
References: <1422486056-11591-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49811 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754418AbbA2UJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 15:09:19 -0500
In-Reply-To: <1422486056-11591-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>

On Thu, 29 Jan 2015, Christoph Hellwig wrote:

> Lock the device embedded in the scsi_device to protect against
> concurrent calls to ->remove.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_scan.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 983aed1..523faee 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1593,16 +1593,15 @@ EXPORT_SYMBOL(scsi_add_device);
>  
>  void scsi_rescan_device(struct device *dev)
>  {
> -	if (!dev->driver)
> -		return;
> -
> -	if (try_module_get(dev->driver->owner)) {
> +	device_lock(dev);
> +	if (dev->driver && try_module_get(dev->driver->owner)) {
>  		struct scsi_driver *drv = to_scsi_driver(dev->driver);
>  
>  		if (drv->rescan)
>  			drv->rescan(dev);
>  		module_put(dev->driver->owner);
>  	}
> +	device_unlock(dev);
>  }
>  EXPORT_SYMBOL(scsi_rescan_device);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

