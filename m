From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Thu, 05 Mar 2015 14:36:44 +0100
Message-ID: <54F85BEC.3010406@redhat.com>
References: <1422882086-1863-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44606 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbbCENgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 08:36:48 -0500
Received: by wivr20 with SMTP id r20so6800051wiv.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Mar 2015 05:36:47 -0800 (PST)
In-Reply-To: <1422882086-1863-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>



On 02/02/2015 14:01, Christoph Hellwig wrote:
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
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
