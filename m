From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Fri, 30 Jan 2015 00:11:37 +0100
Message-ID: <54CABE29.5080909@redhat.com>
References: <1422486056-11591-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42259 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbbA2XLm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 18:11:42 -0500
Received: by mail-wi0-f172.google.com with SMTP id h11so33623944wiw.5
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2015 15:11:41 -0800 (PST)
In-Reply-To: <1422486056-11591-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>



On 29/01/2015 00:00, Christoph Hellwig wrote:
> Lock the device embedded in the scsi_device to protect against
> concurrent calls to ->remove.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I wonder if this makes this problem: https://lkml.org/lkml/2015/1/5/9 go
away.

Paolo

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
> 
