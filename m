From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
Date: Sun, 05 Feb 2012 16:05:48 +0400
Message-ID: <4F2E709C.5060000@mvista.com>
References: <1328273954-5010-1-git-send-email-amit.sahrawat83@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1328273954-5010-1-git-send-email-amit.sahrawat83@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 03-02-2012 16:59, Amit Sahrawat wrote:

> It has been observed that a number of USB HDD's do not respond correctly

    Why are you working around this in libata-scsi.c then if it's USB HDD?

> to SCSI mode sense command(retrieve caching pages) which results in their
> Write Cache being discarded by queue requests i.e., WCE if left set to
> '0'(disabled).
> This results in a number of Filesystem corruptions, when the device
> is unplugged abruptly.

> So, in order to identify the devices correctly - give it
> a last try using ATA_16 after failure from normal routine.

    Shouldn't this be done in drivers/usb/storage somewhere?

> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>

[...]

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 508a60b..d5b00e6 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -562,6 +562,57 @@ error:
>   }
>
>   /**
> + *      ata_get_cachestatus - Handler for to get WriteCache Status
> + *                      using ATA_16 scsi command
> + *      @scsidev: Device to which we are issuing command
> + *
> + *      LOCKING:
> + *      Defined by the SCSI layer.  We don't really care.
> + *
> + *      RETURNS:
> + *      '0' for Write Cache Disabled and on any error.
> + *      '1' for Write Cache enabled
> + */
> +int ata_get_cachestatus(struct scsi_device *scsidev)
> +{
> +	int rc = 0;
> +	u8 scsi_cmd[MAX_COMMAND_SIZE] = {0};
> +	u8 *sensebuf = NULL, *argbuf = NULL;

    No need to initialize them.

> +	enum dma_data_direction data_dir;
> +
> +	sensebuf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
> +	if (!sensebuf)
> +		return rc;
> +
> +	argbuf = kmalloc(ATA_SECT_SIZE, GFP_KERNEL);
> +	if (argbuf == NULL)

    Could you use an uniform NULL-check, either '!x' or 'x == NULL'?

> +		goto error;
> +
> +	scsi_cmd[0] = ATA_16;
> +	scsi_cmd[1]  = (4<<  1); /* PIO Data-in */
> +	scsi_cmd[2]  = 0x0e;     /* no off.line or cc, read from dev,
> +				block count in sector count field */
> +	data_dir = DMA_FROM_DEVICE;
> +	scsi_cmd[14] = ATA_IDENTIFY_DEV;
> +
> +	if (!scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, ATA_SECT_SIZE,
> +				sensebuf, (10*HZ), 5, 0, NULL)) {
> +		/*
> +		 * '6th' Bit in Word 85 Corresponds to Write Cache

    No need for apostrophes here.

> +		 * being Enabled/disabled, Word 85 represnets the
> +		 * features supported
> +		 */
> +		if (le16_to_cpu(((unsigned short *)argbuf)[85])&  0x20)
> +			rc = 1;
> +	}
> +
> +error:
> +	kfree(sensebuf);
> +	kfree(argbuf);
> +	return rc;
> +}
> +
> +/**
>    *	ata_task_ioctl - Handler for HDIO_DRIVE_TASK ioctl
>    *	@scsidev: Device to which we are issuing command
>    *	@arg: User provided data for issuing command
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c691fb5..a6b887d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -50,6 +50,11 @@
>   #include<linux/string_helpers.h>
>   #include<linux/async.h>
>   #include<linux/slab.h>
> +
> +#ifdef CONFIG_ATA

    #ifdef not necessary here.

> +#include<linux/libata.h>
> +#endif
> +
>   #include<linux/pm_runtime.h>
>   #include<asm/uaccess.h>
>   #include<asm/unaligned.h>
> @@ -2129,7 +2134,11 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>   		if (modepage == 0x3F) {
>   			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
>   				  "present\n");
> +#ifdef CONFIG_ATA
> +			goto WCE_USING_ATA;

    Yikes.

> +#else
>   			goto defaults;
> +#endif
>   		} else if ((buffer[offset]&  0x3f) != modepage) {
>   			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
>   			goto defaults;
> @@ -2149,6 +2158,14 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>   				  "Uses READ/WRITE(6), disabling FUA\n");
>   			sdkp->DPOFUA = 0;
>   		}
> +#ifdef CONFIG_ATA
> +WCE_USING_ATA:
> +		if (!sdp->removable && !sdkp->WCE) {
> +			sd_printk(KERN_NOTICE, sdkp, "Try to check write cache "
> +				"enable/disable using ATA command\n");
> +			sdkp->WCE = ata_get_cachestatus(sdp);
> +		}
> +#endif
>
>   		if (sdkp->first_scan || old_wce != sdkp->WCE ||
>   		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index cafc09a..33fc73f 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -84,6 +84,8 @@
>   	}							\
>   })
>
> +#define ATA_IDENTIFY_DEV	0xEC
> +

    This is alerady #defined in <linux/ata.h> as ATA_CMD_ID_ATA.

MBR, Sergei
