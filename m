Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD05EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 03:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjGaDsk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Jul 2023 23:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjGaDsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jul 2023 23:48:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD10C194;
        Sun, 30 Jul 2023 20:48:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bb81809ca8so32271795ad.3;
        Sun, 30 Jul 2023 20:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690775315; x=1691380115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NtvygU/z1y3wTthGw51ELSQ5NZ4rAc6sckIpCAnR/EA=;
        b=IPq/zdroTjGnIcnYK/wupfll2KvSO6uGpJZh0wNiPoMTwaSJJpaW5aWAw0YfV/E52N
         lsqz+FhDSfFlU2z+V6xUUB2GfQnvnAJZVfKlL5ZOerX8LKfGmn09RPofiuQOsvJH9IhW
         ZlO9oE4BZUPvoupTHTZ7LlA4RWHJUxg+Oec+MUQO5Z//RR5v9bVAuZbHTWteSSXnDBuR
         6/zmD3gng9cGOxqiFA6Ml5Zlmuq/OxfdJ5pB4xBqrQ+hDm9B52lUS0IcA+zYhyDBtcGs
         aFZDPJA3OTlrJVecPp8IvrbHrIlRke12w4m8O9bNY8zyBD+vfSxu948ELdj8jAJr44NY
         WDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690775315; x=1691380115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NtvygU/z1y3wTthGw51ELSQ5NZ4rAc6sckIpCAnR/EA=;
        b=cIxEsoYYNFR/6FoWR+cOibNpZ+In2TuIpIrt1mlJoFrK1Sli3qIYyAe9kvdfkmTIe1
         Q9ErEEUQJQTYl2D896oZEW7DKfTCKMn00zG0HhQKPrGXQV1Ubpe09qSYde9W3HUUBnpZ
         iygbJ0yeJGTRys/mtb7FKj46/tOEOgek9EOdotM7i7CoyxIkgJVypQG/fz8aXzXRJo1a
         ujAjwRoq/rkBMQ3vryi9nRP6TiFQzC4fh2/RgATa4k+HLl8BnX1DqkZ/iP4/tZYnd01Q
         EUF8ciAnFnNTS2r5rAtfmPXwCrgIsvQQiYO/WR40U1gTuCuWYHkRtlUtI5b/+Nf/02oD
         Rvlw==
X-Gm-Message-State: ABy/qLbRGSdmGY36iPHWMWSG6rst6chrmoO3E7ldy9CdzHuG93JXk/xd
        vpCTmC+1Dp95Xba4I290fYo=
X-Google-Smtp-Source: APBJJlGq7/xZ3PujiPxnBE9HK3jpP+P6WlUu8u/fupYFHVhjQ0EECzgORfY3JHnrO8dgfz83C8j9uA==
X-Received: by 2002:a17:902:ceca:b0:1bb:97d0:c628 with SMTP id d10-20020a170902ceca00b001bb97d0c628mr10422762plg.31.1690775315104;
        Sun, 30 Jul 2023 20:48:35 -0700 (PDT)
Received: from [192.168.1.121] ([65.129.146.152])
        by smtp.gmail.com with ESMTPSA id ix13-20020a170902f80d00b001b9d7c8f44dsm7325338plb.182.2023.07.30.20.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jul 2023 20:48:34 -0700 (PDT)
Message-ID: <92782079-140a-3581-797e-e5bf0c464d53@gmail.com>
Date:   Sun, 30 Jul 2023 21:48:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        regressions@lists.linux.dev, Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
From:   TW <dalzot@gmail.com>
In-Reply-To: <20230731003956.572414-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tested-by: Tanner Watkins

On 7/30/23 18:39, Damien Le Moal wrote:
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
>     been reenabled at the beginning of the EH execution. This is visible
>     with error messages like:
>
> ata10.00: device reported invalid CHS sector 0
> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
> sd 9:0:0:0: PM: failed to resume async: error -5
>
> 2) The START STOP UNIT command is received while the EH process is
>     on-going, which mean that it is stopped and must wait for its
>     completion, at which point the command is rather useless as the drive
>     is already fully spun up already. This case results also in a
>     significant delay in sd_resume() which is observable by users as
>     the entire system resume completion is delayed.
>
> Given that ATA devices will be woken up by libata activity on resume,
> sd_resume() has no need to issue a START STOP UNIT command, which solves
> the above mentioned problems. Do not issue this command by introducing
> the new scsi_device flag no_start_on_resume and setting this flag to 1
> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
> UNIT command only if this flag is not set.
>
> Reported-by: Paul Ausbeck <paula@soe.ucsc.edu>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=215880
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-scsi.c  | 7 +++++++
>   drivers/scsi/sd.c          | 9 ++++++---
>   include/scsi/scsi_device.h | 1 +
>   3 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 370d18aca71e..c6ece32de8e3 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1100,7 +1100,14 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>   		}
>   	} else {
>   		sdev->sector_size = ata_id_logical_sector_size(dev->id);
> +		/*
> +		 * Stop the drive on suspend but do not issue START STOP UNIT
> +		 * on resume as this is not necessary and may fail: the device
> +		 * will be woken up by ata_port_pm_resume() with a port reset
> +		 * and device revalidation.
> +		 */
>   		sdev->manage_start_stop = 1;
> +		sdev->no_start_on_resume = 1;
>   	}
>   
>   	/*
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 68b12afa0721..3c668cfb146d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3876,7 +3876,7 @@ static int sd_suspend_runtime(struct device *dev)
>   static int sd_resume(struct device *dev)
>   {
>   	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> -	int ret;
> +	int ret = 0;
>   
>   	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
>   		return 0;
> @@ -3884,8 +3884,11 @@ static int sd_resume(struct device *dev)
>   	if (!sdkp->device->manage_start_stop)
>   		return 0;
>   
> -	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> -	ret = sd_start_stop_device(sdkp, 1);
> +	if (!sdkp->device->no_start_on_resume) {
> +		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> +		ret = sd_start_stop_device(sdkp, 1);
> +	}
> +
>   	if (!ret)
>   		opal_unlock_from_suspend(sdkp->opal_dev);
>   	return ret;
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 75b2235b99e2..b9230b6add04 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -194,6 +194,7 @@ struct scsi_device {
>   	unsigned no_start_on_add:1;	/* do not issue start on add */
>   	unsigned allow_restart:1; /* issue START_UNIT in error handler */
>   	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
> +	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
>   	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
>   	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
>   	unsigned select_no_atn:1;
