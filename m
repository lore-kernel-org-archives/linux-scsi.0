Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F266C04A94
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 05:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjGaFrl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 01:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjGaFrk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 01:47:40 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8DCE6A;
        Sun, 30 Jul 2023 22:47:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-686be3cbea0so3265892b3a.0;
        Sun, 30 Jul 2023 22:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690782459; x=1691387259;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bnbHGSU8lrzrC9186GVmYqCgD0re7sVgxixyQll5Jbc=;
        b=YbAcpuh/ZXMORf7Hbw9Sz/YAmZDzX5j0sFV1pYC0G1wWZKysbS1bFo5j8uHMNeXYhz
         syZDGCwmE1mq9fSbf3gA+2qAO+sJ0kyZjTNbnePqdzeqP1eCvc2p2x2syltFnzughzav
         7e4P/podsEXvwQSsNk/fJAjbm5VIugGFaLboanPMri3iSflLeIYZoc2Ybq3mwGoBff5g
         fgKwZ5FCI0kIHzBBXpd7IqM2SzsxMme6mrbXt38uvc7xZ3NhouU3O+bcffbXa/YgncGS
         ZgAnWcBMEmDviY/YL7oHt2utHZWgyiRDBPFfoH6bIfUXeO3bV96ttgxUPo9zmv+FrIcD
         GmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690782459; x=1691387259;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bnbHGSU8lrzrC9186GVmYqCgD0re7sVgxixyQll5Jbc=;
        b=HxARZrRn7x9k1I0PAbcNV6XbO1lO3HSMox1rKUTRjumlIn7+rqW3iFSola/Ser146r
         mRGlTrjVBi6jnU3FTS5RK23u6xX7deV6cwE+/z8uvsXRCQNGcfVR4BoQ8GSuoEQMVJN1
         Sx5LVmUICRSHnQDvDvBCEXo9QusgHdnBQXu0FNfVTUeg3+JGjq/usTbFk4HoFX0XDANl
         lvJhyrKN7iElyt/wO/FnGiA/T6VccRVzlESWWTZpHj3sSd+3JTSg173ivgN95YjIiDEh
         Vza1YU2xfZU+LSUAj4EPY1PVc14DeppZNKn8qHRKtINcF9aSIlIPNezyp3ZHQphnvFfO
         7jwQ==
X-Gm-Message-State: ABy/qLZqU4ZMKHynEkXZSyhfwzSM7BIokmT0pq7UCHF8zdq1fxopYHiy
        hDMIcu1Uhp8P/nEZlPWCV0HAHspwmS9d2A==
X-Google-Smtp-Source: APBJJlHHkim+Ci0qisJB3GWSy97z1wTzCMg4ZJjJ12khHS0ftAgMtuMt978X4ek9oq6RMMdwEjXtuA==
X-Received: by 2002:a17:90a:318c:b0:267:f1d7:ed68 with SMTP id j12-20020a17090a318c00b00267f1d7ed68mr10165154pjb.14.1690782459136;
        Sun, 30 Jul 2023 22:47:39 -0700 (PDT)
Received: from [192.168.1.121] ([65.129.146.152])
        by smtp.gmail.com with ESMTPSA id 29-20020a17090a1a5d00b0025c2c398d33sm6070659pjl.39.2023.07.30.22.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jul 2023 22:47:38 -0700 (PDT)
Message-ID: <487f7bf7-6aa5-b435-e529-af195f13a34c@gmail.com>
Date:   Sun, 30 Jul 2023 23:47:38 -0600
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
From:   Tanner Watkins <dalzot@gmail.com>
In-Reply-To: <20230731003956.572414-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

Tested-by: Tanner Watkins<dalzot@gmail.com>

