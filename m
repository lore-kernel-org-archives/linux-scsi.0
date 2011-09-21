From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [RFC PATCH 3/5] libsas: dynamic queue depth
Date: Wed, 21 Sep 2011 09:17:13 +0800
Message-ID: <2322D79A36774450A5F0769E26A15C6B@usish.com.cn>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6> <20110920221038.1094.7832.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:39668 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1IUBRF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 21:17:05 -0400
In-Reply-To: <20110920221038.1094.7832.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: 'Dave Jiang' <dave.jiang@intel.com>, 'Luben Tuikov' <ltuikov@yahoo.com>, jgarzik@pobox.com, JBottomley@parallels.com, 'Xiangliang Yu' <yuxiangl@marvell.com>, 'Mark Salyzyn' <msalyzyn@us.xyratex.com>, 'Christoph Hellwig' <hch@lst.de>

I suppose to prepare a similar patch, thanks for ding this.
 [RFC PATCH 3/5] libsas: dynamic queue depth
> 
> The queue-depth for libsas-attached devices initializes to 32 and can
> only be increased manually via sysfs to a max of 64, while mpt2sas
> attached devices initialize to 254 and dynamically float via the
> midlayer ->change_queue_depth interface.
> 
> No performance regression was observed with this change on the isci
> driver.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
> Cc: Xiangliang Yu <yuxiangl@marvell.com>
> Cc: Jack Wang <jack_wang@usish.com>
> Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
> Cc: Luben Tuikov <ltuikov@yahoo.com>
> Tested-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_scsi_host.c |   39
> ++++++++++++++++-------------------
>  1 files changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c
> b/drivers/scsi/libsas/sas_scsi_host.c
> index 4c6923c..fe08ef0 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -784,8 +784,7 @@ int sas_target_alloc(struct scsi_target *starget)
>  	return 0;
>  }
> 
> -#define SAS_DEF_QD 32
> -#define SAS_MAX_QD 64
> +#define SAS_DEF_QD 256
> 
>  int sas_slave_configure(struct scsi_device *scsi_dev)
>  {
> @@ -828,31 +827,29 @@ void sas_slave_destroy(struct scsi_device *scsi_dev)
>  		dev->sata_dev.ap->link.device[0].class = ATA_DEV_NONE;
>  }
> 
> -int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth,
> -			   int reason)
> +int sas_change_queue_depth(struct scsi_device *sdev, int depth, int
reason)
>  {
> -	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
> -	int res = min(new_depth, SAS_MAX_QD);
> +	struct domain_device *dev = sdev_to_domain_dev(sdev);
> 
>  	if (dev_is_sata(dev))
> -		return __ata_change_queue_depth(dev->sata_dev.ap, scsi_dev,
> -						new_depth, reason);
> -
> -	if (reason != SCSI_QDEPTH_DEFAULT)
> +		return __ata_change_queue_depth(dev->sata_dev.ap, sdev,
depth,
> +						reason);
> +
> +	switch (reason) {
> +	case SCSI_QDEPTH_DEFAULT:
> +	case SCSI_QDEPTH_RAMP_UP:
> +		if (!sdev->tagged_supported)
> +			depth = 1;
> +		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
depth);
> +		break;
> +	case SCSI_QDEPTH_QFULL:
> +		scsi_track_queue_full(sdev, depth);
> +		break;
> +	default:
>  		return -EOPNOTSUPP;
> -
> -	if (scsi_dev->tagged_supported)
> -		scsi_adjust_queue_depth(scsi_dev,
scsi_get_tag_type(scsi_dev),
> -					res);
> -	else {
> -		sas_printk("device %llx LUN %x queue depth changed to 1\n",
> -			   SAS_ADDR(dev->sas_addr),
> -			   scsi_dev->lun);
> -		scsi_adjust_queue_depth(scsi_dev, 0, 1);
> -		res = 1;
>  	}
> 
> -	return res;
> +	return depth;
>  }
> 
>  int sas_change_queue_type(struct scsi_device *scsi_dev, int qt)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

