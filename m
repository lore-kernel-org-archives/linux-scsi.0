Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80132C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 674BE61CAA
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhGGHjp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 03:39:45 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:39637 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230349AbhGGHjp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Jul 2021 03:39:45 -0400
Received: from [192.168.0.3] (ip5f5aedf7.dynamic.kabel-deutschland.de [95.90.237.247])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0EADA61E64860;
        Wed,  7 Jul 2021 09:37:04 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH 4/9] smartpqi: add SCSI cmd info for
 resets
To:     Don Brace <don.brace@microchip.com>, murthy.bhat@microchip.com
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, balsundar.p@microchip.com,
        joseph.szczypek@hpe.com, jeff@canonical.com, POSWALD@suse.com,
        john.p.donnelly@oracle.com, mwilck@suse.com,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-5-don.brace@microchip.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <02a04074-255a-bf7f-0925-7d4be9c7ab8e@molgen.mpg.de>
Date:   Wed, 7 Jul 2021 09:37:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706181618.27960-5-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Murthy, dear Don,


Am 06.07.21 um 20:16 schrieb Don Brace:
> From: Murthy Bhat <Murthy.Bhat@microchip.com>
> 
> Report on SCSI command that has triggered the reset.
>   - Also add check for 0 length SCSI commands.

Can you please add an example log message line to the git commit message 
summary?


Kind regards,

Paul


> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 5ce1c41a758d..c2ddb66b5c2d 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -6033,8 +6033,10 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
>   	mutex_lock(&ctrl_info->lun_reset_mutex);
>   
>   	dev_err(&ctrl_info->pci_dev->dev,
> -		"resetting scsi %d:%d:%d:%d\n",
> -		shost->host_no, device->bus, device->target, device->lun);
> +		"resetting scsi %d:%d:%d:%d due to cmd 0x%02x\n",
> +		shost->host_no,
> +		device->bus, device->target, device->lun,
> +		scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff);
>   
>   	pqi_check_ctrl_health(ctrl_info);
>   	if (pqi_ctrl_offline(ctrl_info))
> 
