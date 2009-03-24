From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Driver 'sd' needs updating
Date: Tue, 24 Mar 2009 17:45:22 +0200
Message-ID: <49C90012.50009@panasas.com>
References: <20090324141428.31E5118C7A3@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:9494 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754500AbZCXPrB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 11:47:01 -0400
In-Reply-To: <20090324141428.31E5118C7A3@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> If a driver sets blk_queue_prep_rq() it should clean up itself
> and not rely on the bus callbacks to handle this. This removes
> the need to hook into bus->remove() as these should not be used
> at the same time as driver->remove().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

I spoke too soon please see below

> ---
>  drivers/scsi/scsi_lib.c    |    6 ++++++
>  drivers/scsi/scsi_sysfs.c  |   17 -----------------
>  drivers/scsi/sd.c          |    2 ++
>  drivers/scsi/sr.c          |    1 +
>  include/scsi/scsi_driver.h |    1 +
>  5 files changed, 10 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 4b13e36..73df41b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1222,6 +1222,12 @@ int scsi_prep_fn(struct request_queue *q, struct request *req)
>  	return scsi_prep_return(q, req, ret);
>  }
>  
> +void scsi_reset_prep_fn(struct request_queue *q)

Here it is declared void
but

> +{
> +	blk_queue_prep_rq(q, scsi_prep_fn);
> +}
> +EXPORT_SYMBOL(scsi_reset_prep_fn);
> +
>  /*
>   * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
>   * return 0.
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index fa4711d..91482f2 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -420,29 +420,12 @@ static int scsi_bus_resume(struct device * dev)
>  	return err;
>  }
>  
> -static int scsi_bus_remove(struct device *dev)
> -{
> -	struct device_driver *drv = dev->driver;
> -	struct scsi_device *sdev = to_scsi_device(dev);
> -	int err = 0;
> -
> -	/* reset the prep_fn back to the default since the
> -	 * driver may have altered it and it's being removed */
> -	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
> -
> -	if (drv && drv->remove)
> -		err = drv->remove(dev);
> -
> -	return 0;
> -}
> -
>  struct bus_type scsi_bus_type = {
>          .name		= "scsi",
>          .match		= scsi_bus_match,
>  	.uevent		= scsi_bus_uevent,
>  	.suspend	= scsi_bus_suspend,
>  	.resume		= scsi_bus_resume,
> -	.remove		= scsi_bus_remove,
>  };
>  EXPORT_SYMBOL_GPL(scsi_bus_type);
>  
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index aeab5d9..64e88e2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2068,6 +2068,8 @@ static int sd_remove(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
>  
> +	scsi_reset_prep_fn(sdkp->device->request_queue);
> +
>  	device_del(&sdkp->dev);
>  	del_gendisk(sdkp->disk);
>  	sd_shutdown(dev);
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index e7fa3ca..914733a 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -889,6 +889,7 @@ static int sr_remove(struct device *dev)
>  {
>  	struct scsi_cd *cd = dev_get_drvdata(dev);
>  
> +	scsi_reset_prep_fn(cd->device->request_queue);
>  	del_gendisk(cd->disk);
>  
>  	mutex_lock(&sr_ref_mutex);
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index 1f5ca7f..2e22929 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -32,5 +32,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req);
>  int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req);
>  int scsi_prep_state_check(struct scsi_device *sdev, struct request *req);
>  int scsi_prep_return(struct request_queue *q, struct request *req, int ret);
> +int scsi_reset_prep_fn(struct request_queue *);

Here it is returning int.

My FC10 compiler does not like that:
  drivers/scsi/scsi_lib.c:1415: error: conflicting types for 'scsi_reset_prep_fn'
  include/scsi/scsi_driver.h:35: error: previous declaration of 'scsi_reset_prep_fn' was here

>  
>  #endif /* _SCSI_SCSI_DRIVER_H */

I fixed it to be void, will test later

Thanks
Boaz
