From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Tue, 20 Mar 2007 13:58:55 -0400
Message-ID: <460020DF.6090203@torque.net>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45595 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbXCTR7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 13:59:34 -0400
In-Reply-To: <20070320151359.GG6152@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br

Tejun Heo wrote:
> Implement SBC START/STOP management.  sdev->mange_start_stop is added.
> When it's set to one, sd STOPs the device on suspend and shutdown and
> STARTs it on resume.  sdev->manage_start_stop defaults is in sdev
> instead of scsi_disk cdev to allow ->slave_config() override the
> default configuration but is exported under scsi_disk sysfs node as
> sdev->allow_restart is.
> 
> When manage_start_stop is zero (the default value), this patch doesn't
> introduce any behavior change.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  drivers/scsi/scsi_sysfs.c  |   31 +++++++++++--
>  drivers/scsi/sd.c          |  102 +++++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/scsi_device.h |    1 
>  3 files changed, 130 insertions(+), 4 deletions(-)
> 
> Index: work/drivers/scsi/sd.c
> ===================================================================
> --- work.orig/drivers/scsi/sd.c
> +++ work/drivers/scsi/sd.c
> @@ -142,6 +142,8 @@ static void sd_rw_intr(struct scsi_cmnd 
>  static int sd_probe(struct device *);
>  static int sd_remove(struct device *);
>  static void sd_shutdown(struct device *dev);
> +static int sd_suspend(struct device *dev, pm_message_t state);
> +static int sd_resume(struct device *dev);
>  static void sd_rescan(struct device *);
>  static int sd_init_command(struct scsi_cmnd *);
>  static int sd_issue_flush(struct device *, sector_t *);
> @@ -206,6 +208,20 @@ static ssize_t sd_store_cache_type(struc
>  	return count;
>  }
>  
> +static ssize_t sd_store_manage_start_stop(struct class_device *cdev,
> +					  const char *buf, size_t count)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(cdev);
> +	struct scsi_device *sdp = sdkp->device;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	sdp->manage_start_stop = simple_strtoul(buf, NULL, 10);
> +
> +	return count;
> +}
> +
>  static ssize_t sd_store_allow_restart(struct class_device *cdev, const char *buf,
>  				      size_t count)
>  {
> @@ -238,6 +254,14 @@ static ssize_t sd_show_fua(struct class_
>  	return snprintf(buf, 20, "%u\n", sdkp->DPOFUA);
>  }
>  
> +static ssize_t sd_show_manage_start_stop(struct class_device *cdev, char *buf)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(cdev);
> +	struct scsi_device *sdp = sdkp->device;
> +
> +	return snprintf(buf, 20, "%u\n", sdp->manage_start_stop);
> +}
> +
>  static ssize_t sd_show_allow_restart(struct class_device *cdev, char *buf)
>  {
>  	struct scsi_disk *sdkp = to_scsi_disk(cdev);
> @@ -251,6 +275,8 @@ static struct class_device_attribute sd_
>  	__ATTR(FUA, S_IRUGO, sd_show_fua, NULL),
>  	__ATTR(allow_restart, S_IRUGO|S_IWUSR, sd_show_allow_restart,
>  	       sd_store_allow_restart),
> +	__ATTR(manage_start_stop, S_IRUGO|S_IWUSR, sd_show_manage_start_stop,
> +	       sd_store_manage_start_stop),
>  	__ATTR_NULL,
>  };
>  
> @@ -267,6 +293,8 @@ static struct scsi_driver sd_template = 
>  		.name		= "sd",
>  		.probe		= sd_probe,
>  		.remove		= sd_remove,
> +		.suspend	= sd_suspend,
> +		.resume		= sd_resume,
>  		.shutdown	= sd_shutdown,
>  	},
>  	.rescan			= sd_rescan,
> @@ -1776,6 +1804,32 @@ static void scsi_disk_release(struct cla
>  	kfree(sdkp);
>  }
>  
> +static int sd_start_stop_device(struct scsi_device *sdp, int start)
> +{
> +	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
> +	struct scsi_sense_hdr sshdr;
> +	int res;
> +
> +	if (start)
> +		cmd[4] |= 1;	/* START */
> +
> +	if (!scsi_device_online(sdp))
> +		return -ENODEV;
> +
> +	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
> +			       SD_TIMEOUT, SD_MAX_RETRIES);

Tejun,
I note at this point that the IMMED bit in the
START STOP UNIT cdb is clear. [The code might
note that as well.] All SCSI disks that I have
seen, implement the IMMED bit and according to
the SAT standard, so should SAT layers like the
one in libata.

With the IMMED bit clear:
  - on spin up, it will wait until disk is ready.
    Okay unless there are a lot of disks, in
    which case we could ask Matthew Wilcox for help
  - on spin down, will wait until media is
    stopped. That could be 20 seconds, and if there
    were multiple disks ....

I guess the question is do we need to wait until a
disk is spun down before dropping power to it
and suspending.

Doug Gilbert
