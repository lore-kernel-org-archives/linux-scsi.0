Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43184C0032E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 01:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjJZBkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 21:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjJZBkw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 21:40:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE1810E;
        Wed, 25 Oct 2023 18:40:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83D0C433C7;
        Thu, 26 Oct 2023 01:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698284449;
        bh=xV4dskKAdTOZyvbM0N5+/6ry5IRBQzaUQY03ICjRXwg=;
        h=Date:Subject:From:To:References:In-Reply-To:From;
        b=NSp4QsDRlLyT3+Ll+52LsPl0ZZ9cR+ZE/8S9EhmBz0TWTzuIjwsUuX0b1JUDfDz9e
         /61BRTTLP7H4z9EfiRNaaNsTTomtFKqlpfGfV44XdHoODAGbEo4pokLKMQzdKmGW4G
         h0argLRp5dixcZjboJ49GkYR4zKacaDih4wAghNAVQVczVz4M6Zy1yZgcXkieDXALi
         SooVgXPmq7tYyLMXpEfpBX1l1s6k7KFfWOge0YZsc+Tt5DNQBod4u/ro961Sxa8AeO
         AZvVut+WayPaWydEXkOrJ2YShWv9LDhGwZEDTnvb+4DWxAlqP16lOW8f1zuHHsKMpr
         XeoMVqzg8B5ww==
Message-ID: <cd23574d-ed0c-47b8-83eb-7154c30e5827@kernel.org>
Date:   Thu, 26 Oct 2023 10:40:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sd: Introduce manage_shutdown device flag
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20231026013909.24301-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20231026013909.24301-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/23 10:39, Damien Le Moal wrote:
> Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
> manage_system_start_stop") change setting the manage_system_start_stop
> flag to false for libata managed disks to enable libata internal
> management of disk suspend/resume. However, a side effect of this change
> is that on system shutdown, disks are no longer being stopped (set to
> standby mode with the heads unloaded). While this is not a critical
> issue, this unclean shutdown is not recommended and shows up with
> increased smart counters (e.g. the unexpected power loss counter
> "Unexpect_Power_Loss_Ct").
> 
> Instead of defining a shutdown driver method for all ATA adapter
> drivers (not all of them define that operation), this patch resolves
> this issue by further refining the sd driver start/stop control of disks
> using the new flag manage_shutdown. If this new flag is set to true by
> a low level driver, the function sd_shutdown() will issue a
> START STOP UNIT command with the start argument set to 0 when a disk
> needs to be powered off (suspended) on system power off, that is, when
> system_state is equal to SYSTEM_POWER_OFF.
> 
> Similarly to the other manage_xxx flags, the new manage_shutdown flag is
> exposed through sysfs as a read-write device attribute.
> 
> To avoid any confusion between manage_shutdown and
> manage_system_start_stop, the comments describing these flags in
> include/scsi/scsi.h are also improved.
> 
> Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
> Cc: stable@vger.kernel.org
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218038
> Link: https://lore.kernel.org/all/cd397c88-bf53-4768-9ab8-9d107df9e613@gmail.com/
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

Oops... Forgot to add the changelog:

Changes from v1:
 - Improved flags description in include/scsi/scsi_device.h
 - Added missing sysfs export of manage_shutdown

>  drivers/ata/libata-scsi.c  |  5 +++--
>  drivers/firewire/sbp2.c    |  1 +
>  drivers/scsi/sd.c          | 39 +++++++++++++++++++++++++++++++++++---
>  include/scsi/scsi_device.h | 20 +++++++++++++++++--
>  4 files changed, 58 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index a371b497035e..3a957c4da409 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1053,10 +1053,11 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>  
>  		/*
>  		 * Ask the sd driver to issue START STOP UNIT on runtime suspend
> -		 * and resume only. For system level suspend/resume, devices
> -		 * power state is handled directly by libata EH.
> +		 * and resume and shutdown only. For system level suspend/resume,
> +		 * devices power state is handled directly by libata EH.
>  		 */
>  		sdev->manage_runtime_start_stop = true;
> +		sdev->manage_shutdown = true;
>  	}
>  
>  	/*
> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
> index 749868b9e80d..7edf2c95282f 100644
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -1521,6 +1521,7 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
>  	if (sbp2_param_exclusive_login) {
>  		sdev->manage_system_start_stop = true;
>  		sdev->manage_runtime_start_stop = true;
> +		sdev->manage_shutdown = true;
>  	}
>  
>  	if (sdev->type == TYPE_ROM)
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 83b6a3f3863b..6effa13039f3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -209,7 +209,8 @@ manage_start_stop_show(struct device *dev,
>  
>  	return sysfs_emit(buf, "%u\n",
>  			  sdp->manage_system_start_stop &&
> -			  sdp->manage_runtime_start_stop);
> +			  sdp->manage_runtime_start_stop &&
> +			  sdp->manage_shutdown);
>  }
>  static DEVICE_ATTR_RO(manage_start_stop);
>  
> @@ -275,6 +276,35 @@ manage_runtime_start_stop_store(struct device *dev,
>  }
>  static DEVICE_ATTR_RW(manage_runtime_start_stop);
>  
> +static ssize_t manage_shutdown_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +	struct scsi_device *sdp = sdkp->device;
> +
> +	return sysfs_emit(buf, "%u\n", sdp->manage_shutdown);
> +}
> +
> +static ssize_t manage_shutdown_store(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +	struct scsi_device *sdp = sdkp->device;
> +	bool v;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	if (kstrtobool(buf, &v))
> +		return -EINVAL;
> +
> +	sdp->manage_shutdown = v;
> +
> +	return count;
> +}
> +static DEVICE_ATTR_RW(manage_shutdown);
> +
>  static ssize_t
>  allow_restart_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> @@ -607,6 +637,7 @@ static struct attribute *sd_disk_attrs[] = {
>  	&dev_attr_manage_start_stop.attr,
>  	&dev_attr_manage_system_start_stop.attr,
>  	&dev_attr_manage_runtime_start_stop.attr,
> +	&dev_attr_manage_shutdown.attr,
>  	&dev_attr_protection_type.attr,
>  	&dev_attr_protection_mode.attr,
>  	&dev_attr_app_tag_own.attr,
> @@ -3819,8 +3850,10 @@ static void sd_shutdown(struct device *dev)
>  		sd_sync_cache(sdkp, NULL);
>  	}
>  
> -	if (system_state != SYSTEM_RESTART &&
> -	    sdkp->device->manage_system_start_stop) {
> +	if ((system_state != SYSTEM_RESTART &&
> +	     sdkp->device->manage_system_start_stop) ||
> +	    (system_state == SYSTEM_POWER_OFF &&
> +	     sdkp->device->manage_shutdown)) {
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index fd41fdac0a8e..d87bc57da8bf 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -162,8 +162,24 @@ struct scsi_device {
>  				 * core. */
>  	unsigned int eh_timeout; /* Error handling timeout */
>  
> -	bool manage_system_start_stop; /* Let HLD (sd) manage system start/stop */
> -	bool manage_runtime_start_stop; /* Let HLD (sd) manage runtime start/stop */
> +	/*
> +	 * If true, let the high-level device driver (sd) manage the device
> +	 * power state for system suspend/resume (suspend to RAM and
> +	 * hybernation) operations.
> +	 */
> +	bool manage_system_start_stop;
> +
> +	/*
> +	 * If true, let the high-level device driver (sd) manage the device
> +	 * power state for runtime device suspand and resume operations.
> +	 */
> +	bool manage_runtime_start_stop;
> +
> +	/*
> +	 * If true, let the high-level device driver (sd) manage the device
> +	 * power state for system shutdown (power off) operations.
> +	 */
> +	bool manage_shutdown;
>  
>  	unsigned removable:1;
>  	unsigned changed:1;	/* Data invalid due to media change */

-- 
Damien Le Moal
Western Digital Research

