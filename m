Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1435FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 08:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiDHIZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiDHIZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 04:25:45 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344F915E883
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 01:23:42 -0700 (PDT)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KZWRz0MGrz67NMl;
        Fri,  8 Apr 2022 16:21:35 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Fri, 8 Apr 2022 10:23:40 +0200
Received: from [10.47.91.39] (10.47.91.39) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 8 Apr
 2022 09:23:39 +0100
Message-ID: <45a4bb6d-7a09-b576-c68d-9981434b4b2a@huawei.com>
Date:   Fri, 8 Apr 2022 09:23:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v3 1/2] scsi: pm80xx: mask and unmask upper interrupt
 vectors 32-63
To:     Ajish Koshy <Ajish.Koshy@microchip.com>,
        <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20220408080538.278707-1-Ajish.Koshy@microchip.com>
 <20220408080538.278707-2-Ajish.Koshy@microchip.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220408080538.278707-2-Ajish.Koshy@microchip.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.39]
X-ClientProxiedBy: lhreml718-chm.china.huawei.com (10.201.108.69) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/04/2022 09:05, Ajish Koshy wrote:
> When upper inbound and outbound queues 32-63 are enabled, we see upper
> vectors 32-63 in interrupt service routine. We need corresponding
> registers to handle masking and unmasking of these upper interrupts.
> 
> To achieve this, we use registers MSGU_ODMR_U(0x34) to mask and
> MSGU_ODMR_CLR_U(0x3C) to unmask the interrupts. In these registers bit
> 0-31 represents interrupt vectors 32-63.
> 
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")

Regardless of nitpick:
Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/pm8001/pm80xx_hwi.c | 30 ++++++++++++++++++++----------
>   1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 9bb31f66db85..cdb31679f419 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1727,10 +1727,14 @@ static void
>   pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)

comment on current code: using u8 for vec seems dubious

>   {
>   #ifdef PM8001_USE_MSIX
> -	u32 mask;
> -	mask = (u32)(1 << vec);
> -
> -	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
> +	if (vec < 32) {
> +		/* vectors 0 - 31 */

nit: I doubt the use of these sort of comments. I mean, a check for vec 
< 32 makes it pretty obvious

> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, 1U << vec);
> +	} else {
> +		/* vectors 32 - 63 */
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
> +			    1U << (vec - 32));
> +	}
>   	return;
>   #endif
>   	pm80xx_chip_intx_interrupt_enable(pm8001_ha);
> @@ -1746,12 +1750,18 @@ static void
>   pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>   {
>   #ifdef PM8001_USE_MSIX
> -	u32 mask;
> -	if (vec == 0xFF)
> -		mask = 0xFFFFFFFF;
> -	else
> -		mask = (u32)(1 << vec);
> -	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
> +	if (vec == 0xFF) {
> +		/* disable all vectors 0-31, 32-63 */
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 0xFFFFFFFF);
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, 0xFFFFFFFF);
> +	} else if (vec < 32) {
> +		/* vectors 0 - 31 */
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 1U << vec);
> +	} else {
> +		/* vectors 32 - 63 */
> +		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
> +			    1U << (vec - 32));
> +	}
>   	return;
>   #endif
>   	pm80xx_chip_intx_interrupt_disable(pm8001_ha);

