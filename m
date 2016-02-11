From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 19/23] scsi_dh: add 'rescan' callback
Date: Thu, 11 Feb 2016 15:27:33 -0500
Message-ID: <1455222453.22112.332.camel@localhost.localdomain>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
	 <1454942086-128704-20-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbcBKU1e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2016 15:27:34 -0500
In-Reply-To: <1454942086-128704-20-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Mon, 2016-02-08 at 15:34 +0100, Hannes Reinecke wrote:
> If a device needs to be rescanned the device_handler might need
> to be rechecked, too.
> So add a 'rescan' callback to the device handler and call it
> upon scsi_rescan_device().

This comment should mention that you have also changed the Unit
Attention handling of ASC/ASCQ 3F 03 INQUIRY DATA HAS CHANGED
to automatically rescan the device (prior to the uevent).

-Ewan

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 8 ++++++++
>  drivers/scsi/scsi_lib.c                    | 1 +
>  drivers/scsi/scsi_scan.c                   | 8 +++++++-
>  include/scsi/scsi_dh.h                     | 1 +
>  4 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index a1db82f..56f8d21 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1038,6 +1038,13 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  
>  }
>  
> +static void alua_rescan(struct scsi_device *sdev)
> +{
> +	struct alua_dh_data *h = sdev->handler_data;
> +
> +	alua_initialize(sdev, h);
> +}
> +
>  /*
>   * alua_bus_attach - Attach device handler
>   * @sdev: device to be attached to
> @@ -1098,6 +1105,7 @@ static struct scsi_device_handler alua_dh = {
>  	.prep_fn = alua_prep_fn,
>  	.check_sense = alua_check_sense,
>  	.activate = alua_activate,
> +	.rescan = alua_rescan,
>  	.set_params = alua_set_params,
>  };
>  
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index fa6b2c4..d46193a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2699,6 +2699,7 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>  		envp[idx++] = "SDEV_MEDIA_CHANGE=1";
>  		break;
>  	case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
> +		scsi_rescan_device(&sdev->sdev_gendev);
>  		envp[idx++] = "SDEV_UA=INQUIRY_DATA_HAS_CHANGED";
>  		break;
>  	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 420239c..97074c9 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -43,6 +43,7 @@
>  #include <scsi/scsi_devinfo.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_transport.h>
> +#include <scsi/scsi_dh.h>
>  #include <scsi/scsi_eh.h>
>  
>  #include "scsi_priv.h"
> @@ -1524,9 +1525,14 @@ EXPORT_SYMBOL(scsi_add_device);
>  
>  void scsi_rescan_device(struct device *dev)
>  {
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +
>  	device_lock(dev);
>  
> -	scsi_attach_vpd(to_scsi_device(dev));
> +	scsi_attach_vpd(sdev);
> +
> +	if (sdev->handler && sdev->handler->rescan)
> +		sdev->handler->rescan(sdev);
>  
>  	if (dev->driver && try_module_get(dev->driver->owner)) {
>  		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
> index 7e184c6..c7bba2b 100644
> --- a/include/scsi/scsi_dh.h
> +++ b/include/scsi/scsi_dh.h
> @@ -71,6 +71,7 @@ struct scsi_device_handler {
>  	int (*activate)(struct scsi_device *, activate_complete, void *);
>  	int (*prep_fn)(struct scsi_device *, struct request *);
>  	int (*set_params)(struct scsi_device *, const char *);
> +	void (*rescan)(struct scsi_device *);
>  };
>  
>  #ifdef CONFIG_SCSI_DH


