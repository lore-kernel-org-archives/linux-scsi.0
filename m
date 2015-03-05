From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Thu, 5 Mar 2015 05:33:13 -0800
Message-ID: <20150305133313.GA25602@infradead.org>
References: <1422882086-1863-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50708 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbbCENdO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 08:33:14 -0500
Content-Disposition: inline
In-Reply-To: <1422882086-1863-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <famz@redhat.com>

Any chance to get reviews for this series?  Also we should at least
expedite this first patch into 4.0-rc as it fixes scanning races
in virtio_scsi.

On Mon, Feb 02, 2015 at 02:01:24PM +0100, Christoph Hellwig wrote:
> Lock the device embedded in the scsi_device to protect against
> concurrent calls to ->remove.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
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
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
