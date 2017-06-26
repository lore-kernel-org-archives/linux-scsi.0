From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sd: add support for TCG OPAL self encrypting disks
Date: Mon, 26 Jun 2017 13:10:47 +0200
Message-ID: <20170626111047.GA16273@lst.de>
References: <20170619122646.32666-1-hch@lst.de> <20170619122646.32666-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170619122646.32666-2-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ping?

On Mon, Jun 19, 2017 at 02:26:46PM +0200, Christoph Hellwig wrote:
> Just wire up the generic TCG OPAL infrastructure to the SCSI disk driver
> and the Security In/Out commands.
> 
> Note that I don't know of any actual SCSI disks that do support TCG OPAL,
> but this is required to support ATA disks through libata.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/ata/libata-scsi.c  |  3 +++
>  drivers/scsi/sd.c          | 53 +++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/sd.h          |  2 ++
>  include/scsi/scsi_device.h |  1 +
>  4 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 0f788ad6f2f6..3e5ca2e894a4 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1321,6 +1321,9 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
>  
>  	blk_queue_flush_queueable(q, false);
>  
> +	if (dev->flags & ATA_DFLAG_TRUSTED)
> +		sdev->security_supported = 1;
> +
>  	dev->sdev = sdev;
>  	return 0;
>  }
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f9d1432d7cc5..5d32fd7d3a3e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -50,6 +50,7 @@
>  #include <linux/string_helpers.h>
>  #include <linux/async.h>
>  #include <linux/slab.h>
> +#include <linux/sed-opal.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pr.h>
>  #include <linux/t10-pi.h>
> @@ -643,6 +644,26 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
>  	mutex_unlock(&sd_ref_mutex);
>  }
>  
> +#ifdef CONFIG_BLK_SED_OPAL
> +static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
> +		size_t len, bool send)
> +{
> +	struct scsi_device *sdev = data;
> +	u8 cdb[12] = { 0, };
> +	int ret;
> +
> +	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
> +	cdb[1] = secp;
> +	put_unaligned_be16(spsp, &cdb[2]);
> +	put_unaligned_be32(len, &cdb[6]);
> +
> +	ret = scsi_execute_req(sdev, cdb,
> +			send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
> +			buffer, len, NULL, SD_TIMEOUT, SD_MAX_RETRIES, NULL);
> +	return ret <= 0 ? ret : -EIO;
> +}
> +#endif /* CONFIG_BLK_SED_OPAL */
> +
>  static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
>  					   unsigned int dix, unsigned int dif)
>  {
> @@ -1439,6 +1460,9 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
>  	if (error)
>  		goto out;
>  
> +	if (is_sed_ioctl(cmd))
> +		return sed_ioctl(sdkp->opal_dev, cmd, p);
> +
>  	/*
>  	 * Send SCSI addressing ioctls directly to mid level, send other
>  	 * ioctls to block level and then onto mid level if they can't be
> @@ -2994,6 +3018,20 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
>  		sdkp->ws10 = 1;
>  }
>  
> +static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
> +{
> +	struct scsi_device *sdev = sdkp->device;
> +
> +	if (!sdev->security_supported)
> +		return;
> +
> +	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
> +			SECURITY_PROTOCOL_IN) == 1 &&
> +	    scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
> +			SECURITY_PROTOCOL_OUT) == 1)
> +		sdkp->security = 1;
> +}
> +
>  /**
>   *	sd_revalidate_disk - called the first time a new disk is seen,
>   *	performs disk spin up, read_capacity, etc.
> @@ -3047,6 +3085,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		sd_read_cache_type(sdkp, buffer);
>  		sd_read_app_tag_own(sdkp, buffer);
>  		sd_read_write_same(sdkp, buffer);
> +		sd_read_security(sdkp, buffer);
>  	}
>  
>  	sdkp->first_scan = 0;
> @@ -3207,6 +3246,12 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>  
>  	sd_revalidate_disk(gd);
>  
> +	if (sdkp->security) {
> +		sdkp->opal_dev = init_opal_dev(sdp, &sd_sec_submit);
> +		if (sdkp->opal_dev)
> +			sd_printk(KERN_NOTICE, sdkp, "supports TCG Opal\n");
> +	}
> +
>  	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>  		  sdp->removable ? "removable " : "");
>  	scsi_autopm_put_device(sdp);
> @@ -3356,6 +3401,8 @@ static int sd_remove(struct device *dev)
>  
>  	sd_zbc_remove(sdkp);
>  
> +	free_opal_dev(sdkp->opal_dev);
> +
>  	blk_register_region(devt, SD_MINORS, NULL,
>  			    sd_default_probe, NULL, NULL);
>  
> @@ -3497,6 +3544,7 @@ static int sd_suspend_runtime(struct device *dev)
>  static int sd_resume(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	int ret;
>  
>  	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
>  		return 0;
> @@ -3505,7 +3553,10 @@ static int sd_resume(struct device *dev)
>  		return 0;
>  
>  	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> -	return sd_start_stop_device(sdkp, 1);
> +	ret = sd_start_stop_device(sdkp, 1);
> +	if (!ret)
> +		opal_unlock_from_suspend(sdkp->opal_dev);
> +	return ret;
>  }
>  
>  /**
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 61d02efd366c..99c4dde9b6bf 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -71,6 +71,7 @@ struct scsi_disk {
>  	struct scsi_device *device;
>  	struct device	dev;
>  	struct gendisk	*disk;
> +	struct opal_dev *opal_dev;
>  #ifdef CONFIG_BLK_DEV_ZONED
>  	unsigned int	nr_zones;
>  	unsigned int	zone_blocks;
> @@ -114,6 +115,7 @@ struct scsi_disk {
>  	unsigned	rc_basis: 2;
>  	unsigned	zoned: 2;
>  	unsigned	urswrz : 1;
> +	unsigned	security : 1;
>  	unsigned	ignore_medium_access_errors : 1;
>  };
>  #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 05641aebd181..310c86a892e9 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -176,6 +176,7 @@ struct scsi_device {
>  	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
>  	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
>  	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
> +	unsigned security_supported:1;	/* Supports Security Protocols */
>  	unsigned is_visible:1;	/* is the device visible in sysfs */
>  	unsigned wce_default_on:1;	/* Cache is ON by default */
>  	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
> -- 
> 2.11.0
---end quoted text---
