Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9108C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 08:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiDHIVg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiDHIVg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 04:21:36 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002887245C
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 01:19:31 -0700 (PDT)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KZWMP1l9tz67xBN;
        Fri,  8 Apr 2022 16:17:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Fri, 8 Apr 2022 10:19:28 +0200
Received: from [10.47.91.39] (10.47.91.39) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 8 Apr
 2022 09:19:28 +0100
Message-ID: <67ca3648-38b5-86b0-9503-17a2eff8d7dd@huawei.com>
Date:   Fri, 8 Apr 2022 09:19:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v3 2/2] scsi: pm80xx: enable upper inbound, outbound
 queues
To:     Ajish Koshy <Ajish.Koshy@microchip.com>,
        <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20220408080538.278707-1-Ajish.Koshy@microchip.com>
 <20220408080538.278707-3-Ajish.Koshy@microchip.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220408080538.278707-3-Ajish.Koshy@microchip.com>
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
> Executing driver on servers with more than 32 CPUs were faced with command
> timeouts. This is because we were not geting completions for commands
> submitted on IQ32 - IQ63.
> 
> Set E64Q bit to enable upper inbound and outbound queues 32 to 63 in the
> MPI main configuration table.
> 
> Added 500ms delay after successful MPI initialization as mentioned in
> controller datasheet.
> 
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>   drivers/scsi/pm8001/pm80xx_hwi.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index cdb31679f419..71b6cc4b9420 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -766,6 +766,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>   	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
>   	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
>   
> +	/* Enable higher IQs and OQs, 32 to 63, bit 16 */
> +	if (pm8001_ha->max_q_num > 32)
> +		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
> +							1 << 16;
>   	/* Disable end to end CRC checking */
>   	pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
>   
> @@ -1027,6 +1031,8 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>   	if (0x0000 != gst_len_mpistate)
>   		return -EBUSY;
>   
> +	msleep(500);

Personally I think you should mention where this 500ms value comes from 
  (the datasheet), as it is not arbitrary

The change looks ok apart from that

> +
>   	return 0;
>   }
>   

