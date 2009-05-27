From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 23/24] mpt fusion: [2.6.30-rc6]  Module parameters to
	change queue depth for FC,SPI,SAS
Date: Wed, 27 May 2009 19:37:45 +0000
Message-ID: <1243453065.6067.59.camel@localhost.localdomain>
References: <20090522111147.GQ16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50185 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521AbZE0Thp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 15:37:45 -0400
In-Reply-To: <20090522111147.GQ16331@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-22 at 16:41 +0530, Kashyap, Desai wrote:
> 1. Unused mptscsih_timer_expired() function is removed.
> 2. Module parameter mpt_sdev_queue_depth to support different queue depth for different Buses (FC/SPI/SAS).

There's no need for a module parameter since there's already a device
parameter to set.

> 3. changed driver versiont to 3.04.11.
> ---
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
> index 1c8514d..44ef2a0 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -76,8 +76,8 @@
>  #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
>  #endif
>  
> -#define MPT_LINUX_VERSION_COMMON	"3.04.10"
> -#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.09"
> +#define MPT_LINUX_VERSION_COMMON	"3.04.11"
> +#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.11"
>  #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
>  
>  #define show_mptmod_ver(s,ver)  \
> @@ -157,8 +157,9 @@
>  /*
>   *	Try to keep these at 2^N-1
>   */
> -#define MPT_FC_CAN_QUEUE	127
> +#define MPT_FC_CAN_QUEUE	1024
>  #define MPT_SCSI_CAN_QUEUE	127
> +#define MPT_SAS_CAN_QUEUE	127
>  
>  /*
>   * Set the MAX_SGE value based on user input.
> @@ -757,6 +758,7 @@ typedef struct _MPT_ADAPTER
>  
>  	struct scsi_cmnd	**ScsiLookup;
>  	spinlock_t		  scsi_lookup_lock;
> +	int			  sdev_queue_depth;	/* sdev queue depth */
>  	u64			dma_mask;
>  	u32			  broadcast_aen_busy;
>  	char			 reset_work_q_name[MPT_KOBJ_NAME_LEN];
> diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
> index e61df13..1a3975c 100644
> --- a/drivers/message/fusion/mptfc.c
> +++ b/drivers/message/fusion/mptfc.c
> @@ -84,6 +84,14 @@ MODULE_PARM_DESC(mptfc_dev_loss_tmo, " Initial time the driver programs the "
>  				     " return following a device loss event."
>  				     "  Default=60.");
>  
> +static int mpt_sdev_queue_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
> +static int mptfc_set_sdev_queue_depth(const char *val, struct kernel_param *kp);
> +module_param_call(mpt_sdev_queue_depth, mptfc_set_sdev_queue_depth,
> +    param_get_int,  &mpt_sdev_queue_depth, 0600);
> +MODULE_PARM_DESC(mpt_sdev_queue_depth,
> +    " Max Device Queue Depth (default="
> +    __MODULE_STRING(MPT_SCSI_CMD_PER_DEV_HIGH) ")");
> +
>  /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
>  #define MPTFC_MAX_LUN (16895)
>  static int max_lun = MPTFC_MAX_LUN;
> @@ -183,6 +191,34 @@ static struct fc_function_template mptfc_transport_functions = {
>  	.show_host_symbolic_name = 1,
>  };
>  
> +/**
> + *	mptfc_set_sdev_queue_depth - global setting of the mpt_sdev_queue_depth
> + *	found via /sys/module/mptfc/parameters/mpt_sdev_queue_depth
> + *	@val:
> + *	@kp:

This is the wrong thing to do.  You'd give the driver two separate queue
depth knobs (under the device and under the module).  Please just use
the one under the device for feeding in set parameters otherwise it will
only end up confusing users.   The fixed limits are supposed to reflect
hardware, not some random number a user can feed in via the module
parameters ... otherwise there's not much point having fixed limits.

James


