Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDB2C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 18:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354630AbiBNSCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 13:02:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238598AbiBNSCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 13:02:44 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BB44DF73
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 10:02:36 -0800 (PST)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JyBqq5HRrz67N27;
        Tue, 15 Feb 2022 02:01:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 19:02:34 +0100
Received: from [10.47.81.62] (10.47.81.62) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Mon, 14 Feb
 2022 18:02:33 +0000
Message-ID: <bba9c2e3-84c9-618e-f098-bb7c3a7dad10@huawei.com>
Date:   Mon, 14 Feb 2022 18:02:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 17/31] scsi: pm8001: Fix pm8001_tag_alloc() failures
 handling
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-18-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220214021747.4976-18-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.62]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/02/2022 02:17, Damien Le Moal wrote:
> In mpi_set_phy_profile_req() and in pm8001_set_phy_profile_single(), if
> pm8001_tag_alloc() fails to allocate a new tag, a warning message is
> issued but the uninitialized tag variable is still used to build a
> command. Avoid this by returning early in case of tag allocation
> failure.
> 
> Also make sure to always return the error code returned by
> pm8001_tag_alloc() when this function fails instead of an arbitrary
> value.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/pm8001/pm80xx_hwi.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 413b01cc2a84..b0b6dc643916 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1191,7 +1191,7 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
>   	memset(&payload, 0, sizeof(struct set_ctrl_cfg_req));
>   	rc = pm8001_tag_alloc(pm8001_ha, &tag);
>   	if (rc)
> -		return -1;
> +		return rc;
>   
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   	payload.tag = cpu_to_le32(tag);
> @@ -1240,7 +1240,7 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_hba_info *pm8001_ha)

jfyi, please note this:
https://lore.kernel.org/linux-scsi/PH0PR11MB5112D8C17D9EA268C197893FEC579@PH0PR11MB5112.namprd11.prod.outlook.com/

>   	rc = pm8001_tag_alloc(pm8001_ha, &tag);
>   
>   	if (rc)
> -		return -1;
> +		return rc;
>   
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   	payload.tag = cpu_to_le32(tag);
> @@ -1398,7 +1398,7 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
>   	memset(&payload, 0, sizeof(struct kek_mgmt_req));
>   	rc = pm8001_tag_alloc(pm8001_ha, &tag);
>   	if (rc)
> -		return -1;
> +		return rc;
>   
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   	payload.tag = cpu_to_le32(tag);
> @@ -4979,8 +4979,11 @@ static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
>   
>   	memset(&payload, 0, sizeof(payload));
>   	rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -	if (rc)
> +	if (rc) {
>   		pm8001_dbg(pm8001_ha, FAIL, "Invalid tag\n");

ha - it was originally just continuing regardless

> +		return;
> +	}
> +
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   	payload.tag = cpu_to_le32(tag);
>   	payload.ppc_phyid =
> @@ -5022,8 +5025,10 @@ void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
>   	memset(&payload, 0, sizeof(payload));
>   
>   	rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -	if (rc)

and here

> +	if (rc) {
>   		pm8001_dbg(pm8001_ha, INIT, "Invalid tag\n");
> +		return;
> +	}
>   
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   	opc = OPC_INB_SET_PHY_PROFILE;

