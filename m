From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH] scsi: osd_uld: remove an unneeded NULL check
Date: Thu, 23 Mar 2017 21:38:31 +0200
Message-ID: <30405285-8713-5209-5ba6-13f7b4648d89@electrozaur.com>
References: <20170323104142.GD20154@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170323104142.GD20154@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Benny Halevy <bhalevy@primarydata.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/23/2017 12:41 PM, Dan Carpenter wrote:
> We don't call the remove() function unless probe() succeeds so "oud"
> can't be NULL here.  Plus, if it were NULL, we dereference it on the
> next line so it would crash anyway.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Thanks sure!
ACK-by Boaz Harrosh <ooo@electrozaur.com>

> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index 4101c3178411..8b9941a5687a 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -507,10 +507,9 @@ static int osd_remove(struct device *dev)
>  	struct scsi_device *scsi_device = to_scsi_device(dev);
>  	struct osd_uld_device *oud = dev_get_drvdata(dev);
>  
> -	if (!oud || (oud->od.scsi_device != scsi_device)) {
> -		OSD_ERR("Half cooked osd-device %p,%p || %p!=%p",
> -			dev, oud, oud ? oud->od.scsi_device : NULL,
> -			scsi_device);
> +	if (oud->od.scsi_device != scsi_device) {
> +		OSD_ERR("Half cooked osd-device %p, || %p!=%p",
> +			dev, oud->od.scsi_device, scsi_device);
>  	}
>  
>  	cdev_device_del(&oud->cdev, &oud->class_dev);
> 
