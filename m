From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] SCSI: Handle disk devices which can not process medium
 access commands
Date: Sun, 12 Feb 2012 18:35:35 +0100
Message-ID: <4F37F867.5030204@fastmail.fm>
References: <yq1r4y3n8q2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33031 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257Ab2BLRfj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2012 12:35:39 -0500
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id A88CE20E62
	for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2012 12:35:38 -0500 (EST)
In-Reply-To: <yq1r4y3n8q2.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com

Thanks, those patches are actually urgently needed and I would recommend
to also push them back to stable kernels.
I reported such issues back in 2007

> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12517.html

which was with parallel scsi. Just today it happened again on system
with SSD drives.
Actually I even wrote similar patches, but I'm not sure if I ever
published those, as all other scsi patches I wrote back that time had
been rejected...


Thanks,
Bernd

On 02/09/2012 07:48 PM, Martin K. Petersen wrote:
> 
> We have experienced several devices which fail in a fashion we do not
> currently handle gracefully in SCSI. After a failure these devices will
> respond to the SCSI primary command set (INQUIRY, TEST UNIT READY, etc.)
> but any command accessing the storage medium will time out.
> 
> The following patch adds an callback that can be used by upper level
> drivers to inspect the results of an error handling command. This in
> turn has been used to implement additional checking in the SCSI disk
> driver.
> 
> If a medium access command fails twice but TEST UNIT READY succeeds both
> times in the subsequent error handling we will offline the device. The
> maximum number of failed commands required to take a device offline can
> be tweaked in sysfs.
> 
> Also add a new error flag to scsi_debug which allows this scenario to be
> easily reproduced.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 2aeb2e9..07322ec 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -782,12 +782,6 @@ static void scsi_done(struct scsi_cmnd *cmd)
>  	blk_complete_request(cmd->request);
>  }
>  
> -/* Move this to a header if it becomes more generally useful */
> -static struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
> -{
> -	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
> -}
> -
>  /**
>   * scsi_finish_command - cleanup and pass command back to upper layer
>   * @cmd: the command
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 6888b2c..e2ef165 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -126,6 +126,7 @@ static const char * scsi_debug_version_date = "20100324";
>  #define SCSI_DEBUG_OPT_TRANSPORT_ERR   16
>  #define SCSI_DEBUG_OPT_DIF_ERR   32
>  #define SCSI_DEBUG_OPT_DIX_ERR   64
> +#define SCSI_DEBUG_OPT_MAC_TIMEOUT  128
>  /* When "every_nth" > 0 then modulo "every_nth" commands:
>   *   - a no response is simulated if SCSI_DEBUG_OPT_TIMEOUT is set
>   *   - a RECOVERED_ERROR is simulated on successful read and write
> @@ -3615,6 +3616,9 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
>  			scsi_debug_every_nth = -1;
>  		if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
>  			return 0; /* ignore command causing timeout */
> +		else if (SCSI_DEBUG_OPT_MAC_TIMEOUT & scsi_debug_opts &&
> +			 scsi_medium_access_command(SCpnt))
> +			return 0; /* time out reads and writes */
>  		else if (SCSI_DEBUG_OPT_RECOVERED_ERR & scsi_debug_opts)
>  			inj_recovered = 1; /* to reads and writes below */
>  		else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & scsi_debug_opts)
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 5f84a14..d0c5958 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -30,6 +30,7 @@
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_device.h>
> +#include <scsi/scsi_driver.h>
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_transport.h>
>  #include <scsi/scsi_host.h>
> @@ -141,11 +142,11 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>  	else if (host->hostt->eh_timed_out)
>  		rtn = host->hostt->eh_timed_out(scmd);
>  
> +	scmd->result |= DID_TIME_OUT << 16;
> +
>  	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
> -		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
> -		scmd->result |= DID_TIME_OUT << 16;
> +		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
>  		rtn = BLK_EH_HANDLED;
> -	}
>  
>  	return rtn;
>  }
> @@ -770,6 +771,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  			     int cmnd_size, int timeout, unsigned sense_bytes)
>  {
>  	struct scsi_device *sdev = scmd->device;
> +	struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>  	struct Scsi_Host *shost = sdev->host;
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	unsigned long timeleft;
> @@ -824,6 +826,10 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  	}
>  
>  	scsi_eh_restore_cmnd(scmd, &ses);
> +
> +	if (sdrv->eh_action)
> +		rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
> +
>  	return rtn;
>  }
>  
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c691fb5..f9a2ed1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -107,6 +107,7 @@ static int sd_suspend(struct device *, pm_message_t state);
>  static int sd_resume(struct device *);
>  static void sd_rescan(struct device *);
>  static int sd_done(struct scsi_cmnd *);
> +static int sd_eh_action(struct scsi_cmnd *, unsigned char *, int, int);
>  static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
>  static void scsi_disk_release(struct device *cdev);
>  static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
> @@ -346,6 +347,30 @@ sd_store_provisioning_mode(struct device *dev, struct device_attribute *attr,
>  	return count;
>  }
>  
> +static ssize_t
> +sd_show_max_medium_access_timeouts(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +
> +	return snprintf(buf, 20, "%u\n", sdkp->max_medium_access_timeouts);
> +}
> +
> +static ssize_t
> +sd_store_max_medium_access_timeouts(struct device *dev,
> +				    struct device_attribute *attr,
> +				    const char *buf, size_t count)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	sdkp->max_medium_access_timeouts = simple_strtoul(buf, NULL, 10);
> +
> +	return count;
> +}
> +
>  static struct device_attribute sd_disk_attrs[] = {
>  	__ATTR(cache_type, S_IRUGO|S_IWUSR, sd_show_cache_type,
>  	       sd_store_cache_type),
> @@ -360,6 +385,9 @@ static struct device_attribute sd_disk_attrs[] = {
>  	__ATTR(thin_provisioning, S_IRUGO, sd_show_thin_provisioning, NULL),
>  	__ATTR(provisioning_mode, S_IRUGO|S_IWUSR, sd_show_provisioning_mode,
>  	       sd_store_provisioning_mode),
> +	__ATTR(max_medium_access_timeouts, S_IRUGO|S_IWUSR,
> +	       sd_show_max_medium_access_timeouts,
> +	       sd_store_max_medium_access_timeouts),
>  	__ATTR_NULL,
>  };
>  
> @@ -382,6 +410,7 @@ static struct scsi_driver sd_template = {
>  	},
>  	.rescan			= sd_rescan,
>  	.done			= sd_done,
> +	.eh_action		= sd_eh_action,
>  };
>  
>  /*
> @@ -1313,6 +1342,55 @@ static const struct block_device_operations sd_fops = {
>  	.unlock_native_capacity	= sd_unlock_native_capacity,
>  };
>  
> +/**
> + *	sd_eh_action - error handling callback
> + *	@scmd:		sd-issued command that has failed
> + *	@eh_cmnd:	The command that was sent during error handling
> + *	@eh_cmnd_len:	Length of eh_cmnd in bytes
> + *	@eh_disp:	The recovery disposition suggested by the midlayer
> + *
> + *	This function is called by the SCSI midlayer upon completion of
> + *	an error handling command (TEST UNIT READY, START STOP UNIT,
> + *	etc.) The command sent to the device by the error handler is
> + *	stored in eh_cmnd. The result of sending the eh command is
> + *	passed in eh_disp.
> + **/
> +static int sd_eh_action(struct scsi_cmnd *scmd, unsigned char *eh_cmnd,
> +			int eh_cmnd_len, int eh_disp)
> +{
> +	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
> +
> +	if (!scsi_device_online(scmd->device) ||
> +	    !scsi_medium_access_command(scmd))
> +		return eh_disp;
> +
> +	/*
> +	 * The device has timed out executing a medium access command.
> +	 * However, the TEST UNIT READY command sent during error
> +	 * handling completed successfully. Either the device is in the
> +	 * process of recovering or has it suffered an internal failure
> +	 * that prevents access to the storage medium.
> +	 */
> +	if (host_byte(scmd->result) == DID_TIME_OUT && eh_disp == SUCCESS &&
> +	    eh_cmnd_len && eh_cmnd[0] == TEST_UNIT_READY)
> +		sdkp->medium_access_timed_out++;
> +
> +	/*
> +	 * If the device keeps failing read/write commands but TEST UNIT
> +	 * READY always completes successfully we assume that medium
> +	 * access is no longer possible and take the device offline.
> +	 */
> +	if (sdkp->medium_access_timed_out >= sdkp->max_medium_access_timeouts) {
> +		scmd_printk(KERN_ERR, scmd,
> +			    "Medium access timeout failure. Offlining disk!\n");
> +		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
> +
> +		return FAILED;
> +	}
> +
> +	return eh_disp;
> +}
> +
>  static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
>  {
>  	u64 start_lba = blk_rq_pos(scmd->request);
> @@ -1402,6 +1480,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  	    (!sense_valid || sense_deferred))
>  		goto out;
>  
> +	sdkp->medium_access_timed_out = 0;
> +
>  	switch (sshdr.sense_key) {
>  	case HARDWARE_ERROR:
>  	case MEDIUM_ERROR:
> @@ -2523,6 +2603,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>  	sdkp->RCD = 0;
>  	sdkp->ATO = 0;
>  	sdkp->first_scan = 1;
> +	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
>  
>  	sd_revalidate_disk(gd);
>  
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 4163f29..f703f48 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -20,6 +20,7 @@
>   */
>  #define SD_MAX_RETRIES		5
>  #define SD_PASSTHROUGH_RETRIES	1
> +#define SD_MAX_MEDIUM_TIMEOUTS	2
>  
>  /*
>   * Size of the initial data buffer for mode and read capacity data
> @@ -59,6 +60,8 @@ struct scsi_disk {
>  	u32		unmap_alignment;
>  	u32		index;
>  	unsigned int	physical_block_size;
> +	unsigned int	max_medium_access_timeouts;
> +	unsigned int	medium_access_timed_out;
>  	u8		media_present;
>  	u8		write_prot;
>  	u8		protection_type;/* Data Integrity Field */
> @@ -88,6 +91,38 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
>  		    (sdsk)->disk->disk_name, ##a) :			\
>  	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
>  
> +static inline int scsi_medium_access_command(struct scsi_cmnd *scmd)
> +{
> +	switch (scmd->cmnd[0]) {
> +	case READ_6:
> +	case READ_10:
> +	case READ_12:
> +	case READ_16:
> +	case SYNCHRONIZE_CACHE:
> +	case VERIFY:
> +	case VERIFY_12:
> +	case VERIFY_16:
> +	case WRITE_6:
> +	case WRITE_10:
> +	case WRITE_12:
> +	case WRITE_16:
> +	case WRITE_SAME:
> +	case WRITE_SAME_16:
> +	case UNMAP:
> +		return 1;
> +	case VARIABLE_LENGTH_CMD:
> +		switch (scmd->cmnd[9]) {
> +		case READ_32:
> +		case VERIFY_32:
> +		case WRITE_32:
> +		case WRITE_SAME_32:
> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * A DIF-capable target device can be formatted with different
>   * protection schemes.  Currently 0 through 3 are defined:
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index a5e885a..0392641 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -10,6 +10,7 @@
>  
>  struct Scsi_Host;
>  struct scsi_device;
> +struct scsi_driver;
>  
>  /*
>   * MAX_COMMAND_SIZE is:
> @@ -131,6 +132,11 @@ struct scsi_cmnd {
>  	unsigned char tag;	/* SCSI-II queued command tag */
>  };
>  
> +static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
> +{
> +	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
> +}
> +
>  extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
>  extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
>  extern void scsi_put_command(struct scsi_cmnd *);
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index 9fd6702..d443aa0 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -16,6 +16,7 @@ struct scsi_driver {
>  
>  	void (*rescan)(struct device *);
>  	int (*done)(struct scsi_cmnd *);
> +	int (*eh_action)(struct scsi_cmnd *, unsigned char *, int, int);
>  };
>  #define to_scsi_driver(drv) \
>  	container_of((drv), struct scsi_driver, gendrv)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

