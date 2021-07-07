Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521ADC07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3918161CB9
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhGGHut (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 03:50:49 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44187 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230389AbhGGHus (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Jul 2021 03:50:48 -0400
Received: from [192.168.0.3] (ip5f5aedf7.dynamic.kabel-deutschland.de [95.90.237.247])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C661961E64860;
        Wed,  7 Jul 2021 09:48:07 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH 8/9] smartpqi: fix isr accessing null
 structure member
To:     Don Brace <don.brace@microchip.com>,
        Mike McGowen <mike.mcgowen@microchip.com>
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        murthy.bhat@microchip.com, balsundar.p@microchip.com,
        joseph.szczypek@hpe.com, jeff@canonical.com, POSWALD@suse.com,
        john.p.donnelly@oracle.com, mwilck@suse.com,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-9-don.brace@microchip.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <fa3b5d5a-fdd3-48c7-b8d5-1a732b09bf68@molgen.mpg.de>
Date:   Wed, 7 Jul 2021 09:48:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706181618.27960-9-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Don, dear Mike,


Am 06.07.21 um 20:16 schrieb Don Brace:
> From: Mike McGowen <mike.mcgowen@microchip.com>
> 
> Correct driver's ISR accessing a data structure member
> that has not been fully initialized during driver init.

Does that crash the Linux kernel?

>    - The pqi queue groups can be null when an interrupt fires.

If it fixes a crash(?), please add a Fixes: tag so it can be backported 
to the stable series.

> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 6f2263abaa8c..eeaf0568b5e3 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -7757,11 +7757,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
>   
>   	pqi_init_operational_queues(ctrl_info);
>   
> -	rc = pqi_request_irqs(ctrl_info);
> +	rc = pqi_create_queues(ctrl_info);

 From a quick look, these two functions are quite different. It’d be 
great if you elaborated a bit in the commit message, what else the new 
function does.

Also, with this change, `pqi_request_irqs()` does not seem to have any 
users anymore. Without your patch:

     $ git grep pqi_request_irqs
     drivers/scsi/smartpqi/smartpqi_init.c:static int 
pqi_request_irqs(struct pqi_ctrl_info *ctrl_info)
     drivers/scsi/smartpqi/smartpqi_init.c:  rc = 
pqi_request_irqs(ctrl_info);

>   	if (rc)
>   		return rc;
>   
> -	rc = pqi_create_queues(ctrl_info);
> +	rc = pqi_request_irqs(ctrl_info);
>   	if (rc)
>   		return rc;
> 


Kind regards,

Paul
