Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6407FC25B6B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 07:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjJYHOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 03:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjJYHOP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 03:14:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DE6A6;
        Wed, 25 Oct 2023 00:14:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C593CC433C8;
        Wed, 25 Oct 2023 07:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698218053;
        bh=OxoegwDjjcXGEmDTaeEr/nEcNAoGJw4tKo8BVx9eoXE=;
        h=Date:Subject:From:To:References:In-Reply-To:From;
        b=WM/c9hJYciR5CKdncHdCKw3cNwDBW2CCVP3+wRFk6YOsXTnrAMFR7wdBnaaa3toIc
         jsf/8dOXybBkXr9oRTLhEyhO5Uuq2gnkjGiMryfTuTtm3m4LgauW/kZsh8fIIns8OZ
         UXOQiPv7f2nBXzAUjCNppwjYJdIwQ9U1oTUI3tLKu8ePs5IxOifviyDTUi/DSR5ArO
         OMAyNIwURqgKF4yyRs/PFiJT+TOKlsin41r5Zpis0hAz8IuiU5f24x7vPwERZAxbOo
         9ayZMIMcYS/iJNfKxEYxvgYrp4PPf+l1Qxl5zn0QZ79w5F951tbUZ9y4p4UaUSA2Gy
         dA3YVTCFLx2/g==
Message-ID: <0717b6c1-3aab-4ce1-89d5-7c83f30cc995@kernel.org>
Date:   Wed, 25 Oct 2023 16:14:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Introduce manage_shutdown device flag
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20231025070117.464903-1-dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231025070117.464903-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/23 16:01, Damien Le Moal wrote:
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
> using the new flag manage_shutdown. If set to true, the function
> sd_shutdown() will issue a START STOP UNIT command with the start
> argument set to 0 when a disk is shutdown on system power off
> (system_state == SYSTEM_POWER_OFF).
> 
> Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
> Cc: stable@vger.kernel.org
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218038
> Link: https://lore.kernel.org/all/cd397c88-bf53-4768-9ab8-9d107df9e613@gmail.com/
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Martin,

I can take this patch through libata fixes branch if you prefer (as I suspect it
may not apply to your tree without rebasing first).

> ---
>  drivers/ata/libata-scsi.c  | 5 +++--
>  drivers/firewire/sbp2.c    | 1 +
>  drivers/scsi/sd.c          | 6 ++++--
>  include/scsi/scsi_device.h | 1 +
>  4 files changed, 9 insertions(+), 4 deletions(-)
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
> index 83b6a3f3863b..52fa266d976f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3819,8 +3819,10 @@ static void sd_shutdown(struct device *dev)
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
> index fd41fdac0a8e..7edefb73bf69 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -164,6 +164,7 @@ struct scsi_device {
>  
>  	bool manage_system_start_stop; /* Let HLD (sd) manage system start/stop */
>  	bool manage_runtime_start_stop; /* Let HLD (sd) manage runtime start/stop */
> +	bool manage_shutdown;	/* Let HLD (sd) manage shutdown */
>  
>  	unsigned removable:1;
>  	unsigned changed:1;	/* Data invalid due to media change */

-- 
Damien Le Moal
Western Digital Research

