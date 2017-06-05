From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH 6/6] sd: add support for TCG OPAL self encrypting disks
Date: Mon, 5 Jun 2017 15:15:31 -0600
Message-ID: <20170605211530.aqxwigcrxgsdvmhs@sbauer-Z170X-UD5>
References: <20170604124225.27032-1-hch@lst.de>
 <20170604124225.27032-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170604124225.27032-7-hch@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 04, 2017 at 02:42:25PM +0200, Christoph Hellwig wrote:
> Just wire up the generic TCG OPAL infrastructure to the SCSI disk driver
> and the Security In/Out commands.
> 
> Note that I don't know of any actual SCSI disks that do support TCG OPAL,
> but this is required to support ATA disks through libata.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/sd.h |  2 ++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b6bb4e0ce0e3..782f909a223c 100644
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
> @@ -1454,6 +1475,9 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
>  	if (error)
>  		goto out;
>  
> +	if (is_sed_ioctl(cmd))
> +		return sed_ioctl(sdkp->opal_dev, cmd, p);
> +
>  	/*
>  	 * Send SCSI addressing ioctls directly to mid level, send other
>  	 * ioctls to block level and then onto mid level if they can't be
> @@ -3014,6 +3038,17 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
>  		sdkp->ws10 = 1;
>  }
>  
> +static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
> +{
> +	struct scsi_device *sdev = sdkp->device;
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
> @@ -3067,6 +3102,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		sd_read_cache_type(sdkp, buffer);
>  		sd_read_app_tag_own(sdkp, buffer);
>  		sd_read_write_same(sdkp, buffer);
> +		sd_read_security(sdkp, buffer);
>  	}
>  
>  	sdkp->first_scan = 0;
> @@ -3227,6 +3263,12 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>  
>  	sd_revalidate_disk(gd);
>  
> +	if (sdkp->security) {
> +		sdkp->opal_dev = init_opal_dev(sdp, &sd_sec_submit);
> +		if (sdkp->opal_dev)
> +			sd_printk(KERN_NOTICE, sdkp, "supports TCG Opal\n");
> +	}
> +
> 
I'm not familiar at all with ATA, but I noticed there was no unlock from suspend support
in the series. Does ATA not have a way to determine if we're coming out of a suspend?

I see there are some power-ops in scsi/sd.c, if you do want to add it you can mabe toss a

if (sdkp->security)
   opal_unlock_from_suspend(sdpk->opal_dev)

somewhere in the resume path? We handle null opal_devs and no unlock from suspend list
so calling it when nothing is set up is just a no-op.
