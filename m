From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 5 of 8] sd: Detect non-rotational devices
Date: Thu, 23 Apr 2009 12:52:45 +0200
Message-ID: <20090423105245.GX4593@kernel.dk>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <d14109aa6209be628074.1240464572@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:37750 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZDWKwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 06:52:46 -0400
Content-Disposition: inline
In-Reply-To: <d14109aa6209be628074.1240464572@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 23 2009, Martin K. Petersen wrote:
> Detect non-rotational devices and set the queue flag accordingly.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 1 file changed, 27 insertions(+)
> drivers/scsi/sd.c |   27 +++++++++++++++++++++++++++
> 
> 
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -50,6 +50,7 @@
>  #include <linux/string_helpers.h>
>  #include <linux/async.h>
>  #include <asm/uaccess.h>
> +#include <asm/unaligned.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -1800,6 +1801,29 @@ void sd_read_app_tag_own(struct scsi_dis
>  }
>  
>  /**
> + * sd_read_block_characteristics - Query block dev. characteristics
> + * @disk: disk to query
> + */
> +static void sd_read_block_characteristics(struct scsi_disk *sdkp)
> +{
> +	char *buffer;
> +	u16 rot;
> +
> +	/* Block Device Characteristics VPD */
> +	buffer = scsi_get_vpd_page(sdkp->device, 0xb1);
> +
> +	if (buffer == NULL)
> +		return;
> +
> +	rot = get_unaligned_be16(&buffer[4]);
> +
> +	if (rot == 1)
> +		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
> +
> +	kfree(buffer);
> +}
> +
> +/**
>   *	sd_revalidate_disk - called the first time a new disk is seen,
>   *	performs disk spin up, read_capacity, etc.
>   *	@disk: struct gendisk we care about
> @@ -1836,6 +1860,7 @@ static int sd_revalidate_disk(struct gen
>  	 */
>  	if (sdkp->media_present) {
>  		sd_read_capacity(sdkp, buffer);
> +		sd_read_block_characteristics(sdkp);
>  		sd_read_write_protect_flag(sdkp, buffer);
>  		sd_read_cache_type(sdkp, buffer);
>  		sd_read_app_tag_own(sdkp, buffer);
> @@ -1976,6 +2001,8 @@ static void sd_probe_async(void *data, a
>  	add_disk(gd);
>  	sd_dif_config_host(sdkp);
>  
> +	sd_revalidate_disk(gd);
> +
>  	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>  		  sdp->removable ? "removable " : "");

Make sure this works for libata as well, and then kill the rotational
check in there instead.

-- 
Jens Axboe

