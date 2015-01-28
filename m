From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Date: Wed, 28 Jan 2015 10:23:53 +0100
Message-ID: <54C8AAA9.7060300@sandisk.com>
References: <1421600146.2080.8.camel@HansenPartnership.com>
	 <54BC93C3.7010808@hitachi.com> <878ugzco8c.fsf@rustcorp.com.au>
	 <1421683701.2080.25.camel@HansenPartnership.com>
	 <871tmqcmau.fsf@rustcorp.com.au>
	 <1421774615.2080.88.camel@HansenPartnership.com>
	 <20150122165018.GA27377@infradead.org>
	 <1421946175.2093.1.camel@HansenPartnership.com>
	 <87iofyurzc.fsf@rustcorp.com.au> <20150123131758.GC8045@infradead.org>
 <1422038567.2126.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0089.outbound.protection.outlook.com ([207.46.100.89]:1920
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932259AbbA1U7W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2015 15:59:22 -0500
In-Reply-To: <1422038567.2126.14.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 01/23/15 19:42, James Bottomley wrote:
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 08c90a7..31ba254 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -965,6 +965,15 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
>  }
>  EXPORT_SYMBOL(scsi_report_opcode);
>  
> +static int __scsi_device_get_common(struct scsi_device *sdev)
> +{
> +	if (sdev->sdev_state == SDEV_DEL)
> +		return -ENXIO;
> +	if (!get_device(&sdev->sdev_gendev))
> +		return -ENXIO;
> +	return 0;
> +}
> +
>  /**
>   * scsi_device_get  -  get an additional reference to a scsi_device
>   * @sdev:	device to get a reference to
> @@ -975,19 +984,45 @@ EXPORT_SYMBOL(scsi_report_opcode);
>   */
>  int scsi_device_get(struct scsi_device *sdev)
>  {
> -	if (sdev->sdev_state == SDEV_DEL)
> -		return -ENXIO;
> -	if (!get_device(&sdev->sdev_gendev))
> -		return -ENXIO;
> -	/* We can fail this if we're doing SCSI operations
> -	 * from module exit (like cache flush) */
> -	try_module_get(sdev->host->hostt->module);
> +	int ret;
>  
> -	return 0;
> +	ret = __scsi_device_get_common(sdev);
> +	if (ret)
> +		return ret;
> +
> +	ret = try_module_get(sdev->host->hostt->module);
> +
> +	if (ret)
> +		put_device(&sdev->sdev_gendev);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(scsi_device_get);
>  
>  /**
> + * scsi_device_get_in_module_exit() - get an additional reference to a scsi_device
> + * @sdev:	device to get a reference to
> + *
> + * Functions identically to scsi_device_get() except that it unconditionally
> + * gets the module reference.  This allows it to be called from module exit
> + * routines where scsi_device_get() will fail.  This routine is still paired
> + * with scsi_device_put().
> + */
> +int scsi_device_get_in_module_exit(struct scsi_device *sdev)
> +{
> +	int ret;
> +
> +	ret = __scsi_device_get_common(sdev);
> +	if (ret)
> +		return ret;
> +
> +	__module_get(sdev->host->hostt->module);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(scsi_device_get_in_module_exit);
> +
> +/**
>   * scsi_device_put  -  release a reference to a scsi_device
>   * @sdev:	device to release a reference on.
>   *
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ebf35cb6..057604e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -564,16 +564,22 @@ static int sd_major(int major_idx)
>  	}
>  }
>  
> -static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
> +static struct scsi_disk *__scsi_disk_get(struct gendisk *disk, int in_exit)
>  {
>  	struct scsi_disk *sdkp = NULL;
>  
>  	if (disk->private_data) {
> +		int ret;
> +
>  		sdkp = scsi_disk(disk);
> -		if (scsi_device_get(sdkp->device) == 0)
> -			get_device(&sdkp->dev);
> +		if (in_exit)
> +			ret = scsi_device_get_in_module_exit(sdkp->device);
>  		else
> +			ret = scsi_device_get(sdkp->device);
> +		if (unlikely(ret))
>  			sdkp = NULL;
> +		else
> +			get_device(&sdkp->dev);
>  	}
>  	return sdkp;
>  }
> @@ -583,19 +589,19 @@ static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
>  	struct scsi_disk *sdkp;
>  
>  	mutex_lock(&sd_ref_mutex);
> -	sdkp = __scsi_disk_get(disk);
> +	sdkp = __scsi_disk_get(disk, 0);
>  	mutex_unlock(&sd_ref_mutex);
>  	return sdkp;
>  }
>  
> -static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev)
> +static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev, int in_exit)
>  {
>  	struct scsi_disk *sdkp;
>  
>  	mutex_lock(&sd_ref_mutex);
>  	sdkp = dev_get_drvdata(dev);
>  	if (sdkp)
> -		sdkp = __scsi_disk_get(sdkp->disk);
> +		sdkp = __scsi_disk_get(sdkp->disk, in_exit);
>  	mutex_unlock(&sd_ref_mutex);
>  	return sdkp;
>  }
> @@ -1525,7 +1531,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  
>  static void sd_rescan(struct device *dev)
>  {
> -	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> +	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 0);
>  
>  	if (sdkp) {
>  		revalidate_disk(sdkp->disk);
> @@ -3147,7 +3153,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>   */
>  static void sd_shutdown(struct device *dev)
>  {
> -	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> +	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 1);
>  
>  	if (!sdkp)
>  		return;         /* this can happen */
> @@ -3171,7 +3177,7 @@ exit:
>  
>  static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>  {
> -	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> +	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 0);
>  	int ret = 0;
>  
>  	if (!sdkp)
> @@ -3213,7 +3219,7 @@ static int sd_suspend_runtime(struct device *dev)
>  
>  static int sd_resume(struct device *dev)
>  {
> -	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> +	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 0);
>  	int ret = 0;
>  
>  	if (!sdkp->device->manage_start_stop)
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 2e0281e..0bad37c 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -327,6 +327,7 @@ extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
>  void scsi_attach_vpd(struct scsi_device *sdev);
>  
>  extern int scsi_device_get(struct scsi_device *);
> +extern int scsi_device_get_in_module_exit(struct scsi_device *);
>  extern void scsi_device_put(struct scsi_device *);
>  extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
>  					      uint, uint, u64);

Hello James,

Is this the latest version of this patch that is available ? I have
tried to test the above patch. However, I couldn't test the impact of
this patch on the SRP initiator driver since my test system didn't boot
anymore with the above patch applied. That test system boots from an ATA
disk managed by the SCSI subsystem:
$ lsscsi | head -n1
[0:0:0:0]    disk    ATA      KINGSTON SH103S3 BBF0  /dev/sda

Thanks,

Bart.
