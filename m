Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FF9C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 14:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbiC1OPT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 10:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241924AbiC1OPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 10:15:18 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C353F6258
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 07:13:34 -0700 (PDT)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KRvl22gvVz67NYP;
        Mon, 28 Mar 2022 22:11:42 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 28 Mar 2022 16:13:32 +0200
Received: from [10.47.83.59] (10.47.83.59) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 28 Mar
 2022 15:13:31 +0100
Message-ID: <4b891427-0bce-d672-f8ab-2b1572a0f553@huawei.com>
Date:   Mon, 28 Mar 2022 15:13:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 2/2] scsi: pm80xx: enable upper inbound, outbound queues
To:     Ajish Koshy <Ajish.Koshy@microchip.com>,
        <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
 <20220328084243.301493-3-Ajish.Koshy@microchip.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220328084243.301493-3-Ajish.Koshy@microchip.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.59]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/03/2022 09:42, Ajish Koshy wrote:
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
> ---


I'm not sure if this change was meant to help, but I still see timeouts 
on my 96-core arm64 machine with this change - see log at bottom.

I still get the feeling that this issue I mention is timing related, as 
it goes away when I enable lots of heavy debug (like kasan, kmemleak, 
prove_locking, etc.


>   drivers/scsi/pm8001/pm80xx_hwi.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index b92e82a576e3..f04c6c589615 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -766,6 +766,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>   	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
>   	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
>   
> +	/* Enable higher IQs and OQs, 32 to 63, bit 16*/
> +	if (pm8001_ha->max_q_num > 32)
> +		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
> +							(1 << 16);
>   	/* Disable end to end CRC checking */
>   	pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
>   
> @@ -1027,6 +1031,9 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>   	if (0x0000 != gst_len_mpistate)
>   		return -EBUSY;
>   
> +	/* Wait for 500ms after successful MPI initialization*/
> +	msleep(500);
> +
>   	return 0;
>   }
>   



  126.037932] EXT4-fs (sda1): recovery complete
[  126.042297] EXT4-fs (sda1): mounted filesystem with ordered data 
mode. Quota mode: none.
[  159.939179] sas: Enter sas_scsi_recover_host busy: 256 failed: 256
[  159.945390] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
[  181.862870] sas: TMF task timeout for 5000c500a7b95a49 and not done
[  193.436187] pm80xx0:: pm8001_abort_task 1126: rc= 5
[  193.436188] pm80xx0:: mpi_ssp_completion 1937: sas IO status 0x1
[  193.441064] sas: sas_scsi_find_task: querying task 0x(____ptrval____)
[  193.447048] pm80xx0:: mpi_ssp_completion 1948: SAS Address of IO 
Failure Drive:5000c500a7b95a49
[  193.453528] pm80xx0:: mpi_ssp_completion 1937: sas IO status 0x3b
[  193.462158] pm80xx0:: mpi_ssp_completion 2185: task 
0x(____ptrval____) done with io_status 0x1 resp 0x0 stat 0x8c but 
aborted by upper layer!
[  193.468237] pm80xx0:: mpi_ssp_completion 1948: SAS Address of IO 
Failure Drive:5000c500a7b95a49
[  193.489658] sas: TMF task open reject failed  5000c500a7b95a49
[  193.495538] pm80xx0:: mpi_ssp_completion 1937: sas IO status 0x3b
[  193.501619] pm80xx0:: mpi_ssp_completion 1948: SAS Address of IO 
Failure Drive:5000c500a7b95a49
[  193.510371] sas: TMF task open reject failed  5000c500a7b95a49
[  193.516252] pm80xx0:: mpi_ssp_completion 1937: sas IO status 0x3b
[  193.522333] pm80xx0:: mpi_ssp_completion 1948: SAS Address of IO 
Failure Drive:5000c500a7b95a49
[  193.531075] sas: TMF task open reject failed  5000c500a7b95a49
[  193.536899] sas: executing TMF for 5000c500a7b95a49 failed after 3 
attempts!
[  193.543937] pm80xx: rc= -5
[  193.546631] sas: sas_scsi_find_task: task 0x(____ptrval____) result 
code -5 not handled
[  193.554622] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
[  193.561052] sas: sas_eh_handle_sas_errors: task 0x(____ptrval____) is 
done
[  193.567917] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
ls'ing 0
[  214.630859] sas: TMF task timeout for 5000c500a7b95a49 and not done
[  226.241090] pm80xx0:: mpi_ssp_completion 1937: sas IO status 0x1
[  226.241093] pm80xx0:: pm8001_abort_task 1126: rc= 5
[  226.247084] pm80xx0:: mpi_ssp_completion 1948: SAS Address of IO 
Failure Drive:5000c500a7b95a49
[  226.247087] pm80xx0:: mpi_ssp_completion 2185: task 
0x(____ptrval____) done with io_status 0x1 resp 0x0 stat 0x8c but 
aborted by upper layer!
[  226.273324] sas: sas_eh_handle_sas_errors: task 0x(____ptrval____) is 
done
[  226.280188] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
[  247.398856] sas: TMF task timeout for 5000c500a7b95a49 and not done

