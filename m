Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16ECAC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 14:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243068AbiBJOnG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:43:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243024AbiBJOnF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 09:43:05 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B42C4D
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 06:43:05 -0800 (PST)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jvfbb1rHTz67tGk;
        Thu, 10 Feb 2022 22:42:19 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 15:43:04 +0100
Received: from [10.202.227.197] (10.202.227.197) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 14:43:03 +0000
Message-ID: <1c2e2f32-2a6f-3bff-73ad-6764c5062ba5@huawei.com>
Date:   Thu, 10 Feb 2022 14:43:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 10/20] scsi: pm8001: fix payload initialization in
 pm80xx_set_thermal_config()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-11-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220210114218.632725-11-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.197]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2022 11:42, Damien Le Moal wrote:
> The fields of the set_ctrl_cfg_req structure have the __le32 type, so
> use cpu_to_le32() to assign them. This removes the sparse warnings:
> 
> warning: incorrect type in assignment (different base types)
>      expected restricted __le32
>      got unsigned int
> 
> Fixes: 842784e0d15b ("pm80xx: Update For Thermal Page Code")
> Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware functionalities and relevant changes in common files")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


Reviewed-by: John Garry <john.garry@huawei.com>


> ---
>   drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 37ede7c79e85..9c7383fb4bdc 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1202,9 +1202,11 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
>   	else
>   		page_code = THERMAL_PAGE_CODE_8H;
>   
> -	payload.cfg_pg[0] = (THERMAL_LOG_ENABLE << 9) |
> -				(THERMAL_ENABLE << 8) | page_code;
> -	payload.cfg_pg[1] = (LTEMPHIL << 24) | (RTEMPHIL << 8);
> +	payload.cfg_pg[0] =
> +		cpu_to_le32((THERMAL_LOG_ENABLE << 9) |
> +			    (THERMAL_ENABLE << 8) | page_code);
> +	payload.cfg_pg[1] =
> +		cpu_to_le32((LTEMPHIL << 24) | (RTEMPHIL << 8));
>   
>   	pm8001_dbg(pm8001_ha, DEV,
>   		   "Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",

