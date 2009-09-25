From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/4] usb-storage: Associate the name of the interface
 with the scsi host
Date: Fri, 25 Sep 2009 10:29:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0909251028510.23021-100000@netrider.rowland.org>
References: <20090924221911.GC7943@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:33743 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751858AbZIYO3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2009 10:29:40 -0400
In-Reply-To: <20090924221911.GC7943@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Thu, 24 Sep 2009, Matthew Wilcox wrote:

> From: Matthew Wilcox <willy@linux.intel.com>
> 
> Instead of reporting "SCSI emulation for USB Mass Storage devices",
> report "usb-storage 1-4:1.0".
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

> ---
>  drivers/usb/storage/scsiglue.c |    3 ++-
>  drivers/usb/storage/usb.c      |    2 ++
>  drivers/usb/storage/usb.h      |    1 +
>  3 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index cfa26d5..e5e6df3 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -73,7 +73,8 @@
>  
>  static const char* host_info(struct Scsi_Host *host)
>  {
> -	return "SCSI emulation for USB Mass Storage devices";
> +	struct us_data *us = host_to_us(host);
> +	return us->scsi_name;
>  }
>  
>  static int slave_alloc (struct scsi_device *sdev)
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index 8060b85..39d3e54 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -929,6 +929,8 @@ int usb_stor_probe2(struct us_data *us)
>  	result = usb_stor_acquire_resources(us);
>  	if (result)
>  		goto BadDevice;
> +	snprintf(us->scsi_name, sizeof(us->scsi_name), "usb-storage %s",
> +					dev_name(&us->pusb_intf->dev));
>  	result = scsi_add_host(us_to_host(us), &us->pusb_intf->dev);
>  	if (result) {
>  		printk(KERN_WARNING USB_STORAGE
> diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
> index 2609efb..6971713 100644
> --- a/drivers/usb/storage/usb.h
> +++ b/drivers/usb/storage/usb.h
> @@ -132,6 +132,7 @@ struct us_data {
>  	/* SCSI interfaces */
>  	struct scsi_cmnd	*srb;		 /* current srb		*/
>  	unsigned int		tag;		 /* current dCBWTag	*/
> +	char			scsi_name[32];	 /* scsi_host name	*/
>  
>  	/* control and bulk communications data */
>  	struct urb		*current_urb;	 /* USB requests	 */

