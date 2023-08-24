Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A488C71153
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 18:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242954AbjHXS2v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 14:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243039AbjHXS2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 14:28:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C6519B0;
        Thu, 24 Aug 2023 11:28:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A2C064A6B;
        Thu, 24 Aug 2023 18:28:45 +0000 (UTC)
Received: from rdvivi-mobl4 (unknown [192.55.54.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.kernel.org (Postfix) with ESMTPSA id 9F73EC433C7;
        Thu, 24 Aug 2023 18:28:42 +0000 (UTC)
Date:   Thu, 24 Aug 2023 14:28:41 -0400
From:   Rodrigo Vivi <rodrigo.vivi@kernel.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Message-ID: <ZOehTysWO+U3mVvK@rdvivi-mobl4>
References: <20230731003956.572414-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731003956.572414-1-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 31, 2023 at 09:39:56AM +0900, Damien Le Moal wrote:
> During system resume, ata_port_pm_resume() triggers ata EH to
> 1) Resume the controller
> 2) Reset and rescan the ports
> 3) Revalidate devices
> This EH execution is started asynchronously from ata_port_pm_resume(),
> which means that when sd_resume() is executed, none or only part of the
> above processing may have been executed. However, sd_resume() issues a
> START STOP UNIT to wake up the drive from sleep mode. This command is
> translated to ATA with ata_scsi_start_stop_xlat() and issued to the
> device. However, depending on the state of execution of the EH process
> and revalidation triggerred by ata_port_pm_resume(), two things may
> happen:
> 1) The START STOP UNIT fails if it is received before the controller has
>    been reenabled at the beginning of the EH execution. This is visible
>    with error messages like:
> 
> ata10.00: device reported invalid CHS sector 0
> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
> sd 9:0:0:0: PM: failed to resume async: error -5
> 
> 2) The START STOP UNIT command is received while the EH process is
>    on-going, which mean that it is stopped and must wait for its
>    completion, at which point the command is rather useless as the drive
>    is already fully spun up already. This case results also in a
>    significant delay in sd_resume() which is observable by users as
>    the entire system resume completion is delayed.
> 
> Given that ATA devices will be woken up by libata activity on resume,
> sd_resume() has no need to issue a START STOP UNIT command, which solves
> the above mentioned problems. Do not issue this command by introducing
> the new scsi_device flag no_start_on_resume and setting this flag to 1
> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
> UNIT command only if this flag is not set.

Hi Damien,

Last week I noticed that a basic test in our validation started failing,
then I noticed that it was subsequent quick suspend and autoresume using
rtcwake that was problematic.

I couldn't collect any specific log that was pointing to some useful direction.
After a painful bisect I got to this patch. After reverting in from the
top of our tree, the tests are back to life.

The issue was that the subsequent quick suspend-resume (sometimes the
second, sometimes third or even sixth) was simply hanging the machine
in different points at Suspend.

So, maybe we have some kind of disks/configuration out there where this
start upon resume is needed? Maybe it is just a matter of timming to
ensure some firmware underneath is up and back to life?

Well, please let me know the best way to report this issue to you and what
kind of logs I should get.

Meanwhile if this ends up blocking our CI we can keep a revert in a
topic branch for CI.

Thanks,
Rodrigo.

> 
> Reported-by: Paul Ausbeck <paula@soe.ucsc.edu>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=215880
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-scsi.c  | 7 +++++++
>  drivers/scsi/sd.c          | 9 ++++++---
>  include/scsi/scsi_device.h | 1 +
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 370d18aca71e..c6ece32de8e3 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1100,7 +1100,14 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>  		}
>  	} else {
>  		sdev->sector_size = ata_id_logical_sector_size(dev->id);
> +		/*
> +		 * Stop the drive on suspend but do not issue START STOP UNIT
> +		 * on resume as this is not necessary and may fail: the device
> +		 * will be woken up by ata_port_pm_resume() with a port reset
> +		 * and device revalidation.
> +		 */
>  		sdev->manage_start_stop = 1;
> +		sdev->no_start_on_resume = 1;
>  	}
>  
>  	/*
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 68b12afa0721..3c668cfb146d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3876,7 +3876,7 @@ static int sd_suspend_runtime(struct device *dev)
>  static int sd_resume(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> -	int ret;
> +	int ret = 0;
>  
>  	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
>  		return 0;
> @@ -3884,8 +3884,11 @@ static int sd_resume(struct device *dev)
>  	if (!sdkp->device->manage_start_stop)
>  		return 0;
>  
> -	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> -	ret = sd_start_stop_device(sdkp, 1);
> +	if (!sdkp->device->no_start_on_resume) {
> +		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> +		ret = sd_start_stop_device(sdkp, 1);
> +	}
> +
>  	if (!ret)
>  		opal_unlock_from_suspend(sdkp->opal_dev);
>  	return ret;
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 75b2235b99e2..b9230b6add04 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -194,6 +194,7 @@ struct scsi_device {
>  	unsigned no_start_on_add:1;	/* do not issue start on add */
>  	unsigned allow_restart:1; /* issue START_UNIT in error handler */
>  	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
> +	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
>  	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
>  	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
>  	unsigned select_no_atn:1;
> -- 
> 2.41.0
> 
