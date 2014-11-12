From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: remove scsi_driver owner field
Date: Wed, 12 Nov 2014 12:43:50 -0500
Message-ID: <1415814230.16672.34.camel@localhost.localdomain>
References: <1415813691-4132-1-git-send-email-hch@lst.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbaKLRn4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2014 12:43:56 -0500
In-Reply-To: <1415813691-4132-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Shane M Seymour <shane.seymour@hp.com>

On Wed, 2014-11-12 at 18:34 +0100, Christoph Hellwig wrote:
> The driver core driver structure has grown an owner field and now
> requires it to be set for all modular drivers.  Set it up for
> all scsi_driver instances and get rid of the now superflous
> scsi_driver owner field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Shane M Seymour <shane.seymour@hp.com>
> ---
>  drivers/scsi/ch.c          | 2 +-
>  drivers/scsi/osd/osd_uld.c | 2 +-
>  drivers/scsi/osst.c        | 2 +-
>  drivers/scsi/scsi_scan.c   | 9 ++++-----
>  drivers/scsi/sd.c          | 2 +-
>  drivers/scsi/ses.c         | 2 +-
>  drivers/scsi/sr.c          | 2 +-
>  drivers/scsi/st.c          | 2 +-
>  include/scsi/scsi_driver.h | 1 -
>  9 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index 4f502f9..6bac8a7 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -972,9 +972,9 @@ static int ch_remove(struct device *dev)
>  }
>  
>  static struct scsi_driver ch_template = {
> -	.owner     	= THIS_MODULE,
>  	.gendrv     	= {
>  		.name	= "ch",
> +		.owner	= THIS_MODULE,
>  		.probe  = ch_probe,
>  		.remove = ch_remove,
>  	},
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index 92cdd4b..243eab3 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -540,9 +540,9 @@ static int osd_remove(struct device *dev)
>   */
>  
>  static struct scsi_driver osd_driver = {
> -	.owner			= THIS_MODULE,
>  	.gendrv = {
>  		.name		= osd_name,
> +		.owner		= THIS_MODULE,
>  		.probe		= osd_probe,
>  		.remove		= osd_remove,
>  	}
> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
> index 8c38464..5033223 100644
> --- a/drivers/scsi/osst.c
> +++ b/drivers/scsi/osst.c
> @@ -172,9 +172,9 @@ static int osst_probe(struct device *);
>  static int osst_remove(struct device *);
>  
>  static struct scsi_driver osst_template = {
> -	.owner			= THIS_MODULE,
>  	.gendrv = {
>  		.name		=  "osst",
> +		.owner		= THIS_MODULE,
>  		.probe		= osst_probe,
>  		.remove		= osst_remove,
>  	}
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index d97597e..0cda53a 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1593,16 +1593,15 @@ EXPORT_SYMBOL(scsi_add_device);
>  
>  void scsi_rescan_device(struct device *dev)
>  {
> -	struct scsi_driver *drv;
> -	
>  	if (!dev->driver)
>  		return;
>  
> -	drv = to_scsi_driver(dev->driver);
> -	if (try_module_get(drv->owner)) {
> +	if (try_module_get(dev->driver->owner)) {
> +		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> +
>  		if (drv->rescan)
>  			drv->rescan(dev);
> -		module_put(drv->owner);
> +		module_put(dev->driver->owner);
>  	}
>  }
>  EXPORT_SYMBOL(scsi_rescan_device);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 95bfb7b..2ac603f8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -510,9 +510,9 @@ static const struct dev_pm_ops sd_pm_ops = {
>  };
>  
>  static struct scsi_driver sd_template = {
> -	.owner			= THIS_MODULE,
>  	.gendrv = {
>  		.name		= "sd",
> +		.owner		= THIS_MODULE,
>  		.probe		= sd_probe,
>  		.remove		= sd_remove,
>  		.shutdown	= sd_shutdown,
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 80bfece..b7e79e7 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -693,9 +693,9 @@ static struct class_interface ses_interface = {
>  };
>  
>  static struct scsi_driver ses_template = {
> -	.owner			= THIS_MODULE,
>  	.gendrv = {
>  		.name		= "ses",
> +		.owner		= THIS_MODULE,
>  		.probe		= ses_probe,
>  		.remove		= ses_remove,
>  	},
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 3d5399e..20a1096 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -88,9 +88,9 @@ static struct dev_pm_ops sr_pm_ops = {
>  };
>  
>  static struct scsi_driver sr_template = {
> -	.owner			= THIS_MODULE,
>  	.gendrv = {
>  		.name   	= "sr",
> +		.owner		= THIS_MODULE,
>  		.probe		= sr_probe,
>  		.remove		= sr_remove,
>  		.pm		= &sr_pm_ops,
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index e46e02b2..128d3b5 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -202,9 +202,9 @@ static int do_create_sysfs_files(void);
>  static void do_remove_sysfs_files(void);
>  
>  static struct scsi_driver st_template = {
> -	.owner			= THIS_MODULE,
>  	.gendrv = {
>  		.name		= "st",
> +		.owner		= THIS_MODULE,
>  		.probe		= st_probe,
>  		.remove		= st_remove,
>  	},
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index c2b7598..891a658 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -9,7 +9,6 @@ struct scsi_cmnd;
>  struct scsi_device;
>  
>  struct scsi_driver {
> -	struct module		*owner;
>  	struct device_driver	gendrv;
>  
>  	void (*rescan)(struct device *);

Looks fine.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>



