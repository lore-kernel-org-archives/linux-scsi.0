Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FCDC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 08:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F5F6124D
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 08:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352712AbhJAI2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 04:28:41 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:35647 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352723AbhJAI20 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Oct 2021 04:28:26 -0400
Received: from [192.168.0.3] (ip5f5aef40.dynamic.kabel-deutschland.de [95.90.239.64])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id E843E61E64846;
        Fri,  1 Oct 2021 10:26:20 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate device
 nodes for tape changers
To:     Don Brace <don.brace@microchip.com>
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, john.p.donnelly@oracle.com,
        mwilck@suse.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210928235442.201875-1-don.brace@microchip.com>
 <20210928235442.201875-10-don.brace@microchip.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <1351a25f-5310-cae3-ae47-01c842e0a185@molgen.mpg.de>
Date:   Fri, 1 Oct 2021 10:26:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928235442.201875-10-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Kevin, dear Don,


Am 29.09.21 um 01:54 schrieb Don Brace:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> Stop the OS from re-discovering multiple LUNs for
> tape drive and medium changer.
> 
> Duplicate device nodes for Ultrium tape drive and
> medium changer are being created.
> 
> The Ultrium tape drive is a multi-LUN SCSI target.
> It presents a LUN for the tape drive and a 2nd
> LUN for the medium changer.
> Our controller FW lists both LUNs in the RPL
> results.

Please document the firmware version (and controller) you tested with in 
the commit message.

> As a result, the smartpqi driver exposes both
> devices to the OS. Then the OS does its normal
> device discovery via the SCSI REPORT LUNS command,
> which causes it to re-discover both devices a 2nd time,
> which results in the duplicate device nodes.

Shortly describing the implementation (new struct member ignore_device) 
would be nice.

> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>   drivers/scsi/smartpqi/smartpqi.h      |  1 +
>   drivers/scsi/smartpqi/smartpqi_init.c | 23 +++++++++++++++++++----
>   2 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
> index c439583a4ca5..aac88ac0a0b7 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -1106,6 +1106,7 @@ struct pqi_scsi_dev {
>   	u8	keep_device : 1;
>   	u8	volume_offline : 1;
>   	u8	rescan : 1;
> +	u8	ignore_device : 1;

Why not type bool?

>   	bool	aio_enabled;		/* only valid for physical disks */
>   	bool	in_remove;
>   	bool	device_offline;
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index c28eb7ea4a24..8be116992cb0 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -6297,9 +6297,13 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
>   		rphy = target_to_rphy(starget);
>   		device = pqi_find_device_by_sas_rphy(ctrl_info, rphy);
>   		if (device) {
> -			device->target = sdev_id(sdev);
> -			device->lun = sdev->lun;
> -			device->target_lun_valid = true;

Off topic, with `u8 target_lun_valid : 1`, why is `true` used.

> +			if (device->target_lun_valid) {
> +				device->ignore_device = true;
> +			} else {
> +				device->target = sdev_id(sdev);
> +				device->lun = sdev->lun;
> +				device->target_lun_valid = true;
> +			}

If the LUN should be ignored, is it actually valid? Why not extend 
target_lun_valid and add a third option (enums?) to ignore it?

>   		}
>   	} else {
>   		device = pqi_find_scsi_dev(ctrl_info, sdev_channel(sdev),
> @@ -6336,14 +6340,25 @@ static int pqi_map_queues(struct Scsi_Host *shost)
>   					ctrl_info->pci_dev, 0);
>   }
>   
> +static inline bool pqi_is_tape_changer_device(struct pqi_scsi_dev *device)
> +{
> +	return device->devtype == TYPE_TAPE || device->devtype == TYPE_MEDIUM_CHANGER;

Why also check for TYPE_TAPE? The function name should be updated then?

> +}
> +
>   static int pqi_slave_configure(struct scsi_device *sdev)
>   {
> +	int rc = 0;
>   	struct pqi_scsi_dev *device;
>   
>   	device = sdev->hostdata;
>   	device->devtype = sdev->type;
>   
> -	return 0;
> +	if (pqi_is_tape_changer_device(device) && device->ignore_device) {
> +		rc = -ENXIO;
> +		device->ignore_device = false;

I’d add a `return -ENXIO` here, and remove the variable.

> +	}
> +
> +	return rc;
>   }
>   
>   static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
> 


Kind regards,

Paul
