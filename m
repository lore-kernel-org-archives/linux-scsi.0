Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4D2C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B6B61CBB
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhGGHb3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 03:31:29 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37745 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230341AbhGGHb2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Jul 2021 03:31:28 -0400
Received: from [192.168.0.3] (ip5f5aedf7.dynamic.kabel-deutschland.de [95.90.237.247])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DC32561E64860;
        Wed,  7 Jul 2021 09:28:46 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH 2/9] smartpqi: rm unsupported controller
 features msgs
To:     Don Brace <don.brace@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>
Cc:     scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, mike.mcgowen@microchip.com,
        murthy.bhat@microchip.com, balsundar.p@microchip.com,
        joseph.szczypek@hpe.com, jeff@canonical.com, POSWALD@suse.com,
        john.p.donnelly@oracle.com, mwilck@suse.com,
        linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-3-don.brace@microchip.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <17eeaf22-4625-d733-dcfb-ec2322dd0ca6@molgen.mpg.de>
Date:   Wed, 7 Jul 2021 09:28:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706181618.27960-3-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Kevin, dear Don,


Am 06.07.21 um 20:16 schrieb Don Brace:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> Remove "Feature XYZ not supported by controller" messages.
> 
> During driver initialization, the driver examines the PQI Table Feature bits.
> These bits are used by the controller to advertise features supported by the
> controller. For any features not supported by the controller, the driver would
> display a message in the form:
>          "Feature XYZ not supported by controller"
> Some of these "negative" messages were causing customer confusion.

As it’s info log level and not warning or notice, these message are 
useful in my opinion. You could downgrade them to debug, but I do not 
see why. If customers do not want to see these info messages, they 
should filter them out.

For completeness, is there an alternative to list the unsupported 
features from the firmware for example from sysfs?


Kind regards,

Paul


> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index d977c7b30d5c..7958316841a4 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -7255,11 +7255,8 @@ struct pqi_firmware_feature {
>   static void pqi_firmware_feature_status(struct pqi_ctrl_info *ctrl_info,
>   	struct pqi_firmware_feature *firmware_feature)
>   {
> -	if (!firmware_feature->supported) {
> -		dev_info(&ctrl_info->pci_dev->dev, "%s not supported by controller\n",
> -			firmware_feature->feature_name);
> +	if (!firmware_feature->supported)
>   		return;
> -	}
>   
>   	if (firmware_feature->enabled) {
>   		dev_info(&ctrl_info->pci_dev->dev,
> 
